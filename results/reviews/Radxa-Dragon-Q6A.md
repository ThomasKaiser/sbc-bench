# Radxa Dragon Q6A

Tested with sbc-bench v0.9.72 on Mon, 22 Sep 2025 13:19:49 +0000. Full info: [https://0x0.st/KA11.txt](../KA11.txt)

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

5611 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: schedutil / 1517 MHz (ondemand performance schedutil / 300 691 806 941 1152 1325 1517 1651 1805 1958)
    cpufreq-policy4: schedutil / 1651 MHz (ondemand performance schedutil / 691 941 1229 1344 1517 1651 1901 2054 2131 2400)
    cpufreq-policy7: schedutil / 1862 MHz (ondemand performance schedutil / 806 1056 1325 1517 1766 1862 2035 2208 2381 2515 2707)
    1d84000.ufshc: simple_ondemand / 75 MHz (powersave performance simple_ondemand / 75 150 300)
    3d00000.gpu: simple_ondemand / 0 MHz (powersave performance simple_ondemand / 315000 450000 550000 608000 700000 812000)

Tuned governor settings:

    cpufreq-policy0: performance / 1958 MHz
    cpufreq-policy4: performance / 2400 MHz
    cpufreq-policy7: performance / 2707 MHz
    1d84000.ufshc: performance / 300 MHz
    3d00000.gpu: performance / 812 MHz

Status of performance related policies found below /sys:

    /sys/module/pcie_aspm/parameters/policy: default [performance] powersave powersupersave

### Clockspeeds (idle vs. heated up):

Before at 33.8°C:

    cpu0-cpu3 (Cortex-A55): OPP: 1958, Measured: 1944 
    cpu4-cpu6 (Cortex-A78): OPP: 2400, Measured: 2392 
    cpu7 (Cortex-A78): OPP: 2707, Measured: 2086     (-22.9%)

After at 67.7°C:

    cpu0-cpu3 (Cortex-A55): OPP: 1958, Measured: 1944 
    cpu4-cpu6 (Cortex-A78): OPP: 2400, Measured: 2392 
    cpu7 (Cortex-A78): OPP: 2707, Measured: 2698 

### Performance baseline

  * cpu0 (Cortex-A55): memcpy: 3534.4 MB/s, memchr: 2924.8 MB/s, memset: 19229.6 MB/s
  * cpu4 (Cortex-A78): memcpy: 8415.2 MB/s, memchr: 20528.4 MB/s, memset: 19560.5 MB/s
  * cpu7 (Cortex-A78): memcpy: 8348.7 MB/s, memchr: 20595.7 MB/s, memset: 19645.8 MB/s
  * cpu0 (Cortex-A55) 16M latency: 124.7 119.5 129.5 118.6 122.0 124.5 202.1 397.3 
  * cpu4 (Cortex-A78) 16M latency: 119.6 105.0 119.6 104.8 119.2 100.7 98.86 112.6 
  * cpu7 (Cortex-A78) 16M latency: 119.0 103.0 119.0 103.0 118.7 99.80 97.46 110.7 
  * cpu0 (Cortex-A55) 128M latency: 134.4 117.1 134.2 117.2 133.8 126.6 210.4 405.4 
  * cpu4 (Cortex-A78) 128M latency: 135.2 118.1 135.3 118.1 135.2 118.8 116.8 123.2 
  * cpu7 (Cortex-A78) 128M latency: 135.3 116.1 135.3 116.1 134.3 117.9 115.3 122.4 
  * 7-zip MIPS (3 consecutive runs): 17386, 17177, 17313 (17290 avg), single-threaded: 3857
  * `aes-256-cbc     148786.66k   402328.45k   693054.63k   845523.97k   904820.05k   908853.25k (Cortex-A55)`
  * `aes-256-cbc     823728.55k  1164200.62k  1297791.32k  1337372.67k  1348466.01k  1349959.68k (Cortex-A78)`
  * `aes-256-cbc     931034.57k  1313324.25k  1466764.29k  1509008.38k  1521803.26k  1522144.60k (Cortex-A78)`

### PCIe and storage devices:

  * Realtek RTL8111/8168/8211/8411 PCI Express Gigabit Ethernet: Speed 2.5GT/s, Width x1, driver in use: r8169, 
  * 119.2GB SAMSUNG KLUDG4UHGC-B0E1 SPC-4 compliant UFS module: /dev/sda, Driver=ufshcd-qcom
  * 238.8GB "Samsung EE4S5" UHS-I speed SDR104 SDXC card as /dev/mmcblk1: date 05/2023, manfid/oemid: 0x00001b/0x534d, hw/fw rev: 0x3/0x0
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