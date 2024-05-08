# LattePanda Mu / N100

Tested with sbc-bench v0.9.65 on Fri, 03 May 2024 15:52:24 -0500. Full info: [https://sprunge.us/uHzXI7](http://sprunge.us/uHzXI7)

### General information:

    Information courtesy of cpufetch:
    
    Name:                Intel(R) N100
    Microarchitecture:   Alder Lake
    Technology:          10nm
    Max Frequency:       3.400 GHz
    Cores:               4 cores
    AVX:                 AVX,AVX2
    FMA:                 FMA3
    L1i Size:            64KB (256KB Total)
    L1d Size:            32KB (128KB Total)
    L2 Size:             2MB
    L3 Size:             6MB
    
    N100, Kernel: x86_64, Userland: amd64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      700    3400       -
      1        0        1      700    3400       -
      2        0        2      700    3400       -
      3        0        3      700    3400       -

7640 KB available RAM

### Clockspeeds (idle vs. heated up):

Before at 46.0°C:

    cpu0: OPP: 3400, Measured: 3391 

After at 74.0°C:

    cpu0: OPP: 3400, Measured: 3391 

### Performance baseline

  * memcpy: 10920.8 MB/s, memchr: 17571.0 MB/s, memset: 11231.2 MB/s
  * 16M latency: 121.1 112.4 121.4 112.9 121.0 104.7 98.90 103.2 
  * 128M latency: 136.1 132.4 135.7 133.6 135.0 126.5 116.3 117.2 
  * 7-zip MIPS (3 consecutive runs): 14034, 14117, 14132 (14090 avg), single-threaded: 3910
  * `aes-256-cbc     880699.83k  1179283.75k  1218998.61k  1223701.16k  1232644.78k  1232360.79k`
  * `aes-256-cbc     951637.51k  1179264.11k  1218083.07k  1229524.65k  1232079.53k  1232748.54k`

### PCIe and storage devices:

  * Realtek RTL8111/8168/8211/8411 PCI Express Gigabit Ethernet: Speed 2.5GT/s (ok), Width x1 (ok), driver in use: r8169, 
  * 920.4GB "SANDISK SSD PLUS 1000 GB" SSD as /dev/sda [SATA 3.2, 6.0 Gb/s (current: 6.0 Gb/s)]: in "SanDisk Corp. Extreme Pro" (0781:5588), 0% worn out, Driver=uas, 5Gbps (capable of 12Mbps, 480Mbps, 5Gbps), unhealthy drive temp: 65°C
  * 58.2GB "Samsung CUTA42" HS400 Enhanced strobe eMMC 5.1 card as /dev/mmcblk0: date 02/2022, manfid/oemid: 0x000015/0x0100, hw/fw rev: 0x0/0x0100000000000000
  * Winbond W25Q128 16MB SPI NOR flash, drivers in use: spi-nor/intel-spi

"smartctl -x /dev/sda" could be used to get further information about the reported issues.

### Swap configuration:

  * /swapfile on /dev/mmcblk0p2: 2.0G (0K used) on MMC storage

### Software versions:

  * Ubuntu 22.04.2 LTS (jammy)
  * Compiler: /usr/bin/gcc (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0 / x86_64-linux-gnu
  * OpenSSL 3.0.2, built on 15 Mar 2022 (Library: OpenSSL 3.0.2 15 Mar 2022)    

### Kernel info:

  * `/proc/cmdline: BOOT_IMAGE=/boot/vmlinuz-6.5.0-28-generic root=UUID=0ae98e99-6e14-42eb-8a22-1a86c44600cd ro quiet splash vt.handoff=7`
  * Vulnerability Spec store bypass:    Mitigation; Speculative Store Bypass disabled via prctl
  * Vulnerability Spectre v1:           Mitigation; usercopy/swapgs barriers and __user pointer sanitization
  * Kernel 6.5.0-28-generic / CONFIG_HZ=250