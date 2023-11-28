# Olimex A10-OLinuXino-LIME

Tested with sbc-bench v0.9.57 on Mon, 27 Nov 2023 13:25:26 +0000. Full info: [http://ix.io/4MC0](http://ix.io/4MC0)

### General information:

    Allwinner A10 (SID: 16236782), Kernel: armv7l, Userland: armhf
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0       -1        0      624     912   Cortex-A8 / r3p2

491 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: ondemand / 912 MHz (conservative ondemand userspace powersave performance schedutil / 624 864 912)

Tuned governor settings:

    cpufreq-policy0: performance / 912 MHz

### Clockspeeds (idle vs. heated up):

Before at 47.6°C:

    cpu0 (Cortex-A8): OPP:  912, Measured:  908 

After at 55.3°C:

    cpu0 (Cortex-A8): OPP:  912, Measured:  908 

### Performance baseline

  * memcpy: 445.7 MB/s, memchr: 282.8 MB/s, memset: 1306.3 MB/s
  * 16M latency: 301.5 344.6 205.2 339.4 206.4 339.9 719.4 1294 
  * 128M latency: 234.5 466.9 232.3 471.3 231.0 475.5 671.1 1355 
  * 7-zip MIPS (3 consecutive runs): 541 (540 avg), single-threaded: 541
  * `aes-256-cbc      12201.71k    27314.90k    29745.15k    28019.71k    27885.57k    27159.21k`
  * `aes-256-cbc      19594.95k    23484.59k    27768.49k    27373.57k    28508.16k    28426.24k`

### Storage devices:

  * 7.4GB "SanDisk SU08G" SD card as /dev/mmcblk0: date 06/2013, manfid/oemid: 0x000003/0x5344, hw/fw rev: 0x8/0x0

### Swap configuration:

  * /dev/zram0: 246M (11.5M used, lzo-rle, 1 streams, 11.4M data, 5.5M compressed, 6.4M total)

### Software versions:

  * Debian GNU/Linux 11 (bullseye) arm
  * Build scripts: git@github.com:armbian/build, 21.08.1, Lime A10, sun4i, sunxi
  * Compiler: /usr/bin/gcc (Debian 10.2.1-6) 10.2.1 20210110 / arm-linux-gnueabihf
  * OpenSSL 1.1.1k, built on 25 Mar 2021          

### Kernel info:

  * `/proc/cmdline: root=UUID=4a1ddfcc-aea5-49e6-9918-31848b4639f0 rootwait rootfstype=ext4 console=ttyS0,115200 console=tty1 hdmi.audio=EDID:0 disp.screen0_output_mode=1920x1080p60 consoleblank=0 loglevel=1 ubootpart=21bfb2b9-01 ubootsource=mmc usb-storage.quirks=   sunxi_ve_mem_reserve=0 sunxi_g2d_mem_reserve=0 sunxi_fb_mem_reserve=16 cgroup_enable=memory swapaccount=1`
  * Kernel 5.10.60-sunxi / CONFIG_HZ=250

Kernel 5.10.60 is not latest 5.10.201 LTS that was released on 2023-11-20.

See https://endoflife.date/linux for details. It is somewhat likely that
a lot of exploitable vulnerabilities exist for this kernel as well as many
unfixed bugs.
