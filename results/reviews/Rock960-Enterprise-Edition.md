# Radxa ROCK Pi 4B

Tested on Sun, 19 Feb 2023 17:51:55 +0000. Full info: [http://ix.io/4ozG](http://ix.io/4ozG)

### General information:

The CPU features 2 clusters of different core types:

    Rockchip RK3399, Kernel: aarch64, Userland: arm64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      408    1416   Cortex-A53 / r0p4
      1        0        0      408    1416   Cortex-A53 / r0p4
      2        0        0      408    1416   Cortex-A53 / r0p4
      3        0        0      408    1416   Cortex-A53 / r0p4
      4        1        4      408    1800   Cortex-A72 / r0p2
      5        1        4      408    1800   Cortex-A72 / r0p2

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: ondemand / 1416 MHz (conservative ondemand userspace powersave performance schedutil)
    cpufreq-policy4: ondemand / 1800 MHz (conservative ondemand userspace powersave performance schedutil)
    ff9a0000.gpu: performance / 800 MHz (performance simple_ondemand)

Tuned governor settings:

    

Status of performance related policies found below /sys:

    /sys/module/pcie_aspm/parameters/policy: default [performance] powersave powersupersave

### Clockspeeds (idle vs. heated up):

Before at 30.0°C:

    cpu0-cpu3 (Cortex-A53): OPP: 1416, Measured: 1413 
    cpu4-cpu5 (Cortex-A72): OPP: 1800, Measured: 1798 

After at 73.9°C:

    cpu0-cpu3 (Cortex-A53): OPP: 1416, Measured: 1413 
    cpu4-cpu5 (Cortex-A72): OPP: 1800, Measured: 1798 

### Memory performance

  * cpu0 (Cortex-A53): memcpy: 2043.8 MB/s, memchr: 2208.3 MB/s, memset: 8443.2 MB/s
  * cpu4 (Cortex-A72): memcpy: 4262.3 MB/s, memchr: 7090.2 MB/s, memset: 9204.4 MB/s
  * cpu0 (Cortex-A53) 16M latency: 163.7 167.4 163.5 166.4 163.5 166.0 203.7 389.9 
  * cpu4 (Cortex-A72) 16M latency: 169.8 171.9 170.0 171.5 170.5 174.5 177.9 205.0 

### Storage devices:

  * 2.7TB "Seagate ST3000DM001-9YN166" HDD as /dev/sda [SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)]: behind "Western Digital Technologies, Inc. ", Driver=usb-storage, 5000M, firmware version CC4B, updates may be available: http://knowledge.seagate.com/articles/en_US/FAQ/207931en http://knowledge.seagate.com/articles/en_US/FAQ/223651en, 24°C
  * 2.7TB "Seagate ST3000DM001-9YN166" HDD as /dev/sdb [SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)]: behind "Western Digital Technologies, Inc. ", Driver=usb-storage, 5000M, firmware version CC4B, updates may be available: http://knowledge.seagate.com/articles/en_US/FAQ/207931en http://knowledge.seagate.com/articles/en_US/FAQ/223651en, 24°C
  * 7.3GB "SanDisk/Toshiba DG4008" HS400 Enhanced strobe eMMC 5.1 card as /dev/mmcblk2: date 04/2018, manfid/oemid: 0x000045/0x0100, hw/fw rev: 0x0/0x3733313033353137

### Software versions:

  * Debian GNU/Linux 10 (buster)
  * Build scripts: https://github.com/armbian/build, 21.02.2, Rockpi 4B, rockchip64, rockchip64
  * Compiler: /usr/bin/gcc (Debian 8.3.0-6) 8.3.0 / aarch64-linux-gnu
  * OpenSSL 1.1.1n, built on 15 Mar 2022

### Kernel info:

  * `/proc/cmdline: root=UUID=dfa3ab95-cede-4159-9841-4e31bafe853e rootwait rootfstype=ext4 console=ttyS2,1500000 console=tty1 consoleblank=0 loglevel=1 ubootpart=b670ed71-01 usb-storage.quirks=0x2537:0x1066:u,0x2537:0x1068:u,0x1058:0x0a10:u   cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory swapaccount=1`
  * Kernel 5.10.12-rockchip64 / CONFIG_HZ=250

Kernel 5.10.12 is not latest 5.10.168 LTS that was released on 2023-02-15.

Please check https://endoflife.date/linux for details. It is somewhat likely
that a lot of exploitable vulnerabilities exist for this kernel as well as
many unfixed bugs. Better upgrade to a supported version ASAP.
