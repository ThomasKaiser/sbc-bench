# Pine H64 model A

Tested with sbc-bench v0.9.29 on Fri, 24 Feb 2023 22:55:44 +0100. Full info: [http://ix.io/4p79](http://ix.io/4p79)

### General information:

    Allwinner H6, Kernel: aarch64, Userland: arm64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      480    1800   Cortex-A53 / r0p4
      1        0        0      480    1800   Cortex-A53 / r0p4
      2        0        0      480    1800   Cortex-A53 / r0p4
      3        0        0      480    1800   Cortex-A53 / r0p4

1989KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: schedutil / 1320 MHz (conservative ondemand userspace powersave performance schedutil / 480 720 816 888 1080 1320 1488 1608 1704 1800)

Tuned governor settings:

    cpufreq-policy0: performance / 1800 MHz

### Clockspeeds (idle vs. heated up):

Before at 46.4°C:

    cpu0 (Cortex-A53): OPP: 1800, Measured: 1798 

After at 85.3°C (throttled):

    cpu0 (Cortex-A53): OPP: 1800, Measured: 1797 

### Memory performance

  * memcpy: 1414.0 MB/s, memchr: 1880.9 MB/s, memset: 5549.5 MB/s
  * 16M latency: 157.3 159.8 158.3 159.0 156.3 158.8 222.1 435.4 

### Storage devices:

  * 59.5GB "SanDisk SN64G" HS SDXC card as /dev/mmcblk0: date 03/2022, manfid/oemid: 0x000003/0x5344, hw/fw rev: 0x8/0x6

### Software versions:

  * Armbian 23.02.0-trunk Sid (bookworm) arm64
  * Build scripts: https://github.com/armbian/build, 23.02.0-trunk, Pine H64, sun50iw6, sunxi64
  * Compiler: /usr/bin/gcc (Debian 12.2.0-14) 12.2.0 / aarch64-linux-gnu
  * OpenSSL 3.0.8, built on 7 Feb 2023 (Library: OpenSSL 3.0.8 7 Feb 2023)

### Kernel info:

  * `/proc/cmdline: root=UUID=361099a0-1b77-458d-aa6b-53cb93d866c0 rootwait rootfstype=ext4 splash=verbose console=ttyS0,115200 console=tty1 consoleblank=0 loglevel=1 ubootpart=e3e5c10b-01 usb-storage.quirks=   cgroup_enable=memory swapaccount=1`
  * Vulnerability Spectre v1:        Mitigation; __user pointer sanitization
  * Kernel 6.1.11-sunxi64 / CONFIG_HZ=250
