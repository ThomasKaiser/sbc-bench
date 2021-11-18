#!/bin/bash
#
# Archive sbc-bench results (just in case ix.io disappears).
# To be executed from results dir. It also does some quick
# validation of collected results afterwards.

grep "| \[http://ix.io" ../Results.md | awk -F"http://" '{print $2}' | sed 's/](//' | while read ; do
	ResultFile="${REPLY##*/}.txt"
	if [ -f "${ResultFile}" ]; then
		grep -q "^tinymembench" "${ResultFile}" || (wget -q -O "${ResultFile}" "http://${REPLY}" ; sleep 5)
	else
		wget -O "${ResultFile}" "http://${REPLY}"
		git add "${ResultFile}"
		sleep 5
	fi
done

# contain all results files in compressed archive:
tar jcf results.tar.bz2 *.txt

# check results files for anomalies and create a table
cat <<EOF >validation.md
# Result validation

  * Standard deviation reported by tinymembench when repeating the individual tests multiple times
  * RAM total/avail according to \`free -h\`
  * 22/23/24/25 are dictionary sizes 7-zip's internal benchmark is testing through. On systems low on memory the larger ones will be skipped (2^22 = 4 MB, 2^23 = 8 MB, 2^24 = 16 MB, 2^25 = 32 MB)
  * high \`%system\` values while benchmarking are an indication of background activity that might render benchmark results useless
  * high \`%iowait\` values while benchmarking are an indication of something going wrong, most probaly swapping happening which will render benchmark results partially useless
  * if mentioned throttling needs to be checked in the log

| Result | Version / device | Standard deviation | RAM total/avail | 22 | 23 | 24 | 25 | %system | %iowait | throttling |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | ----: | ----: | :---: |
EOF

for file in *.txt ; do
	BoardName="$(head -n1 "${file}" | grep "sbc-bench" | cut -f1 -d'(' | awk -F" -- " '{print $1}' | sed -e 's/sbc-bench //' -e 's/_/\\_/g' | cut -c-40)"
	PrettyBoardName="$(grep "/${file%.*})" ../Results.md | head -n1 | cut -f2 -d'|' | cut -f2 -d'[' | cut -f1 -d']')"
	if [ "X${PrettyBoardName}" = "X" ]; then
		# reference not in results list any more. Strike through result line
		Prefix="<del>"
		Suffix="</del>"
	else
		unset Prefix Suffix
		case ${BoardName} in
			""|"v0.4"|"v0.4.6  "|"v0.6.2  "|"v0.7.1  "|"v0.7.4  "|"v0.7.5  ")
				DisplayName="${BoardName} ${PrettyBoardName}"
				;;
			*Intel*)
				DisplayName="$(cut -f1 -d' ' <<<${BoardName}) ${PrettyBoardName}"
				;;
			*)
				DisplayName="$(sed 's/nexell soc/NanoPi Fire3/' <<<"${BoardName}")"
				;;
		esac
	fi
	echo -e "| ${Prefix}[${file%.*}](${file})${Suffix} | ${Prefix}${DisplayName}${Suffix} | \c"
	TotalMem="$(awk -F" " '/^Mem:   / {print $2}' "${file}" | tail -n1)"
	FreeMem="$(awk -F" " '/^Mem:   / {print $7}' "${file}" | tail -n1)"
	MemCpyStdDeviation="$(awk -F" " '/^ standard memcpy/ {print $6}' "${file}" | sed -e 's/(//' -e 's/)//' | tail -n 1)"
	MemSetStdDeviation="$(awk -F" " '/^ standard memset/ {print $6}' "${file}" | sed -e 's/(//' -e 's/)//' | tail -n 1)"
	echo -e "${Prefix}${MemCpyStdDeviation:-0%}/${MemSetStdDeviation:-0%}${Suffix} | ${Prefix}${TotalMem}/${FreeMem}${Suffix} | \c"
	for dict in 22 23 24 25 ; do
		grep -q "^${dict}: " "${file}" && echo -e "${Prefix}X${Suffix} | \c" || echo -e "   | \c"
	done
	SysBusy="$(egrep "MHz  |---  " "${file}" | awk -F"%" '{print $2}' | sort -n -r | head -n1 | sed 's/  //')"
	if [ ${SysBusy:-0} -ge 10 ]; then
		echo -e "${Prefix}<span style="color:red">**${SysBusy}%**</span>${Suffix} | \c"
	elif [ ${SysBusy:-0} -ge 5 ]; then
		echo -e "${Prefix}<span style="color:red">${SysBusy}%</span>${Suffix} | \c"
	else
		echo -e "${Prefix}${SysBusy}%${Suffix} | \c"
	fi
	IOBusy="$(egrep "MHz  |---  " "${file}" | awk -F"%" '{print $5}' | sort -n -r | head -n1 | sed 's/  //')"
	if [ ${IOBusy:-0} -ge 10 ]; then
		echo -e "${Prefix}<span style="color:red">**${IOBusy}%**</span>${Suffix} | \c"
	elif [ ${IOBusy:-0} -ge 5 ]; then
		echo -e "${Prefix}<span style="color:red">${IOBusy}%</span>${Suffix} | \c"
	else
		echo -e "${Prefix}${IOBusy}%${Suffix} | \c"
	fi
	grep -q -i throttling "${file}" && echo " ${Prefix}[check log](${file})${Suffix} |" || echo " |"
done >>validation.md