# Olimex A20-OLinuXino-LIME2

Tested with sbc-bench v0.9.57 on Mon, 27 Nov 2023 15:47:12 +0000. Full info: [http://ix.io/4MCU](../4MCU.txt)

### General information:

    Allwinner A20 (SID: 16516608), Kernel: armv7l, Userland: armhf
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      144     960   Cortex-A7 / r0p4
      1        0        0      144     960   Cortex-A7 / r0p4

998 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: ondemand / 720 MHz (conservative ondemand userspace powersave performance schedutil / 144 312 528 720 864 912 960)

Tuned governor settings:

    cpufreq-policy0: performance / 960 MHz

### Clockspeeds (idle vs. heated up):

Before at 36.6°C:

    cpu0 (Cortex-A7): OPP:  960, Measured:  957 

After at 43.3°C:

    cpu0 (Cortex-A7): OPP:  960, Measured:  957 

### Performance baseline

  * memcpy: 463.5 MB/s, memchr: 1023.1 MB/s, memset: 2022.0 MB/s
  * 16M latency: 251.8 263.0 251.7 266.9 253.7 272.1 466.6 895.3 
  * 128M latency: 329.8 387.0 329.4 357.7 329.4 347.1 591.0 948.8 
  * 7-zip MIPS (3 consecutive runs): 1048, 1038, 1045 (1040 avg), single-threaded: 593
  * `aes-256-cbc      11230.11k    16413.46k    18055.68k    18519.38k    18658.65k    18661.38k`
  * `aes-256-cbc      12061.05k    16412.03k    18055.08k    18518.02k    18655.91k    18495.96k`

### Storage devices:

  * 119.2GB "SAMSUNG MZ7TE128HMGR-00004" SSD as /dev/sda: SATA 3.1, 6.0 Gb/s (current: 3.0 Gb/s), 4% worn out, drive temp: 24°C
  * 3.7GB "Phison SD4GB" SD card as /dev/mmcblk0: date 02/2015, manfid/oemid: 0x000027/0x5048, hw/fw rev: 0x3/0x0

### Swap configuration:

  * /dev/zram0: 499.5M (0K used, lzo-rle, 2 streams, 4K data, 73B compressed, 4K total)

### Software versions:

  * Debian GNU/Linux 11 (bullseye) arm
  * Build scripts: https://github.com/armbian/build, 21.08.3, Lime 2, sun7i, sunxi
  * Compiler: /usr/bin/gcc (Debian 10.2.1-6) 10.2.1 20210110 / arm-linux-gnueabihf
  * OpenSSL 1.1.1k, built on 25 Mar 2021 (Library: OpenSSL 1.1.1w 11 Sep 2023)    

### Kernel info:

  * `/proc/cmdline: root=UUID=99b596a0-f001-48a3-8b7d-6ffc4c7b0513 rootwait rootfstype=ext4 console=ttyS0,115200 console=tty1 hdmi.audio=EDID:0 disp.screen0_output_mode=1920x1080p60 consoleblank=0 loglevel=1 ubootpart=3ac764ad-01 ubootsource=mmc usb-storage.quirks=0x2537:0x1066:u,0x2537:0x1068:u   sunxi_ve_mem_reserve=0 sunxi_g2d_mem_reserve=0 sunxi_fb_mem_reserve=16 cgroup_enable=memory swapaccount=1`
  * Kernel 5.10.60-sunxi / CONFIG_HZ=250

Kernel 5.10.60 is not latest 5.10.201 LTS that was released on 2023-11-20.

See https://endoflife.date/linux for details. It is somewhat likely that
a lot of exploitable vulnerabilities exist for this kernel as well as many
unfixed bugs.