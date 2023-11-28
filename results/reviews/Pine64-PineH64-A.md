# Pine H64 model A

Tested with sbc-bench v0.9.57 on Mon, 27 Nov 2023 10:22:45 +0100. Full info: [http://ix.io/4MBc](http://ix.io/4MBc)

### General information:

    Allwinner H6 (SID: 82c00001), Kernel: aarch64, Userland: arm64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      480    1800   Cortex-A53 / r0p4
      1        0        0      480    1800   Cortex-A53 / r0p4
      2        0        0      480    1800   Cortex-A53 / r0p4
      3        0        0      480    1800   Cortex-A53 / r0p4

1989 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: ondemand / 1800 MHz (conservative ondemand userspace powersave performance schedutil / 480 720 816 888 1080 1320 1488 1608 1704 1800)

Tuned governor settings:

    cpufreq-policy0: performance / 1800 MHz

### Clockspeeds (idle vs. heated up):

Before at 37.6°C:

    cpu0 (Cortex-A53): OPP: 1800, Measured: 1797 

After at 79.4°C (throttled):

    cpu0 (Cortex-A53): OPP: 1800, Measured: 1797 

### Performance baseline

  * memcpy: 1661.3 MB/s, memchr: 1776.4 MB/s, memset: 5552.8 MB/s
  * 16M latency: 161.2 163.0 163.1 163.0 161.1 162.9 227.8 443.7 
  * 128M latency: 163.4 164.7 173.6 164.6 161.4 164.6 230.6 441.7 
  * 7-zip MIPS (3 consecutive runs): 4523, 4442, 4390 (4450 avg), single-threaded: 1320
  * `aes-256-cbc     122232.05k   340811.97k   602496.51k   768444.76k   835163.48k   840247.98k`
  * `aes-256-cbc     122298.16k   341281.15k   602408.96k   768341.67k   834641.92k   839314.09k`

### Storage devices:

  * 59.5GB "SanDisk SN64G" HS SDXC card as /dev/mmcblk0: date 03/2022, manfid/oemid: 0x000003/0x5344, hw/fw rev: 0x8/0x6

### Swap configuration:

  * /dev/zram0: 994.6M (0K used, lzo-rle, 4 streams, 4K data, 74B compressed, 12K total)

### Software versions:

  * Armbian 23.8.1 bookworm arm64
  * Build scripts: https://github.com/armbian/build, 23.8.1, Pine H64, sun50iw6, sunxi64
  * Compiler: /usr/bin/gcc (Debian 12.2.0-14) 12.2.0 / aarch64-linux-gnu
  * OpenSSL 3.0.9, built on 30 May 2023 (Library: OpenSSL 3.0.9 30 May 2023)    

### Kernel info:

  * `/proc/cmdline: root=UUID=78f7087b-988f-4b5f-96ac-d4913f7c06ab rootwait rootfstype=ext4 splash=verbose console=ttyS0,115200 console=tty1 consoleblank=0 loglevel=1 ubootpart=a5c49e88-01 usb-storage.quirks=   cgroup_enable=memory swapaccount=1`
  * Vulnerability Spectre v1:           Mitigation; __user pointer sanitization
  * Kernel 6.1.47-current-sunxi64 / CONFIG_HZ=250

Kernel 6.1.47 is not latest 6.1.63 LTS that was released on 2023-11-20.

See https://endoflife.date/linux for details. Perhaps some kernel bugs have
been fixed in the meantime and maybe vulnerabilities as well.