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

# CPUUtilization7ZIP >7-zip-cpu-utilisation.md

