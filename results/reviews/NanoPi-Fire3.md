# NanoPi Fire3

Tested on Sun, 19 Feb 2023 18:33:21 +0100. Full info: [http://ix.io/4ozy](http://ix.io/4ozy)

### General information:

    Nexell S5P6818, Kernel: aarch64, Userland: arm64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      400    1400   Cortex-A53 / r0p3
      1        0        0      400    1400   Cortex-A53 / r0p3
      2        0        0      400    1400   Cortex-A53 / r0p3
      3        0        0      400    1400   Cortex-A53 / r0p3
      4        1        0      400    1400   Cortex-A53 / r0p3
      5        1        0      400    1400   Cortex-A53 / r0p3
      6        1        0      400    1400   Cortex-A53 / r0p3
      7        1        0      400    1400   Cortex-A53 / r0p3

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: ondemand / 1400 MHz (conservative userspace powersave ondemand performance schedutil)

Tuned governor settings:

    cpufreq-policy0: performance / 1400 MHz

### Clockspeeds (idle vs. heated up):

Before at 37.0°C:

    cpu0 (Cortex-A53): OPP: 1400, Measured: 1397 

After at 85.0°C (throttled):

    cpu0 (Cortex-A53): OPP: 1400, Measured: 1197     (-14.5%)

### Memory performance

  * memcpy: 1524.0 MB/s, memchr: 1975.8 MB/s, memset: 4584.2 MB/s
  * 16M latency: 174.3 175.4 172.9 175.3 172.6 175.6 237.1 448.2 

### Storage devices:

  * 14.4GB "Genesys Logic, Inc. GL827L SD/MMC/MS Flash Card Reader" as /dev/sda: USB, Driver=usb-storage, 480M
  * 7.4GB "SanDisk SU08G" HS SD card as /dev/mmcblk2: date 06/2013, manfid/oemid: 0x000003/0x5344, hw/fw rev: 0x8/0x0

### Software versions:

  * Ubuntu 20.04.3 LTS
  * Build scripts: https://github.com/armbian/build, 21.02.1, NanoPi Fire3, s5p6818, s5p6818
  * Compiler: /usr/bin/gcc (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0 / aarch64-linux-gnu
  * OpenSSL 1.1.1f, built on 31 Mar 2020

### Kernel info:

  * `/proc/cmdline: console=ttySAC0,115200n8 console=tty1   root=UUID=d907d760-b4fa-4c0b-a1f7-83e3d3a0b871 rootwait rootfstype=ext4 loglevel=1 usb-storage.quirks=0x2537:0x1066:u,0x2537:0x1068:u `
  * Vulnerability Spectre v1:        Mitigation; __user pointer sanitization
  * Kernel 4.14.180-s5p6818 / CONFIG_HZ=250

Kernel 4.14.180 is not latest 4.14.305 LTS that was released on 2023-02-06.

Please check https://endoflife.date/linux for details. It is somewhat likely
that a lot of exploitable vulnerabilities exist for this kernel as well as
many unfixed bugs. Better upgrade to a supported version ASAP.

But this version string doesn't matter since this is not an official LTS Linux
from kernel.org. This device runs a Samsung vendor/BSP kernel.
