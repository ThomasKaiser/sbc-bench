# FriendlyArm NanoPi M1 Plus

Tested with sbc-bench v0.9.34 on Tue, 28 Feb 2023 22:55:40 +0100. Full info: [http://ix.io/4pwB](http://ix.io/4pwB)

### General information:

    Allwinner H3, Kernel: armv7l, Userland: armhf
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      120    1368   Cortex-A7 / r0p5
      1        0        0      120    1368   Cortex-A7 / r0p5
      2        0        0      120    1368   Cortex-A7 / r0p5
      3        0        0      120    1368   Cortex-A7 / r0p5

999 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: ondemand / 816 MHz (conservative userspace powersave ondemand performance schedutil / 120 240 480 648 816 960 1008 1056 1104 1152 1200 1224 1248 1296 1344 1368)

Tuned governor settings:

    cpufreq-policy0: performance / 1368 MHz

### Clockspeeds (idle vs. heated up):

Before at 44.4°C:

    cpu0 (Cortex-A7): OPP: 1368, Measured: 1365 

After at 75.3°C (throttled):

    cpu0 (Cortex-A7): OPP: 1368, Measured: 1365 

### Performance baseline

  * memcpy: 823.3 MB/s, memchr: 1200.0 MB/s, memset: 3453.1 MB/s
  * 16M latency: 190.8 195.8 187.7 210.0 191.4 198.2 393.2 777.6 
  * 7-zip MIPS (3 consecutive runs): 3042, 3046, 3039 (3040 avg), single-threaded: 882
  * `aes-256-cbc      20685.05k    24787.50k    26177.71k    26503.17k    26662.23k    26645.85k`
  * `aes-256-cbc      20683.96k    24822.83k    26189.82k    26507.95k    26664.96k    26651.31k`

### Storage devices:

  * 7.3GB "Samsung 8WPD3R" DDR eMMC 5.0 card as /dev/mmcblk1: date 10/2016, manfid/oemid: 0x000015/0x0100, hw/fw rev: 0x0/0x0000000000000000

### Software versions:

  * Ubuntu 18.04.6 LTS
  * Build scripts: https://github.com/armbian/build, 5.65, NanoPi M1 Plus, sun8i, sunxi
  * Compiler: /usr/bin/gcc (Ubuntu/Linaro 7.5.0-3ubuntu1~18.04) 7.5.0 / arm-linux-gnueabihf
  * OpenSSL 1.1.1, built on 11 Sep 2018          

### Kernel info:

  * `/proc/cmdline: root=UUID=f6baaacc-6ee9-4203-9933-e61afdd231a0 rootwait rootfstype=ext4 console=tty1 console=ttyS0,115200 hdmi.audio=EDID:0 disp.screen0_output_mode=1920x1080p60 panic=10 consoleblank=0 loglevel=1 ubootpart= ubootsource=mmc usb-storage.quirks=0x2537:0x1066:u,0x2537:0x1068:u   sunxi_ve_mem_reserve=0 sunxi_g2d_mem_reserve=0 sunxi_fb_mem_reserve=16 cgroup_enable=memory swapaccount=1`
  * Kernel 4.19.62-sunxi / CONFIG_HZ=250

Kernel 4.19.62 is not latest 4.19.274 LTS that was released on 2023-02-25.

See https://endoflife.date/linux for details. It is somewhat likely that
a lot of exploitable vulnerabilities exist for this kernel as well as many
unfixed bugs.
