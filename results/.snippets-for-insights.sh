#!/bin/bash
#
# some script snippets showing examples how to crawl through sbc-bench results collection

# check some results for memory performance (4 x ODROID XU4 here):
# for i in 1ixL 1iWL 1iLy 3GnC ; do echo -e "\n$(head -n1 $i.txt)" ; egrep '^ standard |    131072 |   4194304 |  67108864 ' $i.txt ; done

CPUUtilization7ZIP() {
	# function that takes sbc-bench results in working directory ending with *.txt 
	# and parses them for 7-zip CPU utilization. Result is a markdown table
	echo "| Device | comp single | decomp single | comp multi | decomp multi |"
	echo "| ----: | :----: | :----: | :----: | :----: |"
	for file in *.txt ; do
		Title="$(head -n1 "${file}" | sed -e 's/sbc-bench //' -e 's/Hardkernel //' -e 's/Xunlong //' -e 's/Raspberry Pi/RPi/' -e 's/ Model //' -e 's/\ (/(/' | cut -f1 -d'(')"
		case ${Title} in
			"v0.4 "*|*"  : "*|"Distributor ID:"*|*AMD*|*Intel*)
				# too old, skip
				:
				;;
			*)
				CPUs=$(awk -F" " '/CPU hardware threads: / {print $9}' <"${file}" | head -n1)
				SinglePercentageComp=$(awk -F" " '/^Avr:/ {print $2}' <"${file}" | head -n1)
				[ ${SinglePercentageComp:-0} -gt 100 ] && SinglePercentageComp="-"
				SinglePercentageDecomp=$(awk -F" " '/^Avr:/ {print $6}' <"${file}" | head -n1)
				[ ${SinglePercentageDecomp:-0} -gt 100 ] && SinglePercentageDecomp="-"
				if [ ${CPUs} -eq 1 ]; then
					MultiPercentageComp="-"
					MultiPercentageDecomp="-"
				else
					CountofAverageScores=$(grep -c '^Avr:' "${file}")
					if [ ${CountofAverageScores} -lt 4 ]; then
						# something went wrong while benchmarking
						MultiPercentageComp="-"
						MultiPercentageDecomp="-"
					else
						# take last 3 7-zip scores
						RawComp=$(grep '^Avr:' "${file}" | tail -n3 | awk -F" " '/^Avr:/ {s+=$2} END {printf "%.0f", s}')
						MultiPercentageComp=$(( ${RawComp} / $(( ${CPUs} * 3 )) ))
						RawDecomp=$(grep '^Avr:' "${file}" | tail -n3 | awk -F" " '/^Avr:/ {s+=$6} END {printf "%.0f", s}')
						MultiPercentageDecomp=$(( ${RawDecomp} / $(( ${CPUs} * 3 )) ))
					fi
				fi
				echo -e "| [${file%.*}](${file}) / ${Title} | ${SinglePercentageComp} | ${SinglePercentageDecomp} | ${MultiPercentageComp} | ${MultiPercentageDecomp} |"
				;;
		esac
	done
} # CPUUtilization7ZIP

CheckRAID6PerfAndAlgo() {
	# if you collected a bunch of armhwinfo files (fetched from ix.io)
	# then you can do some sort of data mining with it, e.g. checking
	# for the RAID algo and achieved MB/s the kernel chose.

	echo -e "# raid6 performance and algorithm\n"
	echo -e "See function CheckRAID6PerfAndAlgo in https://github.com/ThomasKaiser/sbc-bench/blob/master/results/.snippets-for-insights.sh\n"
	echo "| MB/s / algo | Board | Kernel | URL |"
	echo "| :----- | :----: | :---- | :----|"
	( ProcessARMhwinfo ; ProcessSBCbenchs ) | sort -n -r | grep "^[1-9][0-9]" | sed -e 's/^/| /'
} # CheckRAID6PerfAndAlgo

ProcessSBCbenchs() {
	for file in *.txt ; do
		RAID6Raw="$(grep -a 'using algorithm' $file | awk -F" " '{print $6" ("$4")"}')"
		if [ "X${RAID6Raw}" != "X" ]; then
			RAID6Perf=$(sort -n -r <<<"${RAID6Raw}" | head -n1)
			BoardName="$(tail -n1 $file | awk -F"|" '{print $2}')"
			[ "X${BoardName}" = "X" ] && BoardName="$(head -n1 $file | cut -f1 -d'(' | awk -F" " '{print $3" "$4" "$5}')"
			KernelVersions="$(grep '^Linux ' $file | awk -F" " '{print $2}' | head -n1 | cut -f1 -d'-')"
			URL="http://ix.io/${file%.*}"
			case ${RAID6Perf} in
				*neon*)
					# filter out x86 and crappy kernel configs leaving out NEON support
					echo -e "${RAID6Perf} | ${BoardName} | ${KernelVersions} | [${URL}](${URL}) |"
					;;
			esac
		fi
		echo -e ".\c" >&2
	done
} # ProcessSBCbenchs

ProcessARMhwinfo() {
	for file in *.armhwinfo ; do
		RAID6Raw="$(grep -a 'using algorithm' $file | awk -F" " '{print $8" ("$6")"}')"
		if [ "X${RAID6Raw}" != "X" ]; then
			# dmesg output contains raid6 info, let's grab lowest/highest
			RAID6Min=$(sort -n <<<"${RAID6Raw}" | head -n1)
			RAID6Max=$(sort -n -r <<<"${RAID6Raw}" | head -n1)
			PerfRelation="$(awk '{print $1/$2}' <<<"$(cut -f1 -d' ' <<<"${RAID6Max}") $(cut -f1 -d' ' <<<"${RAID6Min}")")"
			if [ $(awk '{printf ("%0.0f",$1*100); }' <<<"${PerfRelation}") -lt 110 ]; then
				# difference between lowest and highest less than 10% so don't bother
				RAID6Perf="${RAID6Max}"
			else
				# report both values
				RAID6Perf="${RAID6Max} / <span style=\"color:red\">**${RAID6Min}**</span>"
			fi
			BoardName="$(grep -a 'Machine model: ' $file | awk -F"model: " '{print $2}' | head -n1)"
			[ "X${BoardName}" = "X" ] && BoardName="$(grep -a -B2 '### dmesg:' $file | cut -f2 -d'|' | head -n1)"
			KernelVersions="$(grep -a -B2 '### dmesg:' $file | awk -F"|" '/\|/ {print $6}' | cut -f1 -d'-' | sort | uniq | tr '\n' '/' | sed -e 's/\ //g' -e 's/\/$//')"
			URL="http://ix.io/${file%.*}"
			echo -e "${RAID6Perf} | ${BoardName} | ${KernelVersions} | [${URL}](${URL}) |"
		fi
		echo -e ".\c" >&2
	done
} # ProcessARMhwinfo

# CPUUtilization7ZIP >7-zip-cpu-utilisation.md
# CheckRAID6PerfAndAlgo >raid6-perf-and-algo.md
