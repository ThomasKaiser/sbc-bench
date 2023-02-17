# NanoPi Fire3

Tested on Fri, 17 Feb 2023 23:54:37 +0100. Full info: [http://ix.io/4oo7](http://ix.io/4oo7)

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

    cpufreq-policy0: ondemand / 1100 MHz (conservative userspace powersave ondemand performance schedutil)

Tuned governor settings:

    cpufreq-policy0: performance / 1400 MHz

### Clockspeeds (idle vs. heated up):

Before at 72.0°C:

    cpu0 (Cortex-A53): OPP: 1400, Measured: 1397 

After at 86.0°C:

    cpu0 (Cortex-A53): OPP: 1400, Measured:  997     (-28.8%)

### Storage devices:

  * 7.4GB SanDisk SU08G SD card as /dev/mmcblk2: date 06/2013, man/oem ID: 0x000003/0x5344, hw/fw rev: 0x8/0x0
  * TOSHIBA MK7559GSXF HDD as /dev/sda as /dev/sda: USB, Driver=uas, 480M, 22°C

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
from kernel.org.

This device runs a Samsung BSP kernel.