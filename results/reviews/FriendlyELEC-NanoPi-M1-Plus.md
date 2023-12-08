# FriendlyArm NanoPi M1 Plus

Tested with sbc-bench v0.9.35 on Wed, 01 Mar 2023 10:56:09 +0100. Full info: [http://ix.io/4pzf](../4pzf.txt)

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

Before at 45.5°C:

    cpu0 (Cortex-A7): OPP: 1368, Measured: 1365 

After at 75.3°C (throttled):

    cpu0 (Cortex-A7): OPP: 1368, Measured: 1338      (-2.2%)

### Performance baseline

  * memcpy: 825.3 MB/s, memchr: 1200.6 MB/s, memset: 3450.1 MB/s
  * 16M latency: 189.8 195.5 189.7 204.1 189.6 195.2 385.8 763.4 
  * 7-zip MIPS (3 consecutive runs): 3052, 2997, 3038 (3030 avg), single-threaded: 881
  * `aes-256-cbc      20321.13k    24785.41k    26176.77k    26549.25k    26662.23k    26613.08k`
  * `aes-256-cbc      20674.86k    24812.46k    26183.17k    26555.73k    26615.81k    26667.69k`

### Storage devices:

  * 7.3GB "Samsung 8WPD3R" DDR eMMC 5.0 card as /dev/mmcblk1: date 10/2016, manfid/oemid: 0x000015/0x0100, hw/fw rev: 0x0/0x0000000000000000

### Swap configuration:

  * /dev/zram1: 124.9M (4.0M used, lzo, 4 streams, 3.9M data, 1.8M compressed, 2.3M total)
  * /dev/zram2: 124.9M (3.8M used, lzo, 4 streams, 3.7M data, 1.6M compressed, 2.1M total)
  * /dev/zram3: 124.9M (3.9M used, lzo, 4 streams, 3.6M data, 2M compressed, 2.4M total)
  * /dev/zram4: 124.9M (3.5M used, lzo, 4 streams, 3.3M data, 1.7M compressed, 2.2M total)

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

All known settings adjusted for performance. Device now ready for benchmarking.
Once finished stop with [ctrl]-[c] to get info about throttling, frequency cap
and too high background activity all potentially invalidating benchmark scores.
All changes with storage and PCIe devices as well as suspicious dmesg contents
will be reported too.
