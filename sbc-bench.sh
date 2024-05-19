#!/bin/bash

Version=0.9.66
InstallLocation=/usr/local/src # change to /tmp if you want tools to be deleted after reboot

Main() {
	export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/vc/bin
	PathToMe="$( cd "$(dirname "$0")" || exit 1 ; pwd -P )/${0##*/}"
	unset LC_ALL LC_MESSAGES LC_NUMERIC LANGUAGE LANG 2>/dev/null # prevent localisation of decimal points and similar stuff
	NO_COLOR="${NO_COLOR:-}"
	Netio="${Netio:-}"
	Smartpower="${Smartpower:-}"
	Linpack="${Linpack:-}"

	# use colours and bold when outputting to a terminal
	CheckTerminal

	# The following allows to use sbc-bench on real ARM devices where for
	# whatever reasons a fake /usr/bin/vcgencmd is lying around -- see for
	# an example here: https://github.com/ThomasKaiser/sbc-bench/pull/13
	VCGENCMD=$(command -v vcgencmd)
	if [ -z "${USE_VCGENCMD}" ] && [ -x "${VCGENCMD}" ]; then
		# this seems to be a Raspberry Pi where we need to query
		# ThreadX on the VC via vcgencmd to get real information
		# Double check via device-tree compatible string:
		[ -f /proc/device-tree/compatible ] && \
			grep -a -q raspberrypi /proc/device-tree/compatible
		if [ $? -eq 0 ]; then
			USE_VCGENCMD=true
		else
			USE_VCGENCMD=false
		fi
	else
		USE_VCGENCMD=false
	fi

	ProcCPUFile="${CPUINFOFILE:-/proc/cpuinfo}"
	[ -r "${ProcCPUFile}" ] && ProcCPU="$(cat "${ProcCPUFile}")"
	[ -r /etc/os-release ] && source /etc/os-release

	# check in which mode we're supposed to run
	while getopts 'uSchjkmtTrRsgNPG' c ; do
		case ${c} in
			m)
				# monitoring mode
				SleepInterval=${2:-5}
				if [ -n "${Netio}" ] && [ -z "${NetioConsumptionFile}" ]; then
					QueryNetioDevice
					if [ "X${OutputCurrents[*]}" != "X" ]; then
						# We are in Netio monitoring mode as such provide consumption info as well
						echo -e "Power monitoring on socket ${NetioSocket} of ${NetioName} (Netio ${NetioModel}, FW v${Firmware}, XML API v${XmlVer}, ${InputVoltage}V @ ${Frequency}Hz)\n"
						CreateTempDir
						NetioConsumptionFile="${TempDir}/netio.current"
						echo -n $(( $(awk '{printf ("%0.0f",$1/10); }' <<<"${OutputCurrent[$(( ${NetioSocket} - 1 ))]}" ) * 10 )) >"${NetioConsumptionFile}"
						export NetioConsumptionFile
						NetioInterval=$(LC_ALL=C awk '{printf ("%0.1f",$1/2); }' <<<"${SleepInterval}")
						NetioSamples=$(( SleepInterval * 3 ))
						/bin/bash "${PathToMe}" -N ${NetioDevice} ${NetioSocket} ${NetioConsumptionFile} "${NetioInterval}" "${NetioSamples}" >/dev/null 2>&1 &
						NetioMonitoringPID=$!
					fi
				fi
				MonitorMode=TRUE
				MonitorBoard
				[ -n "${Netio}" ] && [ -z "${NetioConsumptionFile}" ] && kill ${NetioMonitoringPID} >/dev/null 2>&1
				exit 0
				;;
			c)
				# Run Cpuminer test (NEON/SSE/AVX)
				ExecuteCpuminer=yes
				;;
			s)
				# Run Stockfish test (NEON/SSE/AVX/RAM)
				NeuralNetwork=$2
				ExecuteStockfish=yes
				;;
			S)
				# check storage, only for testing, will disappear later
				DMESG="$(dmesg | grep "mmc")"
				SMARTDrives="$(ls /dev/sd* /dev/nvme* 2>/dev/null)"
				if [ "X${SMARTDrives}" != "X" ]; then
					# warn about absence of smartctl and running not as root only when needed
					command -v smartctl >/dev/null 2>&1 || echo -e "${BOLD}Warning: smartmontools not installed${NC}\n" >&2
					[ ${UID} = 0 ] || echo -e "${BOLD}Warning: to query all drive info this tool needs to be run as root${NC}\n" >&2
				fi
				CheckStorage | sed 's/000Mbps/Gbps/'
				exit 0
				;;
			h)
				# print help
				DisplayUsage
				exit 0
				;;
			u)
				# replace script with latest version from Github
				UpdateMe
				exit 0
				;;
			j|r)
				# Jeff Geerling or Jean-Luc Aufranc mode. Help in reviewing devices
				REVIEWMODE=true
				SleepInterval=${2:-5}
				RunBenchmarks=TRUE
				[ ${UID} = 0 ] || { echo -e "${BOLD}Warning: for useable results this tool needs to be run as root${NC}\n" >&2 ; exit 1 ; }
				ProvideReviewInfo
				exit 0
				;;
			R)
				# Review mode w/o basic benchmarking and thermal throttling tests
				REVIEWMODE=true
				SleepInterval=${2:-5}
				[ ${UID} = 0 ] || { echo -e "${BOLD}Warning: for useable results this tool needs to be run as root${NC}\n" >&2 ; exit 1 ; }
				ProvideReviewInfo
				exit 0
				;;
			k)
				# Kernel info. Check kernel version against https://endoflife.date/linux
				# and issue warnings if used kernel is not an official one but vendor/BSP
				PrintKernelInfo
				exit 0
				;;
			t|T)
				# temperature tests sufficient for heatsink/fan and throttling settings testing
				# 2nd argument (integer in degree C) is the value we wait for the board to cool
				# down prior to next test
				TargetTemp=${2:-50}
				[ ${UID} = 0 ] || { echo -e "${BOLD}Warning: for useable results this tool needs to be run as root${NC}\n" >&2 ; exit 1 ; }
				TempTest
				exit 0
				;;
			g)
				# graph performance chart instead of doing standard 7-zip benchmarks, thereby
				# walking through different cpufreq OPP. An additional parameter in taskset's
				# --cpu-list format can be provided, eg. '-g 0' to graph only cpu0 or '-g 4'
				# to graph only cpu4 (which might be an A72 on big.LITTLE systems). Mixing
				# CPUs from different clusters (e.g. '-g 0,4' on a RK3399) will result in
				# garbage since big and little cores have other cpufreq OPP.
				# 3 special modes exist: cores, clusters and all.
				# * '-g cores' will test single-threaded through cluster's cores (0 and 4 on
				#   RK3399, 0 and 2 on S922X and so on)
				# * '-g clusters' tests all cores of each cluster (0-3 and 4-5 on RK3399,
				#   0-1 and 2-5 on S922X and so on)
				# * '-g all' performs both tests from above and then runs the test on all
				#   cores as well. This will take ages.
				PlotCpufreqOPPs=yes
				CPUList=${2}
				[ "X${CPUList}" = "X" ] || [ "X${CPUList}" = "Xall" ] || [ "X${CPUList}" = "Xcores" ] || [ "X${CPUList}" = "Xclusters" ] || [ "X${CPUList}" = "Xcoreclusters" ] \
					|| taskset -c ${CPUList} echo "foo" >/dev/null 2>&1
				if [ $? -ne 0 ]; then
					echo -e "\nInvalid option \"-g ${CPUList}\". Please check taskset manual page for --cpu-list format" >&2
					DisplayUsage
					exit 1
				fi
				;;
			G)
				# Geekbench piggyback mode. Geekbench lacks sanity checks (measuring
				# clockspeeds) and environment monitoring (too much background activity
				# or throttling for example).
				MODE="gb"
				;;
			P)
				# Phoronix Test Suite piggyback mode. PTS lacks sanity checks (measuring
				# clockspeeds) and environment monitoring (too much background activity
				# or throttling for example). You need to install Phoronix Test Suite by
				# yourself (see https://www.phoronix-test-suite.com/?k=downloads) and run
				# 'phoronix-test-suite batch-setup' once to configure batch operation mode:
				#
				# Save test results when in batch mode (Y/n): y
				# Open the web browser automatically when in batch mode (y/N): n
				# Auto upload the results to OpenBenchmarking.org (Y/n): Y
				# Prompt for test identifier (Y/n): n
				# Prompt for test description (Y/n): n
				# Prompt for saved results file-name (Y/n): n
				# Run all test options (Y/n): n
				#
				# If you want PTS progress info use 'tail -f /tmp/sbc-bench.*/temp.log'
				# in another shell. You'll need this anyway since if 'Run all test options'
				# has been answered with no, then PTS of course expects you giving manual
				# feedback even if in batch-benchmark mode.
				#
				# root@rock-5b:/tmp/sbc-bench.Pvhatc# tail -f temp.log
				# SQLite 3.30.1:
				#     pts/sqlite-2.1.0
				#     Disk Test Configuration
				#         1: 1
				#         2: 8
				#         3: 32
				#         4: 64
				#         5: 128
				#         6: Test All Options
				#         ** Multiple items can be selected, delimit by a comma. **
				#
				# In the invoking shell you need to enter the desired config then PTS
				# proceeds.
				MODE="pts"
				shift
				PTSArguments="$*"
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
				# to monitor idle consumption better choose 4.8 and 30 and deal with a 150
				# seconds average value.
				MonitorNetio "$2" "$3" "$4" "$5" "$6"
				exit 0
				;;
			*)
				# invalid flags
				DisplayUsage
				exit 1
				;;
			esac
	done

	[ ${UID} = 0 ] || echo -e "${BOLD}Warning: when not being executed as root strange things will happen${NC}\n" >&2

	# ensure other sbc-bench instances are terminated
	for PID in $( (pgrep -f "${PathToMe}" ; jobs -p) | sort | uniq -u) ; do
		if [ ${PID} -ne $$ ]; then
			kill ${PID} 2>/dev/null
		fi
	done

	# do a normal release check only if not in PTS or GB mode, in review mode warn if
	# distro is not rather recent
	if [ "X${MODE}" = "Xpts" ] || [ "X${MODE}" = "Xgb" ]; then
		:
	elif [ "X${REVIEWMODE}" = "Xtrue" ]; then
		CheckOSRelease ForReview
	else
		CheckOSRelease
	fi
	unset SPACING
	CreateTempDir
	[ -f /sys/devices/system/cpu/cpufreq/policy0/scaling_governor ] && \
		read OriginalCPUFreqGovernor </sys/devices/system/cpu/cpufreq/policy0/scaling_governor 2>/dev/null
	[ "${OriginalCPUFreqGovernor}" = "ondemand" ] && \
		io_is_busy=( $(find /sys/devices/system/cpu/cpufreq -name io_is_busy | while read ; do cat "${REPLY}"; done) )
	CheckLoadAndDmesg
	BasicSetup performance >/dev/null 2>&1
	GovernorState="$(HandleGovernors | grep -v cpufreq-policy)"
	[ "X${GovernorState}" != "X" ] && echo -e "Status of performance related governors found below /sys (w/o cpufreq):\n${GovernorState}\n"
	GetTempSensor
	[ "X${MODE}" = "Xpts" ] && CheckPTS
	InstallPrerequisits
	[ "X${MODE}" = "Xgb" ] && CheckGB
	InitialMonitoring
	CheckClockspeedsAndSensors
	CheckTimeInState before
	if [ "${PlotCpufreqOPPs}" = "yes" ]; then
		PlotPerformanceGraph
	else
		CheckNetio
		[ "X${MODE}" = "Xpts" ] || [ "X${MODE}" = "Xgb" ] || RunTinyMemBench
		RunRamlat
		if [ "X${MODE}" = "Xpts" ]; then
			RunPTS
		elif [ "X${MODE}" = "Xgb" ]; then
			RunGB
		else
			RunOpenSSLBenchmark "128 192 256"
			Run7ZipBenchmark
			if [ "${ExecuteCpuminer}" = "yes" ] || [ "X${MODE}" = "Xextensive" ]; then
				if [ -x "${InstallLocation}"/cpuminer-multi/cpuminer ]; then
					ExecuteCpuminer=yes
					RunCpuminerBenchmark
				else
					ExecuteCpuminer=no
					echo -e "\x08\x08 Done.\n(${InstallLocation}/cpuminer-multi/cpuminer missing or not executable)...\c"
				fi
			fi
			if [ "${ExecuteStockfish}" = "yes" ] || [ "X${MODE}" = "Xextensive" ]; then
				if [ -x "${InstallLocation}/Stockfish-sf_15/src/stockfish" ]; then
					ExecuteStockfish=yes
					RunStockfishBenchmark
				else
					ExecuteStockfish=no
					echo -e "\x08\x08 Done.\n(${InstallLocation}/Stockfish-sf_15/src/stockfish missing or not executable)...\c"
				fi
			fi
		fi
	fi
	CheckTimeInState after
	CheckClockspeedsAndSensors # test again loaded system after heating the SoC to the max
	SummarizeResults
	UploadResults
	CheckAgeOfScript
	BasicSetup ${OriginalCPUFreqGovernor} >/dev/null 2>&1
} # Main

CheckTerminal() {
	# Check if we're outputting to a terminal. If yes try to use bold and colors for messages
	# unless NO_COLOR is exported by the user and set to 1: https://no-color.org
	if test -t 1; then
		ncolors=$(tput colors)
		if [ -n "${ncolors}" ] && [ "${ncolors}" -ge 8 ] && [ "X${NO_COLOR}" != "X1" ]; then
			BOLD="$(tput bold)"
			NC='\033[0m' # No Color
			LGREEN='\033[1;32m'
			LRED='\e[0;91m'
		fi
	fi
} # CheckTerminal

UpdateMe() {
	# function to replace this script with latest version from here:
	# https://raw.githubusercontent.com/ThomasKaiser/sbc-bench/master/sbc-bench.sh
	# Also check/update the github projects except of stockfish since there we use
	# a static and not latest version

	[ -w "${PathToMe}" ] || { echo "Permission problem accessing ${PathToMe}. Wrong user? Aborting." >&2 ; exit 1 ; }
	command -v curl >/dev/null 2>&1 || { echo "curl not found. Please install and try again. Aborting." >&2 ; exit 1 ; }
	TempFile="$(mktemp /tmp/update-sbc-bench.XXXXXX)"
	[ -w "${TempFile}" ] || { echo "Temp file creation not possible. Aborting." >&2 ; exit 1 ; }
	curl -s "https://raw.githubusercontent.com/ThomasKaiser/sbc-bench/master/sbc-bench.sh" >"${TempFile}" \
		|| { echo "Can not access Github. Network problem? Aborting." >&2 ; exit 1 ; }
	VersionFromInternet="$(head "${TempFile}" | awk -F"=" '/^Version/ {print $2}')"
	VersionCompare="$(echo -e "${VersionFromInternet}\n${Version}" | sort -V 2>/dev/null | tail -n1)"
	if [ "X${VersionFromInternet}" = "X" ]; then
		echo -e "Not able to download from Github. Updating not possible." >&2
		exit 1
	elif [ "X${Version}" = "X${VersionFromInternet}" ]; then
		echo -e "Replaced ${Version} with ${Version} from Github...\c"
	elif [ "X${VersionCompare}" = "X${VersionFromInternet}" ]; then
		echo -e "Upgraded from ${Version} to ${VersionFromInternet}...\c"
	elif [ "X${VersionCompare}" = "X${Version}" ]; then
		echo -e "Downgraded from ${Version} to ${VersionFromInternet}...\c"
	fi
	cat "${TempFile}" >"${PathToMe}" && rm "${TempFile}"
	echo -e "\x08\x08 Done."

	# Only try to update git projects if git is already installed
	command -v git >/dev/null 2>&1 || exit 0

	for GitProject in mhz ramspeed tinymembench cpuminer-multi cpufetch p7zip ; do
		if [ -x "${InstallLocation}/${GitProject}" ]; then
			if [ -r "${InstallLocation}/${GitProject}/.git/config" ]; then
				GitURL="$(awk -F" = " '/url = / {print $2}' "${InstallLocation}/${GitProject}/.git/config")"
				echo -e "Checking/updating ${GitURL}...\c"
			else
				echo -e "Checking/updating ${GitProject} from Github...\c"
			fi
			cd "${InstallLocation}/${GitProject}" || exit 1
			GitResult="$(git pull 2>/dev/null)"
			case "${GitResult}" in
				*"up to date"*)
					echo -e "\x08\x08 ${GitResult}"
					;;
				*)
					case ${GitProject} in
						cpuminer-multi)
							rm "${InstallLocation}"/cpuminer-multi/.do-not-try-to-build-again 2>/dev/null
							./build.sh >/dev/null 2>&1
							case $? in
								0)
									echo -e "\x08\x08 Done."
									;;
								*)
									echo -e "\x08\x08 Failed."
									;;
							esac
							;;
						*)
							make clean >/dev/null 2>&1
							make >/dev/null 2>&1
							echo -e "\x08\x08 Done."
							;;
					esac
			esac
		fi
	done
} # UpdateMe

CheckAgeOfScript() {
	# checks modification of this file on disk, compares to 'time now' and if difference
	# is a month or more then suggests running 'sbc-bench -u' for an update check
	FileTime=$(stat -c %Y -- "${PathToMe}" 2>/dev/null)
	TimeNow=$(date "+%s")
	FileAge=$(( $(( ${TimeNow} - ${FileTime} )) / 86400 ))
	if [ ${FileAge:-0} -ge 30 ]; then
		[ "X${SUDO_USER}" != "X" ] && Sudoprefix="sudo "
		echo -e "\nJust for your information: this script's version on disk is ${FileAge} days old."
		echo -e "Maybe checking for an update: ${BOLD}${Sudoprefix}${PathToMe} -u${NC}\n"
	fi
} # CheckAgeOfScript

snore() {
	# https://blog.dhampir.no/content/sleeping-without-a-subprocess-in-bash-and-how-to-sleep-forever
	local IFS
	[[ -n "${_snore_fd:-}" ]] || { exec {_snore_fd}<> <(:); } 2>/dev/null ||
	{
		# workaround for MacOS and similar systems
		local fifo
		fifo=$(mktemp -u)
		mkfifo -m 700 "$fifo"
		exec {_snore_fd}<>"$fifo"
		rm "$fifo"
	}
	read ${1:+-t "$1"} -u $_snore_fd || :
} # snore

GetARMCore() {
	# List originally obtained from util-linux project but later appended by looking at
	# https://github.com/gcc-mirror/gcc/blob/master/gcc/config/aarch64/aarch64-cores.def
	# and https://github.com/llvm/llvm-project/blob/release/15.x/llvm/lib/Support/Host.cpp
	# and https://github.com/torvalds/linux/blob/master/arch/arm64/include/asm/cputype.h
	# and https://github.com/Dr-Noob/cpufetch/blob/master/src/arm/uarch.c
	# and https://github.com/pytorch/cpuinfo/blob/main/src/arm/linux/midr.c
	# and https://github.com/hrw/arm-socs-table/blob/main/data/cpu_cores.yml
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
	41/c0c:Cortex-A12
	41/c0d:Cortex-A17
	41/c0e:Cortex-A17
	41/c0f:Cortex-A15
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
	41/d02:Cortex-A34
	41/d03:Cortex-A53
	41/d04:Cortex-A35
	41/d05:Cortex-A55
	41/d06:Cortex-A65
	41/d07:Cortex-A57
	41/d08:Cortex-A72
	41/d09:Cortex-A73
	41/d0a:Cortex-A75
	41/d0b:Cortex-A76
	41/d0c:Neoverse-N1
	41/d0d:Cortex-A77
	41/d0e:Cortex-A76AE
	41/d13:Cortex-R52
	41/d15:Cortex-R82
	41/d16:Cortex-R52+
	41/d20:Cortex-M23
	41/d21:Cortex-M33
	41/d22:Cortex-M55
	41/d23:Cortex-M85
	41/d40:Neoverse-V1
	41/d41:Cortex-A78
	41/d42:Cortex-A78AE
	41/d43:Cortex-A65AE
	41/d44:Cortex-X1
	41/d46:Cortex-A510
	41/d47:Cortex-A710
	41/d48:Cortex-X2
	41/d49:Neoverse-N2
	41/d4a:Neoverse-E1
	41/d4b:Cortex-A78C
	41/d4c:Cortex-X1C
	41/d4d:Cortex-A715
	41/d4e:Cortex-X3
	41/d4f:Neoverse-V2
	41/d80:Cortex-A520
	41/d81:Cortex-A720
	41/d82:Cortex-X4
	41/d84:Neoverse-V3
	41/d8e:Neoverse-N3
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
	43/0b0:Cavium OcteonTX2
	43/0b1:Cavium OcteonTX2 98XX
	43/0b2:Cavium OcteonTX2 96XX
	43/0b3:Cavium OcteonTX2 95XX
	43/0b4:Cavium OcteonTX2 95XXN
	43/0b5:Cavium OcteonTX2 95XXMM
	43/0b6:Cavium OcteonTX2 95XXO
	43/0b8:Cavium ThunderX3 T110
	44:DEC
	44/a10:DEC SA110
	44/a11:DEC SA1100
	46:Fujitsu
	46/001:A64FX
	48:HiSilicon
	48/d01:TaiShan v110
	48/d02:TaiShan v120
	48/d40:HiSilicon-A76
	48/d41:HiSilicon-A77
	48/d42:HiSilicon-A710
	49:Infineon
	4d:Motorola/Freescale
	4e:NVidia
	4e/000:NVidia Denver
	4e/003:NVidia Denver 2
	4e/004:NVidia Carmel
	50:APM
	50/000:APM X-Gene
	51:Qualcomm
	51/001:Qualcomm Oryon 1
	51/002:Qualcomm Oryon 2
	51/00f:Qualcomm Scorpion
	51/02d:Qualcomm Scorpion
	51/04d:Qualcomm Krait
	51/06f:Qualcomm Krait
	51/201:Qualcomm Kryo
	51/205:Qualcomm Kryo
	51/211:Qualcomm Kryo
	51/800:Qualcomm Falkor V1/Kryo
	51/801:Qualcomm Kryo V2
	51/802:Qualcomm Kryo 3XX Gold
	51/803:Qualcomm Kryo 3XX Silver
	51/804:Qualcomm Kryo 4XX Gold
	51/805:Qualcomm Kryo 4XX Silver
	51/c00:Qualcomm Falkor
	51/c01:Qualcomm Saphira
	53:Samsung
	53/001:Samsung Exynos-m1
	53/002:Samsung Exynos-m3
	53/003:Samsung Exynos-m4
	53/004:Samsung Exynos-m5
	56:Marvell
	56/131:Marvell Feroceon 88FR131
	56/581:Marvell PJ4/PJ4b
	56/584:Marvell PJ4B-MP
	61:Apple
	61/000:Apple Swift
	61/001:Apple Cyclone
	61/002:Apple Typhoon
	61/003:Apple Typhoon/Capri
	61/004:Apple Twister
	61/005:Apple Twister/Elba/Malta
	61/006:Apple Hurricane
	61/007:Apple Hurricane/Myst
	61/008:Apple Monsoon
	61/009:Apple Mistral
	61/00b:Apple Vortex
	61/00c:Apple Tempest
	61/00f:Apple Tempest-M9
	61/010:Apple Vortex-Aruba
	61/011:Apple Tempest-Aruba
	61/012:Apple Lightning
	61/013:Apple Thunder
	61/020:Apple Icestorm A14
	61/021:Apple Firestorm A14
	61/022:Apple Icestorm M1
	61/023:Apple Firestorm M1
	61/024:Apple Icestorm M1Pro
	61/025:Apple Firestorm M1Pro
	61/026:Apple Thunder-M10
	61/028:Apple Icestorm M1Max
	61/029:Apple Firestorm M1Max
	61/030:Apple Blizzard A15
	61/031:Apple Avalanche A15
	61/032:Apple Blizzard M2
	61/033:Apple Avalanche M2
	61/034:Apple Blizzard M2Pro
	61/035:Apple Avalanche M2Pro
	61/036:Apple Sawtooth A16
	61/037:Apple Everest A16
	61/038:Apple Blizzard M2Max
	61/039:Apple Avalanche M2Max
	61/046:Apple Sawtooth M11
	61/048:Apple Sawtooth M3Max
	61/049:Apple Everest M3Max
	61/000:Virtualized Apple Silicon
	00/000:Virtualized Apple Silicon
	66:Faraday
	66/526:Faraday FA526
	66/626:Faraday FA626
	68:Huaxintong Semiconductor (HXT)
	68/000:HXT Phecda
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
	6d:Microsoft
	6d/d49:Azure Cobalt 100
	70:Phytium
	70/303:Phytium FTC310
	70/660:Phytium FTC660
	70/661:Phytium FTC661
	70/662:Phytium FTC662
	70/663:Phytium FTC663
	70/664:Phytium FTC664
	70/862:Phytium FTC862
	c0:Ampere
	c0/ac3:Ampere Ampere-1
	c0/ac4:Ampere Ampere-1a" | cut -f2 -d:
} # GetARMCore

GetCoreType() {
	# function that returns name of CPU cores on several platforms
	# $1 is the CPU in question, 1st CPU is always cpu0
	case ${CPUArchitecture} in
		arm*|aarch*)
			if [ -n "${ARMTypes}" ]; then
				GetARMCore "${ARMTypes[$(( $1 * 2 ))]}" "${ARMTypes[$(( $(( $1 * 2 )) + 1 ))]}" | tail -n1
			fi
			;;
		riscv*)
			# TODO: newer kernels now expose more information so we could use this:
			# (mvendorid corresponds to manufacturer's JEDEC ID)
			# https://gist.github.com/ThomasKaiser/14002f473d354360bf6d87c652c209aa

			# relying on uarch doesn't work with older RISC-V kernels since missing
			grep -q '^uarch' <<< "${ProcCPU}"
			case $? in
				0)
					awk -F": " '/^uarch/ {print $2}' <<< "${ProcCPU}" | sed -n $(( $1 + 1 ))p
					;;
				*)
					awk -F": " '/^isa/ {print $2}' <<< "${ProcCPU}" | sed -n $(( $1 + 1 ))p
					;;
			esac
			;;
		loongarch*)
			ModelName="$(awk -F": " '/^model name/ {print $2}' <<< "${ProcCPU}" | sed -n $(( $1 + 1 ))p)"
			case ${ModelName} in
				*3?5000*)
					echo "LA464"
					;;
				*3?6000*)
					echo "LA664"
					;;
				"")
					# fallback to cpu model if existing
					grep -q 'cpu model' <<< "${ProcCPU}" && awk -F": " '/^cpu model/ {print $2}' <<< "${ProcCPU}" | sed -n $(( $1 + 1 ))p
					;;
				*\(*)
					# we use just the part in brackets: Loongson-3A R4 (Loongson-3A4000) @ 1500MHz
					awk -F"[()]" '{print $2}' <<<"${ModelName}"
					;;
				*)
					echo "${ModelName}"
					;;
			esac
			;;
		mips*)
			awk -F": " '/^cpu model/ {print $2}' <<< "${ProcCPU}" | sed -n $(( $1 + 1 ))p
			;;
		x86_64)
			# on hybrid x86 designs print core type
			if [ ${#ClusterConfig[@]} -gt 1 ]; then
				if [ $1 -lt ${ClusterConfig[1]} ]; then
					echo "${PCores}"
				else
					echo "${ECores}"
				fi
			fi
			;;
	esac
} # GetCoreType

GetARMStepping() {
	# Parse '^CPU variant|^CPU revision' fields from /proc/cpuinfo and transform them
	# into 'Stepping' like lscpu does (the latter in older versions only showing info for
	# cpu0 so partially useless on systems with different CPU clusters)
	if [ -n "${ARMStepping}" ]; then
		echo "r$(awk -Wposix '{printf("%d", $1)}' <<<${ARMStepping[$(( $1 * 2 ))]})p${ARMStepping[$(( $(( $1 * 2 )) + 1 ))]}"
	fi
} # GetARMStepping

GetCPUInfo() {
	# function that returns ARM/RISC-V core type in brackets if possible otherwise empty string
	CoreType="$(GetCoreType $1)"
	[ -n "${CoreType}" ] && echo " (${CoreType})"
} # GetCPUInfo

GetLastClusterCore() {
	NextCore=${ClusterConfig[$1]}
	[ "${NextCore}" = "" ] && NextCore=$(awk -F" " '/^CPU...:/ {print $2}' <<<"${LSCPU}")
	echo -n $(( ${NextCore} - 1 ))
} # GetLastClusterCore

GetLastClusterCoreByType() {
	NextCore=${ClusterConfigByCoreType[$1]}
	[ "${NextCore}" = "" ] && NextCore=$(awk -F" " '/^CPU...:/ {print $2}' <<<"${LSCPU}")
	echo -n $(( ${NextCore} - 1 ))
} # GetLastClusterCoreByType

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
	# 5.2.15 / BCM2712 @ 3.0 GHz:           41210070

	local i
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

HandleGovernors() {
	# check and report governors that might affect performance behaviour. Stuff like
	# memory/GPU/NPU governors. On RK3588 it looks like this for example:
	#
	# Status of performance related governors found below /sys:
	# cpufreq-policy0: ondemand / 408 MHz (conservative ondemand userspace powersave performance schedutil / 408 600 816 1008 1200 1416 1608 1800)
	# cpufreq-policy4: ondemand / 408 MHz (conservative ondemand userspace powersave performance schedutil / 408 600 816 1008 1200 1416 1608 1800 2016 2208 2256 2304 2352 2400)
	# cpufreq-policy6: ondemand / 408 MHz (conservative ondemand userspace powersave performance schedutil / 408 600 816 1008 1200 1416 1608 1800 2016 2208 2256 2304 2352 2400)
	# dmc: dmc_ondemand / 528 MHz (rknpu_ondemand dmc_ondemand userspace powersave performance simple_ondemand / 528 1068 1560 2112)
	# fb000000.gpu: simple_ondemand / 300 MHz (rknpu_ondemand dmc_ondemand userspace powersave performance simple_ondemand / 300 400 500 600 700 800 900 1000)
	# fdab0000.npu: rknpu_ondemand / 1000 MHz (rknpu_ondemand dmc_ondemand userspace powersave performance simple_ondemand / 300 400 500 600 700 800 900 1000)

	# use colours and bold when outputting to a terminal
	[ -z "${BOLD}" ] && CheckTerminal

	Governors="$(find /sys -name "*governor" 2>/dev/null | grep -E -v '/sys/module|cpuidle|watchdog')"
	if [ "X${Governors}" = "X" ] || [ "${CPUArchitecture}" = "x86_64" ]; then
		# skip if no governors found or on x86 where lots of cpufreq governors are
		# listed to no avail since the actual work is done layers below.
		return
	elif [ "X$1" != "X" ]; then
		# try to set all governors to $1
		echo "${Governors}" | while read ; do
			echo $1 >"${REPLY}" 2>/dev/null
		done
		# If in adjust mode we also tune ASPM since this can massively affect performance
		# of components behind PCIe buses (NVMe SSDs, PCIe attached HBAs, NICs and so on)
		if [ -w /sys/module/pcie_aspm/parameters/policy ] && [ -d /sys/bus/pci_express ]; then
			read OriginalASPMSetting </sys/module/pcie_aspm/parameters/policy
			echo $1 >/sys/module/pcie_aspm/parameters/policy 2>/dev/null
		fi
		return
	fi

	# process governors:
	echo "${Governors}" | while read ; do
		read Governor <"${REPLY}"
		if [ "X${Governor}" != "X" ]; then
			SysFSNode="$(sed 's/cpufreq\//cpufreq-/' <<<"${REPLY%/*}")"
			AvailableGovernorsSysFSNode="$(ls -d "${REPLY%/*}"/*available_governors 2>/dev/null)"
			AvailableFrequenciesSysFSNode="$(ls -d "${REPLY%/*}"/*available_frequencies 2>/dev/null)"
			if [ -r "${REPLY%/*}/cpuinfo_cur_freq" ]; then
				Curfreq=" / $(awk '{printf ("%0.0f",$1/1000); }' <"${REPLY%/*}/cpuinfo_cur_freq") MHz"
				Divider=1000
			elif [ -r "${REPLY%/*}/scaling_cur_freq" ]; then
				Curfreq=" / $(awk '{printf ("%0.0f",$1/1000); }' <"${REPLY%/*}/scaling_cur_freq") MHz"
				Divider=1000
			elif [ -r "${REPLY%/*}/cur_freq" ]; then
				read Rawfreq <"${REPLY%/*}/cur_freq"
				if [ ${Rawfreq} -gt 10000000 ]; then
					Curfreq=" / $(awk '{printf ("%0.0f",$1/1000000); }' <<<"${Rawfreq}") MHz"
					Divider=1000000
				else
					Curfreq=" / $(awk '{printf ("%0.0f",$1/1000); }' <<<"${Rawfreq}") MHz"
					Divider=1000
				fi
			else
				Curfreq=""				
			fi
			if [ -r "${AvailableGovernorsSysFSNode}" ]; then
				# with some kernels powersave and performance are only listed as available
				# after the governor itself has been set to these. So try this just not
				# with cpufreq since there it always works as designed
				case "${SysFSNode##*/}" in
					*cpufreq*)
						:
						;;
					*)
						echo performance >"${REPLY}" 2>/dev/null
						echo powersave >"${REPLY}" 2>/dev/null
						echo "${Governor}" >"${REPLY}" 2>/dev/null
						;;
				esac
				read AvailableGovernors <"${AvailableGovernorsSysFSNode}"
				if [ "X${AvailableGovernors}" != "X${Governor}" ]; then
					[ -r "${AvailableFrequenciesSysFSNode}" ] \
						&& AvailableFrequencies=" / $(tr ' ' '\n' <"${AvailableFrequenciesSysFSNode}" | sort -n | sed '/^$/d' | awk "{printf (\"%0.0f\\n\",\$1/${Divider}); }" | tr '\n' ' ' | sed -e 's/\ $//' -e 's/^ //')" \
						|| AvailableFrequencies=""
					printf "${SysFSNode##*/}: "
					grep -q "performance" <<<"${AvailableGovernors}"
					GovStatus=$?
					if [ ${GovStatus} -eq 0 ] && [ "X${Governor}" = "Xperformance" ]; then
						echo -e "${LGREEN}performance${NC}${Curfreq} (${AvailableGovernors}${AvailableFrequencies})"
					elif [ ${GovStatus} -eq 0 ] && [ "X${Governor}" != "Xperformance" ]; then
						echo -e "${LRED}${Governor}${NC}${Curfreq} ($(sed "s/performance/\x1b\x5b1mperformance\x1b\x5b0m/" <<<"${AvailableGovernors}")${AvailableFrequencies})"
					else
						echo "${Governor}${Curfreq} (${AvailableGovernors}${AvailableFrequencies})"
					fi
				fi
			else
				echo "${SysFSNode##*/}: ${Governor}${Curfreq}"
			fi
		fi
	done | sort -n
} # HandleGovernors

HandlePolicies() {
	# report available sysfs policies that might affect performance behaviour. Stuff like
	# pcie_aspm, gpu/core_availability_policy, gpu/power_policy or iopolicy. With RK3588
	# this might look like this for example:
	#
	# Status of performance related policies found below /sys:
	# /sys/devices/platform/fb000000.gpu/power_policy: [coarse_demand] always_on
	# /sys/module/pcie_aspm/parameters/policy: default performance [powersave] powersupersave

	# use colours and bold when outputting to a terminal
	[ -z "${BOLD}" ] && CheckTerminal

	# If script is sourced we need to read in relevant dmesg contents
	[ -z "${DMESG}" ] && DMESG="$(dmesg | grep pcie)"

	# process policies
	SysFSPolicies="$(find /sys -name "*policy" 2>/dev/null | grep -E -v 'hotplug|cpufreq|thermal_zone|apparmor|hostap|/sys/kernel|/sys/devices/pci|mobile_lpm_|xmit_hash_|fr_policy|selinux')"
	if [ "X${SysFSPolicies}" = "X" ]; then
		# skip if no policies found
		return
	fi

	echo "${SysFSPolicies}" | while read ; do
		read Policy <"${REPLY}"
		if [ "X${Policy}" != "X" ]; then
			case "${REPLY}" in
				*pcie_aspm*)
					# PCIe's ASPM gets special treatment since values are standardized
					# so we can use coloured output. We also need to check for 'pcie'
					# occurences in kernel ring buffer since reporting ASPM settings on
					# devices lacking PCIe capabilities is pointless
					grep -q pcie <<<"${DMESG}"
					PCIeInDmesg=$?
					if [ -d /sys/bus/pci_express ] && [ ${PCIeInDmesg} -eq 0 ]; then
						case ${Policy} in
							*"[performance]"*)
								echo -e "${REPLY}: ${LGREEN}${Policy}${NC}"
								;;
							*"[powersave]"*|*"[powersupersave]"*)
								echo -e "${REPLY}: ${LRED}${Policy}${NC}"
								;;
							*)
								echo -e "${REPLY}: ${Policy}"
								;;
						esac
					fi
					;;
				*)
					# report policy if there is more than one value possible, otherwise skip
					grep -q ' ' <<<"${Policy}" && echo -e "${REPLY}: ${Policy}"
					;;
			esac
		fi
	done | sort -n
} # HandlePolicies

PlotPerformanceGraph() {
	# function that walks through all cpufreq OPP and plots a performance graph using
	# 7-ZIP MIPS. Needs gnuplot and htmldoc (Debian/Ubuntu: gnuplot-nox htmldoc packages)

	local i

	if [ ! -f /sys/devices/system/cpu/cpufreq/policy0/scaling_governor ]; then
		# no cpufreq support -> no way to test through different clockspeeds. Stop
		echo -e " Done.\nNo cpufreq support available. Not able to draw performance graph(s)."
		exit 1
	fi

	# repeat every measurement at least this many times and do not measure any cpufreq below
	MinRepetitions=3 # how many times should each measurement be repeated
	Repetitions=$(( 1000000000 / ${QuickAndDirtyPerformance} ))
	[ ${Repetitions} -lt ${MinRepetitions} ] && Repetitions=${MinRepetitions}
	SkipBelow=${MinKHz:-600000} # minimum cpufreq in KHz to measure

	if [ "X${OutputCurrents[*]}" != "X" ]; then
		# We are in Netio monitoring mode, so measure idle consumption first,
		# set all governors and PCIe ASPM to lowest clockspeed / powersave
		HandleGovernors powersave

		NetioConsumptionFile="${TempDir}/netio.current"
		echo -n $(( $(awk '{printf ("%0.0f",$1/10); }' <<<"${OutputCurrent[$(( ${NetioSocket} - 1 ))]}" ) * 10 )) >"${NetioConsumptionFile}"
		export NetioConsumptionFile
		/bin/bash "${PathToMe}" -N "${NetioDevice}" "${NetioSocket}" "${NetioConsumptionFile}" "4.8" "30" >/dev/null 2>&1 &
		NetioMonitoringPID=$!

		echo -e "\x08\x08 Done.\nTrying to determine idle consumption...\c"
		echo -e "System health while idling for 4 minutes:\n" >>"${MonitorLog}"
		/bin/bash "${PathToMe}" -m 30 >>"${MonitorLog}" &
		MonitoringPID=$!

		snore 240
		read IdleConsumption <"${NetioConsumptionFile}"
		kill ${NetioMonitoringPID} ${MonitoringPID}
		IdleTemp=$(ReadSoCTemp)
		echo -e "\n##########################################################################\n\nIdle temperature: ${IdleTemp}°C, idle consumption: $(( $(awk '{printf ("%0.0f",$1/10); }' <<<"${IdleConsumption}" ) * 10 )) mW" >>"${ResultLog}"
	fi

	CheckNetio

	# check if cpulist parameter has been provided as well:
	if [ "X${CPUList}" = "X" ]; then
		# -g has been used without further restrictions, we run performance test on all cores
		CheckPerformance "all CPU cores" "$(tr -d '[:space:]' <<<"${ClusterConfig[@]}")"
		PlotGraph "all CPU cores" "$(tr -d '[:space:]' <<<"${ClusterConfig[@]}")"
		RenderPDF
	else
		# -g with additional options has been called
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
			coreclusters)
				# check all identical cores of every cluster, on RK3588 for example 0-3 and 4-7
				# though this SoC consists of 3 clusters: 0-3 (A55), 4-5 (A76) and 6-7 (A76)
				for i in $(seq 0 $(( ${#ClusterConfigByCoreType[@]} -1 )) ) ; do
					FirstCore=${ClusterConfigByCoreType[$i]}
					LastCore=$(GetLastClusterCoreByType $(( $i + 1 )))
					CheckPerformance "CPU ${FirstCore}-${LastCore}" "${FirstCore}" "${FirstCore}-${LastCore}"
					CPUInfo="$(GetCPUInfo ${FirstCore})"
					PlotGraph "CPU ${FirstCore}-${LastCore}${CPUInfo}" "${FirstCore}"
				done
				RenderPDF
				;;
			all)
				# check each core of every cluster individually, check cores of each cluster,
				# if real clusters and 'clusters of same type' (see RK3588 example above) differ
				# then check 'clusters of same type' and then check all cores
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
				if [ ${#ClusterConfigByCoreType[@]} -ne ${#ClusterConfig[@]} ]; then
					for i in $(seq 0 $(( ${#ClusterConfigByCoreType[@]} -1 )) ) ; do
						FirstCore=${ClusterConfigByCoreType[$i]}
						LastCore=$(GetLastClusterCoreByType $(( $i + 1 )))
						CheckPerformance "CPU ${FirstCore}-${LastCore}" "${FirstCore}" "${FirstCore}-${LastCore}"
						CPUInfo="$(GetCPUInfo ${FirstCore})"
						PlotGraph "CPU ${FirstCore}-${LastCore}${CPUInfo}" "${FirstCore}"
					done
				fi
				if [ ${#ClusterConfig[@]} -gt 1 ]; then
					# more than one CPU cluster, we test using all cores simultaneously
					CheckPerformance "all CPU cores" "$(tr -d '[:space:]' <<<"${ClusterConfig[@]}")"
					PlotGraph "all CPU cores" "$(tr -d '[:space:]' <<<"${ClusterConfig[@]}")"
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
	# * $3 taskset options as provided via the -g switch when calling sbc-bench

	local i

	if [ -n "${3}" ]; then
		# if taskset options are provided ensure that '-mmt=1' is set when only a single
		# core is tested.
		TasksetOptions="taskset -c ${3} "
		if [ ${#3} -eq 1 ]; then
			SevenZIPOptions="-mmt=1"
		elif [ ${#3} -eq 3 ]; then
			# something like 0-3 or 4-5, determine count of cpu cores:
			HowManyCores=$(( $(( ${3:2:1} - ${3:0:1} )) + 1 ))
			SevenZIPOptions="-mmt=${HowManyCores}"
		else
			SevenZIPOptions=""
		fi
	else
		TasksetOptions=""
		SevenZIPOptions=""
	fi

	Clusters="$(ls -d /sys/devices/system/cpu/cpufreq/policy[${2}])"

	echo -e "\x08\x08 Done.\nChecking ${1}: \c"
	echo -e "\nSystem health while testing through ${1} ${Repetitions} times:\n" >>"${MonitorLog}"
	/bin/bash "${PathToMe}" -m $(( 30 * ${Repetitions} )) >>"${MonitorLog}" &
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
		echo -e "Testing through ${1} ${Repetitions} times:\n\nSysfs/ThreadX/Tested:  MIPS / Temp${NetioHeader}" >"${CpufreqLog}"
	else
		echo -e "Testing through ${1} ${Repetitions} times:\n\nSysfs/Tested:  MIPS / Temp${NetioHeader}" >"${CpufreqLog}"
	fi

	# adjust min and max speeds (set max speeds on unaffected clusters to min speed)
	for Cluster in /sys/devices/system/cpu/cpufreq/policy? ; do
		[[ -e "${Cluster}" ]] || break
		echo userspace >${Cluster}/scaling_governor
		read MinSpeed <${Cluster}/cpuinfo_min_freq
		read MaxSpeed <${Cluster}/cpuinfo_max_freq
		echo ${MinSpeed} >${Cluster}/scaling_setspeed
	done
	for Cluster in ${Clusters}; do
		echo userspace >${Cluster}/scaling_governor
		read MinSpeed <${Cluster}/cpuinfo_min_freq
		read MaxSpeed <${Cluster}/cpuinfo_max_freq
		echo ${MinSpeed} >${Cluster}/scaling_setspeed
	done

	# now walk through higher cluster since this is supposed to provide more cpufreq OPP.
	# On ARM usually little cores are the cores with lower numbers. 
	BiggestCluster="$(sort -n -r <<<${Clusters} | head -n1)"
	for i in $((tr " " "\n" <${BiggestCluster}/scaling_available_frequencies ; tr " " "\n" <${BiggestCluster}/scaling_boost_frequencies) 2>/dev/null | sort -n | uniq | sed '/^[[:space:]]*$/d') ; do
		# skip measuring cpufreq OPPs below $SkipBelow KHz
		if [ $i -lt ${SkipBelow} ]; then
			continue
		fi
		# try to set this speed on all affected cpufreq policies
		if [ "X${3}" = "X" ]; then
			for Cluster in /sys/devices/system/cpu/cpufreq/policy? ; do
				[[ -e "${Cluster}" ]] || break
				[ -f ${Cluster}/scaling_setspeed ] && echo ${i} >${Cluster}/scaling_setspeed
			done
		else
			for Cluster in $(seq ${3:0:1} ${3:2:1}); do
				[ -f /sys/devices/system/cpu/cpufreq/policy${Cluster}/scaling_setspeed ] && echo ${i} >/sys/devices/system/cpu/cpufreq/policy${Cluster}/scaling_setspeed
			done
		fi
		snore 0.1
		
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
			ThreadXFreq=$("${VCGENCMD}" measure_clock arm 2>/dev/null | awk -F"=" '{printf ("%0.0f",$2/1000000); }' )
			CoreVoltage=$("${VCGENCMD}" measure_volts uncached 2>/dev/null | cut -f2 -d=)
			[ "X${CoreVoltage}" = "X" ] && CoreVoltage=$("${VCGENCMD}" measure_volts 2>/dev/null | cut -f2 -d=)
			echo -e "$(printf "%4s" ${SysfsSpeed}) /  $(printf "%4s" ${ThreadXFreq}) /$(printf "%6s" ${RoundedSpeed}):\c" >>"${CpufreqLog}"
			echo -e "${ThreadXFreq}\t\c" >>"${CpufreqDat}"
			echo -e "${ThreadXFreq}MHz, \c"
		else
			echo -e "$(printf "%4s" ${SysfsSpeed}) / $(printf "%4s" ${RoundedSpeed}) :\c" >>"${CpufreqLog}"
			echo -e "${MeasuredSpeed}\t\c" >>"${CpufreqDat}"
			echo -e "${SysfsSpeed}MHz, \c"
		fi

		echo -n "" >"${TempDir}/plotvalues"
		for _check in $(seq 1 ${Repetitions}) ; do
			# run 7-zip benchmark
			${TasksetOptions} "${SevenZip}" b ${SevenZIPOptions} >"${TempLog}" 2>/dev/null
			if [ -s "${NetioConsumptionFile}" ]; then
				read ConsumptionNow <"${NetioConsumptionFile}"
			fi
			SocTemp=$(ReadSoCTemp)
			MIPS="$(awk -F" " '/^Tot:/ {print $4}' <"${TempLog}")"
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
	echo -e "\n##########################################################################\n\n$(cat ${TempDir}/cpufreq${2}.log)" >>"${ResultLog}"
	gnuplot-nox -p -e \
		"set terminal dumb size 75, 30; set autoscale; set yrange [0:${YRangeMIPS}]; plot '${CpufreqDat}' using 1:2  with lines notitle" \
		>>"${ResultLog}"

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
		sbc-bench has been called with <code>-g ${CPUList}</code>
	EOF

	ls -r --time=atime "${TempDir}"/*.png | while read Graph ; do
		echo -e "<img src=\"${Graph}\">" >>${TempDir}/report.html
	done

	cat <<- EOF >>${TempDir}/report.html
		 
		<pre>$(sed '/^$/N;/^\n$/D' <"${ResultLog}")</pre>
	</body>
	</html>
	EOF

	htmldoc --charset utf-8 --headfootfont helvetica-oblique --headfootsize 7 --header ..c --tocheader . --firstpage c1 --quiet --browserwidth 900 --pagemode outline --fontsize 8 --format pdf14 --bodyfont helvetica --bottom 1cm --pagelayout single --left 2.5cm --right 2cm --top 1.7cm --linkstyle plain --linkcolor blue --textcolor black --bodycolor white --links --size 210x297mm --portrait --compression=9 --jpeg=95 --webpage -f "${TempDir}/report.pdf" "${TempDir}/report.html"

	if [ -s "${TempDir}/report.pdf" ]; then
		PDFName="sbc-bench-v${Version}-$(tr ' ' '-' <<<"${DeviceName,,}")-${CPUList}"
		FinalPDF="$(mktemp "/tmp/${PDFName}".XXXXXX)"
		cat "${TempDir}/report.pdf" >"${FinalPDF}"
		mv "${FinalPDF}" "${FinalPDF}.pdf"
		chmod 644 "${FinalPDF}.pdf"
		# make a copy in a permanent location since stuff in /tmp/ gets lost after reboot
		cp "${FinalPDF}.pdf" "${HOME}/"
		echo -e "\x08\x08 Done.\n\nPlease check ${FinalPDF}.pdf"
	else
		echo -e "\x08\x08 Done.\n\nSomething went wrong"
	fi
} # RenderPDF

GetTempSensor() {
	# In Armbian we can not rely on /etc/armbianmonitor/datasources/soctemp at all any more
	# since nobody is left there who cares about /usr/lib/armbian/armbian-hardware-monitor.
	# Armbian always chooses /sys/class/hwmon/hwmon0 which can be something totally different
	# than the SoC temperature, for example:
	# * http://ix.io/3Q5y --> sun4i_ts (touch controller)
	# * http://ix.io/3MFz --> w1_slave_temp (1-wire sensor)
	# * http://ix.io/411x --> gpu_thermal (obviously _not_ cpu_thermal)
	# * http://ix.io/41IL --> iwlwifi_1 (Wi-Fi card)
	# * http://ix.io/4nt8 --> acpitz (whatever sensor remaining at 26.8°C)

	if [ -f /etc/armbianmonitor/datasources/soctemp ] && [ "${CPUArchitecture}" != "x86_64" ]; then
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
			*)
				# Quick results check within few months showed the following types which
				# smell all not that good if it's about CPU or SoC temperatures:
				# scpi_sensors, w1_slave_temp, iio_hwmon, sun4i_ts, gpu_thermal, iwlwifi_1
				NodeGuess=$(cat /sys/devices/virtual/thermal/thermal_zone?/type 2>/dev/null | sort -n | grep -E "cpu|soc|CPU-therm|x86_pkg_temp|thermal-fan-est" | head -n1)
				if [ "X${NodeGuess}" != "X" ]; then
					# let's use this thermal node instead
					if [ -d "${TempDir}" ]; then
						TempSource="${TempDir}/soctemp"
					else
						TempSource="$(mktemp /tmp/soctemp.XXXXXX)"
						trap 'rm -f "${TempSource}" ; exit 0' 0
					fi
					ThermalZone="$(GetThermalZone "${NodeGuess}")"
					ln -fs ${ThermalZone}/temp ${TempSource}
					if [ -f "${ThermalNode%/*}/temp1_label" ]; then
						read TempLabel <"${ThermalNode%/*}/temp1_label"
						case "${TempLabel}" in
							aml_thermal|cpu|cpu_thermal*|cpu-thermal*|cpu0-thermal*|cpu0_thermal*|soc_thermal*|soc-thermal*|CPU-therm|x86_pkg_temp|k10temp|k8temp|coretemp)
								# looks like a legit thermal sensor
								TempInfo="Thermal source: ${ThermalZone}/ (${NodeGuess})"
								;;
							*)
								# looks weird so print a warning
								TempInfo="Thermal source: ${ThermalZone}/ (${NodeGuess})\n                (Armbian wants to use ${ThermalNode%/*} instead, that\n                zone is named ${ThermalSource}. Please check and if wrong\n                file a bug here: https://github.com/armbian/build/issues/)"
								;;
						esac
					fi
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
		if [ -d "${TempDir}" ]; then
			TempSource="${TempDir}/soctemp"
		else
			TempSource="$(mktemp /tmp/soctemp.XXXXXX)"
			trap 'rm -f "${TempSource}" ; exit 0' 0
		fi

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
						find /sys -name 'temp?_input' -type f 2>/dev/null | while read ; do
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
					ThermalNodeGuess=$(cat /sys/devices/virtual/thermal/thermal_zone?/type 2>/dev/null | grep -E -i "aml_thermal|cpu|soc" | tail -n1)
					HWMonNodeGuess=$(cat /sys/class/hwmon/hwmon?/name 2>/dev/null | grep -E -i "120e0000|cpu-hwmon" | tail -n1)
					if [ "X${ThermalNodeGuess}" != "X" ]; then
						# let's use this thermal node
						ThermalZone="$(GetThermalZone "${ThermalNodeGuess}")"
						ln -fs ${ThermalZone}/temp ${TempSource}
						TempInfo="Thermal source: ${ThermalZone}/ (${ThermalNodeGuess})"
					elif [ "X${HWMonNodeGuess}" != "X" ]; then
						# temporary hack to support thermal readouts on JH71x0 boards running
						# StarVision vendor kernel and Loongson CPUs with 4.19.0 vendor kernel
						ThermalZone="$(GetHWNode "${HWMonNodeGuess}")"
						if [ -r ${ThermalZone}/temp1_input ]; then
							ln -fs ${ThermalZone}/temp1_input ${TempSource}
							TempInfo="Thermal source: ${ThermalZone}/ (${HWMonNodeGuess})"
						else
							echo 0 >${TempSource}
						fi
					else
						echo 0 >${TempSource}
					fi
				fi
				;;
		esac
	fi
	export TempSource TempInfo
	InitialTemp=$(ReadSoCTemp)
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

GetHWNode() {
	# get hwmon node for specific name string ($1)
	for node in /sys/class/hwmon/hwmon* ; do
		grep -q "${1}" <"${node}/name"
		case $? in
			0)
				echo ${node}
				return
				;;
		esac
	done
} # GetHWNode

CheckNetio() {
	# Function that checks connection with a Netio powermeter if $Netio is set and if
	# successful spawns another execution of this script with -N (Netio monitor mode.).

	if [ "X${Netio}" != "X" ]; then
		# Try to fetch XML
		XMLOutput="$(curl -q --connect-timeout 1 "http://${NetioDevice}/netio.xml" 2>/dev/null | tr '\015' '\012')"
		if [ "X${XMLOutput}" = "X" ] && [ "X${MODE}" != "Xunattended" ]; then
			echo -e "\nError: not able to fetch \"http://${NetioDevice}/netio.xml\" within a second.\nPlease check parameters and connection manually." >&2
			DisplayUsage
			exit 1
		else
			# check current reading of the socket we're supposed to be plugged into
			OutputCurrents=($(grep '^<Current>' <<<"${XMLOutput}" | sed -e 's/\(<[^<][^<]*>\)//g' | tr '\n' ' '))
			if [ ${OutputCurrents[$(( ${NetioSocket} - 1 ))]} -eq 0 ] && [ "X${MODE}" != "Xunattended" ]; then
				echo -e "\nWarning: socket ${NetioSocket} of Netio device ${NetioDevice} provides zero current.\n"
			fi
			NetioConsumptionFile="${TempDir}/netio.current"
			[ -f "${NetioConsumptionFile}" ] || echo -n 0 >"${NetioConsumptionFile}"
			export NetioConsumptionFile
			/bin/bash "${PathToMe}" -N "${NetioDevice}" "${NetioSocket}" "${NetioConsumptionFile}" >/dev/null 2>&1 &
			NetioMonitoringPID=$!
			trap 'kill ${NetioMonitoringPID} ; rm -rf "${TempDir}" ; exit 0' 0
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
		snore ${SleepInterval}
	done
} # MonitorNetio

PrintCPUInfo() {
	BasicSetup nochange
	[ -z "${DTCompatible}" ] && [ -r /proc/device-tree/compatible ] && DTCompatible="$(tr "\000" "\n" </proc/device-tree/compatible 2>/dev/null)"
	[ -z "${LSCPU}" ] && LSCPU="$(lscpu)"
	[ -z "${CPUArchitecture}" ] && CPUArchitecture="$(awk -F" " '/^Architecture/ {print $2}' <<<"${LSCPU}")"
	[ -z "${VoltageSensor}" ] && VoltageSensor="$(GetVoltageSensor)"
	[ -z "${CPUTopology}" ] && CPUTopology="$(PrintCPUTopology)"
	[ -z "${CPUSignature}" ] && CPUSignature="$(GetCPUSignature)"
	[ -z "${X86CPUName}" ] && X86CPUName="$(sed 's/ \{1,\}/ /g' <<<"${LSCPU}" | awk -F": " '/^Model name/ {print $2}' | sed -e 's/1.th Gen //' -e 's/.th Gen //' -e 's/Core(TM) //' -e 's/ Processor//' -e 's/Intel(R) Xeon(R) CPU //' -e 's/Intel(R) //' -e 's/(R)//' -e 's/CPU //' -e 's/ 0 @/ @/' -e 's/AMD //' -e 's/Authentic //' -e 's/ with .*//')"

	[ -f /sys/devices/soc0/family ] && read SoC_Family </sys/devices/soc0/family
	[ -f /sys/devices/soc0/soc_id ] && read SoC_ID </sys/devices/soc0/soc_id
	[ -f /sys/devices/soc0/revision ] && read SoC_Revision </sys/devices/soc0/revision
	if [ -n "${SoC_Revision}" ] && [ "${SoC_Family}" != "jep106:091e" ]; then
		# Only report this stuff if it's not related to ARM's SMCCC
		echo -e "${SoC_Family} ${SoC_ID} rev ${SoC_Revision}, \c"
	fi
	[ "${CPUArchitecture}" = "x86_64" ] && GuessedSoC="${X86CPUName:-n/a}" || GuessedSoC="$(GuessARMSoC)"
	[ "X${GuessedSoC}" != "Xn/a" ] && echo -e "${GuessedSoC}, \c"
	grep -q "BCM2711" <<<"${DeviceName}" && echo -e "${DeviceName}, \c"
	command -v dpkg >/dev/null 2>&1 && Userland=", Userland: $(dpkg --print-architecture 2>/dev/null)"
	[ "X${VirtWhat}" != "X" ] && [ "X${VirtWhat}" != "Xnone" ] && VirtOrContainer=" / ${BOLD}${VirtWhat}${NC}"
	echo -e "Kernel: ${CPUArchitecture}${VirtOrContainer}${Userland}"
	echo -e "\n${CPUTopology}\n"
	if [ "X${TempInfo}" != "X" ]; then
		echo -e "${TempInfo}\n"
	fi
} # PrintCPUInfo

MonitorBoard() {
	BasicSetup nochange
	[ -z "${TempSource}" ] && GetTempSensor
	[ -z "${DTCompatible}" ] && [ -r /proc/device-tree/compatible ] && DTCompatible="$(tr "\000" "\n" </proc/device-tree/compatible 2>/dev/null)"
	[ -z "${LSCPU}" ] && LSCPU="$(lscpu)"
	[ -z "${CPUArchitecture}" ] && CPUArchitecture="$(awk -F" " '/^Architecture/ {print $2}' <<<"${LSCPU}")"
	[ -z "${VoltageSensor}" ] && VoltageSensor="$(GetVoltageSensor)"
	[ -z "${CPUTopology}" ] && CPUTopology="$(PrintCPUTopology)"
	[ -z "${CPUSignature}" ] && CPUSignature="$(GetCPUSignature)"
	[ -z "${X86CPUName}" ] && X86CPUName="$(sed 's/ \{1,\}/ /g' <<<"${LSCPU}" | awk -F": " '/^Model name/ {print $2}' | sed -e 's/1.th Gen //' -e 's/.th Gen //' -e 's/Core(TM) //' -e 's/ Processor//' -e 's/Intel(R) Xeon(R) CPU //' -e 's/Intel(R) //' -e 's/(R)//' -e 's/CPU //' -e 's/ 0 @/ @/' -e 's/AMD //' -e 's/Authentic //' -e 's/ with .*//')"
	[ -z "${CPUFetchInfo}" ] && CPUFetchInfo="$(GrabCPUFetchInfo)"

	if test -t 1; then
		# when called from a terminal we print some system information first and insert
		# empty line + header every 15 lines. On x86 include cpufetch info if available
		if [ -x "${InstallLocation}"/cpufetch/cpufetch ] && [ "${CPUArchitecture}" = "x86_64" ]; then
			CPUFetchInfo="$("${InstallLocation}"/cpufetch/cpufetch)"
			[[ ${CPUFetchInfo} != *Unknown* ]] && echo -e "Information courtesy of cpufetch:\n${CPUFetchInfo}\n"
		fi
		PrintCPUInfo
		SPACING=yes
	else
		ClusterConfigByCoreType=($(GetCoreClusters))
		ClusterConfig=($(GetRelevantCPUClusters))
		if [ -f "${TempDir}/Pcores" ]; then
			read PCores <"${TempDir}/Pcores"
			read ECores <"${TempDir}/Ecores"
		fi
		[ ${#ClusterConfig[@]} -eq 0 ] && ClusterConfig=(0)
	fi

	# Background monitoring -- try to renice to 19 to not interfere with benchmark behaviour
	renice 19 $BASHPID >/dev/null 2>&1

	# switch to scaling_cur_freq if cpuinfo_cur_freq is not readable
	if [ -r /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq ]; then
		CpuFreqToQuery=cpuinfo_cur_freq
	else
		CpuFreqToQuery=scaling_cur_freq
	fi

	LastUserStat=0
	LastNiceStat=0
	LastSystemStat=0
	LastIdleStat=0
	LastIOWaitStat=0
	LastIrqStat=0
	LastSoftIrqStat=0
	LastTotal=0

	# check if we're in Netio consumption monitoring mode
	[ -s "${NetioConsumptionFile}" ] && NetioHeader="      mW"

	# check whether input voltage can be read
	[ "X${VoltageSensor}" != "X" ] && VoltageHeader="   DC(V)"

	# Check whether PMIC ADCs are readable on RPi 5
	"${VCGENCMD}" pmic_read_adc >/dev/null 2>&1
	case $? in
		0)
			PMIC_ADC=true
			VoltageHeader="   DC(V)"
			;;
		*)
			PMIC_ADC=false
			;;
	esac

	if [ ${USE_VCGENCMD} = true ] && [ ${PMIC_ADC} = true ] ; then
		DisplayHeader="Time        fake/real   load %cpu %sys %usr %nice %io %irq   Temp    VCore    PMIC${VoltageHeader}${NetioHeader}"
		CPUs=raspberrypi
	elif [ ${USE_VCGENCMD} = true ] ; then
		DisplayHeader="Time        fake/real   load %cpu %sys %usr %nice %io %irq   Temp    VCore${VoltageHeader}${NetioHeader}"
		CPUs=raspberrypi
	elif [ ${#ClusterConfig[@]} -eq 1 ] && [ -r /sys/devices/system/cpu/cpufreq/policy0/${CpuFreqToQuery} ] ; then
		DisplayHeader="Time        CPU    load %cpu %sys %usr %nice %io %irq   Temp${VoltageHeader}${NetioHeader}"
		CPUs=singlecluster
	elif [ ${#ClusterConfig[@]} -eq 3 ] && [ -r /sys/devices/system/cpu/cpufreq/policy${ClusterConfig[0]}/${CpuFreqToQuery} ] && [ -r /sys/devices/system/cpu/cpufreq/policy${ClusterConfig[1]}/${CpuFreqToQuery} ] && [ -r /sys/devices/system/cpu/cpufreq/policy${ClusterConfig[2]}/${CpuFreqToQuery} ] ; then
		DisplayHeader="Time       cpu${ClusterConfig[0]}/cpu${ClusterConfig[1]}/cpu${ClusterConfig[2]}    load %cpu %sys %usr %nice %io %irq   Temp${VoltageHeader}${NetioHeader}"
		CPUs=triplecluster
	elif [ -r /sys/devices/system/cpu/cpufreq/policy${ClusterConfig[1]}/${CpuFreqToQuery} ]; then
		ClusterCount=$(( ${#ClusterConfig[@]} -1 ))
		DisplayHeader="Time       big.LITTLE   load %cpu %sys %usr %nice %io %irq   Temp${VoltageHeader}${NetioHeader}"
		read FirstCluster </sys/devices/system/cpu/cpufreq/policy${ClusterConfig[0]}/cpuinfo_max_freq
		read LastCluster </sys/devices/system/cpu/cpufreq/policy${ClusterConfig[$ClusterCount]}/cpuinfo_max_freq
		if [ ${LastCluster} -ge ${FirstCluster} ]; then
			CPUs=biglittle
		else
			CPUs=littlebig
		fi
	else
		DisplayHeader="Time      CPU n/a    load %cpu %sys %usr %nice %io %irq   Temp${VoltageHeader}${NetioHeader}"
		CPUs=notavailable
	fi
	[ -f "${TempSource}" ] || SocTemp='n/a'
	echo -e "${DisplayHeader}"
	Counter=0
	while true ; do
		if [ "$SPACING" == "yes" ]; then
			# if SPACING is defined as yes insert an empty line + header every 15 lines
			let Counter++
			if [ ${Counter} -eq 15 ]; then
				echo -e "\n${DisplayHeader}"
				Counter=0
			fi
		fi
		LoadAvg=$(cut -f1 -d" " </proc/loadavg)
		if [ "X${SocTemp}" != "Xn/a" ]; then
			SocTemp=$(ReadSoCTemp)
		fi

		ProcessStats

		if [ "X${VoltageSensor}" != "X" ]; then
			InputVoltage="$(GetInputVoltage "${VoltageSensor}")"
			VoltageColumn="  $(printf "%4s" ${InputVoltage})"
		fi

		if [ -s "${NetioConsumptionFile}" ]; then
			read ConsumptionNow <"${NetioConsumptionFile}"
			NetioColumn="  $(printf "%5s" ${ConsumptionNow})"
		fi

		case ${CPUs} in
			raspberrypi)
				FakeFreq=$(awk '{printf ("%0.0f",$1/1000); }' </sys/devices/system/cpu/cpu0/cpufreq/${CpuFreqToQuery} 2>/dev/null)
				RealFreq=$("${VCGENCMD}" measure_clock arm 2>/dev/null | awk -F"=" '{printf ("%0.0f",$2/1000000); }' )
				if [ ${PMIC_ADC} = true ]; then
					ADC_Readouts="$("${VCGENCMD}" pmic_read_adc 2>/dev/null)"
					InputVoltage="$(awk -F"=" '/EXT5V_V/ {printf ("%0.2f",$2); }' <<<"${ADC_Readouts}")V"
					CoreVoltage="$(awk -F"=" '/VDD_CORE_V/ {printf ("%0.4f",$2); }' <<<"${ADC_Readouts}")V"
					[ "X${CoreVoltage}" = "X" ] && CoreVoltage=$("${VCGENCMD}" measure_volts 2>/dev/null | cut -f2 -d=)
					PMIC_Whole_Consumption=$(Parse_ADC_Readouts "${ADC_Readouts}" | awk '{s+=$1*$2} END {printf "%.1f", s}')
					printf "%s: %4s/%4sMHz %5s %s %8s %8s %6s %7s %s\n" "$(date "+%H:%M:%S")" "${FakeFreq}" "${RealFreq}" "${LoadAvg}" "${procStats}" "${SocTemp}°C" "${CoreVoltage}" "${PMIC_Whole_Consumption}W" "${InputVoltage}" "${NetioColumn}"
				else
					CoreVoltage=$("${VCGENCMD}" measure_volts uncached 2>/dev/null | cut -f2 -d=)
					[ "X${CoreVoltage}" = "X" ] && CoreVoltage=$("${VCGENCMD}" measure_volts 2>/dev/null | cut -f2 -d=)
					printf "%s: %4s/%4sMHz %5s %s %8s %8s %s\n" "$(date "+%H:%M:%S")" "${FakeFreq}" "${RealFreq}" "${LoadAvg}" "${procStats}" "${SocTemp}°C" "${CoreVoltage}" "${NetioColumn}"
				fi
				;;
			biglittle)
				BigFreq=$(awk '{printf ("%0.0f",$1/1000); }' </sys/devices/system/cpu/cpufreq/policy${ClusterConfig[$ClusterCount]}/${CpuFreqToQuery} 2>/dev/null)
				LittleFreq=$(awk '{printf ("%0.0f",$1/1000); }' </sys/devices/system/cpu/cpufreq/policy${ClusterConfig[0]}/${CpuFreqToQuery} 2>/dev/null)
				printf "%s: %4s/%4sMHz %5s %s %8s %s %s\n" "$(date "+%H:%M:%S")" "${BigFreq}" "${LittleFreq}" "${LoadAvg}" "${procStats}" "${SocTemp}°C" "${VoltageColumn}" "${NetioColumn}"
				;;
			littlebig)
				BigFreq=$(awk '{printf ("%0.0f",$1/1000); }' </sys/devices/system/cpu/cpufreq/policy${ClusterConfig[0]}/${CpuFreqToQuery} 2>/dev/null)
				LittleFreq=$(awk '{printf ("%0.0f",$1/1000); }' </sys/devices/system/cpu/cpufreq/policy${ClusterConfig[$ClusterCount]}/${CpuFreqToQuery} 2>/dev/null)
				printf "%s: %4s/%4sMHz %5s %s %8s %s %s\n" "$(date "+%H:%M:%S")" "${BigFreq}" "${LittleFreq}" "${LoadAvg}" "${procStats}" "${SocTemp}°C" "${VoltageColumn}" "${NetioColumn}"
				;;
			triplecluster)
				Freq0=$(awk '{printf ("%0.0f",$1/1000); }' </sys/devices/system/cpu/cpufreq/policy${ClusterConfig[0]}/${CpuFreqToQuery} 2>/dev/null)
				Freq1=$(awk '{printf ("%0.0f",$1/1000); }' </sys/devices/system/cpu/cpufreq/policy${ClusterConfig[1]}/${CpuFreqToQuery} 2>/dev/null)
				Freq2=$(awk '{printf ("%0.0f",$1/1000); }' </sys/devices/system/cpu/cpufreq/policy${ClusterConfig[2]}/${CpuFreqToQuery} 2>/dev/null)
				printf "%s: %4s/%4s/%4sMHz %5s %s %8s %s %s\n" "$(date "+%H:%M:%S")" "${Freq0}" "${Freq1}" "${Freq2}" "${LoadAvg}" "${procStats}" "${SocTemp}°C" "${VoltageColumn}" "${NetioColumn}"
				;;
			singlecluster)
				CpuFreq=$(awk '{printf ("%0.0f",$1/1000); }' </sys/devices/system/cpu/cpufreq/policy0/${CpuFreqToQuery} 2>/dev/null)
				printf "%s: %4sMHz %5s %s %8s %s %s\n" "$(date "+%H:%M:%S")" "${CpuFreq}" "${LoadAvg}" "${procStats}" "${SocTemp}°C" "${VoltageColumn}" "${NetioColumn}"
				;;
			notavailable)
				printf "%s:  n/aMHz %7s %s %8s %s %s\n" "$(date "+%H:%M:%S")" "${LoadAvg}" "${procStats}" "${SocTemp}°C" "${VoltageColumn}" "${NetioColumn}"
				;;
		esac
		snore ${SleepInterval}
	done
} # MonitorBoard

TempTest() {
	[ "X${TempSource}" = "X" ] && GetTempSensor

	SocTemp=$(ReadSoCTemp 2>/dev/null | cut -f1 -d'.')
	[ "X${SocTemp}" = "X" ] && \
		{ echo -e "${LRED}${BOLD}WARNING: No temperature source found. Aborting.${NC}" >&2 ; exit 1 ; }
	[ ${SocTemp} -lt 20 ] && \
		echo -e "${LRED}${BOLD}WARNING: sysfs thermal readout is ominously low: ${SocTemp}°C.${NC}\n" >&2

	BasicSetup nochange >/dev/null 2>&1
	InstallPrerequisits
	InitialMonitoring
	echo -e "\n${BOLD}Thermal efficiency test using $(readlink "${TempSource}")${NC}"
	echo -e "\nInstalling needed tools. This may take some time...\c"

	# get/build mhz and cpuminer if not already there
	if [ ! -x "${InstallLocation}"/mhz/mhz ]; then
		cd "${InstallLocation}" || exit 1
		git clone https://github.com/wtarreau/mhz >/dev/null 2>&1
		if [ $? -ne 0 ]; then
			echo -e "\n\n${LRED}${BOLD}Temporary Github problem. Not able to download mhz. Please try again later.${NC}" >&2
			exit 1
		fi
		cd mhz || exit 1
		make >/dev/null 2>&1
		if [ ! -x "${InstallLocation}"/mhz/mhz ]; then
			echo -e "${LRED}${BOLD}Not able to build necessary tools. Aborting.${NC}\nMost probably gcc and make packages are missing." >&2
			exit 1
		fi
	else
		grep -q 'among 5 runs of the short loop' "${InstallLocation}"/mhz/mhz.c
		if [ $? -ne 0 ]; then
			# rebuild mhz due to https://github.com/wtarreau/mhz/commit/6620e45f41429afe577aa3bb80614ac3934afd82
			echo -e "\x08\x08\x08, mhz...\c"
			cd "${InstallLocation}/mhz" || exit 1
			git pull >/dev/null 2>&1
			make >/dev/null 2>&1
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
				echo -e "System health while heating up the SoC:\n" >>"${MonitorLog}"
				/bin/bash "${PathToMe}" -m 10 >>"${MonitorLog}" &
				MonitoringPID=$!
				"${InstallLocation}"/cpuminer-multi/cpuminer --benchmark --cpu-priority=2 >/dev/null &
				MinerPID=$!
				while [ ${SocTemp} -le ${TargetTemp} ]; do
					echo "Heating SoC from current ${SocTemp}°C to ${TargetTemp}°C. This may take some time..."
					printf "\x1b[1A"
					snore 2
					SocTemp=$(ReadSoCTemp | cut -f1 -d'.')
				done
				echo -e "Heating SoC from current ${TargetTemp}°C to ${TargetTemp}°C. This may take some time...\c"
				kill ${MinerPID} ${MonitoringPID}
			else
				echo -e "Skipping heating up the SoC since already at ${SocTemp}°C\n" >>"${MonitorLog}"
				echo -e "No need to heat the SoC to ${TargetTemp}°C since already at ${SocTemp}°C...\c"
			fi
			;;
		t)
			if [ ${SocTemp} -gt ${TargetTemp} ]; then
				echo -e "System health while waiting for the SoC to cool down:\n" >>"${MonitorLog}"
				/bin/bash "${PathToMe}" -m 10 >>"${MonitorLog}" &
				MonitoringPID=$!
				while [ ${SocTemp} -gt ${TargetTemp} ]; do
					echo "Waiting for the SoC cooling down from current ${SocTemp}°C to ${TargetTemp}°C. This may take some time..."
					printf "\x1b[1A"
					snore 2
					SocTemp=$(ReadSoCTemp | cut -f1 -d'.')
				done
				echo -e "Waiting for the SoC cooling down from current ${SocTemp}°C to ${TargetTemp}°C. This may take some time...\c"
				kill ${MonitoringPID}
			else
				echo -e "No need to wait for the SoC chilling since already at ${SocTemp}°C\n" >>"${MonitorLog}"
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
	echo -e "\n##########################################################################\n" >>"${ResultLog}"
	cat "${MonitorLog}" >>"${ResultLog}"
	[ -f "${TempDir}/throttling_info.txt" ] && cat "${TempDir}/throttling_info.txt" >>"${ResultLog}"

	cat "${ResultLog}"
} # TempTest

ReadSoCTemp() {
	if [ -h "${TempSource}" ]; then
		read RawTemp <"${TempSource}"
		if [ ${RawTemp:-0} -ge 1000 ]; then
			RawTemp=$(awk '{printf ("%0.1f",$1/1000); }' <<<${RawTemp})
		fi
		echo -e ${RawTemp}
	fi
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

CheckOSRelease() {
	# check OS
	OperatingSystem="$(GetOSRelease)"

	# Display warning when not executed on recent Debian, Fedora, Ubuntu or Rocky Linux distros
	case ${OperatingSystem,,} in
		*buster*|*bullseye*|*bookworm*|*focal*|*jammy*|*mantic*|*noble*|*thirty*|"fedora linux 3"[8-9]*|"rocky linux 9"*)
			:
			;;
		*)
			# only inform/ask user if $MODE != unattended
			if [ "X${MODE}" != "Xunattended" ]; then
				if [ "${1}" = "ForReview" ]; then
					echo -e "${LRED}${BOLD}WARNING: This tool is meant to assist with device reviews but ${OperatingSystem} seems a bit too old for this.${NC}\n"
					echo -e "Press [ctrl]-[c] to stop or ${BOLD}[enter]${NC} to continue.\c"
					read
				else
					echo -e "${LRED}${BOLD}WARNING: This tool is meant to run only on recent Debian, Fedora, Ubuntu or Rocky Linux distros.${NC}\n"
					echo -e "When executed on ${BOLD}${OperatingSystem}${NC} results might be partially meaningless.\nPlease see https://github.com/ThomasKaiser/sbc-bench/issues/81 for reasons.\n\nPress [ctrl]-[c] to stop or ${BOLD}[enter]${NC} to continue.\c"
					read
				fi
			fi
			;;
	esac
} # CheckOSRelease

GetOSRelease() {
	# try to get human friendly OS release name
	[ "X${UBUNTU_CODENAME}" = "X" ] || UbuntuSuffix=" (${UBUNTU_CODENAME})"
	OS="$(hostnamectl 2>/dev/null | awk -F": " '/Operating System:/ {print $2}')"
	if [ "X${OS}" = "X" ] && [ "X${PRETTY_NAME}" != "X" ]; then
		OS="${PRETTY_NAME}"
	fi
	case "${OS}" in
		Armbian*|"Orange Pi"*)
			# After replacing Canonical's advertising behaviour with own advertisings
			# (https://github.com/armbian/build/pull/4303) the distro clowns over at 
			# Armbian now even start to manipulate base files of the operating systems
			# their images base on most probably to fool their users into believing Armbian
			# would be an operating system just like Debian or Ubuntu instead of just a
			# build system. They simply overwrite the PRETTY_NAME definition in Debian's
			# and Ubuntu's /etc/os-release file with some nonsense that will break certain
			# 3rd party installation routines and confuse users. But that's what you get
			# when a project is driven by 'ignorance and stupidity'. The fix to restore
			# the distro's base-files package doesn't work any more since Armbian hobbyists
			# once again replace distro packages with their own.
			grep -q "${UBUNTU_CODENAME:-sucks}" <<<"${OS}" && echo "Ubuntu ${VERSION} tampered by ${OS}" || echo "Debian ${VERSION} tampered by ${OS}"
			;;
		"")
			echo "n/a"
			;;
		*)
			grep -q -i Gentoo <<<"${OS}" && read OS </etc/gentoo-release
			echo "${OS}${UbuntuSuffix}"
			;;
	esac
} # GetOSRelease

CreateTempDir() {
	# Create directory for temporary files
	TempDir="$(mktemp -d /tmp/${0##*/}.XXXXXX)"
	if [ ! -d "${TempDir}" ]; then
		echo "Can not create temporary files below ${TempDir}. Aborting." >&2
		exit 1
	fi
	export TempDir

	# Create temporary files
	TempLog="${TempDir}/temp.log"
	ResultLog="${TempDir}/results.log"
	MonitorLog="${TempDir}/monitor.log"
	touch "${TempLog}" "${ResultLog}" "${MonitorLog}"

	# delete $TempDir by default but not if in extensive mode:
	[ "X${MODE}" = "Xextensive" ] || trap 'rm -rf "${TempDir}" ; exit 0' 0
} # CreateTempDir

CheckLoadAndDmesg() {
	# Check if kernel ring buffer contains boot messages. These help identifying HW.
	DMESG="$(dmesg | grep -E "Linux|pvtm|rockchip-dmc|rockchip-cpuinfo|Amlogic Meson|sun50i|pcie|mmc|leakage")"
	grep -q -E '] Booting Linux|] Linux version ' <<<"${DMESG}"
	case $? in
		1)
			grep -q "sunxi" <<<"${DMESG}"
			IsAllwinner=$?
			grep -q -E "AuthenticAMD|GenuineIntel" <<<"${ProcCPU}"
			IsX86=$?
			if [ "X${MODE}" != "Xunattended" ] && [ ${IsAllwinner} -ne 0 ] && [ ${IsX86} -ne 0 ]; then
				# print warning on other platforms than Allwinner/x86 and if MODE != unattended
				echo -e "${LRED}${BOLD}WARNING: dmesg output does not contain early boot messages which\nhelp in identifying hardware details.${NC}\n"
				echo -e "It is recommended to reboot now and then execute the benchmarks.\nPress ${BOLD}[ctrl]-[c]${NC} to stop or ${BOLD}[enter]${NC} to continue.\c"
				read
			fi
			;;
	esac

	# check for CPU cores being offline
	[ -z "${LSCPU}" ] && LSCPU="$(lscpu)"
	OfflineCores=$(awk -F" " '/^Off-line CPU/ {print $4}' <<<"${LSCPU}")
	if [ "X${OfflineCores}" != "X" ] && [ "X${MODE}" != "Xunattended" ]; then
		echo -e "${LRED}${BOLD}WARNING: One or more CPU cores are offline: ${OfflineCores}${NC}\n"
		echo -e "Press ${BOLD}[ctrl]-[c]${NC} to stop or ${BOLD}[enter]${NC} to continue.\c"
		read
	fi

	# skip whole load check on systems with more than 63 cores.
	CPUCores=$(awk -F" " '/^CPU...:/ {print $2}' <<<"${LSCPU}")
	[ ${CPUCores} -gt 63 ] && return

	# Only continue if average load is less than 0.1 or averaged CPU utilization is lower
	# than 2.5% for 30 sec. Please note that average load on Linux is *not* the same as CPU
	# utilization: https://www.brendangregg.com/blog/2017-08-08/linux-load-averages.html

	# switch to performance cpufreq governor in standard operation modes since this helps
	# lowering load and CPU utilization in less time
	if [ -d /sys/devices/system/cpu/cpufreq/policy0 ] && [ "X${NOTUNING}" != "Xyes" ]; then
		for Cluster in /sys/devices/system/cpu/cpufreq/policy? ; do
			[[ -e "${Cluster}" ]] || break
			[ -w ${Cluster}/scaling_governor ] && echo performance >${Cluster}/scaling_governor 2>/dev/null
		done
	fi

	AvgLoad1Min=$(awk -F" " '{print $1*100}' < /proc/loadavg)
	if [ $AvgLoad1Min -ge 10 ]; then
		echo -e "\nAverage load and/or CPU utilization too high (too much background activity). Waiting...\n"
		/bin/bash "${PathToMe}" -m 5 >"${TempDir}/wait-for-loadavg.log" &
		MonitoringPID=$!
		while [ $AvgLoad1Min -ge 10 ] && [ ${CPUSum:-100} -ge 10 ]; do
			snore 5
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
} # CheckLoadAndDmesg

GetRelevantCPUClusters() {
	# If all CPU cores are of same type then just check for NUMA nodes and ignore
	# cpufreq settings or package IDs (server SoCs like Ampere Altra or NXP LX2160A
	# show rather weird package IDs, see http://ix.io/4kiu or http://ix.io/4uaA)
	# Try to handle special case of crappy S912 SoC consisting of 8 identical A53
	# cores of which 4 are crippled (1 GHz vs. 1.4 GHz while the SoC's boot BLOB
	# fakes 1.5 GHz for the latter)
	# Also try to cope with big.LITTLE/DynamIQ SoC bring-up situations where cpufreq
	# isn't working yet while all cores share same ID, see http://ix.io/4Bc8 for example.

	local ClustersByCpufreqOrPackageIDs=($(GetCPUClusters))

	if [ ${#ClusterConfigByCoreType[@]} -eq 1 ] && [ ${#ClustersByCpufreqOrPackageIDs[@]} -ne 2 ]; then
		NumaNodes=$(awk -F" " '/^NUMA node[0-9]/ {print $4}' <<<"${LSCPU}" | cut -f1 -d'-' | cut -f1 -d',')
		[ "X${NumaNodes}" = "X" ] && echo 0 || echo "${NumaNodes}"
	elif [ ${#ClustersByCpufreqOrPackageIDs[@]} -lt ${#ClusterConfigByCoreType[@]} ] ; then
		# SoC bring-up stage, different CPU clusters are not properly defined
		echo "${ClusterConfigByCoreType[@]}"
	else
		echo "${ClustersByCpufreqOrPackageIDs[@]}"
	fi
} # GetRelevantCPUClusters

GetCPUClusters() {
	# try to report different CPU clusters. Cores of same type might be handled differently.
	# For example on RK3588 with 4 x A55 and 4 x A76 the latter are two clusters behaving
	# differently wrt clockspeeds due to PVTM (see below at GetCoreClusters function
	# that reports all cores of same type as single cluster)
	if [ "X${VirtWhat}" != "X" ] && [ "X${VirtWhat}" != "Xnone" ]; then
		# in virtualized environments we only check cpu0
		echo "0"
	else
		case ${CPUArchitecture} in
			aarch*|arm*)
				if [ -d /sys/devices/system/cpu/cpufreq/policy0 ]; then
					ls -ld /sys/devices/system/cpu/cpufreq/policy? | awk -F"policy" '{print $2}'
				else
					# check for different CPU types based on package ids. This allows to test through
					# different cores even on systems with no cpufreq support.
					for PKG_ID in $(cat /sys/devices/system/cpu/cpu*/topology/physical_package_id | sort | uniq); do
						dirname -- $(dirname -- $(grep "^${PKG_ID}$" /sys/devices/system/cpu/cpu*/topology/physical_package_id | head -n1)) | tr -d -c '[:digit:]'
						echo " "
					done
				fi
				;;
			x86_64)
				Getx86ClusterDetails
				;;
			*)
				# check for different package ids and use if existent otherwise treat all
				# CPU cores as identical
				if [ -f /sys/devices/system/cpu/cpu0/topology/physical_package_id ]; then
					CountOfPackageIDs=$(sort /sys/devices/system/cpu/cpu*/topology/physical_package_id | uniq | wc -l)
					if [ ${CountOfPackageIDs} -gt 1 ]; then
						for PKG_ID in $(cat /sys/devices/system/cpu/cpu*/topology/physical_package_id | sort | uniq); do
							dirname -- $(dirname -- $(grep "^${PKG_ID}$" /sys/devices/system/cpu/cpu*/topology/physical_package_id | head -n1)) | tr -d -c '[:digit:]'
							echo " "
						done
					else
						echo "0"
					fi
				else
					echo "0"
				fi
				;;
		esac
	fi
} # GetCPUClusters

GetCoreClusters() {
	# function to determine clusters by CPU core type used by MODE=extensive
	# and Geekbench mode
	#
	# With x86 we rely on name based cluster detection while on ARM and other
	# platforms we 'bundle' CPU core types by occurence:
	#
	# Amlogic S912 for example contains 2 quad-core A53 clusters with different
	# cpufreq scaling properties but it's just 8 boring A53 and no big.LITTLE
	# so there's no reason to treat S912 as '2 clusters CPU'.
	#
	# RK3588 for example consists of 4 x A55 cores and 4 x A76 but the latter
	# are handled as two different clusters sharing same properties except
	# clockspeed and throttling differences for a reason called PVTM:
	# https://github.com/ThomasKaiser/Knowledge/blob/master/articles/Quick_Preview_of_ROCK_5B.md#pvtm

	if [ "${CPUArchitecture}" = "x86_64" ]; then
		Getx86ClusterDetails
	else
		local i
		for i in $(seq 0 $(( ${CPUCores} - 1 )) ) ; do
			ThisCore="$(GetCPUInfo $i)"
			if [ "X${ThisCore}" != "X${LastCore}" ]; then
				echo "${i}"
				LastCore="${ThisCore}"
			fi
		done
	fi
} # GetCoreClusters

Getx86ClusterDetails() {
	# Since they can't be differentiated by either CPU ID or physical_package_id get
	# Alder/Raptor/Meteor Lake E/P core clusters from ark.intel.com. HFI might be an option
	# in the future but only with most recent kernels: https://docs.kernel.org/x86/intel-hfi.html
	# Fortunately cache sizes do differ between E/P cores and with ACPI correctly set up
	# /sys/devices/system/cpu/cpu*/acpi_cppc/nominal_perf should differ as well. The SKU
	# differentiation of these hybrid CPU models follow this scheme:
	# https://gist.github.com/ThomasKaiser/91ce41d44da14b577b3681bd09075a03

	# Check amount of available CPU cores first and whether virtualization has been detected
	# since when running in a virtualized environment it doesn't make sense trying to
	# distinguish between efficiency and performance cores

	if [ ${CPUCores} -eq 1 ] || [ "X${VirtWhat}" != "Xnone" ]; then
		echo "0"
		return
	fi

	# Check for hyper threading first since affecting size of P logical cluster (the 1st)
	[ -f /sys/devices/system/cpu/smt/active ] && read HT </sys/devices/system/cpu/smt/active || HT=0

	case ${X86CPUName} in
		i3-L13G4|i5-L16G7)
			# Lakefield: 1 P-core w/o HT + 4 E-cores
			echo "Tremont" >"${TempDir}/Ecores"
			echo "Sunny Cove" >"${TempDir}/Pcores"
			[ ${HT} -eq 1 ] && echo "0 2" || echo "0 1"
			;;
		i9-13900K|i9-13900KF|i9-13900F|i9-13900T|i9-13900KS|i9-13900HX|i9-13950HX|i9-13980HX|i9-13900|i9-13900TE|i9-13900E|i9-14900K|i9-14900KF|i9-14900|i9-14900HX|i9-14900T|i9-14900F)
			# Raptor Lake, 8/16 cores, 32 threads
			echo "Gracemont" >"${TempDir}/Ecores"
			echo "Raptor Cove" >"${TempDir}/Pcores"
			[ ${HT} -eq 1 ] && echo "0 16" || echo "0 8"
			;;
		i7-13850HX|i7-14700K|i7-14700KF|i7-14700|i7-14700F|i7-14700HX|i7-14700T)
			# Raptor Lake, 8/12 cores, 28 threads
			echo "Gracemont" >"${TempDir}/Ecores"
			echo "Raptor Cove" >"${TempDir}/Pcores"
			[ ${HT} -eq 1 ] && echo "0 16" || echo "0 8"
			;;
		i9-12900T|i9-12900TE|i9-12900HX|i9-12950HX|i9-12900KS|i9-12900E|i9-12900F|i9-12900|i9-12900K|i9-12900KF|i7-12850HX|i7-12800HX)
			# Alder Lake, 8/8 cores, 24 threads
			echo "Gracemont" >"${TempDir}/Ecores"
			echo "Golden Cove" >"${TempDir}/Pcores"
			[ ${HT} -eq 1 ] && echo "0 16" || echo "0 8"
			;;
		i7-13700K|i7-13700KF|i7-13700F|i7-13700T|i7-13700HX|i7-13700E|i7-13700|i7-13700TE|i7-14650HX)
			# Raptor Lake, 8/8 cores, 24 threads
			echo "Gracemont" >"${TempDir}/Ecores"
			echo "Raptor Cove" >"${TempDir}/Pcores"
			[ ${HT} -eq 1 ] && echo "0 16" || echo "0 8"
			;;
		i7-12700|i7-12700F|i7-12700E|i7-12700TE|i7-12700T|i7-12700K|i7-12700KF)
			# Alder Lake, 8/4 cores, 20 threads
			echo "Gracemont" >"${TempDir}/Ecores"
			echo "Golden Cove" >"${TempDir}/Pcores"
			[ ${HT} -eq 1 ] && echo "0 16" || echo "0 8"
			;;
		i9-12900HK|i9-12900H|i7-12700HL|i7-12800HL|i7-12650HX|i7-1280P|i7-12700H|i7-12800H|i7-12800HE)
			# Alder Lake, 6/8 cores, 20 threads
			echo "Gracemont" >"${TempDir}/Ecores"
			echo "Golden Cove" >"${TempDir}/Pcores"
			[ ${HT} -eq 1 ] && echo "0 12" || echo "0 6"
			;;
		i9-13900HK|i7-13700H|i5-13600K|i5-13600KF|i5-13500|i9-13905H|i9-13900H|i7-13800H|i7-1370P|i7-13705H|i7-13650HX|i5-13500HX|i5-13600HX|i7-1370PE|i7-13800HE|i5-13500T|i5-13500E|i5-13500TE|i5-13600|i5-13600T|i5-14600K|i5-14600KF|i5-14500|i5-14500HX|i5-14600|i7-1370PRE|i7-1375PRE|i7-13800HRE|i5-14600T|i5-14500T)
			# Raptor Lake, 6/8 cores, 20 threads
			echo "Gracemont" >"${TempDir}/Ecores"
			echo "Raptor Cove" >"${TempDir}/Pcores"
			[ ${HT} -eq 1 ] && echo "0 12" || echo "0 6"
			;;
		i7-1270PE|i7-1270P|i7-1260P|i5-12600HL|i5-12500HL|i5-12600HX|i5-1250PE|i5-1250P|i5-1240P|i5-12600HE|i5-12500H|i5-12600H)
			# Alder Lake, 4/8 cores, 16 threads
			echo "Gracemont" >"${TempDir}/Ecores"
			echo "Golden Cove" >"${TempDir}/Pcores"
			[ ${HT} -eq 1 ] && echo "0 8" || echo "0 4"
			;;
		i7-1360P|i5-13500H|i5-13600H|i5-1340P|i5-13505H|i5-1350P|i5-1340PE|i5-13600HE|i5-1350PE|i5-1350PRE|i5-13600HRE)
			# Raptor Lake, 4/8 cores, 16 threads
			echo "Gracemont" >"${TempDir}/Ecores"
			echo "Raptor Cove" >"${TempDir}/Pcores"
			[ ${HT} -eq 1 ] && echo "0 8" || echo "0 4"
			;;
		i7-1265UL|i7-1255UL|i7-1265UE|i7-1260U|i7-1250U|i7-1255U|i7-1265U|i5-1245UL|i5-1235UL|i5-1245UE|i5-1230U|i5-1240U|i5-1235U|i5-1245U|i3-1220P)
			# Alder Lake, 2/8 cores, 12 threads
			echo "Gracemont" >"${TempDir}/Ecores"
			echo "Golden Cove" >"${TempDir}/Pcores"
			[ ${HT} -eq 1 ] && echo "0 4" || echo "0 2"
			;;
		i7-1355U|i7-1365U|i5-1335U|i5-1334U|i5-1345U|i7-1365UE|i5-1335UE|i5-1345UE|"5 120U"*|"7 150U"*)
			# Raptor Lake, 2/8 cores, 12 threads
			echo "Gracemont" >"${TempDir}/Ecores"
			echo "Raptor Cove" >"${TempDir}/Pcores"
			[ ${HT} -eq 1 ] && echo "0 4" || echo "0 2"
			;;
		i7-12650H|i5-12600K|i5-12600KF)
			# Alder Lake, 6/4 cores, 16 threads
			echo "Gracemont" >"${TempDir}/Ecores"
			echo "Golden Cove" >"${TempDir}/Pcores"
			[ ${HT} -eq 1 ] && echo "0 12" || echo "0 6"
			;;
		i5-13400|i5-13400F|i7-13620H|i5-13450HX|i5-13400E|i5-13400T|i5-14400|i5-14400F|i5-14450HX|i5-14400T)
			# Raptor Lake, 6/4 cores, 16 threads
			echo "Gracemont" >"${TempDir}/Ecores"
			echo "Raptor Cove" >"${TempDir}/Pcores"
			[ ${HT} -eq 1 ] && echo "0 12" || echo "0 6"
			;;
		*"Ultra 7 155H"*|*"Ultra 7 165H"*|*"Ultra 7 1002H"*|*"Ultra 9 185H"*)
			# Meteor Lake, 6/8/2 cores, 22 threads
			echo "Crestmont" >"${TempDir}/Ecores"
			echo "Redwood Cove" >"${TempDir}/Pcores"
			[ ${HT} -eq 1 ] && echo "0 12 20" || echo "0 6 14"
			;;
		i5-12450HX|i5-12450H|i3-12300HL|i3-1220PE|i3-12300HE)
			# Alder Lake, 4/4 cores, 12 threads
			echo "Gracemont" >"${TempDir}/Ecores"
			echo "Golden Cove" >"${TempDir}/Pcores"
			[ ${HT} -eq 1 ] && echo "0 8" || echo "0 4"
			;;
		i5-13420H|i3-1320PE|i3-13300HE|i3-1320PRE|i3-13300HRE)
			# Raptor Lake, 4/4 cores, 12 threads
			echo "Gracemont" >"${TempDir}/Ecores"
			echo "Raptor Cove" >"${TempDir}/Pcores"
			[ ${HT} -eq 1 ] && echo "0 8" || echo "0 4"
			;;
		*"Ultra 5 125H"*|*"Ultra 5 135H"*)
			# Meteor Lake, 4/8/2 cores, 18 threads
			echo "Crestmont" >"${TempDir}/Ecores"
			echo "Redwood Cove" >"${TempDir}/Pcores"
			[ ${HT} -eq 1 ] && echo "0 8 16" || echo "0 4 12"
			;;
		i3-1215UL|i3-1215UE|i3-1210U|i3-1215U)
			# Alder Lake, 2/4 cores, 8 threads
			echo "Gracemont" >"${TempDir}/Ecores"
			echo "Golden Cove" >"${TempDir}/Pcores"
			[ ${HT} -eq 1 ] && echo "0 4" || echo "0 2"
			;;
		i3-1315U|i3-1315UE|i3-1315URE|"3 100U"*)
			# Raptor Lake, 2/4 cores, 8 threads
			echo "Gracemont" >"${TempDir}/Ecores"
			echo "Raptor Cove" >"${TempDir}/Pcores"
			[ ${HT} -eq 1 ] && echo "0 4" || echo "0 2"
			;;
		i5-1345URE|i7-1365URE|i7-1366URE)
			# Raptor Lake, 2/8 cores, 12 threads
			echo "Gracemont" >"${TempDir}/Ecores"
			echo "Raptor Cove" >"${TempDir}/Pcores"
			[ ${HT} -eq 1 ] && echo "0 4" || echo "0 2"
			;;
		*"Ultra 5 125U"*|*"Ultra 5 134U"*|*"Ultra 5 135U"*|*"Ultra 7 155U"*|*"Ultra 7 164U"*|*"Ultra 7 165U"*)
			# Meteor Lake, 2/8/2 cores, 14 threads
			echo "Crestmont" >"${TempDir}/Ecores"
			echo "Redwood Cove" >"${TempDir}/Pcores"
			[ ${HT} -eq 1 ] && echo "0 4 12" || echo "0 2 10"
			;;
		*Gold*850*|*Celeron*730*)
			# Alder Lake, 1/4 cores, 6 threads
			echo "Gracemont" >"${TempDir}/Ecores"
			echo "Golden Cove" >"${TempDir}/Pcores"
			[ ${HT} -eq 1 ] && echo "0 2" || echo "0 1"
			;;
		i3-1305U|U300|U300E)
			# Raptor Lake, 1/4 cores, 6 threads
			echo "Gracemont" >"${TempDir}/Ecores"
			echo "Raptor Cove" >"${TempDir}/Pcores"
			[ ${HT} -eq 1 ] && echo "0 2" || echo "0 1"
			;;
		13100|13100E|13100F|13100T|13100TE|14100|14100F|14100T)
			# Raptor Lake, 4/0 cores, 8 threads
			echo "0"
			;;
		*)
			# unknown CPU, try to check cache sizes since at least on currently known Intel
			# CPUs efficiency and performance cores have differing cache sizes.
			echo "Efficiency" >"${TempDir}/Ecores"
			echo "Performance" >"${TempDir}/Pcores"
			if [ -d /sys/devices/system/cpu/cpu0/cache ] ; then
				local i
				for i in $(seq 0 $(( ${CPUCores} - 1 )) ) ; do
					ThisCache="$(find /sys/devices/system/cpu/cpu${i}/cache -name size 2>/dev/null | sort -V | while read ; do echo -n "$(cat "${REPLY}")" ; done)"
					if [ "X${ThisCache}" != "X${LastCache}" ]; then
						echo "${i}"
						LastCache="${ThisCache}"
					fi
				done
			else
				echo "0"
			fi
		;;
	esac
} # Getx86ClusterDetails

ParseOPPTables() {
	# TODO: parse/process opp-peak-kBps values
	[ -d /sys/firmware/devicetree/base ] && DVFS="$(for OPPTable in /sys/firmware/devicetree/base/*opp* ; do grep -q -E -- "opp-|opp_|-table|_table" <<<"${OPPTable}" && echo "${OPPTable}"; done | sort -n)"
	if [ "X${DVFS}" = "X" ]; then
		return
	fi
	echo -e "\n##########################################################################"

	# report I2C accessible microvolt readings first
	Measurements="$(find /sys/devices/platform -name microvolts 2>/dev/null | grep -i i2c)"
	if [ "X${Measurements}" != "X" ]; then
		echo ""
		echo "${Measurements}" | while read ; do
			if [ -f "${REPLY%/*}/name" ]; then
				read NodeName <"${REPLY%/*}/name"
				case ${NodeName} in
					*cpu*|*gpu*|*center*|*npu*|*ddr*|*dmc*)
						# try to report only performance relevant supply voltage readings
						MicroVolts=$(awk '{printf ("%0.0f",$1/1000); }' <"${REPLY}")
						if [ -f "${REPLY%/*}/max_microvolts" ]; then
							MaxMicroVolts=$(awk '{printf ("%0.0f",$1/1000); }' <"${REPLY%/*}/max_microvolts")
							echo -e "   ${NodeName}: ${MicroVolts} mV (${MaxMicroVolts} mV max)"
						else
							echo -e "   ${NodeName}: ${MicroVolts} mV"
						fi
					;;
				esac
			fi
		done | sort -n
	fi

	for OPPTable in ${DVFS}; do
		read OPPTableName <"${OPPTable}/name"
		echo -e "\n   ${OPPTableName}:"
		find "${OPPTable}" -type d -name "opp*" 2>/dev/null | grep "${OPPTableName}/" | sort | while read ; do
			[ -f "${REPLY}/opp-hz" ] && OPPHz="$(printf "%d\n" 0x$(od --endian=big -x <"${REPLY}/opp-hz" | cut -c9- | tr -d ' ') | awk '{printf ("%0.0f",$1/1000000); }')" || OPPHz=""
			if [ -f "${REPLY}/opp-microvolt" ]; then
				OPPVolt="$(printf "%d\n" 0x$(od --endian=big -x <"${REPLY}/opp-microvolt" | cut -c9- | tr -d ' ' | cut -c-8 | head -n1))"
				if [ -f "${REPLY}/opp-supported-hw" ]; then
					OPPSupportedHW="$(od --endian=big -x <"${REPLY}/opp-supported-hw" | cut -c9- | sed 's/0000 //g' | head -n1)"
					[ "X${OPPHz}" != "X" ] && printf "%10s MHz %8s mV (%s)\n" ${OPPHz} $(awk '{printf ("%0.1f",$1/1000); }' <<<"${OPPVolt}") "${OPPSupportedHW}"
				else
					[ "X${OPPHz}" != "X" ] && printf "%10s MHz %8s mV\n" ${OPPHz} $(awk '{printf ("%0.1f",$1/1000); }' <<<"${OPPVolt}")
				fi
			elif [ -f "${REPLY}/opp-microvolt-speed0" ]; then
				printf "%10s MHz " ${OPPHz}
				for SpeedBin in $(ls "${REPLY}"/opp-microvolt-speed* | sort -n) ; do
					OPPVolt="$(printf "%d\n" 0x$(od --endian=big -x <"${SpeedBin}" | cut -c9- | tr -d ' ' | cut -c-8 | head -n1))"
					[ "X${OPPHz}" != "X" ] && printf "%8s mV" $(awk '{printf ("%0.1f",$1/1000); }' <<<"${OPPVolt}")
				done
				echo ""
			else
				printf "%10s MHz       -\n" ${OPPHz}
			fi
		done | sort -n
	done
} # ParseOPPTables

ParseRawOPPTables() {
	DVFS="$(for OPPTable in /sys/firmware/devicetree/base/*opp* ; do grep -q -E -- "opp-|opp_|-table|_table" <<<"${OPPTable}" && echo "${OPPTable}"; done | sort -n)"
	if [ "X${DVFS}" = "X" ]; then
		return
	fi
	echo -e "\n##########################################################################"
	for OPPTable in ${DVFS}; do
		ls -laR "${OPPTable}"
		echo ""
		find "${OPPTable}" -type f 2>/dev/null | while read file ; do
			echo -e "${file}\t$(od --endian=big -x <"${file}" | cut -c9- | tr -d ' ')"
		done
	done
} # ParseRawOPPTables

BasicSetup() {
	# set cpufreq governor based on $1 (defaults to ondemand if not provided)
	if [ "$1" != "nochange" ]; then
		if [ -d /sys/devices/system/cpu/cpufreq/policy0 ]; then
			for Cluster in /sys/devices/system/cpu/cpufreq/policy? ; do
				[[ -e "${Cluster}" ]] || break
				[ -w ${Cluster}/scaling_governor ] && echo ${1:-ondemand} >${Cluster}/scaling_governor 2>/dev/null
			done
		fi
	fi

	# detect environment
	LSCPU="$(lscpu)"
	CPUArchitecture="$(awk -F" " '/^Architecture/ {print $2}' <<<"${LSCPU}")"
	X86CPUName="$(sed 's/ \{1,\}/ /g' <<<"${LSCPU}" | awk -F": " '/^Model name/ {print $2}' | sed -e 's/1.th Gen //' -e 's/.th Gen //' -e 's/Core(TM) //' -e 's/ Processor//' -e 's/Intel(R) Xeon(R) CPU //' -e 's/Intel(R) //' -e 's/(R)//' -e 's/CPU //' -e 's/ 0 @/ @/' -e 's/AMD //' -e 's/Authentic //' -e 's/ with .*//')"
	VirtWhat="$(systemd-detect-virt 2>/dev/null)"
	RK_NVMEM_FILE="$(find /sys/bus/nvmem/devices/rockchip*/* -name nvmem 2>/dev/null | head -n1)"
	[ -r "${RK_NVMEM_FILE}" ] && RK_NVMEM="$(hexdump -C <"${RK_NVMEM_FILE}" 2>/dev/null | grep -E "52 4b |52 56 " | head -n1)"
	AW_NVMEM_FILE="/sys/bus/nvmem/devices/sunxi-sid0/nvmem"
	[ -r "${AW_NVMEM_FILE}" ] && AW_NVMEM="$(hexdump -C <"${AW_NVMEM_FILE}" 2>/dev/null | head -n1)"
	CPUFetchInfo="$(GrabCPUFetchInfo)"
	[[ ${CPUFetchInfo} != *Unknown* ]] && CPUFetchGuess="$(awk -F": " '/SoC:/ {print $2}' <<<"${CPUFetchInfo}" | sed "s/^[ \t]*//")"
	CPUCores=$(awk -F" " '/^CPU...:/ {print $2}' <<<"${LSCPU}")
	# Might not work with RISC-V on old kernels, see
	# https://github.com/ThomasKaiser/sbc-bench/issues/46
	[ ${CPUCores} -eq 0 ] && CPUCores=$(grep -c '^hart' <<< "${ProcCPU}")

	# try to bring CPU cores back online that were sent offline when idle
	for i in $(seq 0 $(( ${CPUCores} - 1 )) ); do
		taskset -c ${i} echo "" >/dev/null 2>&1
	done

	# try to derive DeviceName from device-tree if available
	if [ -f /proc/device-tree/model ]; then
		read DeviceName </proc/device-tree/model
	elif [ -f /sys/class/dmi/id/sys_vendor ]; then
		# read DMI data
		DMIInfo="$(grep -R . /sys/class/dmi/id/ 2>/dev/null)"
		DMISysVendor="$(awk -F":" '/sys_vendor:/ {print $2}' <<<"${DMIInfo}" | grep -E -v "O.E.M.|System manufacturer|Default|default|Not ")"
		DMIProductName="$(awk -F":" '/product_name:/ {print $2}' <<<"${DMIInfo}" | grep -E -v "O.E.M.|Product Name|Default|default|Not ")"
		DMIProductVersion="$(awk -F":" '/product_version:/ {print $2}' <<<"${DMIInfo}" | grep -E -v "O.E.M.|123456789|Not |Default|System Product Name|System Version")"

		# Define DeviceName in virtualized environments based on hypervisor info
		case ${DMISysVendor} in
			# https://github.com/chef-boneyard/dmidecode_collection
			Amazon*)
				# older systemd versions fail on AWS/arm64: https://github.com/systemd/systemd/issues/18929
				VirtWhat="kvm"
				DeviceName="AWS ${DMIProductName} ${VirtWhat} VM"
				;;
			Hetzner*)
				DeviceName="Hetzner ${X86CPUName} ${VirtWhat} VM"
				;;
			QEMU*)
				DeviceName="${DMIProductName} ${VirtWhat}/QEMU VM"
				;;
			Parallels*)
				DeviceName="Parallels $(awk -F":" '/bios_version:/ {print $2}' <<<"${DMIInfo}") VM"
				;;
			innotek*|Innotek*|Oracle*)
				grep -q "VirtualBox" <<<"${DMIProductName}" && DeviceName="VirtualBox ${X86CPUName} VM"
				;;
			VMware*)
				DeviceName="VMware ${X86CPUName} VM"
				;;
			Alibaba*)
				DeviceName="${DMISysVendor} ${DMIProductName} ${VirtWhat} VM"
				;;
			Xen*)
				DeviceName="Xen ${DMIProductVersion} ${X86CPUName} VM"
				;;
			Microsoft*)
				grep -q "Virtual" <<<"${DMIProductName}" && DeviceName="Hyper-V ${DMIProductVersion} VM"
				;;
			OpenStack*)
				DeviceName="OpenStack ${DMIProductVersion} VM"
				;;
			"Red Hat"*)
				case ${DMIProductName} in
					OpenStack*)
						DeviceName="OpenStack ${DMIProductVersion} VM"
						;;
					"RHEV Hypervisor"*)
						DeviceName="RHEV Hypervisor ${DMIProductVersion} VM"
						;;
				esac
				;;
			RDO*)
				grep -q "OpenStack" <<<"${DMIProductName}" && DeviceName="OpenStack ${DMIProductVersion} VM"
				;;
			Apple*)
				# check whether we're running inside Hypervisor.framework
				if [ "X${DMIProductName}" = "XApple Virtualization Generic Platform" ]; then
					VirtWhat="apple-hypervisor v${DMIProductVersion}"
				fi
				;;
		esac
	fi

	# do some device name cosmetics based on platform / device
	case ${CPUArchitecture} in
		arm*|aarch*|riscv*)
			[ "X${DeviceName}" = "Xsun20iw1p1" ] && DeviceName="Allwinner D1"
			ARMTypes=($(awk -F"0x" '/^CPU implementer|^CPU part/ {print $2}' <<< "${ProcCPU}"))
			ARMStepping=($(awk -F": " '/^CPU variant|^CPU revision/ {print $2}' <<< "${ProcCPU}"))
			case ${DeviceName} in
				"Raspberry Pi 4"*)
					# https://github.com/raspberrypi/linux/issues/3210#issuecomment-680035201
					# get SoC revision based on mmc controller's bus location
					od -An -tx1 /proc/device-tree/emmc2bus/dma-ranges 2>/dev/null | tr -d '[:space:]' | \
						grep -q 'c0000000000000000000000040' && BCM2711="B0" || BCM2711="C0 or later"
					DeviceName="$(sed 's/Raspberry Pi/RPi/' <<<"${DeviceName}") / BCM2711 Rev ${BCM2711}"
					;;
				"nexell soc")
					# FriendlyELEC SBC based on Nexell S5P6818, on Armbian use BOARD_NAME
					if [ -f /etc/armbian-release ]; then
						. /etc/armbian-release
						DeviceName="${BOARD_NAME}"
					fi
					;;
				"FriendlyARM "*)
					# Remove vendor string since outdated anyway
					DeviceName="$(sed 's/FriendlyARM //' <<<"${DeviceName}")"
					;;
			esac
			if [ "${VirtWhat}" = "wsl" ]; then
				# Differentiate between WSL and WSL2 VMs
				uname -r | grep -q WSL2 && DeviceName="${HostName} WSL2 VM" || DeviceName="${HostName} WSL VM"
			elif [ ! -f /proc/device-tree/model ] && [ "X${DMISysVendor}" != "X" ] && [ -z "${DeviceName}" ]; then
				# if there's no device-tree support but DMI info available use this for DeviceName
				DeviceName="${DMISysVendor} ${DMIProductName} ${DMIProductVersion}"
			fi
			;;
		x86*|i686)
			# if no DeviceName is already assigned then try to construct it from DMI data
			if [ -z "${DeviceName}" ]; then
				if [ "${VirtWhat}" = "wsl" ]; then
					uname -r | grep -q WSL2 && DeviceName="${X86CPUName} WSL2 VM" || DeviceName="${X86CPUName} WSL VM"
				elif [ "X${VirtWhat}" = "X" ] || [ "X${VirtWhat}" = "Xnone" ]; then
					# seems bare metal, but we double check
					grep -q -i "Virtual" <<<"${DMIProductName}" && \
						DeviceName="${DMISysVendor} ${DMIProductName} ${DMIProductVersion} VM" || \
						DeviceName="${DMISysVendor} ${DMIProductName} ${DMIProductVersion} / ${X86CPUName}"
				else
					# seems virtualized and not already caught by DMISysVendor case construct
					DeviceName="${DMISysVendor} ${DMIProductName} ${DMIProductVersion} ${VirtWhat} VM"
				fi
			fi
			;;
		mips*|loongarch*)
			# do nothing here and use what /proc/device-tree/model provides
			:
			;;
		*)
			echo "${CPUArchitecture} not supported. Aborting." >&2
			exit 1
			;;
	esac

	ClusterConfigByCoreType=($(GetCoreClusters))
	ClusterConfig=($(GetRelevantCPUClusters))
	if [ -f "${TempDir}/Pcores" ]; then
		read PCores <"${TempDir}/Pcores"
		read ECores <"${TempDir}/Ecores"
	fi
	[ ${#ClusterConfig[@]} -eq 0 ] && ClusterConfig=(0)
} # BasicSetup

CheckMissingPackages() {
	# check for missing packages and construct installation string with list of needed packages
	case ${OperatingSystem,,} in
		"arch linux"*|*manjaro*)
			# Arch/Manjaro
			command -v pacman >/dev/null 2>&1
			if [ $? -eq 0 ]; then
				# Arch/Manjaro: check whether packages need updates and suggest to run a
				# 'pacman -Syu' manually before continuing. Simply installing packages on
				# a highly outdated Arch install ended with all programs refusing to run
				# due to 'error while loading shared libraries: libcrypto.so.1.1: cannot
				# open shared object file: No such file or directory'
				packages="$(pacman -S -u --print-format %n,%v | sort -n)"
				count_of_packages=$(wc -l <<<"${packages}")
				if [ ${count_of_packages:-0} -gt 1 ]; then
					echo -e "\x08Aborting. ${count_of_packages} packages need updates first (or reboot due to updated kernel):\n\n${packages}\n\nPlease run \"pacman -Syu\" before trying again." >&2
					echo "stop"
					return 1
				fi
				if [[ $(pacman -Q linux | cut -d" " -f2) > $(uname -r) ]]; then
					echo -e "\x08Aborting. Kernel version mismatch: $(pacman -Q linux | cut -d" " -f2) installed but $(uname -r | cut -f1 -d"-") running\nPlease reboot before trying again." >&2
					echo "stop"
					return 1
				fi
				echo -e "pacman --noconfirm -Syq \c"
				command -v gcc >/dev/null 2>&1 || echo -e "gcc make base-devel \c"
				command -v sensors >/dev/null 2>&1
				if [ $? -ne 0 ]; then
					# package name seems to have changed so try both variants
					pacman -Si lm_sensors >/dev/null 2>&1 && echo -e "lm_sensors \c"
					pacman -Si lm-sensors >/dev/null 2>&1 && echo -e "lm-sensors \c"
				fi
			else
				echo -e "echo \c"
			fi	
			;;
		*fedora*)
			command -v dnf >/dev/null 2>&1
			if [ $? -eq 0 ]; then
				# Fedora
				packages="$(dnf check-update 2>/dev/null | grep "[0-9]\.")"
				count_of_packages=$(wc -l <<<"${packages}")
				if [ ${count_of_packages:-0} -gt 1 ]; then
					echo -e "\x08Aborting. ${count_of_packages} packages need updates first (or reboot due to updated kernel):\n\n${packages}\n\nPlease run \"dnf update -y\" before trying again." >&2
					echo "stop"
					return 1
				fi
				echo -e "dnf install -q -y \c"
				command -v gcc >/dev/null 2>&1 || dnf group install -y -q "C Development Tools and Libraries" >/dev/null 2>"${TempDir}/packages.log"
				command -v sensors >/dev/null 2>&1 || echo -e "lm_sensors \c"
				command -v lsb_release >/dev/null 2>&1 || echo -e "redhat-lsb-core \c"
			else
				echo -e "echo \c"
			fi
			;;
		*"rocky linux"*)
			command -v dnf >/dev/null 2>&1
			if [ $? -eq 0 ]; then
				# Rocky Linux
				packages="$(dnf check-update 2>/dev/null | grep "[0-9]\.")"
				count_of_packages=$(wc -l <<<"${packages}")
				if [ ${count_of_packages:-0} -gt 1 ]; then
					echo -e "\x08Aborting. ${count_of_packages} packages need updates first (or reboot due to updated kernel):\n\n${packages}\n\nPlease run \"dnf update -y\" before trying again." >&2
					echo "stop"
					return 1
				fi
				# check whether "Extra Packages for Enterprise Linux" repo needs to be activated
				dnf repolist | grep -q ^epel || dnf install -q -y epel-release
				echo -e "dnf install -q -y \c"
				command -v gcc >/dev/null 2>&1 || dnf group install -y -q "Development Tools" >/dev/null 2>"${TempDir}/packages.log"
				command -v sensors >/dev/null 2>&1 || echo -e "lm_sensors \c"
			else
				echo -e "echo \c"
			fi
			;;
		*suse*)
			command -v zypper >/dev/null 2>&1
			if [ $? -eq 0 ]; then
				# Some Suse variant with zypper present
				echo -e "zypper install -y \c"
				command -v gcc >/dev/null 2>&1 || zypper install -y -t pattern devel_basis >/dev/null 2>"${TempDir}/packages.log"
				command -v sensors >/dev/null 2>&1 || echo -e "sensors \c"
			else
				echo -e "echo \c"
			fi
			;;
		*)
			# other distro, let's check for apt
			command -v apt-get >/dev/null 2>&1
			if [ $? -eq 0 ]; then
				# Debian/Ubuntu/Linux Mint
				echo -e "apt-get -f -qq -y install \c"
				for dpkg in gcc make build-essential lm-sensors ; do
					dpkg -s ${dpkg} >/dev/null 2>&1 || echo -e "${dpkg} \c"
				done
				command -v powercap-info >/dev/null 2>&1
				[ $? -ne 0 ] && [ -d /sys/devices/virtual/powercap ] && echo -e "powercap-utils \c"
				# Check for hexdump only on Rockchip and Allwinner platforms where NVMEM is
				# readable. In Debian based distros the tool is part of bsdmainutils package,
				# no idea about other distros.
				if [ -r "${RK_NVMEM_FILE}" ] || [ -r "${AW_NVMEM_FILE}" ]; then
					command -v hexdump >/dev/null 2>&1 || echo -e "bsdmainutils \c"
				fi
			else
				echo -e "echo \c"
			fi
			;;
	esac

	command -v curl >/dev/null 2>&1 || echo -e "curl \c"
	command -v dmidecode >/dev/null 2>&1 || echo -e "dmidecode \c"
	command -v git >/dev/null 2>&1 || echo -e "git \c"
	command -v iostat >/dev/null 2>&1 || echo -e "sysstat \c"
	command -v lshw >/dev/null 2>&1 || echo -e "lshw \c"
	command -v openssl >/dev/null 2>&1 || echo -e "openssl \c"
	command -v uptime >/dev/null 2>&1 || echo -e "procps \c"
	command -v links >/dev/null 2>&1 || echo -e "links \c"
	if [ "${ExecuteStockfish}" = "yes" ]; then
		command -v g++ >/dev/null 2>&1 || echo -e "g++ \c"
	fi
	if [ "X${MODE}" = "Xextensive" ]; then
		command -v decode-dimms >/dev/null 2>&1 || echo -e "i2c-tools \c"
	fi
	if [ "X${REVIEWMODE}" = "Xtrue" ]; then
		command -v lspci >/dev/null 2>&1 || echo -e "pciutils \c"
		command -v lsusb >/dev/null 2>&1 || echo -e "usbutils \c"
		command -v mmc >/dev/null 2>&1
		if [ $? -ne 0 ]; then
			apt-cache show mmc-utils >/dev/null 2>&1 && echo -e "mmc-utils \c"
		fi
		command -v smartctl >/dev/null 2>&1 || echo -e "smartmontools \c"
		command -v udevadm >/dev/null 2>&1 || echo -e "udev \c"
		case ${OperatingSystem,,} in
			"arch linux"*|*manjaro*)
				command -v stress >/dev/null 2>&1 || echo -e "stress \c"
				;;
			*)
				command -v stress-ng >/dev/null 2>&1 || echo -e "stress-ng \c"
				;;
		esac
	fi
} # CheckMissingPackages

CheckPTS() {
	command -v phoronix-test-suite >/dev/null 2>&1
	if [ $? -ne 0 ]; then
		command -v php >/dev/null 2>&1
		if [ $? -eq 0 ]; then
			echo "Neither phoronix-test-suite nor php found in \$PATH."
		else
			echo "No phoronix-test-suite found in \$PATH."
		fi
		echo -e "Please install PTS manually from http://phoronix-test-suite.com/?k=downloads\nThen execute \"phoronix-test-suite batch-setup\"."
		exit 1
	fi
} # CheckPTS

CheckGB() {
	# try to download most recent GB version for the platform and check prerequisits
	TotalMem=$(free | awk -F" " '/^Mem:   / {print $7}' | tail -n1)
	if [ ${TotalMem:-1200000} -lt 1200000 ]; then
		echo -e "\x08\x08 \n${LRED}${BOLD}WARNING: This machine is low on memory. Likely Geekbench will be oom-killed${NC}\n"
		echo -e "Press [ctrl]-[c] to stop or ${BOLD}[enter]${NC} to continue.\c"
		read
	fi

	# get latest version string from blog, new major versions are advertised as e.g.
	# 'Geekbench 6' and not 'Geekbench 6.0' which makes version string guessing a bit
	# tricky
	GBBlogContents="$(links -dump "https://www.geekbench.com/blog/")"
	NewMajorVersion="$(grep "Geekbench [567]$" <<<"${GBBlogContents}" | head -n1 | awk -F" " '{print $2}').0"
	LatestMinorVersion="$(awk -F" " '/ Geekbench [567].[0-9]/ {print $2}' <<<"${GBBlogContents}" | head -n1)"
	GBVersion="$(echo -e "${NewMajorVersion}\n${LatestMinorVersion}" | sort -V | tail -n1)"

	case ${GBVersion} in
		7*)
			echo -e "\x08\x08 No support for Geekbench ${GBVersion} yet. Exiting"
			exit 1
			;;
		5*|6*)
			:
			;;
		*)
			echo -e "\x08\x08 Not able to determine Geekbench version. Exiting"
			exit 1
			;;
	esac

	# check platform since download URLs differ:
	# RISC-V: https://cdn.geekbench.com/Geekbench-5.4.4-LinuxRISCVPreview.tar.gz
	#         404
	# ARM:    https://cdn.geekbench.com/Geekbench-5.4.4-LinuxARMPreview.tar.gz
	#         https://cdn.geekbench.com/Geekbench-6.0.0-LinuxARMPreview.tar.gz
	# x86:    https://cdn.geekbench.com/Geekbench-5.4.4-Linux.tar.gz
	#         https://cdn.geekbench.com/Geekbench-6.0.0-Linux.tar.gz

	ARCH=$(dpkg --print-architecture 2>/dev/null) || \
	ARCH=$(awk -F'"' '/^CARCH/ {print $2}' /etc/makepkg.conf 2>/dev/null) || \
	ARCH="$(uname -m)"

	case $ARCH in
		armhf|armv7l)
			# 32-bit ARM: here the geekbench5 binary fails to launch the ARMv7 binary
			DLSuffix="LinuxARMPreview"
			GBBinaryName="geekbench_armv7"
			FirstOfflineCPU=1
			GBVersion="5.5" # latest version for this platform
			;;
		arm*|aarch64)
			DLSuffix="LinuxARMPreview"
			GBBinaryName="geekbench${GBVersion:0:1}"
			FirstOfflineCPU=0
			;;
		riscv64)
			DLSuffix="LinuxRISCVPreview"
			GBBinaryName="geekbench_riscv64"
			FirstOfflineCPU=1
			;;
		amd64|*x86*)
			DLSuffix="Linux"
			GBBinaryName="geekbench${GBVersion:0:1}"
			FirstOfflineCPU=1
			;;
		*)
			echo -e "\x08\x08 Not able to execute Geekbench on ${ARCH}. Exiting"
			exit 1
			;;
	esac

	cd "${InstallLocation}" || exit 1
	for i in $(seq 9 -1 0); do
		GBDir="Geekbench-${GBVersion}.${i}-${DLSuffix}"
		GBBinary="${InstallLocation}/${GBDir}/${GBBinaryName}"
		# if there's already an executable stop here
		[ -x "${GBBinary}" ] && return
		# try to download version ${GBVersion}.${i}
		TryoutURL="https://cdn.geekbench.com/${GBDir}.tar.gz"
		Downloadfile="${InstallLocation}/${GBDir}.tar.gz"
		[ -f "${Downloadfile}" ] || curl -f -O -L -s -q --connect-timeout 10 "${TryoutURL}" 2>/dev/null
		if [ -s "${Downloadfile}" ]; then
			# tarball could be downloaded, proceed with untar/remove
			echo -e "\x08\x08\x08, geekbench ${GBVersion}.${i}...\c"
			tar xf "${Downloadfile}"
			rm "${Downloadfile}"
			break
		elif [ -f "${Downloadfile}" ]; then
			rm "${Downloadfile}"
		fi
	done

	# create symlink with version number, to keep different major versions on same install
	ln -sf "${GBBinary}" "/usr/local/bin/geekbench${GBVersion:0:1}"
} # CheckGB

InstallPrerequisits() {
	case ${MODE} in
		gb)
			echo -e "sbc-bench v${Version} taking care of Geekbench\n\nInstalling needed tools:  \c"
			;;
		pts)
			echo -e "sbc-bench v${Version} taking care of Phoronix Test Suite\n\nInstalling needed tools:  \c"
			;;
		*)
			echo -e "sbc-bench v${Version}\n\nInstalling needed tools:  \c"
			;;
	esac

	# Determine missing packages and install them with a single command
	MissingPackages="$(CheckMissingPackages | sed 's/\ $//')"
	[ "X${MissingPackages}" = "Xstop" ] && exit 1
	[ "X${UBUNTU_CODENAME}" != "X" ] && UBUNTU_MAJOR_VERSION="${VERSION_ID%.*}"
	if [ ${UBUNTU_MAJOR_VERSION:-0} -lt 24 ]; then
		# On Ubuntus prior to 24.04 and all other distros search for p7zip in $PATH and
		# if not found add p7zip to list of packages to be installed
		SevenZip=$(command -v 7za || command -v 7zr)
		if [ -z "${SevenZip}" ]; then
			MissingPackages="${MissingPackages} p7zip"
		fi
	fi

	# add universe repository if needed and install all necessary packages in a batch
	case "${MissingPackages}" in
		*install|*"install -q -y"|*"install -y"|*"Syq")
			# no packages to be installed
			echo -e "\x08distro packages already installed...\c"
			;;
		*)
			echo -e "\x08\x08 ${MissingPackages}...\c"
			[ -r /etc/apt/sources.list ] && grep -v '^#' /etc/apt/sources.list | grep -q universe || add-apt-repository -y universe >/dev/null 2>&1
			${MissingPackages} >/dev/null 2>>"${TempDir}/packages.log"
			if [ $? -eq 100 ]; then
				# apt cache might be too outdated so update and try again
				echo -e "\x08\x08 Updating APT cache...\c"
				AptMessage="$(apt update 2>&1)"
				MissingPubKeys="$(tr "N" "\n" <<<"${AptMessage}" | awk -F" " '/^O_PUBKEY/ {print $2}' | sort | uniq | tr "\n" " ")"
				if [ "X${MissingPubKeys}" != "X" ]; then
					# try to add missing public keys and retry (Ubuntu's key server also has Debian keys)
					echo -e "\x08\x08 Try to add missing public keys ${MissingPubKeys}...\c"
					apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ${MissingPubKeys} >/dev/null 2>&1
					echo -e "\x08\x08 Updating APT cache again...\c"
					apt update >/dev/null 2>&1
					echo -e "\x08\x08 Installing packages...\c"
				fi
				${MissingPackages} >/dev/null 2>&1
			elif [ $? -ne 0 ] && [ -s "${TempDir}/packages.log" ]; then
				echo -e "\x08\x08 Something went wrong:\n"
				cat "${TempDir}/packages.log"
				echo -e "\nTrying to continue...\c"
			fi
			;;
	esac

	if [ ${UBUNTU_MAJOR_VERSION:-0} -lt 24 ]; then
		# On Ubuntus prior to 24.04 and all other distros search for p7zip in $PATH
		SevenZip=$(command -v 7za || command -v 7zr)
		# Validate 7-zip version (only 16.02 allows for comparable scores with results from years ago)
		if [ -x "${SevenZip}" ]; then
			Output7Zip="$("${SevenZip}" lalala 2>&1)"
			Valid7Zip="$(grep '^p7zip Version' <<<"${Output7Zip}" | head -n1 | awk -F" " '{print $3}')"
			[ -z "${Valid7Zip}" ] && Valid7Zip="$(grep '^7-Zip ' <<<"${Output7Zip}" | head -n1 | awk -F" " '{print $3}')"
			if [ "X${Valid7Zip}" != "X16.02" ]; then
				# try to install/build p7zip 16.02 with Debian (security) patches applied. If this fails still
				# use distro provided 7-zip binary (results validation will hint on problematic version later)
				if [ ! -x "${InstallLocation}/p7zip/bin/7za" ]; then
					grep -q "p7zip" <<<"${MissingPackages}" && echo -e "\x08\x08\x08 ${Valid7Zip}...\c"
					InstallOldP7zip
				fi
				[ -x "${InstallLocation}/p7zip/bin/7za" ] && SevenZip="${InstallLocation}/p7zip/bin/7za"
			fi
		fi
	else
		# On Ubuntu 24.x onwards directly build/use p7zip 16.02 on our own
		InstallOldP7zip
		[ -x "${InstallLocation}/p7zip/bin/7za" ] && SevenZip="${InstallLocation}/p7zip/bin/7za"
	fi

	if [ -z "${SevenZip}" ]; then
		echo -e "\x08\x08\x08 failed. ${LRED}${BOLD}No 7-zip binary found and could not be installed. Aborting${NC}" >&2
		exit 1
	fi

	if [ "${PlotCpufreqOPPs}" = "yes" ]; then
		command -v htmldoc >/dev/null 2>&1 || apt -f -qq -y --no-install-recommends install htmldoc >/dev/null 2>&1
		command -v gnuplot >/dev/null 2>&1 || apt -f -qq -y --no-install-recommends install gnuplot-nox >/dev/null 2>&1
	fi

	# get/build tinymembench if not already there
	[ -d "${InstallLocation}" ] || mkdir -p "${InstallLocation}"
	if [ -f "${InstallLocation}/tinymembench/.git/config" ]; then
		# exchange abandoned ssvb version with v0.4.9-nuumio
		grep -q github.com/ssvb/tinymembench "${InstallLocation}/tinymembench/.git/config" && \
			rm -rf "${InstallLocation}/tinymembench"
	fi
	if [ ! -x "${InstallLocation}"/tinymembench/tinymembench ]; then
		echo -e "\x08\x08\x08, tinymembench...\c"
		if [ -d "${InstallLocation}"/tinymembench ]; then
			cd "${InstallLocation}"/tinymembench || exit 1
			git pull >/dev/null 2>&1
		else
			cd "${InstallLocation}" || exit 1
			git clone https://github.com/nuumio/tinymembench >/dev/null 2>&1
			if [ $? -ne 0 ]; then
				echo -e "\n\n${LRED}${BOLD}Temporary Github problem. Not able to download tinymembench. Please try again later.${NC}" >&2
				exit 1
			fi
			cd tinymembench || exit 1
		fi
		make >/dev/null 2>&1
		if [ ! -x "${InstallLocation}"/tinymembench/tinymembench ]; then
			echo -e "${LRED}${BOLD}Not able to build necessary tools. Aborting.${NC}\nMost probably gcc and make packages are missing." >&2
			exit 1
		fi
	fi

	# get/build ramlat benchmark if not already built, rebuild if formerly compiled w/o GCC optimizations:
	# https://www.cnx-software.com/2022/06/05/nanopi-r5s-preview-part-2-ubuntu-20-04-friendlycore/#comment-593141
	if [ ! -x "${InstallLocation}"/ramspeed/ramlat ] || [ ! -f "${InstallLocation}"/ramspeed/Makefile ]; then
		echo -e "\x08\x08\x08, ramlat...\c"
		if [ ! -d "${InstallLocation}"/ramspeed ]; then
			cd "${InstallLocation}" || exit 1 && git clone https://github.com/wtarreau/ramspeed >/dev/null 2>&1
			if [ $? -ne 0 ]; then
				echo -e "\n\n${LRED}${BOLD}Temporary Github problem. Not able to download ramspeed. Please try again later.${NC}" >&2
				exit 1
			fi
		fi
		[ -d "${InstallLocation}"/ramspeed ] && cd "${InstallLocation}"/ramspeed || exit 1 ; git pull >/dev/null 2>&1; make >/dev/null 2>&1
	fi

	# get/build mhz if not already there
	if [ ! -x "${InstallLocation}"/mhz/mhz ]; then
		echo -e "\x08\x08\x08, mhz...\c"
		cd "${InstallLocation}" || exit 1
		git clone https://github.com/wtarreau/mhz >/dev/null 2>&1
		if [ $? -ne 0 ]; then
			echo -e "\n\n${LRED}${BOLD}Temporary Github problem. Not able to download mhz. Please try again later.${NC}" >&2
			exit 1
		fi
		cd mhz || exit 1
		make >/dev/null 2>&1
		if [ ! -x "${InstallLocation}"/mhz/mhz ]; then
			echo -e "${LRED}${BOLD}Not able to build necessary tools. Aborting.${NC}\nMost probably gcc and make packages are missing." >&2
			exit 1
		fi
	else
		grep -q 'among 5 runs of the short loop' "${InstallLocation}"/mhz/mhz.c
		if [ $? -ne 0 ]; then
			# rebuild mhz due to https://github.com/wtarreau/mhz/commit/6620e45f41429afe577aa3bb80614ac3934afd82
			echo -e "\x08\x08\x08, mhz...\c"
			cd "${InstallLocation}/mhz" || exit 1
			git pull >/dev/null 2>&1
			make >/dev/null 2>&1
		fi
	fi

	# get/build/update cpufetch if not already there
	if [ -x "${InstallLocation}"/cpufetch/cpufetch ]; then
		cd "${InstallLocation}/cpufetch" || exit 1
		GitResult="$(git pull 2>/dev/null)"
		if [[ ${GitResult} != *"up to date"* ]]; then
			# always update cpufetch if something has changed on Github
			echo -e "\x08\x08\x08, updating cpufetch...\c"
			make >/dev/null 2>&1
		fi
	else
		echo -e "\x08\x08\x08, cpufetch...\c"
		cd "${InstallLocation}" || exit 1
		git clone https://github.com/Dr-Noob/cpufetch >/dev/null 2>&1
		if [ $? -ne 0 ]; then
			echo -e "\n\n${LRED}${BOLD}Temporary Github problem. Not able to download cpufetch. Please try again later.${NC}" >&2
			exit 1
		fi
		cd cpufetch || exit 1
		make >/dev/null 2>&1
		if [ ! -x "${InstallLocation}"/cpufetch/cpufetch ]; then
			echo -e "${LRED}${BOLD}Not able to build necessary tools. Aborting.${NC}\nMost probably gcc and make packages are missing." >&2
			exit 1
		fi
	fi

	# if called with -s or with MODE=extensive we also use stockfish
	if [ "${ExecuteStockfish}" = "yes" ] || [ "X${MODE}" = "Xextensive" ]; then
		InstallStockfish && DownloadNeuralNet
	fi

	# if called with -c or as 'sbc-bench neon' or with MODE=extensive we also use cpuminer
	if [ "${ExecuteCpuminer}" = "yes" ] || [ "X${MODE}" = "Xextensive" ]; then
		InstallCpuminer
	fi
} # InstallPrerequisits

InstallOldP7zip() {
	if [ ! -x "${InstallLocation}/p7zip/bin/7za" ]; then
		echo -e "\x08\x08\x08, p7zip 16.02...\c"
		cd "${InstallLocation}" || exit 1
		if [ -d "${InstallLocation}/p7zip/.git" ]; then
			cd "${InstallLocation}/p7zip/" || exit 1 && git pull >/dev/null 2>&1
		else
			git clone https://github.com/ThomasKaiser/p7zip >/dev/null 2>&1
		fi
		if [ $? -ne 0 ]; then
			echo -e "\n\n${LRED}${BOLD}Temporary Github problem. Not able to download p7zip 16.02. Please try again later.${NC}" >&2
			exit 1
		fi
		cd "${InstallLocation}/p7zip/" || exit 1 && make clean >/dev/null 2>&1 && make -j${CPUCores} INSTALL=install CC=gcc CXX=g++ OPTFLAGS='-O3' >/dev/null 2>&1
	fi
	if [ ! -x "${InstallLocation}"/p7zip/bin/7za ]; then
		echo -e "\x08\x08\x08\x08\x08\x08\x08\x08\x08\x08\x08\x08\x08 (can't build p7zip 16.02)  \c"
	fi
} # InstallOldP7zip

InstallCpuminer() {
	# get/(re)build cpuminer if not already there or based on tkinjo1985 version
	[ -f "${InstallLocation}"/cpuminer-multi/.git/config ] && grep -q tkinjo1985 "${InstallLocation}"/cpuminer-multi/.git/config >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		# remove the old installation
		rm -rf "${InstallLocation}"/cpuminer-multi
	fi
	if [ ! -x "${InstallLocation}"/cpuminer-multi/cpuminer ] && [ ! -f "${InstallLocation}"/cpuminer-multi/.do-not-try-to-build-again ]; then
		echo -e "\x08\x08\x08, cpuminer...\c"
		cd "${InstallLocation}" || exit 1
		zypper install -y automake autoconf pkg-config libcurl4-openssl-dev libjansson-dev libssl-dev libgmp-dev make g++ zlib1g-dev >/dev/null 2>&1
		apt-get -f -qq -y install automake autoconf pkg-config libcurl4-openssl-dev libjansson-dev libssl-dev libgmp-dev make g++ zlib1g-dev >/dev/null 2>&1
		pacman --noconfirm -Sq automake autoconf pkg-config libcurl4-openssl-dev libjansson-dev libssl-dev libgmp-dev make g++ zlib1g-dev >/dev/null 2>&1
		dnf install -q -y openssl-devel curl-devel zlib-devel >/dev/null 2>&1
		if [ -d "${InstallLocation}/cpuminer-multi/.git" ]; then
			cd "${InstallLocation}/cpuminer-multi/" || exit 1 && git pull >/dev/null 2>&1 && make clean >/dev/null 2>&1
		else
			git clone https://github.com/tpruvot/cpuminer-multi >/dev/null 2>&1
		fi
		if [ $? -ne 0 ]; then
			echo -e "\n\n${LRED}${BOLD}Temporary Github problem. Not able to download cpuminer. Please try again later.${NC}" >&2
			exit 1
		fi
		cd "${InstallLocation}/cpuminer-multi/" || exit 1 && ./build.sh >/dev/null 2>&1
	fi
	if [ ! -x "${InstallLocation}"/cpuminer-multi/cpuminer ]; then
		echo -e "\x08\x08\x08\x08\x08\x08\x08\x08\x08\x08\x08\x08\x08 (can't build cpuminer)  \c"
		touch "${InstallLocation}"/cpuminer-multi/.do-not-try-to-build-again
	fi
} # InstallCpuminer

InstallStockfish() {
	# try to be compatible with Phoronix pts/stockfish-1.4.0 test profile as such grab
	# https://github.com/official-stockfish/Stockfish/archive/refs/tags/sf_15.tar.gz
	# and default net https://tests.stockfishchess.org/api/nn/nn-6877cd24400e.nnue

	if [ ! -x "${InstallLocation}/Stockfish-sf_15/src/stockfish" ]; then
		echo -e "\x08\x08\x08, stockfish...\c"
		cd "${InstallLocation}" || exit 1
		curl -f -L -s -q --connect-timeout 10 "https://github.com/official-stockfish/Stockfish/archive/refs/tags/sf_15.tar.gz" >"${InstallLocation}/sf_15.tar.gz" 2>/dev/null
		[ -s "${InstallLocation}/sf_15.tar.gz" ] && tar xf sf_15.tar.gz
		[ -d "${InstallLocation}/Stockfish-sf_15/src" ] && cd "${InstallLocation}/Stockfish-sf_15/src" || exit 1

		case ${CPUArchitecture} in
			x86_64)
				gcc_enabled=$(c++ -Q -march=native --help=target | grep "\[enabled\]")
				gcc_arch=$(c++ -Q -march=native --help=target | grep "march")
				if [[ "${gcc_enabled}" =~ "-mavx512vnni " && "${gcc_enabled}" =~ "-mavx512dq " && "${gcc_enabled}" =~ "-mavx512f " && "${gcc_enabled}" =~ "-mavx512bw " && "${gcc_enabled}" =~ "-mavx512vl " ]] ; then
					ARCH="x86-64-vnni256"
				elif [[ "${gcc_enabled}" =~ "-mavx512f " && "${gcc_enabled}" =~ "-mavx512bw " ]] ; then
					ARCH="x86-64-avx512"
				elif [[ "${gcc_enabled}" =~ "-mbmi2 " && ! "${gcc_arch}" =~ "znver1" && ! "${gcc_arch}" =~ "znver2" ]] ; then
					ARCH="x86-64-bmi2"
				elif [[ "${gcc_enabled}" =~ "-mavx2 " ]] ; then
					ARCH="x86-64-avx2"
				elif [[ "${gcc_enabled}" =~ "-mpopcnt " && "${gcc_enabled}" =~ "-msse4.1 " ]] ; then
					ARCH="x86-64-modern"
				elif [[ "${gcc_enabled}" =~ "-mssse 3 " ]] ; then
					ARCH="x86-64-ssse3"
				elif [[ "${gcc_enabled}" =~ "-mpopcnt " && "${gcc_enabled}" =~ "-msse3 " ]] ; then
					ARCH="x86-64-sse3-popcnt"
				else
					ARCH="x86-64-avx2"
				fi
				;;
			i686)
				ARCH=x86-32
				;;
			ppc64)
				ARCH=ppc-64
				;;
			armv7*)
				ARCH=armv7-neon
				;;
			aarch*)
				grep -q apple <<<"${DTCompatible,,}" && ARCH=apple-silicon || ARCH=armv8
				;;
			riscv64)
				ARCH=riscv64
				;;
			*)
				ARCH=general-64
				;;
		esac

		make profile-build ARCH=${ARCH} >"${TempDir}/stockfish-install.log" 2>&1

		if [ ! -x "${InstallLocation}/Stockfish-sf_15/src/stockfish" ]; then
			echo -e "\x08\x08\x08\x08\x08\x08\x08\x08\x08\x08\x08\x08\x08 (can't build stockfish)  \c"
			return 1
		else
			[ -f "${InstallLocation}/sf_15.tar.gz" ] && rm "${InstallLocation}/sf_15.tar.gz"
		fi
	fi
} # InstallStockfish

DownloadNeuralNet() {
	if [ -d "${InstallLocation}/Stockfish-sf_15/src" ]; then
		cd "${InstallLocation}/Stockfish-sf_15/src" || exit 1
		case ${NeuralNetwork} in
			????????????)
				# prefix with nn- and suffix with .nnue
				NeuralNetwork="nn-${NeuralNetwork}.nnue"
				;;
			????????????.nnue)
				# prefix with nn-
				NeuralNetwork="nn-${NeuralNetwork}"
				;;
			nn-????????????)
				# suffix with .nnue
				NeuralNetwork="${NeuralNetwork}.nnue"
				;;
			nn-????????????.nnue)
				# name fits already
				:
				;;
			*)
				# use default net
				FallbackNotification=" (fallback default net)"
				NeuralNetwork="nn-6877cd24400e.nnue"
				;;
		esac

		# download neural network if missing
		if [ ! -f "${NeuralNetwork}" ]; then
			echo -e "\x08\x08\x08, stockfish NN...\c"
			curl -f -O -L -s -q --connect-timeout 10 "https://tests.stockfishchess.org/api/nn/${NeuralNetwork}" 2>/dev/null
		fi

		# check neural network
		if [ -f "${NeuralNetwork}" ]; then
			NetHeader="$(od <"${NeuralNetwork}" | head -n1 | cut -c9-28)"
			if [ "X${NetHeader}" != "X027440 075363 027362" ]; then
				echo -e "\x08\x08\x08\x08\x08\x08\x08\x08\x08\x08\x08\x08\x08 (can't use ${NeuralNetwork}${FallbackNotification})  \c"
				return
			fi
		else
			echo -e "\x08\x08\x08\x08\x08\x08\x08\x08\x08\x08\x08\x08\x08 (can't download ${NeuralNetwork}${FallbackNotification})  \c"
		fi
	fi
} # DownloadNeuralNet

function parse_yaml {
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|,$s\]$s\$|]|" \
        -e ":1;s|^\($s\)\($w\)$s:$s\[$s\(.*\)$s,$s\(.*\)$s\]|\1\2: [\3]\n\1  - \4|;t1" \
        -e "s|^\($s\)\($w\)$s:$s\[$s\(.*\)$s\]|\1\2:\n\1  - \3|;p" $1 | \
   sed -ne "s|,$s}$s\$|}|" \
        -e ":1;s|^\($s\)-$s{$s\(.*\)$s,$s\($w\)$s:$s\(.*\)$s}|\1- {\2}\n\1  \3: \4|;t1" \
        -e    "s|^\($s\)-$s{$s\(.*\)$s}|\1-\n\1  \2|;p" | \
   sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)-$s[\"']\(.*\)[\"']$s\$|\1$fs$fs\2|p" \
        -e "s|^\($s\)-$s\(.*\)$s\$|\1$fs$fs\2|p" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p" | \
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]; idx[i]=0}}
      if(length($2)== 0){  vname[indent]= ++idx[indent] };
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) { vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, vname[indent], $3);
      }
   }'
}

InitialMonitoring() {
	# download Linux kernel end-of-life data
	curl -s -q --connect-timeout 10 https://raw.githubusercontent.com/endoflife-date/endoflife.date/master/products/linuxkernel.md \
		>"${TempDir}/linuxkernel.md" &

	# record start time
	BenchmarkStartTime=$(date +"%s")
	# empty caches
	echo 3 >/proc/sys/vm/drop_caches

	# q&d performance assessment to estimate duration
	QuickAndDirtyPerformance="$(BashBench)"
	TinymembenchDuration=$(( $(( 3 + $(( ${QuickAndDirtyPerformance} / 300000000 )) )) * ${#ClusterConfig[@]} ))
	RunHowManyTimes=3 # how many times should the multi-threaded tests be repeated
	SingleThreadedDuration=$(( 20 + $(( ${QuickAndDirtyPerformance} * ${#ClusterConfig[@]} / 5000000 )) ))
	MultiThreadedDuration=$(( ${RunHowManyTimes} * $(( 20 + $(( ${QuickAndDirtyPerformance} / 5000000 )) )) / ${CPUCores} ))
	if [ "${ExecuteCpuminer}" = "yes" ] && [ -x "${InstallLocation}"/cpuminer-multi/cpuminer ]; then
		EstimatedDuration=$(( ${TinymembenchDuration} + $(( $(( ${SingleThreadedDuration} + ${MultiThreadedDuration} )) / 60 )) + 8 ))
	else
		EstimatedDuration=$(( ${TinymembenchDuration} + $(( $(( ${SingleThreadedDuration} + ${MultiThreadedDuration} )) / 60 )) + 3 ))
	fi

	# collect CPU information
	CPUTopology="$(PrintCPUTopology)"
	echo -e "${CPUTopology}\n" >"${TempDir}/cpu-topology.log" &
	CPUSignature="$(GetCPUSignature)"
	[ -r /proc/device-tree/compatible ] && DTCompatible="$(tr "\000" "\n" </proc/device-tree/compatible 2>/dev/null)"
	OPPTables="$(ParseOPPTables)"
	# try to identify ARM/RISC-V/Loongson SoCs
	[ "${CPUArchitecture}" = "x86_64" ] && GuessedSoC="n/a" || GuessedSoC="$(GuessARMSoC)"

	# upload raw /proc/cpuinfo contents and device-tree compatible entry to ix.io
	ping -c1 -w2 ix.io >/dev/null 2>&1
	if [ $? -eq 0 ] && [ "X${ProcCPUFile}" = "X/proc/cpuinfo" ]; then
		UploadScheme="f:1=<-"
		UploadServer="ix.io"
		UploadAnswer="$( (echo -e "/proc/cpuinfo ${Version}\n\n$(uname -a) / ${DeviceName}\n" ; cat /proc/cpuinfo ; echo -e "\n${CPUTopology}\n\n${CPUSignature} / ${GuessedSoC} / ${CPUFetchGuess}$(cut -c9- <<<"${RK_NVMEM}")  ${AW_NVMEM:19:2}${AW_NVMEM:16:2}${AW_NVMEM:13:2}${AW_NVMEM:10:2} ${AW_NVMEM:31:2}${AW_NVMEM:28:2}${AW_NVMEM:25:2}${AW_NVMEM:22:2} ${AW_NVMEM:44:2}${AW_NVMEM:41:2}${AW_NVMEM:38:2}${AW_NVMEM:35:2} ${AW_NVMEM:56:2}${AW_NVMEM:53:2}${AW_NVMEM:50:2}${AW_NVMEM:47:2}\n\n${DTCompatible}\n\n${OPPTables}\n\n$(grep . /sys/devices/virtual/thermal/thermal_zone?/* 2>/dev/null)\n\n$(grep . /sys/class/hwmon/hwmon?/* 2>/dev/null)") 2>/dev/null | curl -s -F ${UploadScheme} ${UploadServer} 2>&1)"
		case "${UploadAnswer}" in
			*ix.io/*)
				# URL returned, so everything's fine
				:
				;;
			*)
				# something's wrong, e.g. "down for a while due to DDOS. thanks, buddy!" in early Nov. 2023
				ping -c1 -w2 sprunge.us >/dev/null 2>&1 && UploadScheme="sprunge=<-" ; UploadServer="sprunge.us"
				;;
		esac
	else
		# upload location fallback to sprunge.us if possible
		ping -c1 -w2 sprunge.us >/dev/null 2>&1 && UploadScheme="sprunge=<-" ; UploadServer="sprunge.us"
	fi

	# Log version and device info
	[ -r /etc/hostname ] && read HostName </etc/hostname 2>/dev/null
	if [ "X${MODE}" = "Xunattended" ] || [ "X${MODE}" = "Xextensive" ] || [ "X${MODE}" = "Xpts" ] || [ "X${MODE}" = "Xgb" ]; then
		echo -e "sbc-bench v${Version} ${DeviceName:-$HostName} ${MODE} ($(date -R))\n" | sed 's/  / /g' >"${ResultLog}"
	elif [ "X${REVIEWMODE}" = "Xtrue" ] && [ "X${NOTUNING}" != "Xyes" ]; then
		echo -e "sbc-bench v${Version} ${DeviceName:-$HostName} ${MODE} ($(date -R))\n" | sed 's/  / /g' >"${ResultLog}"
	elif [ "X${REVIEWMODE}" = "Xtrue" ]; then
		echo -e "sbc-bench v${Version} ${DeviceName:-$HostName} NOTUNING review ($(date -R))\n" | sed 's/  / /g' >"${ResultLog}"
	else
		echo -e "sbc-bench v${Version} ${DeviceName:-$HostName} ($(date -R))\n" | sed 's/  / /g' >"${ResultLog}"
	fi

	# get distribution info
	command -v lsb_release >/dev/null 2>&1 && (lsb_release -a 2>/dev/null | grep -v "n/a") >>"${ResultLog}" || \
		echo -e "Description:\t${OperatingSystem}" >>"${ResultLog}"
	ARCH=$(dpkg --print-architecture 2>/dev/null) || \
		ARCH=$(awk -F'"' '/^CARCH/ {print $2}' /etc/makepkg.conf 2>/dev/null) || \
		ARCH="$(uname -m)"

	# Log Raspberry OS info if available
	[ -f /etc/apt/sources.list.d/raspi.list ] && \
		echo "Build system:   $(grep -v '#' /etc/apt/sources.list.d/raspi.list | head -n1 | sed 's/deb //')" >>"${ResultLog}"

	# Log Build system info if available
	if [ -r /etc/radxa_image_fingerprint ]; then
		# Radxa's rbuild
		. /etc/radxa_image_fingerprint
		if [ ${FINGERPRINT_VERSION:-1} -eq 2 ]; then
			# new format, we need to parse ${RSDK_CONFIG}
			eval "$(parse_yaml "${RSDK_CONFIG}")" 2>/dev/null
			sed -e 's/{//' -e 's/\}//' -e 's/^/Build system:   Radxa rbuild: /' <<<"${metadata} suite: ${metadata_suite}" >>"${ResultLog}"
		else
			echo "Build system:   Radxa rbuild ${RBUILD_REVISION}, ${RBUILD_COMMAND#* }, ${RBUILD_UBOOT} ${RBUILD_UBOOT_VERSION}, $(awk -F" " '{print $2" "$3" "$4}' <<<"${RBUILD_BUILD_DATE}")" >>"${ResultLog}"
		fi
	elif [ -r /etc/fenix-release ]; then
		# Khadas' Fenix (mostly based on an old Armbian fork)
		# they put image build information in /proc/cmdline like e.g.
		# khadas_board=VIM3 hwver=VIM3.V12 coherent_pool=2M pci=pcie_bus_perf imagetype=EMMC_MBR uboottype=mainline
		. /etc/fenix-release
		if [ -r /proc/cmdline ]; then
			read cmdline </proc/cmdline
			khadas_board=${cmdline##*khadas_board=}
			khadas_hwver=${cmdline##*hwver=}
			khadas_imagetype=${cmdline##*imagetype=}
			khadas_uboottype=${cmdline##*uboottype=}
			echo "Build system:   Khadas Fenix ${VERSION}, ${khadas_board%% *}/${khadas_hwver%% *}, u-boot type: ${khadas_uboottype%% *}, image type: ${khadas_imagetype%% *}" >>"${ResultLog}"
		else
			echo "Build system:   Khadas Fenix ${VERSION}" >>"${ResultLog}"
		fi
	elif [ -r /boot/dietpi/.version ]; then
		# DietPi
		. /boot/dietpi/.version
		echo -e "Build system:   DietPi ${G_DIETPI_VERSION_CORE}.${G_DIETPI_VERSION_SUB}.${G_DIETPI_VERSION_RC}, https://github.com/${G_GITOWNER}/DietPi/tree/${G_GITBRANCH}" >>"${ResultLog}"
	elif [ -r /etc/orangepi-release ]; then
		# Xunlong's forked Armbian scripts
		. /etc/orangepi-release
	elif [ -r /etc/armbian-release ]; then
		# Armbian or other forks
		. /etc/armbian-release
	fi
	[ "X${BOARD_NAME}" != "X" ] && \
		echo "Build system:   ${BUILD_REPOSITORY_URL:-https://github.com/armbian/build}, ${VERSION}, ${BOARD_NAME}, ${BOARDFAMILY}, ${LINUXFAMILY}" >>"${ResultLog}"

	# Log system info and BIOS/UEFI versions if available:
	command -v dmidecode >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		SystemInfo="$(dmidecode -t system 2>/dev/null | grep -E "Manufacturer: |Product Name: |Version: |Family: |SKU Number: " | grep -E -v ":  $|O.E.M.|123456789|0000000000000000|: Not |Default|default|System Product Name|System manufacturer|System Version|BAD INDEX")"
		UEFIInfo="$(dmidecode -t bios 2>/dev/null | grep -E "Vendor:|Version:|Release Date:|Revision:")"
	fi
	if [ "X${SystemInfo}" != "X" ]; then
		# Skip worthless SMBIOS/DMI emulation on RPi
		grep -i -q "raspberrypi" <<<"${SystemInfo}" || echo -e "\nDevice Info:\n${SystemInfo}" >>"${ResultLog}"
	fi
	if [ "X${UEFIInfo}" != "X" ]; then
		echo -e "\nBIOS/UEFI:\n${UEFIInfo}" >>"${ResultLog}"
	fi

	# On Raspberries we also collect 'firmware' information and on RPi 4 check SoC revision
	# against config.txt contents:
	if [ ${USE_VCGENCMD} = true ] ; then
		ThreadXVersion="$("${VCGENCMD}" version 2>/dev/null)"
		if [ "X${ThreadXVersion}" = "X" ]; then
			# dealing with a fake vcgencmd not implementing version reporting
			USE_VCGENCMD=false
		else
			# only report ThreadX stuff when 'vcgencmd version' outputs something
			if [ -f /boot/config.txt ]; then
				grep -q 'DO NOT EDIT THIS FILE' /boot/config.txt && ThreadXConfig=/boot/firmware/config.txt || ThreadXConfig=/boot/config.txt
			else
				ThreadXConfig=/boot/firmware/config.txt
			fi
			grep -q "arm_boost=1" ${ThreadXConfig} 2>/dev/null || (grep -q "C0 or later" <<<"${DeviceName}" && \
				echo -e "\nWarning: this Raspberry Pi is powered by BCM2711 Rev. ${BCM2711} but arm_boost=1\nis not set in ${ThreadXConfig}. Some (mis)information about what you are missing:\nhttps://www.raspberrypi.com/news/bullseye-bonus-1-8ghz-raspberry-pi-4/" >>"${ResultLog}")
			echo -e "\nRaspberry Pi ThreadX version:\n${ThreadXVersion}" >>"${ResultLog}"
			[ -f ${ThreadXConfig} ] && echo -e "\nThreadX configuration (${ThreadXConfig}):\n$(grep -v '#' ${ThreadXConfig} | sed '/^\s*$/d')" >>"${ResultLog}"
			ActualThreadXsettings="$("${VCGENCMD}" get_config int)"
			echo -e "\nActual ThreadX settings:\n${ActualThreadXsettings}" >>"${ResultLog}"
		fi
	fi

	# Log gcc version if not in Geekbench mode
	if [ "X${MODE}" != "Xgb" ]; then
		GCC="$(command -v gcc)"
		GCC_Version="$(${GCC} --version | sed 's/gcc\ //' | head -n1)"
		echo -e "\n${GCC} ${GCC_Version}" >>"${ResultLog}"
	fi

	# Some basic system info needed to interpret system health later
	VoltageSensor="$(GetVoltageSensor)"
	if [ "X${VoltageSensor}" != "X" ]; then
		InputVoltage="$(GetInputVoltage "${VoltageSensor}")"
		echo -e "\nUptime:$(uptime),  ${InitialTemp}°C,  ${InputVoltage}V,  ${QuickAndDirtyPerformance}\n\n$(iostat | grep -E -v "^loop|boot0|boot1|mtdblock")\n\n$(free -h)\n\n$(swapon -s)\n" | sed '/^$/N;/^\n$/D' >>"${ResultLog}"
	else
		echo -e "\nUptime:$(uptime),  ${InitialTemp}°C,  ${QuickAndDirtyPerformance}\n\n$(iostat | grep -E -v "^loop|boot0|boot1|mtdblock")\n\n$(free -h)\n\n$(swapon -s)\n" | sed '/^$/N;/^\n$/D' >>"${ResultLog}"
	fi
	ShowZswapStats 2>/dev/null >>"${ResultLog}"

	# set up Netio consumption monitoring if requested. Device address and socket
	# need to be available as Netio (environment) variable.
	if [ "X${Netio}" != "X" ]; then
		QueryNetioDevice
		echo -e "\nPower monitoring on socket ${NetioSocket} of ${NetioName} (Netio ${NetioModel}, FW v${Firmware}, XML API v${XmlVer}, ${InputVoltage}V @ ${Frequency}Hz) " >>"${ResultLog}"
	fi

	# log benchmark start in dmesg output
	echo "sbc-bench started" >/dev/kmsg

	# get status of swap devices to spot swapping activity ruining benchmark scores
	SwapBefore="$(awk -F" " '{print $4}' </proc/swaps | grep -v -i Used | awk '{s+=$1} END {printf "%.0f", s}')"
} # InitialMonitoring

QueryNetioDevice() {
		NetioDevice="$(cut -f1 -d/ <<<"${Netio}")"
		NetioSocket="$(cut -f2 -d/ <<<"${Netio}")"
		XMLOutput="$(curl -q --connect-timeout 1 "http://${NetioDevice}/netio.xml" 2>/dev/null | tr '\015' '\012')"
		OutputCurrents=($(grep '^<Current>' <<<"${XMLOutput}" | sed -e 's/\(<[^<][^<]*>\)//g' | tr '\n' ' '))
		InputVoltage=$(grep '^<Voltage>' <<<"${XMLOutput}" | sed -e 's/\(<[^<][^<]*>\)//g')
		Frequency=$(grep '^<Frequency>' <<<"${XMLOutput}" | sed -e 's/\(<[^<][^<]*>\)//g')
		NetioModel=$(grep '^<Model>' <<<"${XMLOutput}" | sed -e 's/\(<[^<][^<]*>\)//g')
		NetioName=$(grep '^<DeviceName>' <<<"${XMLOutput}" | sed -e 's/\(<[^<][^<]*>\)//g')
		Firmware=$(grep '^<Version>' <<<"${XMLOutput}" | sed -e 's/\(<[^<][^<]*>\)//g')
		XmlVer=$(grep '^<XmlVer>' <<<"${XMLOutput}" | sed -e 's/\(<[^<][^<]*>\)//g')
} # QueryNetioDevice

GetVoltageSensor() {
	case "${DTCompatible,,}" in
		*nanopi-r6s*)
			# NanoPi R6S running with Rockchip's 5.10 BSP kernel?
			if [ -f /sys/devices/iio_sysfs_trigger/subsystem/devices/iio\:device0/in_voltage2_raw ]; then
				echo /sys/devices/iio_sysfs_trigger/subsystem/devices/iio\:device0/in_voltage2_raw
			fi
			;;
		*rock-5b*|*rock-5-itx*)
			# Rock 5B running with Rockchip's 5.10 BSP kernel?
			if [ -f /sys/devices/iio_sysfs_trigger/subsystem/devices/iio\:device0/in_voltage6_raw ]; then
				echo /sys/devices/iio_sysfs_trigger/subsystem/devices/iio\:device0/in_voltage6_raw
			fi
			;;
		*)
			# test for Allwinner A20 + PMU			
			if [ -f /sys/power/axp_pmu/ac/voltage ]; then
				# Allwinner A20 powered via DC-IN running with mainline kernel + Armbian patches
				InputVoltage="$(GetInputVoltage /sys/power/axp_pmu/ac/voltage)"
				case ${InputVoltage} in
					0|0.*)
						# board seems to be powered through either battery or USB, so report the latter
						echo /sys/power/axp_pmu/vbus/voltage
						;;
					*)
						echo /sys/power/axp_pmu/ac/voltage
						;;
				esac
			elif [ -f /sys/devices/platform/sunxi-i2c.0/i2c-0/0-0034/axp20-supplyer.28/power_supply/ac/voltage_now ]; then
				# Allwinner A20 powered via DC-IN running 3.4 kernel
				InputVoltage="$(GetInputVoltage /sys/devices/platform/sunxi-i2c.0/i2c-0/0-0034/axp20-supplyer.28/power_supply/ac/voltage_now)"
				case ${InputVoltage} in
					0|0.*)
						# board seems to be powered through either battery or USB, so report the latter
						echo /sys/devices/platform/sunxi-i2c.0/i2c-0/0-0034/axp20-supplyer.28/power_supply/usb/voltage_now
						;;
					*)
						echo /sys/devices/platform/sunxi-i2c.0/i2c-0/0-0034/axp20-supplyer.28/power_supply/ac/voltage_now
						;;
				esac
			elif [ -f /sys/power/axp_pmu/vbus/voltage ]; then
				# Allwinner A20 powered through USB running with mainline kernel + Armbian patches
				echo /sys/power/axp_pmu/vbus/voltage
			elif [ -f /sys/devices/platform/sunxi-i2c.0/i2c-0/0-0034/axp20-supplyer.28/power_supply/usb/voltage_now ]; then
				# Allwinner A20 powered through USB running 3.4 kernel
				echo /sys/devices/platform/sunxi-i2c.0/i2c-0/0-0034/axp20-supplyer.28/power_supply/usb/voltage_now
			fi
			;;
	esac
} # GetVoltageSensor

GetInputVoltage() {
	case ${1##*/} in
		in_voltage6_raw)
			# Rock 5B running with Rockchip's 5.10 BSP kernel
			awk '{printf ("%0.2f",$1/173.5); }' <"${1}" | sed 's/,/./'
			;;
		in_voltage2_raw)
			case "${DTCompatible,,}" in
				*nanopi-r6s*)
					# NanoPi R6S running with Rockchip's 5.10 BSP kernel
					awk '{printf ("%0.2f",$1/206.2); }' <"${1}" | sed 's/,/./'
					;;
			esac
			;;
		voltage|voltage_now)
			# Allwinner A20
			awk '{printf ("%0.2f",$1/1000000); }' <"${1}" | sed 's/,/./'
			;;
	esac
} # GetInputVoltage

CheckClockspeedsAndSensors() {
	if [ -x "${InstallLocation}"/mhz/mhz ]; then
		echo -e "\n##########################################################################" >>"${ResultLog}"
		echo -e "\c" >"${TempDir}/cpufreq"
		if [ -s "${MonitorLog}" ]; then
			# 2nd check after most demanding benchmark has been run.
			echo -e "\x08\x08 Done.\nChecking cpufreq OPP again...\c"
			echo -e "\nTesting maximum cpufreq again, still under full load. System health now:\n" >>"${ResultLog}"
			grep 'Time' "${MonitorLog}" | tail -n 1 >>"${ResultLog}"
			grep ':' "${MonitorLog}" | tail -n 1 >>"${ResultLog}"
			OnlyCPUFreqMax=YES
		else
			echo -e "\x08\x08 Done.\nChecking cpufreq OPP...\c"
			# 1st check, try to get info about Intel P-States and HFI (Hardware Feedback Interface)
			if [ "${CPUArchitecture}" = "x86_64" ]; then
				PStateStatus="$(journalctl -b 2>/dev/null | awk -F": " '/intel_pstate:/ {print $3}' | sed ':a;N;$!ba;s/\n/, /g')"
				if [ "X${PStateStatus}" != "X" ]; then
					echo -e "\nIntel P-States: ${PStateStatus}" >>"${ResultLog}"
				fi
				HFIEnabled=$(awk -F":" '/^flags/ {print $2}' <<< "${ProcCPU}" | grep -c " hfi")
				if [ ${HFIEnabled} -gt 0 ]; then
					if [ -f /sys/devices/system/cpu/cpu0/acpi_cppc/nominal_perf ]; then
						DifferentCores=$(cat /sys/devices/system/cpu/cpu*/acpi_cppc/nominal_perf | sort | uniq | wc -l)
					else
						DifferentCores=1
					fi
					if [ ${DifferentCores} -gt 1 ]; then
						echo -e "\nIntel Hardware Feedback Interface enabled (${DifferentCores} core types)" >>"${ResultLog}"
					else
						echo -e "\nIntel Hardware Feedback Interface enabled" >>"${ResultLog}"
					fi
				fi
			fi
			# if powercapping seems to be available on Intel then add a hint
			# https://www.cnx-software.com/2022/09/08/how-to-check-tdp-pl1-and-pl2-power-limits-in-windows-and-linux/
			if [ -d /sys/devices/virtual/powercap/intel-rapl ]; then
				grep -q -i GenuineIntel <<< "${ProcCPU}" && \
				echo -e "\nPowercap present. You might want to check with \"powercap-info -p intel-rapl\"" >>"${ResultLog}"
			fi
			# if running on a Ryzen CPU add a hint to RyzenAdj
			grep -q -i "AMD Ryzen" <<< "${ProcCPU}" && \
				echo -e "\nAMD Ryzen detected. For power limits visit https://github.com/FlyGoat/RyzenAdj" >>"${ResultLog}"
		fi
		if [ ${#ClusterConfig[@]} -eq 1 ]; then
			# all CPU cores have same package id, we only need to test one core
			CPUInfo="$(GetCPUInfo 0)"
			echo -e "\nChecking cpufreq OPP${CPUInfo}:\n" >>"${ResultLog}"
			echo -e "cpu0${CPUInfo}: \c" >>"${TempDir}/cpufreq"
			CheckCPUCluster 0 >>"${ResultLog}"
		else
			# different package ids, we walk through all clusters
			for i in $(seq 0 $(( ${#ClusterConfig[@]} -1 )) ) ; do
				FirstCore=${ClusterConfig[$i]}
				LastCore=$(GetLastClusterCore $(( $i + 1 )))
				CPUInfo="$(GetCPUInfo ${ClusterConfig[$i]})"
				CoresOnline ${FirstCore} ${LastCore}
				case $? in
					0)
						if [ ${FirstCore} -eq ${LastCore} ]; then
							echo -e "\nChecking cpufreq OPP for cpu${FirstCore}${CPUInfo}:\n" >>"${ResultLog}"
							echo -e "cpu${FirstCore}${CPUInfo}: \c" >>"${TempDir}/cpufreq"
						else
							echo -e "\nChecking cpufreq OPP for cpu${FirstCore}-cpu${LastCore}${CPUInfo}:\n" >>"${ResultLog}"
							echo -e "cpu${FirstCore}-cpu${LastCore}${CPUInfo}: \c" >>"${TempDir}/cpufreq"
						fi
						CheckCPUCluster ${FirstCore} >>"${ResultLog}"
						;;
					*)
						if [ ${FirstCore} -eq ${LastCore} ]; then
							echo -e "\nSkipping cpu${FirstCore}${CPUInfo} since cores are offline: ${OfflineCores}" >>"${ResultLog}"
						else
							echo -e "\nSkipping cpu${FirstCore}-cpu${LastCore}${CPUInfo} since cores are offline: ${OfflineCores}" >>"${ResultLog}"
						fi
						;;
				esac
			done
		fi
		if [ "X${MODE}" = "Xextensive" ] && [ ! -s "${MonitorLog}" ]; then
			# in this mode we also check all CPU cores in parallel, 1st in idle
			echo -e "\nMeasuring highest clockspeeds for all cores in parallel (idle):\n" >>"${ResultLog}"
			CheckAllCores idle >>"${ResultLog}"
			# measure maximum clockspeeds under full load again
			if [ -x "${InstallLocation}"/cpuminer-multi/cpuminer ]; then
				echo -e "\nMeasuring highest clockspeeds for all cores in parallel (full load):\n" >>"${ResultLog}"
				timeout 15 "${InstallLocation}"/cpuminer-multi/cpuminer --benchmark --cpu-priority=2 >/dev/null &
				snore 10
				CheckAllCores full-load >>"${ResultLog}"
			fi			
		fi
	else
		echo -e "\x08\x08\x08 not possible since ${InstallLocation}/mhz/mhz not executable...\c"
	fi

	# if lm-sensors is present and reports anything add this to results.log
	LMSensorsOutput="$(sensors -A 2>/dev/null | grep -v " +0.0 C" | sed -e 's/rpi_volt-isa-0000//' -e 's/in0:              N\/A  //')"
	if [ "X${LMSensorsOutput}" != "X" ]; then
		echo -e "\n##########################################################################\n" >>"${ResultLog}"
		echo -e "Hardware sensors:\n\n${LMSensorsOutput}" >>"${ResultLog}"

		# if temperature sensors can be read from disks, report them
		SmartCtl="$(command -v smartctl 2>/dev/null)"
		Disks="$(ls /dev/sd? /dev/nvme? 2>/dev/null | sort)"
		if [ "X${SmartCtl}" != "X" ] && [ "X${Disks}" != "X" ]; then
			echo "" >>"${ResultLog}"
			# try to restrict SMART queries to 15 sec duration due to buggy devices
			command -v timeout >/dev/null 2>&1 && SmartCtl="timeout 15 ${SmartCtl}"
			for Disk in ${Disks} ; do
				case ${Disk} in
					/dev/sd*)
						DiskTemp="$(${SmartCtl} -a ${Disk} | awk -F" " '/Temperature/ {print $10" "$2}' | head -n1 | sed -e 's/_/ /g' -e 's/^ *//g')"
						[ "X${DiskTemp}" != "X" ] && echo -e "${Disk}:\t${DiskTemp}"
						;;
					/dev/nvme*)
						echo -e "${Disk}:\t$(${SmartCtl} -a ${Disk} | awk -F" " '/Temperature:/ {print $2" "$3}' | head -n1)"
						;;
				esac
			done | sed -e 's/ Airflow//' -e 's/ Temperature//' -e 's/ Celsius$/°C/' -e 's/ Cel$/°C/' >>"${ResultLog}"
		fi
	fi
} # CheckClockspeedsAndSensors

CoresOnline() {
	# check whether CPU hotplug is supported on cores != 0 (cpu0 can't be offline)
	# $1 -> first core to check
	# $2 -> last core to check, if missing only $1 will be checked

	local i
	if [ ${1} -ne 0 ] && [ -f /sys/devices/system/cpu/cpu${1}/online ]; then
		for i in $(seq ${1} ${2:-$1}) ; do
			read IsOnline </sys/devices/system/cpu/cpu${i}/online
			[ ${IsOnline} -eq 0 ] && return 1
		done
	fi
	return 0
} # CoresOnline

CheckTimeInState() {
	# Check cpufreq statistics prior and after benchmark to detect throttling (won't work
	# with all kernels and especially not on the RPi since RPi Ltd. people are cheating.
	# Cpufreq support via sysfs is bogus and with latest ThreadX (firmware) update they
	# even cheat wrt querying the 'firmware' via 'vcgencmd get_throttled':
	# https://www.raspberrypi.org/forums/viewtopic.php?f=63&t=217056#p1334921

	if [ -f /sys/devices/system/cpu/cpufreq/policy0/stats/time_in_state ]; then
		for StatFile in /sys/devices/system/cpu/cpufreq/policy?/stats/time_in_state ; do
			[[ -e "${StatFile}" ]] || break
			case ${1} in
				before)
					# reset statistics if possible
					[ -w "${StatFile%/*}/reset" ] && echo 1 >"${StatFile%/*}/reset"
					;;
			esac
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
		echo ${MinSpeed} >/sys/devices/system/cpu/cpufreq/policy${1}/scaling_min_freq 2>/dev/null
		if [ "X${OnlyCPUFreqMax}" = "XYES" ]; then
			OPPtoCheck="${MaxSpeed}"
		elif [ -f /sys/devices/system/cpu/cpufreq/policy${1}/scaling_available_frequencies ]; then
			OPPtoCheck=$((tr " " "\n" </sys/devices/system/cpu/cpufreq/policy${1}/scaling_available_frequencies ; tr " " "\n" </sys/devices/system/cpu/cpufreq/policy${1}/scaling_boost_frequencies) 2>/dev/null | sort -n -r | uniq | sed '/^[[:space:]]*$/d')
		elif [ ${MinSpeed} -eq 0 ]; then
			OPPtoCheck="${MaxSpeed}"
		else
			OPPtoCheck="${MaxSpeed} ${MinSpeed}"
		fi
		for i in ${OPPtoCheck} ; do
			# if MaxKHz environment variable is set then skip any higher cpufreq OPP,
			# works similar for MinKHz
			if [ ${i} -le ${MaxKHz:-90000000} ] && [ ${i} -ge ${MinKHz:-0} ]; then
				echo ${i} >/sys/devices/system/cpu/cpufreq/policy${1}/scaling_max_freq
				# instead of 'snore 0.1' fire up some real workload in a try to compensate for SoC
				# firmwares that might do their own thing wrt clockspeeds (keep them low when idle)
				taskset -c $1 "${InstallLocation}"/mhz/mhz 1 1000000 >/dev/null
				MeasuredSpeed=$(taskset -c $1 "${InstallLocation}"/mhz/mhz 3 1000000 | awk -F" cpu_MHz=" '{print $2}' | awk -F" " '{print $1}' | sort -r -n | tr '\n' '/' | sed 's|/$||')
				SpeedSum=$(tr '/' '\n' <<<"${MeasuredSpeed}" | tr -d '.' | awk '{s+=$1} END {printf "%.0f", s}')
				RoundedSpeed=$(( ${SpeedSum} / 3000 ))
				SysfsSpeed=$(( $i / 1000 ))
				# report differences in cpufreq OPP ('advertised' clockspeed) and measured
				# clockspeed if difference exceeds 1%
				MeasuredDiff=$(awk '{printf ("%0.3f",$1/$2); }' <<<"${RoundedSpeed}000 ${SysfsSpeed}000" | tr -d '.')
				if [ ${MeasuredDiff} -lt 990 ]; then
					# measured clockspeed lower than 1% than cpufreq OPP
					DiffPercentage=$(awk '{printf ("%0.0f",$1-$2); }' <<<"1000 ${MeasuredDiff}" | awk '{printf ("%0.1f",$1/10); }')
					PrettyDiff="$(printf "%10s" \(-${DiffPercentage})%)"
					CpufreqPrefix="${LRED}"
				elif [ ${MeasuredDiff} -gt 1010 ]; then
					# measured clockspeed higher than 1% than cpufreq OPP
					DiffPercentage=$(awk '{printf ("%0.0f",$1-$2); }' <<<"${MeasuredDiff} 1000" | awk '{printf ("%0.1f",$1/10); }')
					PrettyDiff="$(printf "%10s" \(+${DiffPercentage})%)"
					CpufreqPrefix="${LGREEN}"
				else
					PrettyDiff=""
					CpufreqPrefix=""
				fi

				# Check whether Linpack reliability measurement should be done as well (aarch64 only)
				[ -x "${Linpack}/xhpl64" ] && [ -r "${Linpack}/HPL.dat" ] && [ "$(uname -m)" = "aarch64" ] && LinpackResult="   ($(MeasureWithLinpack))" || LinpackResult=""

				if [ ${USE_VCGENCMD} = true ] ; then
					# On RPi we query ThreadX about clockspeeds and Vcore voltage too, on RPi 5
					# we even use the ADC measurements. Also we create an OPP table on the fly
					# derived from ThreadX config via 'measure_volts' and 'measure_clock arm':
					ThreadXFreq=$("${VCGENCMD}" measure_clock arm 2>/dev/null | awk -F"=" '{printf ("%0.0f",$2/1000000); }' )
					CoreVoltage=$("${VCGENCMD}" measure_volts uncached 2>/dev/null | cut -f2 -d=)
					[ "X${CoreVoltage}" = "X" ] && CoreVoltage=$("${VCGENCMD}" measure_volts 2>/dev/null | cut -f2 -d=)
					[ "X${OnlyCPUFreqMax}" = "XYES" ] || printf "%10s MHz %8s mV\n" ${ThreadXFreq} $(awk '{printf ("%0.1f",$1*1000); }' <<<${CoreVoltage}) >>"${TempDir}/opp-table-threadx-${1}"
					ADC_Readouts="$("${VCGENCMD}" pmic_read_adc 2>/dev/null)"
					case $? in
						0)
							MeasuredCoreVoltage="$(awk -F"=" '/VDD_CORE_V/ {printf ("%0.4f",$2); }' <<<"${ADC_Readouts}")V"
							echo -e "Cpufreq OPP: $(printf "%4s" ${SysfsSpeed})  ThreadX: $(printf "%4s" ${ThreadXFreq})  Measured: $(printf "%4s" ${RoundedSpeed}) @ ${CoreVoltage}/${MeasuredCoreVoltage}${PrettyDiff}${LinpackResult}"
							;;
						*)
							echo -e "Cpufreq OPP: $(printf "%4s" ${SysfsSpeed})  ThreadX: $(printf "%4s" ${ThreadXFreq})  Measured: $(printf "%4s" ${RoundedSpeed}) @ ${CoreVoltage}${PrettyDiff}${LinpackResult}"
							;;
					esac
					[ $i -eq ${MaxSpeed} ] && echo -e "OPP: $(printf "%4s" ${SysfsSpeed}), ThreadX: $(printf "%4s" ${ThreadXFreq}), Measured: $(printf "%4s" ${RoundedSpeed}) ${CpufreqPrefix}${PrettyDiff}${NC}">>"${TempDir}/cpufreq"
				else
					echo -e "Cpufreq OPP: $(printf "%4s" ${SysfsSpeed})    Measured: $(printf "%4s" ${RoundedSpeed}) $(printf "%27s" \(${MeasuredSpeed}))${PrettyDiff}${LinpackResult}"
					[ $i -eq ${MaxSpeed} ] && echo -e "OPP: $(printf "%4s" ${SysfsSpeed}), Measured: $(printf "%4s" ${RoundedSpeed}) ${CpufreqPrefix}${PrettyDiff}${NC}">>"${TempDir}/cpufreq"
				fi
			fi
		done
		if [ "X${MaxKHz}" = "X" ]; then
			echo ${MaxSpeed} >/sys/devices/system/cpu/cpufreq/policy${1}/scaling_max_freq
		else
			echo ${MaxKHz} >/sys/devices/system/cpu/cpufreq/policy${1}/scaling_max_freq
		fi
	else
		# no cpufreq support: measure speeds on cpu0 on single core machines, otherwise on
		# next cpu core to not interfere with probable bad IRQ/SMP affinitiy settings.
		case ${CPUCores} in
			1)
				CpuToCheck=0
				;;
			*)
				CpuToCheck=$(( $1 + 1 ))
				;;
		esac
		taskset -c ${CpuToCheck} "${InstallLocation}"/mhz/mhz 1 1000000 >/dev/null
		MeasuredSpeed=$(taskset -c ${CpuToCheck} "${InstallLocation}"/mhz/mhz 3 1000000 | awk -F" cpu_MHz=" '{print $2}' | awk -F" " '{print $1}' | sort -r -n | tr '\n' '/' | sed 's|/$||')
		SpeedSum=$(tr '/' '\n' <<<"${MeasuredSpeed}" | tr -d '.' | awk '{s+=$1} END {printf "%.0f", s}')
		RoundedSpeed=$(( ${SpeedSum} / 3000 ))
		echo -e "No cpufreq support available. Measured on cpu${CpuToCheck}: ${RoundedSpeed} MHz (${MeasuredSpeed})"
		echo -e "Measured: $(printf "%4s" ${RoundedSpeed})">>"${TempDir}/cpufreq"
	fi
} # CheckCPUCluster

MeasureWithLinpack() {
	# function that chdirs into ${Linpack}, then runs xhpl64 and provides the resulting
	# Gflops number when passing or FAILED otherwise.
	# https://github.com/raspberrypi/firmware/issues/1876#issuecomment-2002634934
	cd "${Linpack}" || return 1
	LinpackResult="$("./xhpl64" 2>&1)"
	grep -q "PASSED" <<<"${LinpackResult}"
	case $? in
		0)
			awk -F' ' '/^WR02R2L2/ {print $7}' <<<"${LinpackResult}"
			;;
		*)
			echo "FAILED"
			;;
	esac
	cd "${OLDPWD}" || return 1
} # MeasureWithLinpack

CheckAllCores() {
	for i in $(seq 0 $(( ${CPUCores} -1 )) ) ; do
		taskset -c ${i} "${InstallLocation}"/mhz/mhz 3 1000000 >"${TempDir}/CheckAllCores-${1}.${i}" &
	done
	if [ -r /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq ]; then
		CpuFreqToQuery=cpuinfo_cur_freq
	elif [ -r /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq ]; then
		CpuFreqToQuery=scaling_cur_freq
	fi
	# if in full-load mode wait 8 seconds
	[ "X${1}" = "Xfull-load" ] && snore 8
	for i in $(seq 0 $(( ${CPUCores} -1 )) ) ; do
		[ -f /sys/devices/system/cpu/cpu${i}/cpufreq/${CpuFreqToQuery} ] && \
			cat /sys/devices/system/cpu/cpu${i}/cpufreq/${CpuFreqToQuery} >"${TempDir}/Reported-${1}.${i}"
	done
	for job in $(jobs -p) ; do
		wait ${job}
	done
	for i in $(seq 0 $(( ${CPUCores} -1 )) ) ; do
		MeasuredSpeed=$(awk -F" cpu_MHz=" '{print $2}' <"${TempDir}/CheckAllCores-${1}.${i}" | awk -F" " '{print $1}' | sort -r -n | tr '\n' '/' | sed 's|/$||')
		SpeedSum=$(tr '/' '\n' <<<"${MeasuredSpeed}" | tr -d '.' | awk '{s+=$1} END {printf "%.0f", s}')
		RoundedSpeed=$(( ${SpeedSum} / 3000 ))
		if [ -s "${TempDir}/Reported-${1}.${i}" ]; then
			read ReportedSpeed <"${TempDir}/Reported-${1}.${i}"
			echo -e "cpu${i}: ${RoundedSpeed}/$(( ${ReportedSpeed} / 1000 )) MHz (${MeasuredSpeed})"
		else
			echo -e "cpu${i}: ${RoundedSpeed} MHz (${MeasuredSpeed})"
		fi
	done
} # CheckAllCores

RunTinyMemBench() {
	if [ "X${MODE}" = "Xextensive" ] || [ "X${REVIEWMODE}" = "Xtrue" ] || [ "X${ExecuteStockfish}" = "Xyes" ]; then
		# extensive/review mode or yet unknown stockfish run time, do not print any duration estimates
		echo -e "\x08\x08 Done."
	else
		echo -e "\x08\x08 Done (results will be available in $(( ${EstimatedDuration} * 120 / 100 ))-$(( ${EstimatedDuration} * 180 / 100 )) minutes)."
	fi

	# if we're not running with MODE=extensive shorten tinymembench execution drastically.
	# TODO: Adjust time estimates
	[ "X${MODE}" = "Xextensive" ] || TMBOptions="-b 2 -B 3 -l 3 -c 1000000"

	echo -e "Executing tinymembench...\c"
	echo -e "System health while running tinymembench:\n" >"${MonitorLog}"
	if [ "X${MODE}" = "Xextensive" ]; then
		/bin/bash "${PathToMe}" -m $(( 40 * ${#ClusterConfig[@]} )) >>"${MonitorLog}" &
	else
		/bin/bash "${PathToMe}" -m $(( 10 * ${#ClusterConfig[@]} )) >>"${MonitorLog}" &
	fi
	MonitoringPID=$!
	echo -n "" >"${TempLog}"
	for i in $(seq 0 $(( ${#ClusterConfig[@]} -1 )) ) ; do
		CoresOnline ${ClusterConfig[$i]}
		if [ $? -eq 0 ]; then
			CPUInfo="$(GetCPUInfo ${ClusterConfig[$i]})"
			echo -e "\nExecuting benchmark on cpu${ClusterConfig[$i]}${CPUInfo}:\n" >>"${TempLog}"
			[ -s "${NetioConsumptionFile}" ] && snore 10
			taskset -c ${ClusterConfig[$i]} "${InstallLocation}"/tinymembench/tinymembench ${TMBOptions} >>"${TempLog}" 2>&1
		fi
	done
	kill ${MonitoringPID}
	echo -e "\n##########################################################################" >>"${ResultLog}"
	cat "${TempLog}" >>"${ResultLog}"
	MemCpyScore="$(awk -F" " '/^ libc memcpy copy/ {print $5}' <"${TempLog}" | sort -n | tail -n1)"
	MemSetScore="$(awk -F" " '/^ libc memset fill/ {print $5}' <"${TempLog}" | sort -n | tail -n1)"
	# round results
	MemBenchScore="$(( $(awk '{printf ("%0.0f",$1/10); }' <<<"${MemCpyScore}" ) * 10 )) | $(( $(awk '{printf ("%0.0f",$1/10); }' <<<"${MemSetScore}" ) * 10 ))"
} # RunTinyMemBench

RunRamlat() {
	if [ -x "${InstallLocation}"/ramspeed/ramlat ]; then
		echo -e "\x08\x08 Done.\nExecuting RAM latency tester...\c"
		echo -e "\nSystem health while running ramlat:\n" >>"${MonitorLog}"
		/bin/bash "${PathToMe}" -m $(( ${#ClusterConfig[@]} * 3 )) >>"${MonitorLog}" &
		MonitoringPID=$!
		echo -n "" >"${TempLog}"
		for i in $(seq 0 $(( ${#ClusterConfig[@]} -1 )) ) ; do
			CoresOnline ${ClusterConfig[$i]}
			if [ $? -eq 0 ]; then
				CPUInfo="$(GetCPUInfo ${ClusterConfig[$i]})"
				echo -e "\nExecuting ramlat on cpu${ClusterConfig[$i]}${CPUInfo}, results in ns:\n" >>"${TempLog}"
				taskset -c ${ClusterConfig[$i]} "${InstallLocation}"/ramspeed/ramlat -n -w "12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27" 200 \
					| sed -e 's/^/    /' >>"${TempLog}" 2>&1
			fi
		done
		kill ${MonitoringPID}
		echo -e "\n##########################################################################" >>"${ResultLog}"
		cat "${TempLog}" >>"${ResultLog}"
	fi
} # RunRamlat

Run7ZipBenchmark() {
	echo -e "\x08\x08 Done.\nExecuting 7-zip benchmark...\c"
	echo -e "\nSystem health while running 7-zip single core benchmark:\n" >>"${MonitorLog}"
	echo -e "\c" >"${TempLog}"
	# determine available RAM and adjust monitoring interval + dictionary size if necessary
	TotalMem=$(free | awk -F" " '/^Mem:   / {print $7}' | tail -n1)
	[ ${TotalMem:-350000} -lt 350000 ] && DictSize="-md=2m"
	MemAdjustment=$(( $(( 1250000 / ${TotalMem} )) / 3 ))
	if [ ${MemAdjustment} = 0 ]; then
		MonInterval=$(( ${SingleThreadedDuration} / 8 ))
	else
		MonInterval=$(( ${SingleThreadedDuration} / $(( 8 * ${MemAdjustment} )) ))
	fi
	[ ${MonInterval:-0} -lt 5 ] && MonInterval=5
	[ ${MonInterval:-0} -gt 15 ] && MonInterval=15
	/bin/bash "${PathToMe}" -m ${MonInterval} >>"${MonitorLog}" &
	MonitoringPID=$!
	if [ ${#ClusterConfig[@]} -eq 1 ]; then
		# Only cpu0 or single CPU cluster
		CPUInfo="$(GetCPUInfo 0)"
		echo -e "\nExecuting benchmark single-threaded on cpu0${CPUInfo}" >>"${TempLog}"
		[ -s "${NetioConsumptionFile}" ] && snore 10
		taskset -c 0 "${SevenZip}" b ${DictSize} -mmt=1 >>"${TempLog}" 2>/dev/null
	else
		# test each cluster individually
		for i in $(seq 0 $(( ${#ClusterConfig[@]} -1 )) ) ; do
			CoresOnline ${ClusterConfig[$i]}
			if [ $? -eq 0 ]; then
				CPUInfo="$(GetCPUInfo ${ClusterConfig[$i]})"
				echo -e "\nExecuting benchmark single-threaded on cpu${ClusterConfig[$i]}${CPUInfo}" >>"${TempLog}"
				[ -s "${NetioConsumptionFile}" ] && snore 10
				taskset -c ${ClusterConfig[$i]} "${SevenZip}" b ${DictSize} -mmt=1 >>"${TempLog}" 2>/dev/null
			fi
		done
	fi	
	kill ${MonitoringPID}
	echo -e "\n##########################################################################" >>"${ResultLog}"
	cat "${TempLog}" >>"${ResultLog}"
	ZipScoreSingleThreaded=$(awk -F" " '/^Tot:/ {print $4}' "${TempLog}" | sort -n | tail -n1)

	if [ ${CPUCores} -gt 1 ]; then
		# run multi-threaded test only if there's more than one CPU core
		echo -e "\nSystem health while running 7-zip multi core benchmark:\n" >>"${MonitorLog}"
		echo -e "\c" >"${TempLog}"
		if [ ${MemAdjustment} = 0 ]; then
			MonInterval=$(( ${MultiThreadedDuration} / 3 ))
		else
			MonInterval=$(( ${MultiThreadedDuration} / $(( 3 * ${MemAdjustment} )) ))
		fi
		[ ${MonInterval:-0} -lt 10 ] && MonInterval=10
		[ ${MonInterval:-0} -gt 30 ] && MonInterval=30
		/bin/bash "${PathToMe}" -m ${MonInterval} >>"${MonitorLog}" &
		MonitoringPID=$!
		echo -e "Executing benchmark ${RunHowManyTimes} times multi-threaded on CPUs $(cat /sys/devices/system/cpu/online)" >>"${TempLog}"
		for ((i=1;i<=RunHowManyTimes;i++)); do
			"${SevenZip}" b ${DictSize} -mmt=${CPUCores} >>"${TempLog}" 2>/dev/null
		done
		kill ${MonitoringPID}
		echo -e "\n##########################################################################\n" >>"${ResultLog}"
		cat "${TempLog}" >>"${ResultLog}"
		# create average score from all finished benchmark runs (7-zip can get oom-killed)
		FinishedRuns=$(grep -c '^Tot:' "${TempLog}")
		[ ${FinishedRuns} -ne 0 ] && CombinedScore=$(( $(awk -F" " '/^Tot:/ {s+=$4} END {printf "%.0f", s}' <"${TempLog}") / ${FinishedRuns} ))
	else
		# use the single score instead on a single core machine
		CombinedScore=$(awk -F" " '/^Tot:/ {print $4}' <"${TempLog}")
	fi

	sed -i 's/|//' "${TempLog}"
	CompScore=$(awk -F" " '/^Avr:/ {print $4}' <"${TempLog}" | tr '\n' ', ' | sed 's/,$//')
	DecompScore=$(awk -F" " '/^Avr:/ {print $7}' <"${TempLog}" | tr '\n' ', ' | sed 's/,$//')
	TotScore=$(awk -F" " '/^Tot:/ {print $4}' <"${TempLog}" | tr '\n' ', ' | sed 's/,$//')
	echo -e "\nCompression: ${CompScore}" >>"${ResultLog}"
	echo -e "Decompression: ${DecompScore}" >>"${ResultLog}"
	echo -e "Total: ${TotScore}" >>"${ResultLog}"
	# round result
	ZipScore="$(( $(awk '{printf ("%0.0f",$1/10); }' <<<"${CombinedScore}" ) * 10 ))"

	if [ ${#ClusterConfigByCoreType[@]} -ne 1 ] && [ "X${MODE}" = "Xextensive" ]; then
		# extensive mode: we're testing additionally through each CPU core cluster
		echo -e "\nSystem health while running 7-zip cluster benchmarks:\n" >>"${MonitorLog}"
		echo -e "\c" >"${TempLog}"
		/bin/bash "${PathToMe}" -m $(( ${MonInterval} * ${#ClusterConfigByCoreType[@]} )) >>"${MonitorLog}" &
		MonitoringPID=$!

		for i in $(seq 0 $(( ${#ClusterConfigByCoreType[@]} -1 )) ) ; do
			CoresOnline ${ClusterConfigByCoreType[$i]}
			if [ $? -eq 0 ]; then
				FirstCore=${ClusterConfigByCoreType[$i]}
				CPUInfo="$(GetCPUInfo ${FirstCore})"
				LastCore=$(GetLastClusterCoreByType $(( $i + 1 )))
				HowManyCores=$(( $(( ${LastCore} - ${FirstCore} )) + 1 ))
				if [ ${FirstCore} -eq ${LastCore} ]; then
					echo -e "\nExecuting benchmark ${RunHowManyTimes} times single-threaded on CPU ${FirstCore}${CPUInfo}" >>"${TempLog}"
				else
					echo -e "\nExecuting benchmark ${RunHowManyTimes} times multi-threaded on CPUs ${FirstCore}-${LastCore}${CPUInfo}" >>"${TempLog}"
				fi
				for ((o=1;o<=RunHowManyTimes;o++)); do
					taskset -c ${FirstCore}-${LastCore} "${SevenZip}" b ${DictSize} -mmt=${HowManyCores} >>"${TempLog}" 2>/dev/null
				done
			fi
		done

		kill ${MonitoringPID}
		echo -e "\n##########################################################################\n" >>"${ResultLog}"
		cat "${TempLog}" >>"${ResultLog}"
	fi
} # Run7ZipBenchmark

RunOpenSSLBenchmark() {
	echo -e "\x08\x08 Done.\nExecuting OpenSSL benchmark...\c"
	echo -e "\nSystem health while running OpenSSL benchmark:\n" >>"${MonitorLog}"
	echo -e "\n##########################################################################\n" >>"${ResultLog}"
	/bin/bash "${PathToMe}" -m 16 >>"${MonitorLog}" &
	MonitoringPID=$!
	OpenSSLLog="${TempDir}/openssl.log"
	if [ ${#ClusterConfig[@]} -eq 1 ]; then
		# all CPU cores have same package id, we execute openssl twice
		CPUInfo="$(GetCPUInfo 0)"
		echo -e "Executing benchmark twice on cluster 0${CPUInfo}\n" >>"${ResultLog}"
		for bytelength in $1 ; do
			openssl speed -elapsed -evp aes-${bytelength}-cbc 2>/dev/null
			openssl speed -elapsed -evp aes-${bytelength}-cbc 2>/dev/null
		done | tr '[:upper:]' '[:lower:]' >"${OpenSSLLog}"
		# add both scores and divide by two to get an average
		AES256=$(( $(awk '/^aes-256-cbc/ {print $7}' <"${OpenSSLLog}" | awk -F"." '{s+=$1} END {printf "%.0f", s}') / 2 ))
		[ "X${MODE}" = "Xextensive" ] && openssl speed -elapsed -evp aes-256-gcm 2>/dev/null | tr '[:upper:]' '[:lower:]' >>"${OpenSSLLog}"
	else
		# different package ids, we walk through all clusters
		echo -e "Executing benchmark on each cluster individually\n" >>"${ResultLog}"
		for bytelength in $1 ; do
			for i in $(seq 0 $(( ${#ClusterConfig[@]} -1 )) ) ; do
				CoresOnline ${ClusterConfig[$i]}
				if [ $? -eq 0 ]; then
					CPUInfo="$(GetCPUInfo ${ClusterConfig[$i]})"
					taskset -c ${ClusterConfig[$i]} openssl speed -elapsed -evp aes-${bytelength}-cbc 2>/dev/null \
						| tr '[:upper:]' '[:lower:]' | sed "/^aes/ s/$/${CPUInfo}/"
					if [ "X${MODE}" = "Xextensive" ] && [ ${bytelength} -eq 256 ]; then
						openssl speed -elapsed -evp aes-256-gcm 2>/dev/null | tr '[:upper:]' '[:lower:]' | sed "/^aes/ s/$/${CPUInfo}/"
					fi
				fi
			done
		done >"${OpenSSLLog}"
		# check aes-256-cbc scores and choose highest for reporting
		AES256=$(awk '/^aes-256-cbc/ {print $7}' <"${OpenSSLLog}" | awk -F"." '{print $1}' | sort -n | tail -n1)
	fi
	kill ${MonitoringPID}
	echo -e "$(openssl version | awk -F" " '{print $1" "$2", built on "$3" "$4" "$5" "$6" "$7" "$8" "$9" "$10" "$11" "$12" "$13" "$14" "$15}' | sed 's/ *$//')\n$(grep '^type' "${OpenSSLLog}" | head -n1)" >>"${ResultLog}"
	grep '^aes-' ${OpenSSLLog} >>"${ResultLog}"
	# round result
	OpenSSLScore="$(( $(awk '{printf ("%0.0f",$1/10); }' <<<"${AES256}") * 10 ))"

	if [ "X${MODE}" = "Xextensive" ]; then
		# in extensive mode run openssl benchmarks on all cores in parallel
		echo -e "\nSystem health while running parallel OpenSSL benchmarks:\n" >>"${MonitorLog}"
		/bin/bash "${PathToMe}" -m 4 >>"${MonitorLog}" &
		MonitoringPID=$!
		for ((o=1;o<=CPUCores;o++)); do
			taskset -c $(( ${o} - 1 )) openssl speed -elapsed -evp aes-256-cbc 2>/dev/null >"${TempDir}"/openssl.log.cbc.${o} &
		done
		snore 25
		for ((o=1;o<=CPUCores;o++)); do
			taskset -c $(( ${o} - 1 )) openssl speed -elapsed -evp aes-256-gcm 2>/dev/null >"${TempDir}"/openssl.log.gcm.${o} &
		done
		snore 25
		grep '^aes-256-cbc' "${TempDir}"/openssl.log.* | cut -f2 -d':' | sort -r -n | sed "/^aes/ s/$/ (fully parallel)/" >>"${ResultLog}"
		grep '^aes-256-gcm' "${TempDir}"/openssl.log.* | cut -f2 -d':' | sort -r -n | sed "/^aes/ s/$/ (fully parallel)/" >>"${ResultLog}"
		kill ${MonitoringPID}
	fi
} # RunOpenSSLBenchmark

RunCpuminerBenchmark() {
	if [ "X${REVIEWMODE}" = "Xtrue" ]; then
		echo -e "\x08\x08 Done.\nThrottling test: heating up the device, 5 more minutes to wait...\c"
	else
		echo -e "\x08\x08 Done.\nExecuting cpuminer. 5 more minutes to wait...\c"
	fi
	echo -e "\nSystem health while running cpuminer:\n" >>"${MonitorLog}"
	/bin/bash "${PathToMe}" -m 40 >>"${MonitorLog}" &
	MonitoringPID=$!
	"${InstallLocation}"/cpuminer-multi/cpuminer --benchmark --cpu-priority=2 >"${TempLog}" &
	MinerPID=$!
	snore 300
	kill ${MinerPID} ${MonitoringPID}
	echo -e "\n##########################################################################\n" >>"${ResultLog}"
	sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" <"${TempLog}" >>"${ResultLog}"
	# Summarized 'Total:' scores, we need to skip the 1st or even better the two first since
	# sometimes significantly lower which could then be misinterpreted as silent throttling
	MinerRuns=$(grep -c " Total:" "${TempLog}")
	if [ ${MinerRuns:-0} -ge 10 ]; then
		# skip two first scores when more than 10 cpuminer scores could be generated
		TotalScores="$(awk -F" " '/Total:/ {print $4}' "${TempLog}" | tail -n +3 | sort -r -n | uniq | tr '\n' ', ' | sed 's/,$//')"
	else
		# skip only 1st score
		TotalScores="$(awk -F" " '/Total:/ {print $4}' "${TempLog}" | tail -n +2 | sort -r -n | uniq | tr '\n' ', ' | sed 's/,$//')"
	fi
	echo -e "\nTotal Scores: ${TotalScores}" >>"${ResultLog}"
	CpuminerScore="$(awk -F"," '{print $2}' <<<"${TotalScores}")"
} # RunCpuminerBenchmark

RunStressNG() {
	case ${OperatingSystem,,} in
		"arch linux"*|*manjaro*)
			StressCommand="stress --cpu ${CPUCores} --io ${CPUCores} --vm ${CPUCores} --vm-bytes 128M"
			;;
		*)
			StressCommand="stress-ng --matrix 0"
			;;
	esac

	if [ "X${REVIEWMODE}" = "Xtrue" ]; then
		echo -e "\x08\x08 Done.\nThrottling test: heating up the device, 5 more minutes to wait...\c"
	else
		echo -e "\x08\x08 Done.\nExecuting ${StressCommand%% *}. 5 more minutes to wait...\c"
	fi
	echo -e "\nSystem health while running ${StressCommand%% *}:\n" >>"${MonitorLog}"
	/bin/bash "${PathToMe}" -m 40 >>"${MonitorLog}" &
	MonitoringPID=$!
	echo -e "Executing \"${StressCommand}\" for 5 minutes:\n" >"${TempLog}"
	${StressCommand} -t 300 >>"${TempLog}" 2>&1
	kill ${MonitoringPID}
	echo -e "\n##########################################################################\n" >>"${ResultLog}"
	sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" <"${TempLog}" >>"${ResultLog}"
} # RunStressNG

RunStockfishBenchmark() {
	echo -e "\x08\x08 Done.\nExecuting stockfish benchmark...\c"
	echo -e "\nSystem health while running stockfish:\n" >>"${MonitorLog}"
	/bin/bash "${PathToMe}" -m 60 >>"${MonitorLog}" &
	MonitoringPID=$!
	cd "${InstallLocation}/Stockfish-sf_15/src" || exit 1
	echo "" >"${TempLog}"
	for ((i=1;i<=RunHowManyTimes;i++)); do
		echo -e "setoption name EvalFile value ${NeuralNetwork} \n bench 128 ${CPUCores} 24 default depth" | ./stockfish 2>>"${TempLog}" >/dev/null
	done
	kill ${MonitoringPID}
	echo -e "\n##########################################################################\n" >>"${ResultLog}"
	echo -e "Executing Stockfish 15 using ${NeuralNetwork} ${RunHowManyTimes} times in a row:\n" >>"${ResultLog}"
	sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" <"${TempLog}" | sed -e '/^$/d' -e '/^============/i \ ' -e '/second/a \ ' >>"${ResultLog}"
	StockfishScores="$(awk -F": " '/^Nodes\/second/ {print $2}' <"${TempLog}" | tr '\n' ', ' | sed 's/,$//')"
	echo -e "Total Scores (${NeuralNetwork}): ${StockfishScores}" >>"${ResultLog}"
} # RunStockfishBenchmark

RunPTS() {
	# executing phoronix-test-suite
	echo -e "\x08\x08 Done.\nExecuting phoronix-test-suite...\c"

	# if the CPU contains clusters of different CPU cores, test them individually first
	if [ ${#ClusterConfigByCoreType[@]} -ne 1 ]; then
		echo -e "\nSystem health while running Phoronix Test Suite cluster benchmarks:\n" >>"${MonitorLog}"
		/bin/bash "${PathToMe}" -m $(( 60 * ${#ClusterConfigByCoreType[@]} )) >>"${MonitorLog}" &
		MonitoringPID=$!

		for i in $(seq 0 $(( ${#ClusterConfigByCoreType[@]} -1 )) ) ; do
			CoresOnline ${ClusterConfigByCoreType[$i]}
			if [ $? -eq 0 ]; then
				FirstCore=${ClusterConfigByCoreType[$i]}
				CPUInfo="$(GetCPUInfo ${FirstCore})"
				LastCore=$(GetLastClusterCoreByType $(( $i + 1 )))
				HowManyCores=$(( $(( ${LastCore} - ${FirstCore} )) + 1 ))
				# try to send as much cores as possible offline (cpu0 can't be sent offline)
				for o in $(seq ${FirstOfflineCPU} $(( ${CPUCores} - 1 )) ); do
					if [ $o -lt ${FirstCore} ] || [ $o -gt ${LastCore} ]; then
						echo 0 > /sys/devices/system/cpu/cpu${o}/online 2>/dev/null
					fi
				done
				PTS_SILENT_MODE=1 phoronix-test-suite batch-run ${PTSArguments} >"${TempLog}" 2>&1
				ResultsURL="$(awk -F"https" '/Results Uploaded To/ {print $2}' <"${TempLog}")"
				if [ "X${ResultsURL}" = "X" ]; then
					echo -e "\x08\x08 Failed.\n$(cat "${TempLog}")\n"
					grep -q 'is not installed' "${TempLog}" && \
						echo -e "\nTry to manually resolve problems by \"phoronix-test-suite install ${PTSArguments}\""
					exit 1
				else
					echo -e "\n##########################################################################\n" >>"${ResultLog}"
					sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" <"${TempLog}" >>"${ResultLog}"
				fi
				# bring back offline cores
				for o in $(seq ${FirstOfflineCPU} $(( ${CPUCores} - 1 )) ); do
					echo 1 >/sys/devices/system/cpu/cpu${o}/online
					[ -f /sys/devices/system/cpu/cpufreq/policy${o}/scaling_governor ] && \
						echo performance >/sys/devices/system/cpu/cpufreq/policy${o}/scaling_governor 2>/dev/null
					snore 0.5
					[ -f /sys/devices/system/cpu/cpufreq/policy${o}/scaling_governor ] && \
						echo performance >/sys/devices/system/cpu/cpufreq/policy${o}/scaling_governor 2>/dev/null
				done
			fi
		done

		kill ${MonitoringPID}
	fi

	echo -e "\nSystem health while running Phoronix Test Suite:\n" >>"${MonitorLog}"
	/bin/bash "${PathToMe}" -m 60 >>"${MonitorLog}" &
	MonitoringPID=$!
	PTS_SILENT_MODE=1 phoronix-test-suite batch-run ${PTSArguments} >"${TempLog}"
	kill ${MonitoringPID}
	ResultsURL="$(awk -F"https" '/Results Uploaded To/ {print $2}' <"${TempLog}")"
	if [ "X${ResultsURL}" = "X" ]; then
		echo -e "\x08\x08 Failed.\n$(cat "${TempLog}")\n"
		grep -q 'is not installed' "${TempLog}" && \
			echo -e "\nTry to manually resolve problems by \"phoronix-test-suite install ${PTSArguments}\""
		exit 1
	else
		echo -e "\n##########################################################################\n" >>"${ResultLog}"
		sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" <"${TempLog}" >>"${ResultLog}"
	fi
} # RunPTS

BoostGB() {
	snore 1 && for i in $(pgrep geekbench) ; do renice -20 "${i}" >/dev/null 2>&1 ; done
} # BoostGB

RunGB() {
	# executing geekbench5 in a sane and monitored environment
	echo -e "\x08\x08 Done.\nExecuting Geekbench...\n"
	MonitorInterval=$(( ${QuickAndDirtyPerformance} / 10000000 ))

	# if the CPU contains clusters of different CPU cores, test them individually first
	if [ ${#ClusterConfigByCoreType[@]} -ne 1 ]; then
		echo -e "\nSystem health while running Geekbench cluster benchmarks:\n" >>"${MonitorLog}"
		/bin/bash "${PathToMe}" -m $(( ${MonitorInterval} * ${#ClusterConfigByCoreType[@]} )) >>"${MonitorLog}" &
		MonitoringPID=$!

		for i in $(seq 0 $(( ${#ClusterConfigByCoreType[@]} -1 )) ) ; do
			CoresOnline ${ClusterConfigByCoreType[$i]}
			if [ $? -eq 0 ]; then
				FirstCore=${ClusterConfigByCoreType[$i]}
				CPUInfo="$(GetCPUInfo ${FirstCore})"
				LastCore=$(GetLastClusterCoreByType $(( $i + 1 )))
				HowManyCores=$(( $(( ${LastCore} - ${FirstCore} )) + 1 ))
				# try to send as much cores as possible offline (cpu0 can't be sent offline)
				for o in $(seq ${FirstOfflineCPU} $(( ${CPUCores} - 1 )) ); do
					if [ $o -lt ${FirstCore} ] || [ $o -gt ${LastCore} ]; then
						echo 0 > /sys/devices/system/cpu/cpu${o}/online 2>/dev/null
					fi
				done
				echo -e "\n${BOLD}Executing on cores ${FirstCore}-${LastCore}${NC}\n"
				BoostGB &
				taskset -c ${FirstCore}-${LastCore} "${GBBinary}" 2>&1 | tee "${TempLog}"
				ResultsURL="$(awk -F"https" '/browser.geekbench.com/ {print $2}' <"${TempLog}" | head -n1)"
				if [ "X${ResultsURL}" = "X" ]; then
					echo -e "\x08\x08 Failed...\c"
				else
					echo -e "\n##########################################################################\n" >>"${ResultLog}"
					if [ ${FirstCore} -eq ${LastCore} ]; then
						echo -e "Executing Geekbench on core ${FirstCore}${CPUInfo}\n" >>"${ResultLog}"
						ResultList="${TempDir}/${FirstCore}.lst"
					else
						echo -e "Executing Geekbench on cores ${FirstCore}-${LastCore}${CPUInfo}\n" >>"${ResultLog}"
						ResultList="${TempDir}/${FirstCore}-${LastCore}.lst"
					fi
					echo -e "\n  https${ResultsURL}\n" >>"${ResultLog}"
					links -dump "https${ResultsURL}" >"${TempLog}"
					case ${GBVersion} in
						5.*)
							grep ' Score ' "${TempLog}" | sed '/Multi-Core*/i \ \ \ ' | sed 's/^\ //' >>${ResultList}
							echo -e "\n  Single-Core Performance" >>${ResultList}
							sed '1,/^  Single-Core Performance$/d' "${TempLog}" | grep -v -E '/sec| FPS| Score' | head -n46 >>${ResultList}
							;;
						6.*)
							grep ' Score ' "${TempLog}" | sed 's/^\ //' >>${ResultList}
							echo -e "\n  Single-Core Performance" >>${ResultList}
							sed '1,/^  Single-Core Performance$/d' "${TempLog}" | grep -v -E '/sec| FPS| Score' | head -n36 >>${ResultList}
							;;
					esac
					cat ${ResultList} >>"${ResultLog}"
				fi
				# bring back offline cores
				for o in $(seq ${FirstOfflineCPU} $(( ${CPUCores} - 1 )) ); do
					echo 1 >/sys/devices/system/cpu/cpu${o}/online
					[ -f /sys/devices/system/cpu/cpufreq/policy${o}/scaling_governor ] && \
						echo performance >/sys/devices/system/cpu/cpufreq/policy${o}/scaling_governor 2>/dev/null
					snore 0.5
					[ -f /sys/devices/system/cpu/cpufreq/policy${o}/scaling_governor ] && \
						echo performance >/sys/devices/system/cpu/cpufreq/policy${o}/scaling_governor 2>/dev/null
				done
			fi
		done

		kill ${MonitoringPID}
	fi

	# run Geekbench on all cores twice
	echo -e "\nSystem health while running Geekbench on all cores:\n" >>"${MonitorLog}"
	/bin/bash "${PathToMe}" -m ${MonitorInterval} >>"${MonitorLog}" &
	MonitoringPID=$!
	echo -e "\n${BOLD}Executing on all cores 1st time${NC}\n"
	BoostGB &
	"${GBBinary}" 2>&1 | tee "${TempLog}"
	echo ""
	GBFullString="$(awk -F" : " "/^Geekbench ${GBVersion}./ {print \$1}" "${TempLog}")"
	GBSystemInfo="$(grep -A25 "Gathering system information" "${TempLog}" | tail -n +2 | grep -B25 " Size ")"
	TempLog2="${TempDir}/temp2.log"
	echo -e "${BOLD}Executing on all cores 2nd time${NC}\n"
	BoostGB &
	"${GBBinary}" 2>&1 | tee "${TempLog2}"
	kill ${MonitoringPID}
	ResultsURL="$(awk -F"https" '/browser.geekbench.com/ {print $2}' <"${TempLog}" | head -n1)"
	ResultsURL2="$(awk -F"https" '/browser.geekbench.com/ {print $2}' <"${TempLog2}" | head -n1)"
	ClaimURL="$(awk -F"https" '/browser.geekbench.com/ {print $2}' <"${TempLog2}" | tail -n1)"
	if [ "X${ResultsURL}" = "X" ] || [ "X${ResultsURL2}" = "X" ]; then
		echo -e "\x08\x08 Failed.\c..."
	else
		echo -e "\n##########################################################################\n" >>"${ResultLog}"
		echo -e "Executing Geekbench on all cores twice\n" >>"${ResultLog}"
		ResultList="${TempDir}/all-1st.lst"
		links -dump "https${ResultsURL}" >"${TempLog}"
		links -dump "https${ResultsURL2}" >"${TempLog2}"
		case ${GBVersion} in
			5.*)
				sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" <"${TempLog}" | sed '/add this result to your profile/,+3 d' | \
					sed '/Geekbench 5 license/,+4 d' | sed '/active Internet connection/,+2 d' | \
					sed '/preview build/,+1 d' | sed '/Single-Core/,+22 d' | sed '/Multi-Core/,+22 d' | \
					sed '/Uploading results/,+4 d' | sed 's|: https://www.geekbench.com/||' >>"${ResultLog}"
				grep ' Score ' "${TempLog}" | sed '/Multi-Core*/i \ \ \ ' | sed 's/^\ //' >${ResultList}
				echo -e "\n  Single-Core Performance" >>${ResultList}
				sed '1,/^  Single-Core Performance$/d' "${TempLog}" | grep -v -E '/sec| FPS| Score' | head -n46 >>${ResultList}
				cat ${ResultList} >>"${ResultLog}"
				ResultList="${TempDir}/all-2nd.lst"
				echo -e "\n  https${ClaimURL}\n" >>"${ResultLog}"
				grep ' Score ' "${TempLog2}" | sed '/Multi-Core*/i \ \ \ ' | sed 's/^\ //' >${ResultList}
				echo -e "\n  Single-Core Performance" >>${ResultList}
				sed '1,/^  Single-Core Performance$/d' "${TempLog2}" | grep -v -E '/sec| FPS| Score' | head -n46 >>${ResultList}
				cat ${ResultList} >>"${ResultLog}"
				;;
			6.*)
				echo -e "${GBFullString}\n\n${GBSystemInfo}\n" >>"${ResultLog}"
				grep ' Score ' "${TempLog}" | sed 's/^\ //' >${ResultList}
				echo -e "\n  Single-Core Performance" >>${ResultList}
				sed '1,/^  Single-Core Performance$/d' "${TempLog}" | grep -v -E '/sec| FPS| Score' | head -n36 >>${ResultList}
				cat ${ResultList} >>"${ResultLog}"
				ResultList="${TempDir}/all-2nd.lst"
				echo -e "\n  https${ClaimURL}\n" >>"${ResultLog}"
				grep ' Score ' "${TempLog2}" | sed 's/^\ //' >${ResultList}
				echo -e "\n  Single-Core Performance" >>${ResultList}
				sed '1,/^  Single-Core Performance$/d' "${TempLog2}" | grep -v -E '/sec| FPS| Score' | head -n36 >>${ResultList}
				cat ${ResultList} >>"${ResultLog}"
				;;
		esac
		# create a results table on SoCs with different clusters
		if [ ${#ClusterConfigByCoreType[@]} -ne 1 ]; then
			CreateGBResultsTable | sed 's/ HTML /HTML5 /' >>"${ResultLog}"
		fi
		CompareURL="https://browser.geekbench.com/v${GBVersion:0:1}/cpu/compare/${ResultsURL##*/}?baseline=${ResultsURL2##*/}"
		echo -e "\n\n${CompareURL}" >>"${ResultLog}"
	fi
	echo -e "\nGeekbench execution...\c"
} # RunGB

CreateGBResultsTable() {
	cd "${TempDir}/" || exit 1
	echo -e "\n##########################################################################\n"
	echo -e "All Geekbench results:\n\n                         \c"
	for o in *.lst ; do
		printf "%10s" "${o%.*}" | sed 's/all-/all /g'
	done
	echo ""
	for i in $(seq 1 $(wc -l <"${ResultList}") ); do
		for o in *.lst ; do
			case $o in
				0*)
					printf "\n%25s" "$(sed -n ${i}p <$o | cut -c-26 | tr -d '[:digit:]')"
					;;
			esac
			printf "%10s" $(sed -n ${i}p <$o | cut -c25- | tr -d -c '[:digit:]')
		done
	done
} # CreateGBResultsTable

PrintCPUTopology() {
	# prints list of CPU cores, clusters and cpufreq policy nodes
	CPUFreqPolicy="none"
	echo "CPU sysfs topology (clusters, cpufreq members, clockspeeds)"
	echo "                 cpufreq   min    max"
	echo " CPU    cluster  policy   speed  speed   core type"
	FirstCoreName="$(GetCoreType 0)"
	FirstCoreStepping="$(GetARMStepping 0)"
	for i in $(seq 0 $(( ${CPUCores} - 1 )) ); do
		CoreName="$(GetCoreType $i)"
		# check if CoreName is empty
		if [ "X${CoreName}" = "X" ]; then
			case ${CPUArchitecture} in
				*86*)
					# try to return microarchitecture instead of CPU name on x86 if available
					if [[ ${CPUFetchInfo} != *Unknown* ]]; then
						uArch="$(awk -F':' '/Microarchitecture:|uArch:/ {print $2}' <<<"${CPUFetchInfo}" | sed "s/^[ \t]*//")"
						if [ "X${uArch}" = "X" ]; then
							CoreName="${X86CPUName}"
						else
							CoreName="${uArch}"
						fi
					fi
					;;
				*arm*|*aarch*)
					# On ARM with older kernels core/stepping info might only be available
					# for cpu0 so use this instead
					[ -n "${FirstCoreName}" ] && CoreName="${FirstCoreName} / ${FirstCoreStepping}"
					;;
			esac
		else
			CoreStepping="$(GetARMStepping $i)"
			if [ "X${CoreStepping}" != "X" ]; then
				CoreName="${CoreName} / ${CoreStepping}"
			fi
		fi
		[ -f /sys/devices/system/cpu/cpu${i}/topology/physical_package_id ] && \
			read CPUCluster </sys/devices/system/cpu/cpu${i}/topology/physical_package_id
		if [ -d /sys/devices/system/cpu/cpufreq/policy${i} ]; then
			CPUFreqPolicy=${i}
			CPUSpeedMin=$(awk '{printf ("%0.0f",$1/1000); }' </sys/devices/system/cpu/cpufreq/policy${i}/cpuinfo_min_freq)
			CPUSpeedMax=$(awk '{printf ("%0.0f",$1/1000); }' </sys/devices/system/cpu/cpufreq/policy${i}/cpuinfo_max_freq)
		fi
		if [ -z ${CPUFreqPolicy} ] || [ "${CPUFreqPolicy}" = "none" ]; then
			echo "$(printf "%3s" ${i})$(printf "%9s" ${CPUCluster})        0       -      -     ${CoreName:-"    -"}"
		else
			echo "$(printf "%3s" ${i})$(printf "%9s" ${CPUCluster})$(printf "%9s" ${CPUFreqPolicy})$(printf "%9s" ${CPUSpeedMin})$(printf "%8s" ${CPUSpeedMax})   ${CoreName:-"    -"}"
		fi
	done
	echo ""
} # PrintCPUTopology

CheckMemoryDevfreqTransitions() {
	Transitions="$(find /sys/devices/platform -name trans_stat 2>/dev/null | grep -E "memory|dmc|ddr")"
	if [ "X${Transitions}" = "X" ]; then
		return
	fi
	UpTime=$(awk -F" " '{print $1*1000}' </proc/uptime)
	echo -e "\n##########################################################################\n"
	echo -e "DRAM clock transitions since last boot (${UpTime} ms ago):\n"
	echo "${Transitions}" | while read ; do
		echo -e "${REPLY%/*}:\n"
		cat "${REPLY}"
	done
} # CheckMemoryDevfreqTransitions

SummarizeResults() {
	# report rounded up benchmark duration
	BenchmarkFinishedTime=$(date +"%s")
	BenchmarkDuration=$(( $(( ${BenchmarkFinishedTime} - ${BenchmarkStartTime} +59 )) / 60 ))
	echo -e "\x08\x08 Done (${BenchmarkDuration} minutes elapsed).\n\007\007\007"

	# recheck for aarch64 since for some SoC guesses measured clockspeeds are needed
	[ "${CPUArchitecture}" = "aarch64" ] && GuessedSoC="$(GuessARMSoC)"

	# only check for throttling in normal mode and not when plotting performance/mhz graphs
	SwapNow="$(awk -F" " '{print $4}' </proc/swaps | grep -v -i Used | awk '{s+=$1} END {printf "%.0f", s}')"
	[ ${SwapNow:-0} -gt ${SwapBefore:-0} ] && SwapWarning=" and swapping" || SwapWarning=""
	[ "X${PlotCpufreqOPPs}" = "Xyes" ] || ThrottlingCheck="$(CheckForThrottling)"

	# Check %iowait and %sys percentage as an indication of swapping or too much background
	# activity
	IOWaitAvg=$(CheckIOWait)
	IOWaitMax="$(grep -E "MHz  |---  " "${MonitorLog}" | awk -F"%" '{print $5}' | sed '/^[[:space:]]*$/d' | sed -e '1,2d' | sort -n -r | head -n1 | sed 's/  //')"
	SysMax="$(grep -E "MHz  |---  " "${MonitorLog}" | awk -F"%" '{print $2}' | sed '/^[[:space:]]*$/d' | sed -e '1,2d' | sort -n -r | head -n1 | sed 's/  //')"

	# if statistics about memory clockspeeds are available insert these now:
	CheckMemoryDevfreqTransitions >>"${ResultLog}"

	# Prepare benchmark results
	echo -e "\n##########################################################################\n" >>"${ResultLog}"

	# add thermal info if available
	if [ "X${TempInfo}" != "X" ]; then
		echo -e "${TempInfo}\n" >>"${ResultLog}"
	fi

	# include monitoring (filter out broken thermal readouts)
	sed 's/  0°C$/ --/' <"${MonitorLog}" >>"${ResultLog}"

	# add throttling info if available
	if [ -f "${TempDir}/throttling_info.txt" ]; then
		echo -e "\n##########################################################################" >>"${ResultLog}"
		cat "${TempDir}/throttling_info.txt" >>"${ResultLog}"
		ThrottlingWarning="${LRED}${BOLD} (throttled)${NC}"
	fi

	# add dmesg output since start of the benchmark if something relevant is there
	TimeStamp="$(dmesg | tr -d '[' | tr -d ']' | awk -F" " '/sbc-bench started/ {print $1}' | tail -n1)"
	dmesg | sed "/${TimeStamp}/,\$!d" | grep -E -v 'sbc-bench started|started with executable stack' >"${TempDir}/dmesg"
	if [ -s "${TempDir}/dmesg" ]; then
		echo -e "\n##########################################################################\n\ndmesg output while running the benchmarks:\n" >>"${ResultLog}"
		cat "${TempDir}/dmesg" >>"${ResultLog}"
	fi

	echo -e "\n##########################################################################\n" >>"${ResultLog}"
	echo -e "$(iostat | grep -E -v "^loop|boot0|boot1|mtdblock")\n\n$(free -h)\n\n$(swapon -s)\n" | sed '/^$/N;/^\n$/D' >>"${ResultLog}"
	ShowZswapStats 2>/dev/null >>"${ResultLog}"
	echo >>"${ResultLog}"
	cat "${TempDir}/cpu-topology.log" >>"${ResultLog}"
	echo "${LSCPU}" >>"${ResultLog}"
	LogEnvironment >>"${ResultLog}"

	# Throttling detection/reporting
	if [ "X${PlotCpufreqOPPs}" != "Xyes" ]; then
		if [ -f /sys/devices/system/cpu/cpufreq/policy0/cpuinfo_max_freq ]; then
			# Check for throttling for first:
			MeasuredClockspeedStart=$(grep -A2 "^Checking cpufreq OPP" "${ResultLog}" | awk -F" " '/Measured/ {print $5}' | sed -n ${#ClusterConfig[@]}p)
			MeasuredClockspeedFinished=$(grep -A2 "^Checking cpufreq OPP" "${ResultLog}" | awk -F" " '/Measured/ {print $5}' | sed -n $(( ${#ClusterConfig[@]} * 2 ))p)
			MeasuredDifference=$(( 100 * MeasuredClockspeedStart / ${MeasuredClockspeedFinished:-MeasuredClockspeedStart} ))
			if [ ${MeasuredDifference:-100} -gt 103 ] || [ -f "${TempDir}/throttling_info.txt" ]; then
				# if measured clockspeed differs by more than 3% comparing begin and end of
				# benchmarking or if throttling_info.txt exists, then add a throttling warning
				ThrottlingWarning="${LRED}${BOLD} (throttled)${NC}"
			fi

			HighestClock=$(sort -n -r /sys/devices/system/cpu/cpufreq/policy?/cpuinfo_max_freq | head -n1)
			LowestClock=$(sort -n -r /sys/devices/system/cpu/cpufreq/policy?/cpuinfo_max_freq | tail -n1)
			ClockDifference=$(( 100000 * MeasuredClockspeedStart / HighestClock ))
			if [ ${ClockDifference:-100} -lt 98 ] || [ ${ClockDifference:-100} -gt 102 ]; then
				# if measured clockspeed differs by more than 2% compared to cpuinfo_max_freq
				# then report this value slightly rounded instead of cpufreq sysfs entries
				MHz="~$(( $(awk '{printf ("%0.0f",$1/10); }' <<<${MeasuredClockspeedStart} ) * 10 ))"
			elif [ ${HighestClock} -eq ${LowestClock} ]; then
				MHz="$(( HighestClock / 1000 )) MHz"
			else
				MHz="$(( HighestClock / 1000 ))/$(( LowestClock / 1000 )) MHz"
			fi
		else
			# no cpufreq support, we check first measured value and use it if available
			MeasuredClockspeedStart=$(awk -F": " '/No cpufreq support available. Measured on cpu/ {print $2}' <"${ResultLog}" | cut -f1 -d' ' | head -n 1)
			if [ "X${MeasuredClockspeedStart}" = "X" ]; then
				MHz="no cpufreq support"
			else
				# slightly round up measured clockspeed
				MHz="~$(( $(awk '{printf ("%0.0f",$1/10+0.5); }' <<<"${MeasuredClockspeedStart}") * 10 )) MHz"
				# check additionally for throttling
				MeasuredClockspeedFinished=$(awk -F": " '/No cpufreq support available. Measured on cpu/ {print $2}' <"${ResultLog}" | cut -f1 -d' ' | tail -n1)
				MeasuredDifference=$(( 100 * MeasuredClockspeedStart / MeasuredClockspeedFinished ))
				if [ ${MeasuredDifference:-100} -gt 103 ]; then
					# if measured clockspeed differs by more than 3% comparing begin and end of
					# benchmarking then add a throttling warning
					ThrottlingWarning="${LRED}${BOLD} (throttled)${NC}"
				fi
			fi
		fi
	fi

	# Add a line suitable for Results.md on Github if not in efficiency plotting or PTS, GB or review mode
	if [ "X${PlotCpufreqOPPs}" != "Xyes" ] && [ "X${MODE}" != "Xpts" ] && [ "X${MODE}" != "Xgb" ] && [ "X${REVIEWMODE}" != "Xtrue" ]; then
		KernelArch="$(uname -m | sed -e 's/armv7l/armhf/' -e 's/aarch64/arm64/')"
		if [ "X${KernelArch}" = "X" ] || [ "X${KernelArch}" = "X${ARCH}" ]; then
			DistroInfo="${OperatingSystem} ${ARCH}"
		else
			DistroInfo="${OperatingSystem} ${KernelArch}/${ARCH}"
		fi
		echo -e "\n| ${DeviceName:-$HostName} | ${MHz}${ThrottlingWarning} | ${ShortKernelVersion} | ${DistroInfo} | ${ZipScore} | ${ZipScoreSingleThreaded} | ${OpenSSLScore} | ${MemBenchScore} | ${CpuminerScore:-"-"} |\c" | sed -e 's/  / /g' -e "s,\x1B\[[0-9;]*[a-zA-Z],,g" >>"${ResultLog}"
	fi
} # SummarizeResults

LogEnvironment() {
	# Log processor info if available and we're not running virtualized:
	if [ "X${VirtWhat}" = "X" ] || [ "X${VirtWhat}" = "Xnone" ] || [ "X${DMIProductName}" = "XApple Virtualization Generic Platform" ]; then
		command -v dmidecode >/dev/null 2>&1 && \
			ProcessorInfo="$(dmidecode -t processor 2>/dev/null | grep -E -v -i "^#|^Handle|Serial|O.E.M.|1234567|SMBIOS|: Not |Unknown|OUT OF SPEC|00 00 00 00 00 00 00 00|: None|Scanning ")"
		if [ "X${ProcessorInfo}" != "X" ]; then
			echo -e "\n${ProcessorInfo}\n"
		fi
	fi

	# report ARM/RISC-V/Loongson SoCs if possible
	if [ "X${GuessedSoC}" != "Xn/a" ]; then
		echo -e "\nSoC guess: ${GuessedSoC}"
	elif [ "X${CPUSignature}" != "X" ]; then
		if [ "X${CPUFetchGuess}" != "X" ]; then
			echo -e "\nSoC guess: ${CPUFetchGuess} (${CPUSignature})"
		else
			echo -e "\nSignature: ${CPUSignature}"
		fi
	else
		echo ""
	fi

	# check whether it's a Rockchip BSP kernel with dmc enabled
	DMCGovernor="/sys/devices/platform/dmc/devfreq/dmc/governor"
	if [ -f "${DMCGovernor}" ]; then
		read UsedDMCGovernor <"${DMCGovernor}"
		case ${UsedDMCGovernor} in
			userspace|powersave|performance)
				# report also configured RAM clock
				read DRAMClock <"${DMCGovernor%/*}/cur_freq"
				DMCGovernorSettings="${UsedDMCGovernor} ($(( ${DRAMClock} / 1000000 )) MHz)"
				;;
			*)
				# check whether uptreshold and downdifferential values exist and if true report it
				if [ -f "${DMCGovernor%/*}/upthreshold" ]; then
					# report DMC governor and upthreshold value
					read upthreshold <"${DMCGovernor%/*}/upthreshold"
					if [ -f "${DMCGovernor%/*}/downdifferential" ]; then
						# report DMC governor and upthreshold/downdifferential values
						read downdifferential <"${DMCGovernor%/*}/downdifferential"
						DMCGovernorSettings="${UsedDMCGovernor} (upthreshold: ${upthreshold}, downdifferential: ${downdifferential})"
					else
						# report DMC governor and upthreshold value
						DMCGovernorSettings="${UsedDMCGovernor} (upthreshold: ${upthreshold})"
					fi
				else
					# report only DMC governor
					DMCGovernorSettings="${UsedDMCGovernor}"
				fi
				;;
		esac
		echo -e "  DMC gov: ${DMCGovernorSettings}"
	fi

	# log /proc/device-tree/compatible contents if available
	if [ "X${DTCompatible}" != "X" ]; then
		echo "DT compat: $(head -n1 <<<"${DTCompatible}")"
		tail -n +2 <<<"${DTCompatible}" | sed -e 's/^/           /'
	fi

	# Check Rockchip boot environment (may only work on Radxa images)
	RKBootEnvironment="$(GetRKBootEnvironment)"
	if [ "X${RKBootEnvironment}" != "X" ]; then
		echo -e " Boot env: ${RKBootEnvironment}"
	fi

	# Log compiler version if not in Geekbench mode
	if [ "X${MODE}" != "Xgb" ]; then
		GCC_Info="$(${GCC} -v 2>&1 | grep -E "^Target|^Configured")"
		echo -e " Compiler: ${GCC} ${GCC_Version} / $(awk -F": " '/^Target/ {print $2}' <<< "${GCC_Info}")"
	fi

	# Log userland architecture if available
	[ "X${ARCH}" != "X" ] && echo " Userland: ${ARCH}"
	# Log ThreadX version if available
	if [ "X${ThreadXVersion}" != "X" ]; then
		echo -e "  ThreadX: $(awk '/^version/ {print $2}' <<<"${ThreadXVersion}") / $(head -n1 <<<"${ThreadXVersion}")"
		vcgencmd_mem_reloc_stats="$("${VCGENCMD}" mem_reloc_stats 2>/dev/null)"
		grep -q compactions <<<"${vcgencmd_mem_reloc_stats}" && echo "${vcgencmd_mem_reloc_stats}" | while read ; do
			echo "           ${REPLY}"
		done
	fi

	# check for VM/container mode to add this to kernel info
	[ "X${VirtWhat}" != "X" ] && [ "X${VirtWhat}" != "Xnone" ] && VirtOrContainer=" (${VirtWhat})"
	# kernel info
	KernelVersion="$(uname -r)"
	ShortKernelVersion="$(awk -F"." '{print $1"."$2}' <<<"${KernelVersion}")"
	if [ -r /proc/self/smaps ]; then
		KernelPageSize="$(awk -F" " '/KernelPageSize/ {print $2$3}' /proc/self/smaps 2>/dev/null | head -n1)"
		[ "${KernelPageSize}" != "4kB" ] && PageSize=" (${KernelPageSize})" || PageSize=""
	fi
	echo -e "   Kernel: ${KernelVersion}/${CPUArchitecture}${PageSize}${VirtOrContainer}"
	# kernel config
	KernelConfig="/boot/config-${KernelVersion}"
	if [ -f "${KernelConfig}" ] ; then
		grep -E "^CONFIG_HZ|^CONFIG_PREEMPT" "${KernelConfig}" | sed -e 's/^/           /' | sort -V
	else
		modprobe configs 2>/dev/null
		[ -f /proc/config.gz ] && zgrep -E "^CONFIG_HZ|^CONFIG_PREEMPT" /proc/config.gz | sed -e 's/^/           /' | sort -V
	fi

	# with Rockchip BSP kernels try to report PVTM settings (Process-Voltage-Temperature Monitor)
	grep -E "cpu.*pvtm|leakage" <<<"${DMESG}" | awk -F'] ' '{print "           "$2}'

	# Add kernel version info / warnings
	KernelInfo="$(CheckKernelVersion "${KernelVersion}")"
	[ -z "${KernelInfo}" ] || echo -e "\n##########################################################################\n"; \
		sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" <<<"${KernelInfo}"

	# cache and DIMM info
	CacheAndDIMMs="$(CacheAndDIMMDetails)"
	[ -z "${CacheAndDIMMs}" ] || echo -e "\n##########################################################################\n${CacheAndDIMMs}" >>"${ResultLog}"

	# Always include OPP tables
	if [ "X${USE_VCGENCMD}" = "Xtrue" ]; then
		# check whether we collected RPi OPP tables when walking through the cpufreq OPP and
		# if so include them using the usual sbc-bench format. The whole DVFS thing on RPi
		# happens solely inside the closed source ThreadX world.
		echo -e "\n##########################################################################" >>"${ResultLog}"
		for OPPTable in "${TempDir}"/opp-table-threadx-* ; do
			[[ -e "${OPPTable}" ]] || break
			echo -e "\n   ${OPPTable##*/}:" >>"${ResultLog}"
			sort -n <"${OPPTable}" >>"${ResultLog}"
		done
	else
		echo -e "${OPPTables}" >>"${ResultLog}"
	fi

	# results validation:
	echo -e "\n##########################################################################\n"
	IsValid="$(ValidateResults | sed -e 's/^/  * /')"
	[ -n "${IsValid}" ] && echo -e "Results validation:\n\n${IsValid}\n" | sed "s,\x1B\[[0-9;]*[a-zA-Z],,g"

	# add performance relevant governors/policies to results if available:
	GovernorStateNow="$(HandleGovernors | grep -v cpufreq-policy)"
	PolicyStateNow="$(HandlePolicies)"
	if [ "X${GovernorStateNow}" != "X" ] && [ "X${PolicyStateNow}" != "X" ]; then
		echo -e "Status of performance related governors found below /sys (w/o cpufreq):\n"
		sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" <<<"${GovernorStateNow}" | sed -e 's/^/  * /'
		echo -e "\nStatus of performance related policies found below /sys:\n"
		sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" <<<"${PolicyStateNow}" | sed -e 's/^/  * /'
	elif [ "X${GovernorStateNow}" != "X" ]; then
		echo -e "Status of performance related governors found below /sys (w/o cpufreq):\n"
		sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" <<<"${GovernorStateNow}" | sed -e 's/^/  * /'
	elif [ "X${PolicyStateNow}" != "X" ]; then
		echo -e "Status of performance related policies found below /sys:\n"
		sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" <<<"${PolicyStateNow}"	| sed -e 's/^/  * /'
	fi
} # LogEnvironment

GetRKBootEnvironment() {
	if grep -q androidboot.fwver /proc/cmdline ; then
		awk -F"androidboot.fwver=" '{print $2}' </proc/cmdline | awk -F" " '{print $1}' | sed 's/,/, /g'
	fi
} # GetRKBootEnvironment

ValidateResults() {
	# function that checks whether benchmark scores have been invalidated

	# check 7-zip version (only 16.02 is ok to compare with results list)
	Valid7Zip="$(grep '^p7zip Version' "${ResultLog}" | head -n1 | awk -F" " '{print $3}')"
	[ -z "${Valid7Zip}" ] && Valid7Zip="$(grep '^7-Zip ' "${ResultLog}" | head -n1 | awk -F" " '{print $3}')"
	[ "X${Valid7Zip}" = "X16.02" ] || [ "X${Valid7Zip}" = "X" ] || echo -e "${LRED}${BOLD}Distro uses problematic 7-zip version ${Valid7Zip}${NC} -> http://tinyurl.com/ukcktbsm"

	# report significant mismatches between measured and 'advertised' clockspeeds from
	# 1st measurement prior to benchmarking (to rule out later possible throttling effects)
	if [ "X${USE_VCGENCMD}" = "Xtrue" ]; then
		ClockspeedMismatchBefore="$(grep -B1000 "^Executing ramlat" "${ResultLog}" | grep -A2 "^Checking cpufreq OPP " | awk -F"[()]" '/^Cpufreq OPP:/ {print $2}' | grep "^-" | sort -n | head -n1)"
		ClockspeedMismatchAfter="$(grep -A200 "^Testing maximum cpufreq again" "${ResultLog}" | grep -A2 "^Checking cpufreq OPP " | awk -F"[()]" '/^Cpufreq OPP:/ {print $2}' | grep "^-" | sort -n | head -n1)"
	else
		ClockspeedMismatchBefore="$(grep -B1000 "^Executing ramlat" "${ResultLog}" | grep -A2 "^Checking cpufreq OPP " | awk -F"[()]" '/^Cpufreq OPP:/ {print $4}' | grep "^-" | sort -n | head -n1)"
		ClockspeedMismatchAfter="$(grep -A200 "^Testing maximum cpufreq again" "${ResultLog}" | grep -A2 "^Checking cpufreq OPP " | awk -F"[()]" '/^Cpufreq OPP:/ {print $4}' | grep "^-" | sort -n | head -n1)"
	fi
	if [ "X${ClockspeedMismatchBefore}" != "X" ] && [ "X${ClockspeedMismatchAfter}" != "X" ]; then
		OneOrTwoDigitsBefore=$(wc -c <<<"${ClockspeedMismatchBefore}")
		OneOrTwoDigitsAfter=$(wc -c <<<"${OneOrTwoDigitsAfter}")
		if [ ${OneOrTwoDigitsBefore:-6} -gt 6 ] || [ ${OneOrTwoDigitsAfter:-6} -gt 6 ]; then
			# mismatch greater than 9%, print warning in red and bold
			echo -e "${LRED}${BOLD}Advertised vs. measured max CPU clockspeed: ${ClockspeedMismatchBefore} before, ${ClockspeedMismatchAfter} after${NC} -> https://tinyurl.com/32w9rr94"
		else
			echo -e "Advertised vs. measured max CPU clockspeed: ${ClockspeedMismatchBefore} before, ${ClockspeedMismatchAfter} after -> https://tinyurl.com/32w9rr94"
		fi
	elif [ -f /sys/devices/system/cpu/cpufreq/policy0/scaling_governor ]; then
		# cpufreq scaling supported, check we've measured cpufreq before to report 'no mismatch'
		grep -q "^Checking cpufreq OPP" "${ResultLog}" && \
			echo -e "${LGREEN}Measured clockspeed not lower than advertised max CPU clockspeed${NC}"
	fi

	# check for certain RPi specifics
	if [ -r "${ThreadXConfig}" ]; then
    	# Check whether arm_boost=1 is missing with BCM2711 rev C0 or later. Armbian 'experts'
    	# ship with such silly settings but set over_voltage=2 and arm_freq=1800 at the same
    	# time as such RPi 4 with BCM2711 rev C0 or later running with Armbian will waste more
    	# energy and starts to throttle earlier since the ARM cores are being fed unnecessarily
    	# with higher supply voltages than necessary and all of this just due to the usual
    	# amount of ignorance over at Armbian.
    	# https://github.com/armbian/build/issues/3400#issuecomment-1011435796
		grep -q "arm_boost=1" "${ThreadXConfig}"
		if [ $? -ne 0 ] && [ "${BCM2711}" = "C0 or later" ]; then
			grep -q "arm_freq=1800" "${ThreadXConfig}"
			case $? in
				0)
					# Armbian settings
					echo -e "${LRED}${BOLD}Silly settings: \"arm_boost=1\" missing but \"arm_freq=1800\" set in ${ThreadXConfig}${NC} -> https://tinyurl.com/sbmvhwpf"
					;;
				*)
					echo -e "${LRED}${BOLD}\"arm_boost=1\" missing in ${ThreadXConfig}${NC} -> https://tinyurl.com/sbmvhwpf"
					;;
			esac
		fi

		# check whether temp_soft_limit is defined since otherwise on certain RPi models
		# the max clockspeed is silently lowered from 1400 to 1200 MHz once 60°C are hit
		case "${DeviceName}" in
			"Raspberry Pi 3 Model B Plus"*|"Raspberry Pi 3 Model A Plus"*|"Raspberry Pi Compute Module 3 Plus"*)
				grep -q "arm_freq=1200" <<<"${ActualThreadXsettings}"
				LimitedTo1200=$?
				grep -q "temp_soft_limit" "${ThreadXConfig}"
				TempSoftLimitSet=$?
				[ ${LimitedTo1200} -ne 0 ] && [ ${TempSoftLimitSet} -ne 0 ] && echo "\"temp_soft_limit\" not set in ${ThreadXConfig} -> https://tinyurl.com/4e3kpt6n"
				;;
		esac
	fi

	# Swapping? Skip if there's no swap configured
	ProcSwapLines=$(wc -l </proc/swaps)
	if [ ${ProcSwapLines} -gt 1 ]; then
		if [ "${SwapWarning}" = "" ]; then
			echo -e "${LGREEN}No swapping${NC}"
		else
			NoZRAM=$(tail -n +2 /proc/swaps | grep -v '^/dev/zram' | wc -l)
			if [ ${NoZRAM} -eq 0 ]; then
				echo -e "${LRED}${BOLD}Swapping (ZRAM) occured${NC} -> https://tinyurl.com/3h222wnh"
				# check whether zswap sits on top of zram
				[ -r /sys/module/zswap/parameters/enabled ] && ZswapEnabled="$(sed 's/Y/1/' </sys/module/zswap/parameters/enabled)"
				[ "${ZswapEnabled}" = "1" ] && echo -e "${LRED}${BOLD}Zswap configured on top of zram. Swap performance harmed${NC} -> https://tinyurl.com/spkr8ytz"
			else
				echo -e "${LRED}${BOLD}Swapping occured${NC} -> https://tinyurl.com/3h222wnh"
				if [ "X${VirtWhat}" = "X" ] || [ "X${VirtWhat}" = "Xnone" ]; then
					# identify type of swap only when not running inside a VM
					SlowSwap="$(ListSwapDevices | sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" | awk -F") on " '{print $2}' | sed '/^$/d' | tr '\n' ',' | sed -e 's/,/, /g' -e 's/, $//')"
					[ -z "${SlowSwap}" ] || echo -e "${LRED}${BOLD}Swap configured on ${SlowSwap}${NC}"
				fi
			fi
		fi
	fi

	# Too high %system utilization (mostly caused by swapping on zram enabled systems)?
	UtilizationValues="$(grep -A2000 -E "^System health while running tinymembench|^System health while running ramlat" "${MonitorLog}" | sed '/^Time/,+1 d' | awk -F"MHz " '/^[0-9]/ {print $2}' | awk -F" " '{print $3}' | sed 's/%//')"
	PeakSysUtilization=$(sort -n -r <<<"${UtilizationValues}" | head -n1)
	LogLength=$(wc -l <<<"${UtilizationValues}")
	UtilizationSum=$(awk '{s+=$1} END {printf "%.0f", s}' <<<"${UtilizationValues}")
	AverageSysUtilization=$(( ${UtilizationSum} / ${LogLength} ))
	if [ ${PeakSysUtilization:-0} -gt 15 ] || [ ${AverageSysUtilization:-0} -gt 0 ]; then
		echo -e "${LRED}${BOLD}Too much background activity (%system): ${AverageSysUtilization}% avg, ${PeakSysUtilization}% max${NC} -> https://tinyurl.com/mr2wy5uv"
	else
		# only report background activity being ok when not running inside a VM/container
		[ "X${VirtWhat}" = "X" ] || [ "X${VirtWhat}" = "Xnone" ] && echo -e "${LGREEN}Background activity (%system) OK${NC}"
	fi

	# Too high overall CPU utilization with single threaded benchmarks? This is an indication
	# of background activities needing too much CPU ressources. Skip in MODE=extensive/gb/pts
	# Skip also if count of CPU cores is 1 or $1 is review

	if [ "X${MODE}" != "Xextensive" ] && [ "X${MODE}" != "Xpts" ] && [ "X${MODE}" != "Xgb" ] && [ ${CPUCores} -gt 1 ] && [ "X$1" != "Xreview" ]; then
		IdealUtilization=$(( 100 / ${CPUCores} ))
		UtilizationValues="$(grep -A2000 "^System health while running tinymembench" "${MonitorLog}" | grep -B2000 -E " 7-zip multi | 7-zip cluster " | sed '/^Time/,+1 d' | awk -F"MHz " '/^[0-9]/ {print $2}' | awk -F" " '{print $2}' | sed 's/%//' | while read ; do [ ${REPLY} -ge ${IdealUtilization} ] && echo ${REPLY} ; done)"
		PeakCPUUtilization=$(sort -n -r <<<"${UtilizationValues}" | head -n1)
		LogLength=$(wc -l <<<"${UtilizationValues}")
		UtilizationSum=$(awk '{s+=$1} END {printf "%.0f", s}' <<<"${UtilizationValues}")
		AverageCPUUtilization=$(( ${UtilizationSum} / ${LogLength} ))
		PeakDiff=$(( ${PeakCPUUtilization} - ${IdealUtilization} ))
		AverageDiff=$(( ${AverageCPUUtilization} - ${IdealUtilization} ))
		case ${CPUCores} in
			2)
				# 8% peak and 2% average is acceptable
				[ ${PeakDiff} -gt 8 ] || [ ${AverageDiff} -gt 2 ] && echo -e "${LRED}${BOLD}Too much other background activity: ${AverageDiff}% avg, ${PeakDiff}% max${NC} -> https://tinyurl.com/mr2wy5uv"
				;;
			4)
				# 5% peak and 1% average is acceptable
				[ ${PeakDiff} -gt 5 ] || [ ${AverageDiff} -gt 1 ] && echo -e "${LRED}${BOLD}Too much other background activity: ${AverageDiff}% avg, ${PeakDiff}% max${NC} -> https://tinyurl.com/mr2wy5uv"
				;;
			5|6)
				# 3% peak and 1% average is acceptable
				[ ${PeakDiff} -gt 3 ] || [ ${AverageDiff} -gt 1 ] && echo -e "${LRED}${BOLD}Too much other background activity: ${AverageDiff}% avg, ${PeakDiff}% max${NC} -> https://tinyurl.com/mr2wy5uv"
				;;
			8)
				# 2% peak and 0% average is acceptable
				[ ${PeakDiff} -gt 2 ] || [ ${AverageDiff} -gt 0 ] && echo -e "${LRED}${BOLD}Too much other background activity: ${AverageDiff}% avg, ${PeakDiff}% max${NC} -> https://tinyurl.com/mr2wy5uv"
				;;
			*)
				# With more CPU cores it's impossible to detect 'sane environment' so only
				# notify if average utilization is off by more than 0%
				[ ${AverageDiff} -gt 0 ] && echo -e "${LRED}${BOLD}Too much other background activity: ${AverageDiff}% avg, ${PeakDiff}% max${NC} -> https://tinyurl.com/mr2wy5uv"
				;;
		esac
	fi

	# check for out of memory events (oom-killer invocations)
	if [ -s "${TempDir}/dmesg" ]; then
		OOMCount="$(grep -c "oom-killer" "${TempDir}/dmesg")"
		if [ ${OOMCount:-0} -gt 0 ]; then
			case ${ProcSwapLines} in
				1)
					echo -e "${LRED}${BOLD}${OOMCount} oom-killer invocations (system too low on RAM and no ZRAM configured)${NC} -> https://tinyurl.com/ytma8u4e"
					;;
				*)
					echo -e "${LRED}${BOLD}${OOMCount} oom-killer invocations (system too low on RAM and insufficient swap configured)${NC} -> https://tinyurl.com/ytma8u4e"
					;;
			esac
		fi
	fi

	# powercap on Intel?
	if [ -d /sys/devices/virtual/powercap/intel-rapl ]; then
		grep -q -i GenuineIntel <<< "${ProcCPU}" && echo -e "Powercap detected. Details: \"sudo powercap-info -p intel-rapl\" -> https://tinyurl.com/4jh9nevj"
	fi

	# temporarily killed CPU cores due to overheating with Amlogic SoCs and BSP kernel
	if [ ! -f "${TempDir}/dmesg" ]; then
		# filter dmesg output to contain only contents from start of benchmarking
		TimeStamp="$(dmesg | tr -d '[' | tr -d ']' | awk -F" " '/sbc-bench started/ {print $1}' | tail -n1)"
		dmesg | sed "/${TimeStamp}/,\$!d" | grep -E -v 'sbc-bench started|started with executable stack' >"${TempDir}/dmesg"
	fi
	KilledCPUs="$(grep "CPU[0-7]: shutdown" "${TempDir}/dmesg" | awk -F" " '{print $2}' | sort | uniq | tr "\n" ":" | sed -e 's/::/, /g')"
	if [ "X${KilledCPUs}" != "X" ]; then
		ThrottlingWarning="${LRED}${BOLD} (throttled)${NC}"
		echo -e "${LRED}${BOLD}Overheating resulted in CPU cores temporarily being stopped ($(sed 's/, $//' <<<"${KilledCPUs,,}"))${NC} -> https://tinyurl.com/2jetn2eb"
	fi

	# Throttling and frequency capping on RPi?
	if [ "${USE_VCGENCMD}" = "true" ]; then
		case "${ThrottlingCheck}" in
			*"requency capping"*)
				[ "${ThrottlingWarning}" = "" ] && echo -e "${LRED}${BOLD}Frequency capping (under-voltage) occured${NC} -> https://tinyurl.com/3j2c66kd" || echo -e "${LRED}${BOLD}Throttling / frequency capping (under-voltage) occured${NC} -> https://tinyurl.com/4ky59sys / https://tinyurl.com/3j2c66kd"
				;;
			*)
				[ "${ThrottlingWarning}" = "" ] && echo -e "${LGREEN}No throttling${NC}" || echo -e "${LRED}${BOLD}Throttling occured${NC} -> https://tinyurl.com/4ky59sys"
				;;
		esac
	else
		# Throttling on all other systems?
		if [ "${ThrottlingWarning}" = "" ] && [ -f /sys/devices/system/cpu/cpufreq/policy0/stats/time_in_state ]; then
			# only report 'No throttling' when cpufreq statistics are available and not
			# running inside a VM/container
			[ "X${VirtWhat}" = "X" ] || [ "X${VirtWhat}" = "Xnone" ] && echo -e "${LGREEN}No throttling${NC}"
		elif [ "${ThrottlingWarning}" != "" ]; then
			# we need to check whether we're running in Geekbench or PTS mode since the
			# cluster tests on CPUs with different core types end up with the CPUs remaining
			# on lower clockspeeds for a fraction of time when bringing them back online
			# which then results in stats/time_in_state cpufreq statistics showing the cores
			# not all the time at maximum clockspeed.
			if [ "X${MODE}" != "Xpts" ] && [ "X${MODE}" != "Xgb" ]; then
				echo -e "${LRED}${BOLD}Throttling occured${NC} -> https://tinyurl.com/4ky59sys"
			else
				echo -e "Throttling might have occured -> https://tinyurl.com/4ky59sys"
			fi
		fi
	fi

	# ondemand governor used by distro but inappropriate settings on at least some cores
	if [ "X$1" = "Xreview" ] && [ "${OriginalCPUFreqGovernor}" = "ondemand" ] && [[ -n "${io_is_busy[@]}" ]]; then
		grep -q 0 <<<"${io_is_busy[@]}" && echo -e "${LRED}${BOLD}ondemand cpufreq governor used by distro but io_is_busy not set to 1 on all cores${NC} -> http://tinyurl.com/44pbmw79"
	elif [ "X$1" = "Xreview" ] && [ "${OriginalCPUFreqGovernor}" = "ondemand" ] && [[ -z "${io_is_busy[@]}" ]]; then
		echo -e "${LRED}${BOLD}ondemand cpufreq governor used by distro but io_is_busy not active${NC} -> http://tinyurl.com/44pbmw79"
	fi

	# check DT settings on big.LITTLE ARM designs for scheduler relevant stuff:
	if [ -d /proc/device-tree/cpus ] && [ ${#ClusterConfig[@]} -ne 1 ]; then
		capacitydmipsmhz=$(find /proc/device-tree/cpus -name capacity-dmips-mhz | wc -l)
		if [ ${capacitydmipsmhz} -eq 0 ]; then
			echo "${LRED}${BOLD}${#ClusterConfig[@]} different clusters but capacity-dmips-mhz property not set${NC}"
		elif [ ${capacitydmipsmhz} -ne ${CPUCores} ]; then
			echo "${LRED}${BOLD}${#ClusterConfig[@]} different clusters and ${CPUCores} cores but capacity-dmips-mhz property only set on ${capacitydmipsmhz}${NC}"
		fi
		if [ "${OriginalCPUFreqGovernor}" = "schedutil" ]; then
			dynamicpowercoefficient=$(find /proc/device-tree/cpus -name dynamic-power-coefficient | wc -l)
			schedenergycosts=$(find /proc/device-tree/cpus -name sched-energy-costs | wc -l)
			if [ ${dynamicpowercoefficient} -eq 0 ] && [ ${schedenergycosts} -eq 0 ]; then
				echo "${LRED}${BOLD}${OriginalCPUFreqGovernor} cpufreq governor configured but neither dynamic-power-coefficient nor sched-energy-costs defined${NC}"
			elif [ ${dynamicpowercoefficient} -ne ${CPUCores} ]; then
				echo "${OriginalCPUFreqGovernor} cpufreq governor configured: ${CPUCores} cores available vs. only ${dynamicpowercoefficient} dynamic-power-coefficient DT nodes"
			elif [ ${schedenergycosts} -ne ${CPUCores} ]; then
				echo "${OriginalCPUFreqGovernor} cpufreq governor configured: ${CPUCores} cores available vs. only ${schedenergycosts} sched-energy-costs DT nodes"
			fi
		fi
	fi
} # ValidateResults

ListSwapDevices() {
	# function to list swap devices

	grep -q "/dev/zram" /proc/swaps && ZRAMCtl="$(zramctl -n -o NAME,DISKSIZE,ALGORITHM,STREAMS,DATA,COMPR,TOTAL)"
	[ -r /sys/module/zswap/parameters/enabled ] && ZswapEnabled="$(sed 's/Y/1/' </sys/module/zswap/parameters/enabled)"
	[ "${ZswapEnabled}" = "1" ] && ZswapWarning=", ${LRED}slowed down by zswap${NC}"
	tail -n +2 /proc/swaps | while read ; do
		unset DeviceWarning
		SwapDevice="${REPLY%% *}"
		SwapType="$(awk -F" " '{print $2}' <<<"${REPLY}")"
		SwapSizeRaw="$(awk -F" " '{print $3}' <<<"${REPLY}")"
		SwapSize=$(HumanReadableSize "${SwapSizeRaw:-}")
		SwapUsedRaw="$(awk -F" " '{print $4}' <<<"${REPLY}")"
		SwapUsed=$(HumanReadableSize "${SwapUsedRaw:-}")

		case "${SwapType}" in
			partition)
				case "${SwapDevice}" in
					/dev/zram*)
						# ZRAM
						awk -F" " "/${SwapDevice##*/} / {print \"  * \"\$1\": \"\$2\" (${SwapUsed} used, \"\$3\", \"\$4\" streams, \"\$5\" data, \"\$6\" compressed, \"\$7\" total${ZswapWarning})\"}" <<<"${ZRAMCtl}"
						;;
					/dev/*)
						# other partition, find the block device it's residing on and check
						# whether it's flash storage or spinning rust
						DeviceWarning="$(CheckSwapPartition "${SwapDevice}")"
						echo -e "  * ${SwapDevice}: ${SwapSize} (${SwapUsed} used)${DeviceWarning}"
						;;
				esac
				;;
			file)
				# try to find out on which block device it's residing
				# findmnt -J -U "$(stat --printf=%m /swapfile)" -> {"target": "/", "source": "/dev/mmcblk1p1", "fstype": "ext4", "options": "rw,noatime,nodiratime,errors=remount-ro,commit=600"} -> /sys/block/mmcblk1/device/type (SD or MMC)
				SwapDevicePartition="$(findmnt -U "$(stat --printf=%m ${SwapDevice})" | grep "^/" | awk -F" " '{print $2}')"
				if [ "X${SwapDevicePartition}" = "Xoverlay" ] && [ -r /proc/cmdline ]; then
					# FriendlyELEC images using overlayfs: https://wiki.friendlyelec.com/wiki/index.php/How_to_use_overlayfs_on_Linux
					RootPartition="$(tr ' ' '\n' </proc/cmdline | awk -F"=" '/^root=/ {print $2}')"
					[ -z "${RootPartition}" ] || DeviceWarning="$(CheckSwapPartition "${RootPartition}")"
					echo -e "  * ${SwapDevice} on ${RootPartition}: ${SwapSize} (${SwapUsed} used)${DeviceWarning}"
				elif [ "X${SwapDevicePartition}" != "X" ]; then
					# check partition whether it's flash storage or spinning rust
					DeviceWarning="$(CheckSwapPartition "${SwapDevicePartition}")"
					echo -e "  * ${SwapDevice} on ${SwapDevicePartition}: ${SwapSize} (${SwapUsed} used)${DeviceWarning}"
				else
					# no partition found or overlayFS
					echo -e "  * ${SwapDevice}: ${SwapSize} (${SwapUsed} used)"
				fi
				;;
			*)
				# something else
				echo -e "  * ${SwapDevice}: ${SwapSize} (${SwapUsed} used)"
				;;
		esac
	done
} # ListSwapDevices

CheckSwapPartition() {
	# function that determines block device for given partition and examines it wrt
	# HDD or flash storage and if the latter prints warnings when SD or MMC
	BlockDevice="$(basename "$(realpath /sys/class/block/${1##*/}/..)")"
	if [ -f /sys/block/${BlockDevice}/queue/rotational ]; then
		case $(</sys/block/${BlockDevice}/queue/rotational) in
			1)
				# spinning rust, detection works only when not running inside VM/container
				[ "X${VirtWhat}" = "X" ] || [ "X${VirtWhat}" = "Xnone" ] && echo -e " ${LRED}${BOLD}on ultra slow HDD storage${NC}"
				;;
			*)
				# flash storage, get device node
				if [ -f /sys/block/${BlockDevice}/device/type ]; then
					case $(</sys/block/${BlockDevice}/device/type) in
						SD)
							echo -e " ${LRED}${BOLD}on ultra slow SD card storage${NC}"
							;;
						MMC)
							echo -e " on MMC storage"
							;;
					esac
				fi
				;;
		esac
	fi
} # CheckSwapPartition

HumanReadableSize() {
	# transforms storage sizes provided in KB (/proc/swaps for example) into human readable units
	if [ $1 -gt 1273741824 ]; then
		awk '{printf ("%0.1fT",$1/1073741824); }' <<<$1
	elif [ $1 -gt 1248576 ]; then
		awk '{printf ("%0.1fG",$1/1048576); }' <<<$1
	elif [ $1 -gt 1080 ]; then
		awk '{printf ("%0.1fM",$1/1024); }' <<<$1
	else
		echo "${1}K"
	fi
} # HumanReadableSize

UploadResults() {
	# upload results to ix.io and replace multiple empty lines with one. 2nd try if 1st does not succeed
	UploadURL=$(sed '/^$/N;/^\n$/D' <"${ResultLog}" | sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" | curl -s -F ${UploadScheme} ${UploadServer} 2>/dev/null || \
		sed '/^$/N;/^\n$/D' <"${ResultLog}" | sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" | curl -s -F ${UploadScheme} ${UploadServer})

	# Display benchmark results if not in PTS, GB or preview mode
	if [ "X${MODE}" != "Xpts" ] && [ "X${MODE}" != "Xgb" ] && [ "X${REVIEWMODE}" != "Xtrue" ]; then
		[ "X${IsValid}" != "X" ] && echo -e "${BOLD}Results validation:${NC}\n\n${IsValid}\n"
		MemoryScores="$(awk -F" " '/^ libc / {print $2$4" "$5" "$6}' <"${ResultLog}" | grep -E 'memcpy|memset' | awk -F'MB/s' '{print $1"MB/s"}')"
		CountOfMemoryScores=$(wc -l <<<"${MemoryScores}")
		if [ ${#ClusterConfig[@]} -eq 1 ] || [ $(( ${#ClusterConfig[@]} * 2 )) -ne ${CountOfMemoryScores} ]; then
			# if only 1 CPU cluster or mismatch between count of memory scores and cluster members
			# then report plain results
			echo -e "${BOLD}Memory performance${NC}\n${MemoryScores}"
		else
			# suffix memory scores with core types if possible
			ClusterInfo=" (all ${#ClusterConfig[@]} CPU clusters measured individually)"
			echo -e "${BOLD}Memory performance${NC}${ClusterInfo}:"
			for i in $(seq 0 $(( ${#ClusterConfig[@]} -1 )) ) ; do
				CPUInfo="$(GetCPUInfo ${ClusterConfig[$i]})"
				echo "$(grep "^memcpy:" <<<"${MemoryScores}" | sed -n $(( ${i} + 1 ))p)${CPUInfo}"
				echo "$(grep "^memset:" <<<"${MemoryScores}" | sed -n $(( ${i} + 1 ))p)${CPUInfo}"
			done
		fi
		if [ "${ExecuteCpuminer}" = "yes" ] && [ -x "${InstallLocation}"/cpuminer-multi/cpuminer ]; then
			echo -e "\n${BOLD}Cpuminer total scores${NC} (5 minutes execution): $(awk -F"Total Scores: " '/^Total Scores: / {print $2}' "${ResultLog}") kH/s"
		fi
		if [ "${ExecuteStockfish}" = "yes" ] && [ -x "${InstallLocation}/Stockfish-sf_15/src/stockfish" ]; then
			echo -e "\n${BOLD}Stockfish scores${NC} (${RunHowManyTimes} consecutive runs): ${StockfishScores} nodes/second"
		fi
		echo -e "\n${BOLD}7-zip total scores${NC} (${RunHowManyTimes} consecutive runs): $(awk -F" " '/^Total:/ {print $2}' "${ResultLog}"), single-threaded: ${ZipScoreSingleThreaded}"
		if [ -f "${OpenSSLLog}" ]; then
			echo -e "\n${BOLD}OpenSSL results${NC}${ClusterInfo}:\n$(grep '^type' "${OpenSSLLog}" | head -n1)"
			grep '^aes-...-cbc' "${OpenSSLLog}"
		fi
	elif [ "X${MODE}" = "Xgb" ]; then
		echo -e "First run:\n"
		case ${GBVersion} in
			5.*)
				grep ' Score ' "${TempLog}" | sed '/Multi-Core*/i \ \ \ '
				echo -e "\nSecond run:\n"
				grep ' Score ' "${TempLog2}" | sed '/Multi-Core*/i \ \ \ '
				;;
			6.*)
				grep ' Score ' "${TempLog}"
				echo -e "\nSecond run:\n"
				grep ' Score ' "${TempLog2}"
				;;
		esac
		echo -e "\n${CompareURL}\n"
		[ "X${IsValid}" != "X" ] && echo -e "${BOLD}Results validation:${NC}\n\n${IsValid}\n"
	elif [ "X${REVIEWMODE}" = "Xtrue" ] && [ "X${NOTUNING}" != "Xyes" ]; then
		[ "X${IsValid}" != "X" ] && echo -e "${BOLD}Results validation:${NC}\n\n${IsValid}\n"
	fi
	case ${UploadURL} in
		http*)
			# uploading results worked, check sanity of results and environment
			echo " ${UploadURL} |" | sed 's/http:/https:/' >>"${ResultLog}"
			echo -e "\nFull results uploaded to ${UploadURL}\c" | sed 's/http:/https:/'
			# check whether benchmark ran into a sane environment (no throttling and no swapping)
			if [ ${IOWaitAvg:-0} -le 2 ] && [ ${IOWaitMax:-0} -le 5 ] && [ ${SysMax:-0} -le 5 ] && [ ! -f "${TempDir}/throttling_info.txt" ]; then
				# in case it's not x86/x64 then also suggest adding results to official list
				case ${CPUArchitecture} in
					arm*|aarch*|riscv*|mips*|loongarch*)
						# not running on x86/x64, neither throttling nor relevant swapping occured.
						# Check whether SoC in question is already known since if true no more
						# submissions to official results are needed
						grep -q "^SoC guess:" "${ResultLog}"
						if [ $? -ne 0 ] && [ "X${MODE}" != "Xunattended" ]; then
							# not an already known SoC, so suggest submitting results
							echo -e "\n\nIn case this device ${BOLD}is not already represented${NC} in official sbc-bench results list then please"
							echo -e "consider submitting it at https://github.com/ThomasKaiser/sbc-bench/issues with this line:"
							tail -n 1 "${ResultLog}"
						fi
						echo
						;;
				esac
			fi
			;;
		*)
			if [ "X${MODE}" != "Xunattended" ]; then
				echo -e " |\n\n" >>"${ResultLog}"
				echo -e "\nUnable to upload full test results. Please copy&paste the below stuff to pastebin.com and\nprovide the URL. Check the output for throttling and swapping please.\n\n" >&2
				sed '/^$/N;/^\n$/D' <"${ResultLog}" >&2
			fi
			;;
	esac

	# write continous log, see
	# Skip log writing if log is a symlink to somewhere else
	[ -h /var/log/sbc-bench.log ] && return 1
	[ -s /var/log/sbc-bench.log ] && echo -e "\n\n\n" >>/var/log/sbc-bench.log
	sed '/^$/N;/^\n$/D' <"${ResultLog}" >>/var/log/sbc-bench.log
	echo ""

	# On systems running with Rockchip BSP kernel check DMC governor settings and if not
	# optimal, suggest retesting with performance DMC governor
	if [ -f "${DMCGovernor}" ]; then
		if [ "X${UsedDMCGovernor}" != "Xperformance" ]; then
			echo -e "\n${LRED}${BOLD}WARNING:${NC} ${LRED}The DMC governor settings of this device are not adjusted for performance${NC}"
			echo -e "${LRED}and as such DRAM bandwidth and latency might have been severly harmed. Your current\nsettings: ${DMCGovernorSettings}\n${NC}"
			echo -e "${LRED}For a discussion wrt settings see https://github.com/ThomasKaiser/Knowledge/issues/7${NC}\n"
			echo -e "${LRED}It is strongly advised to ${BOLD}switch to maximum performance and run sbc-bench again${NC} ${LRED}to be${NC}"
			echo -e "${LRED}able to compare real hardware performance with default settings of this distro/kernel.${NC}"
			echo -e "${LRED}You might want to execute this now and call sbc-bench again directly afterwards:\n${NC}"
			echo -e "${LRED}echo performance | sudo tee ${DMCGovernor}\n${NC}"
			echo -e "${LRED}Alternatively you can simply use review mode: sbc-bench -r\n${NC}"
		fi
	fi
} # UploadResults

CheckIOWait() {
	IOWait="$(awk -F" " '/^[0-9]/ {print $8}' <"${MonitorLog}" | sed 's/%//')"
	LogLength=$(wc -l <<<"${IOWait}")
	IOWaitSum="$(awk '{s+=$1} END {printf "%.0f", s}' <<<"${IOWait}")"
	echo $(( ${IOWaitSum} * 10 / ${LogLength} ))
} # CheckIOWait

CheckCPUUtilization() {
	# $1 is the CPU utilization w/o any disturbing background tasks, e.g. 50% on a dual
	# core system, 12% on an octa core, %25 on a quad core and so on
	IOWait="$(awk -F" " '/^[0-9]/ {print $8}' <"${MonitorLog}" | sed 's/%//')"
	LogLength=$(wc -l <<<"${IOWait}")
	IOWaitSum="$(awk '{s+=$1} END {printf "%.0f", s}' <<<"${IOWait}")"
	echo $(( ${IOWaitSum} * 10 / ${LogLength} ))
} # CheckCPUUtilization

CheckForThrottling() {
	# skip this check if $MaxKHz is set
	[ "X${MaxKHz}" != "X" ] && return

	# Check for throttling on normal ARM or RISC-V SBC (on x86 cpufreq statistics are
	# more or less irrelevant)
	case ${CPUArchitecture} in
		arm*|aarch*|riscv*)
			if [ -f /sys/devices/system/cpu/cpufreq/policy0/stats/time_in_state ]; then
				ls /sys/devices/system/cpu/cpufreq/policy?/stats/time_in_state | sort | while read ; do
					Number=$(echo ${REPLY} | tr -c -d '[:digit:]')
					diff "${TempDir}/time_in_state_after_${Number}" "${TempDir}/time_in_state_before_${Number}" >/dev/null 2>&1
					if [ $? -ne 0 ]; then
						if [ ${#ClusterConfig[@]} -eq 1 ]; then
							# all CPU cores have same cpufreq policies, we report globally
							ReportCpufreqStatistics ${Number}
							echo -e "${LRED}${BOLD}ATTENTION: Throttling${SwapWarning} occured. Check the log for details.${NC}\n"
						else
							# separate swapping warning:
							[ "${SwapWarning}" = "" ] || echo -e "${LRED}${BOLD}ATTENTION: Swapping has occured invalidating benchmark scores.${NC}\n"
							# report affected cluster
							for i in $(seq 0 $(( ${#ClusterConfig[@]} -1 )) ) ; do
								if [ ${ClusterConfig[$i]} -eq ${Number} ]; then
									FirstCore=${Number}
									LastCore=$(GetLastClusterCore $(( ${i} + 1 )))
									CPUInfo="$(GetCPUInfo ${Number})"
									ReportCpufreqStatistics ${Number} " for CPUs ${FirstCore}-${LastCore}${CPUInfo}"
									echo -e "${LRED}${BOLD}ATTENTION: Throttling occured on CPUs ${FirstCore}-${LastCore}${CPUInfo}. Check the log for details.${NC}\n"
								fi
							done
						fi
					fi
				done
			fi

			# Check for killed CPU cores. Some unfortunate users might still use Allwinner BSP kernels
			CPUCoresNow=$(lscpu | awk -F" " '/^CPU...:/ {print $2}')
			if [ ${CPUCoresNow} -lt ${CPUCores} ]; then
				echo -e "${LRED}${BOLD}ATTENTION: Due to overheating prevention $(( ${CPUCores} - ${CPUCoresNow} )) CPU cores have been killed. Check the log for details.${NC}\n"
			fi

			# Check for throttling/undervoltage on Raspberry Pi
			grep -q '1400/1200MHz' "${MonitorLog}" && Warning="ATTENTION: Silent throttling has occured. Check the log for details."
			if [ ${USE_VCGENCMD} = true ] ; then
				Health="$(LC_ALL=C perl -e "printf \"%19b\n\", $("${VCGENCMD}" get_throttled | cut -f2 -d=)" 2>/dev/null | tr -d '[:blank:]')"
				# https://forum.armbian.com/topic/7763-benchmarking-cpus/?do=findComment&comment=59042
				HealthLength=$(wc -c <<<"${Health}")
				[ ${HealthLength} -eq 19 ] && Health="0${Health}"
				case ${Health} in
					10*)
						Warning="ATTENTION: Frequency capping to 600 MHz${SwapWarning} has occured. Check the log for details."
						ReportRPiHealth ${Health} >>"${TempDir}/throttling_info.txt"
						;;
					01*)
						Warning="ATTENTION: Throttling${SwapWarning} has occured. Check the log for details."
						ReportRPiHealth ${Health} >>"${TempDir}/throttling_info.txt"
						;;
					11*)
						Warning="ATTENTION: Throttling and frequency capping${SwapWarning} has occured. Check the log for details."
						ReportRPiHealth ${Health} >>"${TempDir}/throttling_info.txt"
						;;
				esac
				if [ "X${Warning}" = "X" ]; then
					echo -e "${LGREEN}No downclocking of CPU cores occured.${NC}\n"
				else
					echo -e "${LRED}${BOLD}${Warning}${NC}\n"
				fi
			fi
			;;
	esac
} # CheckForThrottling

ReportCpufreqStatistics() {
	# Displays cpufreq driver statistics from before and after the benchmark as comparison
	if [ -f "${TempDir}/full_time_in_state_before_${1}" ]; then
		echo -e "\nThrottling statistics (time spent on each cpufreq OPP)${2}:\n" >>"${TempDir}/throttling_info.txt"
		awk -F" " '{print $1}' <${TempDir}/full_time_in_state_before_${1} | sort -r -n | while read ; do
			if [ ${REPLY} -le ${MaxKHz:-90000000} ]; then
				BeforeValue=$(awk -F" " "/^${REPLY} / {print \$2}" <${TempDir}/full_time_in_state_before_${1})
				AfterValue=$(awk -F" " "/^${REPLY} / {print \$2}" <${TempDir}/full_time_in_state_after_${1})
				if [ ${AfterValue} -eq ${BeforeValue} ]; then
					Duration=0
				else
					Duration=$(awk '{printf ("%0.2f",$1/100); }' <<<$(( ${AfterValue} - ${BeforeValue} )) )
				fi
				echo -e "$(printf "%4s" $(( ${REPLY} / 1000 )) ) MHz: $(printf "%7s" ${Duration}) sec" >>"${TempDir}/throttling_info.txt"
			fi
		done
	fi
} # ReportCpufreqStatistics

Parse_ADC_Readouts() {
	# this function tries to multiply all amperage and voltage values spitten out by the
	# RPi 5B PMIC ADCs. Querying ThreadX via 'vcgencmd pmic_read_adc' will result in
	# something like this: https://gist.github.com/ThomasKaiser/f98c6f97a2f82d85791cbaf6cebf10b8

	grep current <<<"${1}" | while read ; do
		PowerRail="${REPLY%_A*}"
		Ampere=$(sed 's/A//' <<<"${REPLY##*=}")
		Voltage=$(grep "${PowerRail}_V" <<<"${1}")
		[ -n "${Voltage}" ] && echo "${Ampere} ${Voltage##*=}" | sed 's/V//'
	done
} # Parse_ADC_Readouts

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
	DIMMDetails="$(lshw -C memory 2>/dev/null | grep -E "^          |-bank:" | grep -vi "serial:")"
	if [ "X${DIMMDetails}" != "X" ]; then
		if [ "X${VirtWhat}" = "X" ] || [ "X${VirtWhat}" = "Xnone" ]; then
			# only report DIMM config when running bare metal
			echo "${DIMMDetails}" >"${TempDir}/dimms"
			# unfortunately lshw only reports max clockspeeds of DIMM modules so we try to
			# get configured speed via dmidecode as well
			DIMMFilter="$(echo -e "\tLocator:|\tConfigured Memory Speed:|\tConfigured Clock Speed:")"
			command -v dmidecode >/dev/null 2>&1 && dmidecode --type 17 | grep -E "${DIMMFilter}" | tr "\n" "|" | sed -e 's/|\tCon/:/g' -e 's/\ //g' | tr '|' '\n' | grep -vi "unknown$" | while read ; do
				Pattern="$(awk -F":" '{print $2}' <<<"${REPLY}")"
				Insertion="$(awk -F":" '{print $4}' <<<"${REPLY}" | sed 's/\//\\\//')"
				if [ "X${Insertion}" != "X" ]; then
					sed -i "s/^          slot: ${Pattern}$/          configured speed: ${Insertion}/g" "${TempDir}/dimms"
				fi
			done
			echo -e "\nDIMM configuration:"
			cat "${TempDir}/dimms"
		fi
	fi

	# in MODE=extensive check wether there's even more detailed DIMM info available via i2c
	if [ "X${MODE}" = "Xextensive" ]; then
 		unset DIMMDetails
 		modprobe eeprom >/dev/null 2>&1
 		command -v decode-dimms >/dev/null 2>&1 && \
 			DIMMDetails="$(decode-dimms 2>/dev/null | sed -ne '/Decoding EEPROM/,$ p' | sed '/^$/N;/^\n$/D' | grep -v Serial)"
 		if [ "X${DIMMDetails}" != "X" ]; then
 			echo -e "\n${DIMMDetails}"
 		fi
 	fi
 
	if [ ${#ClusterConfig[@]} -gt 1 ] || [ "${CPUArchitecture}" = "riscv64" ]; then
		# only output individual cache sizes from sysfs on RISC-V or if more than 1 CPU
		# cluster (since otherwise lscpu already reported the full picture)
		find /sys/devices/system/cpu -name "cache" -type d 2>/dev/null | sort -V | while read ; do
			find "${REPLY}" -name size -type f 2>/dev/null | while read ; do
				echo -e "\n${REPLY}: $(cat ${REPLY})\c"
				[ -f ${REPLY%/*}/level ] && echo -e ", level: $(cat ${REPLY%/*}/level)\c"
				[ -f ${REPLY%/*}/type ] && echo -e ", type: $(cat ${REPLY%/*}/type)\c"
			done
		done | sed -e 's|/sys/devices/system/cpu/||' -e 's|cache/||' -e 's|/size||' | sort -V
	fi
	echo ""
} # CacheAndDIMMDetails

GuessARMSoC() {
	# function that tries to guess ARM SoC names correctly
	#
	# ARM core types/steppings this function deals with as of early 2024:
	# https://gist.github.com/ThomasKaiser/1fef6a6a09b07d48632ca99ec075a1df
	#
	# For a rough performance estimate wrt different Cortex ARMv8 cores see:
	# https://www.cnx-software.com/2021/12/10/starfive-dubhe-64-bit-risc-v-core-12nm-2-ghz-processors/#comment-588823
	#
	# As for the logic wrt Rockchip and Amlogic BSP kernel output parsing see here please:
	# https://gist.github.com/ThomasKaiser/f28027f182ff9ae7bfa60065c950be75
	#
	# MIDR_EL1 related stuff: https://gist.github.com/ThomasKaiser/d99228ac986378c41f4f8e6bc3f5cb70
	#
	# Allwinner SID related stuff: https://gist.github.com/ThomasKaiser/05a0ec1685ee19b3713640b06431d2b7

	# If in simulation mode (-m and CPUINFOFILE set) skip all SoC vendor specific detection
	# mechanisms (dmesg, nvmem)
	if [ "X${ProcCPUFile}" != "X/proc/cpuinfo}" ]; then
		SoCGuess="$(GuessSoCbySignature)"
		if [ "X${SoCGuess}" != "X" ] && [ "X${MonitorMode}" = "XTRUE" ]; then
			echo "${SoCGuess}"
			return
		fi
	fi

	[ "X${AW_NVMEM}" != "X" ] && Allwinner_SID=" (SID: ${AW_NVMEM:19:2}${AW_NVMEM:16:2}${AW_NVMEM:13:2}${AW_NVMEM:10:2})" || Allwinner_SID=""
	HardwareInfo="$(awk -F': ' '/^Hardware/ {print $2}' <<< "${ProcCPU}" | tail -n1)"
	RockchipGuess="$(awk -F': ' '/rockchip-cpuinfo cpuinfo: SoC/ {print $3}' <<<"${DMESG}" | head -n1)"
	AmlogicGuess="Amlogic Meson$(grep -i " detected$" <<<"${DMESG}" | awk -F"Amlogic Meson" '/Amlogic Meson/ {print $2}' | head -n1)"
	AMLS4Guess="$(awk -F"= " '/cpu_version: chip version/ {print $2}' <<<"${DMESG}")"

	if [ "X${RockchipGuess}" != "X" ] && [ "X${RockchipGuess}" != "X0" ]; then
		# use Rockchip SoC info from dmesg output
		if [ "X${RK_NVMEM}" != "X" ] && [ "${RockchipGuess:0:4}" = "3588" ]; then
			case "${RK_NVMEM:28:2}" in
				21)
					echo "Rockchip RK3588 (${RockchipGuess} / ${RK_NVMEM:16:42})"
					;;
				33)
					echo "Rockchip RK3588S (${RockchipGuess} / ${RK_NVMEM:16:42})"
					;;
				53)
					echo "Rockchip RK3588S2 (${RockchipGuess} / ${RK_NVMEM:16:42})"
					;;
				*)
					echo "Rockchip RK3588/RK3588S/RK3588S2 (${RockchipGuess} / ${RK_NVMEM:16:42})"
					;;
			esac
		elif [ "X${RK_NVMEM}" != "X" ]; then
			echo "Rockchip RK${RockchipGuess:0:4} (${RockchipGuess} / ${RK_NVMEM:16:42})" | sed 's| RK3588| RK3588/RK3588S/RK3588S2|'
		else
			echo "Rockchip RK${RockchipGuess:0:4} (${RockchipGuess})" | sed 's| RK3588| RK3588/RK3588S/RK3588S2|'
		fi
	elif [ "X${RK_NVMEM}" != "X" ]; then
		# use Rockchip NVMEM available below /sys/bus/nvmem/devices/rockchip* to parse SoC model from there
		case ${RK_NVMEM:16:5} in
			03*|13*|23*|53*|81*)
				# reverse order: 52 4b 23 82 -> RK3228, also affects RK3288
				# RK3228A and RK3229 share same '52 4b 23 82' signature
				echo "Rockchip RK${RK_NVMEM:17:1}${RK_NVMEM:16:1}${RK_NVMEM:20:1}${RK_NVMEM:19:1}" | sed 's|3228|3229/RK3228A|'
				;;
			33*)
				# unknown order, affects RK3306, RK3308, RK3318, RK3326, RK3328, RK3358 and in theory RK3399
				case ${RK_NVMEM:19:2} in
					80|81|62|82|85)
						# reverse order: 52 4b 33 81 -> RK3318, also affects RK3328
						echo "Rockchip RK${RK_NVMEM:17:1}${RK_NVMEM:16:1}${RK_NVMEM:20:1}${RK_NVMEM:19:1}"
						;;
					*)
						# normal order
						echo "Rockchip RK${RK_NVMEM:16:2}${RK_NVMEM:19:2}"
						;;
				esac
				;;
			11*)
				# unknown order, affects RV1103, RV1106, RV1109 and RV1126
				case ${RK_NVMEM:19:2} in
					30|60|62|90)
						echo "Rockchip RV11${RK_NVMEM:20:1}${RK_NVMEM:19:1}"
						;;
					*)
						echo "Rockchip RV11${RK_NVMEM:19:2}"
						;;
				esac
				;;
			"35 88")
				# RK3588/RK3588S/RK3588S2, normal order: 52 4b 35 88 -> RK3588
				case "${RK_NVMEM:28:2}" in
					21)
						echo "Rockchip RK3588 / ${RK_NVMEM:16:42}"
						;;
					33)
						echo "Rockchip RK3588S / ${RK_NVMEM:16:42}"
						;;
					53)
						echo "Rockchip RK3588S2 / ${RK_NVMEM:16:42}"
						;;
					*)
						echo "Rockchip RK3588/RK3588S/RK3588S2 / ${RK_NVMEM:16:42}"
						;;
				esac
				;;
			*)
				# normal order: 52 4b 35 28 -> RK3528, also affects RK3566, RK3568, RK3582, RK3583
				echo "Rockchip RK${RK_NVMEM:16:2}${RK_NVMEM:19:2} / ${RK_NVMEM:16:42}"
				;;
		esac
	elif [ "X${AmlogicGuess}" != "XAmlogic Meson" ]; then
		echo "${AmlogicGuess}" | sed -e 's/GXL (Unknown) Revision 21:b (2:2)/GXL (S905D) Revision 21:b (2:2)/' \
		-e 's/GXL (Unknown) Revision 21:c (84:2)/GXL (S905X) Revision 21:c (84:2)/' \
		-e 's/GXL (Unknown) Revision 21:c (c2:2)/GXL (S905L) Revision 21:c (c2:2)/' \
		-e 's/GXL (Unknown) Revision 21:c (e2:2)/GXL (S905X) Revision 21:c (e2:2)/' \
		-e 's/GXL (Unknown) Revision 21:d (4:2)/GXL (S905D) Revision 21:d (4:2)/' \
		-e 's/GXL (Unknown) Revision 21:d (a4:2)/GXL (S905W) Revision 21:d (a4:2)/' \
		-e 's/GXM (Unknown) Revision 22:a (82:2)/GXM (S912) Revision 22:a (82:2)/' \
		-e 's/AXG (Unknown) Revision 25:b (43:2)/AXG (A113X) Revision 25:b (43:2)/' \
		-e 's/AXG (Unknown) Revision 25:c (43:2)/AXG (A113X) Revision 25:c (43:2)/' \
		-e 's/G12A (Unknown) Revision 28:b (30:2)/G12A (S905Y2) Revision 28:b (30:2)/' \
		-e 's/G12A (Unknown) Revision 28:c (30:2)/G12A (S905Y2) Revision 28:c (30:2)/' \
		-e 's/G12A (Unknown) Revision 28:b (70:2)/G12A (S905L3A) Revision 28:b (70:2)/' \
		-e 's/G12A (Unknown) Revision 28:c (70:2)/G12A (S905L3A) Revision 28:c (70:2)/' \
		-e 's/SM1 (Unknown) Revision 2b:b (1:2)/SM1 (S905D3) Revision 2b:b (1:2)/' \
		-e 's/SM1 (Unknown) Revision 2b:c (10:2)/SM1 (S905X3) Revision 2b:c (10:2)/' \
		-e 's/ Detected//' -e 's/ detected//'
	elif [ "X${AMLS4Guess}" != "X" ]; then
		case ${AMLS4Guess} in
			*" 3:4")
				echo "Amlogic Meson S4 (S905Y4) Revision ${AMLS4Guess}"
				;;
			*)
				echo "Amlogic Meson S4 (S805X2 or S905Y4) Revision ${AMLS4Guess}"
				;;
		esac
	else
		# Guessing by 'Hardware :' in /proc/cpuinfo is something that only reliably works
		# with vendor's BSP kernels. With mainline kernel it's impossible to rely on this
		case ${HardwareInfo} in
			Amlogic*)
				ModelName="$(awk -F': ' '/^model name/ {print $2}' <<< "${ProcCPU}" | tail -n1)"
				case "${ModelName}" in
					Amlogic*)
						echo "${ModelName}"
						;;
					*)
						AmLogicSerial="$(awk -F': ' '/^AmLogic Serial/ {print $2}' <<< "${ProcCPU}" | tail -n1)"
						if [ "X${AmLogicSerial}" = "X" ]; then
							AmLogicSerial="$(awk -F': ' '/^Serial/ {print $2}' <<< "${ProcCPU}" | tail -n1)"
						fi
						case "${AmLogicSerial}" in
							19*)
								# Meson8: S802: RevC (19 - 0:27ED)
								echo "Amlogic S802"
								;;
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
								ParseAmlSerial GXBB S905
								;;
							1f??23*)
								# GXBB: S905H: 1f:c (23:1)
								ParseAmlSerial GXBB S905H
								;;
							1f??20*)
								# GXBB: S905M
								ParseAmlSerial GXBB S905M
								;;
							1f*)
								# GXBB: S905, S905H, S905M
								# - S905: 1f:b (0:1) / 1f:c (0:1)
								# - S905H: 1f:c (23:1)
								ParseAmlSerial GXBB S905/S905H/S905M
								;;
							20*)
								# GXTVBB
								ParseAmlSerial GXTVBB Unknown
								;;
							21??0*|21??4*)
								# GXL: S905D: 21:d (0:2), 21:d (4:2)
								ParseAmlSerial GXL S905D
								;;
							21??3*)
								# GXL: S805X: 21:d (34:2)
								ParseAmlSerial GXL S805X
								;;
							21??8*)
								# GXL: S905X: 21:a (82:2), 21:b (82:2), 21:c (84:2), 21:d (84:2)
								ParseAmlSerial GXL S905X
								;;
							21??a*)
								# GXL: S905W: 21:b (a2:2), 21:e (a5:2)
								ParseAmlSerial GXL S905W
								;;
							21??b*)
								# GXL: S805Y
								ParseAmlSerial GXL S805Y
								;;
							21??c*)
								# GXL: S905L: 21:b (c2:2), 21:c (c4:2), 21:d (c4:2), 21:e (c5:2)
								ParseAmlSerial GXL S905L
								;;
							21??e*)
								# GXL: S905M2: 21:b (e2:2), 21:d (e4:2)
								ParseAmlSerial GXL S905M2
								;;
							21*)
								# GXL: S805X, S805Y, S905X, S905D, S905W, S905L, S905L2, S905M2
								# - S905D: 21:d (0:2), 21:d (4:2)
								# - S805X: 21:d (34:2)
								# - S905X: 21:a (82:2), 21:b (82:2), 21:c (84:2), 21:d (84:2)
								# - S905W: 21:b (a2:2), 21:e (a5:2)
								# - S905L: 21:b (c2:2), 21:c (c4:2), 21:d (c4:2), 21:e (c5:2)
								# - S905M2: 21:b (e2:2), 21:d (e4:2)
								ParseAmlSerial GXL Unknown
								;;
							22*)
								# GXM: S912: 22:a (82:2), 22:b (82:2)
								ParseAmlSerial GXM S912
								;;
							23*)
								# TXL
								ParseAmlSerial TXL Unknown
								;;
							24??10*)
								# TXLX: T962X
								ParseAmlSerial TXLX T962X
								;;
							24??20*)
								# TXLX: T962E
								ParseAmlSerial TXLX T962E
								;;
							24*)
								# TXLX: T962X, T962E
								ParseAmlSerial TXLX Unknown
								;;
							25??22*)
								# AXG: A113D
								ParseAmlSerial AXG A113D
								;;
							25??37*)
								# AXG: A113X
								ParseAmlSerial AXG A113X
								;;
							25*)
								# AXG: A113X, A113D
								# - Unknown: 25:b (43:2), 25:c (43:2)
								ParseAmlSerial AXG Unknown
								;;
							26*)
								# GXLX, seems to be compatible to GXL since one occurence of ID '26:e (c1:2)'
								# has been detected with 'Amlogic Meson GXL (S905X) P212 Development Board'
								# and same ID on IPBS9505 TV box
								ParseAmlSerial GXLX Unknown
								;;
							27*)
								# TXHD
								ParseAmlSerial TXHD Unknown
								;;
							28??1*)
								# G12A: S905D2: 28:b (10:2)
								ParseAmlSerial G12A S905D2
								;;
							28??3*)
								# G12A: S905Y2: 28:b (30:2)
								ParseAmlSerial G12A S905Y2
								;;
							28??4*)
								# G12A: S905X2: 28:b (40:2)
								ParseAmlSerial G12A S905X2
								;;
							28??7*)
								# G12A: S905L3A: 28:b (70:2)
								ParseAmlSerial G12A S905L3A
								;;
							28*)
								# G12A: S905X2, S905D2, S905Y2
								# - S905X2: 28:b (40:2)
								# - S905Y2: 28:b (30:2)
								# - S905L3A: 28:b (70:2)
								ParseAmlSerial G12A Unknown
								;;
							29??1*)
								# - G12B: A311D: 29:b (10:2)
								# - G12B: A311D: 29:c (10:0)
								ParseAmlSerial G12B A311D
								;;
							29??4*)
								# - G12B: S922X: 29:a (40:2), 29:b (40:2), 29:c (40:2)
								ParseAmlSerial G12B S922X
								;;
							29*)
								# G12B: A311D, S922X
								# - A311D: 29:b (10:2)
								# - S922X: 29:a (40:2), 29:b (40:2)
								# - 'S922X-B': 29:c (40:2)
								ParseAmlSerial G12B Unknown
								;;
							2a*)
								# GXLX2: some weird GXL variant, most probably for S905L2 only
								# https://www.cnx-software.com/2020/09/15/low-cost-amlogic-s905l2-tv-boxes-show-up-on-aliexpress-for-20/
								# http://ix.io/45QA / http://ix.io/3RLI
								# Fake 2 GHz while in reality 1.2 GHz, 'Revision 2a:e (c5:2)'
								# while S905L always appears as 'Revision 21:X (cX:X)'
								ParseAmlSerial GXLX2 S905L2
								;;
							2b??05*|2b??10*)
								# SM1: S905X3: 2b:c (10:2)
								ParseAmlSerial SM1 S905X3
								;;
							2b??01*|2b??04*|2b??30*)
								# SM1: S905D3: 2b:b (1:2), 2b:c (4:2)
								ParseAmlSerial SM1 S905D3
								;;
							2b*)
								# SM1: S905X3, S905D3, S905Y3: 2b:b (1:2), 2b:c (4:2), 2b:c (10:2), 2b:b (40:2)
								ParseAmlSerial SM1 Unknown
								;;
							2c*)
								# A1: A113L (dual A35: https://www.amlogic.com/#Products/408/index.html / meson-a1.dtsi)
								ParseAmlSerial A1 A113L
								;;
							2e*)
								# TL1: T962X2
								ParseAmlSerial TL1 T962X2
								;;
							2f*)
								# TM2: T962X3, T962E2 (quad-core A55)
								ParseAmlSerial TM2 T962X3/T962E2
								;;
							30*)
								# C1
								ParseAmlSerial C1 Unknown
								;;
							32??02*)
								# SC2: S905X4: 32:b (2:2)
								ParseAmlSerial SC2 S905X4
								;;
							32*)
								# SC2: S905X4, S905C2
								ParseAmlSerial SC2 S905X4/S905C2
								;;
							33*)
								# C2
								ParseAmlSerial C2 Unknown
								;;
							34*)
								# T5
								ParseAmlSerial T5 Unknown
								;;
							35*)
								# T5D: T950D4, T950X4 (quad-core A53)
								ParseAmlSerial T5D Unknown
								;;
							360b*)
								# T7: A311D2, POP1-G: 36:b (1:3)
								ParseAmlSerial T7 A311D2
								;;
							360c*)
								# T7C: A311D2-N0D (A311D2 with NPU and different ISP): 36:c (1:2)
								# https://docs.khadas.com/products/sbc/vim4/configurations/identify-version / https://archive.md/YUeWa
								ParseAmlSerial T7C A311D2-N0D
								;;
							370b*)
								# S4: S905Y4
								ParseAmlSerial S4 S905Y4
								;;
							37*)
								# S4: S905Y4, S805X2, S905W2
								ParseAmlSerial S4 S905Y4/S805X2/S905W2
								;;
							38*)
								# T3: T965D4, T963D4, T982 (quad-core A55)
								ParseAmlSerial T3 Unknown
								;;
							39*)
								# P1: (8 x A55) https://tinyurl.com/ye8m9uf4
								ParseAmlSerial P1 Unknown
								;;
							3a*)
								# S4D: S805C3, S905C3, S905C3ENG (quad Cortex-A35): https://archive.md/4H6xM
								# but quad-core A55 according to Amlogic 5.4 BSP kernel: tinyurl.com/r598z7aa
								# and CoreElec device tree files
								# https://tinyurl.com/y85lsxsc and/vs. https://tinyurl.com/5n99muj6
								ParseAmlSerial S4D Unknown
								;;
							3b*)
								# T5W: T962D4 (quad-core A55)
								ParseAmlSerial T5W Unknown
								;;
							3c*)
								# A5: A113X2 (quad-core A55)
								ParseAmlSerial A5 Unknown
								;;
							3d*)
								# C3
								ParseAmlSerial C3 Unknown
								;;
							3e*)
								# S5: S928X (4 x A55 + 1 x A76) https://tinyurl.com/mpwhcsua
								ParseAmlSerial S5 Unknown
								;;
							*)
								# https://tinyurl.com/wwuwdef7
								ParseAmlSerial Unknown Unknown
								;;
						esac
						;;
				esac
				;;
			sun3i*)
				# SoC ID: 0x1663
				echo "Allwinner F1C100s/F1C100A/F1C200s/F1C500/F1C500s/F1C600/F1D100/R6${Allwinner_SID}"
				;;
			sun4i*)
				# SoC ID: 0x1623
				echo "Allwinner A10${Allwinner_SID}"
				;;
			sun5i*)
				# SoC ID: 0x1625
				echo "Allwinner A10s/A13/R8${Allwinner_SID}"
				;;
			sun8iw10*)
				# SoC ID: 0x1699
				echo "Allwinner B288/B100${Allwinner_SID}"
				;;
			sun8iw11*)
				# SoC ID: 0x1701
				echo "Allwinner R40/V40/T3/A40i${Allwinner_SID}"
				;;
			sun8iw12*)
				# SoC ID: 0x1721
				echo "Allwinner V5/V100${Allwinner_SID}"
				;;
			sun8iw15*)
				# SoC ID: 0x1755
				echo "Allwinner A50/MR133/R311${Allwinner_SID}"
				;;
			sun8iw16*)
				# SoC ID: 0x1816
				echo "Allwinner V313/V316/V526/V536/V5V200${Allwinner_SID}"
				;;
			sun8iw17*)
				echo "Allwinner T7${Allwinner_SID}"
				;;
			sun8iw18*)
				echo "Allwinner R328${Allwinner_SID}"
				;;
			sun8iw19*)
				# SoC ID: 0x1817
				echo "Allwinner V533/V833/V831${Allwinner_SID}"
				;;
			sun6i*|sun8iw1*)
				# SoC ID: 0x1633
				echo "Allwinner A31/A31s${Allwinner_SID}"
				;;
			sun8iw20*)
				# SoC ID: 0x1859
				echo "Allwinner F133/H133/R528/T113${Allwinner_SID}"
				;;
			sun8iw21*)
				# SoC ID: 0x1886, https://v853.docs.aw-ol.com
				echo "Allwinner R853/V851S/V851SE/V853${Allwinner_SID}"
				;;
			sun7iw2*|sun8iw2*)
				# SoC ID: 0x1651
				echo "Allwinner A20${Allwinner_SID}"
				;;
			sun8iw3*)
				# SoC ID: 0x1650
				echo "Allwinner A23${Allwinner_SID}"
				;;
			sun8iw5*)
				# SoC ID: 0x1667
				echo "Allwinner A33/R16${Allwinner_SID}"
				;;
			sun8iw6*)
				# SoC ID: 0x1673
				echo "Allwinner A83T/H8/H80/V66/R58${Allwinner_SID}"
				;;
			sun8iw7*)
				# SoC ID: 0x1680
				echo "Allwinner H3/H2+${Allwinner_SID}"
				;;
			sun8iw8*)
				# SoC ID: 0x1681
				echo "Allwinner V3/S3/V3s${Allwinner_SID}"
				;;
			sun9i*)
				# SoC ID: 0x1639
				echo "Allwinner A80${Allwinner_SID}"
				;;
			sun20iw1*)
				# https://d1.docs.aw-ol.com / https://d1s.docs.aw-ol.com
				echo "Allwinner D1${Allwinner_SID}"
				;;
			sun20iw2*)
				# https://r128.docs.aw-ol.com
				echo "Allwinner R128${Allwinner_SID}"
				;;
			sun50iw1p*)
				# SoC ID: 0x1689
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
									echo "Allwinner A64${Allwinner_SID}"
									;;
								sun50iw2)
									echo "Allwinner H5${Allwinner_SID}"
									;;
								sun50iw6)
									echo "Allwinner H6${Allwinner_SID}"
									;;
								sun50iw9)
									echo "Allwinner H616/H313/H618${Allwinner_SID}"
									;;
								*)
									echo "Allwinner A64${Allwinner_SID} or https://tinyurl.com/yyf3d7fg"
									;;
							esac
						else
							echo "Allwinner A64${Allwinner_SID} or https://tinyurl.com/yyf3d7fg"
						fi
						;;
					*)
						echo "${AllwinnerGuess}${Allwinner_SID}"
						;;
				esac
				;;
			sun50iw2*)
				# SoC ID: 0x1718
				echo "Allwinner H5${Allwinner_SID}"
				;;
			sun50iw3*)
				# SoC ID: 0x1719
				echo "Allwinner A63${Allwinner_SID}"
				;;
			sun50iw6*)
				# SoC ID: 0x1728
				echo "Allwinner H6${Allwinner_SID}"
				;;
			sun50iw9*)
				# SoC ID: 0x1823
				echo "Allwinner H313/H503/H513/H616/H618/H700/T507/T517${Allwinner_SID}"
				;;
			sun50iw10*)
				# SoC ID: 0x1855
				echo "Allwinner A100/A133/A53/B810/MR813/R818/T509${Allwinner_SID}"
				;;
			sun50iw11*)
				# SoC ID: 0x1851, https://r329.docs.aw-ol.com
				echo "Allwinner R329${Allwinner_SID}"
				;;
			sun50iw12*)
				# SoC ID: 0x1860
				echo "Allwinner TV303${Allwinner_SID}"
				;;
			sun55iw3*)
				# SoC ID: 0x1890
				echo "Allwinner A523/A527/T523/T527/MR527${Allwinner_SID}"
				;;
			sun55iw5*)
				echo "Allwinner TV301${Allwinner_SID}"
				;;
			sun60iw1*)
				echo "Allwinner A736/T736${Allwinner_SID}"
				;;
			sun60iw2*)
				echo "Allwinner A733${Allwinner_SID}"
				;;
			sun*)
				SoCGuess="$(GuessSoCbySignature)"
				[ "X${SoCGuess}" = "X" ] && echo "unknown Allwinner SoC${Allwinner_SID}" || echo "${SoCGuess}${Allwinner_SID}"
				;;
			Allwinner*)
				SoCGuess="$(GuessSoCbySignature)"
				[ "X${SoCGuess}" = "X" ] && sed -e 's/ board//' -e 's/ Family//' <<<"${HardwareInfo}" || echo "${SoCGuess}${Allwinner_SID}"
				;;
			Hardkernel*)
				case ${HardwareInfo} in
					*XU3|*XU4|*HC1|*HC2|*MC1|*XU4Q)
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
					*M1S)
						echo "Rockchip RK3566"
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
				if [ "X${SoCGuess}" != "X" ] && [ "X${VirtWhat}" != "X" ] && [ "X${VirtWhat}" != "Xnone" ]; then
					# add virtualization disclaimer
					echo "${SoCGuess}${Allwinner_SID} / guessing impossible since running in ${VirtWhat}"
				else
					echo "${SoCGuess:-n/a}${Allwinner_SID}"
				fi
				;;
		esac
	fi
} # GuessARMSoC

ParseAmlSerial() {
	# gets SoC family and SoC guess as $1/$2 and then translates the Serial number's digits
	# 0-7 into Soc variant/revision details. Looks like this for example:
	# GXL S905X 210a820094e04a85134XXXXXXXXXXXXX -> Amlogic Meson GXL (S905X) Revision 21:a (82:0)
	# T7 A311D2 360b0103000000000e0XXXXXXXXXXXXX -> Amlogic Meson T7 (A311D2) Revision 36:b (1:3)
	# SC2 S905X4 320b020200000000190XXXXXXXXXXXXX -> Amlogic Meson SC2 (S905X4) Revision 32:b (2:2)
	echo "Amlogic Meson ${1} (${2}) Revision ${AmLogicSerial:0:2}:${AmLogicSerial:2:2} (${AmLogicSerial:4:2}:${AmLogicSerial:6:2})" | sed -e 's/:0/:/g' -e 's/(0/(/'
} # ParseAmlSerial

GuessSoCbySignature() {
	# Guess by CPU topology (core types and revision, clusters and cpufreq policies) and by
	# specific features/flags. Skip whole check if one or more cores are offline.

	if [ "X${OfflineCores}" != "X" ]; then
		echo "Not able to guess since these CPU cores are offline: ${OfflineCores}"
		return 1
	fi

	case ${CPUSignature} in
		??A8r1p3)
			# TI OMAP3530, Cortex-A8 / r1p3 / swp half thumb fastmult vfp edsp thumbee neon
			echo "TI Sitara OMAP3530"
			;;
		??A8r1p7)
			# TI Sitara AM35xx, Cortex-A8 / r1p7
			echo "TI Sitara AM35xx"
			;;
		??A8r2p2)
			# Samsung Exynos 3110 (S5PC110): 1 x Cortex-A8 / r2p2 / swp half thumb fastmult vfp edsp thumbee neon vfpv3
			echo "Samsung Exynos 3110 (S5PC110)"
			;;
		??A8r2p5)
			# Freescale/NXP i.MX515: 1 x Cortex-A8 / r2p5 / https://bench.cr.yp.to/computers.html
			echo "Freescale/NXP i.MX515"
			;;
		??A8r3p2)
			# TI OMAP3530/DM3730/AM335x or Allwinner A10, 1 x Cortex-A8 / r3p2 / half thumb fastmult vfp edsp neon vfpv3 tls vfpd32
			case "${Allwinner_SID:7:8}" in
				1623*)
					echo "Allwinner A10"
					;;
				1625*)
					echo "Allwinner A10s/A13/R8"
					;;
				*)
					lsmod | grep -i -q sun4i
					case $? in
						0)
							# Allwinner A10, 1 x Cortex-A8 / r3p2 / half thumb fastmult vfp edsp neon vfpv3 tls vfpd32
							echo "Allwinner A10"
							;;
						*)
							case "${DTCompatible,,}" in
								*sun4i*)
									# Allwinner A10, 1 x Cortex-A8 / r3p2 / half thumb fastmult vfp edsp neon vfpv3 tls vfpd32
									echo "Allwinner A10"
									;;
								*sun5i*)
									# Allwinner A10s/A13/R8, 1 x Cortex-A8 / r3p2 / half thumb fastmult vfp edsp neon vfpv3 tls vfpd32
									echo "Allwinner A10s/A13/R8"
									;;
								*)
									# TI DM3730/AM335x, 1 x Cortex-A8 / r3p2 / half thumb fastmult vfp edsp neon vfpv3 tls vfpd32
									echo "TI DM3730/AM335x"
									;;
								esac
							;;
					esac
					;;
			esac
			;;
		00A7r0p5)
			# Allwinner R853/S3/V3/V3s/V533/V831/V833/V851S/V851SE/V853, 1 x Cortex-A7 / r0p5 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm
			# or maybe Microchip SAMA7G54, 1 x Cortex-A7 / r0p5
			# or maybe Rockchip RV1108 | 1 x Cortex-A7 / r0p5
			case "${DTCompatible,,}" in
				*rockchip*)
					# Rockchip RV1108 | 1 x Cortex-A7 / r0p5
					echo "Rockchip RV1108"
					;;
				*sun8iw8*)
					# Allwinner S3/V3/V3s, 1 x Cortex-A7 / r0p5 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm
					echo "Allwinner S3/V3/V3s"
					;;
				*sun8iw19*)
					# Allwinner V533/V831/V833, 1 x Cortex-A7 / r0p5 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm
					echo "Allwinner V533/V831/V833"
					;;
				*sun8iw21*)
					# Allwinner R853/V851S/V851SE/V853, 1 x Cortex-A7 / r0p5 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm
					echo "Allwinner R853/V851S/V851SE/V853"
					;;
				*allwinner*)
					# Allwinner R853/S3/V3/V3s/V533/V831/V833/V851S/V851SE/V853, 1 x Cortex-A7 / r0p5 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm
					echo "Allwinner R853/S3/V3/V3s/V533/V831/V833/V851S/V851SE/V853"
					;;
				*)
					# Microchip SAMA7G54, 1 x Cortex-A7 / r0p5
					echo "Microchip SAMA7G54"
					;;
			esac
			;;
		??A9r3p0??A9r3p0??A9r3p0??A9r3p0)
			# RK3188 or Exynos 4412 or Nexell S5P4418, 4 x Cortex-A9 / r3p0 / half thumb fastmult vfp edsp thumbee neon vfpv3 tls vfpd32
			case "${DTCompatible,,}" in
				*s5p4418*)
					echo "Nexell S5P4418"
					;;
				*samsung*)
					echo "Exynos 4412"
					;;
				*rk3188*)
					echo "Rockchip RK3188"
					;;
			esac
			;;
		??A9r3p0??A9r3p0)
			# AML8726-MX, 2 x Cortex-A9 / r3p0 / half thumb fastmult vfp edsp thumbee neon vfpv3 tls vfpd32
			# or RK3066, 2 x Cortex-A9 / r3p0 / swp half thumb fastmult vfp edsp neon vfpv3 / https://lore.kernel.org/all/CAAFQd5CN_xvkdD+Bf9A+Mc+_jVxtdOKosrYH_8bNNHkGQw7eGA@mail.gmail.com/T/
			# or ST Micro STiH415, 2 x Cortex-A9 / r3p0 / swp half thumb fastmult vfp edsp neon vfpv3 tls
			case "${DTCompatible,,}" in
				*amlogic*)
					echo "Amlogic AML8726-MX"
					;;
				*rk3066*)
					echo "Rockchip RK3066"
					;;
				*)
					echo "ST Micro STiH416"
					;;
			esac
			;;
		*A9r3p0)
			# Mediatek MT5880, 1 x Cortex-A9 / r3p0 / swp half thumb fastmult vfp edsp vfpv3 vfpv3d16
			# or ST Micro STiH415: 1 x Cortex-A9 / r3p0 / swp half thumb fastmult vfp edsp neon vfpv3 tls
			# or Xilinx Zynq 7000S:  1 x Cortex-A9 / r3p0 / half thumb fastmult vfp edsp neon vfpv3 tls vfpd32
			case "${DTCompatible,,}" in
				*mt5880*)
					echo "Mediatek MT5880"
					;;
				*xilinx*)
					echo "Xilinx Zynq 7000S"
					;;
				*)
					echo "ST Micro STiH415"
					;;
			esac
			;;
		00A7r0p400A7r0p4)
			# Allwinner A20, 2 x Cortex-A7 / r0p4 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm
			echo "Allwinner A20"
			;;
		00A7r0p500A7r0p500A7r0p500A7r0p5)
			# Allwinner sun8i: could be Allwinner H3/H2+, R40/V40/T3/A40i or A33/R16 or A50/MR133/R311 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm
			# or Spreadtrum SC7731/SC8830 or Rockchip RV1126/RK3126/RK3126B/RK3126C/RK3128
			case "${DTCompatible,,}" in
				*rv1126*)
					# Rockchip RV1126 | 4 x Cortex-A7 / r0p5
					echo "Rockchip RV1126"
					;;
				*rk3126b*)
					# Rockchip RK3126B | 4 x Cortex-A7 / r0p5
					echo "Rockchip RK3126B"
					;;
				*rk3126c*)
					# Rockchip RK3126C | 4 x Cortex-A7 / r0p5
					echo "Rockchip RK3126C"
					;;
				*rk3126*)
					# Rockchip RK3126 | 4 x Cortex-A7 / r0p5
					echo "Rockchip RK3126"
					;;
				*rk3128*)
					# Rockchip RK3128 | 4 x Cortex-A7 / r0p5
					echo "Rockchip RK3128"
					;;
				*rockchip*)
					# Rockchip RV1126 or RK3126/RK3126B/RK3126C or RK3128 | 4 x Cortex-A7 / r0p5
					echo "Rockchip RV1126 or RK3126/RK3126B/RK3126C or RK3128"
					;;
				*hi3796*)
					# HiSilicon Hi3796M-V100, 4 x Cortex-A7 / r0p5 / swp half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt
					echo "HiSilicon Hi3796M-V100"
					;;
				*hi3798*)
					# HiSilicon Hi3798M-V100, 4 x Cortex-A7 / r0p5 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae
					echo "HiSilicon Hi3798M-V100"
					;;
				*hisilicon*)
					# HiSilicon Hi3796M-V100 or Hi3798M-V100, 4 x Cortex-A7 / r0p5 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae
					echo "HiSilicon Hi3796M-V100 or Hi3798M-V100"
					;;
				*sc7731*)
					# Spreadtrum SC7731: 4 x Cortex-A7 / r0p5 / swp half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32
					echo "Spreadtrum SC7731"
					;;
				*sc8830*)
					# Spreadtrum SC8830: 4 x Cortex-A7 / r0p5 / swp half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32
					echo "Spreadtrum SC8830"
					;;
				*sun8i|*)
					case "${Allwinner_SID:7:8}" in
						02c00?81)
							echo "Allwinner H3"
							;;
						02c00?42)
							echo "Allwinner H2+"
							;;
						02c000*)
							echo "Allwinner H3/H2+"
							;;
						0461872a)
							echo "Allwinner A33/R16"
							;;
						12c00017|16554153)
							# checking sbc-bench submissions all BPI-M2 Berry/Ultra (R40/V40) show 16554153
							# as first part of the serial number (which should be the relevant SID part with
							# mainline kernel). Could be a bug in Allwinner's BSP kernel but the versions
							# were as follows: 5.1, 5.4, 5.10, 5.15, 5.16, 5.19, 6.0, 6.1, 6.2 and 6.4
							echo "Allwinner R40/V40"
							;;
						*)
							case "${DTCompatible,,}" in
								*sun8i-r40*|*sun8i-v40*|*sun8i-a40i*|*sun8i-t3*)
									# Allwinner R40/V40/T3/A40i, 4 x Cortex-A7 / r0p5 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm
									echo "Allwinner R40/V40/T3/A40i"
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
								*sun8iw15p1*|*sun8i-a50*)
									# Allwinner A50/MR133/R311, 4 x Cortex-A7 / r0p5 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm
									echo "Allwinner A50/MR133/R311"
									;;
								*)
									echo "Unknown"
							esac
							;;
					esac
					;;
			esac
			;;
		00A7r0p5000000)
			# Allwinner sun8i running with 3.x BSP kernel: could be Allwinner H3/H2+, R40/V40 or A33/R16 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm
			case "${DTCompatible,,}" in
				*sun8i*)
					# kernel 3.10 with device-tree support
					echo "Allwinner R40/V40"
					;;
				*)
					# kernel 3.4 w/o device-tree support
					echo "Allwinner H3/H2+ or A33/R16"
					;;
			esac
			;;
		*A7r0p5*A7r0p5*A7r0p5*A7r0p5*A15r4p0*A15r4p0*A15r4p0*A15r4p0)
			# Allwinner A80: 4 x Cortex-A7 / r0p5 + 4 x Cortex-A15 / r4p0 / swp half thumb fastmult vfp edsp thumbee neon vfpv3 tls vfpv4 idiva idivt
			# GB4 reports stepping of big core: https://browser.geekbench.com/v4/cpu/16436341.gb4, /proc/cpuinfo of little: https://nitter.net/miniNodes/status/533125394686562304
			echo "Allwinner A80"
			;;
		??A7r0p5??A7r0p5??A7r0p5??A7r0p5??A7r0p5??A7r0p5??A7r0p5??A7r0p5)
			# Allwinner A83T, 8 x Cortex-A7 / r0p5 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm
			echo "Allwinner A83T"
			;;
		20A5r0p120A5r0p120A5r0p120A5r0p1|2A5222|20A5r0p1202020)
			# Actions ATM8029, 4 x Cortex-A5 / r0p1 / ?
			# Amlogic S805/M805, 4 x Cortex-A5 / r0p1 / half thumb fastmult vfp edsp thumbee neon vfpv3 tls vfpv4 vfpd32 (3.10: swp half thumb fastmult vfp edsp neon vfpv3 tls vfpv4)
			# or Qualcomm MSM8625Q: 4 x Cortex-A5 / r0p1 / scp half thumb fastmult vfp edsp thumbee neon vfpv3 tls vfpv4
			case "${DTCompatible,,}" in
				*amlogic*)
					echo "Amlogic S805"
					;;
				*8625*)
					echo "Qualcomm MSM8625Q"
					;;
				*)
					echo "Actions ATM8029"
					;;
			esac
			;;
		20A9r4p120A9r4p120A9r4p120A9r4p1|2A9222)
			# Amlogic S802/S812: 4 x Cortex-A9 / r4p1 / half thumb fastmult vfp edsp thumbee neon vfpv3 tls vfpd32
			# or HiSilicon Hi6620: 4 x Cortex-A9 / r4p1 / swp half thumb fastmult vfp edsp thumbee neon vfpv3
			grep -q -i amlogic <<<"${DTCompatible,,}" && echo "Amlogic S802/S812" || echo "HiSilicon Hi6620"
			;;
		*A57r0p0*A57r0p0*A53r0p0*A53r0p0*A53r0p0*A53r0p0)
			# ARM Juno: 2 x Cortex-A57 / r0p0 + 4 x Cortex-A53 / r0p0 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			echo "ARM Juno r0"
			;;
		*A53r0p0*A53r0p0*A53r0p0*A53r0p0)
			# Snapdragon 410 / MSM8916/APQ8016: 4 x Cortex-A53 / r0p0 / fp asimd evtstrm crc32 cpuid
			echo "Snapdragon 410"
			;;
		*A53r0p4*A53r0p4*A53r0p4*A53r0p4*A72r0p0*A72r0p0*A72r0p0*A72r0p0)
			# Snapdragon 652/653 / MSM8976/MSM8976PRO: 4 x Cortex-A53 / r0p4 + 4 x Cortex-A72 / r0p0 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			# or HiSilicon 950/955: 4 x Cortex-A53 / r0p4 + 4 x Cortex-A72 / r0p0 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			case "${DTCompatible,,}" in
				*hisilicon*|*950*|*955)
					echo "HiSilicon Kirin 950/955"
					;;
				*snapdragon*|*652*|*653*)
					echo "Snapdragon 652/653"
					;;
			esac
			;;
		*A53r0p4*A53r0p4*A53r0p4*A53r0p4*A72r0p0*A72r0p0)
			# Snapdragon 650 / MSM8956: 4 x Cortex-A53 / r0p4 + 2 x Cortex-A72 / r0p0 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			echo "Snapdragon 650"
			;;
		*A53r0p3*A53r0p3*A53r0p3*A53r0p3*A57r1p2*A57r1p2)
			# Snapdragon 808 / MSM8992: 4 x Cortex-A53 / r0p3 + 2 x Cortex-A57 / r1p2 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			echo "Snapdragon 808"
			;;
		*A53r0p2*A53r0p2*A53r0p2*A53r0p2*A57r1p1*A57r1p1*A57r1p1*A57r1p1)
			# Snapdragon 810 / MSM8994/MSM8994V: 4 x Cortex-A53 / r0p2 + 4 x Cortex-A57 / r1p1 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			echo "Snapdragon 810"
			;;
		00QualcommV2r10p400QualcommV2r10p400QualcommV2r10p400QualcommV2r10p404QualcommV1Kryor10p104QualcommV1Kryor10p104QualcommV1Kryor10p104QualcommV1Kryor10p1)
			# Snapdragon 835 / MSM8998: 4 x Qualcomm Kryo V2 / r10p4 + 4 x  Qualcomm Falkor V1/Kryo / r10p1 / fp asimd aes pmull sha1 sha2 crc32
			echo "Snapdragon 835"
			;;
		*Kryor1p2*Kryor1p2*Kryor1p2*Kryor1p2)
			# Qualcomm MSM8996: 2 x Kryo r1p2 + 2 x Kryo r1p2 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			echo "Qualcomm MSM8996"
			;;
		*Kryor2p1*Kryor2p1*Kryor2p1*Kryor2p1)
			# Qualcomm MSM8996pro: 2 x Kryo r2p1 + 2 x Kryo r2p1 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			echo "Qualcomm MSM8996pro"
			;;
		00Qualcomm4XXSilver00Qualcomm4XXSilver00Qualcomm4XXSilver00Qualcomm4XXSilver00Qualcomm4XXSilver00Qualcomm4XXSilver06Qualcomm4XXGold06Qualcomm4XXGold)
			# Qualcomm Snapdragon 7c (SC7180): 6 x Kryo 468 Silver / r13p14 + 2 x Kryo 468 Gold / r15p15 / fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp asimdrdm lrcpc dcpop asimddp
			echo "Qualcomm Snapdragon 7c"
			;;
		*Qualcomm4XXSilver*Qualcomm4XXSilver*Qualcomm4XXSilver*Qualcomm4XXSilver*Qualcomm4XXGold*Qualcomm4XXGold*Qualcomm4XXGold*Qualcomm4XXGold)
			# Qualcomm SM8150 / Snapdragon 855: 4 x Qualcomm Kryo 4XX Silver / r13p14 + 4 x Qualcomm Kryo 4XX Gold / r13p14  / fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp asimdrdm lrcpc dcpop asimddp
			echo "Qualcomm SM8150 (Snapdragon 855)"
			;;
		*Qualcomm4XXSilver*Qualcomm4XXSilver*Qualcomm4XXSilver*Qualcomm4XXSilver*Qualcomm4XXGold*Qualcomm4XXGold*Qualcomm4XXGold*Qualcomm4XXGold*)
			# Qualcomm Snapdragon 7c+ Gen 3 (SC7280) or QCM6490: 4 x Kryo 468 Silver + 3 x Kryo 468 Gold + 1 x Kryo 468 Gold Plus
			case "${DTCompatible,,}" in
				*qcm6490*)
					echo "Qualcomm QCM6490"
					;;
				*sc7280*)
					echo "Qualcomm Snapdragon 7c+ Gen 3 (SC7280)"
					;;
			esac
			;;
		*QualcommOryon*)
			# Qualcomm Snapdragon X Elite (X1E80100): 8 x Oryon + 4 x Oryon or variants
			# https://browser.geekbench.com/v6/cpu/3327362.gb6 is in conflict with https://browser.geekbench.com/v6/cpu/3326512.gb6
			# wrt stepping: "ARM implementer 81 architecture 8 variant 1 part 1 revision 1" vs. "ARMv8 (64-bit) Family 8 Model 1 Revision 201"
			# The former is r1p1, the latter r2p1. But maybe it's different steppings since it's also said the clusters would consist of two
			# different core types: https://lore.kernel.org/linux-arm-msm/b165d2cd-e8da-4f6d-9ecf-14df2b803614@linaro.org/
			case ${CPUCores} in
				12)
					echo "Qualcomm Snapdragon X Elite (X1E80100)"
					;;
				10)
					echo "Qualcomm SC8370/SC8370XP"
					;;
				8)
					echo "Qualcomm SC8350/SC8350X"
					;;
			esac
			;;
		*A53r0p4*A53r0p4*A53r0p4*A53r0p4*A53r0p4*A53r0p4*A53r0p4*A53r0p4*A53r0p4*A53r0p4*A53r0p4*A53r0p4*A53r0p4*A53r0p4*A53r0p4*A53r0p4*A53r0p4*A53r0p4*A53r0p4*A53r0p4*A53r0p4*A53r0p4*A53r0p4*A53r0p4)
			# Socionext SC2A11: 24 x Cortex-A53 / r0p4 / fp asimd evtstrm aes pmull sha1 sha2 crc32 cpuid
			echo "Socionext SC2A11"
			;;
		*A53r0p4*A53r0p4*A53r0p4*A53r0p4*A73r0p2*A73r0p2*A73r0p2*A73r0p2)
			# Mediatek MT6771V: 4 x Cortex-A53 / r0p4 + 4 x Cortex-A73 / r0p2 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			# or Mediatek MT8183: 4 x Cortex-A53 / r0p4 + 4 x Cortex-A73 / r0p2 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt lpae evtstrm aes pmull sha1 sha2 crc32
			# or HiSilicon Kirin 710: 4 x Cortex-A53 / r0p4 + 4 x Cortex-A73 / r0p2 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			# or HiSilicon Kirin 970: 4 x Cortex-A53 / r0p4 + 4 x Cortex-A73 / r0p2 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			# or Allwinner R923: 4 x Cortex-A53 / r0p4 + 4 x Cortex-A73 / r0p2
			case "${DTCompatible,,}" in
				*710*)
					echo "HiSilicon Kirin 710"
					;;
				*970*)
					echo "HiSilicon Kirin 970"
					;;
				*hisilicon*)
					echo "HiSilicon Kirin 710 or 970"
					;;
				*mt6771*)
					echo "Mediatek MT6771V"
					;;
				*mt8183*)
					echo "Mediatek MT8183"
					;;
				*allwinner*|*sun*|*r923*)
					echo "Allwinner R923"
					;;
			esac
			;;
		00A53r0p400A53r0p400A53r0p400A53r0p4|??A53r0p4??????)
			# The boring quad Cortex-A53 done by every SoC vendor: 4 x Cortex-A53 / r0p4
			# Allwinner A100/A133/A53/A64/H5/H6/H313/H616/MR813/R818/T507/T509/B810, BCM2837/BCM2709, RK3318/RK3328/RK3528/RK3562, i.MX8 M, S905, S905X/S805X, S805Y, S905X/S905D/S905W/S905L/S905M2, S905X2/S905Y2/T962X2, Mediatek MT6762M/MT6765, RealTek RTD129x/RTD139x
			case "${DeviceName}" in
				"Raspberry Pi Compute Module 3 Plus"*)
					# 4 x Cortex-A53 / r0p4 / fp asimd evtstrm crc32
					echo "BCM2837B0"
					;;
				"Raspberry Pi 2"*|"Raspberry Pi Compute Module 3"*)
					# 4 x Cortex-A53 / r0p4 / fp asimd evtstrm crc32
					echo "BCM2837 (BCM2709)"
					;;
				"Raspberry Pi 3"*)
					# 4 x Cortex-A53 / r0p4 / fp asimd evtstrm crc32
					echo "BCM2837 (BCM2710)"
					;;
				"Raspberry Pi Zero 2"*)
					# 4 x Cortex-A53 / r0p4 / fp asimd evtstrm crc32
					echo "RP3A0-AU (BCM2710A1)"
					;;
				*)
					# No Raspberry, check for AES capabilities first
					grep 'Features' <<< "${ProcCPU}" | grep -q aes
					if [ $? -ne 0 ]; then
						# no ARMv8 Crypto Extensions licensed like RPi ARMv8 cores... then it's
						# S905: 4 x Cortex-A53 / r0p4 / fp asimd evtstrm crc32
						echo "Amlogic S905"
					else
						case "${DTCompatible,,}" in
							*allwinner*)
								# 4 x Cortex-A53 / r0p4 / fp asimd evtstrm aes pmull sha1 sha2 crc32
								case "${Allwinner_SID:7:8}" in
									92c00?ba)
										echo "Allwinner A64"
										;;
									92c000bb)
										echo "Allwinner H64"
										;;
									828000*)
										echo "Allwinner H5"
										;;
									82c000*)
										echo "Allwinner H6"
										;;
									32c05c*)
										echo "Allwinner H313"
										;;
									32c050*)
										echo "Allwinner H616"
										;;
									33802*)
										echo "Allwinner H618"
										;;
									33806*)
										echo "Allwinner H700"
										;;
									*)
										case "${DTCompatible,,}" in
											*h618*|*orangepi-zero3*|*orangepi-zero2w*)
												echo "Allwinner H618"
												;;
											*orangepi-zero2*)
												echo "Allwinner H616"
												;;
											*h313*)
												echo "Allwinner H313"
												;;
											*h616*)
												echo "Allwinner H616/H313/H618"
												;;
											*pine-h64*)
												echo "Allwinner H6"
												;;
											*h64*)
												echo "Allwinner H64"
												;;
											*h6*)
												echo "Allwinner H6"
												;;
											*h5*)
												echo "Allwinner H5"
												;;
											*a64*)
												echo "Allwinner A64"
												;;
											*t507*)
												echo "Allwinner T507"
												;;
											*t509*)
												echo "Allwinner T509"
												;;
											*b810*)
												echo "Allwinner B810"
												;;
											*a100*)
												echo "Allwinner A100"
												;;
											*a133*)
												echo "Allwinner A133"
												;;
											*a53*)
												echo "Allwinner A53"
												;;
											*mr813*)
												echo "Allwinner MR813"
												;;
											*r818*)
												echo "Allwinner R818"
												;;
											*h700*)
												echo "Allwinner H700"
												;;
										esac
										;;
								esac
								;;
							*amlogic*)
								case "${DTCompatible,,}" in
									*axg*)
										# AXG: A113X, A113D, 4 x Cortex-A53 / r0p4 / fp asimd evtstrm aes pmull sha1 sha2 crc32
										echo "Amlogic A113X/A113D"
										;;
									*g12a*)
										# G12A: 4 x Cortex-A53 / r0p4 / fp asimd evtstrm aes pmull sha1 sha2 crc32 cpuid
										echo "Amlogic S905X2/S905Y2/S905D2/S905L3A"
										;;
									*tl1*)
										# TL1: 4 x Cortex-A53 / r0p4 / fp asimd evtstrm aes pmull sha1 sha2 crc32 cpuid
										echo "Amlogic T962X2"
										;;
									*gxl*)
										# GXL: 4 x Cortex-A53 / r0p4 / fp asimd evtstrm aes pmull sha1 sha2 crc32
										echo "Amlogic S805X, S805Y, S905X/S905D/S905W/S905L/S905L2/S905M2"
										;;
									*)
										# GXL or G12A: 4 x Cortex-A53 / r0p4 / fp asimd evtstrm aes pmull sha1 sha2 crc32
										IdentifyAXGGXLG12A
										;;
								esac
								;;
							*rk3318*)
								# RK3318, 4 x Cortex-A53 / r0p4 / fp asimd evtstrm aes pmull sha1 sha2 crc32
								echo "Rockchip RK3318"
								;;
							*rk3328*)
								# RK3328, 4 x Cortex-A53 / r0p4 / fp asimd evtstrm aes pmull sha1 sha2 crc32
								echo "Rockchip RK3328"
								;;
							*rk3528*)
								# RK3528, 4 x Cortex-A53 / r0p4 / https://github.com/LubanCat/u-boot/blob/b36e944afbe275808a3d88575991417bae5e569f/arch/arm/dts/rk3528.dtsi#L76-L114
								echo "Rockchip RK3528"
								;;
							*rk3562*)
								# RK3562, 4 x Cortex-A53 / r0p4 / https://github.com/JeffyCN/rockchip_mirrors/blob/30c488cd350f5f7b53c7f46f803a64929f619230/configs/rockchip/chips/rk3562.config / https://cdn.cnx-software.com/wp-content/uploads/2023/03/Rockchip-RK3528-RK3562.jpg
								echo "Rockchip RK3562"
								;;
							*imx8*)
								# i.MX8M, 4 x Cortex-A53 / r0p4 / fp asimd evtstrm aes pmull sha1 sha2 crc32
								echo "NXP i.MX8M"
								;;
							*rtd1395*)
								# RealTek RTD1395, 4 x Cortex-A53 / r0p4 / fp asimd evtstrm aes pmull sha1 sha2 crc32
								echo "RealTek RTD1395"
								;;
							*realtek*)
								# RealTek RTD129x/RTD139x, 4 x Cortex-A53 / r0p4 / fp asimd evtstrm aes pmull sha1 sha2 crc32
								echo "RealTek RTD129x/RTD139x"
								;;
							*mt6762m*)
								# Mediatek MT6762M, 4 x Cortex-A53 / r0p4 / fp asimd aes pmull sha1 sha2 crc32
								echo "Mediatek MT6762M"
								;;
							*mt6765*)
								# Mediatek MT6765, 4 x Cortex-A53 / r0p4 / fp asimd aes pmull sha1 sha2 crc32
								echo "Mediatek MT6765"
								;;
							*mt6739wa*)
								# Mediatek MT6739WA, 4 x Cortex-A53 / r0p4 / fp asimd aes pmull sha1 sha2 crc32
								echo "Mediatek MT6739WA"
								;;
							*mt7986a*|*bpi-r3*)
								# Mediatek MT7986A, 4 x Cortex-A53 / r0p4 / fp asimd aes pmull sha1 sha2 crc32
								echo "Mediatek MT7986A"
								;;
							*mt8735*)
								# Mediatek MT8735, 4 x Cortex-A53 / r0p4 / fp asimd aes pmull sha1 sha2 crc32
								echo "Mediatek MT8735"
								;;
							*xlnx*|*zynqmp*|*zcu102*)
								# Xilinx XCZU9EG, 4 x Cortex-A53 / r0p4 / fp asimd aes pmull sha1 sha2 crc32
								echo "Xilinx XCZU9EG"
								;;
							*hi3798*)
								# HiSilicon Hi3798C-V200, 4 x Cortex-A53 / r0p4 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm (booting 32-bit)
								echo "HiSilicon Hi3798C-V200"
								;;
							*am623*)
								# Texas Instruments K3 AM623, 4 x Cortex-A53 / r0p4
								echo "Texas Instruments K3 AM6234"
								;;
							*am625*)
								# Texas Instruments K3 AM625, 4 x Cortex-A53 / r0p4
								echo "Texas Instruments K3 AM6254"
								;;
							*am62a7*)
								# Texas Instruments K3 AM62A, 4 x Cortex-A53 / r0p4
								echo "Texas Instruments K3 AM62A7"
								;;
							*am654*)
								# Texas Instruments K3 AM654, 4 x Cortex-A53 / r0p4
								echo "Texas Instruments K3 AM654"
								;;
							*ipq5332*)
								# Qualcomm IPQ5332, 4 x Cortex-A53 / r0p4
								echo "Qualcomm IPQ5332"
								;;
							*7570*)
								# Exynos 7570, 4 x Cortex-A53 / r0p4 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt lpae evtstrm aes pmull sha1 sha2 crc32
								echo "Exynos 7570"
								;;
						esac
					fi
					;;
			esac
			;;
		??BroadcomB53r0p0??BroadcomB53r0p0??BroadcomB53r0p0??BroadcomB53r0p0)
			# technically another quad core A53 but in this case the cores are Broadcom's Brahma-B53.
			# Broadcom used these cores in a bunch of SoCs, usually with ARMv8 Crypto Extensions but
			# sometimes they're not active or licensed (applies to early VideoCore SoCs between 2017
			# and 2018). Stepping was always r0p0: http://tinyurl.com/yt85tt78
			case "${DTCompatible,,}" in
				*brcm,bcm4908*)
					# Broadcom BCM4908: 4 x Brahma B53 / r0p0 / fp asimd evtstrm aes pmull sha1 sha2 crc32 cpuid
					echo "Broadcom BCM4908"
					;;
			esac
			;;
		00A53r0p400A53r0p4)
			# Allwinner R329, 2 x Cortex-A53 / r0p4 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			# or Armada 3720, 2 x Cortex-A53 / r0p4 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			# or MediaTek MT7622B, 2 x Cortex-A53 / r0p4 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			# or Texas Instruments K3 AM62x, 2 x Cortex-A53 / r0p4
			# or Texas Instruments K3 AM642, 2 x Cortex-A53 / r0p4
			# or Texas Instruments K3 AM652, 2 x Cortex-A53 / r0p4
			case "${DTCompatible,,}" in
				*armada37*)
					echo "Marvell Armada 3720"
					;;
				*am623*)
					echo "Texas Instruments K3 AM6232"
					;;
				*am625*)
					echo "Texas Instruments K3 AM6252"
					;;
				*am642*)
					echo "Texas Instruments K3 AM642"
					;;
				*am652*)
					echo "Texas Instruments K3 AM652"
					;;
				*r329*)
					echo "Allwinner R329"
					;;
				*mt7622b*)
					echo "MediaTek MT7622B"
					;;
			esac
			;;
		00A53r0p4)
			# Armada 3710, 1 x Cortex-A53 / r0p4 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			# or Texas Instruments K3 AM62x, 1 x Cortex-A53 / r0p4
			case "${DTCompatible,,}" in
				*armada37*)
					echo "Marvell Armada 3710"
					;;
				*am623*)
					echo "Texas Instruments K3 AM6231"
					;;
				*am625*)
					echo "Texas Instruments K3 AM6251"
					;;
			esac
			;;
		??A53r0p4??A53r0p4??A53r0p4??A53r0p4??A53r0p4??A53r0p4??A53r0p4??A53r0p4)
			# Amlogic S912, 4 x Cortex-A53 / r0p4 + 4 x Cortex-A53 / r0p4 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			# or NXP QorIQ LS1088: 8 x Cortex-A53 / r0p4 / https://bench.cr.yp.to/computers.html
			# or Samsung Exynos 7870: 8 x Cortex-A53 / r0p4 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt lpae evtstrm aes pmull sha1 sha2 crc32
			# or HiSilicon Kirin 650: 8 x Cortex-A53 / r0p4 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			# or Qualcomm SDM439 / Snapdragon 439: 8 x Cortex-A53 / r0p4 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt lpae evtstrm aes pmull sha1 sha2 crc32
			# or Qualcomm SDM450 / Snapdragon 450: 8 x Cortex-A53 / r0p4 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			# or Qualcomm MSM8937 / Snapdragon 430: 8 x Cortex-A53 / r0p4 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm aes pmull sha1 sha2 crc32 (booting 32-bit)
			# or Qualcomm MSM8952 / Snapdragon 617: 8 x Cortex-A53 / r0p4 / swp half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 evtstrm (booting 32-bit)
			# or Qualcomm MSM8953: 8 x Cortex-A53 / r0p4 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			# or Xiaomi Surge S1: 8 x Cortex-A53 / r0p4 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			# or Sophgo BM1684: 8 x Cortex-A53 / r0p4
			# or Qualcomm APQ8053: 8 x Cortex-A53 / r0p4 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			case "${DTCompatible,,}" in
				*amlogic*)
					echo "Amlogic S912"
					;;
				*7870*)
					echo "Samsung Exynos 7870"
					;;
				*hisilicon*|*hi6250*)
					echo "HiSilicon Kirin 650"
					;;
				*msm8937*|*430*)
					echo "Qualcomm Snapdragon 430"
					;;
				*sdm439*)
					echo "Qualcomm Snapdragon 439"
					;;
				*sdm450*)
					echo "Qualcomm Snapdragon 450"
					;;
				*msm8952*|*617*)
					echo "Qualcomm Snapdragon 617"
					;;
				*msm8953*)
					echo "Qualcomm MSM8953"
					;;
				*xiaomi*)
					echo "Xiaomi Surge S1"
					;;
				*bm1684x*)
					echo "Sophgo BM1684X"
					;;
				*bm1684*)
					echo "Sophgo BM1684"
					;;
				*apq8053*)
					echo "Qualcomm APQ8053"
					;;
				*ls1088*)
					echo "NXP QorIQ LS1088"
					;;
			esac
			;;
		00A53r0p400A53r0p412A73r0p212A73r0p212A73r0p212A73r0p2)
			# Amlogic S922X/A311D, 2 x Cortex-A53 / r0p4 + 4 x Cortex-A73 / r0p2 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			echo "Amlogic S922X/A311D"
			;;
		*A73r0p2*A73r0p2*A73r0p2*A73r0p2*A73r0p2*A73r0p2*A73r0p2*A73r0p2)
			# https://github.com/vmlemon/understand/wiki/Lenovo-ChromeBook-Duet suggests all 8 cores are
			# Cortex-A73 / r0p2 (cpu0 -> 'Booting Linux on physical CPU 0x0000000000 [0x410fd092]' and
			# all subsequently brought up cores 'Booted secondary processor 0x000000000x [0x410fd092]')
			# but this is in contrast to specs on the Internet
			# MediaTek Helio P60T, 8 x Cortex-A73 / r0p2 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			echo "MediaTek Helio P60T"
			;;
		00A73r0p200A73r0p200A73r0p200A73r0p214A53r0p414A53r0p414A53r0p414A53r0p4)
			# Amlogic A311D2: 4 x Cortex-A73 / r0p2 + 4 x Cortex-A53 / r0p4 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			echo "Amlogic A311D2"
			;;
		*A53r0p4*A53r0p4*A53r0p4*A53r0p4*A73r0p1*A73r0p1*A73r0p1*A73r0p1)
			# HiSilicon Kirin 960: 4 x Cortex-A53 / r0p4 + 4 x Cortex-A73 / r0p1 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			grep -q hisilicon <<<"${DTCompatible,,}" && echo "HiSilicon Kirin 960"
			;;
		*A55r1p0*A55r1p0*A55r1p0*A55r1p0*A55r1p0*A55r1p0*A55r1p0*A55r1p0)
			# HiSilicon Ascend 310, 8 x Cortex-A55 / r1p0 / fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp asimdrdm lrcpc dcpop asimddp
			echo "HiSilicon Ascend 310"
			;;
		0?A55r2p00?A55r2p00?A55r2p00?A55r2p00?A55r2p00?A55r2p00?A55r2p00?A55r2p0)
			# Allwinner A523/A527/MR527/R828/T523/T527, 8 x Cortex-A55 / r2p0 / at least 'aes pmull sha1 sha2' (https://browser.geekbench.com/v5/cpu/21564626)
			# or Amlogic P1, 8 x Cortex-A55 / r2p0
			case "${DTCompatible,,}" in
				*a523*)
					echo "Allwinner A523"
					;;
				*a527*)
					echo "Allwinner A527"
					;;
				*t523*)
					echo "Allwinner T523"
					;;
				*mr527*)
					echo "Allwinner MR527"
					;;
				*t527*)
					echo "Allwinner T527"
					;;
				*r828*)
					echo "Allwinner R828"
					;;
				*allwinner*|*sun55i*)
					echo "Allwinner A523/A527/MR527/R828/T523/T527"
					;;
			esac
			;;
		*A55r1p0*A55r1p0*A55r1p0*A55r1p0*A76r1p0*A76r1p0*A76r1p0*A76r1p0)
			# HiSilicon Kirin 980, 4 x Cortex-A55 / r1p0 + 4 x HiSilicon-A76 / r1p0 / fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp
			# The big cores are marketed/documented as Cortex-A76 by HiSilicon but instead of the usual ARM core ID 0x41/0xd0b they have 0x48/0xd40
			echo "HiSilicon Kirin 980"
			;;
		*A55r1p0*A55r1p0*A55r1p0*A55r1p0*A76r3p0*A76r3p0*A76r3p0*A76r3p0|*A55r1p0*A55r1p0*A55r1p0*A55r1p0*A76r3p1*A76r3p1*A76r3p1*A76r3p1)
			# HiSilicon Kirin 990, 4 x Cortex-A55 / r1p0 + 4 x HiSilicon-A76 / r3p0 / fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp asimdrdm lrcpc dcpop asimddp
			# The big cores are marketed/documented as Cortex-A76 by HiSilicon but instead of the usual ARM core ID 0x41/0xd0b they have 0x48/0xd40
			# There also seems to be a newer Kirin 990 version with HiSilicon-A76 / r3p1 cores
			# https://browser.geekbench.com/v5/cpu/compare/21007796?baseline=18843090
			echo "HiSilicon Kirin 990"
			;;
		*A55*TaiShanv120*)
			# HiSilicon Kirin 990A, 4 x Cortex-A55 + 4 x TaiShan v120 Lite
			echo "HiSilicon Kirin 990A"
			;;
		*A55r?p*A55r?p*A55r?p*A55r?p*A77r1p0*A77r1p0*A77r1p0*A77r1p0)
			# HiSilicon Kirin 9000, 4 x Cortex-A55 + 4 x Cortex-A77 / r1p0 / https://browser.geekbench.com/v6/cpu/2493425
			echo "HiSilicon Kirin 9000"
			;;
		*A510r1p1*A510r1p1*A510r1p1*A510r1p1*A710r2p2*A710r2p2*A710r2p2*TaiShanv120r2p2)
			# HiSilicon Kirin 9000s: 4 x Cortex-A510 / r1p1 + 3 x HiSilicon-A710 / r2p2 + 1 x TaiShan v120 / r2p2 / fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp cpuid asimdrdm jscvt fcma lrcpc dcpop sha3 sm3 sm4 asimddp sha512 sve asimdfhm dit ilrcpc flagm ssbs sb pacg dcpodp flagm2 frint svei8mm i8mm bti
			# https://youtu.be/SCRIFe0uaac?feature=shared&t=32
			# The 'A710' like cores use HiSilicon's own 48/d42 ID and all the big cores are SMT capable
			echo "HiSilicon Kirin 9000s"
			;;
		*A55r1p0*A55r1p0*A55r1p0*A55r1p0*A55r1p0*A55r1p0*A76r3p0*A76r3p0)
			# HiSilicon Kirin 810, 6 x Cortex-A55 / r1p0 + 2 x HiSilicon-A76 / r3p0 / fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp asimdrdm lrcpc dcpop asimddp
			# The big cores are marketed/documented as Cortex-A76 by HiSilicon but instead of the usual ARM core ID 0x41/0xd0b they have 0x48/0xd40
			echo "HiSilicon Kirin 810"
			;;
		*A55r2p0*A55r2p0*A55r2p0*A55r2p0*A55r2p0*A55r2p0*A76r4p?*A76r4p?)
			# Allwinner A733/A736/T736, 6 x Cortex-A55 / r2p0 + 2 x Cortex-A76 / r4p?
			case "${DTCompatible,,}" in
				*sun60iw1*|*a736*|*t736*)
					echo "Allwinner A736/T736"
					;;
				*sun60iw2*|*a733*)
					echo "Allwinner A733"
					;;
			esac
			;;
		*A55r2p0*A55r2p0*A55r2p0*A55r2p0*A55r2p0*A55r2p0*A78*A78)
			# Allwinner A737/T737, 6 x Cortex-A55 / r2p0 + 2 x Cortex-A78
			grep -E -q 'allwinner|a737|t737|' <<<"${DTCompatible,,}" && echo "Allwinner A737/T737"
			;;
		0A9r4p10A9r4p1|0?A9r4p10?A9r4p1)
			# Armada 375/38x, 2 x Cortex-A9 / r4p1 / swp half thumb fastmult vfp edsp neon vfpv3 tls
			# or MStar Infinity2: 2 Cortex-A9 / r4p1 / half thumb fastmult vfp edsp thumbee neon vfpv3 tls vfpd32
			# or Triductor TR6560: 2 x Cortex-A9 / r4p1
			case "${DTCompatible,,}" in
				*armada*)
					echo "Marvell Armada 375/38x"
					;;
				*mstar*|*infinity*)
					echo "MStar Infinity2"
					;;
				*)
					echo "Triductor TR6560"
					;;
			esac
			;;
		*A9r4p1)
			# HiSilicon Hi3520D-V300: 1 x Cortex-A9 / r4p1 / swp half fastmult edsp
			echo "HiSilicon Hi3520D-V300"
			;;
		0?A72r0p10?A72r0p10?A72r0p10?A72r0p1)
			# Armada 8040, 4 x Cortex-A72 / r0p1 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			echo "Marvell Armada 8040"
			;;
		0?A72r0p10?A72r0p1)
			# Armada 8020, 2 x Cortex-A72 / r0p1 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			echo "Marvell Armada 8020"
			;;
		??A53r0p4??A53r0p4)
			# Armada 3700, 2 x Cortex-A53 / r0p4 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			echo "Marvell Armada 37x0"
			;;
		10ARM1176r0p7)
			# BCM2835, 1 x ARM1176 / r0p7 / half thumb fastmult vfp edsp java tls
			echo "BCM2835"
			;;
		??A73r?p???A73r?p???A73r?p???A73r?p?)
			# Qualcomm IPQ9574, 4 x Cortex-A73
			# or Synaptics VS680 (also called SenaryTech SN3680), 4 x Cortex-A73
			# or MediaTek MT7988A (Filogic 880), 4 x Cortex-A73
			case "${DTCompatible,,}" in
				*qualcomm*|*9574*)
					echo "Qualcomm IPQ9574"
					;;
				*synaptics*|*syna,*|*vs680*|*senarytech*|*sn3680*)
					echo "Synaptics VS680"
					;;
				*880*|*mt7988*)
					echo "MediaTek MT7988A (Filogic 880)"
					;;
			esac
			;;
		00A72r0p300A72r0p300A72r0p300A72r0p3)
			# BCM2711, 4 x Cortex-A72 / r0p3 / fp asimd evtstrm crc32 (running 32-bit: half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm crc32)
			# or Marvell Armada3900-A1, 4 x Cortex-A72 / r0p3 / https://community.cisco.com/t5/wireless/catalyst-9130ax-ap-booting-into-wnc-linux-instead-of-ios-xe/td-p/4460181
			case "${DTCompatible,,}" in
				*raspberrypi*|*bcm283*|*bcm2711*)
					echo "BCM2711${BCM2711}"
					;;
				*marvell*|*3900*)
					echo "Marvell Armada3900-A1"
					;;
			esac
			;;
		*A76r4p1*A76r4p1*A76r4p1*A76r4p1)
			# BCM2712, 4 x Cortex-A76 / r4p1 / fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp cpuid asimdrdm lrcpc dcpop asimddp
			echo "BCM2712"
			;;
		??A72r0p3??A72r0p3)
			# Xilinx Versal, 2 x Cortex-A72 / r0p3 / fp asimd aes pmull sha1 sha2 crc32 cpuid
			echo "Xilinx Versal"
			;;
		10A7r0p310A7r0p310A7r0p310A7r0p30?A15r2p30?A15r2p30?A15r2p30?A15r2p3)
			# Exynos 5422, 4 x Cortex-A7 / r0p3 + 4 x Cortex-A15 / r2p3 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae (with 5.x also evtstrm)
			echo "Exynos 5422"
			;;
		10A7r0p410A7r0p410A7r0p410A7r0p404A15r3p304A15r3p304A15r3p304A15r3p3)
			# Exynos 5430, 4 x Cortex-A7 / r0p4 + 4 x Cortex-A15 / r3p3 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae (with 5.x also evtstrm)
			echo "Exynos 5430"
			;;
		*A7r0p4*A7r0p4*A7r0p4*A7r0p4*A7r0p4*A7r0p4*A7r0p4*A7r0p4|*A7r0p4*A7r0p4)
			# Mediatek MT6592: 8 x Cortex-A7 / r0p4 / swp half thumb fastmult vfp edsp thumbee neon vfpv3 tls vfpv4 idiva idivt
			# (with vendor kernel often only 2 cores show up in /proc/cpuinfo)
			echo "Mediatek MT6592"
			;;
		00A35r0p100A35r0p100A35r0p100A35r0p1)
			# Mediatek MT8167B: 4 x Cortex-A35 / r0p1 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			echo "Mediatek MT8167B"
			;;
		*A35r0p1*A35r0p1*A35r0p1*A35r0p1*A53r0p4*A53r0p4*A53r0p4*A53r0p4*A73r0p2*A73r0p2|*A35r0p1*A53r0p4*A73r0p2)
			# Mediatek MT6799: 4 x Cortex-A35 / r0p1 + 4 x Cortex-A53 / r0p4 + 2 x Cortex-A73 / r0p2 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			echo "Mediatek MT6799"
			;;
		00A35r0p200A35r0p2)
			# RK1808, 2 x Cortex-A35 / r0p2 / https://patchwork.kernel.org/project/linux-arm-kernel/patch/20210516230551.12469-6-afaerber@suse.de/#24199353
			echo "Rockchip RK1808"
			;;
		00A35r0p200A35r0p200A35r0p200A35r0p2)
			# RK3308/RK3326/PX30/PX30S, 4 x Cortex-A35 / r0p2 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			# or i.MX8QXP, 4 x Cortex-A35 / r0p2 / https://gist.github.com/stravs/f82c8a0af276b2d1e6b57235d048f027
			case "${DTCompatible,,}" in
				*rk3308*)
					echo "Rockchip RK3308"
					;;
				*rk3326*)
					echo "Rockchip RK3326"
					;;
				*px30s*)
					echo "Rockchip PX30S"
					;;
				*px30*)
					echo "Rockchip PX30/PX30S"
					;;
				*rockchip*)
					echo "Rockchip RK3308/RK3326/PX30/PX30S"
					;;
				*)
					echo "NXP i.MX8QXP"
					;;
			esac
			;;
		00A35r1p000A35r1p000A35r1p000A35r1p0)
			# S805X2/S905Y4/S905W2, 4 x Cortex-A35 / r1p0 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			echo "Amlogic S805X2/S905Y4/S905W2"
			;;
		*A35r*A35r*A35r*A35r???)
			# RK quad-core A35 with yet unknown details (stepping/flags)
			case "${DTCompatible,,}" in
				*rk3308b*)
					echo "Rockchip RK3308B"
					;;
				*rk3308h*)
					echo "Rockchip RK3308H"
					;;
				*rk3358j*)
					echo "Rockchip RK3358J"
					;;
			esac
			;;
		*A53r0p4*A53r0p4*A53r0p4*A53r0p4*A72r1p0*A72r1p0*A72r1p0*A72r1p0)
			# RK3576, 4 x Cortex-A53 / r0p4 + 4 x Cortex-A72 / r1p0 https://archive.ph/7lkym
			# (most recent steppings are pure assumption since announced in 2023)
			# Why A53/A72 still in 2024? Since last ARM cores able to boot a 32-bit
			# ARMv8l kernel (32-bit userlands consume way less memory compared to 64-bit)
			# The RK3576J variant can run isolated operating systems on each CPU cluster:
			# https://twitter.com/BG5USN/status/1767000716709609521
			echo "Rockchip RK3576"
			;;
		0?A55r2p00?A55r2p00?A55r2p00?A55r2p0??A76r4p0??A76r4p0??A76r4p0??A76r4p0)
			# RK3588, 4 x Cortex-A55 / r2p0 + 2 x Cortex-A76 / r4p0 / + 2 x Cortex-A76 / r4p0 / fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp asimdrdm lrcpc dcpop asimddp
			# or RK3582/RK3583 which are chips not fully passing QA where one of the two A76 clusters is hidden by default even if fully functional and might have been brought back by a DT overlay
			# or Unisoc UMS9620, 4 x Cortex-A55 / r2p0 + 3 x Cortex-A76 / r4p0 / + 1 x Cortex-A76 / r4p0 / fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp asimdrdm lrcpc dcpop asimddp
			case "${DTCompatible,,}" in
				*ums9620*)
					echo "Unisoc UMS9620"
					;;
				*)
					if [ "X${RK_NVMEM}" != "X" ]; then
						if [ "${RK_NVMEM:16:2}${RK_NVMEM:19:2}" = "3588" ]; then
							case "${RK_NVMEM:28:2}" in
								21)
									echo "Rockchip RK3588 / ${RK_NVMEM:16:42}"
									;;
								33)
									echo "Rockchip RK3588S / ${RK_NVMEM:16:42}"
									;;
								53)
									echo "Rockchip RK3588S2 / ${RK_NVMEM:16:42}"
									;;
								*)
									echo "Rockchip RK3588/RK3588S/RK3588S2 / ${RK_NVMEM:16:42}"
									;;
							esac
						else
							echo "Rockchip RK${RK_NVMEM:16:2}${RK_NVMEM:19:2} / ${RK_NVMEM:16:42}"
						fi
					elif [ -f /sys/devices/system/cpu/cpufreq/policy7/cpuinfo_max_freq ]; then
						# According to this site RK3588M is limited to 2.1 GHz
						# https://techacute.com/rockchip-launched-flagship-smart-vehicle-solution-rk3588m-with-360-panoramic-view-function/
						read MaxRK3588Freq </sys/devices/system/cpu/cpufreq/policy7/cpuinfo_max_freq
						[ ${MaxRK3588Freq:-0} -eq 2100000 ] && echo "Rockchip RK3588M / ${RK_NVMEM:16:42}" || echo "Rockchip RK3588/RK3588S/RK3588S2 / ${RK_NVMEM:16:42}"
					else
						echo "Rockchip RK3588/RK3588S/RK3588S2 / ${RK_NVMEM:16:42}"
					fi
					;;
			esac
			;;
		0?A55r2p00?A55r2p00?A55r2p00?A55r2p0*A76r4p0??A76r4p0)
			# RK3582 is a RK3588S2 binning variant with slower NPU and potentially lacking GPU and/or one big cluster
			# https://dl.radxa.com/rock5/5c/docs/hw/datasheet/Rockchip%20RK3582%20Datasheet%20V1.1-20230221.pdf
			grep -q "rk358" <<<"${DTCompatible,,}" && echo "Rockchip RK3582 / ${RK_NVMEM:16:42}"
			;;
		00A35r1p000A35r1p0)
			# Amlogic C302X or C305X, 2 x Cortex-A35 / r1p0 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			# or Nuvoton MA35D1, 2 x Cortex-A35 / r1p0
			case "${DTCompatible,,}" in
				*c302*)
					echo "Amlogic C302X"
					;;
				*c305*)
					echo "Amlogic C305X"
					;;
				*amlogic*)
					echo "Amlogic C3 SoC"
					;;
				*ma35h0*)
					echo "Nuvoton MA35H0"
					;;
				*ma35d0*)
					echo "Nuvoton MA35D0"
					;;
				*ma35d1*)
					echo "Nuvoton MA35D1"
					;;
				*nuvoton*)
					echo "Nuvoton MA35xx"
					;;
			esac
			;;
		00A55r1p000A55r1p000A55r1p000A55r1p0)
			# Amlogic S905X3, 4 x Cortex-A55 / r1p0 / fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp (with 5.4+ also 'asimddp asimdrdm cpuid dcpop lrcpc')
			echo "Amlogic S905X3"
			;;
		00A55r2p000A55r2p000A55r2p000A55r2p0)
			# Allwinner A513, Amlogic S905X4/S905C2, RealTek RTD1619B or Rockchip RK3566/RK3568
			# 4 x Cortex-A55 / r2p0 / fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp asimdrdm lrcpc dcpop asimddp
			case "${DTCompatible,,}" in
				*amlogic*)
					echo "Amlogic S905X4/S905C2"
					;;
				*rk3566*)
					echo "Rockchip RK3566"
					;;
				*rk3568*)
					echo "Rockchip RK3568"
					;;
				*rockchip*)
					echo "Rockchip RK3566/RK3568"
					;;
				*a513*|*allwinner*)
					echo "Allwinner A513"
					;;
				*rtd1619b*|*realtek*|*synology*)
					echo "RealTek RTD1619B"
					;;
			esac
			;;
		0?A55r?p?0?A55r?p?)
			# Renesas RZG2L/RZG2LC, 2 x Cortex-A55 / r2p0 / L1d 32K, L1i 32K, L2 0K, L3 256K (shared)
			# or NXP i.MX 93, 2 x Cortex-A55 / r2p0 / L1d 32K, L1i 32K, L2 64K, L3 256K (shared)
			# or Amlogic C308X, 2 x Cortex-A55
			# or Exynos 5515, 2 x Cortex-A55 / r2p0
			case "${DTCompatible,,}" in
				*nxp*)
					echo "NXP i.MX 93"
					;;
				*rzg2lc*)
					echo "Renesas RZG2LC"
					;;
				*rzg2l*)
					echo "Renesas RZG2L"
					;;
				*renesas*|*rzg2*)
					echo "Renesas RZG2L/RZG2LC"
					;;
				*c308l*)
					echo "Amlogic C308L"
					;;
				*c308*)
					echo "Amlogic C308X"
					;;
				*5515*)
					echo "Exynos 5515"
					;;
			esac
			;;
		*A55r2p0)
			# Renesas RZG2L/RZG2LC/RZG2UL, 1 x Cortex-A55 / r2p0 / L1d 32K, L1i 32K, L2 0K, L3 256K (shared)
			# or NXP i.MX 93, 1 x Cortex-A55 / r2p0 / L1d 32K, L1i 32K, L2 64K, L3 256K (shared)
			case "${DTCompatible,,}" in
				*nxp*)
					echo "NXP i.MX 93"
					;;
				*rzg2lc*)
					echo "Renesas RZG2LC"
					;;
				*rzg2l*)
					echo "Renesas RZG2L"
					;;
				*rzg2ul*)
					echo "Renesas RZG2UL"
					;;
				*renesas*|*rzg2*)
					echo "Renesas RZG2L/RZG2LC/RZG2UL"
					;;
			esac
			;;
		*A53r0p4*A53r0p4*A53r0p4*A53r0p4*A72r0p2*A72r0p2)
			# RK3399, 4 x Cortex-A53 / r0p4 + 2 x Cortex-A72 / r0p2 / fp asimd evtstrm aes pmull sha1 sha2 crc32 (32-bit 4.4 BSP kernel: half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt lpae evtstrm aes pmull sha1 sha2 crc32)
			# or maybe NXP i.MX8QM, 4 x Cortex-A53 / r0p4 + 2 x Cortex-A72 / r0p2
			grep -q rockchip <<<"${DTCompatible,,}" && echo "Rockchip RK3399" || echo "NXP i.MX8QM"
			;;
		*A53r0p2*A53r0p2*A53r0p2*A53r0p2*A72r0p0*A72r0p0)
			# Mediatek MT8176: 4 x Cortex-A53 / r0p2 + 2 x Cortex-A72 / r0p0 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			echo "Mediatek MT8176"
			;;
		*A53r0p2*A53r0p2*A72r0p0*A72r0p0)
			# Mediatek MT8173: 2 x Cortex-A53 / r0p2 + 2 x Cortex-A72 / r0p0 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			echo "Mediatek MT8173"
			;;
		*A53r0p2*A53r0p2*A53r0p2*A53r0p2*A53r0p2*A53r0p2*A53r0p2*A53r0p2)
			# Mediatek MT6752: 8 x Cortex-A53 / r0p2 / fp asimd aes pmull sha1 sha2 crc32
			# Mediatek MT6755: 8 x Cortex-A53 / r0p2 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			echo "Mediatek MT6752/MT6755"
			;;
		*A53r0p2*A53r0p2*A53r0p2*A53r0p2|*A53r0p2)
			# Mediatek MT6738: 4 x Cortex-A53 / r0p2 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			# or Marvell PXA1908: 4 x Cortex-A53 / r0p2 / fp asimd evtstrm aes pmull sha1 sha2 crc32 half thumb fastmult edsp tls vfp vfpv3 vfpv4 neon idiva idivt
			# (at least with vendor's 3.14 kernel CPU cores are sent offline when idle so detection of all cores might fail)
			grep -q mt6738 <<<"${DTCompatible,,}" && echo "Mediatek MT6738" || echo "Marvell PXA1908"
			;;
		*A53r0p4*A53r0p4*A53r0p4*A53r0p4*A53r0p4*A53r0p4*A53r0p4*A53r0p4*A72r0p1*A72r0p1)
			# Mediatek MT6797/MT6797T: 4 x Cortex-A53 / r0p4 + 4 x Cortex-A53 / r0p4 + 2 x Cortex-A72 / r0p1 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			echo "Mediatek MT6797/MT6797T"
			;;
		*A57r1p1*A57r1p1*A53r0p3*A53r0p3*A53r0p3*A53r0p3)
			# ARM Juno: 2 x Cortex-A57 / r1p1 + 4 x Cortex-A53 / r0p3 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			echo "ARM Juno r1"
			;;
		*A53r0p3*A53r0p3*A53r0p3*A53r0p3*A72r0p0*A72r0p0|*A72r0p0*A72r0p0*A53r0p3*A53r0p3*A53r0p3*A53r0p3)
			# ARM Juno r2: 4 x Cortex-A53 / r0p3 + 2 x Cortex-A72 / r0p0 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			echo "ARM Juno r2"
			;;
		00A72r1p000A72r1p0)
			# TI J721E (TDA4VM/DRA829V): 2 x Cortex-A72 / r1p0 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			# or BroadCom Klondike: 2 x Cortex-A72 / r1p0 / with at least 'aes pmull sha1 sha2' https://browser.geekbench.com/v4/cpu/search?page=1&q=broadcom+klondike&utf8=✓
			case "${DTCompatible,,}" in
				*721*|*ti*)
					echo "TI J721E"
					;;
				*bcm*|*broadcom*)
					echo "BroadCom Klondike"
					;;
			esac
			;;
		*A15r2p2*A15r2p2)
			# TI Sitara AM572x: 2 x Cortex-A15 / r2p2 / half thumb fastmult vfp edsp thumbee neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm
			echo "TI Sitara AM572x"
			;;
		150A7r0p5150A7r0p5150A7r0p5150A7r0p5)
			case "${DeviceName}" in
				"Raspberry Pi 2"*)
					# BCM2836, 4 x Cortex-A7 / r0p5 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm
					echo "BCM2836 (BCM2709)"
					;;
				*)
					# RK3229/RK3228A, 4 x Cortex-A7 / r0p5 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm
					# or maybe Rockchip RV1126 | 4 x Cortex-A7 / r0p5
					grep -q "rk322" <<<"${DTCompatible,,}" && echo "Rockchip RK3229/RK3228A" || echo "Rockchip RV1126"
					;;
			esac
			;;
		*A7r0p5*A7r0p5*A7r0p5)
			# RK3506, 3 x Cortex-A7 / r0p5 (stepping is assumption)
			grep -q rk3506 <<<"${DTCompatible,,}" && echo "Rockchip RK3506"
			;;
		*A7r0p5*A7r0p5)
			# SigmaStar SSD201/SSD202D | 2 x Cortex-A7 / r0p5 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm
			# or Rockchip RV1109 | 2 x Cortex-A7 / r0p5
			# or Renesas RZ/N1 | 2 x Cortex-A7 / r0p5
			# or Allwinner R328: 2 x Cortex-A7 / r0p5 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm (https://whycan.com/t_7497.html -> ARMv7 Processor [410fc075] revision 5 (ARMv7), cr=10c5387d)
			# or Allwinner F133/H133/R528/T113: 2 x Cortex-A7 / r0p5 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm (https://forums.100ask.net/t/topic/2867 -> ARMv7 Processor [410fc075] revision 5 (ARMv7), cr=10c5387d)
			# or STMicroelectronics STM32MP153C: 2 x Cortex-A7 / r0p5 / half thumb fastmult vfp edsp thumbee neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm
			case "${DTCompatible,,}" in
				*rockchip*)
					echo "Rockchip RV1109"
					;;
				*renesas*)
					echo "Renesas RZ/N1D"
					;;
				*sstar*)
					echo "SigmaStar SSD201/SSD202D"
					;;
				*sun8iw18*|*r328*)
					echo "Allwinner R328"
					;;
				*sun8iw20*|*f133*|*h133*|*r528*|*t113*)
					echo "Allwinner F133/H133/R528/T113"
					;;
				*stm32mp153*)
					echo "STMicroelectronics STM32MP153C"
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
		*A7r0p5*A7r0p5*A7r0p5*A7r0p5*A15r3p3*A15r3p3*A15r3p3*A15r3p3)
			# HiSilicon Kirin 920/925/928: 4 x Cortex-A7 / r0p5 + 4 x Cortex-A15 / r3p3 / swp half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt
			echo "HiSilicon Kirin 920/925/928"
			;;
		*A15r3p3*A15r3p3*A15r3p3*A15r3p3)
			# Nvidia Tegra K1 (124): 4 x Cortex-A15 / r3p3 / swp half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt
			echo "Nvidia Tegra K1 (124)"
			;;
		00A57r1p100A57r1p100A57r1p100A57r1p1)
			# Tegra X1/TX1, 4 x Cortex-A57 / r1p1 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			echo "Nvidia Tegra X1/TX1"
			;;
		*A57r1p3*A57r1p3*A57r1p3*A57r1p3*A57r1p3*A57r1p3*A57r1p3*A57r1p3)
			# Baikal-M, 8 x Cortex-A57 / r1p3 / fp asimd evtstrm crc32 cpuid
			echo "Baikal-M"
			;;
		*A57r1p3*)
			# Jetson TX2, 1-4 x Cortex-A57 / r1p3 + 0-2 x Denver 2 / r0p0 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			# or Renesas R-Car family: 2-4 x Cortex-A57 / r1p3 + 0-4 Cortex-A53 / r0p4 / https://jira.automotivelinux.org/browse/SPEC-2614?focusedCommentId=20987&page=com.atlassian.jira.plugin.system.issuetabpanels%3Acomment-tabpanel
			case "${DTCompatible,,}" in
				*r8a7795*)
					echo "Renesas R8A7795/R-Car H3"
					;;
				*r8a77965*)
					echo "Renesas R8A77965/R-Car M3N"
					;;
				*r8a7796*)
					echo "Renesas R8A7796/R-Car M3"
					;;
				*nvidia*)
					echo "Nvidia Jetson TX2"
					;;
			esac
			;;
		*NVidiar0p0*NVidiar0p0)
			# Nvidia Tegra K1 (Tegra132): 2 x Denver / r0p0 / fp asimd aes pmull sha1 sha2 crc32
			echo "Nvidia Tegra K1 (Tegra132)"
			;;
		*NVidiar0p0*)
			# Nvidia Tegra Xavier | 4-8 x NVidia Carmel / r0p0 / fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp
			echo "Nvidia Tegra Xavier"
			;;
		*A78AEr0p1*A78AEr0p1*A78AEr0p1*A78AEr0p1*A78AEr0p1*)
			# Nvidia Jetson Orin NX / AGX Orin: 6-12 Cortex-A78AE / r0p1 / https://forums.developer.nvidia.com/t/orin/212053/8 https://developer.nvidia.com/embedded/jetson-orin
			case ${CPUCores} in
				6)
					echo "Nvidia Jetson Orin NX"
					;;
				8)
					echo "Nvidia Jetson Orin NX or AGX Orin"
					;;
				*)
					echo "Nvidia Jetson AGX Orin"
					;;
			esac
			;;
		50A17r0p150A17r0p150A17r0p150A17r0p1)
			# RK3288: 4 x Cortex-A17 / r0p1 / half thumb fastmult vfp edsp thumbee neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm
			echo "Rockchip RK3288"
			;;
		*A7r0p5*A7r0p5*A7r0p5*A7r0p5*A17r0p0*A17r0p0*A17r0p0*A17r0p0)
			# MediaTek MT6595: 4 x Cortex-A7 / r0p5 + 4 x Cortex-A17 / r0p0 / swp half thumb fastmult vfp edsp thumbee neon vfpv3 tls vfpv4 idiva idivt
			echo "MediaTek MT6595"
			;;
		*A17r0p0*A17r0p0)
			# MediaTek MT5890: 2 x Cortex-A17 / r0p0 / swp half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt
			# though has been advertised as quad core (2 x A7 + 2 x A17): https://www.avforums.com/attachments/safari-27-jul-2018-at-09-23-pdf.1043417/
			echo "MediaTek MT5890"
			;;
		*A15r2p1*A15r2p1*A7r0p1*A7r0p1*A7r0p1)
			# ARM Versatile V2P-CA15-CA7: 2 x Cortex-A15 / r2p1 + 3 x Cortex-A7 / r0p1 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm
			echo "ARM Versatile V2P-CA15-CA7"
			;;
		?0A7r0p2?0A7r0p2?0A7r0p2?0A7r0p2)
			# MT6589: 4 x Cortex-A7 / r0p2 / https://gist.github.com/MaTBeu4uk/3a1bea6bf8c658829622f3ecbcf4b7eb which is in conflict to other sources who claim Cortex-A7 / r0p3
			echo "Mediatek MT6589"
			;;
		*A7r0p3*A7r0p3*A15r3p2*A15r3p2)
			# MT8135: 2 x Cortex-A7 / r0p3 + 2 x Cortex-A15 / r3p2 / swp half thumb fastmult vfp edsp thumbee neon vfpv3 tls vfpv4 idiva idivt
				echo "Mediatek MT8135"
				;;
		*A7r0p3*A7r0p3*A7r0p3*A7r0p3)
			# Allwinner A31/A31s: 4 x Cortex-A7 / r0p3 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm
			# or MT7623: 4 x Cortex-A7 / r0p3 / half thumb fastmult vfp edsp thumbee neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm
			# or MT6580: 4 x Cortex-A7 / r0p3 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae
			# or MT6582: 4 x Cortex-A7 / r0p3 / swp half thumb fastmult vfp edsp thumbee neon vfpv3 tls vfpv4 idiva idivt
			# or MT6589: 4 x Cortex-A7 / r0p3 / swp half thumb fastmult vfp edsp thumbee neon vfpv3 tls vfpv4 idiva idivt
			# or MT8127: 4 x Cortex-A7 / r0p3 / swp half thumb fastmult vfp edsp thumbee neon vfpv3 tls vfpv4 idiva idivt
			# or Qualcomm MSM8226/MSM8926 (Snapdragon 400): 4 x Cortex-A7 / r0p3 / swp half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt
			case "${DTCompatible,,}" in
				*mt6580*)
					echo "Mediatek MT6580"
					;;
				*mt6582*)
					echo "Mediatek MT6582"
					;;
				*mt6589*)
					echo "Mediatek MT6589"
					;;
				*mt8127*)
					echo "Mediatek MT8127"
					;;
				*mt7623*)
					echo "Mediatek MT7623"
					;;
				*msm8226*|*msm8926*|*400*)
					echo "Qualcomm MSM8226/MSM8926 (Snapdragon 400)"
					;;
				*a31*|*sun6i*)
					echo "Allwinner A31/A31s"
					;;
			esac
			;;
		*A7r0p3*A7r0p3)
			# Mediatek MT6572: 2 x Cortex-A7 / r0p3 / swp half thumb fastmult vfp edsp thumbee neon vfpv3 tls vfpv4 idiva idivt
			# or Qualcomm MSM8610 (Snapdragon 200): 2 x Cortex-A7 / r0p3 / swp half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt
			case "${DTCompatible,,}" in
				*mt6572*)
					echo "Mediatek MT6572"
					;;
				*)
					echo "Qualcomm MSM8610 (Snapdragon 200)"
					;;
			esac
			;;
		*A53r0p1*A53r0p1*A53r0p1*A53r0p1*A53r0p1*A53r0p1*A53r0p1*A53r0p1)
			# Qualcomm MSM8939: 8 x Cortex-A53 / r0p1 / swp half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 evtstrm (booting 32-bit obviously)
			echo "Qualcomm MSM8939"
			;;
		??A53r0p3??A53r0p3??A53r0p3??A53r0p3??A53r0p3??A53r0p3??A53r0p3??A53r0p3|??A53r0p3??A53r0p3??A53r0p3??A53r0p3)
			# Nexell S5P6818, 8 x Cortex-A53 / r0p3 / fp asimd aes pmull sha1 sha2 crc32
			# or HiSilicon Kirin 620/930, 8 x Cortex-A53 / r0p3 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			# or Samsung Exynos 7580, 4 or 8 x Cortex-A53 / r0p3 / fp asimd aes pmull sha1 sha2 crc32 wp half thumb fastmult vfp edsp neon vfpv3 tlsi vfpv4 idiva idivt
			case "${DTCompatible,,}" in
				*hi6220*|*hi6210*)
					echo "HiSilicon Kirin 620"
					;;
				*hisilicon*)
					echo "HiSilicon Kirin 620/930"
					;;
				*nexell*)
					echo "Nexell S5P6818"
					;;
				*7580*)
					echo "Samsung Exynos 7580"
					;;
			esac
			;;
		*A53r0p3*A53r0p3*A53r0p3*A53r0p3)
			# Mediatek MT6735: 4 x Cortex-A53 / r0p3 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm sha2 (booting 32-bit)
			# or Mediatek MT8163: 4 x Cortex-A53 / r0p3 / half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt lpae evtstrm aes pmull sha1 sha2 crc32
			# or HiSilicon Hi3751: 4 x Cortex-A53 / r0p3 / swp half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt (booting 32-bit kernel)
			case "${DTCompatible,,}" in
				*mt6735*)
					echo "Mediatek MT6735"
					;;
				*mt8163*)
					echo "Mediatek MT8163"
					;;
				*hi3751*)
					echo "HiSilicon Hi3751"
					;;
			esac
			;;
		*A53r0p3*A53r0p3)
			# HiSilicon Hi3751: 2 x Cortex-A53 / r0p3 / swp half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt (booting 32-bit kernel)
			echo "HiSilicon Hi3751"
			;;
		00Cavium88XXr1p1*)
			# ThunderX CN8890, 48 x ThunderX 88XX / r1p1 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			echo "$(( ${CPUCores} / 48 )) x ThunderX CN8890"
			;;
		??A9r2p10??A9r2p10??A9r2p10??A9r2p10)
			# NXP i.MX6 Quad | 4 x Cortex-A9 / r2p10 / swp half thumb fastmult vfp edsp thumbee neon vfpv3
			echo "NXP i.MX6 Quad"
			;;
		*A9r2p10*A9r2p10)
			# NXP i.MX6 Dual | 2 x Cortex-A9 / r2p10 / swp half thumb fastmult vfp edsp thumbee neon vfpv3
			# or TI OMAP4470: 2 x Cortex-A9 / r2p10 / swp half thumb fastmult vfp edsp thumbee neon vfpv3
			grep -q "imx6" <<<"${DTCompatible,,}" && echo "NXP i.MX6 Dual" || echo "TI OMAP4470"
			;;
		??A9r2p1??A9r2p1)
			# FreeScale/NXP QorIQ LS1024A | 2 x Cortex-A9 / r2p1 / swp half thumb fastmult vfp edsp thumbee neon vfpv3 tls
			# or Samsung Exynos 4210 | 2 x Cortex-A9 / r2p1 / swp half thumb fastmult vfp edsp neon vfpv3 tls
			echo "NXP QorIQ LS1024A or Samsung Exynos 4210"
			;;
		??A9r1p2??A9r1p2)
			# TI OMAP 4460 | 2 x Cortex-A9 / r1p2 / https://e2e.ti.com/support/processors-group/processors/f/processors-forum/243190/booting-problem-of-omap4460-pandaboard
			echo "TI OMAP 4460"
			;;
		??A9r1p3??A9r1p3)
			# TI OMAP 4430 | 2 x Cortex-A9 / r1p3 / swp half thumb fastmult vfp edsp thumbee neon vfpv3
			echo "TI OMAP 4430"
			;;
		??A15r0p4??A15r0p4)
			# Samsung Exynos 5 Dual 5250: 2 x Cortex-A15 / r0p4 / https://bench.cr.yp.to/computers.html
			echo "Samsung Exynos 5 Dual 5250"
			;;
		??A15r2p4??A15r2p4)
			# AnnapurnaLabs Alpine | 2 x Cortex-A15 / r2p4 / swp half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt
			echo "AnnapurnaLabs Alpine"
			;;
		??Marvellr1p1)
			# Marvell Armada 370/XP | 1 x Marvell PJ4 / r1p1 / half thumb fastmult vfp edsp vfpv3 vfpv3d16 tls idivt
			echo "Marvell Armada 370/XP"
			;;
		??Marvellr0p5)
			# Marvell Armada 510, 1 x Marvell PJ4 / r0p5 / swp half thumb fastmult vfp edsp iwmmxt thumbee
			echo "Marvell Armada 510"
			;;
		??Marvell88FR131r2p1)
			# Marvell Kirkwood 88F6281: 1 x Marvell Feroceon 88FR131 / r2p1 / swp half thumb fastmult edsp
			echo "Marvell Kirkwood 88F6281 / Armada 300/310"
			;;
		??Marvellr2p2??Marvellr2p2??Marvellr2p2??Marvellr2p2)
			# Marvell PJ4Bv7 | 4 x Marvell PJ4B-MP / r2p2 / swp half thumb fastmult vfp edsp vfpv3 tls
			echo "Marvell PJ4Bv7"
			;;
		??ARM11r0p5??ARM11r0p5)
			# PLX NAS7820: 2 x ARM11 MPCore / r0p5 / swp half thumb fastmult edsp java
			echo "PLX NAS7820"
			;;
		*FTC660r1p1*FTC660r1p1*FTC660r1p1*FTC660r1p1)
			# Phytium FT-1500A: 4 x Phytium FTC660 / r1p1 / fp asimd evtstrm aes pmull sha1 sha2 crc32 / https://openbenchmarking.org/s/Phytium+FT1500A
			echo "Phytium FT-1500A"
			;;
		*FTC662r1p2*FTC662r1p2*FTC662r1p2*FTC662r1p2*FTC662r1p2*FTC662r1p2*FTC662r1p2*FTC662r1p2*FTC662r1p2*)
			# Phytium FT-2000+/64: 64 x Phytium FTC662 / r1p2 / fp asimd evtstrm crc32 / https://github.com/util-linux/util-linux/issues/1036
			echo "Phytium FT-2000+/64"
			;;
		*FTC663r1p3*FTC663r1p3*FTC663r1p3*FTC663r1p3*FTC663r1p3*FTC663r1p3*FTC663r1p3*FTC663r1p3*FTC663r1p3*)
			# Phytium FT-2500: 64 x Phytium FTC663 / r1p3 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			echo "$(( ${CPUCores} / 64 )) x Phytium FT-2500"
			;;
		*FTC663r1p3*FTC663r1p3*FTC663r1p3*FTC663r1p3*FTC663r1p3*FTC663r1p3*FTC663r1p3*FTC663r1p3)
			# Phytium D2000/8: 8 x Phytium FTC663 / r1p3 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			echo "Phytium D2000/8"
			;;
		*FTC663r1p3*FTC663r1p3*FTC663r1p3*FTC663r1p3)
			# Phytium FT-2000/4: 4 x Phytium FTC663 / r1p3 / fp asimd evtstrm aes pmull sha1 sha2 crc32 / https://www.phytium.com.cn/en/article/97
			echo "Phytium FT-2000/4"
			;;
		*FTC310r0p4*FTC310r0p4*FTC664r1p3*FTC664r1p3)
			# Phytium E2000Q: 2 x FTC310 / r0p4 + 2 x FTC664 / r1p3 / fp asimd evtstrm aes pmull sha1 sha2 crc32 cpuid sha3 sha512
			echo "Phytium E2000Q"
			;;
		*FTC310r0p4*FTC310r0p4)
			# Phytium E2000D: 2 x FTC310 / r0p4 / fp asimd evtstrm aes pmull sha1 sha2 crc32 cpuid sha3 sha512
			echo "Phytium E2000D"
			;;
		*FTC310r0p4)
			# Phytium E2000S: 1 x FTC310 / r0p4 / fp asimd evtstrm aes pmull sha1 sha2 crc32 cpuid sha3 sha512
			echo "Phytium E2000S"
			;;
		*FTC862r0p0*FTC862r0p0*FTC862r0p0*FTC862r0p0*FTC862r0p0*FTC862r0p0*FTC862r0p0*FTC862r0p0)
			# Phytium D3000/8: 8 x Phytium FTC862 / r0p0 / https://browser.geekbench.com/v6/cpu/3447903.gb6
			echo "Phytium D3000"
			;;
		*A57r1p2*A57r1p2*A57r1p2*A57r1p2*A57r1p2*A57r1p2*A57r1p2*A57r1p2)
			# AMD Opteron A1100: 8 x Cortex-A57 / r1p2 / https://bugzilla-attachments.redhat.com/attachment.cgi?id=1475897
			echo "AMD Opteron A1100"
			;;
		*Cavium99xxr0p1*)
			# Cavium ThunderX2 CN9980: 32 x Cavium ThunderX2 99xx / r0p1
			echo "$(( ${CPUCores} / 32 )) x Cavium ThunderX2 CN9980"
			;;
		*XGener3p2*)
			# APM Emag 8180: 32 x Ampere X-Gene / r3p2 / fp asimd evtstrm aes pmull sha1 sha2 crc32 cpuid
			# Earlier X-Gene revisions than r3 lack CRC and crypto flags/features
			echo "$(( ${CPUCores} / 32 )) x APM Emag 8180"
			;;
		*Xgener0p0*Xgener0p0*Xgener0p0*Xgener0p0*Xgener0p0*Xgener0p0*Xgener0p0*Xgener0p0*)
			# APM 883208-X1: 8 x APM X-Gene / r0p0 / fp asimd evtstrm
			echo "$(( ${CPUCores} / 8 )) x APM 883208-X1"
			;;
		*A72r0p2*A72r0p2*A72r0p2*A72r0p2*A72r0p2*A72r0p2*A72r0p2*A72r0p2*A72r0p2*A72r0p2*A72r0p2*A72r0p2*A72r0p2*A72r0p2*A72r0p2*A72r0p2*A72r0p2*A72r0p2*A72r0p2*A72r0p2*A72r0p2*A72r0p2*A72r0p2*A72r0p2*A72r0p2*A72r0p2*A72r0p2*A72r0p2*A72r0p2*A72r0p2*A72r0p2*A72r0p2*)
			# HiSilicon Kunpeng 916 in Huawei Taishan 100 2280 server: 2 x 32 x Cortex-A72 / r0p2 / https://gist.github.com/expipiplus1/bd48761b119e867d3c9ddabc2f677374
			echo "$(( ${CPUCores} / 32 )) x HiSilicon Kunpeng 916"
			;;
		*TaiShanv110r1p0*)
			# HiSilicon Kunpeng 920-6426 in Huawei Taishan 200 2280 V2 server: 2 x 64 x TaiShan v110 / r1p0 / fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp cpuid asimdrdm jscvt fcma dcpop asimddp asimdfhm ssbs
			# https://www.spec.org/cpu2017/results/res2020q2/cpu2017-20200529-22564.html / https://en.wikichip.org/wiki/hisilicon/microarchitectures/taishan_v110
			case $(awk -F":" '/ per socket/ {print $2}' <<<"${LSCPU}" | tr -c -d '[:digit:]') in
				32)
					echo "$(( ${CPUCores} / 32 )) x HiSilicon Kunpeng 920-3226"
					;;
				48)
					echo "$(( ${CPUCores} / 48 )) x HiSilicon Kunpeng 920-4826"
					;;
				64)
					echo "$(( ${CPUCores} / 64 )) x HiSilicon Kunpeng 920-6426"
					;;
				24)
					echo "HiSilicon Kunpeng 920 3211K"
					;;
				8)
					echo "HiSilicon Kunpeng 920 2249K"
					;;
				4)
					echo "HiSilicon Kunpeng 920 quad core"
					;;
			esac
			;;
		*TaiShanv120*)
			# HiSilicon HiSilicon Kunpeng 930
			echo "HiSilicon Kunpeng 930"
			;;
		*A72r0p2*A72r0p2*A53r0p4*A53r0p4)
			# Socionext UniPhier LD20: 2 x Cortex-A72 / r0p2 + 2 x Cortex-A53 / r0p4 / https://lore.kernel.org/all/CAM-ziR6N36F-2C7wHLEa4rUD1BpN+pAyMtnjCS9NWJWACZnwQA@mail.gmail.com/T/
			echo "Socionext UniPhier LD20"
			;;
		*A53r0p1*A53r0p1*A53r0p1*A53r0p1*A57r1p0*A57r1p0*A57r1p0*A57r1p0)
			# Samsung Exynos 5433: 4 x Cortex A53 / r0p1 + 4 x Cortex A57 / r1p0 / ?
			echo "Samsung Exynos 5433"
			;;
		*A53r0p2*A53r0p2*A53r0p2*A53r0p2*A57r1p0*A57r1p0*A57r1p0*A57r1p0)
			# Samsung Exynos 7420: 4 x Cortex A53 / r0p2 + 4 x Cortex A57 / r1p0 / fp asimd aes pmull sha1 sha2 crc32
			echo "Samsung Exynos 7420"
			;;
		*A53r0p4*A53r0p4*A53r0p4*A53r0p4*A53r0p4*A53r0p4*A73r0p2*A73r0p2)
			# Samsung Exynos 7885: 6 x Cortex A53 / r0p4 + 2 Cortex A73 / r0p2 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			echo "Samsung Exynos 7885"
			;;
		*A53r0p4*A53r0p4*A53r0p4*A53r0p4*Samsungr1p1*Samsungr1p1*Samsungr1p1*Samsungr1p1)
			# Samsung Exynos 8890: 4 x Cortex A53 / r0p4 + 2 or 4 x Exynos-m1 / r1p1 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			echo "Samsung Exynos 8890"
			;;
		*A53r0p4*A53r0p4*A53r0p4*A53r0p4*Samsungr4p0*Samsungr4p0*Samsungr4p0*Samsungr4p0)
			# Samsung Exynos 8895: 4 x Cortex A53 / r0p4 + 4 x Exynos-m1 / r4p0 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			# The cores are called M2 (Mongoose 2) but share same core ID with M1 and only stepping differs
			echo "Samsung Exynos 8895"
			;;
		*A55r0p1*A55r0p1*A55r0p1*A55r0p1*Samsungr1p0*Samsungr1p0*Samsungr1p0*Samsungr1p0)
			# Samsung Exynos 9810: 4 x Cortex A55 / r0p1 + 4 x Exynos-m3 / r1p0 / fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp
			echo "Samsung Exynos 9810"
			;;
		*A55r1p0*A55r1p0*A55r1p0*A55r1p0*A75r2p1*A75r2p1*Samsungr1p0*Samsungr1p0)
			# Samsung Exynos 9820: 4 x Cortex A55 / r1p0 + 2 x Cortex-A75 / r2p1 + 2 x Exynos-m4 / r1p0 / fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp cpuid asimdrdm dcpop asimddp
			echo "Samsung Exynos 9820"
			;;
		*A76r3p0*A76r3p0*A76r3p0*A76r3p0*A76r3p0*A76r3p0*A76r3p0*A76r3p0)
			# Samsung Exynos Auto V9: 8 x Cortex-A76 / r3p0 / fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp cpuid asimdrdm lrcpc dcpop
			echo "Samsung Exynos Auto V9"
			;;
		*A72r0p2*A72r0p2*A72r0p2*A72r0p2*A72r0p2*A72r0p2*A72r0p2*A72r0p2)
			# NXP LS2088A: 8 x Cortex-A72 / r0p2 / https://community.nxp.com/t5/QorIQ/LS2088-ETH1-connection/td-p/1024323
			echo "NXP LS2088A"
			;;
		*A72r0p3*A72r0p3*A72r0p3*A72r0p3*A72r0p3*A72r0p3*A72r0p3*A72r0p3*A72r0p3*A72r0p3*A72r0p3*A72r0p3*A72r0p3*A72r0p3*A72r0p3*A72r0p3)
			# NXP LX2160A: 16 x Cortex-A72 / r0p3 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			# or AWS Graviton, 16 x Cortex-A72 / r0p3 / fp asimd evtstrm aes pmull sha1 sha2 crc32 / L1d: 32K, L1i: 48K, L2: 2048K
			grep -q -E "nxp|lx2160" <<<"${DTCompatible,,}" && echo "NXP LX2160A" || echo "AWS Graviton"
			;;
		36?A72r0p336?A72r0p336?A72r0p336?A72r0p336?A72r0p336?A72r0p336?A72r0p336?A72r0p3)
			# NXP LX2080A: 8 x Cortex-A72 / r0p3 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			echo "NXP LX2080A"
			;;
		36?A72r0p336?A72r0p336?A72r0p336?A72r0p336?A72r0p336?A72r0p336?A72r0p336?A72r0p336?A72r0p336?A72r0p336?A72r0p336?A72r0p3)
			# NXP LX2120A: 12 x Cortex-A72 / r0p3 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			echo "NXP LX2120A"
			;;
		*A72r0p3*A72r0p3)
			# NXP LS1028A: 2 x Cortex-A72 / r0p3 / fp asimd evtstrm aes pmull sha1 sha2 crc32
			echo "NXP LS1028A"
			;;
		*A75r3p1*)
			# Unisoc T610/T618/T700/T740: 4-6 x Cortex A55 + 2/4 x Cortex-A75 / r3p1
			case "${DTCompatible,,}" in
				*t610*)
					echo "Unisoc T610"
					;;
				*t618*)
					echo "Unisoc T618"
					;;
				*t700*)
					echo "Unisoc T700"
					;;
				*t740*)
					echo "Unisoc T740"
					;;
				*unisoc*)
					echo "Unisoc T610/T618/T700/T740"
					;;
			esac
			;;
		*NeoverseN1r3p1*)
			# Ampere Altra / Altra Max: 32/48/64/72/80/96/128 x Neoverse-N1 / r3p1 / fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp cpuid asimdrdm lrcpc dcpop asimddp ssbs
			# or AWS Graviton2: 1/2/4/8/16/32/48/64 vCPU Neoverse-N1 / r3p1 / fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp cpuid asimdrdm lrcpc dcpop asimddp ssbs / L1d 128K, L1i 128K, L2 2M, L3 32M
			# https://lore.kernel.org/all/alpine.DEB.2.22.394.2204131354190.3066615@ubuntu-linux-20-04-desktop/
			# https://www.spec.org/cpu2017/results/res2021q3/cpu2017-20210702-27694.pdf
			# https://www.youtube.com/watch?v=4jImmuMqnwc&t=1111s
			# https://www.anandtech.com/show/15578/cloud-clash-amazon-graviton2-arm-against-intel-and-amd
			# https://github.com/coreos/fedora-coreos-tracker/issues/920#issuecomment-904981854
			# https://github.com/xianyi/OpenBLAS/issues/2696#issuecomment-652627716
			# https://www.anandtech.com/show/16979/the-ampere-altra-max-review-pushing-it-to-128-cores-per-socket
			# https://blog.cloudflare.com/arms-race-ampere-altra-takes-on-aws-graviton2/
			#
			# Distinguishing between Graviton2 and Ampere Altra (QuickSilver) isn't easy since they
			# share same core types, stepping, CPU flags and even cache sizes though this site here
			# https://adam.younglogic.com/2022/05/building-linux-tip-of-tree-on-an-ampere-based-system/
			# reports smaller cache sizes for Ampere Altra. Measured clockspeeds should differ (2.5 GHz
			# for AWS vs. 3/3+ GHz for Altra while reviews mentioned little less). Altra Max (Mystique)
			# could be identified by its smaller L3 cache.
			if [ -r "${ResultLog}" ]; then
				grep -q 'No cpufreq support available. Measured on cpu' "${ResultLog}" && \
					MeasuredClockspeed=$(awk -F": " '/No cpufreq support available. Measured on cpu/ {print $2}' <"${ResultLog}" | cut -f1 -d' ' | head -n 1) || \
					MeasuredClockspeed=$(grep -A2 "^Checking cpufreq OPP" "${ResultLog}" | awk -F" " '/Measured/ {print $5}' | sort -r | head -n1)
			fi
			ProcessorInfo="$(dmidecode -t processor 2>/dev/null | grep -E -v -i "^#|^Handle|Serial|O.E.M.|1234567|SMBIOS|: Not |Unknown|OUT OF SPEC|00 00 00 00 00 00 00 00|: None")"
			case ${ProcessorInfo} in
				*Ampere*|*Altra*)
					# Try to get Part Number via DMI
					PartNumber="$(awk -F": " '/Part Number: / {print $2}' <<<"${ProcessorInfo}" | tr '\n' '/' | sed -e 's/NotSet/Unpopulated/' -e 's/\/$//')"
					if [ -n "${PartNumber}" ]; then
						# output part number:
						echo "Ampere Altra ${PartNumber}"
					else
						# empty string, so check count of CPU cores per socket and in total and report that
						case $(awk -F":" '/ per socket/ {print $2}' <<<"${LSCPU}" | tr -c -d '[:digit:]') in
							32)
								echo "$(( ${CPUCores} / 32 )) x Ampere Altra AADP-32"
								;;
							48)
								echo "$(( ${CPUCores} / 48 )) x Ampere Altra AADP-48"
								;;
							64)
								echo "$(( ${CPUCores} / 64 )) x Ampere Altra AADP-64"
								;;
							72)
								echo "$(( ${CPUCores} / 72 )) x Ampere Altra AADP-72"
								;;
							80)
								echo "$(( ${CPUCores} / 80 )) x Ampere Altra AADP-80"
								;;
							96)
								echo "$(( ${CPUCores} / 96 )) x Ampere Altra AADP-96"
								;;
							128)
								echo "$(( ${CPUCores} / 128 )) x Ampere Altra Max"
								;;
							*)
								echo "Ampere Altra / Altra Max"
								;;
						esac
					fi
					;;
				*)
					# No DMI information hinting at Ampere/Altra so we check clockspeeds
					if [ ${MeasuredClockspeed:-0} -gt 2550 ]; then
						# Lame assumption that cpufreq above 2.5GHz identifies Ampere Altra
						echo "Ampere Altra"
					else
						echo "AWS Graviton2"
					fi
					;;
			esac
			;;
		*NeoverseV1r1p1*)
			# AWS Graviton3: 1/2/4/8/16/32/48/64 vCPU Neoverse-V1 / r1p1 / fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp cpuid asimdrdm jscvt fcma lrcpc dcpop sha3 sm3 sm4 asimddp sha512 sve asimdfhm dit uscat ilrcpc flagm ssbs paca pacg dcpodp svei8mm svebf16 i8mm bf16 dgh rng
			echo "AWS Graviton3"
			;;
		*NeoverseN2r0p0*)
			# Marvell Octeon 10: 24 x Neoverse-N2 / r0p0 / fp asimd aes pmull sha1 sha2 crc32 atomics fphp asimdhp cpuid asimdrdm jscvt fcma lrcpc dcpop sha3 sm3 sm4 asimddp sha512 sve asimdfhm dit uscat ilrcpc flagm ssbs sb paca pacg dcpodp sve2 sveaes svepmull svebitperm svesha3 svesm4 flagm2 frint rng / L1d 1.5M, L1i 1.5M, L2 24M, L3 48M
			# or Alibaba g8y/c8y/r8y VMs hosted on YiTian 710 CPUs: 1/2/4/8/16/32/64/128 x Neoverse-N2 / r0p0 / fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp cpuid asimdrdm jscvt fcma lrcpc dcpop sha3 sm3 sm4 asimddp sha512 sve asimdfhm dit uscat ilrcpc flagm ssbs sb dcpodp sve2 sveaes svepmull svebitperm svesha3 svesm4 flagm2 frint svei8mm svebf16 i8mm bf16 dgh bti
			if [ ${CPUCores} -eq 24 ]; then
				echo "Marvell Octeon 10"
			else
				echo "YiTian 710"
			fi
			;;
		*NeoverseV2r0p0*)
			# Nvidia Grace: 72 or 144 Neoverse-V2 / r0p0 / fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp cpuid asimdrdm jscvt fcma lrcpc dcpop sha3 sm3 sm4 asimddp sha512 sve asimdfhm dit uscat ilrcpc flagm ssbs sb dcpodp sve2 sveaes svepmull svebitperm svesha3 svesm4 flagm2 frint svei8mm svebf16 i8mm bf16 dgh
			case ${CPUCores} in
				72)
					echo "Nvidia Grace Hopper"
					;;
				144)
					echo "Nvidia Grace"
					;;
			esac
			;;
		*AppleM1r0p0*AppleM1r0p0*AppleM1r0p0*AppleM1r0p0*AppleM1*AppleM1*AppleM1*AppleM1*|*AppleM1r1p1*AppleM1r1p1*AppleM1r1p1*AppleM1r1p1*AppleM1r1p1*AppleM1r1p1*AppleM1r1p1*AppleM1r1p1)
			# Apple M1: 4 x Apple Icestorm / r1p1 + 4 x Apple Firestorm / r1p1 / https://gist.github.com/z4yx/13520bd2beef49019b1b7436e3b95ddd
			# or 4 x Apple Icestorm / r0p0 + 4 x Apple Firestorm / ? / https://bench.cr.yp.to/computers.html
			echo "Apple M1"
			;;
		*AppleM1Pror2p0*AppleM1Pror2p0*AppleM1Pror2p0*AppleM1Pror2p0*AppleM1Pror2p0*AppleM1Pror2p0*AppleM1Pror2p0*AppleM1Pror2p0*AppleM1Pror2p0*AppleM1Pror2p0)
			# Apple M1 Pro: 2 x Apple Icestorm / r2p0 + 4 x Apple Firestorm / r2p0 + 4 x Apple Firestorm / r2p0 / fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp cpuid asimdrdm jscvt fcma lrcpc dcpop sha3 asimddp sha512 asimdfhm dit uscat ilrcpc flagm ssbs sb paca pacg dcpodp flagm2 frint
			echo "Apple M1 Pro"
			;;
		*AppleM1Max*AppleM1Max*AppleM1Max*AppleM1Max*AppleM1Max*AppleM1Max*AppleM1Max*AppleM1Max*AppleM1Max*AppleM1Max*AppleM1Max*AppleM1Max*AppleM1Max*AppleM1Max*AppleM1Max*AppleM1Max*AppleM1Max*AppleM1Max*AppleM1Max*AppleM1Max)
			# Apple M1 Ultra: 2 M1 Max combined on an Interposer
			echo "Apple M1 Ultra"
			;;
		*AppleM1Max*AppleM1Max*AppleM1Max*AppleM1Max*AppleM1Max*AppleM1Max*AppleM1Max*AppleM1Max*AppleM1Max*AppleM1Max)
			# Apple M1 Max: 2 x Apple Icestorm + 8 x Apple Firestorm
			echo "Apple M1 Max"
			;;
		*AppleM2r1p0*AppleM2r1p0*AppleM2r1p0*AppleM2r1p0*AppleM2r1p0*AppleM2r1p0*AppleM2r1p0*AppleM2r1p0)
			# Apple M2: 4 x Apple Blizzard / r1p0 + 4 x Apple Avalanche / r1p0 / https://github.com/hrw/arm-socs-table/blob/main/cpuinfo-data/apple-m2
			echo "Apple M2"
			;;
		*AppleM2Pro*)
			# Apple M2 Pro: 4 x Apple Blizzard  + 6/8 x Apple Avalanche / https://github.com/AsahiLinux/m1n1/commit/7904ed43dc0c2760e728f611efa0b26895ebcd10
			echo "Apple M2 Pro"
			;;
		*AppleM2Max*)
			# Apple M2 Max: 4 x Apple Blizzard + 8 x Apple Avalanche / https://github.com/AsahiLinux/m1n1/commit/8d0474f57b1fb45588d412dcbe7e229dbe6d43cb
			echo "Apple M2 Max"
			;;
		*AppleM3Pro*)
			# Apple M3 Pro: 6 x Apple Sawtooth + 6 x Apple Everest
			echo "Apple M3 Pro"
			;;
		*AppleM3Max*)
			# Apple M3 Max: 4 x Apple Sawtooth + 12 x Apple Everest / https://github.com/AsahiLinux/m1n1/pull/357
			echo "Apple M3 Max"
			;;
		*VirtualizedSiliconr0p0*)
			# When running bare metal M1 and M2 SoCs differ by flags/features:
			# M1: 'fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp cpuid asimdrdm jscvt fcma lrcpc dcpop sha3 asimddp sha512 asimdfhm dit uscat ilrcpc flagm ssbs sb paca pacg dcpodp flagm2 frint'
			# M2: 'fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp cpuid asimdrdm jscvt fcma lrcpc dcpop sha3 asimddp sha512 asimdfhm dit uscat ilrcpc flagm ssbs sb paca pacg dcpodp flagm2 frint i8mm bf16 bti ecv'
			# M3: Based on comparing 'sysctl -A | grep "hw.optional.arm.FEAT_"' output in macOS CPU features/flag seem to be identical to M2
			# Inside Hypervisor.Framework guests on M1/M2 hosts all ID values are set to 0 (0x61/0x0 r0p0 on M3) and on M2/M3 SoCs VMs only see M1 CPU flags/features.
			grep -q -E 'fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp cpuid asimdrdm jscvt fcma lrcpc dcpop sha3 asimddp sha512 asimdfhm dit uscat ilrcpc flagm ssbs sb paca pacg dcpodp flagm2 frint|fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp cpuid asimdrdm jscvt fcma lrcpc dcpop sha3 asimddp sha512 asimdfhm dit uscat ilrcpc flagm sb paca pacg dcpodp flagm2 frint' <<< "${ProcCPU}" && echo "Apple Silicon"
			;;
		*thead,c906|10)
			# Allwinner D1: single T-Head C906 core
			echo "Allwinner D1"
			;;
		*rv64i2p0m2p0a2p0f2p0d2p0c2p0xv50p0*rv64i2p0m2p0a2p0f2p0d2p0c2p0xv50p0)
			# Kendryte K510: Dual-core 64-bit RISC-V https://canaan.io/product/kendryte-k510
			grep -q k510 <<<"${DTCompatible,,}" && echo "Kendryte K510"
			;;
		*thead,c908*thead,c908|*rv64imafdcvxthead*)
			# Kendryte K230: Dual-core 64-bit RISC-V https://canaan.io/product/kendryte-k230
			echo "Kendryte K230"
			;;
		*thead,c910*thead,c910|1?1?|10rv64imafdcsu10rv64imafdcsu)
			# T-Head C910: Dual-core XuanTieISA (compatible with RISC-V 64GC) https://www.t-head.cn/product/c910?lang=en
			grep -q c910 <<<"${DTCompatible,,}" && echo "T-Head C910"
			;;
		??rv64imafdcvsu??rv64imafdcvsu??rv64imafdcvsu??rv64imafdcvsu)
			# T-Head TH1520: quad-core T-Head C910 https://occ.t-head.cn/wujian600?id=4080405462988689408
			echo "T-Head TH1520"
			;;
		*sifive,u54-mc*sifive,u54-mc*sifive,u54-mc*sifive,u54-mc)
			# SiFive "Freedom" U540: 4 x U54-MC https://www.sifive.com/cores/u54-mc
			echo "SiFive U540"
			;;
		10sifive,u74mc10sifive,u74mc10sifive,u74mc10sifive,u74mc|*sifive,u74mc*sifive,u74mc*sifive,u74mc*sifive,u74mc)
			# StarFive JH7110: 4 x U74-MC https://raw.githubusercontent.com/ThomasKaiser/sbc-bench/master/results/cpuinfo/StarFive-JH7110-6.5.0.cpuinfo
			echo "StarFive JH7110"
			;;
		*sifive,u74mc*sifive,u74mc)
			# StarFive JH7100: 2 x U74-MC https://doc-en.rvspace.org/Doc_Center/datasheet_7100.html
			echo "StarFive JH7100"
			;;
		*00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv00rv64imafdcv)
			# Sophgo Mango / Sophon SG2042, 64 x T-Head C910 https://servernews.ru/1081875
			if [ ${CPUCores} -gt 64 ]; then
				echo "$(( ${CPUCores} / 64 )) x Sophon SG2042"
			else
				echo "Sophon SG2042"
			fi
			;;
		*rv64imafdc)
			# Renesas RZ/Five R9A07G043: single Andes AX45MP core
			if [ ${CPUCores} -eq 1 ]; then
				echo "Renesas RZ/Five R9A07G043"
			fi
			;;
		*rv64imafdcv_sscofpmf_sstc_svpbmt_zicbom_zicboz_zicbop_zihintpause*rv64imafdcv_sscofpmf_sstc_svpbmt_zicbom_zicboz_zicbop_zihintpause*rv64imafdcv_sscofpmf_sstc_svpbmt_zicbom_zicboz_zicbop_zihintpause*rv64imafdcv_sscofpmf_sstc_svpbmt_zicbom_zicboz_zicbop_zihintpause04rv64imafdcv_sscofpmf_sstc_svpbmt_zicbom_zicboz_zicbop_zihintpause04rv64imafdcv_sscofpmf_sstc_svpbmt_zicbom_zicboz_zicbop_zihintpause04rv64imafdcv_sscofpmf_sstc_svpbmt_zicbom_zicboz_zicbop_zihintpause04rv64imafdcv_sscofpmf_sstc_svpbmt_zicbom_zicboz_zicbop_zihintpause)
			# SpacemiT K1
			echo "SpacemiT K1"
			;;
		0?Qualcomm3XXSilver0?Qualcomm3XXSilver0?Qualcomm3XXSilver0?Qualcomm3XXSilver0?Qualcomm3XXGold0?Qualcomm3XXGold0?Qualcomm3XXGold0?Qualcomm3XXGold)
			# Qualcomm Snapdragon 845 / SDM845: 4 x Qualcomm Kryo 3XX Silver / r7p12 + 4 x Qualcomm Kryo 3XX Gold / r6p13 / fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp cpuid asimdrdm lrcpc dcpop
			echo "Qualcomm Snapdragon 845"
			;;
		00Qualcomm4XXSilver00Qualcomm4XXSilver00Qualcomm4XXSilver00Qualcomm4XXSilver14A77r1p014A77r1p014A77r1p027A77r1p0)
			# Qualcomm Snapdragon 865 or QRB5165: 4 x Qualcomm Kryo 4XX Silver / r13p14 + 3 x Cortex-A77 / r1p0 + 1 x Cortex-A77 / r1p0 / fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp asimdrdm lrcpc dcpop asimddp
			echo "Qualcomm Snapdragon 865 / QRB5165"
			;;
		*A55r2p0*A55r2p0*A55r2p0*A55r2p0*A78r1p0*A78r1p0*A78r1p0*X1r1p0)
			# Qualcomm SM8350 (Snapdragon 888): 4 x Cortex-A55 / r2p0 + 3 x Cortex-A78 / r1p0 + 1 x Cortex-X1 / r1p0 / fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp cpuid asimdrdm lrcpc dcpop asimddp
			echo "Qualcomm SM8350 (Snapdragon 888)"
			;;
		*A78Cr0p0*A78Cr0p0*A78Cr0p0*A78Cr0p0*X1Cr0p0*X1Cr0p0*X1Cr0p0*X1Cr0p0|360X1Cr0p0360X1Cr0p0360X1Cr0p0360X1Cr0p0360X1Cr0p0360X1Cr0p0360X1Cr0p0360X1Cr0p0)
			# Qualcomm Snapdragon 8cx Gen 3 : 4 x Cortex-A78C / r0p0 + 4 x Cortex-X1C / r0p0 / fp asimd aes pmull sha1 sha2 crc32 atomics fphp asimdhp cpuid asimdrdm lrcpc dcpop asimddp ilrcpc flagm
			# When running Linux on this thing in WSL2 (Windows Subsystem for Linux 2) all 8 cores are presented as Cortex-X1C and from within Linux it's impossible
			# to assign single-threaded tasks to an A78C since they end up on an X1C anyway: https://github.com/ThomasKaiser/sbc-bench/issues/58#issuecomment-1374900303
			echo "Qualcomm Snapdragon 8cx Gen 3"
			;;
		*A510r0p2*A510r0p2*A510r0p2*A510r0p2*A710r2p0*A710r2p0*A710r2p0*X2r2p0)
			# Qualcomm Snapdragon 8 Gen1: 4 x Cortex-A510 / r0p2 + 3 Cortex-A710 / r2p0 + 1 x Cortex-X2 / r2p0 / fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp cpuid asimdrdm jscvt fcma lrcpc dcpop sha3 sm3 sm4 asimddp sha512 sve asimdfhm dit uscat ilrcpc flagm ssbs sb paca pacg dcpodp sve2 sveaes svepmull svebitperm svesha3 svesm4 flagm2 frint svei8mm svebf16 i8mm bf16 bti
			echo "Qualcomm Snapdragon 8 Gen1"
			;;
		*A510r0p3*A510r0p3*A510r0p3*A510r0p3*A710r2p0*A710r2p0*A710r2p0*X2r2p0)
			# Qualcomm Snapdragon 8+ Gen1: 4 x Cortex-A510 / r0p3 + 3 Cortex-A710 / r2p0 + 1 x Cortex-X2 / r2p0
			echo "Qualcomm Snapdragon 8+ Gen1"
			;;
		*A510r1p1*A510r1p1*A510r1p1*A715r1p0*A715r1p0*A710r2p0*A710r2p0*X3r1p0)
			# Qualcomm Snapdragon 8 Gen 2 (SM8550): 3 x Cortex-A510 / r1p1 + 2 x Cortex-A715 / r1p0 + 2 x Cortex-A710 / r2p0 + 1 x Cortex-X3 / r1p0 / fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp cpuid asimdrdm jscvt fcma lrcpc dcpop sha3 sm3 sm4 asimddp sha512 asimdfhm dit uscat ilrcpc flagm ssbs sb paca pacg dcpodp flagm2 frint i8mm bf16 bti
			echo "Qualcomm Snapdragon 8 Gen 2"
			;;
		*A520r0p1*A520r0p1*A720r0p1*A720r0p1*A720r0p1*A720r0p1*A720r0p1*X4r0p1)
			# Qualcomm Snapdragon 8 Gen 3: 2 x Cortex-A520 / r0p1 + 5 x Cortex-A720 / r0p1 + 1 x Cortex-X4 / r0p1 / fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp cpuid asimdrdm jscvt fcma lrcpc dcpop sha3 sm3 sm4 asimddp sha512 asimdfhm dit uscat ilrcpc flagm ssbs sb paca pacg dcpodp flagm2 frint i8mm bf16 dgh bti ecv afp
			echo "Qualcomm Snapdragon 8 Gen 3"
			;;
		*A55r2p0*A55r2p0*A55r2p0*A55r2p0*A76r4p0*A76r4p0*X1r1p0*X1r1p0)
			# Google Tensor G1: 4 x Cortex-A55 / r2p0 + 2 x Cortex-A76 / r4p0 + 2 x Cortex-X1 / r1p0 / fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp cpuid asimdrdm lrcpc dcpop asimddp
			echo "Google Tensor G1"
			;;
		*A55r2p0*A55r2p0*A55r2p0*A55r2p0*A78r1p1*A78r1p1*X1r1p0*X1r1p0)
			# Google Tensor G2: 4 x Cortex-A55 / r2p0 + 2 x Cortex-A78 / r1p1 + 2 x Cortex-X1 / r1p0 / fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp cpuid asimdrdm lrcpc dcpop asimddp
			echo "Google Tensor G2"
			;;
		*A510r1p1*A510r1p1*A510r1p1*A510r1p1*A715r1p0*A715r1p0*A715r1p0*A715r1p0)
			# Google Tensor G3: 4 x Cortex-A510 / r1p1 + 4 x Cortex-A715 / r1p0 / fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp cpuid asimdrdm jscvt fcma lrcpc dcpop sha3 sm3 sm4 asimddp sha512 sve asimdfhm dit uscat ilrcpc flagm ssbs sb paca pacg dcpodp sve2 sveaes svepmull svebitperm svesha3 svesm4 flagm2 frint svei8mm svebf16 i8mm bti mte mte3
			echo "Google Tensor G3"
			;;
		0?Loongson3A10000?Loongson3A10000?Loongson3A10000?Loongson3A1000)
			# Loongson 3A1000: 4 x Loongson-3 V0.5 FPU V0.1 https://github.com/ThomasKaiser/sbc-bench/blob/master/results/cpuinfo/Loongson-3A1000.cpuinfo
			echo "Loongson 3A1000"
			;;
		0?Loongson3A30000?Loongson3A30000?Loongson3A30000?Loongson3A3000)
			# Loongson 3A3000: 4 x Loongson-3 V0.9 FPU V0.1 https://github.com/ThomasKaiser/sbc-bench/blob/master/results/cpuinfo/Loongson-3A3000-5.4.211-aosc-lemote.cpuinfo
			echo "Loongson 3A3000"
			;;
		0?Loongson3A5000H0?Loongson3A5000H0?Loongson3A5000H0?Loongson3A5000H)
			# Loongson-3A5000-H: 4 x LoongArch / loongarch32, loongarch64 / cpucfg lam ual fpu lsx lasx complex crypto lvz lbt_x86 lbt_arm lbt_mips https://github.com/ThomasKaiser/sbc-bench/blob/master/results/cpuinfo/Loongson-3A5000-H-4.19.0-17-loongson-3.cpuinfo
			echo "Loongson-3A5000-H"
			;;
		0?Loongson3A5000HV0?Loongson3A5000HV0?Loongson3A5000HV0?Loongson3A5000HV)
			# Loongson-3A5000-HV: 4 x LoongArch / loongarch32, loongarch64 / cpucfg lam ual fpu lsx lasx complex crypto lvz lbt_x86 lbt_arm lbt_mips https://github.com/ThomasKaiser/sbc-bench/blob/master/results/cpuinfo/Loongson-3A5000-HV-4.19.0-loongson-3.cpuinfo
			echo "Loongson-3A5000-HV"
			;;
		0?Loongson3A5000M0?Loongson3A5000M0?Loongson3A5000M0?Loongson3A5000M)
			# Loongson-3A5000M: 4 x LoongArch / loongarch32, loongarch64 / cpucfg lam ual fpu lsx lasx complex crypto lvz lbt_x86 lbt_arm lbt_mips https://github.com/ThomasKaiser/sbc-bench/blob/master/results/cpuinfo/Loongson-3A5000M-4.19.0.cpuinfo
			echo "Loongson-3A5000M"
			;;
		*Loongson3A6000*Loongson3A6000*Loongson3A6000*Loongson3A6000)
			# Loongson-3A6000: 4 x LoongArch / loongarch32, loongarch64 / cpucfg lam ual fpu lsx lasx crc32 complex crypto lvz lbt_x86 lbt_arm lbt_mips https://github.com/ThomasKaiser/sbc-bench/blob/master/results/cpuinfo/Loongson-3A6000-4.19.0-loongson-3.cpuinfo
			# With SMT support: with SCHED_SMT enabled CPU appears as 4c/8t, without as 8c/8t? https://lkml.org/lkml/2023/6/14/397
			echo "Loongson-3A6000"
			;;
		*Loongson3?6000*Loongson3?6000*Loongson3?6000*Loongson3?6000)
			# Loongson-3A6000 variants with more cores
			[ "X${ModelName}" != "X" ] && echo "${ModelName}"
			;;
		*A55*A55*A55*A55*A76r4p1|*A76r4p1*A55*A55*A55*A55r?p?)
			# Amlogic S928X, 4 x Cortex-A55 + 1 x Cortex-A76 / r4p1: https://browser.geekbench.com/v5/cpu/compare/19788026?baseline=20656779
			echo "Amlogic S928X"
			;;
		*A55r2p0*A55r2p0*A55r2p0*A55r2p0*A55r2p0*A55r2p0*A78r1p0*A78r1p0)
			# MediaTek MT8188JV/A: 6 x Cortex-A55 / r2p0 + 2 x Cortex-A78 / r1p0 / fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp cpuid asimdrdm lrcpc dcpop asimddp
			echo "MediaTek MT8188JV/A"
			;;
		*A55r2p0*A55r2p0*A55r2p0*A55r2p0*A78r1p0*A78r1p0*A78r1p0*A78r1p0)
			# MediaTek Genio 1200 (MT8395): 4 x Cortex-A55 / r2p0 + 4 x Cortex-A78 / r1p0 / fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp cpuid asimdrdm lrcpc dcpop asimddp
			echo "MediaTek Genio 1200 (MT8395)"
			;;
		0?IngenicV4.15FPUV0.00?IngenicV4.15FPUV0.0)
			# Ingenic JZ4780: dual-core MIPS32
			echo "Ingenic JZ4780"
			;;
		*Azure100r?p?*)
			# Microsoft Azure Cobalt 100, based on Neoverse-N2 r0p0
			# https://lore.kernel.org/linux-arm-kernel/b99a7196-011e-4f08-83ec-e63a690ab919@linux.microsoft.com/T/
			echo "Azure Cobalt 100"
			;;
	esac
} # GuessSoCbySignature

GetCPUSignature() {
	case ${CPUArchitecture} in
		arm*|aarch*|riscv*|mips*|loongarch*)
			sed -e '1,/^ CPU/ d' -e 's/Cortex-//' -e 's/HiSilicon-//' -e 's/Phytium //' <<<"${CPUTopology}" | while read ; do
				echo -e "$(awk -F" " '{print $2$3$6$8$9$10}' <<<"${REPLY}" | sed -e 's/-//g' -e 's/\///g')\c"
			done
			;;
	esac
} # GetCPUSignature

IdentifyAXGGXLG12A() {
	# Amlogic AXG, GXL and G12A SoC families share same cluster details (quad A53 / r0p4).
	# They differ in speed though: GXL usually fakes 1.5 GHz while being limited to 1.4 GHz
	# (LibreComputer's La Frite and Jethub devices being the exceptions reporting the true
	# 1416 MHz) but G12A (S905X2, S905D2, S905Y2) clocks higher and doesn't fake clockspeeds
	MaxSpeed="$(sed -e '1,/^ CPU/ d' <<<"${CPUTopology}" | tail -n1 | awk -F" " '{print $5}')"
	case ${MaxSpeed} in
		15??|14??)
			# GXL or AXG: 4 x Cortex-A53 / r0p4 / fp asimd evtstrm aes pmull sha1 sha2 crc32 cpuid (running 32-bit: fp asimd evtstrm aes pmull sha1 sha2 crc32 wp half thumb fastmult vfp edsp neon vfpv3 tlsi vfpv4 idiva idivt)
			echo "Amlogic A113X/A113D, S805X, S805Y, S905X/S905D/S905L/S905L2/S905M2"
			;;
		12??)
			# S905W being limited to 1.2 GHz
			echo "Amlogic S905W"
			;;
		*)
			# G12A/TL1: 4 x Cortex-A53 / r0p4 / fp asimd evtstrm aes pmull sha1 sha2 crc32 cpuid
			echo "Amlogic S905X2/S905Y2/S905D2/S905L3A/T962X2"
			;;
	esac
} # IdentifyAXGGXLG12A

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
	grep -q h616 <<<"${DTCompatible,,}" && echo "Allwinner H616/H313"
	grep -q t507 <<<"${DTCompatible,,}" && echo "Allwinner T507"
	grep -q h313 <<<"${DTCompatible,,}" && echo "Allwinner H313"
	grep -q pine-h64 <<<"${DTCompatible,,}" && echo "Allwinner H6"
	grep -q h64 <<<"${DTCompatible,,}" && echo "Allwinner H64"
	grep -q h6 <<<"${DTCompatible,,}" && echo "Allwinner H6"
	grep -q h5 <<<"${DTCompatible,,}" && echo "Allwinner H5"
	grep -q a64 <<<"${DTCompatible,,}" && echo "Allwinner A64"

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
	grep -E -q "sun50i-h616|sun50iw9" <<<"${DMESG}" && echo "Allwinner H616/H313"
	grep -q sun50i-a64 <<<"${DMESG}" && echo "Allwinner A64"
	grep -q sun50i-h5 <<<"${DMESG}" && echo "Allwinner H5"
	grep -q sun50i-h6- <<<"${DMESG}" && echo "Allwinner H6"

	# A64 is accompanied by AXP803 PMIC:
	grep -q axp803 /proc/interrupts && echo "Allwinner A64"

	# With A64 BSP kernel we can try to rely on a sysfs node
	[ -d /sys/devices/platform/axp81x_board/axp81x-supplyer.47 ] \
		 && echo "Allwinner A64"

	# H5 is usually combined with an I2C attached Silergy SY8106A voltage regulator
	lsmod | grep -i -q sy8106a && echo "Allwinner H5"

	# Maybe there's something in kernel ring buffer identifying the SoC
	grep -E -q "sun50i-h5|sun50iw2" <<<"${DMESG}" && echo "Allwinner H5"

	# if we end up here then print some generic BS
	echo "Allwinner unidentified SoC"
} # IdentifyAllwinnerARMv8

ShowZswapStats() {
	# https://www.kernel.org/doc/Documentation/vm/zswap.txt
	[ -r /sys/module/zswap/parameters/enabled ] && ZswapEnabled="$(sed 's/Y/1/' </sys/module/zswap/parameters/enabled)"
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
		if [ -n "${max_pool_percent}" ] && [ -n "${compressor}" ] && [ -n "${zpool}" ]; then
			echo -e "Zswap active using ${compressor}/${zpool}, max pool occupation: ${max_pool_percent}%\c"
		elif [ -n "${compressor}" ] && [ -n "${zpool}" ]; then
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

BegForContribution() {
	# ask user to submit results. TODO: how to identify results are not already uploaded
	# w/o querying the github repo. 
	cat <<- EOF
	It seems your device ${DeviceName} is not represented in sbc-bench's results list.
	EOF
} # BegForContribution

GrabCPUFetchInfo() {
	if [ -x "${InstallLocation}"/cpufetch/cpufetch ]; then
		echo -e "Information courtesy of cpufetch:\n"
		CPUFetchOutput="$("${InstallLocation}"/cpufetch/cpufetch -s legacy --logo-short 2>/dev/null | sed "s,\x1B\[[0-9;]*[a-zA-Z],,g")"
		case ${CPUFetchOutput} in
			*SoC:*)
				FirstLine="$(grep "SoC:" <<<"${CPUFetchOutput}")"
				LogoArea=${FirstLine%%SoC:*}
				;;
			*Name:*)
				FirstLine="$(grep "Name:" <<<"${CPUFetchOutput}")"
				LogoArea=${FirstLine%%Name:*}
				;;
			*"Part Number:"*)
				FirstLine="$(grep "Part Number:" <<<"${CPUFetchOutput}")"
				LogoArea=${FirstLine%%Part*}
				;;
		esac
		cut -c$((${#LogoArea} + 1))- <<<"${CPUFetchOutput}" | sed -e '/^$/d' | grep -v "Peak Performance:"
	else
		echo "Unknown"
	fi
} # GrabCPUFetchInfo

ProvideReviewInfo() {
	# This function tries to collect as much performance relevant information
	# possible based on sbc-bench being now 5 years used on lots of devices.
	#
	# Once it's ready collecting data (which includes some measurements of e.g.
	# CPU clockspeeds and memory bandwidth/latency) it switches all performance
	# relevant governors to performance, then remains in the background to 
	# report throttling while the reviewer conducts tests with other benchmarks
	#
	# TODO:
	#
	# * warning if uneven count of DIMMs
	# * ThreadX version, UEFI/BIOS version
	# * coherent_pool size

	echo "Starting to examine hardware/software for review purposes..."

	# ensure other sbc-bench instances are terminated
	for PID in $( (pgrep -f "${PathToMe}" ; jobs -p) | sort | uniq -u) ; do
		if [ ${PID} -ne $$ ]; then
			kill ${PID} 2>/dev/null
		fi
	done

	# prerequisits: create temp dir, ensure CPU utilization and/or average load is low
	# enough to continue, collect information, set governors to performance

	[ -z "${DMESG}" ] && DMESG="$(dmesg | grep -E "Linux|pvtm|rockchip-dmc|rockchip-cpuinfo|Amlogic Meson|sun50i|pcie|mmc|leakage")"
	CreateTempDir
	[ -f /sys/devices/system/cpu/cpufreq/policy0/scaling_governor ] && \
		read OriginalCPUFreqGovernor </sys/devices/system/cpu/cpufreq/policy0/scaling_governor 2>/dev/null
	[ "${OriginalCPUFreqGovernor}" = "ondemand" ] && \
		io_is_busy=( $(find /sys/devices/system/cpu/cpufreq -name io_is_busy | while read ; do cat "${REPLY}"; done) )
	GovernorState="$(HandleGovernors)"
	[ "X${RunBenchmarks}" = "XTRUE" ] && CheckLoadAndDmesg || echo ""

	# Allow for a NOTUNING=yes operation mode to compare default with performance settings
	if [ "X${NOTUNING}" != "Xyes" ] && [ -f /sys/devices/system/cpu/cpufreq/policy0/scaling_governor ]; then
		HandleGovernors powersave
		if [ -f /sys/kernel/debug/clk/clk_summary ]; then
			snore 1
			cat /sys/kernel/debug/clk/clk_summary >"${TempDir}/clk_summary.powersave"
		fi
		HandleGovernors performance
		OriginalCPUInfo="$(PrintCPUInfo)"
		TunedGovernorState="$(HandleGovernors | awk -F" " '{print $1" "$2" "$3" "$4" "$5}')"
		BasicSetup performance >/dev/null 2>&1
		[ -f /sys/kernel/debug/clk/clk_summary ] && cat /sys/kernel/debug/clk/clk_summary >"${TempDir}/clk_summary.tuned"
	else
		BasicSetup nochange >/dev/null 2>&1
		OriginalCPUInfo="$(PrintCPUInfo)"
	fi

	GetTempSensor
	OperatingSystem="$(GetOSRelease)"
	InstallPrerequisits
	[ "X${RunBenchmarks}" = "XTRUE" ] && InstallCpuminer
	InitialMonitoring
	CheckNetio
	unset SPACING

	if [ "X${RunBenchmarks}" = "XTRUE" ]; then
		CheckClockspeedsAndSensors
		# repeat SoC guessing after measuring CPU clockspeeds (some guesses depend on clockspeed)
		[ "${CPUArchitecture}" = "aarch64" ] && GuessedSoC="$(GuessARMSoC)"
		ClockspeedsBefore="$(cat "${TempDir}/cpufreq" | sed -e 's/^/    /')"
		[ "X${NOTUNING}" != "Xyes" ] && [ -f /sys/devices/system/cpu/cpufreq/policy0/scaling_governor ] && CheckTimeInState before
		RunTinyMemBench
		RunRamlat
		RunOpenSSLBenchmark 256
		Run7ZipBenchmark
		if [ -x "${InstallLocation}/Stockfish-sf_15/src/stockfish" ]; then
			ExecuteStockfish=yes
			RunStockfishBenchmark
		elif [ -x "${InstallLocation}"/cpuminer-multi/cpuminer ]; then
			ExecuteCpuminer=yes
			RunCpuminerBenchmark
		else
			RunStressNG
		fi
		[ -z ${InitialTemp} ] || TempNow=$(ReadSoCTemp)
		[ "X${NOTUNING}" != "Xyes" ] && [ -f /sys/devices/system/cpu/cpufreq/policy0/scaling_governor ] && CheckTimeInState after
		CheckClockspeedsAndSensors
		ClockspeedsAfter="$(cat "${TempDir}/cpufreq" | sed -e 's/^/    /')"
		SummarizeResults
	else
		echo -e "\x08\x08 Done.\nNow quickly examining OS, settings and hardware...\c"
		echo -e "\n##########################################################################\n" >>"${ResultLog}"
		echo -e "$(iostat | grep -E -v "^loop|boot0|boot1|mtdblock")\n\n$(free -h)\n\n$(swapon -s)\n" | sed '/^$/N;/^\n$/D' >>"${ResultLog}"
		ShowZswapStats 2>/dev/null >>"${ResultLog}"
		echo >>"${ResultLog}"
		cat "${TempDir}/cpu-topology.log" >>"${ResultLog}"
		echo "${LSCPU}" >>"${ResultLog}"
		LogEnvironment >>"${ResultLog}"
	fi

	if [ -f "${TempDir}/clk_summary.tuned" ]; then
		# add clk_summary diff to results output if something has changed
		ClockDiff="$(diff "${TempDir}"/clk_summary.*)"
		if [ $? -ne 0 ]; then
			echo -e "\n##########################################################################\n\n/sys/kernel/debug/clk/clk_summary diff between all governors set to powersave and performance:\n" >>"${ResultLog}"
			head -n3 "${TempDir}/clk_summary.tuned" | sed -e 's/^/  /' >>"${ResultLog}"
			echo -e "${ClockDiff}" >>"${ResultLog}"
		fi
	fi

	# Prepare device listing in Markdown friendly format
	echo -e "# ${DeviceName:-$HostName}" >"${TempDir}/review"
	echo -e "\nTested with sbc-bench v${Version} on $(date -R).\n\n### General information:\n" >>"${TempDir}/review"

	# include cpufetch output if available
	CPUFetchInfo="$(GrabCPUFetchInfo)"
	if [[ ${CPUFetchInfo} != *Unknown* ]]; then
		echo "${CPUFetchInfo}" | sed  -e 's/^/    /' >>"${TempDir}/review"
		echo "    " >>"${TempDir}/review"
	fi

	# add info about CPU cores, if more than 2 CPU clusters add info about them and core types
	if [ ${#ClusterConfig[@]} -gt 1 ] && [ ${#ClusterConfigByCoreType[@]} -eq 1 ]; then
		echo -e "The CPU features ${#ClusterConfig[@]} clusters of same core type:\n" >>"${TempDir}/review"
	elif [ ${#ClusterConfig[@]} -gt 1 ] && [ ${#ClusterConfig[@]} -eq ${#ClusterConfigByCoreType[@]} ]; then
		echo -e "The CPU features ${#ClusterConfig[@]} clusters of different core types:\n" >>"${TempDir}/review"
	elif [ ${#ClusterConfig[@]} -gt 1 ]; then
		echo -e "The CPU features ${#ClusterConfig[@]} clusters consisting of ${#ClusterConfigByCoreType[@]} different core types:\n" >>"${TempDir}/review"
	fi
	sed -e 's/^/    /' <<<"${OriginalCPUInfo}" >>"${TempDir}/review"

	AvailableMem=$(free | awk -F" " '/^Mem:   / {print $2}' | tail -n1)
	echo -e "\n$(( ${AvailableMem} / 1024 )) KB available RAM" >>"${TempDir}/review"

	# report probably performance relevant governors (not on x86_64) and policies
	PolicyStateNow="$(HandlePolicies)"
	if [ -f /sys/devices/system/cpu/cpufreq/policy0/scaling_governor ] && [ "${CPUArchitecture}" != "x86_64" ]; then
		echo -e "\n### Governors/policies (performance vs. idle consumption):\n\nOriginal governor settings:\n" >>"${TempDir}/review"
		sed -e 's/^/    /' <<<"${GovernorState}" >>"${TempDir}/review"
		if [ "X${TunedGovernorState}" != "X" ]; then
			# when running with NOTUNING=yes no before/after check will be performed
			echo -e "\nTuned governor settings:\n" >>"${TempDir}/review"
			sed -e 's/^/    /' <<<"${TunedGovernorState}" >>"${TempDir}/review"
		fi
	else
		[ "X${PolicyStateNow}" != "X" ] && echo -e "\n### Policies (performance vs. idle consumption):" >>"${TempDir}/review"
	fi
	if [ "X${PolicyStateNow}" != "X" ]; then
		echo -e "\nStatus of performance related policies found below /sys:\n" >>"${TempDir}/review"
		sed -e 's/^/    /' <<<"${PolicyStateNow}" >>"${TempDir}/review"
	fi

	if [ "X${RunBenchmarks}" = "XTRUE" ]; then
		# measured clockspeeds
		if [ -z ${InitialTemp} ]; then
			# no thermal readouts possible
			echo -e "\n### Clockspeeds (idle vs. heated up):\n\nBefore:\n\n${ClockspeedsBefore}\n\nAfter:\n\n${ClockspeedsAfter}" >>"${TempDir}/review"
		else
			echo -e "\n### Clockspeeds (idle vs. heated up):\n\nBefore at ${InitialTemp}°C:\n\n${ClockspeedsBefore}\n\nAfter at ${TempNow}°C${ThrottlingWarning}:\n\n${ClockspeedsAfter}" >>"${TempDir}/review"
		fi

		# Performance baseline:
		MemoryScores="$(awk -F" " '/^ libc / {print $2$4" "$5" "$6}' <"${ResultLog}" | grep -E 'memcpy|memchr|memset' | awk -F'MB/s' '{print $1"MB/s"}')"
		CountOfMemoryScores=$(wc -l <<<"${MemoryScores}")
		if [ $(( ${#ClusterConfig[@]} * 3 )) -eq ${CountOfMemoryScores} ]; then
			# only report if all measurements finished successfully, add warning for
			# NOTUNING operation mode.
			[ "X${NOTUNING}" = "Xyes" ] && PerfWarning=" (NOTUNING=yes was set)"
			echo -e "\n### Performance baseline${PerfWarning}\n" >>"${TempDir}/review"
			if [ ${#ClusterConfig[@]} -eq 1 ]; then
				# only 1 CPU cluster, no differentiation between clusters/core types
				echo -e "  * $(grep "^memcpy:" <<<"${MemoryScores}"), $(grep "^memchr:" <<<"${MemoryScores}"), $(grep "^memset:" <<<"${MemoryScores}")" >>"${TempDir}/review"
				grep "^     16384k:" "${ResultLog}" | sed 's/     16384k:/  * 16M latency:/' >>"${TempDir}/review"
				grep "^    131072k:" "${ResultLog}" | sed 's/    131072k:/  * 128M latency:/' >>"${TempDir}/review"
			else
				# list individual CPUs and suffix memory scores with core types if possible
				for i in $(seq 0 $(( ${#ClusterConfig[@]} -1 )) ) ; do
					CPUInfo="$(GetCPUInfo ${ClusterConfig[$i]})"
					echo -e "  * cpu${ClusterConfig[$i]}${CPUInfo}: $(grep "^memcpy:" <<<"${MemoryScores}" | sed -n $(( ${i} + 1 ))p), $(grep "^memchr:" <<<"${MemoryScores}" | sed -n $(( ${i} + 1 ))p), $(grep "^memset:" <<<"${MemoryScores}" | sed -n $(( ${i} + 1 ))p)"  >>"${TempDir}/review"
				done
				for i in $(seq 0 $(( ${#ClusterConfig[@]} -1 )) ) ; do
					CPUInfo="$(GetCPUInfo ${ClusterConfig[$i]})"
					echo -e "  * cpu${ClusterConfig[$i]}${CPUInfo} 16M latency: $(grep "^     16384k:" "${ResultLog}" | sed -n $(( ${i} + 1 ))p | sed 's/     16384k: //')" >>"${TempDir}/review"
				done
				for i in $(seq 0 $(( ${#ClusterConfig[@]} -1 )) ) ; do
					CPUInfo="$(GetCPUInfo ${ClusterConfig[$i]})"
					echo -e "  * cpu${ClusterConfig[$i]}${CPUInfo} 128M latency: $(grep "^    131072k:" "${ResultLog}" | sed -n $(( ${i} + 1 ))p | sed 's/    131072k: //')" >>"${TempDir}/review"
				done
			fi
			ZIPResults="$(awk -F" " '/^Total:/ {print $2}' "${ResultLog}" | sed -e 's/,/, /g' -e 's/, $//')"
			[ "X${ZIPResults}" != "X" ] && echo -e "  * 7-zip MIPS (${RunHowManyTimes} consecutive runs): ${ZIPResults} (${ZipScore} avg), single-threaded: ${ZipScoreSingleThreaded}" >>"${TempDir}/review"
			OpenSSLResults="$(grep '^aes-256-cbc' "${OpenSSLLog}")"
			[ "X${OpenSSLResults}" != "X" ] && echo -e "${OpenSSLResults}" | sed -e 's/^/  * `/' -e 's/$/`/' >>"${TempDir}/review"
		fi
	fi

	# PCIe and storage devices, important stuff like downgraded PCIe link width/speed,
	# SMART errors and suspectible values, counterfeit SD card and speed negotiation
	# issues, (almost) worn out SSDs, unhealthy drive temps (most SSDs start to throttle
	# above a certain thermal treshold), negotiated USB and SATA speeds relating to e.g.
	# underpowering (https://github.com/raspberrypi/linux/issues/4130#issuecomment-787826273)
	# and so on...
	PCIeStatus="$(CheckPCIe | sed 's/Vendor\ Device\ 0001/Raspberry Pi Ltd. RP1/')"
	StorageStatus="$(CheckStorage update-smart-drivedb | sed 's/000Mbps/Gbps/')"
	if [ "X${PCIeStatus}" != "X" ] && [ "X${StorageStatus}" != "X" ]; then
		echo -e "\n### PCIe and storage devices:\n\n${PCIeStatus}\n${StorageStatus}" >>"${TempDir}/review"
	elif [ "X${StorageStatus}" = "X" ]; then
		echo -e "\n### PCIe devices:\n\n${PCIeStatus}" >>"${TempDir}/review"
	elif [ "X${PCIeStatus}" = "X" ]; then
		echo -e "\n### Storage devices:\n\n${StorageStatus}" >>"${TempDir}/review"
	fi

	# In preparation of before/after diff remove sane drive temperatures to keep only "unhealthy drive temp"
	StorageStatus="$(echo "${StorageStatus}" | awk -F", drive temp: " '{print $1"X"}' | sed -e 's/X$//' -e '/^$/d' | grep -v smartctl)"

	# check whether NTFS filesystems are attached (do not need to be mounted yet)
	[ -z "${LSBLK}" ] && LSBLK="$(LC_ALL="C" lsblk -l -o SIZE,NAME,FSTYPE,LABEL,MOUNTPOINT 2>&1)"
	NTFSdevices="$(awk -F" " '/ ntfs / {print $2}' <<< "${LSBLK}" | tr '\n' ',' | sed 's/,$//')"
	if [ "X${NTFSdevices}" != "X" ]; then
		echo -e "\n### Challenging filesystems:\n\nThe following partitions are NTFS: ${NTFSdevices} -> https://tinyurl.com/mv7wvzct" >>"${TempDir}/review"
	fi

	# check swap devices/files/partitions
	SwapDevices="$(ListSwapDevices)"
	if [ "X${SwapDevices}" != "X" ]; then
		echo -e "\n### Swap configuration:\n\n${SwapDevices}" >>"${TempDir}/review"
	fi

	# software versions
	echo -e "\n### Software versions:\n" >>"${TempDir}/review"
	case "${OperatingSystem}" in
		Armbian*|"Orange Pi"*)
			# Armbian went full megalomania in the meantime. They try to trick their users
			# into thinking to run an 'Armbian 23.02.0-trunk.0072 Jammy' while in reality it's
			# 'Ubuntu 22.04 Jammy' debootstraped with a certain version of Armbian's build
			# scripts. The Xunlong copycats do something similarly stupid and report for
			# example 'Orange Pi 1.0.6 Jammy' as distro. Let's fix this nonsense.
			RealDistro="$(awk -F":\t" '/^Description/ {print $2}' <"${ResultLog}")"
			OSCodename="$(awk -F":\t" '/^Codename/ {print $2}' <"${ResultLog}")"
			grep -q "${OSCodename}" <<<"${RealDistro}" && echo "  * ${RealDistro} ${ARCH}" >>"${TempDir}/review" \
				|| echo "  * ${RealDistro} (${OSCodename}) ${ARCH}" >>"${TempDir}/review"
			;;
		*)
			echo "  * ${OperatingSystem}" >>"${TempDir}/review"
			;;
	esac
	BuildInfo="$(grep "^Build system:   " "${ResultLog}" | sed 's/Build system:   /  * Build scripts: /')"
	[ -z "${BuildInfo}" ] || echo "${BuildInfo}" >>"${TempDir}/review"
	grep -i "^ Compiler:" "${ResultLog}" | sed -e 's/^/  */' >>"${TempDir}/review"
	openssl version | awk -F" " '{print "  * "$1" "$2", built on "$3" "$4" "$5" "$6" "$7" "$8" "$9" "$10" "$11" "$12" "$13" "$14" "$15}' >>"${TempDir}/review"
	[ -z "${ThreadXVersion}" ] || echo -e "  * ThreadX: $(tail -n1 <<<"${ThreadXVersion}" | cut -d' ' -f2) / $(head -n1 <<<"${ThreadXVersion}")" >>"${TempDir}/review"
	# Check Rockchip boot environment (may only work on Radxa images)
	RKBootEnvironment="$(GetRKBootEnvironment)"
	if [ "X${RKBootEnvironment}" != "X" ]; then
		echo -e "  * Boot environment: ${RKBootEnvironment}" >>"${TempDir}/review"
	fi

	# Kernel relevant settings / versions
	echo -e "\n### Kernel info:\n" >>"${TempDir}/review"

	[ -r /proc/cmdline ] && echo -e "  * \`/proc/cmdline: $(</proc/cmdline)\`" >>"${TempDir}/review"
	grep "^Vulnerability" <<<"${LSCPU}" | grep -v 'Not affected' | sed -e 's/^/  * /' >>"${TempDir}/review"
	CONFIGHZ="$(awk -F" " '/CONFIG_HZ=/ {print $1}' <"${ResultLog}")"
	[ -z "${CONFIGHZ}" ] && echo "  * Kernel ${KernelVersion}" >>"${TempDir}/review" || echo "  * Kernel ${KernelVersion} / ${CONFIGHZ}" >>"${TempDir}/review"
	[ -z "${KernelInfo}" ] || echo -e "\n${KernelInfo}" >>"${TempDir}/review"

	# if in NetIO mode then measure idle consumption walking through available governors and PCIe ASPM
	if [ "X${OutputCurrents[*]}" != "X" ]; then
		CountOfGovernors=$(wc -l <<<"${GovernorState}")
		[ "X${RunBenchmarks}" = "XTRUE" ] || echo -e "\x08\x08 Done."
		echo -e "Now measuring idle consumption ($(( 3 + ${CountOfGovernors} * 3 )) more minutes)...\c"
		NetioConsumptionFile="${TempDir}/netio.current"
		echo -n $(( $(awk '{printf ("%0.0f",$1/10); }' <<<"${OutputCurrent[$(( ${NetioSocket} - 1 ))]}" ) * 10 )) >"${NetioConsumptionFile}"
		export NetioConsumptionFile
		HandleGovernors powersave >/dev/null 2>&1
		HandlePolicies powersave >/dev/null 2>&1
		/bin/bash "${PathToMe}" -N ${NetioDevice} ${NetioSocket} ${NetioConsumptionFile} "1.8" "55" >/dev/null 2>&1 &
		NetioMonitoringPID=$!
		sleep 180
		read IdleConsumption <${NetioConsumptionFile}
		echo -e "\n### Idle consumption (measured with Netio ${NetioModel}, FW v${Firmware}):\n" >>"${TempDir}/review"
		echo -e "  * everything set to powersave: ${IdleConsumption} mW" >>"${TempDir}/review"
		if [ ${CountOfGovernors} -gt 1 ]; then
			find /sys -name "*governor" 2>/dev/null | grep -E -v '/sys/module|cpuidle|watchdog' | sort -n | while read ; do
				if [ -w "${REPLY}" ]; then
					echo performance >"${REPLY}"
					sleep 180
					read IdleConsumption <${NetioConsumptionFile}
					echo -e "  * ${REPLY%/*} set to performance: ${IdleConsumption} mW" >>"${TempDir}/review"
				else
					echo -e "  * Not able to set ${REPLY%/*} to performance" >>"${TempDir}/review"
				fi
			done
		fi
		if [ -w /sys/module/pcie_aspm/parameters/policy ] && [ -d /sys/bus/pci_express ]; then
			echo performance >/sys/module/pcie_aspm/parameters/policy
			sleep 180
			read IdleConsumption <${NetioConsumptionFile}
			echo -e "  * /sys/module/pcie_aspm/parameters/policy set to performance: ${IdleConsumption} mW" >>"${TempDir}/review"
		fi
		kill ${NetioMonitoringPID} 2>/dev/null
		echo -e "\x08\x08 Done."
	fi

	# add review info to full info
	echo -e "\n##########################################################################\n" >>"${ResultLog}"
	sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" <"${TempDir}/review" >>"${ResultLog}"
	[ "X${RunBenchmarks}" = "XTRUE" ] && UploadResults 2>/dev/null || UploadResults >/dev/null 2>&1
	case "${UploadURL}" in
		http*)
			echo -e "\n\n\n\n# ${DeviceName:-$HostName}\n\nTested with sbc-bench v${Version} on $(date -R). Full info: [${UploadURL}](${UploadURL})" | sed 's/http:/https:/'
			tail -n +4 "${TempDir}/review"
			;;
		*)
			echo -e "\n\n\n"
			cat "${TempDir}/review"
			;;
	esac

	if [ "X${NOTUNING}" != "Xyes" ] && [ "X${RunBenchmarks}" = "XTRUE" ]; then
		# throttling check and routine waiting for the board to cool down since otherwise the
		# next monitoring step will report throttling even if none happens from now on.
		[ "X${ThrottlingWarning}" != "X" ] && snore 5
		# temporary switch to performance when in Netio mode since otherwise the prior idle
		# measurements will result in the following check never finishing
		[ "X${OutputCurrents[*]}" != "X" ] && HandleGovernors performance >/dev/null 2>&1
		if [ -r /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq ]; then
			CpuFreqToQuery=cpuinfo_cur_freq
		elif [ -r /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq ]; then
			CpuFreqToQuery=scaling_cur_freq
		fi
		if [ -r /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq ]; then
			cpuinfo_max_freq=$(cat /sys/devices/system/cpu/cpu?/cpufreq/cpuinfo_max_freq)
			cpuinfo_cur_freq=$(cat /sys/devices/system/cpu/cpu?/cpufreq/${CpuFreqToQuery})
			if [ "X${cpuinfo_max_freq}" != "X${cpuinfo_cur_freq}" ]; then
				echo -e "\nWaiting for the device to cool down       \c"
				while [ "X${cpuinfo_max_freq}" != "X${cpuinfo_cur_freq}" ]; do
					TempNow=$(ReadSoCTemp)
					echo -e "\x08\x08\x08\x08\x08\x08\x08. ${TempNow}°C\c"
					snore 2
					cpuinfo_max_freq=$(cat /sys/devices/system/cpu/cpu?/cpufreq/cpuinfo_max_freq)
					cpuinfo_cur_freq=$(cat /sys/devices/system/cpu/cpu?/cpufreq/${CpuFreqToQuery})
				done
				# wait 20 more seconds for temperatures to stabilize
				for i in {1..10} ; do
					TempNow=$(ReadSoCTemp)
					echo -e "\x08\x08\x08\x08\x08\x08\x08. ${TempNow}°C\c"
					snore 2
				done
				echo ""
			fi
		fi
		[ "X${OutputCurrents[*]}" != "X" ] && HandlePolicies performance >/dev/null 2>&1
	fi

	# drop caches
	echo 3 >/proc/sys/vm/drop_caches

	# device now ready for benchmarking
	cat <<- EOF
	
	All known settings adjusted for performance. Device now ready for benchmarking.
	Once finished stop with [ctrl]-[c] to get info about throttling, frequency cap
	and too high background activity all potentially invalidating benchmark scores.
	All changes with storage and PCIe devices as well as suspicious dmesg contents
	will be reported too.
	EOF

	# Now switch to monitoring mode, report consumption if Netio powermeter is available
	if [ "X${OutputCurrents[*]}" != "X" ]; then
		# We are in Netio monitoring mode as such provide consumption info as well
		/bin/bash "${PathToMe}" -N ${NetioDevice} ${NetioSocket} ${NetioConsumptionFile} "4.8" "30" >/dev/null 2>&1 &
		NetioMonitoringPID=$!
	fi

	echo "sbc-bench review mode started" >/dev/kmsg
	trap 'FinalReporting ; exit 0' 0 1 2 3 15
	unset ThrottlingWarning ThrottlingCheck SwapWarning
	rm "${TempDir}"/*time_in_state* "${TempDir}/throttling_info.txt" 2>/dev/null
	SwapBefore="$(awk -F" " '{print $4}' </proc/swaps | grep -v -i Used | awk '{s+=$1} END {printf "%.0f", s}')"
	CheckTimeInState before
	export SPACING=yes
	/bin/bash "${PathToMe}" -m 60 >"${MonitorLog}" &
	MonitoringPID=$!
	echo ""
	snore 1
	tail -f "${MonitorLog}"
} # ProvideReviewInfo

FinalReporting() {
	trap 'rm -rf "${TempDir}" ; exit 0' 0
	echo -e "\n\nCleaning up...\c"
	kill ${NetioMonitoringPID} ${MonitoringPID} 2>/dev/null
	SwapNow="$(awk -F" " '{print $4}' </proc/swaps | grep -v -i Used | awk '{s+=$1} END {printf "%.0f", s}')"
	[ ${SwapNow:-0} -gt ${SwapBefore:-0} ] && SwapWarning=" and swapping" || SwapWarning=""
	CheckTimeInState after
	[ "X${RunBenchmarks}" = "XTRUE" ] && CheckClockspeedsAndSensors || echo -e "\x08\x08 Done.\n"

	# collect dmesg output since start of monitoring to spot anomalies
	TimeStamp="$(dmesg | tr -d '[' | tr -d ']' | awk -F" " '/sbc-bench review mode started/ {print $1}' | tail -n1)"
	DMESGSinceStart="$(dmesg | sed "/${TimeStamp}/,\$!d" | grep -E -v 'sbc-bench review mode started|started with executable stack|UFW BLOCK| EDID ')"
	DMESGLines=$(wc -l <<<"${DMESGSinceStart}")
	echo "${DMESGSinceStart}" >"${TempDir}/dmesg"

	# check PCIe and storage devices again to spot disconnects or link degradation and
	# stuff like this. Strip off sane drive temps so we only compare unhealthy ones
	PCIeStatusNow="$(CheckPCIe)"
	StorageStatusNow="$(CheckStorage | sed 's/000Mbps/Gbps/' | awk -F", drive temp: " '{print $1"X"}' | sed -e 's/X$//' -e '/^$/d' | grep -v smartctl)"

	if [ "X${RunBenchmarks}" = "XTRUE" ]; then
		ClockspeedsNow="$(cat "${TempDir}/cpufreq" | sed -e 's/^/    /')"
		if [ -z ${InitialTemp} ]; then
			# no thermal readouts possible
			echo -e "\x08\x08 Done.\n\nClockspeeds now:\n\n${ClockspeedsNow}\n"
		else
			echo -e "\x08\x08 Done.\n\nClockspeeds now at $(ReadSoCTemp)°C:\n\n${ClockspeedsNow}\n"
		fi
	fi

	# check for throttling
	ThrottlingCheck="$(CheckForThrottling | sed -e 's/ Check the log for details.//' -e '/^[[:space:]]*$/d')"
	if [ -f "${TempDir}/throttling_info.txt" ]; then
		ThrottlingWarning="${LRED}${BOLD} (throttled)${NC}"
		ThrottlingDetails=$(<"${TempDir}/throttling_info.txt")
	fi

	# Print warnings if count or details of attached PCIe or storage devices have changed.
	# Possible reasons: cable/connector problems, overheating, other transmission errors and so on...
	StorageDiff="$(diff <(echo "${StorageStatus}") <(echo "${StorageStatusNow}") )"
	PCIeDiff="$(diff <(echo "${PCIeStatus}") <(echo "${PCIeStatusNow}") )"
	if [ "X${StorageDiff}" != "X" ] && [ "X${PCIeDiff}" != "X" ]; then
		echo -e "\n${LRED}${BOLD}ATTENTION:${NC} status of PCIe and storage devices has changed:${NC}\n"
		echo -e "${PCIeDiff}\n${StorageDiff}\n"
	elif [ "X${StorageDiff}" != "X" ]; then
		echo -e "\n${LRED}${BOLD}ATTENTION:${NC} status of storage devices has changed:${NC}\n"
		echo -e "${StorageDiff}\n"
	elif [ "X${PCIeDiff}" != "X" ]; then
		echo -e "\n${LRED}${BOLD}ATTENTION:${NC} status of PCIe devices has changed:${NC}\n"
		echo -e "${PCIeDiff}\n"
	fi

	# print warnings if kernel ring buffer contains messages since start of monitoring:
	if [ ${DMESGLines:-0} -gt 20 ]; then
		echo -e "${LRED}${BOLD}ATTENTION:${NC} ${LRED}lots of noise in kernel ring buffer since start of monitoring:${NC}\n"
		echo -e "${DMESGSinceStart}\n"
	elif [ ${DMESGLines:-0} -gt 1 ]; then
		echo -e "${LRED}${BOLD}ATTENTION:${NC} some noise in kernel ring buffer since start of monitoring:\n"
		echo -e "${DMESGSinceStart}\n"
	fi

	# output execution validation, fake ClusterConfig to get definitive throttling warning
	ClusterConfig=(0)
	IsValid="$(ValidateResults review | sed -e 's/^/  * /')"
	[ "X${IsValid}" != "X" ] && echo -e "${BOLD}Results validation:${NC}\n\n${IsValid}\n"
	echo -e "${ThrottlingDetails}"

	CheckAgeOfScript

	# revert at least cpufreq and PCIe ASPM settings
	BasicSetup ${OriginalCPUFreqGovernor} >/dev/null 2>&1
	[ -w /sys/module/pcie_aspm/parameters/policy ] && echo "${OriginalASPMSetting}" >/sys/module/pcie_aspm/parameters/policy >/dev/null 2>&1
} # FinalReporting

CheckKernelVersion() {
	# checks device's kernel version and compares with https://endoflife.date/linux
	# Major challenge: identify those smelly vendor BSP kernels that show a version
	# number similar to an official LTS kernel but are in reality forward ported since
	# ages and can't be trusted AT ALL.

	# check whether endoflife data has been downloaded, if not return
	[ -r "${TempDir}/linuxkernel.md" ] || return

	# check whether kernel version contains "-rc" and if true simply return to not
	# bother devs developing/testing release candidate kernels
	case $1 in
		*-rc*)
			return
			;;
	esac

	# check kernel version number string for distro kernel schemes and return if true
	# Debian/Ubuntu kernel versions look like 6.2.0-32-generic, 5.10.0-23-amd64 or
	# 5.15.0-1035-raspi for example
	grep -v -E 'amlogic|librem5|rockchip' <<<"$1" | grep -q -E '[3-9]\.[0-9]{1,3}\.[0-9]{1,2}-[0-9]{1,4}-raspi|[3-9]\.[0-9]{1,3}\.[0-9]{1,2}-[0-9]{1,3}-[a-z]{1,3}' && return

	# RPi Bookworm images implement a new naming scheme not directly exposing real kernel
	# version, e.g. an RPi 4 runs 6.1.0-rpi4-rpi-v8, RPi 5 runs 6.1.0-rpi4-rpi-2712 or
	# 6.1.0-rpi6-rpi-v8
	grep -q -E 'rpi.-rpi' <<<"$1" && return

	# Fedora/Rockylinux kernels also follow an own release scheme and not mainline's
	grep -q -E '\.fc3|\.fc4|\.el9' <<<"$1" && return

	# skip this whole check on x86 and in aarch64 VMs where usually distro kernels are
	# used that follow an own release schedule
	case "${CPUArchitecture}" in
		x86_64)
			return
			;;
		aarch64)
			case ${VirtWhat} in
				kvm|oracle|parallels|vmware|wsl|xen|qemu)
					return
					;;
			esac
			;;
	esac

	# Avoid annoying users of latest bleeding edge kernels by ignoring anything with
	# higher version number than 1st entry on endoflife.date
	LastReleaseCycle="$(grep -A1 "^releases:$" "${TempDir}/linuxkernel.md" | awk -F'"' '/releaseCycle:/ {print $2}')"
	CheckRelease=$(echo -e "${LastReleaseCycle}\n${ShortKernelVersion}" | sort -n | head -n1)
	[ "${CheckRelease}" = "${LastReleaseCycle}" ] && return

	KernelVersionDigitsOnly=$(cut -f1 -d- <<<"$1")

	# parse LTS kernel info, in Nov 2023 this looks like this for example with 5.10:
	# releaseCycle: "5.10"
	# lts: true
	# releaseDate: 2020-12-13
	# eol: 2026-12-31 # Projected EOL from https://www.kernel.org/category/releases.html
	# latest: "5.10.201"
	# latestReleaseDate: 2023-11-20
	KernelStatus="$(grep -A5 "releaseCycle: \"${ShortKernelVersion}\"" "${TempDir}/linuxkernel.md" | tail -n5)"
	LatestKernelVersion="$(awk -F'"' '/latest:/ {print $2}' <<<"${KernelStatus}")"
	LatestKernelDate="$(awk -F": " '/latestReleaseDate:/ {print $2}' <<<"${KernelStatus}")"
	IsLTS="$(awk -F": " '/lts:/ {print $2}' <<<"${KernelStatus}")"
	[ "X${IsLTS}" = "Xtrue" ] && KernelSuffix=" LTS"
	EOLDate="$(awk -F": " '/eol:/ {print $2}' <<<"${KernelStatus}" | awk -F" # " '{print $1}')"
	Today="$(date "+%Y-%m-%d")"
	# check EOL date vs. today
	CheckEOL=$(echo -e "${Today}\n${EOLDate}" | sort -n | head -n1)

	if [ -z "${KernelStatus}" ]; then
		# some old kernel version neither being an LTS kernel nor any actively developed variant
		echo -e "${LRED}${BOLD}Kernel version ${KernelVersionDigitsOnly} is not covered by any active release cycle any more.${NC}\n"
		echo -e "${LRED}${BOLD}See https://endoflife.date/linux for details. It is highly likely countless${NC}"
		echo -e "${LRED}${BOLD}exploitable vulnerabilities do exist for this kernel as well as tons of bugs.${NC}"
	elif [ "X${KernelVersionDigitsOnly}" != "X${LatestKernelVersion}" ]; then
		# kernel version at least matches a supported kernel but is not most recent one
		BSPDisclaimer="\n${BOLD}But this version string doesn't matter since this is not an official${KernelSuffix} Linux${NC}\n${BOLD}from kernel.org.${NC} \c"
		UsedKernelRevision=$(cut -f3 -d. <<<"${KernelVersionDigitsOnly}" | tr -c -d '[:digit:]')
		LatestKernelRevision=$(cut -f3 -d. <<<"${LatestKernelVersion}" | tr -c -d '[:digit:]')
		RevisionDifference=$(( ${LatestKernelRevision:-0} - ${UsedKernelRevision:-0} ))
		if [ "X${CheckEOL}" = "X${EOLDate}" ] && [ "X${EOLDate}" != "Xfalse" ]; then
			# EOL date is in the past
			echo -e "${LRED}${BOLD}${ShortKernelVersion}${KernelSuffix} has reached end-of-life on ${EOLDate} with version ${LatestKernelVersion}.${NC}"
			echo -e "${LRED}${BOLD}This ${KernelVersionDigitsOnly} and all other ${ShortKernelVersion}${KernelSuffix} revisions are unsupported since then.${NC}"
		elif [ ${RevisionDifference} -gt 5 ]; then
			# report version mismatch only if kernel revision difference is greater than 5
			echo -e "${BOLD}Kernel ${KernelVersionDigitsOnly} is not latest ${LatestKernelVersion}${KernelSuffix} that was released on ${LatestKernelDate}.${NC}\n"
		else
			BSPDisclaimer="\n${BOLD}The ${KernelVersionDigitsOnly} kernel version string doesn't matter since this is not an official${NC}\n${BOLD}${KernelSuffix} Linux from kernel.org.${NC} \c"
		fi
		if [ "X${IsLTS}" = "Xtrue" ]; then
			# warn about vulnerabilities only on LTS kernels since users of actively
			# developed kernel branches should know what they're doing.
			if [ ${RevisionDifference} -ge 50 ]; then
				echo -e "${LRED}${BOLD}See https://endoflife.date/linux for details. It is somewhat likely that${NC}"
				echo -e "${LRED}${BOLD}a lot of exploitable vulnerabilities exist for this kernel as well as many${NC}"
				echo -e "${LRED}${BOLD}unfixed bugs.${NC}"
			elif [ ${RevisionDifference} -ge 20 ]; then
				echo -e "${LRED}${BOLD}See https://endoflife.date/linux for details. It is somewhat likely that some${NC}"
				echo -e "${LRED}${BOLD}exploitable vulnerabilities exist for this kernel as well as many unfixed bugs.${NC}"
			elif [ ${RevisionDifference} -gt 5 ]; then
				echo -e "${LRED}${BOLD}See https://endoflife.date/linux for details. Perhaps some kernel bugs have${NC}"
				echo -e "${LRED}${BOLD}been fixed in the meantime and maybe vulnerabilities as well.${NC}"
			else
				# Avoid annoying warnings if kernel revision difference is lower than 5.
				# Happened eg. with 6.1.9 shortly after 6.1 became most recent LTS kernel as
				# 'Kernel 6.1.9 is not latest 6.1.10 LTS that was released on 2023-02-06'
				:
			fi
		fi
	else
		# kernel version seems to match most recent upstream kernel.
		BSPDisclaimer="\n${BOLD}But this version string doesn't matter since this is not an official${KernelSuffix} Linux${NC}\n${BOLD}from kernel.org.${NC} \c"
		if [ "X${CheckEOL}" = "X${EOLDate}" ] && [ "X${EOLDate}" != "Xfalse" ]; then
			# EOL date is in the past
			echo -e "${LRED}${BOLD}${ShortKernelVersion}${KernelSuffix} has reached end-of-life on ${EOLDate}. ${KernelVersionDigitsOnly} is unsupported since then.${NC}"
		else
			echo -e "${LGREEN}According to https://endoflife.date/linux this kernel version is up to date.${NC}"
			if [ "X${IsLTS}" = "Xtrue" ]; then
				echo "The predicted end-of-life date for the ${ShortKernelVersion} LTS kernel is ${EOLDate}"
			fi
		fi
	fi

	case ${KernelVersionDigitsOnly} in
		# EOL notifications and BSP kernel warnings
		"3.10.33"|"4.16.1"|"4.18.7"|"5.0.2"|"5.1.0"|"5.3.0"|"5.3.11"|"5.5.0"|"5.6.0"|"5.7."*|"5.8."*|"5.9."*|"5.10.0"|"5.14.0")
			# Popular kernels for all sorts of Amlogic SoCs from https://github.com/150balbes
			# Unfortunately lots of devices still run with these ancient kernels lacking any fixes
			:
			;;
		3.4.*)
			# some SDKs/BSPs based on this version: Allwinner A10, A20, A83T, H2+/H3
			case ${GuessedSoC} in
				*Allwinner*)
					PrintBSPWarning Allwinner
					;;
			esac
			echo -e "\n${LRED}${BOLD}The 3.4 series has reached end-of-life on 2016-10-26 with version 3.4.113.${NC}"
			;;
		3.10.*)
			# some SDKs/BSPs based on this version: Allwinner A64, H5, R40/V40, Amlogic S805 (Meson8b), Exynos 5422
			case ${GuessedSoC} in
				*Allwinner*)
					PrintBSPWarning Allwinner
					;;
				*Amlogic*)
					PrintBSPWarning Amlogic
					;;
				*5422*)
					PrintBSPWarning Samsung
					;;
			esac
			echo -e "\n${LRED}${BOLD}The 3.10 series has reached end-of-life on 2017-11-05 with version 3.10.108.${NC}"
			;;
		3.14.*)
			case ${GuessedSoC} in
				*Amlogic*)
					PrintBSPWarning Amlogic
					;;
			esac
			echo -e "\n${LRED}${BOLD}The 3.14 series has reached end-of-life on 2016-09-11 with version 3.14.79.${NC}"
			;;
		3.16.*)
			# some SDKs/BSPs based on this version: Amlogic S905 (ODROID C2)
			case ${GuessedSoC} in
				*Amlogic*)
					PrintBSPWarning Amlogic
					;;
			esac
			echo -e "\n${LRED}${BOLD}The 3.16 series has reached end-of-life on 2020-06-11 with version 3.16.85.${NC}"
			;;
		3.18.*)
			# some SDKs/BSPs based on this version: Ingenic JZ4780, Qualcomm APQ8053
			case ${GuessedSoC} in
				*Ingenic*)
					PrintBSPWarning Ingenic
					;;
				*Qualcomm*)
					PrintBSPWarning Qualcomm
					;;
			esac
			echo -e "\n${LRED}${BOLD}The 3.18 series has reached end-of-life on 2017-02-08 with version 3.18.48.${NC}"
			;;
		4.4.*)
			# some SDKs/BSPs based on this version: Rockchip RK32xx/RK33xx, Nexell S5P4418/S5P6818
			case ${GuessedSoC} in
				*RK3*|*Rockchip*)
					PrintBSPWarning Rockchip
					;;
				*Nexell*)
					PrintBSPWarning Nexell
					;;
			esac
			echo -e "\n${LRED}${BOLD}The 4.4 series has reached end-of-life on 2022-02-03 with version 4.4.302.${NC}"
			;;
		4.9.*)
			# some SDKs/BSPs based on this version: Allwinner A50/MR133/R311/H6/H616/H313/H618, Amlogic S905X3 (SM1) / S922X/A311D (G12B), Exynos 5422, Nvidia AGX Xavier / Nvidia Jetson Nano / Nvidia Tegra X1 / Nvidia Tegra Xavier, RealTek RTD129x/RTD139x
			case ${GuessedSoC} in
				*5422*)
					PrintBSPWarning Samsung
					;;
				*Allwinner*)
					PrintBSPWarning Allwinner
					;;
				*Amlogic*)
					PrintBSPWarning Amlogic
					;;
				"RealTek RTD"*)
					PrintBSPWarning RealTek
					;;
				Nvidia*)	
					PrintBSPWarning Nvidia
					;;
			esac
			# prepare 4.9 not being listed any more on https://endoflife.date/linux
			grep -q "releaseCycle: \"4.9\"" "${TempDir}/linuxkernel.md" || \
				echo -e "\n${LRED}${BOLD}The 4.9 series has reached end-of-life on 2023-01-07 with version 4.9.337.${NC}"
			;;
		4.14.*)
			# some SDKs/BSPs based on this version: Exynos 5422/9820, NXP i.MX8x, Nexell S5P4418/S5P6818
			case ${GuessedSoC} in
				*Nexell*)
					PrintBSPWarning Nexell
					;;
				*5422*|"Samsung Exynos 9820")
					PrintBSPWarning Samsung
					;;
				"NXP i.MX8"*)
					PrintBSPWarning NXP
					;;
			esac
			;;
		4.19.*)
			# some SDKs/BSPs based on this version: Rockchip RK356x/RK3399
			case ${GuessedSoC} in
				*RK3566*|*RK3568*)
					PrintBSPWarning Rockchip
					;;
				Phytium*)
					PrintBSPWarning Phytium
					;;
			esac
			;;
		"5.4.125"|"5.4.180")
			# New Amlogic SDK initially released with 5.4.125 and after some version string cosmetics
			# stuck at 5.4.180
			case ${GuessedSoC} in
				Allwinner*)
					# 5.4.125 is also used in Allwinner Android builds
					PrintBSPWarning Allwinner
					;;
				*Amlogic*)
					PrintBSPWarning Amlogic
					;;
			esac
			;;
		5.4.*)
			# some SDKs/BSPs based on this version: Allwinner A133/A64/D1/R528/T113/H5/H6/H616/H618, Amlogic A311D2 (T7), S805X2/S905Y4/S905W2 (S4), S928X (S5), Exynos 5422
			case ${GuessedSoC} in
				Allwinner*)
					# highly unlikely that there's any Allwinner A64/H5/H6 out in the wild still running a _mainline_ 5.4 version
					PrintBSPWarning Allwinner
					;;
				*A311D2*|*S805X2*|*S905Y4*|*S905W2*|*S928X*)
					PrintBSPWarning Amlogic
					;;
				*5422*)
					PrintBSPWarning Samsung
					;;
				Phytium*)
					PrintBSPWarning Phytium
					;;
				*Unisoc*)
					PrintBSPWarning Unisoc
					;;
				*Synaptics*)
					PrintBSPWarning Synaptics
					;;
			esac
			;;
		5.10.4)
			case ${GuessedSoC} in
				*K230*)
					# Kendryte K230
					PrintBSPWarning Kendryte
					;;
			esac
			;;		
		5.10.66|5.10.72|5.10.110)
			case ${GuessedSoC} in
				*Rockchip*)
					# RK 5.10 BSP in different flavours
					PrintBSPWarning RockchipGKI
					;;
			esac
			;;
		5.10.*)
			# some SDKs/BSPs based on this version: Nvidia Jetson AGX Orin, Rockchip RK3399/RK3528/RK356x/RK3588/
			case ${GuessedSoC} in
				"Nvidia Jetson AGX Orin")
					PrintBSPWarning Nvidia
					;;
				Phytium*)
					PrintBSPWarning Phytium
					;;
				*RK3528*|*RK3588*)
					PrintBSPWarning RockchipGKI
					;;
				*RK3399*)
					# With RK3399 we need to differentiate between mainline and BSP kernel, for
					# example CONFIG_HZ (not reliable once someone gets the idea to switch BSP
					# settings from 300 to 250) or microvolts entries below /sys/devices/platform/
					dmesg | grep -q pvtm-volt-sel && PrintBSPWarning RockchipGKI
					;;
				*RK3566*|*RK3568*)
					# With RK3566/RK3568 same problem: how to differentiate between latest
					# RK BSP based on 5.10.66/5.10.110 and former mainlining efforts?  Check
					# dmesg output for PVTM for example
					dmesg | grep -q 'cpu cpu0: pvtm' && PrintBSPWarning RockchipGKI
					;;
				"Qualcomm Snapdragon 8 Gen1"|"Qualcomm Snapdragon 8+ Gen1")
					PrintBSPWarning Qualcomm
					;;
				*S928X*)
					PrintBSPWarning Amlogic
					;;
				*T-Head*)
					PrintBSPWarning T-Head
					;;
			esac
			;;
		"5.15.78"|"5.15.119")
			# New Amlogic SDK released with 5.15.78, supports at least T7, S4, SM1 and G12B.
			# Kernel version 5.15.119 some images were using is the result of version string
			# cosmetics over at ophub/flippy/unifreq
			# Allwinner's Android 13 BSP also uses both 5.15.78 and 5.15.119
			case ${GuessedSoC} in
				Allwinner*)
					# though there's a small chance users of flippy/unifreq kernels on older Allwinner SoCs are affected print BSP warning
					PrintBSPWarning Allwinner
					;;
				*Amlogic*)
					PrintBSPWarning Amlogic
					;;
			esac
			;;
		"5.15.41"|"5.15.94"|"5.15.123"|"5.15.151")
			# At least used with Android 13 and OpenWRT builds for A133/T527: https://browser.geekbench.com/v5/cpu/21947495.gb5 / https://browser.geekbench.com/v6/cpu/2610471.gb6 /
			# https://bbs.aw-ol.com/topic/5060/syterkit-启动-t527-失败 / https://github.com/chainsx/linux-t527/blob/main/Makefile
			case ${GuessedSoC} in
				Allwinner*)
					# though there's a small chance users of flippy/unifreq kernels on older Allwinner SoCs are affected
					PrintBSPWarning Allwinner
					;;
			esac
			;;
		5.15.*)
			case ${GuessedSoC} in
				StarFive*)
					PrintBSPWarning StarFive
					;;
				*MT7986A*|*"Genio 1200"*)
					PrintBSPWarning MediaTek
					;;
				*S928X*)
					# Android 14 BSP relies on 5.15
					PrintBSPWarning Amlogic
					;;
			esac
			;;
		6.1.*)
			case ${GuessedSoC} in
				SpacemiT*)
					PrintBSPWarning SpacemiT
					;;
			esac
			;;
		*)
			case ${GuessedSoC} in
				*S928X*)
					PrintBSPWarning Amlogic
					;;
			esac
			;;
	esac
} # CheckKernelVersion

PrintBSPWarning() {
	echo -e "${BSPDisclaimer}"
	case $1 in
		Allwinner)
			echo -e "${BOLD}This device runs an $1 vendor/BSP kernel.${NC}\n"
			echo -e "${BOLD}This kernel has been forward ported since ages based on unknown sources. While${NC}"
			echo -e "${BOLD}the version string suggests being a ${ShortKernelVersion} LTS release the code base differs way${NC}"
			echo -e "${BOLD}too much. Better expect tons of unfixed bugs and vulnerabilities hiding in this${NC}"
			echo -e "${BOLD}vendor kernel.${NC}"
			;;
		Amlogic)
			echo -e "${BOLD}This device runs an $1 vendor/BSP kernel.${NC}\n"
			echo -e "${BOLD}This kernel has been forward ported since ages based on unknown sources. While${NC}"
			echo -e "${BOLD}the version string suggests being a ${ShortKernelVersion} LTS release the code base differs way${NC}"
			echo -e "${BOLD}too much. Better expect tons of unfixed bugs and vulnerabilities hiding in this${NC}"
			echo -e "${BOLD}vendor kernel. See https://tinyurl.com/y8k3af73 and https://tinyurl.com/ywtfec7n${NC}"
			echo -e "${BOLD}for details.${NC}"
			;;
		Ingenic|Kendryte|MediaTek|Nexell|Nvidia|NXP|Phytium|Qualcomm|RealTek|Samsung|SpacemiT|StarFive|Synaptics|T-Head|Unisoc)
			echo -e "${BOLD}This device runs a $1 vendor/BSP kernel.${NC}"
			;;
		Rockchip)
			echo -e "${BOLD}This device runs a forward ported $1 vendor/BSP kernel.${NC}"
			;;
		RockchipGKI)
			echo -e "${BOLD}This device runs a Rockchip vendor/BSP kernel.${NC}\n"
			echo -e "${BOLD}This kernel is based on a mixture of Android GKI and other sources. Also some${NC}"
			echo -e "${BOLD}community attempts to do version string cosmetics might have happened, see${NC}"
			echo -e "${BOLD}https://tinyurl.com/2p8fuubd for example. To examine how far away this ${KernelVersionDigitsOnly}${NC}"
			echo -e "${BOLD}is from an official LTS of same version someone would have to reapply Rockchip's${NC}"
			echo -e "${BOLD}thousands of patches to a clean ${KernelVersionDigitsOnly} LTS.${NC}"
			;;
		*)
			echo -e "${BOLD}This device runs an unknown vendor/BSP/Android kernel.${NC}"
			;;
	esac
} # PrintBSPWarning

PrintKernelInfo() {
	# Kernel info: version number and vendor/BSP check
	CreateTempDir
	trap 'rm -rf "${TempDir}" ; exit 0' 0
	curl -s -q --connect-timeout 10 https://raw.githubusercontent.com/endoflife-date/endoflife.date/master/products/linuxkernel.md \
		>"${TempDir}/linuxkernel.md"
	BasicSetup nochange >/dev/null 2>&1
	KernelVersion="$(uname -r)"
	ShortKernelVersion="$(awk -F"." '{print $1"."$2}' <<<"${KernelVersion}")"
	[ -z "${DTCompatible}" ] && [ -r /proc/device-tree/compatible ] && DTCompatible="$(tr "\000" "\n" </proc/device-tree/compatible 2>/dev/null)"
	[ -z "${LSCPU}" ] && LSCPU="$(lscpu)"
	[ -z "${CPUArchitecture}" ] && CPUArchitecture="$(awk -F" " '/^Architecture/ {print $2}' <<<"${LSCPU}")"
	[ -z "${VoltageSensor}" ] && VoltageSensor="$(GetVoltageSensor)"
	[ -z "${CPUTopology}" ] && CPUTopology="$(PrintCPUTopology)"
	[ -z "${CPUSignature}" ] && CPUSignature="$(GetCPUSignature)"
	[ -z "${X86CPUName}" ] && X86CPUName="$(sed 's/ \{1,\}/ /g' <<<"${LSCPU}" | awk -F": " '/^Model name/ {print $2}' | sed -e 's/1.th Gen //' -e 's/.th Gen //' -e 's/Core(TM) //' -e 's/ Processor//' -e 's/Intel(R) Xeon(R) CPU //' -e 's/Intel(R) //' -e 's/(R)//' -e 's/CPU //' -e 's/ 0 @/ @/' -e 's/AMD //' -e 's/Authentic //' -e 's/ with .*//')"
	[ "${CPUArchitecture}" = "x86_64" ] || GuessedSoC="$(GuessARMSoC)"
	KernelInfo="$(CheckKernelVersion "${KernelVersion}")"
	if [ -z "${KernelInfo}" ]; then
		if [ "${CPUArchitecture}" = "x86_64" ]; then
			echo -e "This tool does not yet implement distro kernel checks"
		else
			uname -a
		fi
	else
		echo -e "$(uname -a)\n\n${KernelInfo}"
	fi
	echo ""
} # PrintKernelInfo

GetASPMSettings() {
	case "${1}" in
		*"ASPM L1 Enabled"*)
			ASPMSettings="$(awk -F':\t' '/LnkCtl:/ {print $2}' <<<"${PCIeDetails}")"
			case "${1}" in
				*L1SubCap*)
					ASPMSettings="${ASPMSettings}$(grep -A1 L1SubCap <<<"${PCIeDetails}" | grep -v "L1SubCtl1" | sed  -e 's/L1SubCap://'  -e 's/\t//g' | tr '\n' ' ' | sed 's/ \{1,\}/ /g')"
					ASPMSettings="${ASPMSettings}$(grep -A1 L1SubCtl1 <<<"${PCIeDetails}" | grep -v "L1SubCtl2" | sed  -e 's/L1SubCtl1://'  -e 's/\t//g' | tr '\n' ' ' | sed 's/ \{1,\}/ /g')"
					ASPMSettings="${ASPMSettings}$(grep L1SubCtl2 <<<"${PCIeDetails}" | sed  -e 's/L1SubCtl2://'  -e 's/\t//g' | tr '\n' ' ' | sed 's/ \{1,\}/ /g')"
					;;
			esac
			;;
		*)
			ASPMSettings="ASPM Disabled"
			;;
	esac
	echo "${ASPMSettings}"
} # GetASPMSettings

CheckPCIe() {
	# Examine devices on the PCI buses. Report link width/speed and whether those are
	# downgraded or not. With NVMe devices try to query SMART data to report drive health,
	# with other PCIe devices report driver (for example to spot the 'famous' RealTek NIC
	# performance issues that go away once the appropriate driver is loaded)
	#
	# TODO: print RTL8111 revision based on lspci output since everything prior to G sucks:
	# http://tinyurl.com/3jcashvt
	#
	# rev 01 -> RTL8111C
	# rev 03 -> RTL8111D
	# rev 06 -> RTL8111E
	# rev 07 -> RTL8111F
	# rev 0a -> ?
	# rev 0c -> RTL8111G
	# rev 15 -> RTL8111H
	#
	# If $1 is "nvme" then try to update smartmontools device database if needed and report
	# also NVMe devices found on the PCIe buses

	# use colours and bold when outputting to a terminal
	[ -z "${BOLD}" ] && CheckTerminal

	[ -b /dev/nvme0 ] && [ "$1" = "nvme" ] && { update-smart-drivedb >/dev/null 2>&1 ; [ -z "${TempDir}" ] && CreateTempDir ; }

	# grab info about block devices
	[ -z "${LSBLK}" ] && LSBLK="$(LC_ALL="C" lsblk -l -o SIZE,NAME,FSTYPE,LABEL,MOUNTPOINT 2>&1)"

	lspci -Q -mm 2>/dev/null | grep controller | while read ; do
		unset DeviceWarning DevizeSize AdditionalInfo AdditionalSMARTInfo RawDiskTemp DriveTemp PercentageUsed
		BusAddress="$(awk -F" " '{print $1}' <<<"${REPLY}")"
		ControllerType="$(awk -F'"' '{print $2}' <<<"${REPLY}")"
		case "${ControllerType}" in
			"Encryption"*|"VGA compatible"*|"Serial bus"*|"Communication"*|"Signal processing"*|"Memory"*)
				# ignore since internal mainboard components
				:
				;;
			*)
				# check device
				DeviceName="$(sed 's/Advanced Micro Devices,/AMD/' <<<"${REPLY}" | awk -F'"' '{print $4}' | cut -f1 -d' ') $(awk -F'"' '{print $6}' <<<"${REPLY}" | sed -e 's/ SSD//' -e 's/ Controller//')"
				PCIeDetails="$(lspci -vv -s "${BusAddress}" 2>/dev/null)"
				LnkSta="$(awk -F"\t" '/LnkSta:/ {print $4}' <<<"${PCIeDetails}" | awk -F", " '{print $1", "$2}' | head -n1)"
				if [ "X${LnkSta}" != "X" ]; then
					# only report devices for which a link state can be determined
					if [ "X${ControllerType}" = "XNon-Volatile memory controller" ]; then
						# only report NVMe devices when $1 is nvme
						ASPMSettings="$(GetASPMSettings "${PCIeDetails}")"
						if [ "$1" = "nvme" ]; then
							# omit driver information since it's nvme anyway
							unset AdditionalInfo
							# try to get nvme device node to query drive model by SMART
							PathGuess="$(ls /dev/disk/by-path/*${BusAddress}-nvme-1)"
							if [ -h "${PathGuess}" ]; then
								# try to query via SMART
								NVMeDevice="$(readlink "${PathGuess}")"
								CheckSMARTData "/dev/${NVMeDevice##*/}" nvme
								DevizeSize="$(GetDiskSize "/dev/${NVMeDevice##*/}" "${DeviceName}")"
								if [ "X${DeviceWarning}" = "XTRUE" ]; then
									echo -e "smartctl -x /dev/${NVMeDevice##*/} ; \c" >>"${TempDir}/check-smart"
									echo -e "  * ${LRED}${DevizeSize}${DeviceName}: ${LnkSta}${AdditionalSMARTInfo}${AdditionalInfo}${DriveTemp}, ${ASPMSettings}${NC}"
								else
									echo -e "  * ${DevizeSize}${DeviceName}: ${LnkSta}${AdditionalSMARTInfo}${AdditionalInfo}${DriveTemp}, ${ASPMSettings}"
								fi
							fi
						fi
					else
						AdditionalInfo=", driver in use: $(awk -F": " '/Kernel driver in use:/ {print $2}' <<<"${PCIeDetails}" | head -n1)"
						echo -e "  * ${DeviceName}: ${LnkSta}${AdditionalInfo}, ${ASPMSettings}"
					fi
				fi
				;;
		esac
	done
} # CheckPCIe

CheckStorage() {
	# examine storage devices of these patterns: /dev/sd?, /dev/mmcblk? and /dev/mtd?
	# With the more sophisticated ones (USB and SATA) try to report as much connection details
	# as possible (e.g. USB/SATA speed, whether speed downgrades have happened, usb-storage
	# vs. uas and so on)
	#
	# TODO:
	# * maybe overtake CheckSMARTModes code from armbianmonitor to query picky/old USB
	#   bridges in all possible ways.

	# use colours and bold when outputting to a terminal
	[ -z "${BOLD}" ] && CheckTerminal

	[ -z "${TempDir}" ] && CreateTempDir

	# try to update SMART drive database if SMART capable devices exist and $1 is set to
	# update-smart-drivedb
	[ -b /dev/nvme0 ] || [ -b /dev/sda ] && [ "$1" = "update-smart-drivedb" ] && update-smart-drivedb >/dev/null 2>&1

	# try to restrict SMART queries to 15 sec duration due to buggy USB-to-SATA bridges
	SmartCtl="$(command -v smartctl 2>/dev/null)"
	command -v timeout >/dev/null 2>&1 && SmartCtl="timeout 15 ${SmartCtl}"

	# grab info about block devices
	udevadm settle
	[ -z "${LSBLK}" ] && LSBLK="$(LC_ALL="C" lsblk -l -o SIZE,NAME,FSTYPE,LABEL,MOUNTPOINT 2>&1)"

	for StorageDevice in $(ls /dev/sd? /dev/nvme? /dev/vd? 2>/dev/null | sort) ; do
		unset DeviceName DeviceInfo DeviceWarning DevizeSize AdditionalInfo AdditionalSMARTInfo ProductName VendorName SpeedInfo SupportedSpeeds RawDiskTemp DriveTemp LnkSta PercentageUsed ASPMSettings

		UdevInfo="$(udevadm info -a -n ${StorageDevice} 2>/dev/null)"
		Driver="$(awk -F'"' '/DRIVERS==/ {print $2}' <<<"${UdevInfo}" | grep -E 'uas|usb-storage|ahci|nvme|virtio-')"
		case "${Driver}" in
			ahci|ahci-*|*-ahci|sata_*|sata-*|*-sata|*pata|pata*)
				# (S)ATA attached, we need to also take care about other driver names like
				# ahci-mvebu, ahci-sunxi, sata_promise, tegra-ahci, xgene-ahci and so on
				CheckSMARTData "${StorageDevice}" ahci
				;;
			nvme)
				# NVMe, we need to determine bus address to check PCIe link width/speed
				BusAddress="$(awk -F'"' '/ATTR{address}/ {print $2}' <<<"${UdevInfo}" | head -n1)"
				PCIeDetails="$(lspci -vv -s "${BusAddress}" 2>/dev/null)"
				LnkSta="$(awk -F"\t" '/LnkSta:/ {print $4}' <<<"${PCIeDetails}" | awk -F", " '{print $1", "$2}' | head -n1)"
				ASPMSettings="$(GetASPMSettings "${PCIeDetails}")"
				[[ -n "${ASPMSettings}" ]] && ASPMSettings=", ${ASPMSettings}"
				CheckSMARTData "${StorageDevice}" "${Driver}"
				;;
			usb-storage|uas)
				# USB attached
				CheckSMARTData "${StorageDevice}" "${Driver}"

				# try to lookup device ID in usbutils' database
				idProduct="$(awk -F'"' '/ATTRS{idProduct}/ {print $2}' <<<"${UdevInfo}" | head -n1)"
				idVendor="$(awk -F'"' '/ATTRS{idVendor}/ {print $2}' <<<"${UdevInfo}" | head -n1)"
				USBBus="$(awk -F'"' '/ATTRS{busnum}/ {print $2}' <<<"${UdevInfo}" | head -n1)"
				USBDevice="$(awk -F'"' '/ATTRS{devnum}/ {print $2}' <<<"${UdevInfo}" | head -n1)"
				LsusbInfo="$(lsusb -v -s ${USBBus}:${USBDevice} 2>/dev/null)"

				# Check device capabilities and speeds that could be negotiated to spot downgrading
				# With SuperSpeed it looks like this:
				#       Device can operate at Full Speed (12Mbps)
				#       Device can operate at High Speed (480Mbps)
				#       Device can operate at SuperSpeed (5Gbps)
				# With SuperSpeed Plus like this:
				#       Speed Attribute ID: 0 10Gb/s Symmetric RX SuperSpeedPlus
				#       Speed Attribute ID: 0 10Gb/s Symmetric TX SuperSpeedPlus
				SupportedSpeeds="$(awk -F"[()]" '/Device can operate at/ {print $2}' <<<"${LsusbInfo}" | tr '\n' ',' | sed -e 's/,/, /g' -e 's/, $//')"
				SupportedSuperSpeeds="$(awk -F": " '/Speed Attribute ID/ {print $2}' <<<"${LsusbInfo}" | cut -c3- | sort | uniq | grep -E "^10G|^20G|^40G" | tr '\n' ',' | sed -e 's/,/, /g' -e 's/, $//')"
				if [ "X${SupportedSpeeds}" != "X" ] && [ "X${SupportedSuperSpeeds}" != "X" ]; then
					SpeedInfo=" (capable of ${SupportedSpeeds}, ${SupportedSuperSpeeds})"
				elif [ "X${SupportedSpeeds}" != "X" ]; then
					SpeedInfo=" (capable of ${SupportedSpeeds})"
				fi
				ProductName="$(awk -F"${idProduct} " "/0x${idProduct} / {print \$2}" <<<"${LsusbInfo}")"
				VendorName="$(awk -F"${idVendor} " "/0x${idVendor} / {print \$2}" <<<"${LsusbInfo}" | cut -f1 -d',')"
				if [ "X${ProductName}" != "X" ] && [ "X${VendorName}" != "X" ]; then
					LsusbGuess="${VendorName} ${ProductName}"
				else
					LsusbGuess="$(lsusb -s ${USBBus}:${USBDevice} 2>/dev/null | awk -F"${idVendor}:${idProduct} " "/${idVendor}:${idProduct} / {print \$2}")"
				fi

				NegotiatedSpeed="$(awk -F'"' '/ATTRS{speed}/ {print $2}' <<<"${UdevInfo}" | head -n1)"
				if [ "X${DeviceName}" = "X${DeviceToCheck}" ]; then
					# no SMART support or SMART query failed, we need to find a fallback name
					if [ "X${LsusbGuess}" != "X" ]; then
						# Seems like a legit string, so use usbutils database but doublecheck
						# against our exception list first to avoid lengthy or wrong names
						BetterNameAvailable="$(GetUSBSataBridgeName "${idVendor}" "${idProduct}" "${LsusbGuess}")"
							if [ "X${BetterNameAvailable}" = "X" ]; then
								DeviceName="\"${LsusbGuess}\" as ${StorageDevice}"
							else
								DeviceName="\"${BetterNameAvailable}\" as ${StorageDevice}"
							fi
					else
						# try to construct device name from ATTRS{vendor}+ATTRS{model} udev info
						DeviceVendor="$(awk -F'"' '/ATTRS{vendor}/ {print $2}' <<<"${UdevInfo}" | awk '{$1=$1};1')"
						if [ "X${DeviceVendor}" != "X" ]; then
							DeviceName="\"${DeviceVendor} $(awk -F'"' '/ATTRS{model}/ {print $2}' <<<"${UdevInfo}" | awk '{$1=$1};1')\" as ${StorageDevice}"
						else
							DeviceName="[unknown device] as ${StorageDevice}"
						fi
					fi
					DeviceInfo="USB"
				else
					# SMART data has been found, now try to determine bridge chip in between
					# disk and USB host controller
					case "${idVendor}:${idProduct}" in
						:)
							# no IDs found, generic report
							DeviceInfo="behind USB"
							;;
						152d*|174c*|2109*|0bda*|1058:0a10)
							# USB-to-SATA bridge vendors: JMicron, ASMedia, VIA Labs, Realtek
							BetterNameAvailable="$(GetUSBSataBridgeName "${idVendor}" "${idProduct}" "${LsusbGuess}")"
							if [ "X${BetterNameAvailable}" = "X" ]; then
								DeviceInfo="behind \"${LsusbGuess}\" (${idVendor}:${idProduct})"
							else
								DeviceInfo="behind ${BetterNameAvailable} (${idVendor}:${idProduct})"
							fi
							;;
						0bc2*|1058*|04e8*|0781*|0930*|0fce*|054c*|0411*|17ef*|07ab*|0718*|2009*|18a5*)
							# vendor IDs of disk manufacturers that use USB SATA bridges with
							# branded firmwares like Seagate, WD, Samsung, SanDisk, Toshiba,
							# Sony, Buffalo, Lenovo, Freecom, Imation, iStorage, Verbatim
							DeviceInfo="in \"${LsusbGuess}\" (${idVendor}:${idProduct})"
							;;
						*)
							DeviceInfo="behind \"${LsusbGuess}\" (${idVendor}:${idProduct})"
							;;
					esac
				fi
				AdditionalInfo=", Driver=${Driver}, ${NegotiatedSpeed}Mbps${SpeedInfo}${AdditionalInfo}"
				;;
			virtio-*)
				# virtual disk
				DeviceName="Virtual disk"
				AdditionalInfo="${StorageDevice}, Driver=${Driver}"
				;;
		esac

		DevizeSize="$(GetDiskSize "${StorageDevice}" "${DeviceName}")"
		if [ "X${DeviceWarning}" = "XTRUE" ]; then
			echo -e "smartctl -x ${StorageDevice} ; \c" >>"${TempDir}/check-smart"
			echo -e "  * ${LRED}${DevizeSize}${DeviceName%%*( )}: ${DeviceInfo}${LnkSta}${AdditionalSMARTInfo}${AdditionalInfo}${DriveTemp}${ASPMSettings}${NC}"
		else
			echo -e "  * ${DevizeSize}${DeviceName%%*( )}: ${DeviceInfo}${LnkSta}${AdditionalSMARTInfo}${AdditionalInfo}${DriveTemp}${ASPMSettings}"
		fi
		[ -n "${LetsBenchmark}" ] && snore 0.1 && echo -e "    \c" >&2 && GetBenchmarkPartition "${StorageDevice}" 600000 >&2
	done

	# MMC devices
	for StorageDevice in /dev/mmcblk? ; do
		[[ -e "${StorageDevice}" ]] || break
		unset DeviceName DeviceInfo DeviceWarning DevizeSize DeviceType DmesgInfo AdditionalInfo CountOfProblems TuningProblems Manufacturer
		if [ -x /sys/block/${StorageDevice##*/}/device ]; then
			cd /sys/block/${StorageDevice##*/}/device || return 1
			# read in variables from sysfs in q&d style and prefix them all with "mmc_".
			# We rely here on the kernel version being recent enough to decode CIS and CSD
			# correctly. Should be double checked against https://tinyurl.com/29c8393f or
			# https://gurumeditation.org/1342/sd-memory-card-register-decoder/
			#
			# Looks like this for example: https://gist.github.com/ThomasKaiser/97770ef60a94e19df3c270506209e70f

			declare mmc_serial mmc_manfid mmc_oemid mmc_date mmc_type mmc_hwrev mmc_fwrev
			eval $(grep . * 2>/dev/null | grep -v uevent | sed -e 's/:/=/' -e 's/^/mmc_/' -e 's/\ //g')

			# Rely on human readable real storage sizes and not marketing 'sizes':
			# e.g. show 29.7GB for a '32GB' card:
			mmc_size=$(awk -F" " "/ ${StorageDevice##*/} / {print \$1}" <<<"${LSBLK}")
			[ "X${mmc_size}" != "X" ] && FlashSize="${mmc_size}B "

			# check serial number since low serial numbers are suspicious, might be overriden
			# one step later since some OEM cards (AData, Phison) seem to use low serial numbers.
			# https://github.com/ThomasKaiser/sbc-bench/blob/master/results/SD-cards-with-low-serial-numbers.md
			case "${mmc_serial}" in
				0x0000*)
					# probable fake card
					Manufacturer="Probable counterfeit "
					;;
			esac

			# Only add manufacturer info if really unique. Partially misleading since counterfeit
			# cards were and still are an issue: https://www.bunniestudios.com/blog/?page_id=1022
			# Also newer manfids (based on JEDEC vendor IDs) are broken by design: https://archive.ph/x2kpx
			case "${mmc_manfid}/${mmc_oemid}" in
				0x0000df/0x0118)
					# Despite the weird 0x0000df manufacturer ID this seems to be a legit soldered
					# 128GB eMMC used in e.g. GoWin R86S and MeLE Quieter3C
					:
					;;
				0x000000*|0x0000ff/0x0000|0x00006f/0x0013|0x000025/0x1708|0x0000df*|0x0000fe/0x3456)
					# counterfeit card
					Manufacturer="Definite counterfeit "
					DeviceWarning=TRUE
					;;
				0x000001*)
					Manufacturer="${Manufacturer}Panasonic "
					;;
				0x000002/0x544d)
					# 0x544d -> "TM"
					Manufacturer="${Manufacturer}Toshiba "
					;;
				0x000003/0x5344|0x000003/0x5744)
					# 0x5344 -> "SD", 0x5744 -> "WD" (Western Digital owning the SanDisk brand since 2016)
					Manufacturer="${Manufacturer}SanDisk "
					;;
				0x000008*)
					Manufacturer="${Manufacturer}Silicon Power "
					;;
				0x000012/0x3456)
					# 0x3456 -> "4V", used by at least the following brands: EssentielB, Extrememory,
					# fake Kingston: https://www.bunniestudios.com/blog/?page_id=1022
					# show up with very low serial numbers as "ASTC", "SD" or "F0F0", fake
					Manufacturer="Definite counterfeit "
					DeviceWarning=TRUE
					;;
				0x000012/0x5678)
					# 0x5678 -> "Vx", show up with very low serial numbers as "ASTC", "MS", fake
					Manufacturer="Definite counterfeit "
					DeviceWarning=TRUE
					;;
				0x000012*)
					# fake Samsung PRO Endurance: https://tinyurl.com/ytd8hmka
					# this manufacturer ID is definitely a counterfeit indicator
					Manufacturer="Definite counterfeit "
					DeviceWarning=TRUE
					;;
				0x000018*)
					Manufacturer="${Manufacturer}Infineon "
					;;
				0x000015/0x0100|0x00001b/0x534d|0x0000ce*)
					# 0x534d -> "SM"
					if [ "X${mmc_name}" = "X00000" ]; then
						# erase mmc_name if 00000 since Samsung SD cards all use this non-descriptive
						# string that's also used by scammers (Samsung eMMC though uses descriptive names)
						Manufacturer="${Manufacturer}Samsung"
						mmc_name=""
					else
						Manufacturer="${Manufacturer}Samsung "
					fi
					;;
				0x00001d/0x4144)
					# 0x4144 -> "AD"
					Manufacturer="AData "
					;;
				0x00001d*)
					Manufacturer="${Manufacturer}Corsair "
					;;
				0x000027/0x5048)
					# 0x5048 -> "PH", used by at least the following brands: AgfaPhoto, Delkin, Intenso, Integral, Lexar, Patriot, PNY, Polaroid, Sony, Verbatim
					Manufacturer="Phison "
					;;
				0x000028/0x4245)
					# 0x4245 -> "BE", used by at least the following brands: Lexar, PNY, ProGrade
					Manufacturer="${Manufacturer}Lexar "
					;;
				0x000041/0x3432|0x000070/0x0100)
					# 0x3432 -> "42"
					Manufacturer="${Manufacturer}Kingston "
					;;
				*/0x3432)
					# 0x3432 -> "42" but differing manfid from Kingston's
					Manufacturer="Definite counterfeit "
					DeviceWarning=TRUE
					;;
				0x000045*)
					Manufacturer="${Manufacturer}SanDisk/Toshiba "
					;;
				0x000073/0x4247)
					# 0x4247 -> "BG", used by at least the following brands: Fugi, Hama, V-Gen
					:
					;;
				0x000074/0x4a45)
					# 0x4a45 -> "JE"
					case ${mmc_date} in
						*200*|*2010|*2011|*2012)
							# low serial number is fine dating back then
							Manufacturer="Transcend "
							;;
						*)
							Manufacturer="${Manufacturer}Transcend "
							;;
					esac
					;;
				0x000074/0x4a60)
					# 0x4a60 -> "J`", combination used with some cards showing low serial numbers,
					# bogus names like 00000/ASTC or name/capacity mismatch: SD16G with 7.44 GiB
					Manufacturer="${Manufacturer}Transcend "
					;;
				0x000082/0x4a54)
					# 0x4a54 -> "JT"
					Manufacturer="${Manufacturer}Sony "
					;;
				0x000084/0x5446)
					# 0x5446 -> "TF", http://strontium.biz/products/memory-cards/mobile-memory-cards/#seven
					:
					;;
				0x000088/0x0103|0x0000d6/0x0103|0x0000d6/0x2903)
					Manufacturer="${Manufacturer}Foresee "
					;;
				0x00009b/0x0100)
					# https://en.wikipedia.org/wiki/Yangtze_Memory_Technologies
					Manufacturer="${Manufacturer}YMTC "
					;;
				0x00009f/0x5449)
					# 0x5449 -> "TI", found with maybe counterfeit Kingston SDC10G2 (name:SD16G): https://wiki.kobol.io/helios4/sdcard/#kingston-mobile-card-microsdhc-16gb
					# or as "Kingston Canvas Select Plus, SDCS2/32GB" "SD32G", date 10/2020, hw/fw rev: 0x6/0x1
					Manufacturer="${Manufacturer}Texas Instruments "
					;;
				0x0000ad*|0x000090/0x014a)
					Manufacturer="${Manufacturer}SK Hynix "
					;;
				0x0000ea/0x010e)
					Manufacturer="${Manufacturer}SiliconGo "
					;;
				0x0000fe*)
					Manufacturer="${Manufacturer}Micron-Numonyx "
					;;
			esac

			# check certain fraud criteria again to switch from 'Probable counterfeit' (low
			# serial number) to 'Definite counterfeit'
			if [ "${mmc_serial}" = "0x00000000" ] || [ "X${mmc_name}" = "X00000" ] || [ "X${mmc_name}" = "XSMI" ] || [ "X${mmc_name}" = "XASTC" ] || [ "X${mmc_name}" = "XAS" ]; then
				Manufacturer="Definite counterfeit "
				DeviceWarning=TRUE
			fi

			# check dmesg output to gather further info like negotiation problems and errors.
			MMCNode="$(grep "] ${StorageDevice##*/}: " <<<"${DMESG}" | grep "iB" | awk -F":" "/ ${mmc_name} / {print \$2}" | head -n1)"
			if [ "X${MMCNode}" != "X" ]; then
				DmesgInfo="$(awk -F' new ' "/]${MMCNode}: new/ {print \$2}" <<<"${DMESG}" | awk -F' at ' '{print $1}' | tail -n1)"
				CountOfProblems=$(grep "]${MMCNode}: " <<<"${DMESG}" | grep -c error)
				TuningProblems=$(grep -c "]${MMCNode}: tuning execution failed" <<<"${DMESG}")
				if [ ${CountOfProblems} -gt 0 ] && [ ${TuningProblems} -gt 0 ]; then
					AdditionalInfo=" (speed negotiation problems and errors, check dmesg)"
					DeviceWarning=TRUE
				elif [ ${CountOfProblems} -gt 0 ] && [ ${TuningProblems} -eq 0 ]; then
					AdditionalInfo=" (various errors occured, check dmesg)"
					DeviceWarning=TRUE
				elif [ ${CountOfProblems} -eq 0 ] && [ ${TuningProblems} -gt 0 ]; then
					AdditionalInfo=" (speed negotiation problems, check dmesg)"
					DeviceWarning=TRUE
				fi
			fi

			case "${mmc_type}" in
				SD)
					DeviceType="$(sed -e 's/ultra /U/' -e 's/high speed/HS/' -e 's/SDHC /SD /' <<<"${DmesgInfo:-SDHC card}")"
					;;
				MMC)
					# try to query additional info via mmc-utils (for now only MMC version)
					ExtendedInfo="$(mmc extcsd read ${StorageDevice} 2>/dev/null)"
					grep -q "Extended CSD rev" <<<"${ExtendedInfo}" && MMCVersion="$(awk -F"[()]" '/Extended CSD rev/ {print $2}' <<<"${ExtendedInfo}")"
					DeviceType="$(sed "s/MMC/e${MMCVersion:-MMC}/" <<<"${DmesgInfo:-MMC}")"
					;;
			esac

			if [ "X${DeviceWarning}" = "XTRUE" ]; then
				echo -e "  * ${LRED}${FlashSize}\"${Manufacturer}${mmc_name}\" ${DeviceType}${AdditionalInfo} as ${StorageDevice}: date ${mmc_date}, manfid/oemid: ${mmc_manfid}/${mmc_oemid}, hw/fw rev: ${mmc_hwrev}/${mmc_fwrev}${NC}"
			else
				echo -e "  * ${FlashSize}\"${Manufacturer}${mmc_name}\" ${DeviceType}${AdditionalInfo} as ${StorageDevice}: date ${mmc_date}, manfid/oemid: ${mmc_manfid}/${mmc_oemid}, hw/fw rev: ${mmc_hwrev}/${mmc_fwrev}"
			fi
		fi
		[ -n "${LetsBenchmark}" ] && snore 0.1 && echo -e "    \c" >&2 && GetBenchmarkPartition "${StorageDevice}" 120000 >&2
	done

	# MTD devices: partitions appear as single mtd devices so different logic is needed
	# to deal with devices

	MTDDevices="$(CheckMTD)"
	echo -n "${MTDDevices}" | cut -f1 -d'|' | sort | uniq | sed '/^$/d' | while read ; do
		unset RawSize DeviceName Driver FlashManufacturer FlashPartName
		DeviceInfo="$(grep "^${REPLY}" <<<"${MTDDevices}")"
		PartitionCount=$(wc -l <<<"${DeviceInfo}")
		case ${PartitionCount} in
			1)
				# device seems not to be partitioned, report raw size
				RawSize=$(cut -f6 -d'|' <<<"${DeviceInfo}")
				[ "X${RawSize}" != "X" ] && FlashSize="$(( ${RawSize} / 1024 ))MB "
				PartitionInfo=""
				;;
			*)
				# partitions, we report the individual partitions (label/size)
				PartitionInfo=" (${PartitionCount} partitions: $(awk -F"|" '{print $7": "$6"KB"}' <<<"${DeviceInfo}" | tr '\n' ',' | sed -e 's/,/, /g' -e 's/, $//'))"
				FlashSize=""
				;;
		esac

		Driver=$(cut -f2 -d'|' <<<"${DeviceInfo}" | head -n1)
		FlashManufacturer=$(cut -f4 -d'|' <<<"${DeviceInfo}" | head -n1)
		FlashPartName=$(cut -f5 -d'|' <<<"${DeviceInfo}" | head -n1)
		[ "X${FlashManufacturer}" != "X" ] && [ "X${FlashPartName}" != "X" ] && DeviceName="${FlashManufacturer} ${FlashPartName} "

		# Maybe TODO: parse lists like https://github.com/Ruimusume/DiM_BACKUP/blob/main/chiplist.xml to show device size
		JedecID=$(cut -f3 -d'|' <<<"${DeviceInfo}" | head -n1)

		case "${Driver}" in
			*spi-nor*)
				echo -e "  * ${DeviceName}${FlashSize}SPI NOR flash${PartitionInfo}, drivers in use: ${Driver}"
				;;
			*nand*)
				grep -q "spi" <<<"${Driver}" \
					&& echo -e "  * ${DeviceName}${FlashSize}SPI NAND flash${PartitionInfo}, drivers in use: ${Driver}" \
					|| echo -e "  * ${DeviceName}${FlashSize}NAND flash${PartitionInfo}, drivers in use: ${Driver}" \
				;;
			*)
				echo -e "  * ${DeviceName}${FlashSize}MTD device${PartitionInfo}, drivers in use: ${Driver}"
			;;
		esac
	done

	if [ -f "${TempDir}/check-smart" ]; then
		echo -e "\n\"$(sed 's/ ; $//' <"${TempDir}/check-smart")\" could be used to get further information about the reported issues."
		rm "${TempDir}/check-smart"
	fi
} # CheckStorage

GetBenchmarkPartition() {
	# function that gets a block device as $1 and minimum free blocks as $2 and returns
	# whether benchmarking in a reasonable way is possible or not and if possible prints
	# the best suited partition (e.g. on spinning rust due to ZBR outer partitions are
	# faster than inner)
	echo lalala $2
} # GetBenchmarkPartition

BenchmarkDrives() {
	# function that takes a list of suited partitions generated in review mode and
	# tests sequential and in case it's worth to check (not on spinning rust) also random
	# I/O
	# TODO: check SMART attribute 199 before/after to spot cabling problems
	:
} # BenchmarkDrives

CheckMTD() {
	for StorageDevice in /dev/mtd? ; do
		[[ -e "${StorageDevice}" ]] || break
		UdevInfo="$(udevadm info -a -n ${StorageDevice} 2>/dev/null)"
		DevicePath="$(awk -F"'" '/looking at device/ {print $2}' <<<"${UdevInfo}")"
		Driver="$(awk -F'"' '/DRIVERS==/ {print $2}' <<<"${UdevInfo}" | sed '/^$/d' | tr '\n' '/' | sed 's/\/$//')"
		JedecID="$(awk -F'"' '/\/jedec_id}==/ {print $2}' <<<"${UdevInfo}" | head -n1)"
		FlashManufacturer="$(awk -F'"' '/\/manufacturer}==/ {print $2}' <<<"${UdevInfo}" | head -n1)"
		FlashPartName="$(awk -F'"' '/\/partname}==/ {print $2}' <<<"${UdevInfo}" | head -n1)"
		RawSize=$(awk -F'"' '/ATTR{size}/ {print $2}' <<<"${UdevInfo}" | head -n1)
		[ "X${RawSize}" != "X" ] && FlashSize="$(( ${RawSize} / 1024 ))"
		DeviceLabel="$(awk -F'"' '/ATTR{name}/ {print $2}' <<<"${UdevInfo}" | head -n1)"
		echo -e "${DevicePath%/*}|${Driver}|${JedecID}|$(tr '[:lower:]' '[:upper:]' <<<"${FlashManufacturer:0:1}")${FlashManufacturer:1}|${FlashPartName^^}|${FlashSize}|${DeviceLabel}"
	done
} # CheckMTD

GetUSBSataBridgeName() {
	# function wants USB vendor and product ID as $1 and $2 and the name guessed by
	# usbutils as $3. Returns nicer and/or more correct name for the USB-to-SATA bridge
	case "${1}:${2}" in
		1058:0a10)
			# JMicron JMS56x USB-to-SATA bridge with integrated port multiplier
			# that has been flashed with Western Digital branded firmware
			DeviceInfo="JMicron JMS56x dual SATA 6Gb/s bridge"
			;;
		152d:0561)
			# Listed as "JMS551 - Sharkoon SATA QuickPort Duo"
			DeviceInfo="JMicron JMS561 dual SATA 6Gb/s bridge"
			;;
		152d:0576)
			# Listed as "JMicron Technology Corp. / JMicron USA Technology Corp. Gen1 SATA 6Gb/s Bridge"
			DeviceInfo="JMicron JMS576 SATA 6Gb/s bridge"
			;;
		152d:0578)
			# JMS578 wrongly listed as JMS567 in usbutils database, though there are some JMS567 that
			# can be flashed with a firmware that then results in them identifying as product ID 0578
			DeviceInfo="JMicron JMS578 SATA 6Gb/s bridge"
			;;
		152d:0580)
			DeviceInfo="JMicron JMS580 SATA bridge (SuperSpeed Plus / 6Gb/s)"
			;;
		152d:0581)
			# SuperSpeed Plus bridge, one of the following:
			# JMS581LT NVMe/SATA/SD7.1 bridge (SuperSpeed Plus / Gen3 x2 / 6Gb/s)
			# JMS581D NVMe/SATA bridge (SuperSpeed Plus / Gen3 x2 / 6Gb/s)
			# JMS581SD SD7.1/SD8.0 bridge (SuperSpeed Plus)
			#
			# To properly differentiate maybe bcdDevice can be used but at least to get
			# negotiated device type ATTRS{model} can be used. Reads for example 'Generic
			# SD70' with a ADATA Premier Extreme SD7.0 Express card: https://archive.md/h51hS
			unset BridgeModel
			BridgeModel="$(awk -F'"' '/ATTRS{model}/ {print $2}' <<<"${UdevInfo}" | head -n1 | tr -s ' ' | sed -e 's/\ $//' -e 's/^ //')"
			DeviceInfo="JMicron JMS581 ${BridgeModel} bridge (SuperSpeed Plus)"
			;;
		152d:0583)
			DeviceInfo="JMicron JMS583 NVMe bridge (SuperSpeed Plus / Gen3 x2)"
			;;
		152d:0586)
			DeviceInfo="JMicron JMS586 NVMe bridge (SuperSpeed Plus 20Gbps / Gen3 x2)"
			;;
		152d:0901)
			DeviceInfo="JMicron JMS901 UFS 2.1/UHS-I bridge"
			;;
		152d*)
			# JMicron bridge, let's replace the monstrous vendor string with JMicron
			DeviceInfo="$(sed 's|JMicron Technology Corp. / JMicron USA Technology Corp.|JMicron|' <<<"${3}")"
			;;
		174c:1352|174c:1356)
			DeviceInfo="ASMedia ASM1352R SATA bridge (SuperSpeed Plus / 6Gb/s)"
			;;
		174c:225c)
			DeviceInfo="ASMedia ASM225CM SATA 6Gb/s bridge"
			;;
		174c:2362)
			DeviceInfo="ASMedia ASM2362 NVMe bridge (SuperSpeed Plus / Gen3 x2)"
			;;
		174c:2364)
			DeviceInfo="ASMedia ASM2362 NVMe bridge (SuperSpeed Plus 20Gbps / Gen3 x4)"
			;;
		174c:55aa)
			# The product ID has been used by ASMedia for a bunch of different bridges and the usbutils name reads
			# 'ASMedia Technology Inc. Name: ASM1051E SATA 6Gb/s bridge, ASM1053E SATA 6Gb/s bridge, ASM1153 SATA 3Gb/s bridge, ASM1153E SATA 6Gb/s bridge'
			# ASM1153 is fine in general while the older ASM105x thingies are known to be buggy. Connected via
			# USB3 it would be possible to identify the different bridges but if they're behind USB2 then there's
			# no chance. So we live with a generic string (that isn't that long/useless as lsusb output).
			# ASM1153 is also used in many USB disks (e.g. Seagate) but with different firmware and then appears
			# not with 174c vendor ID. Same ID is also used with ASM1156 and ASM235CM so it needs to query product string
			unset ProductString
			ProductString="$(awk -F'"' '/ATTRS{product}/ {print $2}' <<<"${UdevInfo}" | head -n1 | tr -s ' ' | sed -e 's/\ $//' -e 's/^ //')"
			case "${ProductString}" in
				ASM235*)
					DeviceInfo="ASMedia ${ProductString} SATA bridge (SuperSpeed Plus / 6Gb/s)"
					;;
				ASM105*|ASM115*)
					DeviceInfo="ASMedia ${ProductString} SATA 6Gb/s bridge"
					;;
				*)
					DeviceInfo="ASMedia SATA 6Gb/s bridge"
					;;
			esac
			;;
		174c*)
			# ASMedia bridges, let's replace the monstrous vendor string with ASMedia
			DeviceInfo="$(sed 's|ASMedia Technology Inc.|ASMedia|' <<<"${3}")"
			;;
		2109:0715)
			# VIA VL715/VL716 USB to SATA bridges, appear in usbutils as
			# "VIA Labs, Inc. VLI Product String" or "VL817 SATA Adaptor"
			# while VL817 is a hub! VL715/VL716 differ by PHY (VL716 USB-C)
			# but share same product ID since otherwise identical
			DeviceInfo="VIA Labs VL715/VL716 SATA 6Gb/s bridge"
			;;
		2109:070*)
			# SATA 3Gb/s bridges: VL700/VL701
			DeviceInfo="VIA Labs VL${idProduct:1} SATA 3Gb/s bridge"
			;;
		2109:071*)
			# any of the other VIA Labs VL71* SATA 6Gb/s bridges (that may follow)
			DeviceInfo="VIA Labs VL${idProduct:1} SATA bridge (SuperSpeed Plus / 6Gb/s)"
			;;
		0bda:9210)
			# Listed as 'RTL9210 M.2 NVME Adapter' in usbutils database but the RTL9210B-CG
			# variant supports both NVMe and SATA with auto detection
			DeviceInfo="Realtek RTL9210 NVMe/SATA bridge (SuperSpeed Plus / Gen3 x2 / 6Gb/s)"
			;;
		0bda*)
			# RealTek bridges, let's replace the vendor string with Realtek
			DeviceInfo="$(sed 's|Realtek Semiconductor Corp.|Realtek|' <<<"${3}")"
			;;
	esac
	echo "${DeviceInfo}"
} # GetUSBSataBridgeName

GetDiskSize() {
	# $1 device node
	# $2 Device name obtained using SMART or usbutils
	#
	# returns an empty string if device name seems to consist of the capacity already
	# (e.g. "Model Number: KXG50ZNV256G NVMe TOSHIBA 256GB") or the capacity reported
	# by lsblk if lsblk lists the device

	local disksize
	grep -q " ${1##*/}" <<<"${LSBLK}" || return
	disksize=$(awk -F" " "/ ${1##*/}/ {print \$1}" <<<"${LSBLK}" | head -n1)
	# return disk size only if not '0B'
	[ "X${disksize}" != "X0B" ] && echo "${disksize}B "
} # GetDiskSize

CheckSMARTData() {
	DeviceToCheck="$1"
	LinuxDriver="$2"
	SMARTInfo="$(${SmartCtl} -i ${DeviceToCheck} 2>/dev/null)"
	unset PercentageUsed DeviceWarning

	# do nothing if $SMARTInfo either contains 'No Information Found' or no disk name
	grep -q "No Information Found" <<<"${SMARTInfo}" && return
	grep -E -q "Device Model:|Model Number:" <<<"${SMARTInfo}"
	if [ $? -eq 0 ]; then
		# use SMART data, we need to differentiate by Linux driver (ahci, nvme, uas, usb-storage)
		case "${LinuxDriver}" in
			ahci)
				# native SATA
				Protocol="ATA"
				DeviceAddition=""
				;;
			nvme)
				# directly PCIe accessible NVMe
				Protocol="NVMe"
				DeviceAddition=""
				;;
			usb-storage|uas)
				# USB attached, so we need to see what's behind the bridge chip
				grep -E -q "Device Model:" <<<"${SMARTInfo}"
				case $? in
					0)
						# SATA behind an USB-to-SATA bridge
						Protocol="ATA"
						DeviceAddition=" [SATA]"
						;;
					*)
						# USB-to-NVMe bridge remains then
						Protocol="NVMe"
						DeviceAddition=" [NVMe]"
						;;
				esac
				;;
		esac

		case ${Protocol} in
			NVMe)
				# we can use the standardized NVMe SMART attributes, use old text based
				# output since JSON works only since smartmontools 7.x
				SMARTData="$(${SmartCtl} -a ${DeviceToCheck} 2>/dev/null)"
				DeviceName="\"$(awk -F": " "/^Model Number:/ {print \$2}" <<<"${SMARTData}" | sed 's/^ *//g')\" SSD as ${DeviceToCheck}${DeviceAddition}"
				PercentageUsed="$(awk -F": " "/^Percentage Used:/ {print \$2}" <<<"${SMARTData}" | sed -e 's/^ *//g' -e 's/%//')"

				if [ ${PercentageUsed:-0} -gt 75 ]; then
					AdditionalSMARTInfo="${AdditionalSMARTInfo}, ${BOLD}${PercentageUsed}% worn out${NC}${LRED}"
				else
					AdditionalSMARTInfo="${AdditionalSMARTInfo}, ${PercentageUsed}% worn out"
				fi
				MediaErrors=$(awk -F": " "/^Media and Data Integrity Errors:/ {print \$2}" <<<"${SMARTData}" | sed 's/^ *//g')
				[ ${MediaErrors:-0} -gt 0 ] && AdditionalSMARTInfo="${AdditionalSMARTInfo}, ${BOLD}${MediaErrors} media errors${NC}${LRED}"
				ErrorLogEntries=$(awk -F": " "/^Error Information Log Entries:/ {print \$2}" <<<"${SMARTData}" | sed 's/^ *//g')
				if [ ${ErrorLogEntries:-0} -gt 0 ]; then
					AdditionalSMARTInfo="${AdditionalSMARTInfo}, ${BOLD}${ErrorLogEntries} error log entries${NC}${LRED}"
					grep -q "/dev/nvme" <<<"${DeviceToCheck}" && echo -e "nvme error-log ${DeviceToCheck} ; \c" >>"${TempDir}/check-smart"
				fi
				RawDiskTemp="$(awk -F": " "/^Temperature:/ {print \$2}" <<<"${SMARTData}" | sed 's/^ *//g' | cut -f1 -d' ')"
				TempTreshold=60
				if [ "X${RawDiskTemp}" != "X" ]; then
					if [ ${RawDiskTemp} -gt ${TempTreshold} ]; then
						DeviceWarning=TRUE
						DriveTemp=", ${BOLD}unhealthy drive temp: ${RawDiskTemp}°C${NC}"
					else
						DriveTemp=", drive temp: ${RawDiskTemp}°C"
					fi
				fi
				Health="$(awk -F": " '/overall-health self-assessment test result/ {print $2}' <<<"${SMARTData}")"
				if [ "X${Health}" != "XPASSED" ]; then
					AdditionalSMARTInfo="${AdditionalSMARTInfo}, ${BOLD}SMART health: **FAILED**${NC}${LRED}"
					DeviceWarning=TRUE
				fi
				if [ ${PercentageUsed:-0} -gt 75 ] || [ ${MediaErrors:-0} -gt 0 ] || [ ${ErrorLogEntries:-0} -gt 0 ]; then
					DeviceWarning=TRUE
				fi
				;;
			ATA)
				# it gets complicated since we need to deal with vendor specific attributes
				# and need to differentiate between spinning rust and SSDs :(
				SMARTData="$(${SmartCtl} -a ${DeviceToCheck})"

				# Check for available firmware upgrades
				grep -q -A5 "A firmware update for this drive may be available" <<<"${SMARTData}"
				if [ $? -eq 0 ]; then
					FWUpdateURLs="$(grep -A5 "A firmware update for this drive may be available" <<<"${SMARTData}" | grep http | tr '\n' ' ' | sed 's/\ $//')"
					FWVersion="$(awk -F": " '/Firmware Version:/ {print $2}' <<<"${SMARTData}" | sed 's/^ *//g')"
					AdditionalSMARTInfo="${AdditionalSMARTInfo}, firmware version ${FWVersion}, updates may be available: ${FWUpdateURLs}"
				fi

				# Check for CRC errors. Usually caused by bad cables or jack contacts,
				# goes along with retransmits and as such harms performance. Beware that
				# this attribute records these issues over the drive's lifetime as such
				# it's only an issue when the CRC error counter increases while accessing
				# the drive
				CRCErrors="$(awk -F": " '/^199 / {print $10}' <<<"${SMARTData}")"
				[ ${CRCErrors:-0} -gt 0 ] && AdditionalSMARTInfo=", ${BOLD}${CRCErrors} CRC errors${NC}${LRED}"

				SATAVersion="$(awk -F": " '/^SATA Version is/ {print $2": "$3}' <<<"${SMARTData}" | sed -e 's/^ *//g' -e 's/: $//')"
				if [ "X${SATAVersion}" = "X: " ]; then
					DeviceInfo="SATA"
				else
					DeviceInfo="${SATAVersion}"
					[ "X${DeviceAddition}" != "X" ] && DeviceAddition="$(echo "${DeviceAddition}" | sed "s|SATA|${SATAVersion}|")"
				fi

				# differentiate between HDDs and SSDs
				RotationRate="$(awk -F": " '/^Rotation Rate/ {print $2}' <<<"${SMARTData}")"
				case "${RotationRate}" in
					*"Solid State Device"*)
						# SSD
						DriveType="SSD"
						TempTreshold=60

						# Dealing with custom vendor attributes is unreliable by definition,
						# so let's try ATA Device Statistics first
						SMARTDevstat="$(${SmartCtl} -l devstat ${DeviceToCheck})"
						PercentageUsed="$(awk -F" " '/Percentage Used Endurance Indicator/ {print $4}' <<<"${SMARTDevstat}")"
						if [ "X${PercentageUsed}" != "X" ]; then
							# use 'Percentage Used Endurance Indicator'
							if [ ${PercentageUsed:-0} -gt 75 ]; then
								AdditionalSMARTInfo="${AdditionalSMARTInfo}, ${BOLD}${PercentageUsed}% worn out${NC}${LRED}"
							else
								AdditionalSMARTInfo="${AdditionalSMARTInfo}, ${PercentageUsed}% worn out"
							fi
						else
							# not compliant with ATA Device Statistics so try to deal with the vendor
							# attributes if in good mood sometimes in the future, for now only caring
							# about 169, 177 and 202

							# Silicon Motion based SSDs / CT500BX100SSD1: 169, raw value decreasing from 100 to 0
							# 169 Remaining_Lifetime_Perc 0x0000   100   100   000    Old_age   Offline      -       78
							[ -z "${SMARTValue}" ] && SMARTValue="$(awk -F" " '/^169 / {print $10}' <<<"${SMARTData}" | sed 's/^0*//')"

							# Samsung SSDs that don't support ATA Device Statistics, normalized value decreasing from 100 to 0
							# 177 Wear_Leveling_Count     0x0013   095   095   000    Pre-fail  Always       -       57
							[ -z "${SMARTValue}" ] && SMARTValue="$(awk -F" " '/^177 / {print $4}' <<<"${SMARTData}" | sed 's/^0*//')"

							# Crucial SSDs not relying on Silicon Motion controllers, normalized value decreasing from 100 to 0
							# 202 Percent_Lifetime_Remain 0x0030   092   092   001    Old_age   Offline      -       8
							[ -z "${SMARTValue}" ] && SMARTValue="$(awk -F" " '/^202 / {print $4}' <<<"${SMARTData}" | sed 's/^0*//')"

							# WD/SanDisk use 230
							# 230 Media_Wearout_Indicator 0x0032   017   017   ---    Old_age   Always       -       0x11570e001157
							# depends on drive's firmware version how values have to be interpreted,
							# as such unreliable by definition:
							# https://listi.jpberlin.de/pipermail/smartmontools-support/2021-February/000580.html

							if [ ${SMARTValue:-101} -lt 101 ]; then
								PercentageUsed=$(( 100 - ${SMARTValue} ))
								if [ ${PercentageUsed:-0} -gt 75 ]; then
									AdditionalSMARTInfo="${AdditionalSMARTInfo}, ${BOLD}${PercentageUsed}% worn out${NC}${LRED}"
								else
									AdditionalSMARTInfo="${AdditionalSMARTInfo}, ${PercentageUsed}% worn out"
								fi
							fi
						fi
						;;
					*)
						# HDD, check for the most common fail indicators
						DriveType="HDD"
						TempTreshold=45

						#   5 Reallocated_Sector_Ct   0x0033   252   252   010    Pre-fail  Always       -       0
						Reallocated_Sector_Ct="$(awk -F": " '/^  5 / {print $10}' <<<"${SMARTData}")"
						[ ${Reallocated_Sector_Ct:-0} -gt 0 ] && AdditionalSMARTInfo="${AdditionalSMARTInfo}, ${BOLD}${Reallocated_Sector_Ct} Reallocated Sector Count${NC}${LRED}"
						# 195 Hardware_ECC_Recovered  0x003a   100   100   000    Old_age   Always       -       0
						Hardware_ECC_Recovered="$(awk -F": " '/^195 / {print $10}' <<<"${SMARTData}")"
						[ ${Hardware_ECC_Recovered:-0} -gt 0 ] && AdditionalSMARTInfo="${AdditionalSMARTInfo}, ${BOLD}${Hardware_ECC_Recovered} Hardware ECC Recovered${NC}${LRED}"
						# 196 Reallocated_Event_Count 0x0032   252   252   000    Old_age   Always       -       0
						Reallocated_Event_Count="$(awk -F": " '/^196 / {print $10}' <<<"${SMARTData}")"
						[ ${Reallocated_Event_Count:-0} -gt 0 ] && AdditionalSMARTInfo="${AdditionalSMARTInfo}, ${BOLD}${Reallocated_Event_Count} Reallocated Event Count${NC}${LRED}"
						# 197 Current_Pending_Sector  0x0032   252   252   000    Old_age   Always       -       0
						Current_Pending_Sector="$(awk -F": " '/^197 / {print $10}' <<<"${SMARTData}")"
						[ ${Current_Pending_Sector:-0} -gt 0 ] && AdditionalSMARTInfo="${AdditionalSMARTInfo}, ${BOLD}${Current_Pending_Sector} Current Pending Sector${NC}${LRED}"
						# 198 Offline_Uncorrectable   0x0030   252   252   000    Old_age   Offline      -       0
						Offline_Uncorrectable="$(awk -F": " '/^197 / {print $10}' <<<"${SMARTData}")"
						[ ${Offline_Uncorrectable:-0} -gt 0 ] && AdditionalSMARTInfo="${AdditionalSMARTInfo}, ${BOLD}${Offline_Uncorrectable} Offline Uncorrectable${NC}${LRED}"
						;;
				esac

				RawDiskTemp="$(awk -F" " '/Temperature/ {print $10" "$2}' <<<"${SMARTData}" | head -n1 | sed 's/_/ /g' | sed -e 's/ Airflow//' -e 's/ Temperature//' | tr -d -c '[:digit:]')"
				if [ "X${RawDiskTemp}" != "X" ]; then
					if [ ${RawDiskTemp} -gt ${TempTreshold} ]; then
						DeviceWarning=TRUE
						DriveTemp=", ${BOLD}unhealthy drive temp: ${RawDiskTemp}°C${NC}"
					else
						DriveTemp=", drive temp: ${RawDiskTemp}°C"
					fi
				fi

				# 184 End-to-End_Error        0x0032   100   100   ---    Old_age   Always       -       0
				EndtoEnd_Error="$(awk -F": " '/^184 / {print $10}' <<<"${SMARTData}")"
				[ ${EndtoEnd_Error:-0} -gt 0 ] && AdditionalSMARTInfo="${AdditionalSMARTInfo}, ${BOLD}${EndtoEnd_Error} End-to-End errors${NC}${LRED}"

				# Check whether drive model name already contains vendor and if not try to add it
				DeviceVendor="$(awk -F": " "/^Model Family:/ {print \$2}" <<<"${SMARTData}" | grep -E -v "Silicon Motion|Phison|SandForce|SK hynix|Marvell|JMicron|Apacer SSDs|Indilinx" | sed 's/^ *//g' | cut -f1 -d' ')"
				DeviceModel="$(awk -F": " "/^Device Model:/ {print \$2}" <<<"${SMARTData}" | sed 's/^ *//g')"
				grep -q "${DeviceVendor}" <<<"${DeviceModel}"
				case $? in
					0)
						# drive vendor already part of device model string
						DeviceName="\"${DeviceModel}\" ${DriveType} as ${DeviceToCheck}${DeviceAddition}"
						;;
					*)
						# we add vendor to device name
						DeviceName="\"${DeviceVendor} ${DeviceModel}\" ${DriveType} as ${DeviceToCheck}${DeviceAddition}"
						;;
				esac

				Health="$(awk -F": " '/overall-health self-assessment test result/ {print $2}' <<<"${SMARTData}")"
				if [ "X${Health}" != "XPASSED" ]; then
					AdditionalSMARTInfo="${AdditionalSMARTInfo}, ${BOLD}SMART health: **FAILED**${NC}${LRED}"
					DeviceWarning=TRUE
				fi
				if [ ${PercentageUsed:-0} -gt 75 ] || [ ${Reallocated_Sector_Ct:-0} -gt 1 ] || [ ${Hardware_ECC_Recovered:-0} -gt 1 ] || [ ${Reallocated_Event_Count:-0} -gt 1 ] || [ ${Current_Pending_Sector:-0} -gt 1 ] || [ ${Offline_Uncorrectable:-0} -gt 1 ] || [ ${EndtoEnd_Error:-0} -gt 1 ]; then
					DeviceWarning=TRUE
				fi
				;;
		esac

		# Add vendor name where missing from model string
		case "${DeviceName}" in
			"\"CT"*)
				DeviceName="\"Crucial ${DeviceName:1}"
				;;
			"\"TS"*)
				DeviceName="\"Transcend ${DeviceName:1}"
				;;
		esac
	else
		DeviceName="${DeviceToCheck}"
	fi
} # CheckSMARTData

DisplayUsage() {
	echo -e "\nUsage: ${BOLD}${0##*/} [-c] [-g] [-G] [-h] [-m] [-P] [-r] [-R] [-s] [-t \$degree] [-T \$degree] [-u]${NC}\n"
	echo -e "############################################################################"
	echo -e "\n Use ${BOLD}${0##*/}${NC} for the following tasks:\n"
	echo -e " ${0##*/} invoked without arguments runs a standard benchmark"
	echo -e " ${0##*/} ${BOLD}-c${NC} also executes cpuminer stress tester (NEON/SSE/AVX)"
	echo -e " ${0##*/} ${BOLD}-g${NC} graphs 7-zip MIPS for every cpufreq OPP"
	echo -e " ${0##*/} ${BOLD}-G${NC} Geekbench mode, ensures benchmark is properly monitored"
	echo -e " ${0##*/} ${BOLD}-h${NC} displays this help text"
	echo -e " ${0##*/} ${BOLD}-j${NC} Jeff Geerling mode. Don't use if you're not him"
	echo -e " ${0##*/} ${BOLD}-k${NC} Kernel info: version number and vendor/BSP check"
	echo -e " ${0##*/} ${BOLD}-m${NC} [\$seconds] provides CLI monitoring (5 sec default interval)"
	echo -e " ${0##*/} ${BOLD}-P${NC} Phoronix mode, ensures benchmark is properly monitored"
	echo -e " ${0##*/} ${BOLD}-r${NC} Review mode: generate insights via benchmarking"
	echo -e " ${0##*/} ${BOLD}-R${NC} Review mode w/o baseline benchmarks for further testing"
	echo -e " ${0##*/} ${BOLD}-s${NC} also executes stockfish stress tester (NEON/SSE/AVX/RAM)"
	echo -e " ${0##*/} ${BOLD}-t${NC} [\$degree] runs thermal test waiting to cool down to this value"
	echo -e " ${0##*/} ${BOLD}-T${NC} [\$degree] runs thermal test heating up to this value"
	echo -e " ${0##*/} ${BOLD}-u${NC} update sbc-bench to latest version from Github\n"
	echo -e " The environment variable ${BOLD}MODE${NC} can be set to either ${BOLD}extensive${NC} or ${BOLD}unattended${NC}"
	echo -e " prior to benchmark execution. Exporting ${BOLD}MaxKHz${NC} will also be honored, see here"
	echo -e " for details: https://github.com/ThomasKaiser/sbc-bench#unattended-execution\n"
	echo -e " With a Netio powermeter accessible you can export ${BOLD}Netio=address/socket${NC}" to
	echo -e " sbc-bench defining address and socket this device is plugged into. Requires"
	echo -e " XML API enabled and read-only access w/o password. Use this ${BOLD}only${NC} with ${BOLD}-g${NC} to"
	echo -e " draw efficiency graphs since results will be slightly tampered by this mode."
	echo -e "\n############################################################################\n"
} # DisplayUsage

# Allows the script to be sourced
[[ "${BASH_SOURCE}" = "$0" ]] && Main "$@"
