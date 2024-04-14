# Orange Pi 5 Plus

Tested with sbc-bench v0.9.65 on Sat, 13 Apr 2024 22:00:25 +0100. Full info: [https://sprunge.us/Vo25Uv](http://sprunge.us/Vo25Uv)

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
      Max Frequency:     2.304 GHz
      Cores:             2 cores
      Features:          NEON,SHA1,SHA2,AES,CRC32
    CPU 3:
      Microarchitecture: Cortex-A76
      Max Frequency:     2.352 GHz
      Cores:             2 cores
      Features:          NEON,SHA1,SHA2,AES,CRC32
    Peak Performance:    206.59 GFLOP/s
    
The CPU features 3 clusters consisting of 2 different core types:

    Rockchip RK3588 (35881000 / 35 88 12 fe 21 41  32 4e 41 37 00 00 00 00), Kernel: aarch64, Userland: arm64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      408    1800   Cortex-A55 / r2p0
      1        0        0      408    1800   Cortex-A55 / r2p0
      2        0        0      408    1800   Cortex-A55 / r2p0
      3        0        0      408    1800   Cortex-A55 / r2p0
      4        1        4      408    2304   Cortex-A76 / r4p0
      5        1        4      408    2304   Cortex-A76 / r4p0
      6        2        6      408    2352   Cortex-A76 / r4p0
      7        2        6      408    2352   Cortex-A76 / r4p0

31790 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: performance / 1800 MHz (conservative ondemand userspace powersave performance schedutil / 408 600 816 1008 1200 1416 1608 1800)
    cpufreq-policy4: performance / 2304 MHz (conservative ondemand userspace powersave performance schedutil / 408 600 816 1008 1200 1416 1608 1800 2016 2208 2304)
    cpufreq-policy6: performance / 2352 MHz (conservative ondemand userspace powersave performance schedutil / 408 600 816 1008 1200 1416 1608 1800 2016 2208 2352)
    fb000000.gpu: performance / 1000 MHz (rknpu_ondemand userspace powersave performance simple_ondemand / 300 400 500 600 700 800 900 1000)
    fdab0000.npu: performance / 1000 MHz (rknpu_ondemand userspace powersave performance simple_ondemand / 300 400 500 600 700 800 900 1000)

Tuned governor settings:

    cpufreq-policy0: performance / 1800 MHz
    cpufreq-policy4: performance / 2304 MHz
    cpufreq-policy6: performance / 2352 MHz
    fb000000.gpu: performance / 1000 MHz
    fdab0000.npu: performance / 1000 MHz

Status of performance related policies found below /sys:

    /sys/devices/platform/fb000000.gpu/power_policy: [coarse_demand] always_on
    /sys/module/pcie_aspm/parameters/policy: default [performance] powersave powersupersave

### Clockspeeds (idle vs. heated up):

Before at 52.7°C:

    cpu0-cpu3 (Cortex-A55): OPP: 1800, Measured: 1824      (+1.3%)
    cpu4-cpu5 (Cortex-A76): OPP: 2304, Measured: 2281 
    cpu6-cpu7 (Cortex-A76): OPP: 2352, Measured: 2317      (-1.5%)

After at 74.8°C:

    cpu0-cpu3 (Cortex-A55): OPP: 1800, Measured: 1811 
    cpu4-cpu5 (Cortex-A76): OPP: 2304, Measured: 2264      (-1.7%)
    cpu6-cpu7 (Cortex-A76): OPP: 2352, Measured: 2301      (-2.2%)

### Performance baseline

  * cpu0 (Cortex-A55): memcpy: 6749.7 MB/s, memchr: 2813.2 MB/s, memset: 22080.8 MB/s
  * cpu4 (Cortex-A76): memcpy: 11950.9 MB/s, memchr: 16240.5 MB/s, memset: 29994.3 MB/s
  * cpu6 (Cortex-A76): memcpy: 12080.9 MB/s, memchr: 16479.6 MB/s, memset: 30171.7 MB/s
  * cpu0 (Cortex-A55) 16M latency: 114.5 117.3 111.8 117.4 112.4 118.7 180.8 322.8 
  * cpu4 (Cortex-A76) 16M latency: 116.0 106.5 113.8 105.5 114.2 104.4 102.9 103.6 
  * cpu6 (Cortex-A76) 16M latency: 113.7 109.4 125.1 107.9 112.5 105.9 104.7 103.0 
  * cpu0 (Cortex-A55) 128M latency: 135.7 136.7 135.4 136.7 134.6 137.2 198.2 339.7 
  * cpu4 (Cortex-A76) 128M latency: 130.4 130.8 129.8 130.9 129.8 127.1 127.5 132.1 
  * cpu6 (Cortex-A76) 128M latency: 127.9 128.9 127.6 128.8 127.6 124.8 125.0 130.6 
  * 7-zip MIPS (3 consecutive runs): 16581, 16405, 16616 (16530 avg), single-threaded: 3143
  * `aes-256-cbc     149055.17k   391720.21k   658037.93k   796599.64k   848087.72k   852197.38k (Cortex-A55)`
  * `aes-256-cbc     578354.66k   999926.89k  1208118.36k  1270137.86k  1293888.17k  1296384.00k (Cortex-A76)`
  * `aes-256-cbc     584341.53k  1016744.83k  1228779.86k  1291989.33k  1315886.42k  1318518.78k (Cortex-A76)`

### PCIe and storage devices:

  * Realtek RTL8852BE PCIe 802.11ax Wireless Network: Speed 2.5GT/s (ok), Width x1 (ok), driver in use: rtl8852be
  * Realtek RTL8125 2.5GbE: Speed 5GT/s (ok), Width x1 (ok), driver in use: r8125
  * Realtek RTL8125 2.5GbE: Speed 5GT/s (ok), Width x1 (ok), driver in use: r8125
  * 476.9GB "FIKWOT FN501 Pro 512GB" SSD as /dev/nvme0: Speed 8GT/s (ok), Width x4 (ok), 0% worn out, drive temp: 44°C
  * 233GB "Foresee A3A564" HS400 Enhanced strobe eMMC 5.1 card as /dev/mmcblk0: date 10/2023, manfid/oemid: 0x0000d6/0x2903, hw/fw rev: 0x0/0x1100000000000000
  * 58GB "Phison SD64G" UHS SDR104 SDXC card as /dev/mmcblk1: date 02/2023, manfid/oemid: 0x000027/0x5048, hw/fw rev: 0x6/0x0
  * 16MB SPI NOR flash, drivers in use: spi-nor/rockchip-sfc

### Swap configuration:

  * /dev/zram0: 15.5G (0K used, lzo-rle, 8 streams, 4K data, 74B compressed, 12K total)

### Software versions:

  * Ubuntu 22.04.3 LTS (Jammy Jellyfish) tampered by Armbian 24.2.1 jammy
  * Build scripts: https://github.com/armbian/build, 24.2.1, Orange Pi 5 Plus, rockchip-rk3588, rk35xx
  * Compiler: /usr/bin/gcc (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0 / aarch64-linux-gnu
  * OpenSSL 3.0.2, built on 15 Mar 2022 (Library: OpenSSL 3.0.2 15 Mar 2022)    

### Kernel info:

  * `/proc/cmdline: root=UUID=35881e15-2152-4abe-b5d4-d36dfed1cc95 rootwait rootfstype=ext4 splash plymouth.ignore-serial-consoles console=ttyS2,1500000 console=tty1 consoleblank=0 loglevel=1 ubootpart=0871f285-d6fd-6f48-b654-ca2dabec30ad usb-storage.quirks=   cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory swapaccount=1`
  * Vulnerability Spec store bypass: Mitigation; Speculative Store Bypass disabled via prctl
  * Vulnerability Spectre v1:        Mitigation; __user pointer sanitization
  * Vulnerability Spectre v2:        Vulnerable: Unprivileged eBPF enabled
  * Kernel 5.10.160-legacy-rk35xx / CONFIG_HZ=300

Kernel 5.10.160 is not latest 5.10.214 LTS that was released on 2024-03-26.

See https://endoflife.date/linux for details. It is somewhat likely that
a lot of exploitable vulnerabilities exist for this kernel as well as many
unfixed bugs.

But this version string doesn't matter since this is not an official LTS Linux
from kernel.org. This device runs a Rockchip vendor/BSP kernel.

This kernel is based on a mixture of Android GKI and other sources. Also some
community attempts to do version string cosmetics might have happened, see
https://tinyurl.com/2p8fuubd for example. To examine how far away this 5.10.160
is from an official LTS of same version someone would have to reapply Rockchip's
thousands of patches to a clean 5.10.160 LTS.