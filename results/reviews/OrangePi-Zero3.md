# Orange Pi Zero 3

Tested with sbc-bench v0.9.53 on Wed, 22 Nov 2023 12:28:25 +0000. Full info: [http://ix.io/4M8N](../4M8N.txt)

### General information:

    Allwinner H618, Kernel: aarch64, Userland: arm64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      480    1512   Cortex-A53 / r0p4
      1        0        0      480    1512   Cortex-A53 / r0p4
      2        0        0      480    1512   Cortex-A53 / r0p4
      3        0        0      480    1512   Cortex-A53 / r0p4

3901 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: ondemand / 1512 MHz (conservative userspace powersave ondemand performance schedutil / 480 720 936 1008 1104 1200 1320 1416 1512)

Tuned governor settings:

    cpufreq-policy0: performance / 1512 MHz

### Clockspeeds (idle vs. heated up):

Before at 50.3°C:

    cpu0 (Cortex-A53): OPP: 1512, Measured: 1509 

After at 75.7°C:

    cpu0 (Cortex-A53): OPP: 1512, Measured: 1509 

### Performance baseline

  * memcpy: 1290.4 MB/s, memchr: 1490.9 MB/s, memset: 4466.8 MB/s
  * 16M latency: 202.0 203.8 201.2 203.2 201.2 202.8 283.0 567.2 
  * 128M latency: 203.1 205.5 202.8 215.0 202.1 205.3 285.6 572.1 
  * 7-zip MIPS (3 consecutive runs): 3924, 3928, 3925 (3920 avg), single-threaded: 1142
  * `aes-256-cbc     100278.62k   289951.91k   513532.33k   648466.09k   701784.06k   705729.88k`
  * `aes-256-cbc     105051.94k   290588.01k   514803.11k   648946.69k   701920.60k   705369.43k`

### Storage devices:

  * 119.1GB "SH128" UHS SDR104 SDXC card as /dev/mmcblk0: date 06/2019, manfid/oemid: 0x000003/0x5744, hw/fw rev: 0x8/0x0
  * 16MB SPI NOR flash, drivers in use: spi-nor

### Swap configuration:

  * /dev/zram0: 1.9G (0K used, lzo-rle, 4 streams, 4K data, 74B compressed, 12K total)

### Software versions:

  * Ubuntu 22.04.3 LTS
  * Build scripts: https://github.com/orangepi-xunlong/orangepi-build, 1.0.0, OPI Zero3, sun50iw9, sun50iw9
  * Compiler: /usr/bin/gcc (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0 / aarch64-linux-gnu
  * OpenSSL 3.0.2, built on 15 Mar 2022 (Library: OpenSSL 3.0.2 15 Mar 2022)    

### Kernel info:

  * `/proc/cmdline: root=UUID=097c0934-864c-4961-9bf6-4ab53f3c5f5a rootwait rootfstype=ext4 splash=verbose console=ttyAS0,115200 consoleblank=0 loglevel=9 ubootpart=22e197f4-01 disp_reserve=8294400,0xbbf6f000  `
  * Vulnerability Spectre v1:        Mitigation; __user pointer sanitization
  * Kernel 5.4.125 / CONFIG_HZ=250

Kernel 5.4.125 is not latest 5.4.261 LTS that was released on 2023-11-20.

See https://endoflife.date/linux for details. It is somewhat likely that
a lot of exploitable vulnerabilities exist for this kernel as well as many
unfixed bugs.