# RK3588 OPi 5 Max

Tested with sbc-bench v0.9.67 on Sun, 25 Aug 2024 02:15:17 +0800. Full info: [https://0x0.st/XyIw.bin](https://0x0.st/XyIw.bin)

### General information:

    Information courtesy of cpufetch:
    
    SoC:                 Rockchip RK3588
    Technology:          8nm
    CPU 1:
      Microarchitecture: Cortex-A55
      Max Frequency:     1.800 GHz
      Cores:             4 cores
      Features:          NEON,SHA1,SHA2,AES,CRC32
    CPU 2:
      Microarchitecture: Cortex-A76
      Max Frequency:     2.256 GHz
      Cores:             4 cores
      Features:          NEON,SHA1,SHA2,AES,CRC32
    
The CPU features 3 clusters consisting of 2 different core types:

    Rockchip RK3588 (35880000 / 35 88 12 fe 21 41  32 34 43 42 00 00 00 00), Kernel: aarch64, Userland: arm64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      408    1800   Cortex-A55 / r2p0
      1        0        0      408    1800   Cortex-A55 / r2p0
      2        0        0      408    1800   Cortex-A55 / r2p0
      3        0        0      408    1800   Cortex-A55 / r2p0
      4        0        4      408    2256   Cortex-A76 / r4p0
      5        0        4      408    2256   Cortex-A76 / r4p0
      6        0        6      408    2256   Cortex-A76 / r4p0
      7        0        6      408    2256   Cortex-A76 / r4p0

7934 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: ondemand / 1008 MHz (interactive conservative ondemand userspace powersave performance schedutil / 408 600 816 1008 1200 1416 1608 1800)
    cpufreq-policy4: ondemand / 600 MHz (interactive conservative ondemand userspace powersave performance schedutil / 408 600 816 1008 1200 1416 1608 1800 2016 2208 2256)
    cpufreq-policy6: ondemand / 600 MHz (interactive conservative ondemand userspace powersave performance schedutil / 408 600 816 1008 1200 1416 1608 1800 2016 2208 2256)
    dmc: dmc_ondemand / 534 MHz (rknpu_ondemand dmc_ondemand userspace powersave performance simple_ondemand / 534 1320 1968 2400)
    fb000000.gpu: simple_ondemand / 300 MHz (rknpu_ondemand dmc_ondemand userspace powersave performance simple_ondemand / 300 400 500 600 700 800 900 1000)
    fdab0000.npu: rknpu_ondemand / 1000 MHz (rknpu_ondemand dmc_ondemand userspace powersave performance simple_ondemand / 300 400 500 600 700 800 900 1000)

Tuned governor settings:

    cpufreq-policy0: performance / 1800 MHz
    cpufreq-policy4: performance / 2256 MHz
    cpufreq-policy6: performance / 2256 MHz
    dmc: performance / 2400 MHz
    fb000000.gpu: performance / 1000 MHz
    fdab0000.npu: performance / 1000 MHz

Status of performance related policies found below /sys:

    /sys/devices/platform/fb000000.gpu/power_policy: [coarse_demand] always_on
    /sys/module/pcie_aspm/parameters/policy: default [performance] powersave powersupersave

### Clockspeeds (idle vs. heated up):

Before at 30.5°C:

    cpu0-cpu3 (Cortex-A55): OPP: 1800, Measured: 1833      (+1.8%)
    cpu4-cpu5 (Cortex-A76): OPP: 2256, Measured: 2283      (+1.2%)
    cpu6-cpu7 (Cortex-A76): OPP: 2256, Measured: 2285      (+1.3%)

After at 51.8°C:

    cpu0-cpu3 (Cortex-A55): OPP: 1800, Measured: 1823      (+1.3%)
    cpu4-cpu5 (Cortex-A76): OPP: 2256, Measured: 2269 
    cpu6-cpu7 (Cortex-A76): OPP: 2256, Measured: 2272 

### Performance baseline

  * cpu0 (Cortex-A55): memcpy: 6632.7 MB/s, memchr: 3319.6 MB/s, memset: 22301.7 MB/s
  * cpu4 (Cortex-A76): memcpy: 12195.4 MB/s, memchr: 15574.7 MB/s, memset: 27947.8 MB/s
  * cpu6 (Cortex-A76): memcpy: 12096.7 MB/s, memchr: 15574.9 MB/s, memset: 27851.7 MB/s
  * cpu0 (Cortex-A55) 16M latency: 133.4 136.3 137.7 137.2 130.3 136.9 218.2 375.5 
  * cpu4 (Cortex-A76) 16M latency: 134.7 123.8 134.0 124.5 133.9 129.1 133.7 132.1 
  * cpu6 (Cortex-A76) 16M latency: 134.6 123.7 134.2 124.5 133.0 124.1 128.3 128.7 
  * cpu0 (Cortex-A55) 128M latency: 159.4 160.3 159.0 160.1 158.6 160.0 234.1 401.0 
  * cpu4 (Cortex-A76) 128M latency: 153.2 151.7 152.8 151.6 152.6 150.4 150.9 155.9 
  * cpu6 (Cortex-A76) 128M latency: 152.6 151.6 152.3 151.4 152.3 150.2 150.6 155.6 
  * 7-zip MIPS (3 consecutive runs): 15900, 15965, 16004 (15960 avg), single-threaded: 2994
  * `aes-256-cbc     152520.09k   398608.51k   667089.92k   803358.38k   853895.85k   858314.07k (Cortex-A55)`
  * `aes-256-cbc     583795.51k  1009286.76k  1214317.06k  1272786.60k  1297405.27k  1300004.86k (Cortex-A76)`
  * `aes-256-cbc     571916.53k  1003548.44k  1212634.88k  1273139.54k  1298036.05k  1300660.22k (Cortex-A76)`

### PCIe and storage devices:

  * Realtek RTL8125 2.5GbE: Speed 5GT/s (ok), Width x1 (ok), driver in use: r8169, 
  * 29.7GB "SanDisk SD32G" UHS SDR104 SD card as /dev/mmcblk1: date 07/2023, manfid/oemid: 0x000003/0x5344, hw/fw rev: 0x8/0x5
  * Xmc XM25QU128C 16MB SPI NOR flash, drivers in use: spi-nor/rockchip-sfc

### Swap configuration:

  * /dev/zram0: 3.9G (0K used, lzo-rle, 8 streams, 4K data, 74B compressed, 12K total)

### Software versions:

  * Debian 11 (bullseye) tampered by Orange Pi 1.0.0 Bullseye
  * Build scripts: https://github.com/armbian/build, 1.0.0, Orange Pi 5 Max, rockchip-rk3588, rockchip-rk3588
  * Compiler: /usr/bin/gcc (Debian 10.2.1-6) 10.2.1 20210110 / aarch64-linux-gnu
  * OpenSSL 1.1.1w, built on 11 Sep 2023          

### Kernel info:

  * `/proc/cmdline: root=UUID=ee0ec470-77d2-48ad-bb4c-2c17fcdad7a0 rootwait rootfstype=ext4 splash plymouth.ignore-serial-consoles console=ttyS2,1500000 console=tty1 consoleblank=0 loglevel=1 ubootpart=088cfebe-7166-6e4f-9a05-698def790f92 usb-storage.quirks= cma=128M  cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory swapaccount=1`
  * Vulnerability Spec store bypass: Mitigation; Speculative Store Bypass disabled via prctl
  * Vulnerability Spectre v1:        Mitigation; __user pointer sanitization
  * Vulnerability Spectre v2:        Vulnerable: Unprivileged eBPF enabled
  * Kernel 6.1.43-rockchip-rk3588 / CONFIG_HZ=300

Kernel 6.1.43 is not latest 6.1.106 LTS that was released on 2024-08-19.

See https://endoflife.date/linux for details. It is somewhat likely that
a lot of exploitable vulnerabilities exist for this kernel as well as many
unfixed bugs.