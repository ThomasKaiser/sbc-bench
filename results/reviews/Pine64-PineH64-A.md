# Pine H64 model A

Tested with sbc-bench v0.9.34 on Tue, 28 Feb 2023 22:19:41 +0100. Full info: [http://ix.io/4pvX](http://ix.io/4pvX)

### General information:

    Allwinner H6, Kernel: aarch64, Userland: arm64
    
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

    cpufreq-policy0: ondemand / 1488 MHz (conservative ondemand userspace powersave performance schedutil / 480 720 816 888 1080 1320 1488 1608 1704 1800)

Tuned governor settings:

    cpufreq-policy0: performance / 1800 MHz

### Clockspeeds (idle vs. heated up):

Before at 41.2°C:

    cpu0 (Cortex-A53): OPP: 1800, Measured: 1797 

After at 75.1°C (throttled):

    cpu0 (Cortex-A53): OPP: 1800, Measured: 1798 

### Performance baseline

  * memcpy: 1412.4 MB/s, memchr: 1868.5 MB/s, memset: 5555.9 MB/s
  * 16M latency: 161.9 164.6 163.3 164.1 161.6 164.1 225.2 440.9 
  * 7-zip MIPS (3 consecutive runs): 4526, 4430, 4369 (4440 avg), single-threaded: 1328
  * `aes-256-cbc     123361.64k   338878.95k   604878.85k   769394.35k   835190.78k   839445.16k`
  * `aes-256-cbc     123423.07k   338379.29k   604895.49k   769360.21k   835207.17k   840258.90k`

### Storage devices:

  * 59.5GB "SanDisk SN64G" HS SDXC card as /dev/mmcblk0: date 03/2022, manfid/oemid: 0x000003/0x5344, hw/fw rev: 0x8/0x6

### Software versions:

  * Armbian 23.02.0-trunk Sid (bookworm) arm64
  * Build scripts: https://github.com/armbian/build, 23.02.0-trunk, Pine H64, sun50iw6, sunxi64
  * Compiler: /usr/bin/gcc (Debian 12.2.0-14) 12.2.0 / aarch64-linux-gnu

### Kernel info:

  * `/proc/cmdline: root=UUID=361099a0-1b77-458d-aa6b-53cb93d866c0 rootwait rootfstype=ext4 splash=verbose console=ttyS0,115200 console=tty1 consoleblank=0 loglevel=1 ubootpart=e3e5c10b-01 usb-storage.quirks=   cgroup_enable=memory swapaccount=1`
  * Vulnerability Spectre v1:        Mitigation; __user pointer sanitization
  * Kernel 6.1.11-sunxi64 / CONFIG_HZ=250
