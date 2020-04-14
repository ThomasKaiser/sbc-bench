#!/bin/bash

Version=0.7.1
InstallLocation=/usr/local/src # change to /tmp if you want tools to be deleted after reboot

Main() {
	export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
	PathToMe="$( cd "$(dirname "$0")" ; pwd -P )/${0##*/}"

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

	# The following allows to use sbc-bench on real ARM devices where for
	# whatever reasons a fake /usr/bin/vcgencmd is lying around -- see for
	# an example here: https://github.com/ThomasKaiser/sbc-bench/pull/13
	if [ -z "${USE_VCGENCMD}" -a -f /usr/bin/vcgencmd ]; then
		# this seems to be a Raspberry Pi where we need to query
		# ThreadX on the VC via vcgencmd to get real information
		USE_VCGENCMD=true
	else
		USE_VCGENCMD=false
	fi
	
	# check whether we're running in monitoring or benchmark mode
	# Backwards compatibility: if 1st argument is 'neon' run cpuminer test
	[ "X$1" = "Xneon" ] && ExecuteCpuminer=yes
	while getopts 'chmtT' c ; do
		case ${c} in
			m)
				# monitoring mode
				interval=$2
				MonitorBoard
				exit 0
				;;
			c)
				# Run Cpuminer test (NEON/SSE)
				ExecuteCpuminer=yes
				;;
			h)
				# print help
				DisplayUsage
				exit 0
				;;
			t|T)
				# temperature tests sufficient for heatsink/fan and throttling settings testing
				# 2nd argument (integer in degree C) is the value we wait for the board to cool
				# down prior to next test
				TargetTemp=${2:-50}
				TempTest
				exit 0
				;;
		esac
	done

	CheckRelease
	CheckLoad
	BasicSetup >/dev/null 2>&1
	InstallPrerequisits
	InitialMonitoring
	CheckClockspeeds
	CheckTimeInState before
	RunTinyMemBench
	RunOpenSSLBenchmark
	Run7ZipBenchmark
	if [ "${ExecuteCpuminer}" = "yes" -a -x "${InstallLocation}"/cpuminer-multi/cpuminer ]; then
		RunCpuminerBenchmark
	fi
	CheckTimeInState after
	"${SevenZip}" b >/dev/null 2>&1 & # run 7-zip bench in the background
	CheckClockspeeds # test again loaded system after heating the SoC to the max
	DisplayResults
} # Main

MonitorBoard() {
	# Background monitoring

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

	CpuFreqToQuery=cpuinfo_cur_freq

	# check platform
	case $(lscpu | awk -F" " '/^Architecture/ {print $2}') in
		x86*|i686)
			IsIntel="yes"
			ln -fs /sys/devices/virtual/thermal/thermal_zone1/temp ${TempSource}
			if [ ! -f /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq} ]; then
				CpuFreqToQuery=scaling_cur_freq
			fi
			;;
	esac

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

	if [ ${USE_VCGENCMD} = true ] ; then
		DisplayHeader="Time        fake/real   load %cpu %sys %usr %nice %io %irq   Temp   VCore"
		CPUs=raspberrypi
	elif [ "${IsIntel}" = "yes" ] ; then
		DisplayHeader="Time        CPU    load %cpu %sys %usr %nice %io %irq   Temp"
		CPUs=normal
	elif [ -f /sys/devices/system/cpu/cpufreq/policy4/${CpuFreqToQuery} ]; then
		DisplayHeader="Time       big.LITTLE   load %cpu %sys %usr %nice %io %irq   Temp"
		read MaxSpeed0 </sys/devices/system/cpu/cpufreq/policy0/cpuinfo_max_freq
		read MaxSpeed4 </sys/devices/system/cpu/cpufreq/policy4/cpuinfo_max_freq
		if [ ${MaxSpeed4} -ge ${MaxSpeed0} ]; then
			CPUs=biglittle
		else
			CPUs=littlebig
		fi
	elif [ -f /sys/devices/system/cpu/cpufreq/policy2/${CpuFreqToQuery} ]; then
		# On S922X/A311D cpu0-cpu1 are littles ones, cpu2-cpu4 the big ones
		DisplayHeader="Time       big.LITTLE   load %cpu %sys %usr %nice %io %irq   Temp"
		CPUs=mesong12b
	elif [ -f /sys/devices/system/cpu/cpufreq/policy0/${CpuFreqToQuery} ]; then
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
			SocTemp=$(ReadSoCTemp)
		fi

		ProcessStats

		case ${CPUs} in
			raspberrypi)
				FakeFreq=$(awk '{printf ("%0.0f",$1/1000); }' </sys/devices/system/cpu/cpu0/cpufreq/${CpuFreqToQuery} 2>/dev/null)
				RealFreq=$(/usr/bin/vcgencmd measure_clock arm | awk -F"=" '{printf ("%0.0f",$2/1000000); }' )
				CoreVoltage=$(/usr/bin/vcgencmd measure_volts | cut -f2 -d= | sed 's/000//')
				echo -e "$(date "+%H:%M:%S"): $(printf "%4s" ${FakeFreq})/$(printf "%4s" ${RealFreq})MHz $(printf "%5s" ${LoadAvg}) ${procStats}  $(printf "%4s" ${SocTemp})°C  ${CoreVoltage}"
				;;
			biglittle)
				BigFreq=$(awk '{printf ("%0.0f",$1/1000); }' </sys/devices/system/cpu/cpufreq/policy4/${CpuFreqToQuery} 2>/dev/null)
				LittleFreq=$(awk '{printf ("%0.0f",$1/1000); }' </sys/devices/system/cpu/cpufreq/policy0/${CpuFreqToQuery} 2>/dev/null)
				echo -e "$(date "+%H:%M:%S"): $(printf "%4s" ${BigFreq})/$(printf "%4s" ${LittleFreq})MHz $(printf "%5s" ${LoadAvg}) ${procStats}  $(printf "%4s" ${SocTemp})°C"
				;;
			littlebig)
				BigFreq=$(awk '{printf ("%0.0f",$1/1000); }' </sys/devices/system/cpu/cpufreq/policy0/${CpuFreqToQuery} 2>/dev/null)
				LittleFreq=$(awk '{printf ("%0.0f",$1/1000); }' </sys/devices/system/cpu/cpufreq/policy4/${CpuFreqToQuery} 2>/dev/null)
				echo -e "$(date "+%H:%M:%S"): $(printf "%4s" ${BigFreq})/$(printf "%4s" ${LittleFreq})MHz $(printf "%5s" ${LoadAvg}) ${procStats}  $(printf "%4s" ${SocTemp})°C"
				;;
			mesong12b)
				BigFreq=$(awk '{printf ("%0.0f",$1/1000); }' </sys/devices/system/cpu/cpufreq/policy2/${CpuFreqToQuery} 2>/dev/null)
				LittleFreq=$(awk '{printf ("%0.0f",$1/1000); }' </sys/devices/system/cpu/cpufreq/policy0/${CpuFreqToQuery} 2>/dev/null)
				echo -e "$(date "+%H:%M:%S"): $(printf "%4s" ${BigFreq})/$(printf "%4s" ${LittleFreq})MHz $(printf "%5s" ${LoadAvg}) ${procStats}  $(printf "%4s" ${SocTemp})°C"
				;;
			normal)
				CpuFreq=$(awk '{printf ("%0.0f",$1/1000); }' </sys/devices/system/cpu/cpufreq/policy0/${CpuFreqToQuery} 2>/dev/null)
				echo -e "$(date "+%H:%M:%S"): $(printf "%4s" ${CpuFreq})MHz $(printf "%5s" ${LoadAvg}) ${procStats}  $(printf "%4s" ${SocTemp})°C"
				;;
			notavailable)
				echo -e "$(date "+%H:%M:%S"):   ---     $(printf "%5s" ${LoadAvg}) ${procStats}  $(printf "%4s" ${SocTemp})°C"
				;;
		esac
		sleep ${SleepInterval}
	done
} # MonitorBoard

TempTest() {
	# First check whether SoC temperature is available
	# In Armbian we can rely on /etc/armbianmonitor/datasources/soctemp
	if [ -f /etc/armbianmonitor/datasources/soctemp ]; then
		TempSource=/etc/armbianmonitor/datasources/soctemp
	else
		TempSource="$(mktemp /tmp/soctemp.XXXXXX)"
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

	SocTemp=$(ReadSoCTemp 2>/dev/null | cut -f1 -d'.')
	[ "X${SocTemp}" = "X" ] && \
		(echo -e "${LRED}${BOLD}WARNING: No temperature source found. Aborting.${NC}" >&2 ; exit 1)
	[ ${SocTemp} -lt 20 ] && \
		echo -e "${LRED}${BOLD}WARNING: sysfs thermal readout is ominously low: ${SocTemp}°C.${NC}\n" >&2

	BasicSetup
	InitialMonitoring
	echo -e "\n${BOLD}Thermal efficiency test using $(readlink "${TempSource}")${NC}"
	echo -e "\nInstalling needed tools. This may take some time...\c"

	# get/build mhz and cpuminer if not already there
	if [ ! -x "${InstallLocation}"/mhz/mhz ]; then
		cd "${InstallLocation}"
		git clone https://github.com/wtarreau/mhz >/dev/null 2>&1
		cd mhz
		make >/dev/null 2>&1
		if [ ! -x "${InstallLocation}"/mhz/mhz ]; then
			echo -e "${LRED}${BOLD}Not able to build necessary tools. Aborting.${NC}\nMost probably gcc and make packages are missing." >&2
			exit 1
		fi
	fi
	InstallCpuminer >/dev/null 2>&1
	if [ ! -x "${InstallLocation}"/cpuminer-multi/cpuminer ]; then
		echo -e "${LRED}${BOLD}WARNING: Not able to execute cpuminer. Aborting.${NC}" >&2
		exit 1
	fi

	# Start with testing
	CheckClockspeeds
	SocTemp=$(ReadSoCTemp | cut -f1 -d'.')
	echo " Done"
	case $c in
		T)
			if [ ${SocTemp} -le ${TargetTemp} ]; then
				echo -e "System health while heating up the SoC:\n" >>${MonitorLog}
				/bin/bash "${PathToMe}" -m 10 >>${MonitorLog} &
				MonitoringPID=$!
				"${InstallLocation}"/cpuminer-multi/cpuminer --benchmark --cpu-priority=2 >/dev/null &
				MinerPID=$!
				while [ ${SocTemp} -le ${TargetTemp} ]; do
					echo "Heating SoC from current ${SocTemp}°C to ${TargetTemp}°C. This may take some time..."
					printf "\x1b[1A"
					sleep 2
					SocTemp=$(ReadSoCTemp | cut -f1 -d'.')
				done
				echo -e "Heating SoC from current ${TargetTemp}°C to ${TargetTemp}°C. This may take some time...\c"
				kill ${MinerPID} ${MonitoringPID}
			else
				echo -e "Skipping heating up the SoC since already at ${SocTemp}°C\n" >>${MonitorLog}
				echo -e "No need to heat the SoC to ${TargetTemp}°C since already at ${SocTemp}°C...\c"
			fi
			;;
		t)
			if [ ${SocTemp} -gt ${TargetTemp} ]; then
				echo -e "System health while waiting for the SoC to cool down:\n" >>${MonitorLog}
				/bin/bash "${PathToMe}" -m 10 >>${MonitorLog} &
				MonitoringPID=$!
				while [ ${SocTemp} -gt ${TargetTemp} ]; do
					echo "Waiting for the SoC cooling down from current ${SocTemp}°C to ${TargetTemp}°C. This may take some time..."
					printf "\x1b[1A"
					sleep 2
					SocTemp=$(ReadSoCTemp | cut -f1 -d'.')
				done
				echo -e "Waiting for the SoC cooling down from current ${SocTemp}°C to ${TargetTemp}°C. This may take some time...\c"
				kill ${MonitoringPID}
			else
				echo -e "No need to wait for the SoC chilling since already at ${SocTemp}°C\n" >>${MonitorLog}
				echo -e "No need to wait for the SoC chilling since already at ${SocTemp}°C...\c"
			fi
			;;
	esac
	CheckTimeInState before
	RunCpuminerBenchmark
	CheckTimeInState after
	echo -e " Done.\n\007\007\007"

	# Prepare test results
	CheckForThrottling
	echo -e "\n##########################################################################\n" >>${ResultLog}
	cat ${MonitorLog} >>${ResultLog}
	[ -f ${TempDir}/throttling_info.txt ] && cat ${TempDir}/throttling_info.txt >>${ResultLog}

	cat ${ResultLog}
} # TempTest

ReadSoCTemp() {
	read RawTemp <"${TempSource}"
	if [ ${RawTemp} -ge 1000 ]; then
		RawTemp=$(awk '{printf ("%0.1f",$1/1000); }' <<<${RawTemp})
	fi
	echo -e ${RawTemp}
} # ReadSoCTemp

ProcessStats() {
	# Generate detailed usage statistics based on /proc/stat
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
	# Display warning when not executing on Debian Stretch or Ubuntu Bionic
	apt -f -qq -y install lsb-release >/dev/null 2>&1
	Distro=$(lsb_release -c | awk -F" " '{print $2}' | tr '[:upper:]' '[:lower:]')
	case ${Distro} in
		stretch|bionic|buster)
			:
			;;
		*)
			echo -e "${LRED}${BOLD}WARNING: this tool is meant to run only on Debian Stretch, Buster or Ubuntu Bionic.${NC}"
			echo -e "When running on other distros results are partially meaningless or can't be collected.\nPress [ctrl]-[c] to stop or [enter] to continue."
			read
			;;
	esac
} # CheckRelease

CheckLoad() {
	# Only continue if average load is less than 0.1
	AvgLoad1Min=$(awk -F" " '{print $1*100}' < /proc/loadavg)
	[ $AvgLoad1Min -ge 10 ] && echo -e "\nAverage load is 0.1 or higher (way too much background activity). Waiting...\n"
	while [ $AvgLoad1Min -ge 10 ]; do
		echo -e "System too busy for benchmarking:$(uptime)"
		sleep 5
		AvgLoad1Min=$(awk -F" " '{print $1*100}' < /proc/loadavg)
	done
	echo ""
} # CheckLoad

BasicSetup() {
	CPUArchitecture="$(LANG=C lscpu | awk -F" " '/^Architecture/ {print $2}')"
	case ${CPUArchitecture} in
		arm*|aarch*)
			[ -f /proc/device-tree/model ] && read DeviceName </proc/device-tree/model
			# Try to switch to performance cpufreq governor on ARM with all CPU cores
			CPUCores=$(grep -c '^processor' /proc/cpuinfo)
				for ((i=0;i<CPUCores;i++)); do
				echo performance >/sys/devices/system/cpu/cpufreq/policy${i}/scaling_governor
			done
			;;
		x86*|i686)
			# Define CPUCores as 3 to prevent big.LITTLE handling and throttling reporting
			CPUCores=3
			# Try to get device name from CPU entry
			DeviceName="$(lscpu | sed 's/ \{1,\}/ /g' | awk -F": " '/^Model name/ {print $2}')"
			;;
		*)
			echo "${CPUArchitecture} not supported. Aborting." >&2
			exit 1
			;;
	esac
} # BasicSetup

InstallPrerequisits() {
	echo -e "sbc-bench v${Version}\n\nInstalling needed tools. This may take some time...\c"
	SevenZip=$(which 7za || which 7zr)
	[ -z "${SevenZip}" ] && add-apt-repository universe >/dev/null 2>&1 ; apt -f -qq -y install p7zip >/dev/null 2>&1 && SevenZip=/usr/bin/7zr
	[ -z "${SevenZip}" ] && (echo "No 7-zip binary found and could not be installed. Aborting" >&2 ; exit 1)

	which iostat >/dev/null 2>&1 || apt -f -qq -y install sysstat >/dev/null 2>&1
	which git >/dev/null 2>&1 || apt -f -qq -y install git >/dev/null 2>&1
	which openssl >/dev/null 2>&1 || apt -f -qq -y install openssl >/dev/null 2>&1
	which curl >/dev/null 2>&1 || apt -f -qq -y install curl >/dev/null 2>&1

	# get/build tinymembench if not already there
	[ -d "${InstallLocation}" ] || mkdir -p "${InstallLocation}"
	if [ ! -x "${InstallLocation}"/tinymembench/tinymembench ]; then
		apt -f -qq -y install gcc make build-essential >/dev/null 2>&1
		cd "${InstallLocation}"
		git clone https://github.com/ssvb/tinymembench >/dev/null 2>&1
		cd tinymembench
		make >/dev/null 2>&1
		if [ ! -x "${InstallLocation}"/tinymembench/tinymembench ]; then
			echo -e "${LRED}${BOLD}Not able to build necessary tools. Aborting.${NC}\nMost probably gcc and make packages are missing." >&2
			exit 1
		fi
	fi

	# get/build mhz if not already there
	if [ ! -x "${InstallLocation}"/mhz/mhz ]; then
		cd "${InstallLocation}"
		git clone https://github.com/wtarreau/mhz >/dev/null 2>&1
		cd mhz
		make >/dev/null 2>&1
	fi

	# if called with -c or as 'sbc-bench neon' we also use cpuminer
	if [ "${ExecuteCpuminer}" = "yes" ]; then
		InstallCpuminer >/dev/null 2>&1
	fi
} # InstallPrerequisits

InstallCpuminer() {
	# get/build cpuminer if not already there
	if [ ! -x "${InstallLocation}"/cpuminer-multi/cpuminer ]; then
		cd "${InstallLocation}"
		apt-get -f -qq -y install automake autoconf pkg-config libcurl4-openssl-dev libjansson-dev libssl-dev libgmp-dev make g++ zlib1g-dev >/dev/null 2>&1
		git clone https://github.com/tkinjo1985/cpuminer-multi.git
		cd cpuminer-multi/
		./build.sh
	fi
	if [ ! -x "${InstallLocation}"/cpuminer-multi/cpuminer ]; then
		echo -e " (can't build cpuminer)\c"
	fi
} # InstallCpuminer

InitialMonitoring() {
	# log benchmark start in dmesg output
	echo "sbc-bench started" >/dev/kmsg

	# Create temporary files
	TempDir="$(mktemp -d /tmp/${0##*/}.XXXXXX)"
	TempLog="${TempDir}/temp.log"
	ResultLog="${TempDir}/results.log"
	MonitorLog="${TempDir}/monitor.log"
	trap "rm -rf \"${TempDir}\" ; exit 0" 0 1 2 3 15

	# Log version and device info
	echo -e "sbc-bench v${Version} ${DeviceName} ($(date -R))\n" >${ResultLog}

	# Log distribution info
	[ -f /etc/armbian-release ] && . /etc/armbian-release
	which lsb_release >/dev/null 2>&1 && (lsb_release -a 2>/dev/null) >>${ResultLog}
	if [ -n "${BOARDFAMILY}" ]; then
		echo -e "\nArmbian release info:\n$(grep -v "#" /etc/armbian-release)" >>${ResultLog}
	else
		ARCH=$(dpkg --print-architecture 2>/dev/null) || \
			ARCH=$(awk -F"=" '/^CARCH/ {print $2}' /etc/makepkg.conf 2>/dev/null) || \
			ARCH="unknown/$(uname -m)"
		echo -e "Architecture:\t$(tr -d '"' <<<${ARCH})" >>${ResultLog}
	fi

	# On Raspberries we also collect 'firmware' information:
	if [ ${USE_VCGENCMD} = true ] ; then
		echo -e "\nRaspberry Pi ThreadX version:\n$(/usr/bin/vcgencmd version)" >>${ResultLog}
		[ -f /boot/config.txt ] && echo -e "\nThreadX configuration (/boot/config.txt):\n$(grep -v '#' /boot/config.txt | sed '/^\s*$/d')" >>${ResultLog}
		echo -e "\nActual ThreadX settings:\n$(vcgencmd get_config int)" >>${ResultLog}
	fi

	# Log gcc version
	echo -e "\n$(which gcc) $(gcc --version | sed 's/gcc\ //' | head -n1)" >>${ResultLog}

	# Some basic system info needed to interpret system health later
	echo -e "\nUptime:$(LANG=C uptime)\n\n$(LANG=C iostat)\n\n$(LANG=C free -h)\n\n$(LANG=C swapon -s)" >>${ResultLog}
} # InitialMonitoring

CheckClockspeeds() {
	echo -e " Done.\nChecking cpufreq OPP...\c"
	echo -e "\n##########################################################################" >>${ResultLog}
	if [ -f ${MonitorLog} ]; then
		# 2nd check after most demanding benchmark has been run.
		echo -e "\nTesting clockspeeds again. System health now:\n" >>${ResultLog}
		grep 'Time' ${MonitorLog} | tail -n 1 >"${TempDir}/systemhealth.now" >>${ResultLog}
		grep ':' ${MonitorLog} | tail -n 1 >>"${TempDir}/systemhealth.now" >>${ResultLog}
	fi
	if [ "X${BOARDFAMILY}" = "Xs5p6818" -o ${CPUCores} -le 4 ]; then
		# no big.LITTLE, checking cluster 0 is sufficient
		echo -e "\nChecking cpufreq OPP:\n" >>${ResultLog}
		CheckCPUCluster 0 >>${ResultLog}
	else
		# big.LITTLE or something else (Amlogic S912)
		if [ -f /sys/devices/system/cpu/cpufreq/policy4/scaling_available_frequencies ]; then
			echo -e "\nChecking cpufreq OPP for cpu0-cpu3:\n" >>${ResultLog}
			CheckCPUCluster 0 >>${ResultLog}
			echo -e "\nChecking cpufreq OPP for cpu4-cpu$(( ${CPUCores} - 1 )):\n" >>${ResultLog}
			CheckCPUCluster 4 >>${ResultLog}
		elif [ -f /sys/devices/system/cpu/cpufreq/policy2/scaling_available_frequencies ]; then
			# Amlogic S922X/A311D
			echo -e "\nChecking cpufreq OPP for cpu0-cpu1:\n" >>${ResultLog}
			CheckCPUCluster 0 >>${ResultLog}
			echo -e "\nChecking cpufreq OPP for cpu2-cpu$(( ${CPUCores} - 1 )):\n" >>${ResultLog}
			CheckCPUCluster 2 >>${ResultLog}
		fi
	fi
} # CheckClockspeeds

CheckTimeInState() {
	# Check cpufreq statistics prior and after benchmark to detect throttling (won't work
	# with all kernels and especially not on the RPi since RPi Trading people are cheating.
	# Cpufreq support via sysfs is bogus and with latest ThreadX (firmware) update they
	# even cheat wrt querying the 'firmware' via 'vcgencmd get_throttled':
	# https://www.raspberrypi.org/forums/viewtopic.php?f=63&t=217056#p1334921

	find /sys -type f -name time_in_state | sort | grep 'cpufreq' | while read ; do
		StatFile="${REPLY}"
		Number=$(echo ${StatFile} | tr -c -d '[:digit:]')
		read MaxSpeed </sys/devices/system/cpu/cpufreq/policy${Number}/cpuinfo_max_freq
		sort -n <${StatFile} | while read ; do
			Cpufreq=$(awk '{print $1}' <<<${REPLY})
			if [ ${Cpufreq} -lt ${MaxSpeed} ]; then
				echo ${REPLY} >>${TempDir}/time_in_state_${1}_${Number}
				echo ${REPLY} >>${TempDir}/full_time_in_state_${1}_${Number}
			elif [ ${Cpufreq} -le ${MaxSpeed} ]; then
				echo ${REPLY} >>${TempDir}/full_time_in_state_${1}_${Number}
			fi
		done
	done
} # CheckTimeInState

CheckCPUCluster() {
	# check whether there's cpufreq support or not
	if [ -f /sys/devices/system/cpu/cpufreq/policy${1}/scaling_available_frequencies ]; then
		# walk through all cpufreq OPP and report clockspeeds (kernel vs. measured)
		read MinSpeed </sys/devices/system/cpu/cpufreq/policy${1}/cpuinfo_min_freq
		read MaxSpeed </sys/devices/system/cpu/cpufreq/policy${1}/cpuinfo_max_freq
		echo ${MinSpeed} >/sys/devices/system/cpu/cpufreq/policy${1}/scaling_min_freq
		for i in $(tr " " "\n" </sys/devices/system/cpu/cpufreq/policy${1}/scaling_available_frequencies | sort -n -r) ; do
			echo ${i} >/sys/devices/system/cpu/cpufreq/policy${1}/scaling_max_freq
			sleep 0.1
			RealSpeed=$(taskset -c $1 "${InstallLocation}"/mhz/mhz 3 100000 | awk -F" cpu_MHz=" '{print $2}' | awk -F" " '{print $1}' | tr '\n' '/' | sed 's|/$||')
			SysfsSpeed=$(( $i / 1000 ))
			if [ ${USE_VCGENCMD} = true ] ; then
				# On RPi we query ThreadX about clockspeeds too
				ThreadXFreq=$(/usr/bin/vcgencmd measure_clock arm | awk -F"=" '{printf ("%0.0f",$2/1000000); }' )
				echo -e "Cpufreq OPP: $(printf "%4s" ${SysfsSpeed})    ThreadX: $(printf "%4s" ${ThreadXFreq})    Measured: ${RealSpeed}"
			else
				echo -e "Cpufreq OPP: $(printf "%4s" ${SysfsSpeed})    Measured: ${RealSpeed}"
			fi
		done
		echo ${MaxSpeed} >/sys/devices/system/cpu/cpufreq/policy${1}/scaling_max_freq
	else
		# no cpufreq support
		RealSpeed=$(taskset -c $(( $1 + 1 )) "${InstallLocation}"/mhz/mhz 3 1000000 | awk -F" cpu_MHz=" '{print $2}' | awk -F" " '{print $1}' | tr '\n' '/' | sed 's|/$||')
		echo -e "No cpufreq support available. Measured on cpu$(( $1 + 1 )): ${RealSpeed}"
	fi
} # CheckCPUCluster

RunTinyMemBench() {
	echo -e " Done.\nExecuting tinymembench. This will take a long time...\c"
	echo -e "System health while running tinymembench:\n" >${MonitorLog}
	/bin/bash "${PathToMe}" -m 120 >>${MonitorLog} &
	MonitoringPID=$!
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
	/bin/bash "${PathToMe}" -m 60 >>${MonitorLog} &
	MonitoringPID=$!
	if [ ${CPUCores} -eq 1 ]; then
		# Do not measure single threaded result since useless
		:
	elif [ ${CPUCores} -gt 4 ]; then
		if [ "X${BOARDFAMILY}" = "Xs5p6818" ]; then
			# S5P6816 octa-core SoC is not a big.LITTLE design
			taskset -c 0 "${SevenZip}" b -mmt 1 >>${TempLog}
		else
			# big.LITTLE SoC, we execute one time on a little and one time on a big core
			taskset -c 0 "${SevenZip}" b -mmt 1 >>${TempLog}
			taskset -c $(( ${CPUCores} - 1 )) "${SevenZip}" b -mmt 1 >>${TempLog}
		fi
	else
		taskset -c 0 "${SevenZip}" b -mmt 1 >>${TempLog}
	fi
	kill ${MonitoringPID}
	echo -e "\n##########################################################################" >>${ResultLog}
	cat ${TempLog} >>${ResultLog}
	echo -e "\nSystem health while running 7-zip multi core benchmark:\n" >>${MonitorLog}
	echo -e "\c" >${TempLog}
	/bin/bash "${PathToMe}" -m 20 >>${MonitorLog} &
	MonitoringPID=$!
	RunHowManyTimes=3
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
	/bin/bash "${PathToMe}" -m 10 >>${MonitorLog} &
	MonitoringPID=$!
	OpenSSLLog="${TempDir}/openssl.log"
	for i in 128 192 256 ; do
		if [ ${CPUCores} -gt 4 ]; then
			# big.LITTLE SoC, we execute one time on a little and one time on a big core
			taskset -c 0 openssl speed -elapsed -evp aes-${i}-cbc 2>/dev/null
			taskset -c $(( ${CPUCores} -1 )) openssl speed -elapsed -evp aes-${i}-cbc 2>/dev/null
		else
			openssl speed -elapsed -evp aes-${i}-cbc 2>/dev/null
			openssl speed -elapsed -evp aes-${i}-cbc 2>/dev/null
		fi
	done >${OpenSSLLog}
	kill ${MonitoringPID}
	echo -e "\n##########################################################################\n" >>${ResultLog}
	echo -e "$(openssl version | awk -F" " '{print $1" "$2", built on "$3" "$4" "$5" "$6" "$7" "$8" "$9" "$10" "$11" "$12" "$13" "$14" "$15}' | sed 's/ *$//')\n$(grep '^type' ${OpenSSLLog} | head -n1)" >>${ResultLog}
	grep '^aes-' ${OpenSSLLog} >>${ResultLog}
} # RunOpenSSLBenchmark

RunCpuminerBenchmark() {
	echo -e " Done.\nExecuting cpuminer. This will take 5 minutes...\c"
	echo -e "\nSystem health while running cpuminer:\n" >>${MonitorLog}
	/bin/bash "${PathToMe}" -m 20 >>${MonitorLog} &
	MonitoringPID=$!
	"${InstallLocation}"/cpuminer-multi/cpuminer --benchmark --cpu-priority=2 >${TempLog} &
	MinerPID=$!
	sleep 300
	kill ${MinerPID} ${MonitoringPID}
	echo -e "\n##########################################################################\n" >>${ResultLog}
	sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" <${TempLog} >>${ResultLog}
	# Summarized 'Total:' scores
	TotalScores="$(awk -F" " '/Total:/ {print $4}' ${TempLog} | sort -r -n | uniq | tr '\n' ', ' | sed 's/,$//')"
	echo -e "\nTotal Scores: ${TotalScores}" >>${ResultLog}
} # RunCpuminerBenchmark

DisplayResults() {
	echo -e " Done.\n\007\007\007"

	CheckForThrottling

	# Prepare benchmark results
	echo -e "\n##########################################################################\n" >>${ResultLog}
	cat ${MonitorLog} >>${ResultLog}
	[ -f ${TempDir}/throttling_info.txt ] && cat ${TempDir}/throttling_info.txt >>${ResultLog}

	# add dmesg output since start of the benchmark if something relevant is there
	TimeStamp="$(dmesg | tr -d '[' | tr -d ']' | awk -F" " '/sbc-bench started/ {print $1}' | tail -n1)"
	dmesg | sed "/${TimeStamp}/,\$!d" | grep -v 'sbc-bench started' >"${TempDir}/dmesg"
	if [ -s "${TempDir}/dmesg" ]; then
		echo -e "\n##########################################################################\n\ndmesg output while running the benchmarks:\n" >>${ResultLog}
		cat "${TempDir}/dmesg" >>${ResultLog}
	fi

	echo -e "\n##########################################################################\n" >>${ResultLog}
	echo -e "$(LANG=C iostat)\n\n$(LANG=C free -h)\n\n$(LANG=C swapon -s)\n\n$(LANG=C lscpu)" >>${ResultLog}
	ReportCacheSizes >>${ResultLog}
	UploadURL=$(curl -s -F 'f:1=<-' ix.io <${ResultLog} 2>/dev/null || curl -s -F 'f:1=<-' ix.io <${ResultLog})

	# Display benchmark results
	[ ${CPUCores} -gt 4 ] && BigLittle=" (big.LITTLE cores measured individually)"
	echo -e "${BOLD}Memory performance${NC}${BigLittle}:"
	awk -F" " '/^ standard/ {print $2": "$4" "$5" "$6}' <${ResultLog}
	if [ "${ExecuteCpuminer}" = "yes" -a -x "${InstallLocation}"/cpuminer-multi/cpuminer ]; then
		echo -e "\n${BOLD}Cpuminer total scores${NC} (5 minutes execution): $(awk -F"Total Scores: " '/^Total Scores: / {print $2}' ${ResultLog}) kH/s"
	fi
	echo -e "\n${BOLD}7-zip total scores${NC} (3 consecutive runs): $(awk -F" " '/^Total:/ {print $2}' ${ResultLog})"
	echo -e "\n${BOLD}OpenSSL results${NC}${BigLittle}:\n$(grep '^type' ${OpenSSLLog} | head -n1)"
	grep '^aes-' ${OpenSSLLog}
	if [ "X${UploadURL}" = "X" ]; then
		echo -e "\nUnable to upload full test results. Please copy&paste the below stuff to pastebin.com and\nprovide the URL. Check the output for throttling and swapping please.\n\n"
		cat ${ResultLog}
		echo -e "\n"
	else
		echo -e "\nFull results uploaded to ${UploadURL}. Please check the log for anomalies (e.g. swapping\nor throttling happenend) and otherwise share this URL.\n"
	fi
} # DisplayResults

CheckForThrottling() {
	# Check for throttling on normal ARM SBC
	find /sys -type f -name time_in_state | sort | grep 'cpufreq' | while read ; do
		Number=$(echo ${REPLY} | tr -c -d '[:digit:]')
		diff ${TempDir}/time_in_state_after_${Number} ${TempDir}/time_in_state_before_${Number} >/dev/null 2>&1
		if [ $? -ne 0 ]; then
			case ${CPUCores} in
				1|2|4)
					ReportCpufreqStatistics ${Number}
					echo -e "${LRED}${BOLD}ATTENTION: Throttling might have occured. Check the log for details.${NC}\n"
					;;
				6)
					if [ ${Number} -eq 0 ]; then
						ReportCpufreqStatistics ${Number} " for CPUs 0-3"
						echo -e "${LRED}${BOLD}ATTENTION: Throttling might have occured on CPUs 0-3. Check the log for details.${NC}\n"
					else
						ReportCpufreqStatistics ${Number} " for CPUs 4-5"
						echo -e "${LRED}${BOLD}ATTENTION: Throttling might have occured on CPUs 4-5. Check the log for details.${NC}\n"
					fi
					;;
				8)
					if [ "X${BOARDFAMILY}" = "Xs5p6818" ]; then
						ReportCpufreqStatistics ${Number}
						echo -e "${LRED}${BOLD}ATTENTION: Throttling might have occured. Check the log for details.${NC}\n"
					elif [ ${Number} -eq 0 ]; then
						ReportCpufreqStatistics ${Number} " for CPUs 0-3"
						echo -e "${LRED}${BOLD}ATTENTION: Throttling might have occured on CPUs 0-3. Check the log for details.${NC}\n"
					else
						ReportCpufreqStatistics ${Number} " for CPUs 4-7"
						echo -e "${LRED}${BOLD}ATTENTION: Throttling might have occured on CPUs 4-7. Check the log for details.${NC}\n"
					fi
					;;
			esac
		fi
	done

	# Check for killed CPU cores. Some unfortunate users might still use Allwinner BSP kernels
	CPUCoresNow=$(grep -c '^processor' /proc/cpuinfo)
	if [ ${CPUCoresNow} -lt ${CPUCores} ]; then
		echo -e "${LRED}${BOLD}ATTENTION: Due to overheating prevention $(( ${CPUCores} - ${CPUCoresNow} )) CPU cores have been killed. Check the log for details.${NC}\n"
	fi

	# Check for throttling/undervoltage on Raspberry Pi
	grep -q '/1200MHz' ${MonitorLog} && Warning="ATTENTION: Silent throttling has occured. Check the log for details."
	if [ ${USE_VCGENCMD} = true ] ; then
		Health="$(perl -e "printf \"%19b\n\", $(/usr/bin/vcgencmd get_throttled | cut -f2 -d=)" | tr -d '[:blank:]')"
		# https://forum.armbian.com/topic/7763-benchmarking-cpus/?do=findComment&comment=59042
		HealthLength=$(wc -c <<<"${Health}")
		[ ${HealthLength} -eq 19 ] && Health="0${Health}"
		case ${Health} in
			10*)
				Warning="ATTENTION: Frequency capping to 600 MHz has occured. Check the log for details."
				ReportRPiHealth ${Health} >>${TempDir}/throttling_info.txt
				;;
			01*)
				Warning="ATTENTION: Throttling has occured. Check the log for details."
				ReportRPiHealth ${Health} >>${TempDir}/throttling_info.txt
				;;
			11*)
				Warning="ATTENTION: Throttling and frequency capping has occured. Check the log for details."
				ReportRPiHealth ${Health} >>${TempDir}/throttling_info.txt
				;;
		esac
		if [ "X${Warning}" = "X" ]; then
			echo -e "${LGREEN}It seems neither throttling nor frequency capping has occured.${NC}\n"
		else
			echo -e "${LRED}${BOLD}${Warning}${NC}\n"
		fi
	fi
} # CheckForThrottling

ReportCpufreqStatistics() {
	# Displays cpufreq driver statistics from before and after the benchmark as comparison
	if [ -f ${TempDir}/full_time_in_state_before_${1} ]; then
		echo -e "\nThrottling statistics (time spent on each cpufreq OPP)${2}:\n" >>${TempDir}/throttling_info.txt
		awk -F" " '{print $1}' <${TempDir}/full_time_in_state_before_${1} | sort -r -n | while read ; do
			BeforeValue=$(awk -F" " "/^${REPLY}/ {print \$2}" <${TempDir}/full_time_in_state_before_${1})
			AfterValue=$(awk -F" " "/^${REPLY}/ {print \$2}" <${TempDir}/full_time_in_state_after_${1})
			if [ ${AfterValue} -eq ${BeforeValue} ]; then
				Duration=0
			else
				Duration=$(awk '{printf ("%0.2f",$1/100); }' <<<$(( ${AfterValue} - ${BeforeValue} )) )
			fi
			echo -e "$(printf "%4s" $(( ${REPLY} / 1000 )) ) MHz: $(printf "%7s" ${Duration}) sec" >>${TempDir}/throttling_info.txt
		done
	fi
} # ReportCpufreqStatistics

ReportRPiHealth() {
	# Displaying the 'vcgencmd get_throttled' output in an understandable way
	echo -e "\nQuerying ThreadX on RPi for thermal or undervoltage issues:\n\n${1}"
	cat <<-EOF
	|||             |||_ under-voltage
	|||             ||_ currently throttled
	|||             |_ arm frequency capped
	|||_ under-voltage has occurred since last reboot
	||_ throttling has occurred since last reboot
	|_ arm frequency capped has occurred since last reboot
	EOF
} # ReportRPiHealth

ReportCacheSizes() {
	find /sys/devices/system/cpu -name "cache" -type d | sort -n | while read ; do
		find "${REPLY}" -name size -type f | while read ; do
			echo -e "\n${REPLY}: $(cat ${REPLY})\c"
			[ -f ${REPLY%/*}/level ] && echo -e ", level: $(cat ${REPLY%/*}/level)\c"
			[ -f ${REPLY%/*}/type ] && echo -e ", type: $(cat ${REPLY%/*}/type)\c"
		done
	done
} # ReportCacheSizes

DisplayUsage() {
	echo -e "Usage: ${BOLD}${0##*/} [-c] [-h] [-m] [-t \$degree] [-T \$degree]${NC}\n"
	echo -e "############################################################################"
	echo -e "\n Use ${BOLD}${0##*/}${NC} for the following tasks:\n"
	echo -e " ${0##*/} invoked without arguments runs a standard benchmark"
	echo -e " ${0##*/} ${BOLD}-c${NC} also executes cpuminer test (NEON/SSE)"
	echo -e " ${0##*/} ${BOLD}-h${NC} displays this help text"
	echo -e " ${0##*/} ${BOLD}-m${NC} [\$seconds] provides CLI monitoring (5 sec default interval)"
	echo -e " ${0##*/} ${BOLD}-t${NC} [\$degree] runs thermal test waiting to cool down to this value"
	echo -e " ${0##*/} ${BOLD}-T${NC} [\$degree] runs thermal test heating up to this value\n"
	echo -e "############################################################################\n"
} # DisplayUsage

Main "$@"
