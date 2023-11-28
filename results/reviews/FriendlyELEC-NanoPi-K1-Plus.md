# FriendlyElec NanoPi K1 Plus

Tested with sbc-bench v0.9.56 on Mon, 27 Nov 2023 09:51:09 +0100. Full info: [http://ix.io/4MB5](http://ix.io/4MB5)

### General information:

    Allwinner H5, Kernel: aarch64, Userland: arm64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      480    1368   Cortex-A53 / r0p4
      1        0        0      480    1368   Cortex-A53 / r0p4
      2        0        0      480    1368   Cortex-A53 / r0p4
      3        0        0      480    1368   Cortex-A53 / r0p4

1989 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: ondemand / 960 MHz (conservative ondemand userspace powersave performance schedutil / 480 648 816 960 1008 1104 1200 1296 1368)
    1c62000.dram-controller: performance / 1008 MHz (userspace powersave performance simple_ondemand / 252 336 504 1008)

Tuned governor settings:

    cpufreq-policy0: performance / 1368 MHz
    1c62000.dram-controller: performance / 1008 MHz

### Clockspeeds (idle vs. heated up):

Before at 33.3°C:

    cpu0 (Cortex-A53): OPP: 1368, Measured: 1366 

After at 85.8°C (throttled):

    cpu0 (Cortex-A53): OPP: 1368, Measured: 1349      (-1.4%)

### Performance baseline

  * memcpy: 1101.0 MB/s, memchr: 1473.3 MB/s, memset: 3832.9 MB/s
  * 16M latency: 196.3 198.4 196.2 199.2 196.0 198.9 276.7 534.2 
  * 128M latency: 198.1 200.6 209.2 199.9 197.2 200.0 262.3 521.9 
  * 7-zip MIPS (3 consecutive runs): 3452, 3310, 3176 (3310 avg), single-threaded: 1016
  * `aes-256-cbc      92765.06k   258248.00k   457777.75k   583857.83k   634516.82k   638266.03k`
  * `aes-256-cbc      92716.97k   258210.97k   457771.69k   583841.45k   634440.36k   638271.49k`

### Storage devices:

  * 3.7GB "Phison SD4GB" HS SD card as /dev/mmcblk0: date 02/2015, manfid/oemid: 0x000027/0x5048, hw/fw rev: 0x3/0x0

### Swap configuration:

  * /dev/zram0: 994.6M (0K used, lzo-rle, 4 streams, 4K data, 74B compressed, 12K total)

### Software versions:

  * Armbian 23.8.1 bookworm arm64
  * Build scripts: https://github.com/armbian/build, 23.8.1, NanoPi K1 Plus, sun50iw2, sunxi64
  * Compiler: /usr/bin/gcc (Debian 12.2.0-14) 12.2.0 / aarch64-linux-gnu
  * OpenSSL 3.0.9, built on 30 May 2023 (Library: OpenSSL 3.0.9 30 May 2023)    

### Kernel info:

  * `/proc/cmdline: root=UUID=54b66702-866f-4eeb-98d5-da6c5bee4256 rootwait rootfstype=ext4 splash=verbose console=ttyS0,115200 console=tty1 consoleblank=0 loglevel=1 ubootpart=65ccd104-01 usb-storage.quirks=   cgroup_enable=memory swapaccount=1`
  * Vulnerability Spectre v1:           Mitigation; __user pointer sanitization
  * Kernel 6.1.47-current-sunxi64 / CONFIG_HZ=250

Kernel 6.1.47 is not latest 6.1.63 LTS that was released on 2023-11-20.

See https://endoflife.date/linux for details. Perhaps some kernel bugs have
been fixed in the meantime and maybe vulnerabilities as well.