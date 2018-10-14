#!/bin/bash
#
# sd-card-bench.sh 0.1
#
# Purpose of this SBC benchmark script is to get the idea about rootfs performance
# differences based on storage type (be it a slow SD card, a fast one, an eMMC module,
# an USB or SATA drive or even a fast NVMe SSD)
#
# To be used an Armbian Stretch or Bionic CLI image (not desktop!) is needed, then this
# script stored with execute permissions as /usr/local/bin/sd-card-bench.sh and a single
# line in /etc/rc.local prior to the 'exit 0' line reading
#
#    /usr/local/bin/sd-card-bench.sh &
#
# The script after the needed reboot will then do the following:
#
# - rebooting 4 times, each time measuring time until execution of /etc/rc.local
# - 3 times running an iozone benchmark (some new SD cards perform poorly in the beginning)
# - installing Armbian's desktop metapackage twice (1st time Internet access interferes)
# - then allowing to measure application start times in installed desktop environment
#
# From a security point of view this is just a mess so only run this on a test install.
# It's only about providing an automated and mostly unattended way to test through rootfs
# storage performance.
#
# The relevant numbers are collected as follows:
#
# - /root/uptime contains the time in seconds until OS executed /etc/rc.local
# - /root/iostat.txt contains the kernel IO statistics
# - /root/desktop-install.txt contains the times for installing a DE, removing it
#   and installing it a 2nd time (this time not downloading the stuff from upstream
#   repos but local cache so the latter number is the one where Internet access speed
#   doesn't tamper with storage results)
#
# And finally after latest reboot /root/storage-report.txt will be created containing
# averaged results from the individual tests.

# monitor boot times
awk '{print $1}' /proc/uptime >>/root/uptime

# increment reboot counter
if [ -f /root/reboot-count ]; then
	read RebootCount </root/reboot-count
	echo $((RebootCount + 1)) >/root/reboot-count
else
	RebootCount=0
	echo 0 >/root/reboot-count
fi

# monitor storage access patterns
echo -e "\n\n$(date) - reboot count: ${RebootCount}" >>/root/iostat.txt
iostat 20 >>/root/iostat.txt &

# switch to highest performance to avoid potentially broken cpufreq behavior
# interfering with storage performance
CPUCores=$(grep -c '^processor' /proc/cpuinfo)
for ((i=0;i<CPUCores;i++)); do
	echo performance >/sys/devices/system/cpu/cpu${i}/cpufreq/scaling_governor
done

# test 3 times with iozone, then install armbian-desktop package twice
if [ ${RebootCount} -lt 2 ]; then
	cd /root
	taskset -c $((CPUCores - 1)) iozone -e -I -a -s 100M -r 1k -r 2k -r 4k -r 16k -r 128k -r 512k -r 1024k -r 16384k -i 0 -i 1 -i 2 \
		>>/root/iozone.txt
	echo -e "\n\n\n" >>/root/iozone.txt
	reboot
elif [ ${RebootCount} -eq 2 ]; then
	# install time package for better output parsing
	sleep 60
	apt-get -qq -o Dpkg::Use-Pty=0 install time
	DISTROID=$(lsb_release -sc)
	(/usr/bin/time -f '\nFirst desktop install time: %e\n\n\n' apt-get -qq -o Dpkg::Use-Pty=0 install armbian-${DISTROID}-desktop) &>>/root/desktop-install.txt
	(/usr/bin/time -f '\nFirst desktop sync time: %e\n\n\n' sync) &>>/root/desktop-install.txt
	apt-get -y purge armbian-${DISTROID}-desktop
	(/usr/bin/time -f '\nAutoremove time: %e\n\n\n' apt-get -qq autoremove) &>>/root/desktop-install.txt
	(/usr/bin/time -f '\nAutoremove sync time: %e\n\n\n' sync) &>>/root/desktop-install.txt
	(/usr/bin/time -f '\nSecond desktop install time: %e\n\n\n' apt-get -qq -o Dpkg::Use-Pty=0 install armbian-${DISTROID}-desktop) &>>/root/desktop-install.txt	
	(/usr/bin/time -f '\nSecond desktop sync time: %e\n\n\n' sync) &>>/root/desktop-install.txt
	[[ ${DISTROID} == stretch ]] && debconf-apt-progress -- apt -y purge lightdm
	DEBIAN_FRONTEND=noninteractive debconf-apt-progress -- apt-get -y -qq install nodm
	sed -i "s/NODM_USER=\(.*\)/NODM_USER=root/" /etc/default/nodm
	sed -i "s/NODM_ENABLED=\(.*\)/NODM_ENABLED=true/g" /etc/default/nodm
	reboot
elif [ ${RebootCount} -eq 3 ]; then
	# create report using averages values from the individual tests

	# uptime average:
	AvgUptime=$(awk '{ sum += $1 } END { if (NR > 0) print sum / NR }' </root/uptime)
	echo -e "Average time until /etc/rc.local execution: ${AvgUptime} sec ($(tr '\n' ', ' </root/uptime | sed 's/,$//'))" >/root/storage-report.txt
	
	# IOPS values
	Read1K=$(grep '102400       1' /root/iozone.txt | awk '{ sum += $7 } END { if (NR > 0) print sum / NR }' | cut -f1 -d.)
	Write1K=$(grep '102400       1' /root/iozone.txt | awk '{ sum += $8 } END { if (NR > 0) print sum / NR }' | cut -f1 -d.)
	Read4K=$(grep '102400       4' /root/iozone.txt | awk '{ sum += $7 } END { if (NR > 0) print sum / NR }' | cut -f1 -d.)
	Write4K=$(grep '102400       4' /root/iozone.txt | awk '{ sum += $8 } END { if (NR > 0) print sum / NR }' | cut -f1 -d.)
	Read16K=$(grep '102400      16' /root/iozone.txt | awk '{ sum += $7 } END { if (NR > 0) print sum / NR }' | cut -f1 -d.)
	Write16K=$(grep '102400      16' /root/iozone.txt | awk '{ sum += $8 } END { if (NR > 0) print sum / NR }' | cut -f1 -d.)
	echo "IOPS read/write: 1k: ${Read1K}/${Write1K}, 4k: $(( (Read4K+2)/4 ))/$(( (Write4K+2)/4 )), 16k: $(( (Read16K+8)/16 ))/$(( (Write16K+8)/16 ))" >>/root/storage-report.txt
	
	# Sequential MB/s
	SeqRead=$(grep '102400   16384' /root/iozone.txt | awk '{ sum += $5 } END { if (NR > 0) print sum / NR }' | cut -f1 -d.)
	SeqWrite=$(grep '102400   16384' /root/iozone.txt | awk '{ sum += $3 } END { if (NR > 0) print sum / NR }' | cut -f1 -d.)
	echo "Sequential: $(( (SeqRead+512)/1024 )) MB/s read, $(( (SeqWrite+512)/1024 )) MB/s write" >>/root/storage-report.txt

	# Desktop installation and autoremove times
	Install1stTime=$(awk -F"time: " '/First desktop install time/ {print $2}' </root/desktop-install.txt)
	Sync1stTime=$(awk -F"time: " '/First desktop sync time/ {print $2}' </root/desktop-install.txt)
	Install2ndTime=$(awk -F"time: " '/Second desktop install time/ {print $2}' </root/desktop-install.txt)
	Sync2ndTime=$(awk -F"time: " '/Second desktop sync time/ {print $2}' </root/desktop-install.txt)
	AutoremoveTime=$(awk -F"time: " '/Autoremove time/ {print $2}' </root/desktop-install.txt)
	AutoremoveSyncTime=$(awk -F"time: " '/Autoremove sync time/ {print $2}' </root/desktop-install.txt)
	echo "First desktop install: $(bc <<<"${Install1stTime}+${Sync1stTime}" | cut -f1 -d.) sec" >>/root/storage-report.txt
	echo "Desktop removal time: $(bc <<<"${AutoremoveTime}+${AutoremoveSyncTime}" | cut -f1 -d.) sec" >>/root/storage-report.txt
	echo -e "Second desktop install: $(bc <<<"${Install2ndTime}+${Sync2ndTime}" | cut -f1 -d.) sec\n\n\n" >>/root/storage-report.txt
	cat /root/iozone.txt >>/root/storage-report.txt
	echo -e "\n\n\n" >>/root/storage-report.txt
	cat /root/desktop-install.txt >>/root/storage-report.txt
	echo -e "\n\n\n" >>/root/storage-report.txt
	armbianmonitor -U >>/root/storage-report.txt
fi