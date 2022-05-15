#!/bin/bash

Version=0.9.6
InstallLocation=/usr/local/src # change to /tmp if you want tools to be deleted after reboot

Main() {
	export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/vc/bin
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
	VCGENCMD=$(command -v vcgencmd)
	if [ -z "${USE_VCGENCMD}" -a -x "${VCGENCMD}" ]; then
		# this seems to be a Raspberry Pi where we need to query
		# ThreadX on the VC via vcgencmd to get real information
		USE_VCGENCMD=true
	else
		USE_VCGENCMD=false
	fi
	
	# check in which mode we're supposed to run
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
		RunRamlat
		RunOpenSSLBenchmark
		Run7ZipBenchmark
		if [ "${ExecuteCpuminer}" = "yes" ]; then
			if [ -x "${InstallLocation}"/cpuminer-multi/cpuminer ]; then
				RunCpuminerBenchmark
			else
				echo -e "\x08\x08 Done.\n(${InstallLocation}/cpuminer-multi/cpuminer missing or not executable)...\c"
			fi
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
	41/d40:Neoverse-V1
	41/d41:Cortex-A78
	41/d42:Cortex-A78AE
	41/d44:Cortex-X1
	41/d46:Cortex-510
	41/d47:Cortex-710
	41/d48:Cortex-X2
	41/d49:Neoverse-N2
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
	51/803:Qualcomm Kryo 3XX Silver
	51/804:Qualcomm Kryo 4XX Gold
	51/805:Qualcomm Kryo 4XX Silver
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

GetARMStepping() {
	# Parse '^CPU variant|^CPU revision' fields from /proc/cpuinfo and transform them
	# into 'Stepping' like lscpu does (the latter only showing info for cpu0 so partially
	# useless on systems with different CPU clusters)
	if [ -n "${ARMStepping}" ]; then
		echo "r$(sed 's/^0x//' <<<${ARMStepping[$(( $1 * 2 ))]})p${ARMStepping[$(( $(( $1 * 2 )) + 1 ))]}"
	fi
} # GetARMStepping

GetCPUInfo() {
	# function that returns ARM core type in brackets if possible otherwise empty string
	ARMCore="$(GetCPUType $1)"
	[ -n "${ARMCore}" ] && echo -n " (${ARMCore})"
} # GetCPUInfo

GetLastClusterCore() {
	NextCore=${ClusterConfig[$1]}
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
		CheckPerformance "all CPU cores" $(tr -d '[:space:]' <<<${ClusterConfig[@]})
		PlotGraph "all CPU cores" $(tr -d '[:space:]' <<<${ClusterConfig[@]})
		RenderPDF
	else
		# -p with additional options has been called
		case ${CPUList} in
			cores)
				# check each core of every cluster, on RK3399 for example 0 and 4
				for i in $(seq 0 $(( ${#ClusterConfig[@]} -1 )) ) ; do
					FirstCore=${ClusterConfig[$i]}
					CheckPerformance "CPU ${FirstCore}" "${FirstCore}" "${FirstCore}"
					CPUInfo="$(GetCPUInfo ${FirstCore})"
					PlotGraph "CPU ${FirstCore}${CPUInfo}" "${FirstCore}"
				done
				RenderPDF
				;;
			clusters)
				# check all cores of every cluster, on RK3399 for example 0-3 and 4-5
				for i in $(seq 0 $(( ${#ClusterConfig[@]} -1 )) ) ; do
					FirstCore=${ClusterConfig[$i]}
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
				for i in $(seq 0 $(( ${#ClusterConfig[@]} -1 )) ) ; do
					FirstCore=${ClusterConfig[$i]}
					CheckPerformance "CPU ${FirstCore}" "${FirstCore}" "${FirstCore}"
					CPUInfo="$(GetCPUInfo ${FirstCore})"
					PlotGraph "CPU ${FirstCore}${CPUInfo}" "${FirstCore}"
				done
				for i in $(seq 0 $(( ${#ClusterConfig[@]} -1 )) ) ; do
					FirstCore=${ClusterConfig[$i]}
					LastCore=$(GetLastClusterCore $(( $i + 1 )))
					CheckPerformance "CPU ${FirstCore}-${LastCore}" "${FirstCore}" "${FirstCore}-${LastCore}"
					CPUInfo="$(GetCPUInfo ${FirstCore})"
					PlotGraph "CPU ${FirstCore}-${LastCore}${CPUInfo}" "${FirstCore}"
				done
				if [ ${#ClusterConfig[@]} -gt 1 ]; then
					# more than one CPU cluster, we test using all cores simultaneously
					CheckPerformance "all CPU cores" $(tr -d '[:space:]' <<<${ClusterConfig[@]})
					PlotGraph "all CPU cores" $(tr -d '[:space:]' <<<${ClusterConfig[@]})
				fi
				RenderPDF
				;;
			*)
				# individual taskset options have been provided, e.g. 0-2 or 3
				if [ ${#CPUList} -eq 1 ]; then
					# single core to be tested, we need to determine correct policy node
					for i in $(seq 0 $(( ${#ClusterConfig[@]} -1 )) ) ; do
						FirstCore=${ClusterConfig[$i]}
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
	for i in $((tr " " "\n" <${BiggestCluster}/scaling_available_frequencies ; tr " " "\n" <${BiggestCluster}/scaling_boost_frequencies) 2>/dev/null | sort -n | uniq | sed '/^[[:space:]]*$/d') ; do
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
			ThreadXFreq=$("${VCGENCMD}" measure_clock arm | awk -F"=" '{printf ("%0.0f",$2/1000000); }' )
			CoreVoltage=$("${VCGENCMD}" measure_volts | cut -f2 -d= | sed 's/000//')
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
	# In Armbian we can not rely on /etc/armbianmonitor/datasources/soctemp at all any more
	# since nobody is left there who cares about /usr/lib/armbian/armbian-hardware-monitor
	if [ -f /etc/armbianmonitor/datasources/soctemp ]; then
		TempSource=/etc/armbianmonitor/datasources/soctemp
		ThermalNode="$(readlink /etc/armbianmonitor/datasources/soctemp)"
		if [ -f "${ThermalNode%/*}/name" ]; then
			read ThermalSource <"${ThermalNode%/*}/name" 2>/dev/null
		elif [ -f "${ThermalNode%/*}/type" ]; then
			read ThermalSource <"${ThermalNode%/*}/type" 2>/dev/null
		fi
		case ${ThermalSource} in
			# check name/type of thermal node Armbian 'has chosen' (it's an unmaintained
			# mess since 2018)
			aml_thermal|cpu|cpu_thermal*|cpu-thermal*|cpu0-thermal*|cpu0_thermal*|soc_thermal*|soc-thermal*|CPU-therm|x86_pkg_temp)
				# Seems like a good find
				TempInfo="Thermal source: ${ThermalNode%/*}/ (${ThermalSource})"
				;;
			nvme|w1_slave_temp)
				# Obviously wrong
				TempInfo="Wrong thermal source: /etc/armbianmonitor/datasources/soctemp (${ThermalSource})"
				;;
			*)
				# Quick results check within one week showed the following types which
				# smell all not that good if it's about CPU or SoC temperatures:
				# scpi_sensors, w1_slave_temp, thermal-fan-est, iio_hwmon
				NodeGuess=$(cat /sys/devices/virtual/thermal/thermal_zone?/type 2>/dev/null | egrep "cpu|soc|CPU-therm|x86_pkg_temp" | tail -n1)
				if [ "X${NodeGuess}" != "X" ]; then
					# let's use this thermal node instead
					TempSource="$(mktemp /tmp/soctemp.XXXXXX)"
					ThermalZone="$(GetThermalZone "${NodeGuess}")"
					ln -fs ${ThermalZone}/temp ${TempSource}
					# TempInfo="Thermal source: ${ThermalZone}/ (${NodeGuess} / Armbian would have chosen ${ThermalSource} instead)"
					TempInfo="Thermal source: ${ThermalZone}/ (${NodeGuess})\n                (Armbian wants to use ${ThermalNode%/*} instead, that\n                zone is named ${ThermalSource}. Please check and if wrong\n                file a bug here: https://github.com/armbian/build/issues/)"
				else
					# use Armbian's 'choice' since no better match was found
					OtherTempZones="$(cat /sys/devices/virtual/thermal/thermal_zone?/type | grep -v "${ThermalSource}" | tr '\n' ',' | sed -e 's/,/, /g' -e 's/, $//')"
					if [ "X${OtherTempZones}" = "X" ]; then
						# no other thermal zones available
						TempInfo="Thermal source: ${ThermalNode%/*}/ (${ThermalSource})"
					else
						# report other thermal zones as well
						TempInfo="Thermal source: ${ThermalNode%/*}/ (${ThermalSource})\n                (other sensors found: ${OtherTempZones})"
					fi
				fi
				;;
		esac
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
				else
					NodeGuess=$(cat /sys/devices/virtual/thermal/thermal_zone?/type 2>/dev/null | egrep "aml_thermal|cpu|soc" | tail -n1)
					if [ "X${NodeGuess}" != "X" ]; then
						# let's use this thermal node
						ThermalZone="$(GetThermalZone "${NodeGuess}")"
						ln -fs ${ThermalZone}/temp ${TempSource}
						TempInfo="Thermal source: ${ThermalZone}/ (${NodeGuess})"
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
		CPUTopology="$(PrintCPUTopology)"
		CPUSignature="$(GetCPUSignature)"
		GuessedSoC="$(GuessARMSoC)"
		[ "X${GuessedSoC}" != "X" ] && echo -e "${GuessedSoC}, \c"
		grep -q "BCM2711" <<<"${DeviceName}" && echo -e "${DeviceName}, \c"
		command -v dpkg >/dev/null 2>&1 && Userland=", Userland: $(dpkg --print-architecture 2>/dev/null)"
		VirtWhat="$(systemd-detect-virt 2>/dev/null)"
		[ "X${VirtWhat}" != "X" -a "X${VirtWhat}" != "Xnone" ] && VirtOrContainer=" / ${BOLD}${VirtWhat}${NC}"
		echo -e "Kernel: ${CPUArchitecture}${VirtOrContainer}${Userland}"
		echo -e "${CPUTopology}\n"
		if [ "X${TempInfo}" != "X" ]; then
			echo -e "${TempInfo}\n"
		fi
	fi

	# Background monitoring

	# Try to renice to 19 to not interfere with benchmark behaviour
	renice 19 $BASHPID >/dev/null 2>&1

	CpuFreqToQuery=cpuinfo_cur_freq
	CPUArchitecture="$(lscpu | awk -F" " '/^Architecture/ {print $2}')"
	ClusterConfig=($(GetCPUClusters))

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
	elif [ ${#ClusterConfig[@]} -eq 1 -a -f /sys/devices/system/cpu/cpufreq/policy0/${CpuFreqToQuery} ] ; then
		DisplayHeader="Time        CPU    load %cpu %sys %usr %nice %io %irq   Temp${NetioHeader}"
		CPUs=singlecluster
	elif [ -f /sys/devices/system/cpu/cpufreq/policy${ClusterConfig[1]}/${CpuFreqToQuery} ]; then
		ClusterCount=$(( ${#ClusterConfig[@]} -1 ))
		DisplayHeader="Time       big.LITTLE   load %cpu %sys %usr %nice %io %irq   Temp${NetioHeader}"
		read FirstCluster </sys/devices/system/cpu/cpufreq/policy${ClusterConfig[0]}/cpuinfo_max_freq
		read LastCluster </sys/devices/system/cpu/cpufreq/policy${ClusterConfig[$ClusterCount]}/cpuinfo_max_freq
		if [ ${LastCluster} -ge ${FirstCluster} ]; then
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
				RealFreq=$("${VCGENCMD}" measure_clock arm | awk -F"=" '{printf ("%0.0f",$2/1000000); }' )
				CoreVoltage=$("${VCGENCMD}" measure_volts | cut -f2 -d= | sed 's/000//')
				echo -e "$(date "+%H:%M:%S"): $(printf "%4s" ${FakeFreq})/$(printf "%4s" ${RealFreq})MHz $(printf "%5s" ${LoadAvg}) ${procStats}  $(printf "%4s" ${SocTemp})°C  $(printf "%7s" ${CoreVoltage})${NetioColumn}"
				;;
			biglittle)
				BigFreq=$(awk '{printf ("%0.0f",$1/1000); }' </sys/devices/system/cpu/cpufreq/policy${ClusterConfig[$ClusterCount]}/${CpuFreqToQuery} 2>/dev/null)
				LittleFreq=$(awk '{printf ("%0.0f",$1/1000); }' </sys/devices/system/cpu/cpufreq/policy${ClusterConfig[0]}/${CpuFreqToQuery} 2>/dev/null)
				echo -e "$(date "+%H:%M:%S"): $(printf "%4s" ${BigFreq})/$(printf "%4s" ${LittleFreq})MHz $(printf "%5s" ${LoadAvg}) ${procStats}  $(printf "%4s" ${SocTemp})°C${NetioColumn}"
				;;
			littlebig)
				BigFreq=$(awk '{printf ("%0.0f",$1/1000); }' </sys/devices/system/cpu/cpufreq/policy${ClusterConfig[0]}/${CpuFreqToQuery} 2>/dev/null)
				LittleFreq=$(awk '{printf ("%0.0f",$1/1000); }' </sys/devices/system/cpu/cpufreq/policy${ClusterConfig[$ClusterCount]}/${CpuFreqToQuery} 2>/dev/null)
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
			echo -e "When running on other distros results are partially meaningless or can't be collected.\nPress [ctrl]-[c] to stop or [enter] to continue.\c"
			read
			;;
	esac
} # CheckRelease

CheckLoad() {
	# Only continue if average load is less than 0.1 or averaged CPU utilization is lower
	# than 2.5% for 30 sec. Please note that average load on Linux is *not* the same as CPU
	# utilization: https://www.brendangregg.com/blog/2017-08-08/linux-load-averages.html
	AvgLoad1Min=$(awk -F" " '{print $1*100}' < /proc/loadavg)
	if [ $AvgLoad1Min -ge 10 ]; then
		echo -e "\nAverage load and/or CPU utilization too high (too much background activity). Waiting...\n"
		/bin/bash "${PathToMe}" -m 5 >"${TempDir}/wait-for-loadavg.log" &
		MonitoringPID=$!
		while [ $AvgLoad1Min -ge 10 -a ${CPUSum:-100} -ge 15 ]; do
			sleep 5
			CPUutilization="$(awk -F" " '/^[0-9]/ {print $4}' <"${TempDir}/wait-for-loadavg.log" | sed 's/%//' | tail -n6)"
			LogLength=$(wc -l <<<"${CPUutilization}")
			if [ ${LogLength} -gt 5 ]; then
				CPUSum="$(awk '{s+=$1} END {printf "%.0f", s}' <<<"${CPUutilization}")"
			else
				CPUSum=100
			fi
			echo -e "Too busy for benchmarking:$(uptime),  cpu: $(tail -n1 <<<"${CPUutilization}")%"
			AvgLoad1Min=$(awk -F" " '{print $1*100}' < /proc/loadavg)
		done
		kill ${MonitoringPID}
	fi
	echo ""
} # CheckLoad

GetCPUClusters() {
	if [ -d /sys/devices/system/cpu/cpufreq/policy0 -a "${CPUArchitecture}" != "x86_64" ]; then
		# cpufreq support exists on ARM, we rely on this
		ls -ld /sys/devices/system/cpu/cpufreq/policy? | awk -F"policy" '{print $2}'
	else
		# check for different CPU types based on package ids. This allows to test through
		# different cores even on systems with no cpufreq support.
		SYS=/sys/devices/system/cpu
		for PKG_ID in $(cat "${SYS}"/cpu*/topology/physical_package_id | sort | uniq); do
	 	   dirname $(dirname $(grep "^${PKG_ID}$" "${SYS}"/cpu*/topology/physical_package_id | head -n1)) | tr -d -c '[:digit:]'
	 	   echo " "
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
			ARMStepping=($(awk -F": " '/^CPU variant|^CPU revision/ {print $2}' /proc/cpuinfo))
			case ${DeviceName} in
				"Raspberry Pi 4"*)
					# https://github.com/raspberrypi/linux/issues/3210#issuecomment-680035201
					# get SoC revision based on mmc controller's bus location
					od -An -tx1 /proc/device-tree/emmc2bus/dma-ranges 2>/dev/null | tr -d '[:space:]' | \
						grep -q 'c0000000000000000000000040' && BCM2711="B0" || BCM2711="C0 or later"
					DeviceName="$(sed 's/Raspberry Pi/RPi/' <<<"${DeviceName}") / BCM2711 Rev ${BCM2711}"
					;;
			esac		
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

	ClusterConfig=($(GetCPUClusters))
	CPUCores=$(grep -c '^processor' /proc/cpuinfo)
} # BasicSetup

CheckMissingPackages() {
	# check for missing packages and construct installation string with list of needed packages
	command -v apt >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		# Debian/Ubuntu/Linux Mint
		echo -e "apt -f -qq -y install \c"
		command -v gcc >/dev/null 2>&1 || echo -e "gcc make build-essential \c"
	fi
	command -v pacman >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		# Arch/Manjaro
		echo -e "pacman --noconfirm -Sq \c"
		command -v gcc >/dev/null 2>&1 || echo -e "gcc make base-devel \c"
	fi	
	command -v iostat >/dev/null 2>&1 || echo -e "sysstat \c"
	command -v git >/dev/null 2>&1 || echo -e "git \c"
	command -v openssl >/dev/null 2>&1 || echo -e "openssl \c"
	command -v curl >/dev/null 2>&1 || echo -e "curl \c"
	command -v dmidecode >/dev/null 2>&1 || echo -e "dmidecode \c"
	command -v decode-dimms >/dev/null 2>&1 || echo -e "i2c-tools \c"
	command -v sensors >/dev/null 2>&1 || echo -e "lm-sensors \c"
}

InstallPrerequisits() {
	echo -e "sbc-bench v${Version}\n\nInstalling needed tools. This may take some time...\c"
	
	# Determine missing packages and install them with a single command
	MissingPackages="$(CheckMissingPackages)"
	SevenZip=$(command -v 7zr || command -v 7za)
	if [ -z "${SevenZip}" ]; then
		# add needed repository and install 7-zip and all other packages
		add-apt-repository -y universe >/dev/null 2>&1
		${MissingPackages} p7zip >/dev/null 2>&1
		SevenZip=$(command -v 7zr || command -v 7za)
	else
		# 7-zip already there, just install other missing packages if needed
		${MissingPackages} >/dev/null 2>&1
	fi

	[ -z "${SevenZip}" ] && (echo "${LRED}${BOLD}No 7-zip binary found and could not be installed. Aborting${NC}" >&2 ; exit 1)

	if [ "${PlotCpufreqOPPs}" = "yes" ]; then
		command -v htmldoc >/dev/null 2>&1 || apt -f -qq -y --no-install-recommends install htmldoc >/dev/null 2>&1
		command -v gnuplot >/dev/null 2>&1 || apt -f -qq -y --no-install-recommends install gnuplot-nox >/dev/null 2>&1
	fi

	# get/build tinymembench if not already there
	[ -d "${InstallLocation}" ] || mkdir -p "${InstallLocation}"
	if [ ! -x "${InstallLocation}"/tinymembench/tinymembench ]; then
		cd "${InstallLocation}"
		git clone https://github.com/ssvb/tinymembench >/dev/null 2>&1
		cd tinymembench
		make >/dev/null 2>&1
		if [ ! -x "${InstallLocation}"/tinymembench/tinymembench ]; then
			echo -e "${LRED}${BOLD}Not able to build necessary tools. Aborting.${NC}\nMost probably gcc and make packages are missing." >&2
			exit 1
		fi
	fi

	# get/build ramlat benchmark if not already built
	if [ ! -x "${InstallLocation}"/ramspeed/ramlat ]; then
		cd "${InstallLocation}"
		git clone https://github.com/wtarreau/ramspeed >/dev/null 2>&1
		[ -d "${InstallLocation}"/ramspeed ] && cd ramspeed ; gcc -o ramlat ramlat.c >/dev/null 2>&1
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
		pacman --noconfirm -Sq automake autoconf pkg-config libcurl4-openssl-dev libjansson-dev libssl-dev libgmp-dev make g++ zlib1g-dev >/dev/null 2>&1
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
	TinymembenchDuration=$(( $(( 5 + $(( ${QuickAndDirtyPerformance} / 150000000 )) )) * ${#ClusterConfig[@]} ))
	RunHowManyTimes=3 # how many times should the multi-threaded 7-zip test be repeated
	SingleThreadedDuration=$(( 20 + $(( ${QuickAndDirtyPerformance} * ${#ClusterConfig[@]} / 5000000 )) ))
	MultiThreadedDuration=$(( ${RunHowManyTimes} * $(( 20 + $(( ${QuickAndDirtyPerformance} / 5000000 )) )) / ${CPUCores} ))
	if [ "${ExecuteCpuminer}" = "yes" -a -x "${InstallLocation}"/cpuminer-multi/cpuminer ]; then
		EstimatedDuration=$(( ${TinymembenchDuration} + $(( $(( ${SingleThreadedDuration} + ${MultiThreadedDuration} )) / 60 )) + 8 ))
	else
		EstimatedDuration=$(( ${TinymembenchDuration} + $(( $(( ${SingleThreadedDuration} + ${MultiThreadedDuration} )) / 60 )) + 3 ))
	fi

	# upload raw /proc/cpuinfo contents
	(echo -e "/proc/cpuinfo\n\n$(uname -a) / $(cat /proc/device-tree/model)\n" ; cat /proc/cpuinfo) 2>/dev/null \
		| curl -s -F 'f:1=<-' ix.io >/dev/null 2>&1 &

	# Create temporary files
	TempDir="$(mktemp -d /tmp/${0##*/}.XXXXXX)"
	export TempDir
	TempLog="${TempDir}/temp.log"
	ResultLog="${TempDir}/results.log"
	MonitorLog="${TempDir}/monitor.log"
	trap "rm -rf \"${TempDir}\" ; exit 0" 0 1 2 3 15

	# collect CPU topology
	CPUTopology="$(PrintCPUTopology)"
	echo -e "${CPUTopology}\n" >"${TempDir}/cpu-topology.log" &
	CPUSignature="$(GetCPUSignature)"
	
	# Log version and device info
	read HostName </etc/hostname
	echo -e "sbc-bench v${Version} ${DeviceName:-$HostName} ($(date -R))\n" >${ResultLog}

	# get distribution info / Xunlong's lame Armbian rip-off tries to hide its origin
	[ -f /etc/orangepi-release ] && ArmbianReleaseFile=/etc/orangepi-release
	[ -f /etc/armbian-release ] && ArmbianReleaseFile=/etc/armbian-release
	[ -f "${ArmbianReleaseFile}" ] && . "${ArmbianReleaseFile}"
	command -v lsb_release >/dev/null 2>&1 && (lsb_release -a 2>/dev/null) >>${ResultLog}
	ARCH=$(dpkg --print-architecture 2>/dev/null) || \
		ARCH=$(awk -F"=" '/^CARCH/ {print $2}' /etc/makepkg.conf 2>/dev/null) || \
		ARCH="unknown/$(uname -m)"

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

	# On Raspberries we also collect 'firmware' information and on RPi 4 check SoC revision
	# against config.txt contents:
	if [ ${USE_VCGENCMD} = true ] ; then
		ThreadXVersion="$("${VCGENCMD}" version)"
		[ -f /boot/config.txt ] && ThreadXConfig=/boot/config.txt || ThreadXConfig=/boot/firmware/config.txt
		grep -q "arm_boost=1" ${ThreadXConfig} 2>/dev/null || (grep -q "C0 or later" <<<"${DeviceName}" && \
			echo -e "\nWarning: your Raspberry Pi is powered by BCM2711 Rev. ${BCM2711} but arm_boost=1\nis not set in ${ThreadXConfig}. Some (mis)information about what you are missing:\nhttps://www.raspberrypi.com/news/bullseye-bonus-1-8ghz-raspberry-pi-4/" >>${ResultLog})
		echo -e "\nRaspberry Pi ThreadX version:\n${ThreadXVersion}" >>${ResultLog}
		[ -f ${ThreadXConfig} ] && echo -e "\nThreadX configuration (${ThreadXConfig}):\n$(grep -v '#' ${ThreadXConfig} | sed '/^\s*$/d')" >>${ResultLog}
		echo -e "\nActual ThreadX settings:\n$("${VCGENCMD}" get_config int)" >>${ResultLog}
	fi

	# Log gcc version
	GCC="$(command -v gcc)"
	GCC_Version="$(${GCC} --version | sed 's/gcc\ //' | head -n1)"
	echo -e "\n${GCC} ${GCC_Version}" >>${ResultLog}

	# Some basic system info needed to interpret system health later
	echo -e "\nUptime:$(uptime)\n\n$(iostat | egrep -v "^loop|boot0|boot1")\n\n$(free -h)\n\n$(swapon -s)\n" | sed '/^$/N;/^\n$/D' >>${ResultLog}
	ShowZswapStats 2>/dev/null >>${ResultLog}
	
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
	if [ ${#ClusterConfig[@]} -eq 1 ]; then
		# all CPU cores have same package id, we only need to test one core
		CPUInfo="$(GetCPUInfo 0)"
		echo -e "\nChecking cpufreq OPP${CPUInfo}:\n" >>${ResultLog}
		CheckCPUCluster 0 >>${ResultLog}
	else
		# different package ids, we walk through all clusters
		for i in $(seq 0 $(( ${#ClusterConfig[@]} -1 )) ) ; do
			FirstCore=${ClusterConfig[$i]}
			LastCore=$(GetLastClusterCore $(( $i + 1 )))
			CPUInfo="$(GetCPUInfo ${ClusterConfig[$i]})"
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
			OPPtoCheck=$((tr " " "\n" </sys/devices/system/cpu/cpufreq/policy${1}/scaling_available_frequencies ; tr " " "\n" </sys/devices/system/cpu/cpufreq/policy${1}/scaling_boost_frequencies) 2>/dev/null | sort -n -r | uniq | sed '/^[[:space:]]*$/d')
		else
			OPPtoCheck="${MaxSpeed} ${MinSpeed}"
		fi
		for i in ${OPPtoCheck} ; do
			echo ${i} >/sys/devices/system/cpu/cpufreq/policy${1}/scaling_max_freq
			sleep 0.1
			MeasuredSpeed=$(taskset -c $1 "${InstallLocation}"/mhz/mhz 3 100000 | awk -F" cpu_MHz=" '{print $2}' | awk -F" " '{print $1}' | sort -r -n | tr '\n' '/' | sed 's|/$||')
			RoundedSpeed=$(( $(awk '{printf ("%0.0f",$1/5+0.5); }' <<<"${MeasuredSpeed}") * 5 ))
			SysfsSpeed=$(( $i / 1000 ))
			if [ ${USE_VCGENCMD} = true ] ; then
				# On RPi we query ThreadX about clockspeeds and Vcore voltage too
				ThreadXFreq=$("${VCGENCMD}" measure_clock arm | awk -F"=" '{printf ("%0.0f",$2/1000000); }' )
				CoreVoltage=$("${VCGENCMD}" measure_volts | cut -f2 -d= | sed 's/000//')
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
		MeasuredSpeed=$(taskset -c ${CpuToCheck} "${InstallLocation}"/mhz/mhz 3 1000000 | awk -F" cpu_MHz=" '{print $2}' | awk -F" " '{print $1}' | sort -r -n | tr '\n' '/' | sed 's|/$||')
		RoundedSpeed=$(( $(awk '{printf ("%0.0f",$1/5+0.5); }' <<<"${MeasuredSpeed}") * 5 ))
		echo -e "No cpufreq support available. Measured on cpu${CpuToCheck}: ${RoundedSpeed} Mhz (${MeasuredSpeed})"
	fi
} # CheckCPUCluster

RunTinyMemBench() {
	echo -e "\x08\x08 Done (results will be available in $(( ${EstimatedDuration} * 110 / 100 ))-$(( ${EstimatedDuration} * 160 / 100 )) minutes)."
	echo -e "Executing tinymembench...\c"
	echo -e "System health while running tinymembench:\n" >${MonitorLog}
	/bin/bash "${PathToMe}" -m $(( 40 * ${#ClusterConfig[@]} )) >>${MonitorLog} &
	MonitoringPID=$!
	echo -n "" >${TempLog}
	for i in $(seq 0 $(( ${#ClusterConfig[@]} -1 )) ) ; do
		CPUInfo="$(GetCPUInfo ${ClusterConfig[$i]})"
		echo -e "\nExecuting benchmark on cpu${ClusterConfig[$i]}${CPUInfo}:\n" >>${TempLog}
		[ -s "${NetioConsumptionFile}" ] && sleep 10
		taskset -c ${ClusterConfig[$i]} "${InstallLocation}"/tinymembench/tinymembench >>${TempLog} 2>&1
	done
	kill ${MonitoringPID}
	echo -e "\n##########################################################################" >>${ResultLog}
	cat ${TempLog} >>${ResultLog}
	MemCpyScore="$(awk -F" " '/^ standard memcpy/ {print $4}' <${TempLog} | sort -n | tail -n1)"
	MemSetScore="$(awk -F" " '/^ standard memset/ {print $4}' <${TempLog} | sort -n | tail -n1)"
	# round results
	MemBenchScore="$(( $(awk '{printf ("%0.0f",$1/10); }' <<<"${MemCpyScore}" ) * 10 )) | $(( $(awk '{printf ("%0.0f",$1/10); }' <<<"${MemSetScore}" ) * 10 ))"
} # RunTinyMemBench

RunRamlat() {
	if [ -x "${InstallLocation}"/ramspeed/ramlat ]; then
		echo -e "\x08\x08 Done.\nExecuting RAM latency tester...\c"
		echo -e "\nSystem health while running ramlat:\n" >>${MonitorLog}
		/bin/bash "${PathToMe}" -m $(( ${#ClusterConfig[@]} * 3 )) >>${MonitorLog} &
		MonitoringPID=$!
		echo -n "" >${TempLog}
		for i in $(seq 0 $(( ${#ClusterConfig[@]} -1 )) ) ; do
			CPUInfo="$(GetCPUInfo ${ClusterConfig[$i]})"
			echo -e "\nExecuting ramlat on cpu${ClusterConfig[$i]}${CPUInfo}, results in ns:\n" >>${TempLog}
			taskset -c ${ClusterConfig[$i]} "${InstallLocation}"/ramspeed/ramlat -s -n 200 \
				| sed -e 's/^/    /' >>${TempLog} 2>&1
		done
		kill ${MonitoringPID}
		echo -e "\n##########################################################################" >>${ResultLog}
		cat ${TempLog} >>${ResultLog}
	fi
} # RunRamlat

Run7ZipBenchmark() {
	echo -e "\x08\x08 Done.\nExecuting 7-zip benchmark...\c"
	echo -e "\nSystem health while running 7-zip single core benchmark:\n" >>${MonitorLog}
	echo -e "\c" >${TempLog}
	TotalMem=$(free | awk -F" " '/^Mem:   / {print $7}' | tail -n1)
	MemAdjustment=$(( $(( 1250000 / ${TotalMem} )) / 3 ))
	if [ ${MemAdjustment} = 0 ]; then
		MonInterval=$(( ${SingleThreadedDuration} / 8 ))
	else
		MonInterval=$(( ${SingleThreadedDuration} / $(( 8 * ${MemAdjustment} )) ))
	fi
	[ ${MonInterval:-0} -lt 5 ] && MonInterval=5
	[ ${MonInterval:-0} -gt 15 ] && MonInterval=15
	/bin/bash "${PathToMe}" -m ${MonInterval} >>${MonitorLog} &
	MonitoringPID=$!
	if [ ${#ClusterConfig[@]} -eq 1 ]; then
		# all CPU cores have same package id
		CPUInfo="$(GetCPUInfo 0)"
		echo -e "\nExecuting benchmark single-threaded on cpu0${CPUInfo}" >>${TempLog}
		[ -s "${NetioConsumptionFile}" ] && sleep 10
		taskset -c 0 "${SevenZip}" b -mmt=1 >>${TempLog}
	else
		for i in $(seq 0 $(( ${#ClusterConfig[@]} -1 )) ) ; do
			CPUInfo="$(GetCPUInfo ${ClusterConfig[$i]})"
			echo -e "\nExecuting benchmark single-threaded on cpu${ClusterConfig[$i]}${CPUInfo}" >>${TempLog}
			[ -s "${NetioConsumptionFile}" ] && sleep 10
			taskset -c ${ClusterConfig[$i]} "${SevenZip}" b -mmt=1 >>${TempLog}
		done
	fi	
	kill ${MonitoringPID}
	echo -e "\n##########################################################################" >>${ResultLog}
	cat ${TempLog} >>${ResultLog}
	
	if [ ${CPUCores} -gt 1 ]; then
		# run multi-threaded test only if there's more than one CPU core
		echo -e "\nSystem health while running 7-zip multi core benchmark:\n" >>${MonitorLog}
		echo -e "\c" >${TempLog}
		if [ ${MemAdjustment} = 0 ]; then
			MonInterval=$(( ${MultiThreadedDuration} / 3 ))
		else
			MonInterval=$(( ${MultiThreadedDuration} / $(( 3 * ${MemAdjustment} )) ))
		fi
		[ ${MonInterval:-0} -lt 10 ] && MonInterval=10
		[ ${MonInterval:-0} -gt 30 ] && MonInterval=30
		/bin/bash "${PathToMe}" -m ${MonInterval} >>${MonitorLog} &
		MonitoringPID=$!
		RunHowManyTimes=3
		echo -e "Executing benchmark ${RunHowManyTimes} times multi-threaded" >>${TempLog}
		for ((i=1;i<=RunHowManyTimes;i++)); do
			"${SevenZip}" b -mmt=${CPUCores} >>${TempLog}
		done
		kill ${MonitoringPID}
		echo -e "\n##########################################################################\n" >>${ResultLog}
		cat ${TempLog} >>${ResultLog}
		# create average score from all $RunHowManyTimes runs
		CombinedScore=$(( $(awk -F" " '/^Tot:/ {s+=$4} END {printf "%.0f", s}' <${TempLog}) / ${RunHowManyTimes} ))
	else
		# use the single score instead on a single core machine
		CombinedScore=$(awk -F" " '/^Tot:/ {print $4}' <${TempLog})
	fi

	sed -i 's/|//' ${TempLog}
	CompScore=$(awk -F" " '/^Avr:/ {print $4}' <${TempLog} | tr '\n' ', ' | sed 's/,$//')
	DecompScore=$(awk -F" " '/^Avr:/ {print $7}' <${TempLog} | tr '\n' ', ' | sed 's/,$//')
	TotScore=$(awk -F" " '/^Tot:/ {print $4}' <${TempLog} | tr '\n' ', ' | sed 's/,$//')
	echo -e "\nCompression: ${CompScore}" >>${ResultLog}
	echo -e "Decompression: ${DecompScore}" >>${ResultLog}
	echo -e "Total: ${TotScore}" >>${ResultLog}
	# round result
	ZipScore="$(( $(awk '{printf ("%0.0f",$1/10); }' <<<"${CombinedScore}" ) * 10 ))"
} # Run7ZipBenchmark

RunOpenSSLBenchmark() {
	echo -e "\x08\x08 Done.\nExecuting OpenSSL benchmark...\c"
	echo -e "\nSystem health while running OpenSSL benchmark:\n" >>${MonitorLog}
	echo -e "\n##########################################################################\n" >>${ResultLog}
	/bin/bash "${PathToMe}" -m 16 >>${MonitorLog} &
	MonitoringPID=$!
	OpenSSLLog="${TempDir}/openssl.log"
	if [ ${#ClusterConfig[@]} -eq 1 ]; then
		# all CPU cores have same package id, we execute openssl twice
		CPUInfo="$(GetCPUInfo 0)"
		echo -e "Executing benchmark twice on cluster 0${CPUInfo}\n" >>${ResultLog}
		for bytelength in 128 192 256 ; do
			openssl speed -elapsed -evp aes-${bytelength}-cbc 2>/dev/null
			openssl speed -elapsed -evp aes-${bytelength}-cbc 2>/dev/null
		done | tr '[:upper:]' '[:lower:]' >${OpenSSLLog}
		# add both scores and divide by two to get an average
		AES128=$(( $(awk '/^aes-128-cbc/ {print $2}' <"${OpenSSLLog}" | awk -F"." '{s+=$1} END {printf "%.0f", s}') / 2 ))
		AES256=$(( $(awk '/^aes-256-cbc/ {print $7}' <"${OpenSSLLog}" | awk -F"." '{s+=$1} END {printf "%.0f", s}') / 2 ))
	else
		# different package ids, we walk through all clusters
		echo -e "Executing benchmark on each cluster individually\n" >>${ResultLog}
		for bytelength in 128 192 256 ; do
			for i in $(seq 0 $(( ${#ClusterConfig[@]} -1 )) ) ; do
				taskset -c ${ClusterConfig[$i]} openssl speed -elapsed -evp aes-${bytelength}-cbc 2>/dev/null
			done
		done | tr '[:upper:]' '[:lower:]' >${OpenSSLLog}
		# check scores and choose highest for reporting
		AES128=$(awk '/^aes-128-cbc/ {print $2}' <"${OpenSSLLog}" | awk -F"." '{print $1}' | sort -n | tail -n1)
		AES256=$(awk '/^aes-256-cbc/ {print $7}' <"${OpenSSLLog}" | awk -F"." '{print $1}' | sort -n | tail -n1)
	fi
	kill ${MonitoringPID}
	echo -e "$(openssl version | awk -F" " '{print $1" "$2", built on "$3" "$4" "$5" "$6" "$7" "$8" "$9" "$10" "$11" "$12" "$13" "$14" "$15}' | sed 's/ *$//')\n$(grep '^type' ${OpenSSLLog} | head -n1)" >>${ResultLog}
	grep '^aes-' ${OpenSSLLog} >>${ResultLog}
	# round result
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
	CPUFreqPolicy="none"
	echo "CPU sysfs topology (clusters, cpufreq members, clockspeeds)"
	echo "                 cpufreq   min    max"
	echo " CPU    cluster  policy   speed  speed   core type"
	for i in $(seq 0 $(( ${CPUCores} - 1 )) ); do
		CoreName="$(GetCPUType $i)"
		# check if CoreName is empty
		if [ "X${CoreName}" = "X" ]; then
			# try to return CPU type instead of core type on x86 if available
			[[ ${CPUArchitecture} == *86* ]] && \
				CoreName="${X86CPUName}"
		else
			CoreStepping="$(GetARMStepping $i)"
			if [ "X${CoreStepping}" != "X" ]; then
				CoreName="${CoreName} / ${CoreStepping}"
			fi
		fi
		read CPUCluster </sys/devices/system/cpu/cpu${i}/topology/physical_package_id
		if [ -d /sys/devices/system/cpu/cpufreq/policy${i} ]; then
			CPUFreqPolicy=${i}
			CPUSpeedMin=$(awk '{printf ("%0.0f",$1/1000); }' </sys/devices/system/cpu/cpufreq/policy${i}/scaling_min_freq)
			CPUSpeedMax=$(awk '{printf ("%0.0f",$1/1000); }' </sys/devices/system/cpu/cpufreq/policy${i}/scaling_max_freq)
		fi
		if [ -z ${CPUFreqPolicy} -o "${CPUFreqPolicy}" = "none" ]; then
			echo "$(printf "%3s" ${i})$(printf "%9s" ${CPUCluster})        0       -      -     ${CoreName:-"    -"}"
		else
			echo "$(printf "%3s" ${i})$(printf "%9s" ${CPUCluster})$(printf "%9s" ${CPUFreqPolicy})$(printf "%9s" ${CPUSpeedMin})$(printf "%8s" ${CPUSpeedMax})   ${CoreName:-"    -"}"
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

	# Check %iowait and %sys percentage as an indication of swapping or too much background
	# activity
	IOWaitAvg=$(CheckIOWait)
	IOWaitMax="$(egrep "MHz  |---  " "${MonitorLog}" | awk -F"%" '{print $5}' | sed '/^[[:space:]]*$/d' | sed -e '1,2d' | sort -n -r | head -n1 | sed 's/  //')"
	SysMax="$(egrep "MHz  |---  " "${MonitorLog}" | awk -F"%" '{print $2}' | sed '/^[[:space:]]*$/d' | sed -e '1,2d' | sort -n -r | head -n1 | sed 's/  //')"

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
	dmesg | sed "/${TimeStamp}/,\$!d" | egrep -v 'sbc-bench started|started with executable stack' >"${TempDir}/dmesg"
	if [ -s "${TempDir}/dmesg" ]; then
		echo -e "\n##########################################################################\n\ndmesg output while running the benchmarks:\n" >>${ResultLog}
		cat "${TempDir}/dmesg" >>${ResultLog}
	fi

	echo -e "\n##########################################################################\n" >>${ResultLog}
	echo -e "$(iostat | egrep -v "^loop|boot0|boot1")\n\n$(free -h)\n\n$(swapon -s)\n" | sed '/^$/N;/^\n$/D' >>${ResultLog}
	ShowZswapStats 2>/dev/null >>${ResultLog}
	echo >>${ResultLog}
	cat "${TempDir}/cpu-topology.log" >>${ResultLog}
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
	# try to guess the SoC and report if successful
	DTCompatible="$(strings /proc/device-tree/compatible 2>/dev/null)"
	GuessedSoC="$(GuessARMSoC)"
	if [ "X${GuessedSoC}" != "X" ]; then
		echo -e "\nSoC guess: ${GuessedSoC}"
	elif [ "X${CPUSignature}" != "X" ]; then
		echo -e "\nSignature: ${CPUSignature}"
	fi
	# log /proc/device-tree/compatible contents if available
	if [ "X${DTCompatible}" != "X" ]; then
		echo "DT compat: $(head -n1 <<<"${DTCompatible}")"
		tail -n +2 <<<"${DTCompatible}" | sed -e 's/^/           /'
	fi
	# Log compiler version
	GCC_Info="$(${GCC} -v 2>&1 | egrep "^Target|^Configured")"
	echo -e " Compiler: ${GCC} $(cut -f1 -d')' <<<${GCC_Version})/$(awk -F": " '/^Target/ {print $2}' <<< "${GCC_Info}"))"
	# Log userland architecture if available
	[ "X${ARCH}" != "X" ] && echo " Userland: ${ARCH}"
	# Log ThreadX version if available
	if [ "X${ThreadXVersion}" != "X" ]; then
		echo -e "  ThreadX: $(awk '/^version/ {print $2}' <<<"${ThreadXVersion}") / $(head -n1 <<<"${ThreadXVersion}")"
		"${VCGENCMD}" mem_reloc_stats | while read ; do
			echo "           ${REPLY}"
		done
	fi
	# check for VM/container mode to add this to kernel info
	VirtWhat="$(systemd-detect-virt 2>/dev/null)"
	[ "X${VirtWhat}" != "X" -a "X${VirtWhat}" != "Xnone" ] && VirtOrContainer=" (${VirtWhat})"
	# kernel info
	KernelVersion="$(uname -r)"
	echo -e "   Kernel: ${KernelVersion}/${CPUArchitecture}${VirtOrContainer}"
	# kernel config
	KernelConfig="/boot/config-${KernelVersion}"
	if [ -f "${KernelConfig}" ] ; then
		grep -E "^CONFIG_HZ|^CONFIG_PREEMPT" "${KernelConfig}" | while read ; do echo "           ${REPLY}"; done | sort -V
	else
		modprobe configs 2>/dev/null
		[ -f /proc/config.gz ] && zgrep -E "^CONFIG_HZ|^CONFIG_PREEMPT" /proc/config.gz | \
			while read ; do echo "           ${REPLY}"; done | sort -V
	fi
	# if available report the kernel's xor/raid6 choices
	dmesg | awk -F"] " '/ raid6: | xor: / {print "           "$2}'
} # LogEnvironment

UploadResults() {
	# upload results to ix.io and replace multiple empty lines with one. 2nd try if 1st does not succeed
	UploadURL=$(sed '/^$/N;/^\n$/D' <${ResultLog} | curl -s -F 'f:1=<-' ix.io 2>/dev/null || \
		sed '/^$/N;/^\n$/D' <${ResultLog} | curl -s -F 'f:1=<-' ix.io)

	# Display benchmark results
	[ ${#ClusterConfig[@]} -gt 1 ] && ClusterInfo=" (different CPU cores measured individually)"
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
			if [ ${IOWaitAvg:-0} -le 2 -a ${IOWaitMax:-0} -le 5 -a ${SysMax:-0} -le 5 -a ! -f ${TempDir}/throttling_info.txt ]; then
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
						# not running on x86/x64, neither throttling and none/minor swapping
						# occured. Check whether SoC in question is already known since if
						# that's the case no more submissions to official results are needed
						grep -q "^SoC guess:" "${ResultLog}"
						if [ $? -ne 0 ]; then
							# not an already known SoC, so suggest submitting results
							echo -e "\n\nIn case this device ${BOLD}is not already represented${NC} in official sbc-bench results list then please"
							echo -e "consider submitting it at https://github.com/ThomasKaiser/sbc-bench/issues with this line:"
							tail -n 1 "${ResultLog}"
						fi
						echo
						;;
				esac
			else
				echo -e "Please check the log for anomalies (e.g. swapping\nor throttling happenend).\n"
			fi
			;;
		*)
			echo -e "\nUnable to upload full test results. Please copy&paste the below stuff to pastebin.com and\nprovide the URL. Check the output for throttling and swapping please.\n\n"
			sed '/^$/N;/^\n$/D' <${ResultLog}
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
	# Check for throttling on normal ARM or RISC-V SBC (on x86 cpufreq statistics are
	# more or less irrelevant)
	case ${CPUArchitecture} in
		arm*|aarch*|riscv*)
			if [ -f /sys/devices/system/cpu/cpufreq/policy0/stats/time_in_state ]; then
				ls /sys/devices/system/cpu/cpufreq/policy?/stats/time_in_state | sort | while read ; do
					Number=$(echo ${REPLY} | tr -c -d '[:digit:]')
					diff ${TempDir}/time_in_state_after_${Number} ${TempDir}/time_in_state_before_${Number} >/dev/null 2>&1
					if [ $? -ne 0 ]; then
						if [ ${#ClusterConfig[@]} -eq 1 ]; then
							# all CPU cores have same cpufreq policies, we report globally
							ReportCpufreqStatistics ${Number}
							echo -e "${LRED}${BOLD}ATTENTION: Throttling might have occured. Check the log for details.${NC}\n"
						else
							# report affected cluster
							for i in $(seq 0 $(( ${#ClusterConfig[@]} -1 )) ) ; do
								if [ ${ClusterConfig[$i]} -eq ${Number} ]; then
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
				Health="$(LC_ALL=C perl -e "printf \"%19b\n\", $("${VCGENCMD}" get_throttled | cut -f2 -d=)" 2>/dev/null | tr -d '[:blank:]')"
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
			;;
	esac
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
			echo -e "${DIMMDetails}" | egrep -v -i ": Unknown|: None" || \
			(echo ; dmidecode -t memory 2>/dev/null | \
			egrep -i -v "^Handle |^# dmidecode |^Getting SMBIOS data|^SMBIOS |Serial Number:|Not Provided|No Module Installed|Unknown|NO DIMM" \
			| sed '/^$/N;/^\n$/D')
		# check wether there's even more detailed DIMM info available via i2c
		unset DIMMDetails
		modprobe eeprom >/dev/null 2>&1
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

GuessARMSoC() {
	# function that tries to guess ARM SoC names correctly
	#
	# For a rough performance estimate wrt different Cortex ARMv8 cores see:
	# https://www.cnx-software.com/2021/12/10/starfive-dubhe-64-bit-risc-v-core-12nm-2-ghz-processors/#comment-588823
	#
	# The cpuid flags seems to appear on all ARMv8 cores starting with kernel 5
	#
	# AnnapurnaLabs Alpine | 2 x Cortex-A15 / r2p4 / swp half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt
	# Armada 370/XP | 1 x Marvell PJ4 / r1p1 / half thumb fastmult vfp edsp vfpv3 vfpv3d16 tls idivt
	# Comcerto 2000 EVM (FreeScale/NXP QorIQ LS1024A) | 2 x Cortex-A9 / r2p1 / swp half thumb fastmult vfp edsp thumbee neon vfpv3 tls
	# HiSilicon Kirin 930 | 8 x Cortex-A53 / r0p3 / fp asimd evtstrm aes pmull sha1 sha2 crc32
	# Marvell PJ4Bv7 | 4 x Marvell PJ4B-MP / r2p2 / swp half thumb fastmult vfp edsp vfpv3 tls
	#
	# Recent Rockchip BSP include something like this in dmesg output:
	# rockchip-cpuinfo cpuinfo: SoC            : 35661000 --> https://forum.pine64.org/showthread.php?tid=14457&pid=101319#pid101319
	# rockchip-cpuinfo cpuinfo: SoC            : 35681000 --> https://dev.t-firefly.com/forum.php?mod=redirect&goto=findpost&ptid=104549&pid=280260
	# rockchip-cpuinfo cpuinfo: SoC            : 35682000 --> https://forum.banana-pi.org/t/banana-pi-bpi-r2-pro-open-soruce-router-board-with-rockchip-rk3568-run-debian-linux/
	# rockchip-cpuinfo cpuinfo: SoC            : 35880000 --> http://ix.io/3XzI
	#
	# Amlogic: dmesg | grep 'soc soc0:'
	# soc soc0: Amlogic Meson8b (S805) RevA (1b - 0:B72) detected <-- ODROID-C1 / S805-onecloud / Endless Computers Endless Mini
	# soc soc0: Amlogic Meson8m2 (S812) RevA (1d - 0:74E) detected <-- Akaso M8S / Tronsmart MXIII Plus
	# soc soc0: Amlogic Meson GXBB (S905) Revision 1f:b (0:1) Detected <-- ODROID-C2
	# soc soc0: Amlogic Meson GXBB (S905) Revision 1f:c (0:1) Detected <-- ODROID-C2
	# soc soc0: Amlogic Meson GXBB (S905) Revision 1f:c (13:1) Detected <-- NanoPi K2 / NEXBOX A95X / Tronsmart Vega S95 Telos / Amlogic Meson GXBB P200 Development Board / Amlogic Meson GXBB P201 Development Board
	# soc soc0: Amlogic Meson GXBB (S905H) Revision 1f:c (23:1) Detected <-- Amlogic Meson GXBB P201 Development Board
	# soc soc0: Amlogic Meson GXL (S905X) Revision 21:a (82:2) Detected <-- Khadas VIM / NEXBOX A95X (S905X)/ Amlogic Meson GXL (S905X) P212 Development Board
	# soc soc0: Amlogic Meson GXL (Unknown) Revision 21:b (2:2) Detected <-- Phicomm N1
	# soc soc0: Amlogic Meson GXL (S905X) Revision 21:b (82:2) Detected <-- Libre Computer AML-S905X-CC / Tanix TX3 Mini / Amlogic Meson GXL (S905X) P212 Development Board
	# soc soc0: Amlogic Meson GXL (S905W) Revision 21:b (a2:2) Detected <-- Amlogic Meson GXL (S905X) P212 Development Board
	# soc soc0: Amlogic Meson GXL (S905L) Revision 21:b (c2:2) Detected <-- Amlogic Meson GXL (S905X) P212 Development Board
	# soc soc0: Amlogic Meson GXL (S905M2) Revision 21:b (e2:2) Detected <-- Amlogic Meson GXL (S905X) P212 Development Board
	# soc soc0: Amlogic Meson GXL (S905X) Revision 21:c (84:2) Detected <-- Khadas VIM / Amlogic Meson GXL (S905X) P212 Development Board
	# soc soc0: Amlogic Meson GXL (S905L) Revision 21:c (c2:2) Detected <-- PiBox by wdmomo
	# soc soc0: Amlogic Meson GXL (Unknown) Revision 21:c (c2:2) Detected <-- S905L on "PiBox by wdmomo"
	# soc soc0: Amlogic Meson GXL (S905L) Revision 21:c (c4:2) Detected <-- Amlogic Meson GXL (S905X) P212 Development Board
	# soc soc0: Amlogic Meson GXL (Unknown) Revision 21:c (e2:2) Detected <-- S905X on Khadas VIM
	# soc soc0: Amlogic Meson GXL (S905D) Revision 21:d (0:2) Detected <-- Tanix TX3 Mini, Amlogic Meson GXL (S905W) P281 Development Board
	# soc soc0: Amlogic Meson GXL (Unknown) Revision 21:d (4:2) Detected <-- Phicomm N1
	# soc soc0: Amlogic Meson GXL (S905D) Revision 21:d (4:2) Detected <-- Phicomm N1
	# soc soc0: Amlogic Meson GXL (S805X) Revision 21:d (34:2) Detected <-- Libre Computer AML-S805X-AC, Amlogic Meson GXL (S905X) P212 Development Board
	# soc soc0: Amlogic Meson GXL (S905X) Revision 21:d (84:2) Detected <-- Khadas VIM / Amlogic Meson GXL (S905X) P212 Development Board
	# soc soc0: Amlogic Meson GXL (S905X) Revision 21:d (85:2) Detected <-- Libre Computer AML-S905X-CC
	# soc soc0: Amlogic Meson GXL (Unknown) Revision 21:d (a4:2) Detected <-- Khadas VIM / Tanix TX3 Mini / JetHome JetHub J80 / Amlogic Meson GXL (S905X) P212 Development Board / Amlogic Meson GXL (S905W) P281 Development Board
	# soc soc0: Amlogic Meson GXL (S905L) Revision 21:d (c4:2) Detected <-- Amlogic Meson GXL (S905X) P212 Development Board
	# soc soc0: Amlogic Meson GXL (S905M2) Revision 21:d (e4:2) Detected <-- Amlogic Meson GXL (S905X) P212 Development Board
	# soc soc0: Amlogic Meson GXL (S905W) Revision 21:e (a5:2) Detected <-- Tanix TX3 Mini / JetHome JetHub J80 / Amlogic Meson GXL (S905X) P212 Development Board / Amlogic Meson GXL (S905W) P281 Development Board
	# soc soc0: Amlogic Meson GXL (S905L) Revision 21:e (c5:2) Detected <-- Amlogic Meson GXL (S905X) P212 Development Board
	# soc soc0: Amlogic Meson GXM (S912) Revision 22:a (82:2) Detected <-- Beelink GT1 / Octopus Planet / Amlogic Meson GXM (S912) Q200 Development Board / Amlogic Meson GXM (S912) Q201 Development Board
	# soc soc0: Amlogic Meson GXM (S912) Revision 22:b (82:2) Detected <-- Tronsmart Vega S96 / Octopus Planet / Amlogic Meson GXM (S912) Q201 Development Board
	# soc soc0: Amlogic Meson AXG (Unknown) Revision 25:b (43:2) Detected <-- JetHome JetHub J100
	# soc soc0: Amlogic Meson AXG (Unknown) Revision 25:c (43:2) Detected <-- JetHome JetHub J100
	# soc soc0: Amlogic Meson GXLX (Unknown) Revision 26:e (c1:2) Detected <-- Amlogic Meson GXL (S905X) P212 Development Board
	# soc soc0: Amlogic Meson G12A (Unknown) Revision 28:b (30:2) Detected <-- S905Y2 on Radxa Zero
	# soc soc0: Amlogic Meson G12A (S905X2) Revision 28:b (40:2) Detected <-- Shenzhen Amediatech Technology Co., Ltd X96 Max
	# soc soc0: Amlogic Meson G12A (Unknown) Revision 28:b (70:2) Detected <-- Amlogic Meson G12A U200 Development Board
	# soc soc0: Amlogic Meson G12A (Unknown) Revision 28:c (70:2) Detected <-- Amlogic Meson G12A U200 Development Board
	# soc soc0: Amlogic Meson G12B (S922X) Revision 29:a (40:2) Detected <-- ODROID-N2 / Beelink GT-King Pro
	# soc soc0: Amlogic Meson G12B (A311D) Revision 29:b (10:2) Detected <-- Khadas VIM3
	# soc soc0: Amlogic Meson G12B (S922X) Revision 29:b (40:2) Detected <-- Beelink GT-King Pro
	# soc soc0: Amlogic Meson G12B (S922X) Revision 29:c (40:2) Detected <-- ODROID-N2+ ('S922X-B')
	# soc soc0: Amlogic Meson Unknown (Unknown) Revision 2a:e (c5:2) Detected <-- Amlogic Meson GXL (S905X) P212 Development Board
	# soc soc0: Amlogic Meson SM1 (Unknown) Revision 2b:b (1:2) Detected <-- BananaPi M5 / Shenzhen Amediatech Technology Co., Ltd X96 Air / AMedia X96 Max+ / SEI Robotics SEI610
	# soc soc0: Amlogic Meson SM1 (Unknown) Revision 2b:b (40:2)' Detected <-- S905D3 on Khadas VIM3L
	# soc soc0: Amlogic Meson SM1 (S905X3) Revision 2b:c (10:2) Detected <-- AMedia X96 Max+ / H96 Max X3 / ODROID-C4 / ODROID-HC4 / HK1 Box / Vontar X3 / SEI Robotics SEI610 / Shenzhen Amediatech Technology Co., Ltd X96 Max/Air / Shenzhen CYX Industrial Co., Ltd A95XF3-AIR / Sinovoip BANANAPI-M5 / Tanix TX3 (QZ)
	#
	# With T7/A311D2 the string 'soc soc0:' is missing in Amlogic's BSP kernel, instead it's just
	# '[    0.492977] Amlogic Meson T7 (A311D2) Revision 36:b (1:3) Detected' in dmesg output
	#
	# SoC IDs listed by Amlogic reference designs (ID pattern pretty obvious):
	# - P200 Development Board (GXBB):
	#   - S905: 1f:c (13:1)
	# - P201 Development Board (GXBB):
	#   - S905: 1f:c (13:1)
	#   - S905H: 1f:c (23:1)
	# - P212 Development Board (GXL):
	#   - S905X: 21:a (82:2), 21:b (82:2), 21:c (84:2), 21:d (84:2)
	#   - S905W: 21:b (a2:2), 21:e (a5:2)
	#   - S905L: 21:b (c2:2), 21:c (c4:2), 21:d (c4:2), 21:e (c5:2)
	#   - S905M2: 21:b (e2:2), 21:d (e4:2)
	#   - Unknown: 21:d (a4:2), 2a:e (c5:2), 26:e (c1:2)
	# - P281 Development Board (GXL):
	#   - S905D: 21:d (0:2)
	#   - S905W: 21:e (a5:2)
	#   - Unknown: 21:d (a4:2)
	# - Q200 Development Board (GXM):
	#   - S912: 22:a (82:2)
	# - Q201 Development Board (GXM):
	#   - S912: 22:a (82:2), 22:b (82:2)
	# - U200 Development Board (G12A):
	#   - Unknown: 28:b (70:2), 28:c (70:2)
	#
	# If /proc/cpuinfo Hardware field is 'Amlogic' then the first five/six chars of 'AmLogic
	# Serial' and if not present 'Serial' have special meaning as it's the 'chip id':
	# S905X:   '21:a (82:2)' / 210a820094e04a851342e1d007989aa7
	# S912:    '22:a (82:2)' / 220a82006da41365fedf301742726826
	# S905X3:  '2b:b (1:2)'  / 2b0b0100010918000006323730523050
	# S922X:   '29:c (40:2)' / 290c4000012b1500000639314e315350
	# A311D2:  '36:b (1:3)'  / 360b010300000000081d810911605690
	#
	# Chars 1-2: meson family: 21=GXL, 22=GXM, 2b=SM1, 29=G12B, 36=T7 and so on, see below
	# Chars 3-4: production batch: the earlier production run the lower (0a, 0b, 0c and so on)
	# Chars 5-6: SKU differentiation: see GXL case construct below starting at '21??3*')
	#
	# https://github.com/CoreELEC/bl301/blob/1b435f3e20160d50fc01c3ef616f1dbd9ff26be8/arch/arm/include/asm/cpu_id.h#L21-L42
	# https://www.kernel.org/doc/Documentation/devicetree/bindings/arm/amlogic.txt
	# Amlogic chip ids: https://github.com/CoreELEC/linux-amlogic/blob/ab1ab097d1a7b01d644d09625c9e4c7e31e35fb4/arch/arm64/kernel/cpuinfo.c#L135-L158
	# More cpuinfo: http://tessy.org/wiki/index.php?Arm#ae54e1d6 (archived at https://archive.md/nf6kL)
	# https://github.com/pytorch/cpuinfo/tree/master/src/arm/linux/

	CPUInfo="$(cat /proc/cpuinfo)"
	HardwareInfo="$(awk -F': ' '/^Hardware/ {print $2}' <<< "${CPUInfo}" | tail -n1)"
	RockchipGuess="$(dmesg | awk -F': ' '/rockchip-cpuinfo cpuinfo: SoC/ {print $3}'| head -n1)"
	AmlogicGuess="Amlogic Meson$(dmesg | grep -i " detected$" | awk -F"Amlogic Meson" '/Amlogic Meson/ {print $2}' | head -n1)"
	
	if [ "X${RockchipGuess}" != "X" ]; then
		echo "Rockchip RK$(cut -c-4 <<<"${RockchipGuess}") (${RockchipGuess})"
	elif [ "X${AmlogicGuess}" != "XAmlogic Meson" ]; then
		echo "${AmlogicGuess}" | sed -e 's/SM1 (Unknown) Revision 2b:b/SM1 (S905D3) Revision 2b:b/' \
		-e 's/G12A (Unknown) Revision 28:b (30:2)/G12A (S905Y2) Revision 28:b (30:2)/' \
		-e 's/GXL (Unknown) Revision 21:c (e2:2)/GXL (S905X) Revision 21:c (e2:2)/' \
		-e 's/GXL (Unknown) Revision 21:d (a4:2)/GXL (S905W) Revision 21:d (a4:2)/' \
		-e 's/GXL (Unknown) Revision 21:d (4:2)/GXL (S905D) Revision 21:d (4:2)/' \
		-e 's/GXL (Unknown) Revision 21:c (c2:2)/GXL (S905L) Revision 21:c (c2:2)/' \
		-e 's/ Detected//' -e 's/ detected//'
	else
		# Guessing by 'Hardware :' in /proc/cpuinfo is something that only reliably works
		# with vendor's BSP kernels. With mainline kernel it's impossible to rely on this
		case ${HardwareInfo} in
			Amlogic*)
				ModelName="$(awk -F': ' '/^model name/ {print $2}' <<< "${CPUInfo}" | tail -n1)"
				case "${ModelName}" in
					Amlogic*)
						echo "${ModelName}"
						;;
					*)
						AmLogicSerial="$(awk -F': ' '/^AmLogic Serial/ {print $2}' <<< "${CPUInfo}" | tail -n1)"
						if [ "X${AmLogicSerial}" = "X" ]; then
							AmLogicSerial="$(awk -F': ' '/^Serial/ {print $2}' <<< "${CPUInfo}" | tail -n1)"
						fi
						case "${AmLogicSerial}" in
							1b*)
								# Meson8B: S805: RevA (1b - 0:B72)
								echo "Amlogic S805"
								;;
							1d*)
								# Meson8m2: S812: RevA (1d - 0:74E)
								echo "Amlogic S812"
								;;
							1f??0*|1f??1*)
								# GXBB: S905: 1f:b (0:1) / 1f:c (0:1) / 1f:c (13:1)
								echo "Amlogic S905"
								;;
							1f??23*)
								# GXBB: S905H: 1f:c (23:1)
								echo "Amlogic S905H"
								;;
							1f*)
								# GXBB: S905, S905H, S905M
								# - S905: 1f:b (0:1) / 1f:c (0:1)
								# - S905H: 1f:c (23:1)
								echo "Amlogic S905/S905H/S905M"
								;;
							21??3*)
								# GXL: S805X: 21:d (34:2)
								echo "Amlogic S805X"
								;;
							21??0*|21??4*)
								# GXL: S905D: 21:d (0:2), 21:d (4:2)
								echo "Amlogic S905D"
								;;
							21??8*)
								# GXL: S905X: 21:a (82:2), 21:b (82:2), 21:c (84:2), 21:d (84:2)
								echo "Amlogic S905X"
								;;
							21??a*)
								# GXL: S905W: 21:b (a2:2), 21:e (a5:2)
								echo "Amlogic S905W"
								;;
							21??c*)
								# GXL: S905L: 21:b (c2:2), 21:c (c4:2), 21:d (c4:2), 21:e (c5:2)
								echo "Amlogic S905L"
								;;
							21??e*)
								# GXL: S905M2: 21:b (e2:2), 21:d (e4:2)
								echo "Amlogic S905M2"
								;;
							21*)
								# GXL: S805X, S805Y, S905X, S905D, S905W, S905L, S905M2
								# - S905D: 21:d (0:2), 21:d (4:2)
								# - S805X: 21:d (34:2)
								# - S905X: 21:a (82:2), 21:b (82:2), 21:c (84:2), 21:d (84:2)
								# - S905W: 21:b (a2:2), 21:e (a5:2)
								# - S905L: 21:b (c2:2), 21:c (c4:2), 21:d (c4:2), 21:e (c5:2)
								# - S905M2: 21:b (e2:2), 21:d (e4:2)
								echo "Amlogic S805X/S805Y/S905X/S905D/S905W/S905L/S905M2"
								;;
							22*)
								# GXM: S912: 22:a (82:2), 22:b (82:2)
								echo "Amlogic S912"
								;;
							24*)
								# TXLX
								echo "Amlogic T962X/T962E"
								;;
							25*)
								# AXG: A113X, A113D
								# - Unknown: 25:b (43:2), 25:c (43:2)
								echo "Amlogic A113X/A113D"
								;;
							26*)
								# GXLX, seems to be compatible to GXL since one occurence of ID '26:e (c1:2)'
								# has been detected on 'Amlogic Meson GXL (S905X) P212 Development Board'
								echo "unknown Amlogic GXLX SoC, serial $(cut -c-6 <<<"${AmLogicSerial}")..."
								;;
							27*)
								# TXHD
								echo "unknown Amlogic TXHD SoC, serial $(cut -c-6 <<<"${AmLogicSerial}")..."
								;;
							28??4*)
								# G12A: S905X2: 28:b (40:2)
								echo "Amlogic S905X2"
								;;
							28??3*)
								# G12A: S905Y2: 28:b (30:2)
								echo "Amlogic S905Y2"
								;;
							28*)
								# G12A: S905X2, S905D2, S905Y2
								# - S905X2: 28:b (40:2)
								# - S905Y2: 28:b (30:2)
								echo "Amlogic S905X2/S905D2/S905Y2"
								;;
							29??1*)
								# - G12B: A311D: 29:b (10:2)
								echo "Amlogic A311D"
								;;
							29??4*)
								# - G12B: S922X: 29:a (40:2), 29:b (40:2), 29:c (40:2)
								echo "Amlogic S922X"
								;;
							29*)
								# G12B: A311D, S922X
								# - A311D: 29:b (10:2)
								# - S922X: 29:a (40:2), 29:b (40:2)
								# - 'S922X-B': 29:c (40:2)
								echo "Amlogic S922X/A311D"
								;;
							2b??1*)
								# SM1: S905X3: 2b:b (1:2), 2b:c (10:2)
								echo "Amlogic S905X3"
								;;
							2b??4*)
								# SM1: S905D3: 2b:b (40:2)
								echo "Amlogic S905D3"
								;;
							2b*)
								# SM1: S905X3, S905D3
								# - S905X3: 2b:b (1:2), 2b:c (10:2)
								# - S905D3: 2b:b (40:2)
								echo "Amlogic S905X3/S905D3"
								;;
							2c*)
								# A1: A113L
								echo "Amlogic A113L"
								;;
							2e*)
								# TL1: T962X2
								echo "Amlogic T962X2"
								;;
							2f*)
								# TM2: ?
								echo "unknown Amlogic TM2 SoC, serial $(cut -c-6 <<<"${AmLogicSerial}")..."
								;;
							32*)
								# SC2: S905X4
								echo "Amlogic S905X4"
								;;
							36*)
								# T7: A311D2: 36:b (1:3)
								echo "Amlogic A311D2"
								;;
							*)
								# https://tinyurl.com/y85lsxsc:
								# T3 --> T982, T963D4, T965D4
								# S4 --> S905Y4, S805X2 (quad Cortex-A35) https://lkml.org/lkml/2022/1/6/204
								# S4D --> S905C3, S905C3ENG (quad Cortex-A35): https://archive.md/4H6xM
								echo "unknown Amlogic, serial $(cut -c-6 <<<"${AmLogicSerial}")..."
								;;
						esac
						;;
				esac
				;;
			sun20iw1*)
				echo "Allwinner D1 (1xC906 RISC-V)"
				;;
			sun7iw2*)
				echo "Allwinner A20"
				;;
			sun8iw7*)
				echo "Allwinner H3/H2+"
				;;
			sun8iw11*)
				echo "Allwinner R40/V40/T3/A40i"
				;;
			sun50iw1p*)
				# Since Armbian patched arch/arm64/kernel/cpuinfo.c since Aug 2016 every
				# other Allwinner ARMv8 SoC (H5/H6/H616) will identify itself as sun50iw1p1
				# when kernel has been tampered with by Armbian.
				# https://github.com/armbian/build/issues/3400 / https://archive.md/VxK14
				AllwinnerGuess="$(IdentifyAllwinnerARMv8 | head -n1)"
				case ${AllwinnerGuess} in
					*unidentified*)
						if [ -f /etc/armbian-release ]; then
							# use Armbian's release info since there we can rely on SoC family
							# naming unlike cpuinfo output that was fake for many years
							ArmbianReleaseFile=/etc/armbian-release
						elif [ -f /etc/orangepi-release ]; then
							# try to deal with Xunlong's lame Armbian rip-off over at
							# https://github.com/orangepi-xunlong/orangepi-build
							ArmbianReleaseFile=/etc/orangepi-release
						fi
						if [ -f "${ArmbianReleaseFile}" ]; then
							BoardFamily="$(awk -F'=' '/^BOARDFAMILY/ {print $2}' <"${ArmbianReleaseFile}")"
							case ${BoardFamily} in
								sun50iw1)
									echo "Allwinner A64"
									;;
								sun50iw2)
									echo "Allwinner H5"
									;;
								sun50iw6)
									echo "Allwinner H6"
									;;
								sun50iw9)
									echo "Allwinner H616/H313"
									;;
								*)
									echo "Allwinner A64 or https://tinyurl.com/yyf3d7fg"
									;;
							esac
						else
							echo "Allwinner A64 or https://tinyurl.com/yyf3d7fg"
						fi
						;;
					*)
						echo "${AllwinnerGuess}"
						;;
				esac
				;;
			sun50iw2*)
				echo "Allwinner H5"
				;;
			sun50iw3*)
				echo "Allwinner A63"
				;;
			sun50iw6*)
				echo "Allwinner H6"
				;;
			sun50iw9*)
				echo "Allwinner H616/H313"
				;;
			sun50iw10*)
				echo "Allwinner A100/A133/A53/T509"
				;;
			sun50iw11*)
				echo "Allwinner R329"
				;;
			sun*|Allwinner*)
				SoCGuess="$(GuessSoCbySignature)"
				[ "X${SoCGuess}" = "X" ] && sed -e 's/ board//' -e 's/ Family//' <<<"${HardwareInfo}" || echo "${SoCGuess}"
				;;
			Hardkernel*)
				case ${HardwareInfo} in
					*XU4|*HC1|*HC2|*MC1|*XU4Q)
						echo "Exynos 5422"
						;;
					*C1*)
						echo "Amlogic S805"
						;;
					*C2)
						echo "Amlogic S905"
						;;
					*C4)
						echo "Amlogic S905X3"
						;;
					*M1)
						echo "Rockchip RK3568"
						;;
					*N1)
						echo "Rockchip RK3399"
						;;
					*N2*)
						echo "Amlogic S922X"
						;;
					*)
						sed 's/Hardkernel //' <<<"${HardwareInfo}"
						;;
				esac
				;;
			*)
				# guess SoC based on CPU topology
				SoCGuess="$(GuessSoCbySignature)"
				[ "X${SoCGuess}" = "X" ] || echo "${SoCGuess}"
				;;
		esac
	fi
} # GuessARMSoC

GuessSoCbySignature() {
	# Guess by CPU topology (core types and revision, clusters and cpufreq policies) and by
	# specific features/flags
	case ${CPUSignature} in
		??A8r3p2)
			# TI AM3358 or Allwinner A10, 1 x Cortex-A8 / r3p2 / half thumb fastmult vfp edsp neon vfpv3 tls vfpd32
			lsmod | grep -i -q sun4i
			case $? in
				0)
					# Allwinner A10, 1 x Cortex-A8 / r3p2 / half thumb fastmult vfp edsp neon vfpv3 tls vfpd32
					echo "Allwinner A10"
					;;
				*)
					case "${DTCompatible}" in
						*sun4i*|*allwinner*)
							# Allwinner A10, 1 x Cortex-A8 / r3p2 / half thumb fastmult vfp edsp neon vfpv3 tls vfpd32
							echo "Allwinner A10"
							;;
						*)
							# TI AM3358, 1 x Cortex-A8 / r3p2 / half thumb fastmult vfp edsp neon vfpv3 tls vfpd32
							echo "TI AM3358"
							;;
						esac
					;;
			esac
			;;
		00A7r0p5)
			# Allwinner S3/V3/V3s, 1 x Cortex-A7 / r0p5 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm
			echo "Allwinner S3/V3/V3s"
			;;
		00A7r0p400A7r0p4)
			# Allwinner A20, 2 x Cortex-A7 / r0p4 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm
			echo "Allwinner A20"
			;;
		00A7r0p500A7r0p5)
			# SigmaStar SSD201/SSD202D | 2 x Cortex-A7 / r0p5 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm
			echo "SigmaStar SSD201/SSD202D"
			;;
		00A7r0p500A7r0p500A7r0p500A7r0p5)
			# Allwinner sun8i: could be Allwinner H3/H2+, R40/V40 or A33/R16 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm
			egrep -q 'ahci-sunxi|axp22x' /proc/interrupts
			case $? in
				0)
					# SATA and/or AXP221s PMIC is present, so we're talking about R40/V40, 4 x Cortex-A7 / r0p5 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm
					echo "Allwinner R40/V40"
					;;
				*)
					case "${DTCompatible}" in
						*sun8i-r40*)
							# R40/V40, 4 x Cortex-A7 / r0p5 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm
							echo "Allwinner R40/V40"
							;;
						*sun8i-h3*)
							# Allwinner H3, 4 x Cortex-A7 / r0p5 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm
							echo "Allwinner H3"
							;;
						*sun8i-h2*)
							# Allwinner H2+, 4 x Cortex-A7 / r0p5 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm
							echo "Allwinner H2+"
							;;
						*sun8i-a33*|*sun8i-r16*)
							# Allwinner A33/R16, 4 x Cortex-A7 / r0p5 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm
							echo "Allwinner A33/R16"
							;;
						*)
							echo "Allwinner H3/H2+ or R40/V40 or A33/R16"
							;;
					esac
					;;
			esac
			;;
		??A7r0p5??A7r0p5??A7r0p5??A7r0p5??A7r0p5??A7r0p5??A7r0p5??A7r0p5)
			# Allwinner A83T, 8 x Cortex-A7 / r0p5 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm
			echo "Allwinner A83T"
			;;
		20A5r0p120A5r0p120A5r0p120A5r0p1|2A5222)
			# S805, 4 x Cortex-A5 / r0p1 / half thumb fastmult vfp edsp thumbee neon vfpv3 tls vfpv4 vfpd32 (3.10: swp half thumb fastmult vfp edsp neon vfpv3 tls vfpv4)
			echo "Amlogic S805"
			;;
		20A9r4p120A9r4p120A9r4p120A9r4p1|2A9222)
			# S805, 4 x Cortex-A9 / r4p1 / half thumb fastmult vfp edsp thumbee neon vfpv3 tls vfpd32
			echo "Amlogic S812"
			;;
		00A53r0p400A53r0p400A53r0p400A53r0p4)
			# The boring quad Cortex-A53 done by every SoC vendor: 4 x Cortex-A53 / r0p4
			# Allwinner A64/H5/H6, BCM2837/BCM2709, RK3328, i.MX8 M, S905, S905X/S805X, S805Y, S905X/S905D/S905W/S905L/S905M2, S905X2/S905Y2/T962X2, RealTek RTD129x/RTD139x
			case "${DeviceName}" in
				"Raspberry Pi 2"*)
					# 4 x Cortex-A53 / r0p4 / fp asimd evtstrm crc32
					echo "BCM2837 (BCM2709)"
					;;
				"Raspberry Pi 3"*)
					# 4 x Cortex-A53 / r0p4 / fp asimd evtstrm crc32
					echo "BCM2710"
					;;
				"Raspberry Pi Zero 2"*)
					# 4 x Cortex-A53 / r0p4 / fp asimd evtstrm crc32
					echo "RP3A0-AU (BCM2710A1)"
					;;
				*)
					# No Raspberry, check for AES capabilities first
					grep 'Features' /proc/cpuinfo | grep -q aes
					if [ $? -ne 0 ]; then
						# no ARMv8 Crypto Extensions licensed like RPi ARMv8 cores... then it's
						# S905: 4 x Cortex-A53 / r0p4 / fp asimd evtstrm crc32
						echo "Amlogic S905"
					else
						ModulesLoaded=$(lsmod | cut -f1 -d' ' | tr '\n' ' ')
						case ${ModulesLoaded} in
							*sun?i*)
								# 4 x Cortex-A53 / r0p4 / fp asimd evtstrm aes pmull sha1 sha2 crc32
								IdentifyAllwinnerARMv8 | head -n1
								;;
							*rockchip*|*dwmac_rk*)
								# RK3328, 4 x Cortex-A53 / r0p4 / fp asimd evtstrm aes pmull sha1 sha2 crc32
								echo "Rockchip RK3328"
								;;
							*meson*)
								# GXL or G12A: 4 x Cortex-A53 / r0p4 / fp asimd evtstrm aes pmull sha1 sha2 crc32
								IdentifyGXLG12A
								;;
							*imx8*)
								# i.MX8M, 4 x Cortex-A53 / r0p4 / fp asimd evtstrm aes pmull sha1 sha2 crc32
								echo "NXP i.MX8M"
								;;
							*)
								# no significant module names found, guess by kernel
								case "$(uname -a)" in
									*sunxi*)
										IdentifyAllwinnerARMv8 | head -n1
										;;
									*sun50iw2)
										echo "Allwinner H5"
										;;
									*sun50iw6)
										echo "Allwinner H6"
										;;
									*sun50iw9)
										echo "Allwinner H616/H313"
										;;
									*rockchip*)
										echo "Rockchip RK3328"
										;;
									*meson*)
										IdentifyGXLG12A
										;;
									*BPI-M4*)
										echo "RealTek RTD1395"
										;;
									*)
										# no kernel name match, guess by /proc/interrupts
										grep -q "rockchip" /proc/interrupts && echo "Rockchip RK3328"
										;;
								esac
								;;
						esac
					fi
					;;
			esac
			;;
		00A53r0p400A53r0p4)
			# Allwinner R329, 2 x Cortex-A53 / r0p4 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			echo "Allwinner R329"
			;;
		00A53r0p400A53r0p400A53r0p400A53r0p414A53r0p414A53r0p414A53r0p414A53r0p4)
			# S912, 4 x Cortex-A53 / r0p4 + 4 x Cortex-A53 / r0p4 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			echo "Amlogic S912"
			;;
		00A53r0p400A53r0p412A73r0p212A73r0p212A73r0p212A73r0p2)
			# S922X/A311D, 2 x Cortex-A53 / r0p4 + 4 x Cortex-A73 / r0p2 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			echo "Amlogic S922X/A311D"
			;;
		00A73r0p200A73r0p200A73r0p200A73r0p214A53r0p414A53r0p414A53r0p414A53r0p4)
			# Amlogic A311D2, 4 x Cortex-A73 / r0p2 + 4 x Cortex-A53 / r0p4 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			echo "Amlogic A311D2"
			;;
		0A9r4p10A9r4p1|00A9r4p100A9r4p1)
			# Armada 375/38x, 2 x Cortex-A9 / r4p1 / swp half thumb fastmult vfp edsp neon vfpv3 tls
			echo "Armada 375/38x"
			;;
		??A53r0p4??A53r0p4)
			# Armada 3700, 2 x Cortex-A53 / r0p4 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			echo "Armada 37x0"
			;;
		10ARM1176r0p7)
			# BCM2835, 1 x ARM1176 / r0p7 / half thumb fastmult vfp edsp java tls
			echo "BCM2835"
			;;
		00A72r0p300A72r0p300A72r0p300A72r0p3)
			# BCM2711, 4 x Cortex-A72 / r0p3 / fp asimd evtstrm crc32 (running 32-bit: half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm crc32)
			echo "BCM2711${BCM2711}"
			;;
		10A7r0p310A7r0p310A7r0p310A7r0p304A15r2p304A15r2p304A15r2p304A15r2p3)
			# Exynos 5422, 4 x Cortex-A7 / r0p3 + 4 x Cortex-A15 / r2p3 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae (with 5.x also evtstrm)
			echo "Exynos 5422"
			;;
		??A9r3p0??A9r3p0??A9r3p0??A9r3p0)
			# RK3188, 4 x Cortex-A9 / r3p0 / half thumb fastmult vfp edsp thumbee neon vfpv3 tls vfpd32
			echo "Rockchip RK3188"
			;;
		00A35r0p200A35r0p200A35r0p200A35r0p2)
			# RK3308, 4 x Cortex-A35 / r0p2 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			echo "Rockchip RK3308"
			;;
		00A55r1p000A55r1p000A55r1p000A55r1p0)
			# Amlogic S905X3, 4 x Cortex-A55 / r1p0 / fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp (with 5.4+ also 'asimddp asimdrdm cpuid dcpop lrcpc')
			echo "Amlogic S905X3"
			;;
		00A55r2p000A55r2p000A55r2p000A55r2p0)
			# Amlogic S905X4 or RK3566/RK3568
			# 4 x Cortex-A55 / r2p0 / fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp asimdrdm lrcpc dcpop asimddp
			lsmod | grep -i meson && echo "Amlogic S905X4" || echo "Rockchip RK3566 or RK3568"
			;;
		00A53r0p400A53r0p400A53r0p400A53r0p414A72r0p214A72r0p2)
			# RK3399, 4 x Cortex-A53 / r0p4 + 2 x Cortex-A72 / r0p2 / fp asimd evtstrm aes pmull sha1 sha2 crc32 (32-bit 4.4 BSP kernel: half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt lpae evtstrm aes pmull sha1 sha2 crc32)
			echo "Rockchip RK3399"
			;;
		0?A55r2p00?A55r2p00?A55r2p00?A55r2p01?A76r4p01?A76r4p02?A76r4p02?A76r4p0)
			# RK3588, 4 x Cortex-A55 / r2p0 + 2 x Cortex-A76 / r4p0 / + 2 x Cortex-A76 / r4p0 / fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp asimdrdm lrcpc dcpop asimddp
			echo "Rockchip RK3588/RK3588s"
			;;
		150A7r0p5150A7r0p5150A7r0p5150A7r0p5)
			case "${DeviceName}" in
				"Raspberry Pi 2"*)
					# BCM2836, 4 x Cortex-A7 / r0p5 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm
					echo "BCM2836 (BCM2709)"
					;;
				*)
					# RK3229/RK3228A, 4 x Cortex-A7 / r0p5 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm
					echo "Rockchip RK3229/RK3228A"
					;;
			esac
			;;
		??A9r1p0??A9r1p0)
			# Nvidia Tegra 2, 2 x Cortex-A9 / r1p0 / swp half thumb fastmult vfp edsp thumbee vfpv3 vfpv3d16 (no neon)
			echo "Nvidia Tegra 2"
			;;
		??A9r2p9??A9r2p9??A9r2p9??A9r2p9)
			# Nvidia Tegra 3, 4 x Cortex-A9 / r2p9 / swp half thumb fastmult vfp edsp neon vfpv3 tls
			echo "Nvidia Tegra 3"
			;;
		00A57r1p100A57r1p100A57r1p100A57r1p1)
			# Jetson Nano, 4 x Cortex-A57 / r1p1 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			echo "Nvidia Jetson Nano"
			;;
		*A57r1p3*)
			# Jetson TX2, 1-4 x Cortex-A57 / r1p3 + 0-2 x Denver2 / r0p0 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			echo "Nvidia Jetson TX2"
			;;
		*NVidiaCarmelr0p0*)
			# Nvidia Xavier | 4-8 x NVidia Carmel / r0p0 / fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp
			echo "Nvidia Xavier"
			;;
		50A17r0p150A17r0p150A17r0p150A17r0p1)
			# RK3288, 4 x Cortex-A17 / r0p1 / half thumb fastmult vfp edsp thumbee neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm
			echo "Rockchip RK3288"
			;;
		?0A7r0p3?0A7r0p3?0A7r0p3?0A7r0p3)
			# MT7623 or Allwinner A31, 4 x Cortex-A7 / r0p3 / half thumb fastmult vfp edsp (thumbee) neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm
			grep -q ' thumbee' /proc/cpuinfo && echo "Mediatek MT7623" || echo "Allwinner A31"
			;;
		00A53r0p300A53r0p300A53r0p300A53r0p310A53r0p310A53r0p310A53r0p310A53r0p3)
			# Samsung/Nexell S5P6818, 8 x Cortex-A53 / r0p3 / fp asimd aes pmull sha1 sha2 crc32
			echo "Samsung/Nexell S5P6818"
			;;
		00Cavium88XXr1p1*)
			# ThunderX CN8890, 48 x ThunderX 88XX / r1p1 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			echo "$(( ${CPUCores} / 48 )) x ThunderX CN8890"
			;;
		??A9r2p10??A9r2p10??A9r2p10??A9r2p10)
			# NXP i.MX6 Quad | 4 x Cortex-A9 / r2p10 / swp half thumb fastmult vfp edsp thumbee neon vfpv3
			echo " NXP i.MX6 Quad"
			;;
		??A9r2p10??A9r2p10)
			# NXP i.MX6 Quad | 2 x Cortex-A9 / r2p10 / swp half thumb fastmult vfp edsp thumbee neon vfpv3
			echo " NXP i.MX6 Dual"
			;;
		??MarvellPJ4PJ4br0p5)
			# Marvell Armada 510, 1 x Marvell PJ4 / r0p5 / swp half thumb fastmult vfp edsp iwmmxt thumbee
			echo "Marvell Armada 510"
			;;
		??MarvellFeroceon88FR131r2p1)
			# Marvell Kirkwood 88F6281: 1 x Marvell Feroceon 88FR131 / r2p1 / swp half thumb fastmult edsp
			echo "Marvell Kirkwood 88F6281"
			;;
		??ARM11MPCorer0p5??ARM11MPCorer0p5)
			# PLX NAS7820: 2 x ARM11 MPCore / r0p5 / swp half thumb fastmult edsp java
			echo "PLX NAS7820"
			;;
		36?Phytiumr1p336?Phytiumr1p336?Phytiumr1p336?Phytiumr1p336?Phytiumr1p336?Phytiumr1p336?Phytiumr1p336?Phytiumr1p3)
			# Phytium D2000: 8 x Phytium FTC663 / r1p3 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			echo "Phytium D2000"
			;;
	esac
}

GetCPUSignature() {
	case ${CPUArchitecture} in
		arm*|aarch*)
			sed -e '1,/^ CPU/ d' -e 's/Cortex-//' <<<"${CPUTopology}" | while read ; do
				echo -e "$(awk -F" " '{print $2$3$6$8$9$10}' <<<"${REPLY}" | sed -e 's/-//g' -e 's/\///g')\c"
			done
			;;
	esac
} # GetCPUSignature

IdentifyGXLG12A() {
	# Amlogic GXL and G12A SoC families share same cluster details (quad A53 / r0p4).
	# They differ in speed though: GXL usually fakes 1.5 GHz while being limited to
	# 1.4 GHz (LibreComputer's La Frite and Jethub D1 being exceptions reporting 1416 MHz)
	# but G12A (S905X2, S905D2, S905Y2) clocks higher and doesn't fake clockspeeds
	MaxSpeed="$(sed -e '1,/^ CPU/ d' <<<"${CPUTopology}" | tail -n1 | awk -F" " '{print $5}')"
	case ${MaxSpeed} in
		15??|14??)
			# GXL: 4 x Cortex-A53 / r0p4 / fp asimd evtstrm aes pmull sha1 sha2 crc32 cpuid (running 32-bit: fp asimd evtstrm aes pmull sha1 sha2 crc32 wp half thumb fastmult vfp edsp neon vfpv3 tlsi vfpv4 idiva idivt)
			echo "Amlogic A113X/A113D, S805X, S805Y, S905X/S905D/S905L/S905M2"
			;;
		12??)
			# S905W being limited to 1.2 GHz
			echo "Amlogic S905W"
			;;
		*)
			# G12A/TL1: 4 x Cortex-A53 / r0p4 / fp asimd evtstrm aes pmull sha1 sha2 crc32 cpuid
			echo "Amlogic S905X2/S905Y2/S905D2/T962X2"
			;;
	esac
} # IdentifyGXLG12A

IdentifyAllwinnerARMv8() {
	# Allwinner sun50iw* except sun50iw11 are all quad A53 / r0p4. Today sun50iw1p
	# (A64/H64), sun50iw2 (H5), sun50iw6 (H6) and sun50iw9 (H616/H313) seem to exist
	# in the wild.
	#
	# Allwinner SoCs feature a Security/Chip ID (SID): https://linux-sunxi.org/SID_Register_Guide
	#
	# Allwinner H5, 5.10.60-sunxi64
	# /sys/devices/platform/soc/1c14000.eeprom/sunxi-sid0/nvmem
	# 00000000  01 00 80 82 04 47 00 64  04 c3 36 50 0e 09 37 64
	# 00000010  42 02 00 00 00 00 00 00  00 00 00 00 00 00 00 00
	# 00000020  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
	# 00000030  00 00 00 00 cd 07 ed 07  00 00 00 00 00 00 00 00
	# 00000040  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
	#
	# Allwinner H6, 5.4.20-sunxi64
	# /sys/devices/platform/soc/3006000.efuse/sunxi-sid0/nvmem
	# 00000000  01 00 c0 82 08 47 00 0c  3e 04 41 01 4b 22 74 54
	# 00000010  00 00 00 00 f7 10 21 09  29 09 01 00 40 00 00 00
	# 00000020  00 00 00 00 79 00 00 00  47 8f 00 00 01 00 e0 02
	# 00000030  2e 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
	# 00000040  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
	#
	# H616/H313 is usually combined with AXP806 PMIC, lacks USB3 but should be
	# equipped with 2 GMAC according to http://ix.io/2cGy and http://ix.io/2MBN
	# According to https://irclog.whitequark.org/linux-sunxi/2021-01-19#28890526;
	# AXP1530 and AXP305 (compatible to AXP805) are also mentioned but won't show
	# up in /proc/interrupts
	#
	# Since no access to A64 and H616/H313 right now, try to identify the different
	# quad core SoCs based on presence of PMIC, USB3 and maybe clockspeeds

	# check device-tree compatible strings
	grep -q h616 <<<"${DTCompatible}" && echo "Allwinner H616/H313"
	grep -q t507 <<<"${DTCompatible}" && echo "Allwinner T507"
	grep -q h313 <<<"${DTCompatible}" && echo "Allwinner H313"
	grep -q h6 <<<"${DTCompatible}" && echo "Allwinner H6"
	grep -q h5 <<<"${DTCompatible}" && echo "Allwinner H5"
	grep -q a64 <<<"${DTCompatible}" && echo "Allwinner A64"

	# Check for USB3 first, mainline kernel:
	grep -q "xhci" /proc/interrupts && echo "Allwinner H6"

	# No idea about H6 BSP kernel but we simply play safe
	lsusb -t | grep -q xhci && echo "Allwinner H6"

	# Now check for PMIC. Both H616 and H6 use AXP806 but the latter has USB3.
	# Checking with mainline seemed to work for axp806: http://ix.io/2GH3
	# but with later kernels it's gone: http://ix.io/3woR. Reasons why:
	# https://github.com/jernejsk/linux-1/commit/50b9a4612a8cc6e2131b83f498d7c5d4cb6ea74f
	grep -q axp806 /proc/interrupts && echo "Allwinner H616/H313"

	# Maybe there's something in kernel ring buffer identifying the SoC
	dmesg | egrep -q "sun50i-h616|sun50iw9" && echo "Allwinner H616/H313"
	dmesg | grep -q sun50i-a64 && echo "Allwinner A64"
	dmesg | grep -q sun50i-h5 && echo "Allwinner H5"
	dmesg | grep -q sun50i-h6- && echo "Allwinner H6"

	# A64 is accompanied by AXP803 PMIC:
	grep -q axp803 /proc/interrupts && echo "Allwinner A64"

	# With A64 BSP kernel we can try to rely on a sysfs node
	[ -d /sys/devices/platform/axp81x_board/axp81x-supplyer.47 ] \
		 && echo "Allwinner A64"

	# H5 is usually combined with an I2C attached Silergy SY8106A voltage regulator
	lsmod | grep -i -q sy8106a && echo "Allwinner H5"

	# Maybe there's something in kernel ring buffer identifying the SoC
	dmesg | egrep -q "sun50i-h5|sun50iw2" && echo "Allwinner H5"

	# if we end up here then print some generic BS
	echo "Allwinner unidentified SoC"
} # IdentifyAllwinnerARMv8

ShowZswapStats() {
	# https://www.kernel.org/doc/Documentation/vm/zswap.txt
	ZswapEnabled="$(sed 's/Y/1/' </sys/module/zswap/parameters/enabled)"
	if [ "${ZswapEnabled}" = "1" ]; then
		# check whether zswap is in conflict with zram. If both are combined together
		# once swapping occurs performance will be trashed, see sbc-bench results from
		# systems where this mess happened: zswap statistics, zram usage and the %sys CPU
		# percentage in 'System health while running 7-zip multi core benchmark:' section:
		# - http://ix.io/3PCk
		# - http://ix.io/3Rfi
		# - http://ix.io/3X7U
		# - http://ix.io/3X1E
		grep -q '/dev/zram' /proc/swaps && echo -e "WARNING: ZSWAP ON TOP OF ZRAM HAS BEEN CONFIGURED ON THIS SYSTEM!\nTHIS WILL SEVERELY HARM PERFORMANCE IN CASE SWAPPING OCCURS!\n"

		# read module parameters
		read max_pool_percent </sys/module/zswap/parameters/max_pool_percent 2>/dev/null
		read compressor </sys/module/zswap/parameters/compressor 2>/dev/null
		read zpool </sys/module/zswap/parameters/zpool 2>/dev/null
		if [ -n ${max_pool_percent} -a -n ${compressor} -a -n ${zpool} ]; then
			echo -e "Zswap active using ${compressor}/${zpool}, max pool occupation: ${max_pool_percent}%\c"
		elif [ -n ${compressor} -a -n ${zpool} ]; then
			echo -e "Zswap active using ${compressor}/${zpool}\c"
		else
			echo -e "Zswap active\c"
		fi
		if [ -d /sys/kernel/debug/zswap ]; then
			echo ", details:"
			read stored_pages </sys/kernel/debug/zswap/stored_pages
			read pool_total_size </sys/kernel/debug/zswap/pool_total_size
			if [ ${pool_total_size:-0} -gt 0 ]; then
				# https://unix.stackexchange.com/a/412760
				compression_ratio=$(awk -F" " '{printf ("%0.1f",$1*4096/$2); }' <<<"${stored_pages} ${pool_total_size}")
				echo -e "\tcompression_ratio:${compression_ratio:-0}"
			fi
			grep -R . /sys/kernel/debug/zswap/ | sed 's|/sys/kernel/debug/zswap/|\t|' | sort
		fi
	fi
} # ShowZswapStats

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
