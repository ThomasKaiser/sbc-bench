# Orange Pi Zero2w

Tested with sbc-bench v0.9.58 on Wed, 29 Nov 2023 06:57:57 +0000. Full info: [http://ix.io/4MLz](../4MLz.txt)

### General information:

    Allwinner H618 (SID: 33802000), Kernel: aarch64, Userland: arm64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      480    1512   Cortex-A53 / r0p4
      1        0        0      480    1512   Cortex-A53 / r0p4
      2        0        0      480    1512   Cortex-A53 / r0p4
      3        0        0      480    1512   Cortex-A53 / r0p4

952 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: ondemand / 1512 MHz (conservative userspace powersave ondemand performance schedutil / 480 720 936 1008 1104 1200 1320 1416 1512)

Tuned governor settings:

    cpufreq-policy0: performance / 1512 MHz

### Clockspeeds (idle vs. heated up):

Before at 61.9°C:

    cpu0 (Cortex-A53): OPP: 1512, Measured: 1509 

After at 91.4°C (throttled):

    cpu0 (Cortex-A53): OPP: 1512, Measured: 1509 

### Performance baseline

  * memcpy: 1293.6 MB/s, memchr: 1441.0 MB/s, memset: 4451.6 MB/s
  * 16M latency: 207.9 212.7 202.1 213.2 211.0 208.8 303.3 598.1 
  * 128M latency: 206.3 206.9 203.0 206.7 203.0 206.6 300.0 573.7 
  * `aes-256-cbc     117605.58k   313446.81k   533142.27k   651560.62k   701180.59k   703026.52k`
  * `aes-256-cbc     117834.10k   313093.99k   533221.80k   655200.26k   703225.86k   704992.60k`

### Storage devices:

  * 14.9GB "SanDisk SB16G" UHS SDR104 SD card as /dev/mmcblk0: date 02/2021, manfid/oemid: 0x000003/0x5344, hw/fw rev: 0x8/0x0

### Swap configuration:

  * /dev/zram0: 476.4M (321.6M used, lzo-rle, 4 streams, 321.5M data, 95.9M compressed, 104.4M total)

### Software versions:

  * Ubuntu 20.04.6 LTS
  * Build scripts: https://github.com/orangepi-xunlong/orangepi-build, 1.0.0, OPI Zero2W, sun50iw9, sun50iw9
  * Compiler: /usr/bin/gcc (Ubuntu 9.4.0-1ubuntu1~20.04.2) 9.4.0 / aarch64-linux-gnu
  * OpenSSL 1.1.1f, built on 31 Mar 2020          

### Kernel info:

  * `/proc/cmdline: root=UUID=adb0523d-da08-4a54-9c4c-d549a5cd714d rootwait rootfstype=ext4 splash plymouth.ignore-serial-consoles console=ttyAS0,115200 console=tty1 consoleblank=0 loglevel=1 ubootpart=c90ad7cc-01 disp_reserve=8294400,0x7bf6f000  `
  * Vulnerability Spectre v1:        Mitigation; __user pointer sanitization
  * Kernel 5.4.125 / CONFIG_HZ=250

Kernel 5.4.125 is not latest 5.4.261 LTS that was released on 2023-11-20.

See https://endoflife.date/linux for details. It is somewhat likely that
a lot of exploitable vulnerabilities exist for this kernel as well as many
unfixed bugs.

But this version string doesn't matter since this is not an official LTS Linux
from kernel.org. This device runs an Allwinner vendor/BSP kernel.

This kernel has been forward ported since ages based on unknown sources. While
the version string suggests being a 5.4 LTS release the code base differs way
too much. Better expect tons of unfixed bugs and vulnerabilities hiding in this
vendor kernel.