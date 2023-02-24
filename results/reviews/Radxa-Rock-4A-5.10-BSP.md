# Radxa ROCK Pi 4A

Tested with sbc-bench v0.9.29 on Fri, 24 Feb 2023 09:20:30 +0000. Full info: [http://ix.io/4p3e](http://ix.io/4p3e)

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

    cpufreq-policy0: ondemand / 1200 MHz (ondemand performance schedutil / 408 600 816 1008 1200 1416)
    cpufreq-policy4: ondemand / 408 MHz (ondemand performance schedutil / 408 600 816 1008 1200 1416 1608 1800)
    dmc: dmc_ondemand / 856 MHz (powersave performance dmc_ondemand simple_ondemand / 328 416 666 856)
    ff9a0000.gpu: simple_ondemand / 200 MHz (powersave performance dmc_ondemand simple_ondemand / 200 300 400 600 800)

Tuned governor settings:

    cpufreq-policy0: performance / 1416 MHz
    cpufreq-policy4: performance / 1800 MHz
    dmc: performance / 856 MHz
    ff9a0000.gpu: performance / 800 MHz

Status of performance related policies found below /sys:

    /sys/devices/platform/ff9a0000.gpu/core_availability_policy: [fixed] devfreq
    /sys/devices/platform/ff9a0000.gpu/power_policy: [coarse_demand] always_on
    /sys/module/pcie_aspm/parameters/policy: default [performance] powersave powersupersave

### Clockspeeds (idle vs. heated up):

Before at 49.4°C:

    cpu0-cpu3 (Cortex-A53): OPP: 1416, Measured: 1412 
    cpu4-cpu5 (Cortex-A72): OPP: 1800, Measured: 1797 

After at 80.6°C (throttled):

    cpu0-cpu3 (Cortex-A53): OPP: 1416, Measured: 1412 
    cpu4-cpu5 (Cortex-A72): OPP: 1800, Measured: 1413     (-21.5%)

### Memory performance

  * cpu0 (Cortex-A53): memcpy: 1780.9 MB/s, memchr: 1885.0 MB/s, memset: 8492.4 MB/s
  * cpu4 (Cortex-A72): memcpy: 3585.2 MB/s, memchr: 6225.3 MB/s, memset: 8386.5 MB/s
  * cpu0 (Cortex-A53) 16M latency: 189.6 192.3 188.4 191.5 188.5 192.1 236.2 449.4 
  * cpu4 (Cortex-A72) 16M latency: 197.5 198.8 199.5 198.7 199.3 203.0 203.5 239.2 

### Storage devices:

  * 111.8GB "Samsung SSD 750 EVO 120GB" SSD as /dev/sda [SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)]: behind ASMedia SATA 6Gb/s bridge, 3% worn out, Driver=uas, 5000Mbps (capable of 12Mbps, 480Mbps, 5Gbps), drive temp: 24°C
  * 7.3GB "Silicon Motion Flash Drive" as /dev/sdb: USB, Driver=usb-storage, 480Mbps
  * 29.7GB "SanDisk SE32G" HS SD card (speed negotiation problems, check dmesg) as /dev/mmcblk0: date 10/2017, manfid/oemid: 0x000003/0x5344, hw/fw rev: 0x8/0x0

### Software versions:

  * Debian GNU/Linux 11 (bullseye)
  * Compiler: /usr/bin/gcc (Debian 10.2.1-6) 10.2.1 20210110 / aarch64-linux-gnu
  * OpenSSL 1.1.1n, built on 15 Mar 2022

### Kernel info:

  * `/proc/cmdline: root=UUID=82c6b681-0ae1-4228-a95e-393d9b4bef28 loglevel=4 console=tty0 console=ttyAML0,115200n8 console=ttyS2,1500000n8 console=ttyFIQ0,1500000n8 coherent_pool=2M irqchip.gicv3_pseudo_nmi=0 quiet splash plymouth.ignore-serial-consoles`
  * Vulnerability Spec store bypass: Vulnerable
  * Vulnerability Spectre v1:        Mitigation; __user pointer sanitization
  * Vulnerability Spectre v2:        Vulnerable
  * Kernel 5.10.110-1-rockchip / CONFIG_HZ=300

Kernel 5.10.110 is not latest 5.10.169 LTS that was released on 2023-02-22.

See https://endoflife.date/linux for details. It is somewhat likely that
a lot of exploitable vulnerabilities exist for this kernel as well as many
unfixed bugs.

But this version string doesn't matter since this is not an official LTS Linux
from kernel.org. This device runs a Rockchip vendor/BSP kernel.

This kernel is based on a mixture of Android GKI and other sources. Also some
community attempts to do version string cosmetics might have happened, see
https://tinyurl.com/2p8fuubd for example. To examine how far away this 5.10.110
is from an official LTS of same version someone would have to reapply Rockchip's
thousands of patches to a clean 5.10.110 LTS.
