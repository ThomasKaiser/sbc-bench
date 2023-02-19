# Radxa ROCK Pi 4A

Tested on Sun, 19 Feb 2023 17:12:04 +0000. Full info: [http://ix.io/4ozm](http://ix.io/4ozm)

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

    cpufreq-policy0: ondemand / 1008 MHz (ondemand performance schedutil)
    cpufreq-policy4: ondemand / 408 MHz (ondemand performance schedutil)
    dmc: dmc_ondemand / 856 MHz (dmc_ondemand simple_ondemand)
    ff9a0000.gpu: simple_ondemand / 200 MHz (dmc_ondemand simple_ondemand)

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

Before at 45.6°C:

    cpu0-cpu3 (Cortex-A53): OPP: 1416, Measured: 1412 
    cpu4-cpu5 (Cortex-A72): OPP: 1800, Measured: 1797 

After at 81.7°C (throttled):

    cpu0-cpu3 (Cortex-A53): OPP: 1416, Measured: 1412 
    cpu4-cpu5 (Cortex-A72): OPP: 1800, Measured: 1462     (-18.8%)

### Memory performance

  * cpu0 (Cortex-A53): memcpy: 1660.6 MB/s, memchr: 1879.6 MB/s, memset: 8470.1 MB/s
  * cpu4 (Cortex-A72): memcpy: 3595.9 MB/s, memchr: 6755.7 MB/s, memset: 8622.2 MB/s
  * cpu0 (Cortex-A53) 16M latency: 190.7 193.8 189.5 193.4 189.6 193.7 237.7 452.7 
  * cpu4 (Cortex-A72) 16M latency: 197.4 200.4 200.0 198.6 199.1 202.1 204.0 239.4 

### Storage devices:

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

Kernel 5.10.110 is not latest 5.10.168 LTS that was released on 2023-02-15.

Please check https://endoflife.date/linux for details. It is somewhat likely
that a lot of exploitable vulnerabilities exist for this kernel as well as
many unfixed bugs. Better upgrade to a supported version ASAP.

But this version string doesn't matter since this is not an official LTS Linux
from kernel.org. This device runs a Rockchip vendor/BSP kernel.

This kernel is based on a mixture of Android GKI and other sources. Also some
community attempts to do version string cosmetics might have happened, see
https://tinyurl.com/2p8fuubd for example. To examine how far away this 5.10.110
is from an official LTS of same version someone would have to reapply Rockchip's
thousands of patches to a clean 5.10.110 LTS.
