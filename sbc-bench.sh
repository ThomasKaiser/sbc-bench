#!/bin/bash

Version=0.3
InstallLocation=/tmp # change to /usr/local/src if you want tools to persist reboots

Main() {
	export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

	# check whether we're running in monitoring or benchmark mode
	if [ "X$1" = "Xm" ]; then
		interval=$2
		MonitorBoard
	else
		# Check if we're outputting to a terminal. If yes try to use bold and colors for messages
		if test -t 1; then
			ncolors=$(tput colors)
			if test -n "$ncolors" && test $ncolors -ge 8; then
				BOLD="$(tput bold)"
				NC='\033[0m' # No Color
				LGREEN='\033[1;32m'
				LRED='\e[0;91m'
			fi
		fi
		if [ "X$1" = "Xneon" ]; then
			TestNEON=yes
		fi
		CheckRelease
		CheckLoad
		SwitchToPerformance >/dev/null 2>&1
		InstallPrerequisits
		InitialMonitoring
		CheckClockspeeds
		RunTinyMemBench
		if [ "${TestNEON}" = "yes" -a -x "${InstallLocation}"/cpuminer-multi/cpuminer ]; then
			RunCpuminerBenchmark
			CheckClockspeeds # again after heating the SoC to the max
		fi
		Run7ZipBenchmark
		[ "${TestNEON}" = "yes" ] || CheckClockspeeds # again after heating the SoC to the max
		RunOpenSSLBenchmark
		DisplayResults
	fi
} # Main

MonitorBoard() {
	# In Armbian we can rely on /etc/armbianmonitor/datasources/soctemp
	if [ -f /etc/armbianmonitor/datasources/soctemp ]; then
		TempSource=/etc/armbianmonitor/datasources/soctemp
	else
		TempSource="$(mktemp /tmp/soctemp.XXXXXX)"
		trap "rm -f \"${TempSource}\" ; exit 0" 0 1 2 3 15
		if [[ -d "/sys/devices/platform/a20-tp-hwmon" ]]; then
			# Allwinner A20 with old 3.4 kernel
			ln -fs /sys/devices/platform/a20-tp-hwmon/temp1_input ${TempSource}
		elif [[ -f /sys/class/hwmon/hwmon0/temp1_input ]]; then
			# usual convention with modern kernels
			ln -fs /sys/class/hwmon/hwmon0/temp1_input ${TempSource}
		else
			# all other boards/kernels use the same sysfs node except of Actions Semi S500
			# so on LeMaker Guitar, Roseapple Pi or Allo Sparky it must read "thermal_zone1"
			ln -fs /sys/devices/virtual/thermal/thermal_zone0/temp ${TempSource}
		fi
	fi

	# Try to renice to 19 to not interfere with benchmark behaviour
	renice 19 $BASHPID >/dev/null 2>&1

	LastUserStat=0
	LastNiceStat=0
	LastSystemStat=0
	LastIdleStat=0
	LastIOWaitStat=0
	LastIrqStat=0
	LastSoftIrqStat=0
	LastCpuStatCheck=0
	LastTotal=0

	SleepInterval=${interval:-5}

	if [ -f /usr/bin/vcgencmd ]; then
		DisplayHeader="Time        fake/real   load %cpu %sys %usr %nice %io %irq   Temp   VCore"
		CPUs=raspberrypi
	elif [ -f /sys/devices/system/cpu/cpu4/cpufreq/cpuinfo_cur_freq ]; then
		DisplayHeader="Time       big.LITTLE   load %cpu %sys %usr %nice %io %irq   Temp"
		CPUs=biglittle
	elif [ -f /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq ]; then
		DisplayHeader="Time        CPU    load %cpu %sys %usr %nice %io %irq   Temp"
		CPUs=normal
	else
		DisplayHeader="Time      CPU n/a    load %cpu %sys %usr %nice %io %irq   Temp"
		CPUs=notavailable
	fi
	[ -f "${TempSource}" ] || SocTemp='n/a'
	echo -e "${DisplayHeader}"
	while true ; do
		LoadAvg=$(cut -f1 -d" " </proc/loadavg)
		if [ "X${SocTemp}" != "Xn/a" ]; then
			read SocTemp <"${TempSource}"
			if [ ${SocTemp} -ge 1000 ]; then
				SocTemp=$(awk '{printf ("%0.1f",$1/1000); }' <<<${SocTemp})
			fi
		fi
		case ${CPUs} in
			raspberrypi)
				FakeFreq=$(awk '{printf ("%0.0f",$1/1000); }' </sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq) 2>/dev/null
				RealFreq=$(/usr/bin/vcgencmd measure_clock arm | awk -F"=" '{printf ("%0.0f",$2/1000000); }' )
				CoreVoltage=$(/usr/bin/vcgencmd measure_volts | cut -f2 -d= | sed 's/000//')
				ProcessStats
				echo -e "$(date "+%H:%M:%S"): $(printf "%4s" ${FakeFreq})/$(printf "%4s" ${RealFreq})MHz $(printf "%5s" ${LoadAvg}) ${procStats}  $(printf "%4s" ${SocTemp})°C  ${CoreVoltage}"
				;;
			biglittle)
				BigFreq=$(awk '{printf ("%0.0f",$1/1000); }' </sys/devices/system/cpu/cpu4/cpufreq/cpuinfo_cur_freq) 2>/dev/null
				LittleFreq=$(awk '{printf ("%0.0f",$1/1000); }' </sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq) 2>/dev/null
				ProcessStats
				echo -e "$(date "+%H:%M:%S"): $(printf "%4s" ${BigFreq})/$(printf "%4s" ${LittleFreq})MHz $(printf "%5s" ${LoadAvg}) ${procStats}  $(printf "%4s" ${SocTemp})°C"
				;;
			normal)
				CpuFreq=$(awk '{printf ("%0.0f",$1/1000); }' </sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq) 2>/dev/null
				ProcessStats
				echo -e "$(date "+%H:%M:%S"): $(printf "%4s" ${CpuFreq})MHz $(printf "%5s" ${LoadAvg}) ${procStats}  $(printf "%4s" ${SocTemp})°C"
				;;
			notavailable)
				ProcessStats
				echo -e "$(date "+%H:%M:%S"):   ---     $(printf "%5s" ${LoadAvg}) ${procStats}  $(printf "%4s" ${SocTemp})°C"
				;;
		esac
		sleep ${SleepInterval}
	done
} # MonitorBoard

ProcessStats() {
	procStatLine=(`sed -n 's/^cpu\s//p' /proc/stat`)
	UserStat=${procStatLine[0]}
	NiceStat=${procStatLine[1]}
	SystemStat=${procStatLine[2]}
	IdleStat=${procStatLine[3]}
	IOWaitStat=${procStatLine[4]}
	IrqStat=${procStatLine[5]}
	SoftIrqStat=${procStatLine[6]}

	Total=0
	for eachstat in ${procStatLine[@]}; do
		Total=$(( ${Total} + ${eachstat} ))
	done

	UserDiff=$(( ${UserStat} - ${LastUserStat} ))
	NiceDiff=$(( ${NiceStat} - ${LastNiceStat} ))
	SystemDiff=$(( ${SystemStat} - ${LastSystemStat} ))
	IOWaitDiff=$(( ${IOWaitStat} - ${LastIOWaitStat} ))
	IrqDiff=$(( ${IrqStat} - ${LastIrqStat} ))
	SoftIrqDiff=$(( ${SoftIrqStat} - ${LastSoftIrqStat} ))
	
	diffIdle=$(( ${IdleStat} - ${LastIdleStat} ))
	diffTotal=$(( ${Total} - ${LastTotal} ))
	diffX=$(( ${diffTotal} - ${diffIdle} ))
	CPULoad=$(( ${diffX}* 100 / ${diffTotal} ))
	UserLoad=$(( ${UserDiff}* 100 / ${diffTotal} ))
	SystemLoad=$(( ${SystemDiff}* 100 / ${diffTotal} ))
	NiceLoad=$(( ${NiceDiff}* 100 / ${diffTotal} ))
	IOWaitLoad=$(( ${IOWaitDiff}* 100 / ${diffTotal} ))
	IrqCombined=$(( ${IrqDiff} + ${SoftIrqDiff} ))
	IrqCombinedLoad=$(( ${IrqCombined}* 100 / ${diffTotal} ))

	LastUserStat=${UserStat}
	LastNiceStat=${NiceStat}
	LastSystemStat=${SystemStat}
	LastIdleStat=${IdleStat}
	LastIOWaitStat=${IOWaitStat}
	LastIrqStat=${IrqStat}
	LastSoftIrqStat=${SoftIrqStat}
	LastTotal=${Total}
	procStats=$(echo -e "$(printf "%3s" ${CPULoad})%$(printf "%4s" ${SystemLoad})%$(printf "%4s" ${UserLoad})%$(printf "%4s" ${NiceLoad})%$(printf "%4s" ${IOWaitLoad})%$(printf "%4s" ${IrqCombinedLoad})%")
} # ProcessStats

CheckRelease() {
	Distro=$(lsb_release -c | awk -F" " '{print $2}' | tr '[:upper:]' '[:lower:]')
	case ${Distro} in
		stretch|bionic)
			:
			;;
		*)
			echo -e "${LRED}${BOLD}WARNING: this tool is meant to run only on Debian Stretch or Ubuntu Bionic.${NC}"
			echo -e "When running on other distros results are partially meaningless or can't be collected.\nPress [ctrl]-[c] to stop or [enter] to continue."
			read
			;;
	esac
} # CheckRelease

CheckLoad() {
	AvgLoad1Min=$(awk -F" " '{print $1*100}' < /proc/loadavg)
	while [ $AvgLoad1Min -ge 10 ]; do
		echo -e "System too busy for benchmarking:$(uptime)"
		sleep 5
		AvgLoad1Min=$(awk -F" " '{print $1*100}' < /proc/loadavg)
	done
	echo ""
} # CheckLoad

SwitchToPerformance() {
	CPUCores=$(grep -c '^processor' /proc/cpuinfo)
	for ((i=0;i<CPUCores;i++)); do
		echo performance >/sys/devices/system/cpu/cpu${i}/cpufreq/scaling_governor
	done
} # SwitchToPerformance

InstallPrerequisits() {
	echo -e "sbc-bench v${Version}\n\nInstalling needed tools. This may take some time...\c"
	SevenZip=$(which 7za || which 7zr)
	[ -z "${SevenZip}" ] && apt -f -qq -y install p7zip >/dev/null 2>&1 && SevenZip=/usr/bin/7zr
	[ -z "${SevenZip}" ] && (echo "No 7-zip binary found and could not be installed. Aborting" >&2 ; exit 1)

	which iostat >/dev/null 2>&1 || apt -f -qq -y install sysstat >/dev/null 2>&1
	which git >/dev/null 2>&1 || apt -f -qq -y install git >/dev/null 2>&1
	which openssl >/dev/null 2>&1 || apt -f -qq -y install openssl >/dev/null 2>&1
	which curl >/dev/null 2>&1 || apt -f -qq -y install curl >/dev/null 2>&1

	# get/build tinymembench if not already there
	if [ ! -x "${InstallLocation}"/tinymembench/tinymembench ]; then
		cd "${InstallLocation}"
		git clone https://github.com/ssvb/tinymembench >/dev/null 2>&1
		cd tinymembench
		make >/dev/null 2>&1
	fi

	# get/build mhz if not already there
	if [ ! -x "${InstallLocation}"/mhz/mhz ]; then
		cd "${InstallLocation}"
		git clone http://git.1wt.eu/git/mhz.git/ >/dev/null 2>&1
		cd mhz
		make >/dev/null 2>&1
	fi
	
	# if called as 'sbc-bench neon' we also use cpuminer
	if [ "${TestNEON}" = "yes" ]; then
		InstallCpuminer >/dev/null 2>&1
	fi
} # InstallPrerequisits

InstallCpuminer() {
	# get/build cpuminer if not already there
	if [ ! -x "${InstallLocation}"/cpuminer-multi/cpuminer ]; then
		cd "${InstallLocation}"
		apt -f -qq -y install automake autoconf pkg-config libcurl4-openssl-dev libjansson-dev libssl-dev libgmp-dev make g++ zlib1g-dev >/dev/null 2>&1
		git clone https://github.com/tkinjo1985/cpuminer-multi.git
		cd cpuminer-multi/
		./build.sh
	fi
	if [ ! -x "${InstallLocation}"/cpuminer-multi/cpuminer ]; then
		echo -e " (can't build cpuminer)\c"
	fi
} # InstallCpuminer

InitialMonitoring() {
	# Create temporary files
	TempDir="$(mktemp -d /tmp/${0##*/}.XXXXXX)"
	TempLog="${TempDir}/temp.log"
	ResultLog="${TempDir}/results.log"
	MonitorLog="${TempDir}/monitor.log"
	trap "rm -rf \"${TempDir}\" ; exit 0" 0 1 2 3 15

	# Log version info
	echo -e "sbc-bench v${Version} -- $(date -R)\n" >${ResultLog}

	# Log distribution info
	[ -f /etc/armbian-release ] && . /etc/armbian-release
	[ -n "${BOARDFAMILY}" ] && (grep -v "#" /etc/armbian-release ; echo "") >>${ResultLog}
	which lsb_release >/dev/null 2>&1 && (lsb_release -a 2>/dev/null) >>${ResultLog}
	[ -n "${BOARDFAMILY}" ] || echo -e "Architecture:\t$(dpkg --print-architecture)" >>${ResultLog}

	# On Raspberries we also collect 'firmware' information:
	[ -f /usr/bin/vcgencmd ] && (echo -e "\nRaspberry Pi ThreadX version:\n$(/usr/bin/vcgencmd version)") >>${ResultLog}
	[ -f /boot/config.txt ] && echo -e "\nThreadX configuration (/boot/config.txt):\n$(grep -v '#' /boot/config.txt | sed '/^\s*$/d')" >>${ResultLog}

	# Some basic system info needed to interpret system health later
	echo -e "\nUptime:$(uptime)\n\n$(iostat)\n\n$(free -h)\n\n$(swapon -s)" \
		>>${ResultLog}
	# Check cpufreq statistics prior and after benchmark to detect throttling (won't work 
	# with all kernels and especially not on the RPi since RPi Trading people are cheating.
	# Cpufreq support via sysfs is bogus and with latest ThreadX (firmware) update they 
	# even cheat wrt querying the 'firmware' via 'vcgencmd get_throttled':
	# https://www.raspberrypi.org/forums/viewtopic.php?f=63&t=217056#p1334921
	find /sys -type f -name time_in_state | grep 'cpufreq' | while read ; do
		Number=$(echo ${REPLY} | tr -c -d '[:digit:]')
		Entries=$(wc -l ${REPLY} | awk -F" " '{print $1}')
		head -n $(( ${Entries} - 1 )) ${REPLY} >${TempDir}/time_in_state_before_${Number}
	done
} # InitialMonitoring

CheckClockspeeds() {
	echo -e " Done.\nChecking cpufreq OPP...\c"
	if [ "X${BOARDFAMILY}" = "Xs5p6818" -o ${CPUCores} -le 4 ]; then
		# no big.LITTLE, checking cluster 0 is enough
		echo -e "\n##########################################################################\n\nChecking cpufreq OPP:\n" >>${ResultLog}
		CheckCPUCluster 0 >>${ResultLog}
	else
		# big.LITTLE or something else (Amlogic S912)
		echo -e "\n##########################################################################\n\nChecking cpufreq OPP for cpu0-cpu3:\n" >>${ResultLog}
		CheckCPUCluster 0 >>${ResultLog}
		echo -e "\nChecking cpufreq OPP for cpu4-cpu$(( ${CPUCores} - 1 )):\n" >>${ResultLog}
		CheckCPUCluster 4 >>${ResultLog}
	fi
} # CheckClockspeeds

CheckCPUCluster() {
	read MaxSpeed </sys/devices/system/cpu/cpu${1}/cpufreq/cpuinfo_max_freq
	read MinSpeed </sys/devices/system/cpu/cpu${1}/cpufreq/cpuinfo_min_freq
	echo ${MinSpeed} >/sys/devices/system/cpu/cpu${1}/cpufreq/scaling_min_freq
	for i in $(cat /sys/devices/system/cpu/cpu${1}/cpufreq/scaling_available_frequencies) ; do
		echo ${i} >/sys/devices/system/cpu/cpu${1}/cpufreq/scaling_max_freq
		sleep 0.1
		RealSpeed=$(taskset -c $(( $1 + 1 )) "${InstallLocation}"/mhz/mhz 3 1000 | awk -F" cpu_MHz=" '{print $2}' | awk -F" " '{print $1}' | tr '\n' '/' | sed 's|/$||')
		SysfsSpeed=$(( $i / 1000 ))
		if [ -f /usr/bin/vcgencmd ]; then
			# On RPi we query ThreadX about clockspeeds too
			ThreadXFreq=$(/usr/bin/vcgencmd measure_clock arm | awk -F"=" '{printf ("%0.0f",$2/1000000); }' )
			echo -e "Cpufreq OPP: $(printf "%4s" ${SysfsSpeed})    ThreadX: $(printf "%4s" ${ThreadXFreq})    Measured: ${RealSpeed}"
		else
			echo -e "Cpufreq OPP: $(printf "%4s" ${SysfsSpeed})    Measured: ${RealSpeed}"
		fi
	done
} # CheckCPUCluster

RunTinyMemBench() {
	echo -e " Done.\nExecuting tinymembench. This will take a long time...\c"
	echo -e "System health while running tinymembench:\n" >${MonitorLog}
	"${0}" m 60 >>${MonitorLog} &
	MonitoringPID=$!
	sleep 10
	if [ ${CPUCores} -gt 4 ]; then
		if [ "X${BOARDFAMILY}" = "Xs5p6818" ]; then
			# S5P6816 octa-core SoC is not a big.LITTLE design
			"${InstallLocation}"/tinymembench/tinymembench >${TempLog} 2>&1
		else
			# big.LITTLE SoC, we execute one time on a little and one time on a big core
			echo -e "Executing tinymembench on a little core:\n" >${TempLog}
			taskset -c 0 "${InstallLocation}"/tinymembench/tinymembench >>${TempLog} 2>&1
			echo -e "\nExecuting tinymembench on a big core:\n" >>${TempLog}
			taskset -c $(( ${CPUCores} -1 )) "${InstallLocation}"/tinymembench/tinymembench >>${TempLog} 2>&1
		fi
	else
		"${InstallLocation}"/tinymembench/tinymembench >${TempLog} 2>&1
	fi
	kill ${MonitoringPID}
	echo -e "\n##########################################################################\n" >>${ResultLog}
	cat ${TempLog} >>${ResultLog}
} # RunTinyMemBench

Run7ZipBenchmark() {
	echo -e " Done.\nExecuting 7-zip benchmark. This will take a long time...\c"
	echo -e "\nSystem health while running 7-zip single core benchmark:\n" >>${MonitorLog}
	echo -e "\c" >${TempLog}
	"${0}" m 15 >>${MonitorLog} &
	MonitoringPID=$!
	if [ ${CPUCores} -gt 4 ]; then
		if [ "X${BOARDFAMILY}" = "Xs5p6818" ]; then
			# S5P6816 octa-core SoC is not a big.LITTLE design
			taskset -c 0 "${SevenZip}" b >>${TempLog}
		else
			# big.LITTLE SoC, we execute one time on a little and one time on a big core
			taskset -c 0 "${SevenZip}" b >>${TempLog}
			taskset -c $(( ${CPUCores} - 1 )) "${SevenZip}" b >>${TempLog}
		fi
	else
		taskset -c 0 "${SevenZip}" b >>${TempLog}
	fi
	kill ${MonitoringPID}
	echo -e "\n##########################################################################" >>${ResultLog}
	cat ${TempLog} >>${ResultLog}
	echo -e "\nSystem health while running 7-zip multi core benchmark:\n" >>${MonitorLog}
	echo -e "\c" >${TempLog}
	"${0}" m 30 >>${MonitorLog} &
	MonitoringPID=$!
	RunHowManyTimes=3
	sleep 10
	for ((i=1;i<=RunHowManyTimes;i++)); do
		"${SevenZip}" b >>${TempLog}
	done
	kill ${MonitoringPID}
	echo -e "\n##########################################################################" >>${ResultLog}
	cat ${TempLog} >>${ResultLog}
	sed -i 's/|//' ${TempLog}
	CompScore=$(awk -F" " '/^Avr:/ {print $4}' <${TempLog} | tr '\n' ', ' | sed 's/,$//')
	DecompScore=$(awk -F" " '/^Avr:/ {print $7}' <${TempLog} | tr '\n' ', ' | sed 's/,$//')
	TotScore=$(awk -F" " '/^Tot:/ {print $4}' <${TempLog} | tr '\n' ', ' | sed 's/,$//')
	echo -e "\nCompression: ${CompScore}" >>${ResultLog}
	echo -e "Decompression: ${DecompScore}" >>${ResultLog}
	echo -e "Total: ${TotScore}" >>${ResultLog}
} # Run7ZipBenchmark

RunOpenSSLBenchmark() {
	echo -e " Done.\nExecuting OpenSSL benchmark. This will take 3 minutes...\c"
	echo -e "\nSystem health while running OpenSSL benchmark:\n" >>${MonitorLog}
	"${0}" m 10 >>${MonitorLog} &
	MonitoringPID=$!
	sleep 10
	for i in 128 192 256 ; do
		if [ ${CPUCores} -gt 4 ]; then
			# big.LITTLE SoC, we execute one time on a little and one time on a big core
			taskset -c 0 openssl speed -elapsed -evp aes-${i}-cbc 2>/dev/null
			taskset -c $(( ${CPUCores} -1 )) openssl speed -elapsed -evp aes-${i}-cbc 2>/dev/null
		else
			openssl speed -elapsed -evp aes-${i}-cbc 2>/dev/null
			openssl speed -elapsed -evp aes-${i}-cbc 2>/dev/null
		fi
	done >${TempLog}
	kill ${MonitoringPID}
	echo -e "\n##########################################################################\n" >>${ResultLog}
	echo -e "$(openssl version)\n$(grep '^type' ${TempLog} | head -n1)" >>${ResultLog}
	grep '^aes-' ${TempLog} >>${ResultLog}
} # RunOpenSSLBenchmark

RunCpuminerBenchmark() {
	echo -e " Done.\nExecuting cpuminer. This will take 5 minutes...\c"
	echo -e "\nSystem health while running cpuminer:\n" >>${MonitorLog}
	"${0}" m 10 >>${MonitorLog} &
	MonitoringPID=$!
	sleep 10
	"${InstallLocation}"/cpuminer-multi/cpuminer --benchmark --cpu-priority=2 >${TempLog} &
	MinerPID=$!
	sleep 290
	kill ${MinerPID} ${MonitoringPID}
	echo -e "\n##########################################################################\n" >>${ResultLog}
	sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" <${TempLog} >>${ResultLog}
	# Summarized 'Total:' scores
	TotalScores="$(awk -F" " '/Total:/ {print $4}' ${TempLog} | sort -r -n | uniq | tr '\n' ', ' | sed 's/,$//')"
	echo -e "\nTotal Scores: ${TotalScores}" >>${ResultLog}
} # RunCpuminerBenchmark

DisplayResults() {
	echo -e " Done.\n\007\007\007"

	# Check for throttling on normal ARM SBC
	find /sys -type f -name time_in_state | grep 'cpufreq' | while read ; do
		Number=$(echo ${REPLY} | tr -c -d '[:digit:]')
		Entries=$(wc -l ${REPLY} | awk -F" " '{print $1}')
		head -n $(( ${Entries} - 1 )) ${REPLY} >${TempDir}/time_in_state_after_${Number}
		diff ${TempDir}/time_in_state_after_${Number} ${TempDir}/time_in_state_before_${Number} >/dev/null 2>&1
		if [ $? -ne 0 ]; then
			case ${CPUCores} in
				1|2|3|4)
					echo -e "${LRED}${BOLD}ATTENTION: Throttling occured. Check the uploaded log for details.${NC}\n"
					;;
				6)
					if [ ${Number} -eq 0 ]; then
						echo -e "${LRED}${BOLD}ATTENTION: Throttling occured on CPUs 0-3. Check the uploaded log for details.${NC}\n"
					else
						echo -e "${LRED}${BOLD}ATTENTION: Throttling occured on CPUs 4-5. Check the uploaded log for details.${NC}\n"
					fi
					;;
				8)
					if [ "X${BOARDFAMILY}" = "Xs5p6818" ]; then
						echo -e "${LRED}${BOLD}ATTENTION: Throttling occured. Check the uploaded log for details.${NC}\n"
					elif [ ${Number} -eq 0 ]; then
						echo -e "${LRED}${BOLD}ATTENTION: Throttling occured on CPUs 0-3. Check the uploaded log for details.${NC}\n"
					else
						echo -e "${LRED}${BOLD}ATTENTION: Throttling occured on CPUs 4-7. Check the uploaded log for details.${NC}\n"
					fi
					;;
			esac
		fi
	done

	# Check for killed CPU cores. Some unfortunate users might still use Allwinner BSP kernels
	CPUCoresNow=$(grep -c '^processor' /proc/cpuinfo)
	if [ ${CPUCoresNow} -lt ${CPUCores} ]; then
		echo -e "${LRED}${BOLD}ATTENTION: Due to throttling $(( ${CPUCores} - ${CPUCoresNow} )) CPU cores have been killed. Check dmesg output and the uploaded log for details.${NC}\n"
	fi

	# Check for throttling/undervoltage on Raspberry Pi
	grep -q '/1200MHz' ${MonitorLog} && Warning="ATTENTION: Throttling has occured. Check the uploaded log for details."
	if [ -f /usr/bin/vcgencmd ]; then
		Health=$(perl -e "printf \"%19b\n\", $(/usr/bin/vcgencmd get_throttled | cut -f2 -d=)" | tr -d '[:blank:]')
		case ${Health} in
			10*)
				Warning="ATTENTION: Frequency capping to 600 MHz has occured. Check the uploaded log for details."
				;;
			01*)
				Warning="ATTENTION: Throttling has occured. Check the uploaded log for details."
				;;
			11*)
				Warning="ATTENTION: Throttling and frequency capping has occured. Check the uploaded log for details."
				;;
		esac
		if [ "X${Warning}" = "X" ]; then
			echo -e "${LGREEN}It seems neither throttling nor frequency capping has occured.${NC}\n"
		else
			echo -e "${LRED}${BOLD}${Warning}${NC}\n"
		fi
	fi

	# Prepare benchmark results
	echo -e "\n##########################################################################\n" >>${ResultLog}
	cat ${MonitorLog} >>${ResultLog}
	echo -e "\n##########################################################################\n" >>${ResultLog}
	echo -e "$(iostat)\n\n$(free -h)\n\n$(swapon -s)\n\n$(lscpu)" >>${ResultLog}
	UploadURL=$(curl -s -F 'f:1=<-' ix.io <${ResultLog} 2>/dev/null || curl -s -F 'f:1=<-' ix.io <${ResultLog})

	# Display benchmark results
	[ ${CPUCores} -gt 4 ] && BigLittle=" (big.LITTLE cores measured individually)"
	echo -e "${BOLD}Memory performance${NC}${BigLittle}:"
	awk -F" " '/^ standard/ {print $2": "$4" "$5" "$6}' <${ResultLog}
	echo -e "\n${BOLD}Cpuminer total scores${NC} (5 minutes execution): $(awk -F"Total Scores: " '/^Total Scores: / {print $2}' ${ResultLog}) kH/s"
	echo -e "\n${BOLD}7-zip total scores${NC} (3 consecutive runs): $(awk -F" " '/^Total:/ {print $2}' ${ResultLog})"
	echo -e "\n${BOLD}OpenSSL results${NC}${BigLittle}:\n$(grep '^type' ${TempLog} | head -n1)"
	grep '^aes-' ${TempLog}
	if [ "X${UploadURL}" = "X" ]; then
		echo -e "\nUnable to upload full test results. Please copy&paste the below stuff to pastebin.com and\nprovide the URL. Check the output for throttling and swapping please.\n\n"
		cat ${ResultLog}
		echo -e "\n"
	else
		echo -e "\nFull results uploaded to ${UploadURL}. Please check the log for anomalies (e.g. swapping\nor throttling happenend) and otherwise share this URL.\n"
	fi
} # DisplayResults

Main "$@"