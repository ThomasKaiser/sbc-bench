# Radxa Dragon Q6A

Tested with sbc-bench v0.9.72 on Wed, 17 Sep 2025 14:58:59 +0000. Full info: [https://0x0.st/Kcd5.txt](../Kcd5.txt)

### General information:

The CPU features 3 clusters consisting of 2 different core types:

    Snapdragon 498 rev 1.0, Qualcomm QCM6490/QCS6490, Kernel: aarch64, Userland: arm64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      300    1958   Cortex-A55 / r2p0
      1        0        0      300    1958   Cortex-A55 / r2p0
      2        0        0      300    1958   Cortex-A55 / r2p0
      3        0        0      300    1958   Cortex-A55 / r2p0
      4        0        4      691    2400   Cortex-A78 / r1p1
      5        0        4      691    2400   Cortex-A78 / r1p1
      6        0        4      691    2400   Cortex-A78 / r1p1
      7        0        7      806    2707   Cortex-A78 / r1p1

5618 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: schedutil / 1152 MHz (ondemand userspace performance schedutil / 300 691 806 941 1152 1325 1517 1651 1805 1958)
    cpufreq-policy4: schedutil / 1517 MHz (ondemand userspace performance schedutil / 691 941 1229 1344 1517 1651 1901 2054 2131 2400)
    cpufreq-policy7: schedutil / 1325 MHz (ondemand userspace performance schedutil / 806 1056 1325 1517 1766 1862 2035 2208 2381 2515 2707)
    3d00000.gpu: simple_ondemand / 0 MHz (userspace simple_ondemand / 315000 450000 550000 608000 700000 812000)

Tuned governor settings:

    cpufreq-policy0: performance / 1958 MHz
    cpufreq-policy4: performance / 2400 MHz
    cpufreq-policy7: performance / 2707 MHz
    3d00000.gpu: simple_ondemand / 0 MHz

Status of performance related policies found below /sys:

    /sys/module/pcie_aspm/parameters/policy: default [performance] powersave powersupersave

### Clockspeeds (idle vs. heated up):

Before at 31.1°C:

    cpu0-cpu3 (Cortex-A55): OPP: 1958, Measured: 1940 
    cpu4-cpu6 (Cortex-A78): OPP: 2400, Measured: 2390 
    cpu7 (Cortex-A78): OPP: 2707, Measured:  882     (-67.4%)

After at 65.8°C:

    cpu0-cpu3 (Cortex-A55): OPP: 1958, Measured: 1940 
    cpu4-cpu6 (Cortex-A78): OPP: 2400, Measured: 2390 
    cpu7 (Cortex-A78): OPP: 2707, Measured: 2697 

### Performance baseline

  * cpu0 (Cortex-A55): memcpy: 3687.9 MB/s, memchr: 2916.3 MB/s, memset: 20780.7 MB/s
  * cpu4 (Cortex-A78): memcpy: 8650.6 MB/s, memchr: 21372.7 MB/s, memset: 21225.6 MB/s
  * cpu7 (Cortex-A78): memcpy: 8645.7 MB/s, memchr: 21353.5 MB/s, memset: 21420.0 MB/s
  * cpu0 (Cortex-A55) 16M latency: 121.8 122.2 120.9 122.4 122.9 125.1 201.5 380.2 
  * cpu4 (Cortex-A78) 16M latency: 119.1 106.9 119.1 106.9 119.2 102.4 99.37 113.1 
  * cpu7 (Cortex-A78) 16M latency: 115.7 111.3 115.7 111.4 115.7 106.4 100.1 112.4 
  * cpu0 (Cortex-A55) 128M latency: 133.1 122.0 133.0 122.2 133.0 128.4 210.2 405.8 
  * cpu4 (Cortex-A78) 128M latency: 134.2 123.2 134.2 123.3 134.2 122.7 121.7 131.1 
  * cpu7 (Cortex-A78) 128M latency: 133.0 122.1 133.0 122.1 133.0 122.7 120.5 129.6 
  * 7-zip MIPS (3 consecutive runs): 17352, 17407, 17392 (17380 avg), single-threaded: 3827
  * `aes-256-cbc     148284.47k   398130.54k   687717.55k   843554.13k   902843.05k   906827.09k (Cortex-A55)`
  * `aes-256-cbc     821391.64k  1163428.27k  1297137.32k  1337464.15k  1347319.13k  1348747.26k (Cortex-A78)`
  * `aes-256-cbc     928499.29k  1311497.07k  1464771.33k  1507509.25k  1520416.09k  1521248.94k (Cortex-A78)`

### PCIe and storage devices:

  * Realtek RTL8111/8168/8211/8411 PCI Express Gigabit Ethernet: Speed 2.5GT/s, Width x1, driver in use: r8169, 
  * 29.7GB "SanDisk SN32G" UHS-I speed SDR104 SD card as /dev/mmcblk2: date 08/2023, manfid/oemid: 0x000003/0x5344, hw/fw rev: 0x8/0x0
  * Winbond W25Q256JW 32MB SPI NOR flash, drivers in use: spi-nor/qcom_qspi/simple-pm-bus

### Software versions:

  * Ubuntu 24.04.2 LTS (noble)
  * Compiler: /usr/bin/gcc (Ubuntu 13.3.0-6ubuntu2~24.04) 13.3.0 / aarch64-linux-gnu
  * OpenSSL 3.0.13, built on 30 Jan 2024 (Library: OpenSSL 3.0.13 30 Jan 2024)    

### Kernel info:

  * `/proc/cmdline: BOOT_IMAGE=/Image panic=30 loglevel=8 rw rootwait=10 root=/dev/mmcblk2p2 rootfstype=ext4`
  * Vulnerability Spec store bypass:         Mitigation; Speculative Store Bypass disabled via prctl
  * Vulnerability Spectre v1:                Mitigation; __user pointer sanitization
  * Vulnerability Spectre v2:                Mitigation; CSV2, BHB
  * Kernel 6.15.7+ / CONFIG_HZ=1000