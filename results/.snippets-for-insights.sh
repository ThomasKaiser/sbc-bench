#!/bin/bash
#
# some script snippets showing examples how to crawl through sbc-bench results collection

# check some results for memory performance (4 x ODROID XU4 here):
# for i in 1ixL 1iWL 1iLy 3GnC ; do echo -e "\n$(head -n1 $i.txt)" ; egrep '^ standard |    131072 |   4194304 |  67108864 ' $i.txt ; done

CPUUtilization7ZIP() {
	# function that takes sbc-bench results in working directory ending with *.txt 
	# and parses them for 7-zip CPU utilization. Result is a markdown table
	echo "| Device | cores | comp single | decomp single | comp multi | decomp multi |"
	echo "| ----: | :----: | :----: | :----: | :----: | :----: |"
	for file in *.txt ; do
		Title="$(head -n1 "${file}" | sed -e 's/sbc-bench //' -e 's/Hardkernel //' -e 's/Xunlong //' -e 's/Raspberry Pi/RPi/' -e 's/ Model //' -e 's/\ (/(/' | cut -f1 -d'(')"
		case ${Title} in
			"v0.4 "*|*"  : "*|"Distributor ID:"*|*AMD*|*Intel*|*extensive*)
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
				SoCName="$(awk -F": " '/^SoC guess/ {print $2}' "${file}")"
				[ "X${SoCName}" = "X" ] || Title="$(cut -f1 -d' ' <<<"${Title}") ${SoCName}"
				echo -e "| [${Title}](http://ix.io/${file%.*}) | ${CPUs} | ${SinglePercentageComp} | ${SinglePercentageDecomp} | ${MultiPercentageComp} | ${MultiPercentageDecomp} |"
				;;
		esac
	done
} # CPUUtilization7ZIP

CheckRAID6PerfAndAlgo() {
	# If you collected a bunch of armhwinfo files (fetched from ix.io)
	# then you can do some sort of data mining with it, e.g. checking
	# for the RAID algo and achieved MB/s the kernel chose.

	# One use case of this collection is to determine best RAID6 PQ algo
	# per ARM core family. Then adopting this kernel patch here:
	# https://bugs.launchpad.net/ubuntu/+source/linux-gcp/+bug/1812728
	# Then add e.g. CONFIG_RAID6_PQ_DEFAULT_ALG=neonx4 to kernel cmdline
	# on boards with little cores (neonx8 seems best with A72/A73, neonx2
	# with Cortex-A9 and so on). Would save approx. 1 second on each boot
	# for every Armbian device out there. But since Armbian is now all
	# about desktop and GUI there's no-one left caring about such details.

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

CheckThermalSources() {
	grep "^Thermal source:" *.txt | while read ; do
		URL="$(cut -f1 -d'.' <<<"${REPLY}")"
		Board="$(tail -n1 ${URL}.txt | cut -f2 -d'|')"
		echo "  * [${Board}](http://ix.io/${URL})$(awk -F".txt" '{print $2}' <<<"${REPLY}")"
	done
} # CheckThermalSources

CheckcpufreqVSdistro() {
	for board in "Khadas VIM3" "Khadas VIM3L" "ODROID-N2" "ODROID-N2Plus" "Radxa ROCK 3 Model A" "Radxa ROCK 5B" ; do
		echo -e "\n${board} "
		grep "${board} " *.txt | cut -f1 -d':' | while read ; do
			OSRelease="Armbian $(awk -F"=" '/^VERSION/ {print $2}' "${REPLY}")"
			[ "X${OSRelease}" = "XArmbian " ] && OSRelease="Armbian $(awk -F"," '/^Armbian info/ {print $4}' "${REPLY}" | sed 's/\ //')"
			[ "X${OSRelease}" = "XArmbian " ] && OSRelease="$(awk -F":" '/^Description/ {print $2}' "${REPLY}" | sed 's/\t//')"
			Clockspeeds=$(tail -n1 "${REPLY}" | awk -F"|" '{print $3}')
			if [ "x${Clockspeeds}" != "X" ]; then
				echo ${OSRelease}: ${Clockspeeds}
			else
				A53=$(awk -F" " '/^  0/ {print $5}' "${REPLY}")
				A73=$(awk -F" " '/^  2/ {print $5}' "${REPLY}")
				echo ${OSRelease}: ${A53}/${A73} MHz
			fi
		done | sort
	done
} # CheckcpufreqVSdistro

CheckRK3588sbc-bench-results() {
	echo -e "# RK3588 sbc-bench results so far\n"
	echo "| Device / details | Clockspeed | idle temp | Kernel | Distro | dmc governor | 7-zip | memcpy | memset |"
	echo "| ----- | :--------: | :----: | :----: | :----: |  :----: | ----: | ------: | ------: |"
	grep -i "rk3588" *.txt | cut -f1 -d':' | sort | uniq | while read ; do
		Gov=$(grep "DMC gov" $REPLY | cut -c12-)
		IdleTemp=$(grep -A1 'soc_thermal-virtual-0' $REPLY | awk -F" " '/temp1/ {print $2}' | head -n1)
		echo -e "\n${IdleTemp}|${Gov:-unknown}|$REPLY: \c"
		tail -n1 $REPLY
	done | grep ' | ' | grep -v ' | | | |' | sed -e 's/: |/ |/' -e 's/\.txt //' | awk -F'|' '{print "| ["$4"](http://ix.io/"$3") |"$5"| "$1" |"$6"|"$7"| "$2" |"$8"|"$11"|"$12"|"}'
} # CheckRK3588sbc-bench-results

GetSingleThreaded7ZIPScore() {
	CountOfScores=$(grep -c '^Tot:' "$1")
	case ${CountOfScores} in
		1)
			# single core board
			awk -F" " '/^Tot:/ {print $4}' "$1"
			;;
		2)
			# something went wrong
			echo "-"
			;;
		3)
			# single core board but old sbc-bench version
			echo $(( $(awk -F" " '/^Tot:/ {s+=$4} END {printf "%.0f", s}' <"$1") / 3 ))
			;;
		4)
			# multiple cores, one cluster
			awk -F" " '/^Tot:/ {print $4}' "$1" | head -n1
			;;
		12)
			# Rock 5B extended mode
			awk -F" " '/^Tot:/ {print $4}' "$1" | head -n3 | sort -n | tail -n1
			;;

		*)
			# multiple cores, more than one cluster
			# head -n${#ClusterConfig[@]}
			awk -F" " '/^Tot:/ {print $4}' "$1" | head -n$(( ${CountOfScores} - 3 )) | sort -n | tail -n1
			;;
	esac
} # GetSingleThreaded7ZIPScore

ReplaceAES128CoreWith7ZIPST() {
	grep -E "http://ix.io|http://sprunge.us" ../Results.md | grep "^|" | while read ; do
		ResultFile="$(awk -F"/" '{print $4}' <<<"${REPLY}" | cut -f1 -d')').txt"
		STScore=$(GetSingleThreaded7ZIPScore "${ResultFile}")
		Prefix="$(awk -F"|" '{print "|"$2"|"$3"|"$4"|"$5"|"$6}' <<<"${REPLY}")"
		Suffix="$(awk -F"|" '{print $8"|"$9"|"$10"|"$11"|"}' <<<"${REPLY}")"
		echo "${Prefix}| ${STScore} |${Suffix}"
	done
} # ReplaceAES128CoreWith7ZIPST

CheckPVTMDistributionOnRK3588() {
	grep 'cpu cpu6: pvtm-volt-sel' *.txt | cut -f1 -d':' | sort | uniq | while read file ; do
		URL="http://ix.io/${file%.*}"
		IdleTemp="$(awk -F", " '/^Uptime/ {print $6}' ${file})"
		case ${IdleTemp} in
			*C)
				:
				;;
			*)
				IdleTemp="$(awk -F", " '/^Uptime/ {print $7}' ${file})"
				;;
		esac
		DeviceName="$(awk -F"," '/^DT compat: / {print $2}' ${file})"
		CPU4Freq=$(grep -A2 'Checking cpufreq OPP for cpu4' ${file} | awk -F" " '/Cpufreq OPP/ {print $5}' | head -n1)
		CPU4OPP=$(grep -A2 'Checking cpufreq OPP for cpu4' ${file} | awk -F" " '/Cpufreq OPP/ {print $3}' | head -n1)
		CPU6Freq=$(grep -A2 'Checking cpufreq OPP for cpu6' ${file} | awk -F" " '/Cpufreq OPP/ {print $5}' | head -n1)
		CPU6OPP=$(grep -A2 'Checking cpufreq OPP for cpu6' ${file} | awk -F" " '/Cpufreq OPP/ {print $3}' | head -n1)
		CPU4PVTM=$(awk -F"=" '/cpu cpu4: pvtm=/ {print $2}' ${file})
		CPU4PVTMVoltSel=$(awk -F"=" '/cpu cpu4: pvtm-volt-sel/ {print $2}' ${file})
		CPU6PVTM=$(awk -F"=" '/cpu cpu6: pvtm=/ {print $2}' ${file})
		CPU6PVTMVoltSel=$(awk -F"=" '/cpu cpu6: pvtm-volt-sel/ {print $2}' ${file})
		grep -q "Linux 5.10.72" ${file}
		if [ $? -eq 0 ]; then
			# Filter out amazingfate's overvolting experiments
			[ ${CPU4Freq} -lt 2300 ] && echo "| [${DeviceName}](${URL}) | ${CPU4PVTM} | ${CPU4PVTMVoltSel} | ${CPU4OPP} | ${CPU4Freq} |${IdleTemp} |"
			[ ${CPU6Freq} -lt 2300 ] && echo "| [${DeviceName}](${URL}) | ${CPU6PVTM} | ${CPU6PVTMVoltSel} | ${CPU6OPP} | ${CPU6Freq} |${IdleTemp} |"
		else
			[ ${CPU4Freq} -le 2400 ] && echo "| [${DeviceName}](${URL}) | ${CPU4PVTM} | ${CPU4PVTMVoltSel} | ${CPU4OPP} | ${CPU4Freq} |${IdleTemp} |" \
			|| echo "| [${DeviceName}](${URL}) | ${CPU4PVTM} | ${CPU4PVTMVoltSel} | ${CPU4OPP} | **${CPU4Freq}** |${IdleTemp} |"
			[ ${CPU6Freq} -le 2400 ] && echo "| [${DeviceName}](${URL}) | ${CPU6PVTM} | ${CPU6PVTMVoltSel} | ${CPU6OPP} | ${CPU6Freq} |${IdleTemp} |" \
			|| echo "| [${DeviceName}](${URL}) | ${CPU6PVTM} | ${CPU6PVTMVoltSel} | ${CPU6OPP} | **${CPU6Freq}** |${IdleTemp} |"
		fi
	done | grep -v ' |  |' | grep -v '| 0 |' | sed 's/,/./g' | sort -t '|' -k 3 -n
} # CheckPVTMDistributionOnRK3588

# CPUUtilization7ZIP >7-zip-cpu-utilisation.md
# CheckRAID6PerfAndAlgo >raid6-perf-and-algo.md
# CheckRK3588sbc-bench-results