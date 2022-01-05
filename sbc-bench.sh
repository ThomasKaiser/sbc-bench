#!/bin/bash

Version=0.9.1
InstallLocation=/usr/local/src # change to /tmp if you want tools to be deleted after reboot

Main() {
	export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
	PathToMe="$( cd "$(dirname "$0")" ; pwd -P )/${0##*/}"
	unset LC_ALL LC_MESSAGES LANGUAGE LANG # prevent localisation of decimal points and other stuff

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
	while getopts 'chmtTpN' c ; do
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
			p)
				# plot performance chart instead of doing standard 7-zip benchmarks, thereby
				# walking through different cpufreq OPP. An additional parameter in taskset's
				# --cpu-list format can be provided, eg. '-p 0' to graph only cpu0 or '-p 4'
				# to graph only cpu4 (which might be an A72 on big.LITTLE systems). Mixing
				# CPUs from different clusters (e.g. '-p 0,4' on a RK3399) will result in
				# garbage since big and little cores have other cpufreq OPP.
				# 3 special modes exist: cores, clusters and all.
				# * '-p cores' will test single-threaded through cluster's cores (0 and 4 on
				#   RK3399, 0 and 2 on S922X and so on)
				# * '-p clusters' tests all cores of each cluster (0-3 and 4-5 on RK3399,
				#   0-1 and 2-5 on S922X and so on)
				# * '-p all' performs both tests from above and then runs the test on all
				#   cores as well. This will take ages.
				PlotCpufreqOPPs=yes
				CPUList=${2}
				[ "X${CPUList}" = "X" -o "X${CPUList}" = "Xall" -o "X${CPUList}" = "Xcores" -o "X${CPUList}" = "Xclusters" ] \
					|| taskset -c ${CPUList} echo "foo" >/dev/null 2>&1
				if [ $? -ne 0 ]; then
					echo -e "\nInvalid option \"-p ${CPUList}\". Please check taskset manual page for --cpu-list format" >&2
					DisplayUsage
					exit 1
				fi
				;;
			N)
				# internal Netio monitor mode. Do not use this unless you really know
				# what you're doing. Requires enabled 'XML API' on your device (read-only
				# w/o password: https://www.netio-products.com/en/glossary/xml-over-https)
				# Needs address/name and socket number and a file where results will be
				# written to. For example '-N powerbox-1.local 2 /tmp/my-consumption' if
				# your Netio device is accessible as powerbox-1.local, this device is 
				# plugged into its 2nd socket and you want consumption to be written to
				# /tmp/my-consumption where it can be picked up by tools like RPi Monitor.
				# The last 2 arguments are optional: sleep time (defaults to 0.8) and
				# count of samples (defaults to 30). The defaults already put significant
				# load on the device (compare http://ix.io/3E91 and http://ix.io/3Ebd) so
				# to monitor idle consumption better choose 5 and 30 and deal with a 150
				# seconds average value.
				MonitorNetio "$2" "$3" "$4" "$5" "$6"
				exit 0
				;;
			esac
	done

	CheckRelease
	CheckLoad
	[ -f /sys/devices/system/cpu/cpufreq/policy0/scaling_governor ] && \
		read OriginalCPUFreqGovernor </sys/devices/system/cpu/cpufreq/policy0/scaling_governor 2>/dev/null
	BasicSetup performance >/dev/null 2>&1
	GetTempSensor
	InstallPrerequisits
	InitialMonitoring
	CheckClockspeedsAndSensors
	CheckTimeInState before
	if [ "${PlotCpufreqOPPs}" = "yes" ]; then
		PlotPerformanceGraph
	else
		CheckNetio
		RunTinyMemBench
		RunOpenSSLBenchmark
		Run7ZipBenchmark
		if [ "${ExecuteCpuminer}" = "yes" -a -x "${InstallLocation}"/cpuminer-multi/cpuminer ]; then
			RunCpuminerBenchmark
		fi
	fi
	CheckTimeInState after
	"${SevenZip}" b >/dev/null 2>&1 & # run 7-zip bench in the background
	CheckClockspeedsAndSensors # test again loaded system after heating the SoC to the max
	SummarizeResults
	UploadResults
	BasicSetup ${OriginalCPUFreqGovernor} >/dev/null 2>&1
} # Main

GetARMCore() {
	grep "${1}/${2}:" <<<"41:Arm
	41/810:ARM810
	41/920:ARM920
	41/922:ARM922
	41/926:ARM926
	41/940:ARM940
	41/946:ARM946
	41/966:ARM966
	41/a20:ARM1020
	41/a22:ARM1022
	41/a26:ARM1026
	41/b02:ARM11 MPCore
	41/b36:ARM1136
	41/b56:ARM1156
	41/b76:ARM1176
	41/c05:Cortex-A5
	41/c07:Cortex-A7
	41/c08:Cortex-A8
	41/c09:Cortex-A9
	41/c0d:Cortex-A17
	41/c0f:Cortex-A15
	41/c0e:Cortex-A17
	41/c14:Cortex-R4
	41/c15:Cortex-R5
	41/c17:Cortex-R7
	41/c18:Cortex-R8
	41/c20:Cortex-M0
	41/c21:Cortex-M1
	41/c23:Cortex-M3
	41/c24:Cortex-M4
	41/c27:Cortex-M7
	41/c60:Cortex-M0+
	41/d01:Cortex-A32
	41/d03:Cortex-A53
	41/d04:Cortex-A35
	41/d05:Cortex-A55
	41/d07:Cortex-A57
	41/d08:Cortex-A72
	41/d09:Cortex-A73
	41/d0a:Cortex-A75
	41/d0b:Cortex-A76
	41/d0c:Neoverse-N1
	41/d0d:Cortex-A77
	41/d0e:Cortex-A76AE
	41/d13:Cortex-R52
	41/d20:Cortex-M23
	41/d21:Cortex-M33
	41/d22:Cortex-M55
	41/d41:Cortex-A78
	41/d42:Cortex-A78AE
	41/d4a:Neoverse-E1
	41/d4b:Cortex-A78C
	42:Broadcom
	42/00f:Broadcom Brahma B15
	42/100:Broadcom Brahma B53
	42/516:Broadcom ThunderX2
	43:Cavium
	43/0a0:Cavium ThunderX
	43/0a1:Cavium ThunderX 88XX
	43/0a2:Cavium ThunderX 81XX
	43/0a3:Cavium ThunderX 83XX
	43/0af:Cavium ThunderX2 99xx
	44:DEC
	44/a10:DEC SA110
	44/a11:DEC SA1100
	46:Fujitsu
	46/001:A64FX
	48:HiSilicon
	48/d01:Kunpeng-920
	49:Infineon
	4d:Motorola/Freescale
	4e:NVidia
	4e/000:NVidia Denver
	4e/003:NVidia Denver 2
	4e/004:NVidia Carmel
	50:APM
	50/000:APM X-Gene
	51:Qualcomm
	51/00f:Qualcomm Scorpion
	51/02d:Qualcomm Scorpion
	51/04d:Qualcomm Krait
	51/06f:Qualcomm Krait
	51/201:Qualcomm Kryo
	51/205:Qualcomm Kryo
	51/211:Qualcomm Kryo
	51/800:Qualcomm Falkor V1/Kryo
	51/801:Qualcomm Kryo V2
	51/c00:Qualcomm Falkor
	51/c01:Qualcomm Saphira
	53:Samsung
	53/001:Samsung Exynos-m1
	56:Marvell
	56/131:Marvell Feroceon 88FR131
	56/581:Marvell PJ4/PJ4b
	56/584:Marvell PJ4B-MP
	61:Apple
	61/022:Apple Icestorm
	61/023:Apple Firestorm
	66:Faraday
	66/526:Faraday FA526
	66/626:Faraday FA626
	69:Intel
	69/200:Intel i80200
	69/210:Intel PXA250A
	69/212:Intel PXA210A
	69/242:Intel i80321-400
	69/243:Intel i80321-600
	69/290:Intel PXA250B/PXA26x
	69/292:Intel PXA210B
	69/2c2:Intel i80321-400-B0
	69/2c3:Intel i80321-600-B0
	69/2d0:Intel PXA250C/PXA255/PXA26x
	69/2d2:Intel PXA210C
	69/411:Intel PXA27x
	69/41c:Intel IPX425-533
	69/41d:Intel IPX425-400
	69/41f:Intel IPX425-266
	69/682:Intel PXA32x
	69/683:Intel PXA930/PXA935
	69/688:Intel PXA30x
	69/689:Intel PXA31x
	69/b11:Intel SA1110
	69/c12:Intel IPX1200
	70:Phytium
	70/660:Phytium FTC660
	70/661:Phytium FTC661
	70/662:Phytium FTC662
	70/663:Phytium FTC663
	c0:Ampere" | cut -f2 -d:
} # GetARMCore

GetCPUType() {
	# function that returns name of ARM cores
	# $1 is the CPU in question, 1st CPU is always cpu0
	if [ -n "${ARMTypes}" ]; then
		GetARMCore "${ARMTypes[$(( $1 * 2 ))]}" "${ARMTypes[$(( $(( $1 * 2 )) + 1 ))]}"
	fi
} # GetCPUType

GetCPUInfo() {
	# function that returns ARM core type in brackets if possible otherwise empty string
	ARMCore="$(GetCPUType $1)"
	[ -n "${ARMCore}" ] && echo -n " (${ARMCore})"
} # GetCPUInfo

GetLastClusterCore() {
	NextCore=${ClusterConfig:$1:1}
	[ "${NextCore}" = "" ] && NextCore=${CPUCores}
	echo -n $(( ${NextCore} - 1 ))
} # GetLastClusterCore

BashBench(){
	# quick integer performance assessment using a simple bash loop.
	# Depends not only on CPU performance but also on bash version.
	#
	# 5.0.17 / E5-2665 @ 2.40GHz:          147485025
	# 4.4.20 / Xeon Silver 4110 @ 3.00GHz:  64434988
	# 5.0.3  / Xeon Silver 4110 @ 3.00GHz:  38958875
	# 5.0.17 / N5100 @ 2.8GHz:              56864747
	# 4.4.20 / Allwinner H3:               566944214
	# 5.0.3  / BCM2711:                    152325522
	# 5.0.17 / Apple Firestorm:             28319838
	StartTime=$(date +"%s%N")
	i=0
	while [ $i -lt 10000 ]
	do
		((i++))
	done
	FinishedTime=$(date +"%s%N")
	RawTime=$(( ${FinishedTime} - ${StartTime} ))
	case ${BASH_VERSION} in
		5.*)
			# multiply by 1.2 since this version seems faster
			awk '{printf ("%0.0f",$1*1.2); }' <<<${RawTime}
			;;
		*)
			echo -n ${RawTime}
			;;
	esac
} # BashBench

PlotPerformanceGraph() {
	# function that walks through all cpufreq OPP and plots a performance graph using
	# 7-ZIP MIPS. Needs gnuplot and htmldoc (Debian/Ubuntu: gnuplot-nox htmldoc packages)

	if [ ! -f /sys/devices/system/cpu/cpufreq/policy0/scaling_governor ]; then
		# no cpufreq support -> no way to test through different clockspeeds. Stop
		echo -e " Done.\nNo cpufreq support available. Not able to draw performance graph(s)."
		exit 1
	fi

	# repeat every measurement this many times and do not measure any cpufreq below
	Repetitions=3 # how many times should each measurement be repeated
	SkipBelow=400 # minimum cpufreq in MHz to measure

	if [ -n "${OutputCurrent}" ]; then
		# We are in Netio monitoring mode, so measure idle consumption first,
		# set CPUs to lowest clockspeed
		for i in $(ls /sys/devices/system/cpu/cpufreq/policy?/scaling_governor); do
			echo powersave >${i}
		done

		NetioConsumptionFile="${TempDir}/netio.current"
		echo -n $(( $(awk '{printf ("%0.0f",$1/10); }' <<<"${OutputCurrent[$(( ${NetioSocket} - 1 ))]}" ) * 10 )) >"${NetioConsumptionFile}"
		export NetioConsumptionFile
		/bin/bash "${PathToMe}" -N ${NetioDevice} ${NetioSocket} ${NetioConsumptionFile} "4.8" "30" >/dev/null 2>&1 &
		NetioMonitoringPID=$!

		echo -e "\x08\x08 Done.\nTrying to determine idle consumption...\c"
		echo -e "System health while idling for 4 minutes:\n" >>${MonitorLog}
		/bin/bash "${PathToMe}" -m 30 >>${MonitorLog} &
		MonitoringPID=$!

		sleep 240
		read IdleConsumption <${NetioConsumptionFile}
		kill ${NetioMonitoringPID} ${MonitoringPID}
		IdleTemp=$(ReadSoCTemp)
		echo -e "\n##########################################################################\n\nIdle temperature: ${IdleTemp}°C, idle consumption: $(( $(awk '{printf ("%0.0f",$1/10); }' <<<"${IdleConsumption}" ) * 10 ))mW" >>${ResultLog}
	fi
	
	# ramp up CPU clockspeeds and continue with normal consumption monitoring
	for i in $(ls /sys/devices/system/cpu/cpufreq/policy?/scaling_governor); do
		echo performance >${i}
	done
	CheckNetio

	# check if cpulist parameter has been provided as well:
	if [ "X${CPUList}" = "X" ]; then
		# -p has been used without further restrictions, we run performance test on all cores
		CheckPerformance "all CPU cores" ${ClusterConfig}
		PlotGraph "all CPU cores" ${ClusterConfig}
		RenderPDF
	else
		# -p with additional options has been called
		case ${CPUList} in
			cores)
				# check each core of every cluster, on RK3399 for example 0 and 4
				for i in $(seq 0 $(( ${#ClusterConfig} -1 )) ) ; do
					FirstCore=${ClusterConfig:$i:1}
					CheckPerformance "CPU ${FirstCore}" "${FirstCore}" "${FirstCore}"
					CPUInfo="$(GetCPUInfo ${FirstCore})"
					PlotGraph "CPU ${FirstCore}${CPUInfo}" "${FirstCore}"
				done
				RenderPDF
				;;
			clusters)
				# check all cores of every cluster, on RK3399 for example 0-3 and 4-5
				for i in $(seq 0 $(( ${#ClusterConfig} -1 )) ) ; do
					FirstCore=${ClusterConfig:$i:1}
					LastCore=$(GetLastClusterCore $(( $i + 1 )))
					CheckPerformance "CPU ${FirstCore}-${LastCore}" "${FirstCore}" "${FirstCore}-${LastCore}"
					CPUInfo="$(GetCPUInfo ${FirstCore})"
					PlotGraph "CPU ${FirstCore}-${LastCore}${CPUInfo}" "${FirstCore}"
				done
				RenderPDF
				;;
			all)
				# check each core of every cluster individually, check cores of each cluster
				# and check all cores
				for i in $(seq 0 $(( ${#ClusterConfig} -1 )) ) ; do
					FirstCore=${ClusterConfig:$i:1}
					CheckPerformance "CPU ${FirstCore}" "${FirstCore}" "${FirstCore}"
					CPUInfo="$(GetCPUInfo ${FirstCore})"
					PlotGraph "CPU ${FirstCore}${CPUInfo}" "${FirstCore}"
				done
				for i in $(seq 0 $(( ${#ClusterConfig} -1 )) ) ; do
					FirstCore=${ClusterConfig:$i:1}
					LastCore=$(GetLastClusterCore $(( $i + 1 )))
					CheckPerformance "CPU ${FirstCore}-${LastCore}" "${FirstCore}" "${FirstCore}-${LastCore}"
					CPUInfo="$(GetCPUInfo ${FirstCore})"
					PlotGraph "CPU ${FirstCore}-${LastCore}${CPUInfo}" "${FirstCore}"
				done
				if [ "${ClusterConfig}" != "0" ]; then
					# more than one CPU cluster, we test using all cores simultaneously
					CheckPerformance "all CPU cores" ${ClusterConfig}
					PlotGraph "all CPU cores" ${ClusterConfig}
				fi
				RenderPDF
				;;
			*)
				# individual taskset options have been provided, e.g. 0-2 or 3
				if [ ${#CPUList} -eq 1 ]; then
					# single core to be tested, we need to determine correct policy node
					for i in $(seq 0 $(( ${#ClusterConfig} -1 )) ) ; do
						FirstCore=${ClusterConfig:$i:1}
						LastCore=$(GetLastClusterCore $(( $i + 1 )))
						if [ ${CPUList} -le ${LastCore} ]; then
							CheckPerformance "CPU core(s) ${CPUList}" "${FirstCore}" "${CPUList}"
							CPUInfo="$(GetCPUInfo ${CPUList})"
							PlotGraph "core ${CPUList}${CPUInfo}" "${FirstCore}"
							break
						fi
					done	
				else
					CheckPerformance "CPU core(s) ${CPUList}" "${CPUList:0:1}" "${CPUList}"
					PlotGraph "core(s) ${CPUList}" "${CPUList:0:1}"
				fi
				RenderPDF
				;;
		esac
	fi
	exit 0
} # PlotPerformanceGraph

CheckPerformance() {
	# function that gets provided with two or three arguments:
	# * $1 test focus to be displayed
	# * $2 policy cores: the cores that need to be adjusted when measuring, e.g. "0" for
	#   cpu0, "4" for cpu4 or for example on an RK3399 "04" to handle both cpu clusters
	#   at the same time
	# * $3 taskset options as provided via the -p switch when calling sbc-bench
	
	if [ -n "${3}" ]; then
		# if taskset options are provided ensure that '-mmt=1' is set when only a single
		# core is tested.
		TasksetOptions="taskset -c ${3} "
		if [ ${#3} -eq 1 ]; then
			SevenZIPOptions="-mmt=1"
		else
			SevenZIPOptions=""
		fi
	else
		TasksetOptions=""
		SevenZIPOptions=""
	fi
	
	Clusters="$(ls -d /sys/devices/system/cpu/cpufreq/policy[${2}])"

	echo -e "\x08\x08 Done.\nChecking ${1}: \c"
	echo -e "\nSystem health while testing through ${1}:\n" >>${MonitorLog}
	/bin/bash "${PathToMe}" -m $(( 30 * ${Repetitions} )) >>${MonitorLog} &
	MonitoringPID=$!

	SocTemp=$(ReadSoCTemp)

	CpufreqDat="${TempDir}/cpufreq${2}.dat"
	CpufreqLog="${TempDir}/cpufreq${2}.log"

	if [ -s "${NetioConsumptionFile}" ]; then
		NetioHeader=" /  Watt"
		echo -e "0\t0\t${IdleTemp}\t${IdleConsumption}" >"${CpufreqDat}"
		echo -n "" >"${CpufreqDat}"
	else
		echo -n "" >"${CpufreqDat}"
	fi

	if [ ${USE_VCGENCMD} = true ] ; then
		echo -e "Testing through ${1}:\n\nSysfs/ThreadX/Tested:  MIPS / Temp${NetioHeader}" >"${CpufreqLog}"
	else
		echo -e "Testing through ${1}:\n\nSysfs/Tested:  MIPS / Temp${NetioHeader}" >"${CpufreqLog}"
	fi

	# adjust min and max speeds (set max speeds on unaffected clusters to min speed)
	for Cluster in $(ls -d /sys/devices/system/cpu/cpufreq/policy?); do
		read MinSpeed <${Cluster}/cpuinfo_min_freq
		read MaxSpeed <${Cluster}/cpuinfo_max_freq
		echo ${MinSpeed} >${Cluster}/scaling_max_freq
	done
	for Cluster in ${Clusters}; do
		read MinSpeed <${Cluster}/cpuinfo_min_freq
		read MaxSpeed <${Cluster}/cpuinfo_max_freq
		echo ${MinSpeed} >${Cluster}/scaling_min_freq
	done
	
	# now walk through higher cluster since this is supposed to provide more cpufreq OPP.
	# On ARM usually little cores are the cores with lower numbers. 
	BiggestCluster="$(sort -n -r <<<${Clusters} | head -n1)"
	for i in $(tr " " "\n" <${BiggestCluster}/scaling_available_frequencies | sort -n | sed '/^[[:space:]]*$/d') ; do
		# skip measuring cpufreq OPPs below $SkipBelow MHz
		if [ $i -lt ${SkipBelow}000 ]; then
			continue
		fi
		# try to set this speed on all clusters
		for Cluster in ${Clusters}; do
			echo ${i} >${Cluster}/scaling_max_freq
		done
		sleep 0.1
		
		# if TasksetOptions is not provided measure clockspeed on highest core:
		if [ "X${TasksetOptions}" = "X" ]; then
			MeasureCore=$(awk '{print substr($0,length,1)}' <<<"${BiggestCluster}")
			MeasuredSpeed=$(( $(taskset -c ${MeasureCore} "${InstallLocation}"/mhz/mhz 3 100000 | awk -F" cpu_MHz=" '{s+=$2} END {printf "%.0f", s}') / 3 ))
		else
			MeasuredSpeed=$(( $(${TasksetOptions} "${InstallLocation}"/mhz/mhz 3 100000 | awk -F" cpu_MHz=" '{s+=$2} END {printf "%.0f", s}') / 3 ))
		fi

		RoundedSpeed=$(( $(awk '{printf ("%0.0f",$1/10+0.5); }' <<<"${MeasuredSpeed}") * 10 ))
		SysfsSpeed=$(( $i / 1000 ))
		if [ ${USE_VCGENCMD} = true ] ; then
			# On RPi we query ThreadX about clockspeeds too
			ThreadXFreq=$(/usr/bin/vcgencmd measure_clock arm | awk -F"=" '{printf ("%0.0f",$2/1000000); }' )
			CoreVoltage=$(/usr/bin/vcgencmd measure_volts | cut -f2 -d= | sed 's/000//')
			echo -e "$(printf "%4s" ${SysfsSpeed}) /  $(printf "%4s" ${ThreadXFreq}) /$(printf "%6s" ${RoundedSpeed}):\c" >>"${CpufreqLog}"
			echo -e "${ThreadXFreq}\t\c" >>"${CpufreqDat}"
			echo -e "${ThreadXFreq}MHz, \c"
		else
			echo -e "$(printf "%4s" ${SysfsSpeed}) / $(printf "%4s" ${RoundedSpeed}) :\c" >>"${CpufreqLog}"
			echo -e "${SysfsSpeed}\t\c" >>"${CpufreqDat}"
			echo -e "${SysfsSpeed}MHz, \c"
		fi

		echo -n "" >"${TempDir}/plotvalues"
		for check in $(seq 1 ${Repetitions}) ; do
			# run 7-zip benchmark
			${TasksetOptions} "${SevenZip}" b ${SevenZIPOptions} >${TempLog}
			if [ -s "${NetioConsumptionFile}" ]; then
				read ConsumptionNow <"${NetioConsumptionFile}"
			fi
			SocTemp=$(ReadSoCTemp)
			MIPS="$(awk -F" " '/^Tot:/ {print $4}' <${TempLog})"
			echo -e "${MIPS} ${SocTemp} ${ConsumptionNow}" >>"${TempDir}/plotvalues"
		done

		AveragedMIPS=$(( $(awk -F" " '{s+=$1} END {printf "%.0f", s}' <"${TempDir}/plotvalues") / ${Repetitions} ))
		TempSum=$(awk -F" " '{s+=$2} END {printf "%.1f", s}' <"${TempDir}/plotvalues")
		AveragedTemp=$(awk "{printf (\"%0.1f\",\$1/${Repetitions}); }" <<<"${TempSum}")
		if [ -s "${NetioConsumptionFile}" ]; then
			AveragedWatts=$(( $(awk -F" " '{s+=$3} END {printf "%.0f", s}' <"${TempDir}/plotvalues") / ${Repetitions} ))
			ConsumptionInfo="$(printf "%6s" ${AveragedWatts})mW"
		fi

		echo "$(printf "%6s" ${AveragedMIPS}) $(printf "%5s" ${AveragedTemp})°C${ConsumptionInfo}" >>"${CpufreqLog}"
		echo -e "${AveragedMIPS}\t${AveragedTemp}\t${AveragedWatts}" >>"${CpufreqDat}"
	done
	kill ${MonitoringPID} >/dev/null 2>&1
} # CheckPerformance

PlotGraph() {
	# function that gets two arguments provided to graph the performance results:
	# * $1 test focus to be displayed
	# * $2 policy cores: the cores that need to be adjusted when measuring, e.g. "0" for
	#   cpu0, "4" for cpu4 or for example on an RK3399 "04" to handle both cpu clusters
	#   at the same time
	
	# create random filename for graph png
	GraphPNG="$(mktemp ${TempDir}/graph.XXXXXX)"
	mv "${GraphPNG}" "${GraphPNG}.png"	
	
	# adjust y axis range by highest value
	MaxMIPS=$(awk '{print $2}' <"${CpufreqDat}" | sort -n | tail -n1)
	MaxTemp=$(awk '{print $3}' <"${CpufreqDat}" | sort -n | tail -n1)
	Y2Range=$(awk '{printf ("%0.0f",$1*1.2); }' <<<"${MaxTemp}")

	# Count columns in plot data
	CountofColums=$(awk '{print NF}' "${CpufreqDat}" | head -n1)	
	case ${CountofColums} in
		3)
			# no consumption numbers, only plot MIPS and temp
			YLabel="7-Zip MIPS"
			YRange=$(awk '{printf ("%0.0f",$1*1.2); }' <<<"${MaxMIPS}")
			PlotCommand="plot '${CpufreqDat}' using 1:2 lt rgb 'blue' w l title '7-Zip MIPS ${1}' axis x1y1, '' using 1:3 lt rgb 'green' w l title 'SoC temp' axis x1y2"
			;;			
		4)
			# also consumption numbers so include them in the graph too
			YLabel="7-Zip MIPS / mW"
			MaxWatt=$(awk '{print $4}' <"${CpufreqDat}" | sort -n | tail -n1)
			YRangeWatt=$(awk '{printf ("%0.0f",$1*1.2); }' <<<"${MaxWatt}")
			YRangeMIPS=$(awk '{printf ("%0.0f",$1*1.2); }' <<<"${MaxMIPS}")
			if [ ${MaxWatt} -gt ${MaxMIPS} ]; then
				YRange=${YRangeWatt}
			else
				YRange=${YRangeMIPS}
			fi
			PlotCommand="plot '${CpufreqDat}' using 1:2 lt rgb 'blue' w l title '7-Zip MIPS ${1}' axis x1y1, '' using 1:4 lt rgb 'black' w l title 'Consumption in mW' axis x1y1, '' using 1:3 lt rgb 'green' w l title 'SoC temp' axis x1y2"
			;;
	esac

	# add individual results and ASCII graph to results log
	echo -e "\n##########################################################################\n\n$(cat ${TempDir}/cpufreq${2}.log)" >>${ResultLog}
	gnuplot-nox -p -e \
		"set terminal dumb size 75, 30; set autoscale; set yrange [0:${YRangeMIPS}]; plot '${CpufreqDat}' using 1:2  with lines notitle" \
		>>${ResultLog}

	# plot PNG with gnuplot
	PNGWidth=900
	PNGHeight=450
	
	cat <<- EOF | gnuplot-nox
	set title '${DeviceName}: ${1}'
	set ylabel '${YLabel}'
	set ytics nomirror
	set y2tics 0,10
	set y2label 'degree celsius'
	set xlabel 'CPU clockspeed in MHz'
	set datafile sep '\t'
	set key top left autotitle columnheader
	set grid
	set autoscale
	set yrange [0:${YRange}]
	set y2range [0:${Y2Range}]
	set terminal png size ${PNGWidth},${PNGHeight}
	set output '${GraphPNG}.png'
	${PlotCommand}
	plot '${CpufreqDat}' using 1:2 lt rgb 'blue' w l title '7-Zip MIPS ${1}' axis x1y1, '' using 1:3 lt rgb 'green' w l title 'SoC temp' axis x1y2
	EOF
} # PlotGraph

RenderPDF() {
	# fire up monitoring tasks to get device's health after executing the benchmark
	# CheckTimeInState after
	"${SevenZip}" b >/dev/null 2>&1 & # run 7-zip bench in the background
	CheckClockspeedsAndSensors # test again loaded system after heating the SoC to the max
	SummarizeResults >/dev/null

	# use HTMLdoc to combine graph and text
	cat <<- EOF >${TempDir}/report.html
	<html>
	<head>
		<title>sbc-bench performance graph</title>
	</head>
	<body>
		<h3>sbc-bench v${Version} - ${DeviceName} - $(date)</h3>
		sbc-bench has been called with <code>-p ${CPUList}</code>
	EOF
	
	ls -r --time=atime "${TempDir}"/*.png | while read Graph ; do
		echo -e "<img src=\"${Graph}\">" >>${TempDir}/report.html
	done

	cat <<- EOF >>${TempDir}/report.html
		 
		<pre>$(cat ${ResultLog})</pre>
	</body>
	</html>
	EOF

	htmldoc --charset utf-8 --headfootfont helvetica-oblique --headfootsize 7 --header ..c --tocheader . --firstpage c1 --quiet --browserwidth 900 --pagemode outline --fontsize 8 --format pdf14 --bodyfont helvetica --bottom 1cm --pagelayout single --left 2.5cm --right 2cm --top 1.7cm --linkstyle plain --linkcolor blue --textcolor black --bodycolor white --links --size 210x297mm --portrait --compression=9 --jpeg=95 --webpage -f "${TempDir}/report.pdf" "${TempDir}/report.html"
	
	if [ -s "${TempDir}/report.pdf" ]; then
		FinalPDF="$(mktemp /tmp/sbc-bench.XXXXXX)"
		cat "${TempDir}/report.pdf" >"${FinalPDF}"
		mv "${FinalPDF}" "${FinalPDF}.pdf"
		chmod 644 "${FinalPDF}.pdf"
		echo -e "\x08\x08 Done.\n\nPlease check ${FinalPDF}.pdf"
	else
		echo -e "\x08\x08 Done.\n\nSomething went wrong"
	fi
} # RenderPDF

GetTempSensor() {
	# In Armbian we might rely on /etc/armbianmonitor/datasources/soctemp
	if [ -f /etc/armbianmonitor/datasources/soctemp ]; then
		TempSource=/etc/armbianmonitor/datasources/soctemp
		ThermalNode="$(readlink /etc/armbianmonitor/datasources/soctemp)"
		if [ -f "${ThermalNode%/*}/name" ]; then
			read ThermalSource <"${ThermalNode%/*}/name" 2>/dev/null && \
				TempInfo="Thermal source: ${ThermalNode%/*}/ (${ThermalSource})"
		elif [ -f "${ThermalNode%/*}/type" ]; then
			read ThermalSource <"${ThermalNode%/*}/type" 2>/dev/null && \
				TempInfo="Thermal source: ${ThermalNode%/*}/ (${ThermalSource})"
		fi
	else
		TempSource="$(mktemp /tmp/soctemp.XXXXXX)"

		# check platform
		case $(lscpu | awk -F" " '/^Architecture/ {print $2}') in
			x86*|i686)
				cat /sys/devices/virtual/thermal/thermal_zone?/type 2>/dev/null | grep -q x86_pkg_temp
				case $? in
					0)
						# use x86_pkg_temp sensor if available
						ThermalZone="$(GetThermalZone x86_pkg_temp)"
						ln -fs ${ThermalZone}/temp ${TempSource}
						TempInfo="Thermal source: ${ThermalZone}/ (x86_pkg_temp)"
						;;
					*)
						# try to get hwmon node based on thermal driver loaded (idea/feedback courtesy
						# @linuxium and @dan-and: https://github.com/ThomasKaiser/sbc-bench/issues/33)
						find /sys -name temp1_input -type f 2>/dev/null | while read ; do
							read NodeName <"${REPLY%/*}/name"
							case "${NodeName}" in
								k10temp|k8temp|coretemp)
									ln -fs "${REPLY}" ${TempSource}
									TempInfo="Thermal source: ${REPLY%/*}/ (${NodeName})"
									break
									;;
							esac
						done
						if [ ! -h "${TempSource}" ]; then
							# still no thermal source found. If there is at least one thermal_zone
							# with 'cpu' in its name then use it
							CPUSensor="$(cat /sys/devices/virtual/thermal/thermal_zone?/type 2>/dev/null | grep -i cpu | head -n1)"
							if [ "X${CPUSensor}" != "X" ]; then
								ThermalZone="$(GetThermalZone "${CPUSensor}")"
								ln -fs ${ThermalZone}/temp ${TempSource}
								TempInfo="Thermal source: ${ThermalZone}/ (${CPUSensor})"
							else
								echo 0 >${TempSource}
							fi
						fi
						;;
				esac
				;;
			*)
				if [[ -d "/sys/devices/platform/a20-tp-hwmon" ]]; then
					# Allwinner A20 with old 3.4 kernel
					ln -fs /sys/devices/platform/a20-tp-hwmon/temp1_input ${TempSource}
					read ThermalSource </sys/devices/platform/a20-tp-hwmon/name 2>/dev/null && \
						TempInfo="Thermal source: /sys/devices/platform/a20-tp-hwmon/ (${ThermalSource})"
				elif [[ -f /sys/class/hwmon/hwmon0/temp1_input ]]; then
					# usual convention with modern kernels
					ln -fs /sys/class/hwmon/hwmon0/temp1_input ${TempSource}
					read ThermalSource </sys/class/hwmon/hwmon0/name 2>/dev/null && \
						TempInfo="Thermal source: /sys/class/hwmon/hwmon0/ (${ThermalSource})"
				else
					# all other boards/kernels use the same sysfs node except of Actions Semi S500
					# so on LeMaker Guitar, Roseapple Pi or Allo Sparky it must read "thermal_zone1"
					if [ -f /sys/devices/virtual/thermal/thermal_zone0/temp ]; then
						ln -fs /sys/devices/virtual/thermal/thermal_zone0/temp ${TempSource}
						read ThermalSource </sys/devices/virtual/thermal/thermal_zone0/type 2>/dev/null && \
							TempInfo="Thermal source: /sys/devices/virtual/thermal/thermal_zone0/ (${ThermalSource})"
					else
						echo 0 >${TempSource}
					fi
				fi
				;;				
		esac
	fi
	export TempSource TempInfo
} # GetTempSensor

GetThermalZone() {
	# get thermal zone for specific type string ($1)
	for zone in /sys/devices/virtual/thermal/thermal_zone* ; do
		grep -q "${1}" <"${zone}/type"
		case $? in
			0)
				echo ${zone}
				return
				;;
		esac
	done
} # GetThermalZone

CheckNetio() {
	# Function that checks connection with a Netio powermeter if $Netio is set and if
	# successful spawns another execution of this script with -N (Netio monitor mode.).

	if [ "X${Netio}" != "X" ]; then
		# Try to fetch XML
		XMLOutput="$(curl -q --connect-timeout 1 "http://${NetioDevice}/netio.xml" 2>/dev/null | tr '\015' '\012')"
		if [ "X${XMLOutput}" = "X" ]; then
			echo -e "\nError: not able to fetch \"http://${NetioDevice}/netio.xml\" within a second.\nPlease check parameters and connection manually." >&2
			DisplayUsage
			exit 1
		else
			# check current reading of the socket we're supposed to be plugged into
			OutputCurrent=($(grep '^<Current>' <<<"${XMLOutput}" | sed -e 's/\(<[^<][^<]*>\)//g' | tr '\n' ' '))
			if [ ${OutputCurrent[$(( ${NetioSocket} - 1 ))]} -eq 0 ]; then
				echo -e "\nWarning: socket ${NetioSocket} of Netio device ${NetioDevice} provides zero current.\n"
			fi
			NetioConsumptionFile="${TempDir}/netio.current"
			[ -f "${NetioConsumptionFile}" ] || echo -n 0 >"${NetioConsumptionFile}"
			export NetioConsumptionFile
			/bin/bash "${PathToMe}" -N ${NetioDevice} ${NetioSocket} ${NetioConsumptionFile} >/dev/null 2>&1 &
			NetioMonitoringPID=$!
			trap "kill ${NetioMonitoringPID} ; rm -rf \"${TempDir}\" ; exit 0" 0 1 2 3 15
		fi
	fi
} # CheckNetio

MonitorNetio() {
	# Poll Netio powermeter accessible at $1 every ~1 second, extract current and 
	# powerfactor readouts for socket $2, write most recent 30 readouts to a file
	# and generate an average number from this to be written to $3
	# By also providing $4 and $5 you can adjust poll interval and sample count.

	NetioDevice="$1"
	NetioSocket="$2"
	ConsumptionFile="$3"
	SleepInterval=${4:-0.8}
	CountofSamples=${5:-30}

	# Try to renice to 19 to not interfere with benchmark behaviour
	renice 19 $BASHPID >/dev/null 2>&1

	while true ; do
		XMLOutput="$(curl -q --connect-timeout 1 "http://${NetioDevice}/netio.xml" 2>/dev/null | tr '\015' '\012')"
		InputVoltage=$(grep '^<Voltage>' <<<"${XMLOutput}" | sed -e 's/\(<[^<][^<]*>\)//g')
		OutputCurrents=($(grep '^<Current>' <<<"${XMLOutput}" | sed -e 's/\(<[^<][^<]*>\)//g' | tr '\n' ' '))
		OutputCurrent=${OutputCurrents[$(( ${NetioSocket} - 1 ))]}
		OutputPowerFactors=($(grep '^<PowerFactor>' <<<"${XMLOutput}" | sed -e 's/\(<[^<][^<]*>\)//g' | tr '\n' ' '))
		OutputPowerFactor=${OutputPowerFactors[$(( ${NetioSocket} - 1 ))]}
		Consumption=$(awk -F" " '{printf ("%0.0f",$1*$2*$3); }' <<<"${InputVoltage} ${OutputCurrent} ${OutputPowerFactor}")
		
		# create a file consisting of $CountofSamples entries with last consumption readouts so we
		# can generate an average value based this and $SleepInterval
		touch ${TempDir}/netio-socket-${NetioSocket}
		PriorValues="$(tail -n${CountofSamples} ${TempDir}/netio-socket-${NetioSocket})"
		echo -e "${PriorValues}\n${Consumption}" | sed '/^[[:space:]]*$/d' >${TempDir}/netio-socket-${NetioSocket}
		CountOfEntries="$(wc -l <${TempDir}/netio-socket-${NetioSocket})"
		SumOfEntries=$(awk '{s+=$1} END {printf "%.0f", s}' <${TempDir}/netio-socket-${NetioSocket})
		AverageConsumption=$(( ${SumOfEntries} / ${CountOfEntries} ))
		echo -n $(( $(awk '{printf ("%0.0f",$1/10); }' <<<"${AverageConsumption}" ) * 10 )) >"${ConsumptionFile}"
		sleep ${SleepInterval}
	done
} # MonitorNetio

MonitorBoard() {
	[ "X${TempSource}" = "X" ] && GetTempSensor

	if test -t 1; then
		# when called from a terminal we print some system information first
		[ -f /sys/devices/soc0/family ] && read SoC_Family </sys/devices/soc0/family
		[ -f /sys/devices/soc0/soc_id ] && read SoC_ID </sys/devices/soc0/soc_id
		[ -f /sys/devices/soc0/revision ] && read SoC_Revision </sys/devices/soc0/revision
		if [ -n "${SoC_Revision}" ]; then
			echo -e "${SoC_Family} ${SoC_ID} rev ${SoC_Revision}, \c"
		fi
		BasicSetup
		command -v dpkg >/dev/null 2>&1 && Userland=", Userland: $(dpkg --print-architecture 2>/dev/null)"
		VirtWhat="$(systemd-detect-virt 2>/dev/null)"
		[ "X${VirtWhat}" != "X" -a "X${VirtWhat}" != "Xnone" ] && VirtOrContainer=" / ${BOLD}${VirtWhat}${NC}"
		echo -e "Kernel: ${CPUArchitecture}${VirtOrContainer}${Userland}"
		PrintCPUTopology
		if [ "X${TempInfo}" != "X" ]; then
			echo -e "${TempInfo}\n"
		fi
	fi

	# Background monitoring

	# Try to renice to 19 to not interfere with benchmark behaviour
	renice 19 $BASHPID >/dev/null 2>&1

	CpuFreqToQuery=cpuinfo_cur_freq
	CPUArchitecture="$(lscpu | awk -F" " '/^Architecture/ {print $2}')"
	ClusterConfig=$(GetCPUClusters)

	# check platform
	case ${CPUArchitecture} in
		x86*|i686)
			IsIntel="yes"
			if [ ! -f /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq ]; then
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

	# check if we're in Netio consumption monitoring mode
	[ -s "${NetioConsumptionFile}" ] && NetioHeader="     mW"

	if [ ${USE_VCGENCMD} = true ] ; then
		DisplayHeader="Time        fake/real   load %cpu %sys %usr %nice %io %irq   Temp    VCore${NetioHeader}"
		CPUs=raspberrypi
	elif [ "${ClusterConfig}" = "0" -a -f /sys/devices/system/cpu/cpufreq/policy0/${CpuFreqToQuery} ] ; then
		DisplayHeader="Time        CPU    load %cpu %sys %usr %nice %io %irq   Temp${NetioHeader}"
		CPUs=singlecluster
	elif [ -f /sys/devices/system/cpu/cpufreq/policy${ClusterConfig:1:1}/${CpuFreqToQuery} ]; then
		DisplayHeader="Time       big.LITTLE   load %cpu %sys %usr %nice %io %irq   Temp${NetioHeader}"
		read FirstCluster </sys/devices/system/cpu/cpufreq/policy${ClusterConfig:0:1}/cpuinfo_max_freq
		read SecondCluster </sys/devices/system/cpu/cpufreq/policy${ClusterConfig:1:1}/cpuinfo_max_freq
		if [ ${SecondCluster} -ge ${FirstCluster} ]; then
			CPUs=biglittle
		else
			CPUs=littlebig
		fi
	else
		DisplayHeader="Time      CPU n/a    load %cpu %sys %usr %nice %io %irq   Temp${NetioHeader}"
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

		if [ -s "${NetioConsumptionFile}" ]; then
			read ConsumptionNow <"${NetioConsumptionFile}"
			NetioColumn="  $(printf "%5s" ${ConsumptionNow})"
		fi

		case ${CPUs} in
			raspberrypi)
				FakeFreq=$(awk '{printf ("%0.0f",$1/1000); }' </sys/devices/system/cpu/cpu0/cpufreq/${CpuFreqToQuery} 2>/dev/null)
				RealFreq=$(/usr/bin/vcgencmd measure_clock arm | awk -F"=" '{printf ("%0.0f",$2/1000000); }' )
				CoreVoltage=$(/usr/bin/vcgencmd measure_volts | cut -f2 -d= | sed 's/000//')
				echo -e "$(date "+%H:%M:%S"): $(printf "%4s" ${FakeFreq})/$(printf "%4s" ${RealFreq})MHz $(printf "%5s" ${LoadAvg}) ${procStats}  $(printf "%4s" ${SocTemp})°C  $(printf "%7s" ${CoreVoltage})${NetioColumn}"
				;;
			biglittle)
				BigFreq=$(awk '{printf ("%0.0f",$1/1000); }' </sys/devices/system/cpu/cpufreq/policy${ClusterConfig:1:1}/${CpuFreqToQuery} 2>/dev/null)
				LittleFreq=$(awk '{printf ("%0.0f",$1/1000); }' </sys/devices/system/cpu/cpufreq/policy${ClusterConfig:0:1}/${CpuFreqToQuery} 2>/dev/null)
				echo -e "$(date "+%H:%M:%S"): $(printf "%4s" ${BigFreq})/$(printf "%4s" ${LittleFreq})MHz $(printf "%5s" ${LoadAvg}) ${procStats}  $(printf "%4s" ${SocTemp})°C${NetioColumn}"
				;;
			littlebig)
				BigFreq=$(awk '{printf ("%0.0f",$1/1000); }' </sys/devices/system/cpu/cpufreq/policy${ClusterConfig:0:1}/${CpuFreqToQuery} 2>/dev/null)
				LittleFreq=$(awk '{printf ("%0.0f",$1/1000); }' </sys/devices/system/cpu/cpufreq/policy${ClusterConfig:1:1}/${CpuFreqToQuery} 2>/dev/null)
				echo -e "$(date "+%H:%M:%S"): $(printf "%4s" ${BigFreq})/$(printf "%4s" ${LittleFreq})MHz $(printf "%5s" ${LoadAvg}) ${procStats}  $(printf "%4s" ${SocTemp})°C${NetioColumn}"
				;;
			singlecluster)
				CpuFreq=$(awk '{printf ("%0.0f",$1/1000); }' </sys/devices/system/cpu/cpufreq/policy0/${CpuFreqToQuery} 2>/dev/null)
				echo -e "$(date "+%H:%M:%S"): $(printf "%4s" ${CpuFreq})MHz $(printf "%5s" ${LoadAvg}) ${procStats}  $(printf "%4s" ${SocTemp})°C${NetioColumn}"
				;;
			notavailable)
				echo -e "$(date "+%H:%M:%S"):   ---     $(printf "%5s" ${LoadAvg}) ${procStats}  $(printf "%4s" ${SocTemp})°C${NetioColumn}"
				;;
		esac
		sleep ${SleepInterval}
	done
} # MonitorBoard

TempTest() {
	[ "X${TempSource}" = "X" ] && GetTempSensor

	SocTemp=$(ReadSoCTemp 2>/dev/null | cut -f1 -d'.')
	[ "X${SocTemp}" = "X" ] && \
		(echo -e "${LRED}${BOLD}WARNING: No temperature source found. Aborting.${NC}" >&2 ; exit 1)
	[ ${SocTemp} -lt 20 ] && \
		echo -e "${LRED}${BOLD}WARNING: sysfs thermal readout is ominously low: ${SocTemp}°C.${NC}\n" >&2

	BasicSetup >/dev/null 2>&1
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
	CheckClockspeedsAndSensors
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
	# Display warning when not executing on Debian Stretch/Buster/Bullseye or Ubuntu Bionic/Focal/Jammy
	command -v lsb_release >/dev/null 2>&1 || apt -f -qq -y install lsb-release >/dev/null 2>&1
	Distro=$(lsb_release -c | awk -F" " '{print $2}' | tr '[:upper:]' '[:lower:]')
	case ${Distro} in
		stretch|bionic|buster|focal|bullseye|jammy)
			:
			;;
		*)
			echo -e "${LRED}${BOLD}WARNING: this tool is meant to run only on Debian Stretch, Buster, Bullseye or Ubuntu Bionic, Focal, Jammy.${NC}"
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

GetCPUClusters() {
	if [ -d /sys/devices/system/cpu/cpufreq/policy0 -a "${CPUArchitecture}" != "x86_64" ]; then
		# cpufreq support exists on ARM, we rely on this
		ls -d /sys/devices/system/cpu/cpufreq/policy? | tr -d -c '[:digit:]'
	else
		# check for different CPU types based on package ids. This allows to test through
		# different cores even on systems with no cpufreq support.
		SYS=/sys/devices/system/cpu
		for PKG_ID in $(cat "${SYS}"/cpu*[0-9]/topology/physical_package_id | sort | uniq); do
	 	   dirname $(dirname $(grep "^${PKG_ID}$" "${SYS}"/cpu*[0-9]/topology/physical_package_id | head -n1)) | tr -d -c '[:digit:]'
		done
	fi
} # GetCPUClusters

BasicSetup() {
	# set cpufreq governor based on $1 (defaults to ondemand if not provided)
	if [ -d /sys/devices/system/cpu/cpufreq/policy0 ]; then
		for Cluster in $(ls -d /sys/devices/system/cpu/cpufreq/policy?); do
			[ -w ${Cluster}/scaling_governor ] && echo ${1:-ondemand} >${Cluster}/scaling_governor 2>/dev/null
		done
	fi

	CPUArchitecture="$(lscpu | awk -F" " '/^Architecture/ {print $2}')"
	case ${CPUArchitecture} in
		arm*|aarch*|riscv*)
			[ -f /proc/device-tree/model ] && read DeviceName </proc/device-tree/model
			[ "X${DeviceName}" = "Xsun20iw1p1" ] && DeviceName="Allwinner D1"
			ARMTypes=($(awk -F"0x" '/^CPU implementer|^CPU part/ {print $2}' /proc/cpuinfo))
			;;
		x86*|i686)
			# Try to get device name from CPU entry
			DeviceName="$(lscpu | sed 's/ \{1,\}/ /g' | awk -F": " '/^Model name/ {print $2}')"
			;;
		*)
			echo "${CPUArchitecture} not supported. Aborting." >&2
			exit 1
			;;
	esac

	ClusterConfig=$(GetCPUClusters)
	CPUCores=$(grep -c '^processor' /proc/cpuinfo)
} # BasicSetup

InstallPrerequisits() {
	echo -e "sbc-bench v${Version}\n\nInstalling needed tools. This may take some time...\c"
	SevenZip=$(command -v 7za || command -v 7zr)
	[ -z "${SevenZip}" ] && add-apt-repository -y universe >/dev/null 2>&1 ; apt -f -qq -y install p7zip >/dev/null 2>&1 && SevenZip=/usr/bin/7zr
	[ -z "${SevenZip}" ] && (echo "No 7-zip binary found and could not be installed. Aborting" >&2 ; exit 1)

	command -v iostat >/dev/null 2>&1 || apt -f -qq -y install sysstat >/dev/null 2>&1
	command -v git >/dev/null 2>&1 || apt -f -qq -y install git >/dev/null 2>&1
	command -v openssl >/dev/null 2>&1 || apt -f -qq -y install openssl >/dev/null 2>&1
	command -v curl >/dev/null 2>&1 || apt -f -qq -y install curl >/dev/null 2>&1
	command -v dmidecode >/dev/null 2>&1 || apt -f -qq -y install dmidecode >/dev/null 2>&1
	
	if [ "${PlotCpufreqOPPs}" = "yes" ]; then
		command -v htmldoc >/dev/null 2>&1 || apt -f -qq -y --no-install-recommends install htmldoc >/dev/null 2>&1
		command -v gnuplot >/dev/null 2>&1 || apt -f -qq -y --no-install-recommends install gnuplot-nox >/dev/null 2>&1
	fi

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
	# record start time
	BenchmarkStartTime=$(date +"%s")
	# empty caches
	echo 3 >/proc/sys/vm/drop_caches
	
	# q&d performance assessment to estimate duration
	QuickAndDirtyPerformance="$(BashBench)"
	TinymembenchDuration=$(( $(( 5 + $(( ${QuickAndDirtyPerformance} / 150000000 )) )) * ${#ClusterConfig} ))
	RunHowManyTimes=3 # how many times should the multi-threaded 7-zip test be repeated
	SingleThreadedDuration=$(( 20 + $(( ${QuickAndDirtyPerformance} * ${#ClusterConfig} / 5000000 )) ))
	MultiThreadedDuration=$(( ${RunHowManyTimes} * $(( 20 + $(( ${QuickAndDirtyPerformance} / 5000000 )) )) / ${CPUCores} ))
	if [ "${ExecuteCpuminer}" = "yes" -a -x "${InstallLocation}"/cpuminer-multi/cpuminer ]; then
		EstimatedDuration=$(( ${TinymembenchDuration} + $(( $(( ${SingleThreadedDuration} + ${MultiThreadedDuration} )) / 60 )) + 8 ))
	else
		EstimatedDuration=$(( ${TinymembenchDuration} + $(( $(( ${SingleThreadedDuration} + ${MultiThreadedDuration} )) / 60 )) + 3 ))
	fi

	# Create temporary files
	TempDir="$(mktemp -d /tmp/${0##*/}.XXXXXX)"
	export TempDir
	TempLog="${TempDir}/temp.log"
	ResultLog="${TempDir}/results.log"
	MonitorLog="${TempDir}/monitor.log"
	trap "rm -rf \"${TempDir}\" ; exit 0" 0 1 2 3 15

	# Log version and device info
	read HostName </etc/hostname
	echo -e "sbc-bench v${Version} ${DeviceName:-$HostName} ($(date -R))\n" >${ResultLog}

	# Log distribution info
	[ -f /etc/armbian-release ] && . /etc/armbian-release
	command -v lsb_release >/dev/null 2>&1 && (lsb_release -a 2>/dev/null) >>${ResultLog}
	ARCH=$(dpkg --print-architecture 2>/dev/null) || \
		ARCH=$(awk -F"=" '/^CARCH/ {print $2}' /etc/makepkg.conf 2>/dev/null) || \
		ARCH="unknown/$(uname -m)"
	if [ -n "${BOARDFAMILY}" ]; then
		echo -e "\nArmbian release info:\n$(grep -v "#" /etc/armbian-release)" >>${ResultLog}
	else
		echo -e "Architecture:\t$(tr -d '"' <<<${ARCH})" >>${ResultLog}
	fi

	# Log system info if present:
	SystemInfo="$(dmidecode -t system 2>/dev/null | egrep "Manufacturer: |Product Name: |Version: |Family: |SKU Number: " | egrep -v ":  $|O.E.M.|123456789")"
	if [ "X${SystemInfo}" != "X" ]; then
		echo -e "\nDevice Info:\n${SystemInfo}" >>${ResultLog}
	fi
	
	# Log BIOS/UEFI info if present:
	UEFIInfo="$(dmidecode -t bios 2>/dev/null | egrep "Vendor:|Version:|Release Date:|Revision:")"
	if [ "X${UEFIInfo}" != "X" ]; then
		echo -e "\nBIOS/UEFI:\n${UEFIInfo}" >>${ResultLog}
	fi

	# On Raspberries we also collect 'firmware' information:
	if [ ${USE_VCGENCMD} = true ] ; then
		ThreadXVersion="$(/usr/bin/vcgencmd version)"
		echo -e "\nRaspberry Pi ThreadX version:\n${ThreadXVersion}" >>${ResultLog}
		[ -f /boot/config.txt ] && ThreadXConfig=/boot/config.txt || ThreadXConfig=/boot/firmware/config.txt
		[ -f ${ThreadXConfig} ] && echo -e "\nThreadX configuration (${ThreadXConfig}):\n$(grep -v '#' ${ThreadXConfig} | sed '/^\s*$/d')" >>${ResultLog}
		echo -e "\nActual ThreadX settings:\n$(vcgencmd get_config int)" >>${ResultLog}
	fi

	# Log gcc version
	GCC="$(command -v gcc)"
	GCC_Version="$(${GCC} --version | sed 's/gcc\ //' | head -n1)"
	echo -e "\n${GCC} ${GCC_Version}" >>${ResultLog}

	# Some basic system info needed to interpret system health later
	echo -e "\nUptime:$(uptime)\n\n$(iostat | grep -v "^loop")\n\n$(free -h)\n\n$(swapon -s)" | sed '/^$/N;/^\n$/D' >>${ResultLog}
	
	# set up Netio consumption monitoring if requested. Device address and socket
	# need to be available as Netio (environment) variable.
	if [ "X${Netio}" != "X" ]; then
		NetioDevice="$(cut -f1 -d/ <<<"${Netio}")"
		NetioSocket="$(cut -f2 -d/ <<<"${Netio}")"
		XMLOutput="$(curl -q --connect-timeout 1 "http://${NetioDevice}/netio.xml" 2>/dev/null | tr '\015' '\012')"
		OutputCurrent=($(grep '^<Current>' <<<"${XMLOutput}" | sed -e 's/\(<[^<][^<]*>\)//g' | tr '\n' ' '))
		InputVoltage=$(grep '^<Voltage>' <<<"${XMLOutput}" | sed -e 's/\(<[^<][^<]*>\)//g')
		Frequency=$(grep '^<Frequency>' <<<"${XMLOutput}" | sed -e 's/\(<[^<][^<]*>\)//g')
		NetioModel=$(grep '^<Model>' <<<"${XMLOutput}" | sed -e 's/\(<[^<][^<]*>\)//g')
		NetioName=$(grep '^<DeviceName>' <<<"${XMLOutput}" | sed -e 's/\(<[^<][^<]*>\)//g')
		Firmware=$(grep '^<Version>' <<<"${XMLOutput}" | sed -e 's/\(<[^<][^<]*>\)//g')
		XmlVer=$(grep '^<XmlVer>' <<<"${XMLOutput}" | sed -e 's/\(<[^<][^<]*>\)//g')
		echo -e "\nPower monitoring on socket ${NetioSocket} of ${NetioName} (Netio ${NetioModel}, FW v${Firmware}, XML API v${XmlVer}, ${InputVoltage}V @ ${Frequency}Hz) " >>${ResultLog}
	fi

	# log benchmark start in dmesg output
	echo "sbc-bench started" >/dev/kmsg
} # InitialMonitoring

CheckClockspeedsAndSensors() {
	echo -e "\x08\x08 Done.\nChecking cpufreq OPP...\c"
	echo -e "\n##########################################################################" >>${ResultLog}
	if [ -f ${MonitorLog} ]; then
		# 2nd check after most demanding benchmark has been run.
		echo -e "\nTesting clockspeeds again. System health now:\n" >>${ResultLog}
		grep 'Time' ${MonitorLog} | tail -n 1 >"${TempDir}/systemhealth.now" >>${ResultLog}
		grep ':' ${MonitorLog} | tail -n 1 >>"${TempDir}/systemhealth.now" >>${ResultLog}
	else
		# 1st check, try to get info about Intel P-States
		PStateStatus="$(journalctl -b 2>/dev/null | awk -F": " '/intel_pstate:/ {print $3}' | sed ':a;N;$!ba;s/\n/, /g')"
		if [ "X${PStateStatus}" != "X" ]; then
			echo -e "\nIntel P-States: ${PStateStatus}" >>${ResultLog}
		fi
	fi
	if [ "${ClusterConfig}" = "0" ]; then
		# all CPU cores have same package id, we only need to test one core
		CPUInfo="$(GetCPUInfo 0)"
		echo -e "\nChecking cpufreq OPP${CPUInfo}:\n" >>${ResultLog}
		CheckCPUCluster 0 >>${ResultLog}
	else
		# different package ids, we walk through all clusters
		for i in $(seq 0 $(( ${#ClusterConfig} -1 )) ) ; do
			FirstCore=${ClusterConfig:$i:1}
			LastCore=$(GetLastClusterCore $(( $i + 1 )))
			CPUInfo="$(GetCPUInfo ${ClusterConfig:$i:1})"
			echo -e "\nChecking cpufreq OPP for cpu${FirstCore}-cpu${LastCore}${CPUInfo}:\n" >>${ResultLog}
			CheckCPUCluster ${FirstCore} >>${ResultLog}
		done
	fi

	# if lm-sensors is present and reports anything add this to results.log
	LMSensorsOutput="$(sensors -A 2>/dev/null)"
	if [ "X${LMSensorsOutput}" != "X" ]; then
		echo -e "\n##########################################################################\n" >>${ResultLog}
		echo -e "Hardware sensors:\n\n${LMSensorsOutput}" >>${ResultLog}
	
		# if temperature sensors can be read from disks, report them
		SmartCtl="$(command -v smartctl 2>/dev/null)"
		Disks="$(ls /dev/sd? 2>/dev/null ; ls /dev/nvme?n1 2>/dev/null)"
		if [ "X${SmartCtl}" != "X" -a "X${Disks}" != "X" ]; then
			echo "" >>${ResultLog}
			for Disk in ${Disks} ; do
				case ${Disk} in
					/dev/sd*)
						echo -e "${Disk}:\t$(smartctl -a ${Disk} | awk -F" " '/Temperature/ {print $10" "$2}' | head -n1 | sed 's/_/ /g')"
						;;
					/dev/nvme*)
						echo -e "${Disk}:\t$(smartctl -a ${Disk} | awk -F" " '/Temperature:/ {print $2" "$3}' | head -n1)" 
						;;
				esac
			done | sed -e 's/ Airflow//' -e 's/ Temperature//' -e 's/ Celsius$/°C/' -e 's/ Cel$/°C/' >>${ResultLog}
		fi
	fi
} # CheckClockspeedsAndSensors

CheckTimeInState() {
	# Check cpufreq statistics prior and after benchmark to detect throttling (won't work
	# with all kernels and especially not on the RPi since RPi Trading people are cheating.
	# Cpufreq support via sysfs is bogus and with latest ThreadX (firmware) update they
	# even cheat wrt querying the 'firmware' via 'vcgencmd get_throttled':
	# https://www.raspberrypi.org/forums/viewtopic.php?f=63&t=217056#p1334921

	if [ -f /sys/devices/system/cpu/cpufreq/policy0/stats/time_in_state ]; then
		for StatFile in $(ls /sys/devices/system/cpu/cpufreq/policy?/stats/time_in_state) ; do
			Number=$(tr -c -d '[:digit:]' <<<${StatFile})
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
	fi
} # CheckTimeInState

CheckCPUCluster() {
	# check whether there's cpufreq support or not
	if [ -d /sys/devices/system/cpu/cpufreq/policy${1} ]; then
		# walk through all cpufreq OPP and report clockspeeds (kernel vs. measured)
		read MinSpeed </sys/devices/system/cpu/cpufreq/policy${1}/cpuinfo_min_freq
		read MaxSpeed </sys/devices/system/cpu/cpufreq/policy${1}/cpuinfo_max_freq
		echo ${MinSpeed} >/sys/devices/system/cpu/cpufreq/policy${1}/scaling_min_freq
		if [ -f /sys/devices/system/cpu/cpufreq/policy${1}/scaling_available_frequencies ]; then
			OPPtoCheck=$(tr " " "\n" </sys/devices/system/cpu/cpufreq/policy${1}/scaling_available_frequencies | sort -n -r)
		else
			OPPtoCheck="${MaxSpeed} ${MinSpeed}"
		fi
		for i in ${OPPtoCheck} ; do
			echo ${i} >/sys/devices/system/cpu/cpufreq/policy${1}/scaling_max_freq
			sleep 0.1
			MeasuredSpeed=$(taskset -c $1 "${InstallLocation}"/mhz/mhz 3 100000 | awk -F" cpu_MHz=" '{print $2}' | awk -F" " '{print $1}' | tr '\n' '/' | sed 's|/$||')
			RoundedSpeed=$(( $(awk '{printf ("%0.0f",$1/5+0.5); }' <<<"${MeasuredSpeed}") * 5 ))
			SysfsSpeed=$(( $i / 1000 ))
			if [ ${USE_VCGENCMD} = true ] ; then
				# On RPi we query ThreadX about clockspeeds and Vcore voltage too
				ThreadXFreq=$(/usr/bin/vcgencmd measure_clock arm | awk -F"=" '{printf ("%0.0f",$2/1000000); }' )
				CoreVoltage=$(/usr/bin/vcgencmd measure_volts | cut -f2 -d= | sed 's/000//')
				echo -e "Cpufreq OPP: $(printf "%4s" ${SysfsSpeed})  ThreadX: $(printf "%4s" ${ThreadXFreq})  Measured: $(printf "%4s" ${RoundedSpeed}) @ ${CoreVoltage}"
			else
				echo -e "Cpufreq OPP: $(printf "%4s" ${SysfsSpeed})    Measured: $(printf "%4s" ${RoundedSpeed}) (${MeasuredSpeed})"
			fi
		done
		echo ${MaxSpeed} >/sys/devices/system/cpu/cpufreq/policy${1}/scaling_max_freq
	else
		# no cpufreq support: measure speeds on cpu0 on single core machines, otherwise on
		# next cpu core to not interfere with probable bad IRQ/SMP affinitiy settings.
		case $(grep -c '^processor' /proc/cpuinfo) in
			1)
				CpuToCheck=0
				;;
			*)
				CpuToCheck=$(( $1 + 1 ))
				;;
		esac
		MeasuredSpeed=$(taskset -c ${CpuToCheck} "${InstallLocation}"/mhz/mhz 3 1000000 | awk -F" cpu_MHz=" '{print $2}' | awk -F" " '{print $1}' | tr '\n' '/' | sed 's|/$||')
		RoundedSpeed=$(( $(awk '{printf ("%0.0f",$1/5+0.5); }' <<<"${MeasuredSpeed}") * 5 ))
		echo -e "No cpufreq support available. Measured on cpu${CpuToCheck}: ${RoundedSpeed} Mhz (${MeasuredSpeed})"
	fi
} # CheckCPUCluster

RunTinyMemBench() {
	echo -e "\x08\x08 Done (results will be available in ${EstimatedDuration}-$(( ${EstimatedDuration} * 140 / 100 )) minutes)."
	echo -e "Executing tinymembench...\c"
	echo -e "System health while running tinymembench:\n" >${MonitorLog}
	/bin/bash "${PathToMe}" -m $(( 40 * ${#ClusterConfig} )) >>${MonitorLog} &
	MonitoringPID=$!
	echo -n "" >${TempLog}
	for i in $(seq 0 $(( ${#ClusterConfig} -1 )) ) ; do
		CPUInfo="$(GetCPUInfo ${ClusterConfig:$i:1})"
		echo -e "\nExecuting benchmark on cpu${ClusterConfig:$i:1}${CPUInfo}:\n" >>${TempLog}
		[ -s "${NetioConsumptionFile}" ] && sleep 10
		taskset -c ${ClusterConfig:$i:1} "${InstallLocation}"/tinymembench/tinymembench >>${TempLog} 2>&1
	done
	kill ${MonitoringPID}
	echo -e "\n##########################################################################" >>${ResultLog}
	cat ${TempLog} >>${ResultLog}
	MemCpyScore="$(awk -F" " '/^ standard memcpy/ {print $4}' <${TempLog} | tail -n1)"
	MemSetScore="$(awk -F" " '/^ standard memset/ {print $4}' <${TempLog} | tail -n1)"
	MemBenchScore="$(( $(awk '{printf ("%0.0f",$1/10); }' <<<"${MemCpyScore}" ) * 10 )) | $(( $(awk '{printf ("%0.0f",$1/10); }' <<<"${MemSetScore}" ) * 10 ))"
} # RunTinyMemBench

Run7ZipBenchmark() {
	echo -e "\x08\x08 Done.\nExecuting 7-zip benchmark...\c"
	echo -e "\nSystem health while running 7-zip single core benchmark:\n" >>${MonitorLog}
	echo -e "\c" >${TempLog}
	/bin/bash "${PathToMe}" -m $(( ${SingleThreadedDuration} / 8 )) >>${MonitorLog} &
	MonitoringPID=$!
	if [ "${ClusterConfig}" = "0" ]; then
		# all CPU cores have same package id
		CPUInfo="$(GetCPUInfo 0)"
		echo -e "\nExecuting benchmark single-threaded on cpu0${CPUInfo}" >>${TempLog}
		[ -s "${NetioConsumptionFile}" ] && sleep 10
		taskset -c 0 "${SevenZip}" b -mmt=1 >>${TempLog}
	else
		for i in $(seq 0 $(( ${#ClusterConfig} -1 )) ) ; do
			CPUInfo="$(GetCPUInfo ${ClusterConfig:$i:1})"
			echo -e "\nExecuting benchmark single-threaded on cpu${ClusterConfig:$i:1}${CPUInfo}" >>${TempLog}
			[ -s "${NetioConsumptionFile}" ] && sleep 10
			taskset -c ${ClusterConfig:$i:1} "${SevenZip}" b -mmt=1 >>${TempLog}
		done
	fi	
	kill ${MonitoringPID}
	echo -e "\n##########################################################################" >>${ResultLog}
	cat ${TempLog} >>${ResultLog}
	
	if [ ${CPUCores} -gt 1 ]; then
		# run multi-threaded test only if there's more than one CPU core
		echo -e "\nSystem health while running 7-zip multi core benchmark:\n" >>${MonitorLog}
		echo -e "\c" >${TempLog}
		/bin/bash "${PathToMe}" -m $(( ${MultiThreadedDuration} / 3 )) >>${MonitorLog} &
		MonitoringPID=$!
		RunHowManyTimes=3
		echo -e "Executing benchmark ${RunHowManyTimes} times multi-threaded" >>${TempLog}
		for ((i=1;i<=RunHowManyTimes;i++)); do
			"${SevenZip}" b -mmt=${CPUCores} >>${TempLog}
		done
		kill ${MonitoringPID}
		echo -e "\n##########################################################################\n" >>${ResultLog}
		cat ${TempLog} >>${ResultLog}
	fi

	sed -i 's/|//' ${TempLog}
	CompScore=$(awk -F" " '/^Avr:/ {print $4}' <${TempLog} | tr '\n' ', ' | sed 's/,$//')
	DecompScore=$(awk -F" " '/^Avr:/ {print $7}' <${TempLog} | tr '\n' ', ' | sed 's/,$//')
	TotScore=$(awk -F" " '/^Tot:/ {print $4}' <${TempLog} | tr '\n' ', ' | sed 's/,$//')
	echo -e "\nCompression: ${CompScore}" >>${ResultLog}
	echo -e "Decompression: ${DecompScore}" >>${ResultLog}
	echo -e "Total: ${TotScore}" >>${ResultLog}
	CombinedScore=$(( $(awk -F" " '/^Tot:/ {s+=$4} END {printf "%.0f", s}' <${TempLog}) / 3 ))
	ZipScore="$(( $(awk '{printf ("%0.0f",$1/10); }' <<<"${CombinedScore}" ) * 10 ))"
} # Run7ZipBenchmark

RunOpenSSLBenchmark() {
	echo -e "\x08\x08 Done.\nExecuting OpenSSL benchmark...\c"
	echo -e "\nSystem health while running OpenSSL benchmark:\n" >>${MonitorLog}
	echo -e "\n##########################################################################\n" >>${ResultLog}
	/bin/bash "${PathToMe}" -m 16 >>${MonitorLog} &
	MonitoringPID=$!
	OpenSSLLog="${TempDir}/openssl.log"
	if [ "${ClusterConfig}" = "0" ]; then
		# all CPU cores have same package id, we execute openssl twice
		CPUInfo="$(GetCPUInfo 0)"
		echo -e "Executing benchmark twice on cluster 0${CPUInfo}\n" >>${ResultLog}
		for bytelength in 128 192 256 ; do
			openssl speed -elapsed -evp aes-${bytelength}-cbc 2>/dev/null
			openssl speed -elapsed -evp aes-${bytelength}-cbc 2>/dev/null
		done | tr '[:upper:]' '[:lower:]' >${OpenSSLLog}
	else
		# different package ids, we walk through all clusters
		echo -e "Executing benchmark on each cluster individually\n" >>${ResultLog}
		for bytelength in 128 192 256 ; do
			for i in $(seq 0 $(( ${#ClusterConfig} -1 )) ) ; do
				taskset -c ${ClusterConfig:$i:1} openssl speed -elapsed -evp aes-${bytelength}-cbc 2>/dev/null
			done
		done | tr '[:upper:]' '[:lower:]' >${OpenSSLLog}
	fi
	kill ${MonitoringPID}
	echo -e "$(openssl version | awk -F" " '{print $1" "$2", built on "$3" "$4" "$5" "$6" "$7" "$8" "$9" "$10" "$11" "$12" "$13" "$14" "$15}' | sed 's/ *$//')\n$(grep '^type' ${OpenSSLLog} | head -n1)" >>${ResultLog}
	grep '^aes-' ${OpenSSLLog} >>${ResultLog}
	AES128=$(( $(awk '/^aes-128-cbc/ {print $2}' <"${OpenSSLLog}" | awk -F"." '{s+=$1} END {printf "%.0f", s}') / 2 ))
	AES256=$(( $(awk '/^aes-256-cbc/ {print $7}' <"${OpenSSLLog}" | awk -F"." '{s+=$1} END {printf "%.0f", s}') / 2 ))
	OpenSSLScore="$(( $(awk '{printf ("%0.0f",$1/10); }' <<<"${AES128}") * 10 )) | $(( $(awk '{printf ("%0.0f",$1/10); }' <<<"${AES256}") * 10 ))"
} # RunOpenSSLBenchmark

RunCpuminerBenchmark() {
	echo -e "\x08\x08 Done.\nExecuting cpuminer. 5 more minutes to wait...\c"
	echo -e "\nSystem health while running cpuminer:\n" >>${MonitorLog}
	/bin/bash "${PathToMe}" -m 40 >>${MonitorLog} &
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
	CpuminerScore="$(awk -F"," '{print $2}' <<<"${TotalScores}")"
} # RunCpuminerBenchmark

PrintCPUTopology() {
	# prints list of CPU cores, clusters and cpufreq policy nodes
	X86CPUName="$(sed -e 's/1.th Gen //' -e 's/.th Gen //' -e 's/Core(TM) //' -e 's/ Processor//' -e 's/Intel(R) Xeon(R) CPU //' -e 's/Intel(R) //' -e 's/(R)//' -e 's/CPU //' -e 's/ 0 @/ @/' -e 's/AMD //' -e 's/Authentic //' -e 's/ with .*//' <<<"${DeviceName}")"
	echo "CPU sysfs topology (clusters, cpufreq members, clockspeeds)"
	echo "                 cpufreq   min    max"
	echo " CPU    cluster  policy   speed  speed   core type"
	for i in $(seq 0 $(( ${CPUCores} - 1 )) ); do
		CoreName="$(GetCPUType $i)"
		# check if CoreName is empty
		if [ "X${CoreName}" = "X" -a "X${DeviceName}" != "X" ]; then
			# try to return CPU type instead of core type on x86 if available
			[[ ${CPUArchitecture} == *86* ]] && \
				CoreName="${X86CPUName}"
		fi
		read CPUCluster </sys/devices/system/cpu/cpu${i}/topology/physical_package_id
		if [ -d /sys/devices/system/cpu/cpufreq/policy${i} ]; then
			CPUFreqPolicy=${i}
			CPUSpeedMin=$(awk '{printf ("%0.0f",$1/1000); }' </sys/devices/system/cpu/cpufreq/policy${i}/scaling_min_freq)
			CPUSpeedMax=$(awk '{printf ("%0.0f",$1/1000); }' </sys/devices/system/cpu/cpufreq/policy${i}/scaling_max_freq)
		fi
		if [ -n ${CPUFreqPolicy} ]; then
			echo  "$(printf "%3s" ${i})$(printf "%9s" ${CPUCluster})$(printf "%9s" ${CPUFreqPolicy})$(printf "%9s" ${CPUSpeedMin})$(printf "%8s" ${CPUSpeedMax})   ${CoreName:-"    -"}"
		else
			echo "$(printf "%3s" ${i})$(printf "%9s" ${CPUCluster})        -       -      -     ${CoreName:-"    -"}"
		fi
	done
	echo ""
} # PrintCPUTopology

SummarizeResults() {
	# report rounded up benchmark duration
	BenchmarkFinishedTime=$(date +"%s")
	BenchmarkDuration=$(( $(( ${BenchmarkFinishedTime} - ${BenchmarkStartTime} +59 )) / 60 ))
	echo -e "\x08\x08 Done (${BenchmarkDuration} minutes elapsed).\n\007\007\007"

	# only check for throttling in normal mode and not when plotting performance/mhz graphs
	[ "X${PlotCpufreqOPPs}" = "Xyes" ] || CheckForThrottling

	# Check %iowait percentage as an indication of swapping happened
	IOWait=$(CheckIOWait)

	# Prepare benchmark results
	echo -e "\n##########################################################################\n" >>${ResultLog}
	
	# add thermal info if available
	if [ "X${TempInfo}" != "X" ]; then
		echo -e "${TempInfo}\n" >>${ResultLog}
	fi

	# include monitoring (filter out broken thermal readouts)
	sed 's/  0°C$/ --/' <${MonitorLog} >>${ResultLog}
	
	# add throttling info if available
	if [ -f ${TempDir}/throttling_info.txt ]; then
		echo -e "\n##########################################################################" >>${ResultLog}
		cat ${TempDir}/throttling_info.txt >>${ResultLog}
	fi

	# add dmesg output since start of the benchmark if something relevant is there
	TimeStamp="$(dmesg | tr -d '[' | tr -d ']' | awk -F" " '/sbc-bench started/ {print $1}' | tail -n1)"
	dmesg | sed "/${TimeStamp}/,\$!d" | grep -v 'sbc-bench started' >"${TempDir}/dmesg"
	if [ -s "${TempDir}/dmesg" ]; then
		echo -e "\n##########################################################################\n\ndmesg output while running the benchmarks:\n" >>${ResultLog}
		cat "${TempDir}/dmesg" >>${ResultLog}
	fi

	echo -e "\n##########################################################################\n" >>${ResultLog}
	echo -e "$(iostat | grep -v "^loop")\n\n$(free -h)\n\n$(swapon -s)\n" | sed '/^$/N;/^\n$/D' >>${ResultLog}
	PrintCPUTopology >>${ResultLog}
	lscpu >>${ResultLog}
	LogEnvironment >>${ResultLog}
	CacheAndDIMMDetails >>${ResultLog}

	# Add a line suitable for Results.md on Github if not in efficiency plotting mode
	if [ "X${PlotCpufreqOPPs}" != "Xyes" ]; then
		if [ -f /sys/devices/system/cpu/cpufreq/policy0/cpuinfo_max_freq ]; then
			MHz="$(sort -n -r /sys/devices/system/cpu/cpufreq/policy?/cpuinfo_max_freq | head -n 2 | tr '\n' '/' | sed -e 's|000/|/|g' -e 's|/$||') MHz"
		else
			MHz="no cpufreq support"
		fi
		KernelVersion="$(awk -F"." '{print $1"."$2}' <<<"${KernelVersion}")"
		KernelArch="$(uname -m | sed -e 's/armv7l/armhf/' -e 's/aarch64/arm64/')"
		if [ "X${KernelArch}" = "X" -o "X${KernelArch}" = "X${ARCH}" ]; then
			DistroInfo="$(cut -c-1 <<<"${Distro##*/}" | tr '[:lower:]' '[:upper:]')$(cut -c2- <<<"${Distro##*/}") ${ARCH}"
		else
			DistroInfo="$(cut -c-1 <<<"${Distro##*/}" | tr '[:lower:]' '[:upper:]')$(cut -c2- <<<"${Distro##*/}") ${KernelArch}/${ARCH}"
		fi
		echo -e "\n| ${DeviceName:-$HostName} | ${MHz} | ${KernelVersion} | ${DistroInfo} | ${ZipScore} | ${OpenSSLScore} | ${MemBenchScore} | ${CpuminerScore:-"-"} |\c" >>${ResultLog}
	fi
} # SummarizeResults

LogEnvironment() {
	# Log compiler version
	GCC_Info="$(${GCC} -v 2>&1 | egrep "^Target|^Configured")"
	echo -e "\nCompiler: ${GCC} $(cut -f1 -d')' <<<${GCC_Version})/$(awk -F": " '/^Target/ {print $2}' <<< "${GCC_Info}"))"
	# awk -F": " '/^Configured/ {print $2}' <<< "${GCC_Info}"
	# Log userland architecture if available
	[ "X${ARCH}" != "X" ] && echo "Userland: ${ARCH}"
	# Log ThreadX version if available
	[ "X${ThreadXVersion}" != "X" ] && echo -e \
		" ThreadX: $(awk '/^version/ {print $2}' <<<"${ThreadXVersion}") / $(head -n1 <<<"${ThreadXVersion}")"
	# check for VM/container mode to add this to kernel info
	VirtWhat="$(systemd-detect-virt 2>/dev/null)"
	[ "X${VirtWhat}" != "X" -a "X${VirtWhat}" != "Xnone" ] && VirtOrContainer=" (${VirtWhat})"
	# kernel info
	KernelVersion="$(uname -r)"
	echo -e "  Kernel: ${KernelVersion}/${CPUArchitecture}${VirtOrContainer}"
	# kernel config
	KernelConfig="/boot/config-${KernelVersion}"
	if [ -f "${KernelConfig}" ] ; then
		grep -E "^CONFIG_HZ|^CONFIG_PREEMPT" "${KernelConfig}" | while read ; do echo "          ${REPLY}"; done | sort -V
	else
		modprobe configs 2>/dev/null
		[ -f /proc/config.gz ] && zgrep -E "^CONFIG_HZ|^CONFIG_PREEMPT" /proc/config.gz | \
			while read ; do echo "          ${REPLY}"; done | sort -V
	fi
} # LogEnvironment

UploadResults() {
	UploadURL=$(curl -s -F 'f:1=<-' ix.io <${ResultLog} 2>/dev/null || curl -s -F 'f:1=<-' ix.io <${ResultLog})

	# Display benchmark results
	[ "${ClusterConfig}" = "0" ] || ClusterInfo=" (different CPU cores measured individually)"
	echo -e "${BOLD}Memory performance${NC}${ClusterInfo}:"
	awk -F" " '/^ standard/ {print $2": "$4" "$5" "$6}' <${ResultLog}
	if [ "${ExecuteCpuminer}" = "yes" -a -x "${InstallLocation}"/cpuminer-multi/cpuminer ]; then
		echo -e "\n${BOLD}Cpuminer total scores${NC} (5 minutes execution): $(awk -F"Total Scores: " '/^Total Scores: / {print $2}' ${ResultLog}) kH/s"
	fi
	echo -e "\n${BOLD}7-zip total scores${NC} (3 consecutive runs): $(awk -F" " '/^Total:/ {print $2}' ${ResultLog})"
	if [ -f ${OpenSSLLog} ]; then
		echo -e "\n${BOLD}OpenSSL results${NC}${ClusterInfo}:\n$(grep '^type' ${OpenSSLLog} | head -n1)"
		grep '^aes-' ${OpenSSLLog}
	fi
	case ${UploadURL} in
		http*)
			# uploading results worked, check sanity of results and environment
			echo " [${UploadURL}](${UploadURL}) |" >>${ResultLog}
			echo -e "\nFull results uploaded to ${UploadURL}. \c"
			# check whether benchmark ran into a sane environment (no throttling and no swapping)
			if [ ${IOWait:-0} -le 5 -a ! -f ${TempDir}/throttling_info.txt ]; then
				# in case it's not x86/x64 then also suggest adding results to official list
				case ${CPUArchitecture} in
					x86*|i686)
						# Collecting x86 results is somewhat pointless. At least inform
						# about environment the benchmark was running in
						VirtWhat="$(systemd-detect-virt 2>/dev/null)"
						Manufacturer="$(dmidecode -t system 2>/dev/null | awk -F": " '/Manufacturer:/ {print $2}')"
						case "${Manufacturer}" in
							"")
								# No dmidecode output as such check where we're running
								if [ "X${VirtWhat}" = "X" -o "X${VirtWhat}" = "Xnone" ]; then
									echo -e "\n"
								else
									echo -e "Please be aware that benchmark was running inside a ${VirtWhat} instance\n"
								fi
								;;
							*)
								# Check whether virtualization flags are present
								grep -q ^flags.*\ hypervisor /proc/cpuinfo
								case $? in
									0)
										echo -e "Please be aware that benchmark was running inside a ${Manufacturer}/${VirtWhat} instance\n"
										;;
									*)
										echo -e "\n"
										;;
								esac
								;;
						esac
						;;
					*)
						echo -e "\n\nIn case this device ${BOLD}is not already represented${NC} in official sbc-bench results list then please"
						echo -e "consider submitting it at https://github.com/ThomasKaiser/sbc-bench/issues with this line:"
						tail -n 1 "${ResultLog}"
						echo
						;;
				esac
			else
				echo -e "Please check the log for anomalies (e.g. swapping\nor throttling happenend).\n"
			fi
			;;
		*)
			echo -e "\nUnable to upload full test results. Please copy&paste the below stuff to pastebin.com and\nprovide the URL. Check the output for throttling and swapping please.\n\n"
			cat ${ResultLog}
			echo -e "\n\n"
			;;
	esac

	# write continous log, see
	# Skip log writing if log is a symlink to somewhere else
	[ -h /var/log/sbc-bench.log ] && return 1
	[ -s /var/log/sbc-bench.log ] && echo -e "\n\n\n" >>/var/log/sbc-bench.log
	cat ${ResultLog} >>/var/log/sbc-bench.log
} # UploadResults

CheckIOWait() {
	IOWait="$(awk -F" " '/^[0-9]/ {print $8}' <"${MonitorLog}" | sed 's/%//')"
	LogLength=$(wc -l <<<"${IOWait}")
	IOWaitSum="$(awk '{s+=$1} END {printf "%.0f", s}' <<<"${IOWait}")"
	echo $(( ${IOWaitSum} * 10 / ${LogLength} ))
} # CheckIOWait

CheckForThrottling() {
	# Check for throttling on normal ARM SBC
	if [ -f /sys/devices/system/cpu/cpufreq/policy0/stats/time_in_state ]; then
		ls /sys/devices/system/cpu/cpufreq/policy?/stats/time_in_state | sort | while read ; do
			Number=$(echo ${REPLY} | tr -c -d '[:digit:]')
			diff ${TempDir}/time_in_state_after_${Number} ${TempDir}/time_in_state_before_${Number} >/dev/null 2>&1
			if [ $? -ne 0 ]; then
				if [ "${ClusterConfig}" = "0" ]; then
					# all CPU cores have same cpufreq policies, we report globally
					ReportCpufreqStatistics ${Number}
					echo -e "${LRED}${BOLD}ATTENTION: Throttling might have occured. Check the log for details.${NC}\n"
				else
					# report affected cluster
					for i in $(seq 0 $(( ${#ClusterConfig} -1 )) ) ; do
						if [ ${ClusterConfig:$i:1} -eq ${Number} ]; then
							FirstCore=${Number}
							LastCore=$(GetLastClusterCore $(( ${i} + 1 )))
							CPUInfo="$(GetCPUInfo ${Number})"
							ReportCpufreqStatistics ${Number} " for CPUs ${FirstCore}-${LastCore}${CPUInfo}"
							echo -e "${LRED}${BOLD}ATTENTION: Throttling might have occured on CPUs ${FirstCore}-${LastCore}${CPUInfo}. Check the log for details.${NC}\n"
						fi
					done
				fi
			fi
		done
	fi

	# Check for killed CPU cores. Some unfortunate users might still use Allwinner BSP kernels
	CPUCoresNow=$(grep -c '^processor' /proc/cpuinfo)
	if [ ${CPUCoresNow} -lt ${CPUCores} ]; then
		echo -e "${LRED}${BOLD}ATTENTION: Due to overheating prevention $(( ${CPUCores} - ${CPUCoresNow} )) CPU cores have been killed. Check the log for details.${NC}\n"
	fi

	# Check for throttling/undervoltage on Raspberry Pi
	grep -q '1400/1200MHz' ${MonitorLog} && Warning="ATTENTION: Silent throttling has occured. Check the log for details."
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
			BeforeValue=$(awk -F" " "/^${REPLY} / {print \$2}" <${TempDir}/full_time_in_state_before_${1})
			AfterValue=$(awk -F" " "/^${REPLY} / {print \$2}" <${TempDir}/full_time_in_state_after_${1})
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

CacheAndDIMMDetails() {
	DIMMFilter="$(echo -e "Locator:|\tVolatile Size:|\tType:|Speed:|\tRank:")"
	DIMMDetails="$(dmidecode -t memory 2>/dev/null | egrep "${DIMMFilter}" | sed "/\tLocator:/i \ ")"
	if [ "X${DIMMDetails}" != "X" ]; then
		echo -e "\nDIMM configuration:\c"
		# check whether 'Volatile Size' is contained and if not include full command output
		grep -q "Volatile Size:" <<<"${DIMMDetails}" && \
			echo -e "${DIMMDetails}" | egrep -v ": Unknown|: None" || \
			(echo ; dmidecode -t memory 2>/dev/null | \
			egrep -v "^Handle |^# dmidecode |^Getting SMBIOS data|^SMBIOS |Serial Number:" \
			| sed '/^$/N;/^\n$/D')
		# check wether there's even more detailed DIMM info available via i2c
		unset DIMMDetails
		modprobe eeprom >/dev/null 2>&1
		command -v decode-dimms >/dev/null 2>&1 || apt -f -qq -y install i2c-tools >/dev/null 2>&1
		command -v decode-dimms >/dev/null 2>&1 && \
			DIMMDetails="$(decode-dimms 2>/dev/null | sed -ne '/Decoding EEPROM/,$ p' | sed '/^$/N;/^\n$/D' | grep -v Serial)"
		if [ "X${DIMMDetails}" != "X" ]; then
			echo -e "\n${DIMMDetails}"
		fi
	fi
	find /sys/devices/system/cpu -name "cache" -type d | sort -V | while read ; do
		find "${REPLY}" -name size -type f | while read ; do
			echo -e "\n${REPLY}: $(cat ${REPLY})\c"
			[ -f ${REPLY%/*}/level ] && echo -e ", level: $(cat ${REPLY%/*}/level)\c"
			[ -f ${REPLY%/*}/type ] && echo -e ", type: $(cat ${REPLY%/*}/type)\c"
		done
	done | sed -e 's|/sys/devices/system/cpu/||' -e 's|cache/||' -e 's|/size||'
	echo ""
} # CacheAndDIMMDetails

DisplayUsage() {
	echo -e "\nUsage: ${BOLD}${0##*/} [-c] [-p] [-h] [-m] [-t \$degree] [-T \$degree]${NC}\n"
	echo -e "############################################################################"
	echo -e "\n Use ${BOLD}${0##*/}${NC} for the following tasks:\n"
	echo -e " ${0##*/} invoked without arguments runs a standard benchmark"
	echo -e " ${0##*/} ${BOLD}-c${NC} also executes cpuminer test (NEON/SSE)"
	echo -e " ${0##*/} ${BOLD}-p${NC} plots 7-zip MIPS graph for every cpufreq OPP"
	echo -e " ${0##*/} ${BOLD}-h${NC} displays this help text"
	echo -e " ${0##*/} ${BOLD}-m${NC} [\$seconds] provides CLI monitoring (5 sec default interval)"
	echo -e " ${0##*/} ${BOLD}-t${NC} [\$degree] runs thermal test waiting to cool down to this value"
	echo -e " ${0##*/} ${BOLD}-T${NC} [\$degree] runs thermal test heating up to this value\n"
	echo -e " With a Netio powermeter accessible you can export ${BOLD}Netio=address/socket${NC}" to
	echo -e " sbc-bench defining address and socket this device is plugged into. Requires"
	echo -e " XML API enabled and read-only access w/o password. Use this ${BOLD}only${NC} with -p to"
	echo -e " draw efficiency graphs since results will be slightly tampered by this mode."
	echo -e "\n############################################################################\n"
} # DisplayUsage

# Allows the script to be sourced
[[ "${BASH_SOURCE}" = "$0" ]] && Main "$@"
