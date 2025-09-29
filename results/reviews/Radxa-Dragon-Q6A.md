# Radxa Dragon Q6A

Tested with sbc-bench v0.9.72 on Mon, 29 Sep 2025 12:17:06 +0000. Full info: [https://0x0.st/KBw_.txt](../KBw_.txt)

### General information:

The CPU features 3 clusters consisting of 2 different core types:

    Snapdragon 498 rev 1.0, Qualcomm QCS6490, Kernel: aarch64, Userland: arm64
    
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

5609 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: schedutil / 1517 MHz (powersave ondemand performance schedutil / 300 691 806 941 1152 1325 1517 1651 1805 1958)
    cpufreq-policy4: schedutil / 1651 MHz (powersave ondemand performance schedutil / 691 941 1229 1344 1517 1651 1901 2054 2131 2400)
    cpufreq-policy7: schedutil / 1862 MHz (powersave ondemand performance schedutil / 806 1056 1325 1517 1766 1862 2035 2208 2381 2515 2707)
    1d84000.ufshc: performance / 300 MHz (powersave performance simple_ondemand / 75 150 300)
    3d00000.gpu: performance / 812 MHz (powersave performance simple_ondemand / 315 450 550 608 700 812)

Tuned governor settings:

    cpufreq-policy0: performance / 1958 MHz
    cpufreq-policy4: performance / 2400 MHz
    cpufreq-policy7: performance / 2707 MHz
    1d84000.ufshc: performance / 300 MHz
    3d00000.gpu: performance / 812 MHz

Status of performance related policies found below /sys:

    /sys/module/pcie_aspm/parameters/policy: default [performance] powersave powersupersave

### Clockspeeds (idle vs. heated up):

Before at 31.1°C:

    cpu0-cpu3 (Cortex-A55): OPP: 1958, Measured: 1944 
    cpu4-cpu6 (Cortex-A78): OPP: 2400, Measured: 2392 
    cpu7 (Cortex-A78): OPP: 2707, Measured:  823     (-69.6%)

After at 64.6°C:

    cpu0-cpu3 (Cortex-A55): OPP: 1958, Measured: 1944 
    cpu4-cpu6 (Cortex-A78): OPP: 2400, Measured: 2391 
    cpu7 (Cortex-A78): OPP: 2707, Measured: 2698 

### Performance baseline

  * cpu0 (Cortex-A55): memcpy: 3593.8 MB/s, memchr: 2928.1 MB/s, memset: 19355.6 MB/s
  * cpu4 (Cortex-A78): memcpy: 8409.7 MB/s, memchr: 20612.2 MB/s, memset: 19571.6 MB/s
  * cpu7 (Cortex-A78): memcpy: 8404.4 MB/s, memchr: 20539.5 MB/s, memset: 19662.3 MB/s
  * cpu0 (Cortex-A55) 16M latency: 126.0 117.2 123.6 117.5 123.3 124.1 200.2 380.8 
  * cpu4 (Cortex-A78) 16M latency: 119.0 102.9 119.1 102.7 119.1 100.8 98.06 110.4 
  * cpu7 (Cortex-A78) 16M latency: 118.9 103.3 118.9 103.4 118.8 99.69 96.79 109.5 
  * cpu0 (Cortex-A55) 128M latency: 133.1 124.9 133.0 125.0 132.8 129.9 213.3 410.2 
  * cpu4 (Cortex-A78) 128M latency: 134.3 125.3 134.3 125.2 134.4 125.5 124.1 133.1 
  * cpu7 (Cortex-A78) 128M latency: 133.0 124.2 133.1 124.2 133.1 123.7 123.0 132.4 
  * 7-zip MIPS (3 consecutive runs): 17457, 17391, 17355 (17400 avg), single-threaded: 3839
  * `aes-256-cbc     149800.39k   402334.51k   693098.50k   845404.16k   904841.90k   908700.33k (Cortex-A55)`
  * `aes-256-cbc     824915.14k  1159055.45k  1299641.86k  1337541.97k  1348752.73k  1350199.98k (Cortex-A78)`
  * `aes-256-cbc     928924.93k  1311054.17k  1463581.53k  1508960.60k  1521677.65k  1522728.96k (Cortex-A78)`

### PCIe and storage devices:

  * Realtek RTL8111/8168/8211/8411 PCI Express Gigabit Ethernet: Speed 2.5GT/s, Width x1, driver in use: r8169, 
  * 119.2GB SAMSUNG KLUDG4UHGC-B0E1 SPC-4 compliant UFS module: /dev/sda, Driver=ufshcd-qcom
  * Winbond W25Q256JW 32MB SPI NOR flash, drivers in use: spi-nor/qcom_qspi/simple-pm-bus

### Swap configuration:

  * /dev/zram0: 2.7G (0K used, zstd, 4K streams, 59B data, 20K compressed,  total, slowed down by zswap)

### Software versions:

  * Ubuntu 24.04.3 LTS (noble)
  * Build scripts: Radxa rbuild: architecture: arm64, build_date: '2025-09-19T14:59:14+00:00', distro_mirror: '', suite: 
  * Compiler: /usr/bin/gcc (Ubuntu 13.3.0-6ubuntu2~24.04) 13.3.0 / aarch64-linux-gnu
  * OpenSSL 3.0.13, built on 30 Jan 2024 (Library: OpenSSL 3.0.13 30 Jan 2024)    

### Kernel info:

  * `/proc/cmdline: initrd=\RadxaOS\6.16.7-1-qcom\initrd.img-6.16.7-1-qcom root=UUID=cbddb2c3-3936-4129-a758-4bdfc1ee314b console=ttyMSM0,115200n8 quiet splash loglevel=4 rw earlycon consoleblank=0 console=tty1 coherent_pool=2M irqchip.gicv3_pseudo_nmi=0 cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory swapaccount=1 kasan=off`
  * Vulnerability Spec store bypass:         Mitigation; Speculative Store Bypass disabled via prctl
  * Vulnerability Spectre v1:                Mitigation; __user pointer sanitization
  * Vulnerability Spectre v2:                Mitigation; CSV2, BHB
  * Kernel 6.16.7-1-qcom / CONFIG_HZ=1000