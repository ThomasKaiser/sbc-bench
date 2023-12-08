# NanoPi NEO

Tested with sbc-bench v0.9.57 on Mon, 27 Nov 2023 10:45:32 +0100. Full info: [http://ix.io/4MBf](../4MBf.txt)

### General information:

    Allwinner H3 (SID: 02c00081), Kernel: armv7l, Userland: armhf
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      480    1296   Cortex-A7 / r0p5
      1        0        0      480    1296   Cortex-A7 / r0p5
      2        0        0      480    1296   Cortex-A7 / r0p5
      3        0        0      480    1296   Cortex-A7 / r0p5

491 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: ondemand / 1296 MHz (conservative ondemand userspace powersave performance schedutil / 480 648 816 960 1008 1104 1200 1296)

Tuned governor settings:

    cpufreq-policy0: performance / 1296 MHz

### Clockspeeds (idle vs. heated up):

Before at 30.9°C:

    cpu0 (Cortex-A7): OPP: 1296, Measured: 1293 

After at 53.3°C:

    cpu0 (Cortex-A7): OPP: 1296, Measured: 1292 

### Performance baseline

  * memcpy: 497.8 MB/s, memchr: 911.7 MB/s, memset: 1532.8 MB/s
  * 16M latency: 241.8 254.1 242.0 259.2 241.6 252.8 501.3 1013 
  * 128M latency: 241.5 279.3 245.3 284.6 240.7 272.9 513.9 1019 
  * 7-zip MIPS (3 consecutive runs): 2702, 2708, 2705 (2700 avg), single-threaded: 788
  * `aes-256-cbc      17391.87k    22801.13k    24549.63k    25029.29k    25171.29k    25122.13k`
  * `aes-256-cbc      17891.39k    22797.95k    24547.24k    25027.58k    25168.55k    25122.13k`

### Storage devices:

  * 3.7GB "Phison SD4GB" HS SD card as /dev/mmcblk0: date 02/2015, manfid/oemid: 0x000027/0x5048, hw/fw rev: 0x3/0x0

### Swap configuration:

  * /dev/zram0: 245.6M (15.0M used, lzo-rle, 4 streams, 14.7M data, 4.3M compressed, 5.3M total)

### Software versions:

  * Armbian 23.8.99 bookworm arm
  * Build scripts: https://github.com/armbian/build, 23.8.99, NanoPi Neo, sun8i, sunxi
  * Compiler: /usr/bin/gcc (Debian 12.2.0-14) 12.2.0 / arm-linux-gnueabihf
  * OpenSSL 3.0.11, built on 19 Sep 2023 (Library: OpenSSL 3.0.11 19 Sep 2023)    

### Kernel info:

  * `/proc/cmdline: root=UUID=f92b58ff-bd6d-439f-a502-0c6c4790d6b5 rootwait rootfstype=ext4 splash=verbose console=ttyS0,115200 hdmi.audio=EDID:0 disp.screen0_output_mode=1920x1080p60 consoleblank=0 loglevel=1 ubootpart=d4f2c70f-01 ubootsource=mmc usb-storage.quirks=   sunxi_ve_mem_reserve=0 sunxi_g2d_mem_reserve=0 sunxi_fb_mem_reserve=16 cgroup_enable=memory swapaccount=1`
  * Vulnerability Spectre v1:           Mitigation; __user pointer sanitization
  * Kernel 6.1.62-current-sunxi / CONFIG_HZ=250