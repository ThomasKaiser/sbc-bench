# Pine64 Rock64

Tested with sbc-bench v0.9.58 on Fri, 01 Dec 2023 17:03:10 +0100. Full info: [http://sprunge.us/Ga0KBn](http://sprunge.us/Ga0KBn)

### General information:

    Rockchip RK3328, Kernel: aarch64, Userland: arm64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      408    1512   Cortex-A53 / r0p4
      1        0        0      408    1512   Cortex-A53 / r0p4
      2        0        0      408    1512   Cortex-A53 / r0p4
      3        0        0      408    1512   Cortex-A53 / r0p4

1981 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: ondemand / 1512 MHz (conservative ondemand userspace powersave performance schedutil / 408 600 816 1008 1200 1296 1392 1512)
    ff300000.gpu: simple_ondemand / 200 MHz (powersave performance simple_ondemand / 200 300 400 500)

Tuned governor settings:

    cpufreq-policy0: performance / 1512 MHz
    ff300000.gpu: performance / 500 MHz

### Clockspeeds (idle vs. heated up):

Before at 35.9°C:

    cpu0 (Cortex-A53): OPP: 1512, Measured: 1509 

After at 59.5°C:

    cpu0 (Cortex-A53): OPP: 1512, Measured: 1509 

### Performance baseline

  * memcpy: 1375.9 MB/s, memchr: 1971.1 MB/s, memset: 5882.1 MB/s
  * 16M latency: 147.2 149.0 146.6 148.5 146.4 151.5 173.7 324.6 
  * 128M latency: 163.5 168.1 161.4 168.4 162.9 167.6 211.2 344.4 
  * 7-zip MIPS (3 consecutive runs): 3948, 3952, 3946 (3950 avg), single-threaded: 1131
  * `aes-256-cbc     101125.50k   283286.23k   503031.38k   643702.78k   700467.88k   704064.17k`
  * `aes-256-cbc     102851.00k   286153.66k   505707.01k   645017.60k   700882.94k   704615.77k`

### Storage devices:

  * 111.8GB "Transcend TS120GMTS420" SSD as /dev/sda [SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)]: behind JMicron JMS578 SATA 6Gb/s bridge (152d:0578), 1% worn out, Driver=uas, 480Mbps (capable of 12Mbps, 480Mbps, 5Gbps), drive temp: 31°C
  * 14.8GB "SanDisk SP16G" HS SD card as /dev/mmcblk0: date 07/2015, manfid/oemid: 0x000003/0x5344, hw/fw rev: 0x8/0x0
  * Winbond W25Q128 16MB SPI NOR flash, drivers in use: spi-nor/rockchip-spi

### Swap configuration:

  * /dev/zram0: 990.5M (0K used, lzo-rle, 4 streams, 4K data, 74B compressed, 12K total)

### Software versions:

  * Armbian 23.11.1 bookworm arm64
  * Build scripts: https://github.com/armbian/build, 23.11.1, Rock 64, rockchip64, rockchip64
  * Compiler: /usr/bin/gcc (Debian 12.2.0-14) 12.2.0 / aarch64-linux-gnu
  * OpenSSL 3.0.11, built on 19 Sep 2023 (Library: OpenSSL 3.0.11 19 Sep 2023)    

### Kernel info:

  * `/proc/cmdline: root=UUID=31ba9b53-4ed3-4748-b77f-abd1962b4b82 rootwait rootfstype=ext4 splash=verbose console=ttyS2,1500000 console=tty1 consoleblank=0 loglevel=1 ubootpart=1958fdf7-01 usb-storage.quirks=0x2537:0x1066:u,0x2537:0x1068:u   cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory swapaccount=1`
  * Vulnerability Spectre v1:           Mitigation; __user pointer sanitization
  * Kernel 6.1.63-current-rockchip64 / CONFIG_HZ=250