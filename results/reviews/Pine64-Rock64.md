# Pine64 Rock64

Tested with sbc-bench v0.9.29 on Fri, 24 Feb 2023 08:53:57 +0000. Full info: [http://ix.io/4p2X](http://ix.io/4p2X)

### General information:

    Rockchip RK3328, Kernel: aarch64, Userland: arm64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      408    1512   Cortex-A53 / r0p4
      1        0        0      408    1512   Cortex-A53 / r0p4
      2        0        0      408    1512   Cortex-A53 / r0p4
      3        0        0      408    1512   Cortex-A53 / r0p4

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: ondemand / 1296 MHz (conservative ondemand userspace powersave performance schedutil / 408 600 816 1008 1200 1296 1392 1512)
    ff300000.gpu: simple_ondemand / 200 MHz (powersave performance simple_ondemand / 200 300 400 500)

Tuned governor settings:

    cpufreq-policy0: performance / 1296 MHz
    ff300000.gpu: performance / 500 MHz

### Clockspeeds (idle vs. heated up):

Before at 43.2°C:

    cpu0 (Cortex-A53): OPP: 1512, Measured: 1509 

After at 83.5°C (throttled):

    cpu0 (Cortex-A53): OPP: 1512, Measured: 1509 

### Memory performance

  * memcpy: 1384.2 MB/s, memchr: 2396.7 MB/s, memset: 5913.9 MB/s
  * 16M latency: 145.5 147.6 146.4 148.2 144.7 147.2 172.0 322.9 

### Storage devices:

  * 14.4GB "Genesys Logic GL827L SD/MMC/MS Flash Card Reader" as /dev/sda: USB, Driver=usb-storage, 480Mbps
  * 14.9GB "SanDisk SP16G" HS SD card as /dev/mmcblk1: date 07/2015, manfid/oemid: 0x000003/0x5344, hw/fw rev: 0x8/0x0
  * 16MB SPI NOR flash, drivers in use: spi-nor/rockchip-spi

### Software versions:

  * Ubuntu 20.04.3 LTS (focal) arm64
  * Build scripts: https://github.com/armbian/build, 21.08.3, Rock 64, rockchip64, rockchip64
  * Compiler: /usr/bin/gcc (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0 / aarch64-linux-gnu
  * OpenSSL 1.1.1f, built on 31 Mar 2020

### Kernel info:

  * `/proc/cmdline: root=UUID=8ef0cd26-9dc8-4a3e-90e2-bb5f209a75aa rootwait rootfstype=ext4 console=ttyS2,1500000 console=tty1 consoleblank=0 loglevel=1 ubootpart=c945e319-01 usb-storage.quirks=0x2537:0x1066:u,0x2537:0x1068:u   cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory swapaccount=1`
  * Vulnerability Spectre v1:        Mitigation; __user pointer sanitization
  * Kernel 5.10.63-rockchip64 / CONFIG_HZ=250

Kernel 5.10.63 is not latest 5.10.169 LTS that was released on 2023-02-22.

See https://endoflife.date/linux for details. It is somewhat likely that
a lot of exploitable vulnerabilities exist for this kernel as well as many
unfixed bugs.
