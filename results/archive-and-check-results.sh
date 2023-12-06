#!/bin/bash
#
# Archive sbc-bench results (just in case ix.io or sprunge.us disappear).
# To be executed from results dir. It also does some quick validation of
# collected results afterwards.

grep -E "http://ix.io|http://sprunge.us" ../Results.md | awk -F"http://" '{print $2}' | cut -f1 -d')' | while read ; do
	ResultFile="${REPLY##*/}.txt"
	if [ -f "${ResultFile}" ]; then
		grep -q "^tinymembench" "${ResultFile}" || (wget -q -O "${ResultFile}" "http://${REPLY}" ; sleep 5)
	else
		wget -O "${ResultFile}" "http://${REPLY}"
		git add "${ResultFile}"
		sleep 5
	fi
done

# create compressed archive with benchmark results, cpuinfo files and opp-tables:
tar Jcf results.tar.xz *.txt cpuinfo opp-tables

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
	unset BoardName PrettyBoardName
	BoardName="$(head -n1 "${file}" | grep "sbc-bench" | sed 's/(R)//g' | cut -f1 -d'(' | awk -F" -- " '{print $1}' | sed -e 's/sbc-bench //' -e 's/_/\\_/g' | cut -c-39)"
	PrettyBoardName="$(grep "/${file})" ../Results.md | head -n1 | cut -f2 -d'|' | cut -f2 -d'[' | cut -f1 -d']')"
	if [ "X${PrettyBoardName}" = "X" ]; then
		DisplayName="$(sed 's/nexell soc/NanoPi Fire3/' <<<"${BoardName}")"
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
	SysBusy="$(egrep "MHz  |---  " "${file}" | awk -F"%" '{print $2}' | sed '/^[[:space:]]*$/d' | sed -e '1,2d' | sort -n -r | head -n1 | sed 's/  //')"
	if [ ${SysBusy:-0} -ge 10 ]; then
		echo -e "${Prefix}<span style="color:red">**${SysBusy}%**</span>${Suffix} | \c"
	elif [ ${SysBusy:-0} -ge 5 ]; then
		echo -e "${Prefix}<span style="color:red">${SysBusy}%</span>${Suffix} | \c"
	else
		echo -e "${Prefix}${SysBusy}%${Suffix} | \c"
	fi
	IOBusy="$(egrep "MHz  |---  " "${file}" | awk -F"%" '{print $5}' | sed '/^[[:space:]]*$/d' | sed -e '1,2d' | sort -n -r | head -n1 | sed 's/  //')"
	if [ ${IOBusy:-0} -ge 8 ]; then
		echo -e "${Prefix}<span style="color:red">**${IOBusy}%**</span>${Suffix} | \c"
	elif [ ${IOBusy:-0} -ge 4 ]; then
		echo -e "${Prefix}<span style="color:red">${IOBusy}%</span>${Suffix} | \c"
	else
		echo -e "${Prefix}${IOBusy}%${Suffix} | \c"
	fi
	case ${BoardName} in
		*icosa*|*"Tinker Board"*|*"Orange Pi Prime"*|"v0.7.9 Raspberry Pi Zero 2 Rev 1.0"*|"v0.8.3 Raspberry Pi Model B Rev 2"*|*"NanoPi K1 Plus"*)
			# ignore since not really throttling
			echo " |"
			;;
		*)
			grep -q -i throttling "${file}" && echo " ${Prefix}[check log](${file})${Suffix} |" || echo " |"
			;;
	esac
done | sed -e 's/ \{2,\}/ /g' >>validation.md

# check whether new ARM Core IDs appeared
for URL2Check in https://raw.githubusercontent.com/util-linux/util-linux/master/sys-utils/lscpu-arm.c https://raw.githubusercontent.com/hrw/arm-socs-table/main/data/cpu_cores.yml https://raw.githubusercontent.com/pytorch/cpuinfo/main/src/arm/linux/midr.c https://raw.githubusercontent.com/Dr-Noob/cpufetch/master/src/arm/uarch.c https://raw.githubusercontent.com/torvalds/linux/master/arch/arm64/include/asm/cputype.h ; do
	echo "Checking ${URL2Check}"
	curl -s -O "${URL2Check}"
	[ -f "${URL2Check##*/}.old" ] && diff "${URL2Check##*/}" "${URL2Check##*/}.old"
	mv -f "${URL2Check##*/}" "${URL2Check##*/}.old"
done

# generate sorted tables
echo -e "# sbc-bench results sorted\n" >../Sorted-Results.md
echo -e "**WARNING: Do NOT blindly trust into these numbers without reading [the explanations](../Results.md#explanations) first!**\n" >>../Sorted-Results.md
echo "  * [7-zip multi-threaded](#7-zip-mips-multi-threaded)" >>../Sorted-Results.md
echo "  * [7-zip single-threaded](#7-zip-mips-single-threaded)" >>../Sorted-Results.md
echo "  * [aes-256-cbc](#openssl-speed--elapsed--evp-aes-256-cbc)" >>../Sorted-Results.md
echo "  * [memcpy](#memcpy)" >>../Sorted-Results.md
echo "  * [memset](#memset)" >>../Sorted-Results.md
echo "  * [clockspeed](#clockspeed)" >>../Sorted-Results.md

# sorted by 7-zip multi-threaded score:
echo -e "\n## 7-zip MIPS multi-threaded\n" >>../Sorted-Results.md
echo "| Device / details | Clockspeed | Kernel | Distro | *7-zip multi* | 7-zip single | AES | memcpy | memset | kH/s |" >>../Sorted-Results.md
echo "| ----- | :--------: | :----: | :----: | ----: | ------: | ------: | -----: | -----: | ---: |" >>../Sorted-Results.md
grep -E "results/|http://ix.io|http://sprunge.us" ../Results.md | grep "^|" | sed 's/\*\*//g'| sort -r -t '|' -k 6 -n \
	| awk -F"|" '{print "|"$2"|"$3"|"$4"|"$5"|**"$6"**|"$7"|"$8"|"$9"|"$10"|"$11"|"}' | sed -e 's/|\*\* /| \*\*/' -e 's/ \*\*|/\*\* |/' >>../Sorted-Results.md

# sorted by 7-zip single-threaded score:
echo -e "\n[(back to top of the page)](#sbc-bench-results-sorted)\n\n## 7-zip MIPS single-threaded\n" >>../Sorted-Results.md
echo "| Device / details | Clockspeed | Kernel | Distro | 7-zip multi | *7-zip single* | AES | memcpy | memset | kH/s |" >>../Sorted-Results.md
echo "| ----- | :--------: | :----: | :----: | ----: | ------: | ------: | -----: | -----: | ---: |" >>../Sorted-Results.md
grep -E "results/|http://ix.io|http://sprunge.us" ../Results.md | grep "^|" | sed 's/\*\*//g'| sort -r -t '|' -k 7 -n \
	| awk -F"|" '{print "|"$2"|"$3"|"$4"|"$5"|"$6"|**"$7"**|"$8"|"$9"|"$10"|"$11"|"}' | sed -e 's/|\*\* /| \*\*/' -e 's/ \*\*|/\*\* |/' >>../Sorted-Results.md

# sorted by openssl speed -elapsed -evp aes-256-cbc:
echo -e "\n[(back to top of the page)](#sbc-bench-results-sorted)\n\n## openssl speed -elapsed -evp aes-256-cbc\n" >>../Sorted-Results.md
echo -e "(For an in-depth explanation of ARMv8 AES scores see [here](ARMv8-Crypto-Extensions.md))\n" >>../Sorted-Results.md
echo "| Device / details | Clockspeed | Kernel | Distro | 7-zip multi | 7-zip single | *AES* | memcpy | memset | kH/s |" >>../Sorted-Results.md
echo "| ----- | :--------: | :----: | :----: | ----: | ------: | ------: | -----: | -----: | ---: |" >>../Sorted-Results.md
grep -E "results/|http://ix.io|http://sprunge.us" ../Results.md | grep "^|" | sed 's/\*\*//g'| sort -r -t '|' -k 8 -n \
	| awk -F"|" '{print "|"$2"|"$3"|"$4"|"$5"|"$6"|"$7"|**"$8"**|"$9"|"$10"|"$11"|"}' | sed -e 's/|\*\* /| \*\*/' -e 's/ \*\*|/\*\* |/' >>../Sorted-Results.md

# sorted by memcpy:
echo -e "\n[(back to top of the page)](#sbc-bench-results-sorted)\n\n## memcpy\n" >>../Sorted-Results.md
echo "| Device / details | Clockspeed | Kernel | Distro | 7-zip multi | 7-zip single | AES | *memcpy* | memset | kH/s |" >>../Sorted-Results.md
echo "| ----- | :--------: | :----: | :----: | ----: | ------: | ------: | -----: | -----: | ---: |" >>../Sorted-Results.md
grep -E "results/|http://ix.io|http://sprunge.us" ../Results.md | grep "^|" | sed 's/\*\*//g'| sort -r -t '|' -k 9 -n \
	| awk -F"|" '{print "|"$2"|"$3"|"$4"|"$5"|"$6"|"$7"|"$8"|**"$9"**|"$10"|"$11"|"}' | sed -e 's/|\*\* /| \*\*/' -e 's/ \*\*|/\*\* |/' >>../Sorted-Results.md

# sorted by memset:
echo -e "\n[(back to top of the page)](#sbc-bench-results-sorted)\n\n## memset\n" >>../Sorted-Results.md
echo "| Device / details | Clockspeed | Kernel | Distro | 7-zip multi | 7-zip single | AES | memcpy | *memset* | kH/s |" >>../Sorted-Results.md
echo "| ----- | :--------: | :----: | :----: | ----: | ------: | ------: | -----: | -----: | ---: |" >>../Sorted-Results.md
grep -E "results/|http://ix.io|http://sprunge.us" ../Results.md | grep "^|" | sed 's/\*\*//g'| sort -r -t '|' -k 10 -n \
	| awk -F"|" '{print "|"$2"|"$3"|"$4"|"$5"|"$6"|"$7"|"$8"|"$9"|**"$10"**|"$11"|"}' | sed -e 's/|\*\* /| \*\*/' -e 's/ \*\*|/\*\* |/' >>../Sorted-Results.md

# sorted by clockspeed:
echo -e "\n[(back to top of the page)](#sbc-bench-results-sorted)\n\n## clockspeed\n" >>../Sorted-Results.md
echo "| Device / details | *Clockspeed* | Kernel | Distro | 7-zip multi | 7-zip single | AES | memcpy | memset | kH/s |" >>../Sorted-Results.md
echo "| ----- | :--------: | :----: | :----: | ----: | ------: | ------: | -----: | -----: | ---: |" >>../Sorted-Results.md
grep -E "results/|http://ix.io|http://sprunge.us" ../Results.md | grep "^|" | sed 's/\*\*//g'| sort -r -t '|' -k 3 -n | grep MHz \
	| awk -F"|" '{print "|"$2"|**"$3"**|"$4"|"$5"|"$6"|"$7"|"$8"|"$9"|"$10"|"$11"|"}' | sed -e 's/|\*\* /| \*\*/' -e 's/ MHz \*\*|/\*\* MHz|/' >>../Sorted-Results.md
echo -e "\n[(back to top of the page)](#sbc-bench-results-sorted)" >>../Sorted-Results.md