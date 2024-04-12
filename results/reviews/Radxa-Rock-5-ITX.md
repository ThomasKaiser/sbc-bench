# Radxa ROCK 5 ITX

Tested with sbc-bench v0.9.65 on Fri, 12 Apr 2024 15:22:43 +0000. Full info: [https://sprunge.us/C7YwRI](http://sprunge.us/C7YwRI)

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
      Max Frequency:     2.400 GHz
      Cores:             4 cores
      Features:          NEON,SHA1,SHA2,AES,CRC32
    Peak Performance:    211.20 GFLOP/s
    
The CPU features 3 clusters consisting of 2 different core types:

    Rockchip RK3588 (35881000 / 35 88 12 fe 21 41  32 4e 48 46 00 00 00 00), Kernel: aarch64, Userland: arm64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      408    1800   Cortex-A55 / r2p0
      1        0        0      408    1800   Cortex-A55 / r2p0
      2        0        0      408    1800   Cortex-A55 / r2p0
      3        0        0      408    1800   Cortex-A55 / r2p0
      4        1        4      408    2400   Cortex-A76 / r4p0
      5        1        4      408    2400   Cortex-A76 / r4p0
      6        2        6      408    2400   Cortex-A76 / r4p0
      7        2        6      408    2400   Cortex-A76 / r4p0

7945 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: ondemand / 1800 MHz (ondemand performance schedutil / 408 600 816 1008 1200 1416 1608 1800)
    cpufreq-policy4: ondemand / 2400 MHz (ondemand performance schedutil / 408 600 816 1008 1200 1416 1608 1800 2016 2208 2400)
    cpufreq-policy6: ondemand / 2400 MHz (ondemand performance schedutil / 408 600 816 1008 1200 1416 1608 1800 2016 2208 2400)
    dmc: dmc_ondemand / 528 MHz (powersave performance rknpu_ondemand dmc_ondemand simple_ondemand / 528 1320 2736)
    fdab0000.npu: rknpu_ondemand / 1000 MHz (powersave performance rknpu_ondemand dmc_ondemand simple_ondemand / 300 400 500 600 700 800 900 1000)

Tuned governor settings:

    cpufreq-policy0: performance / 1800 MHz
    cpufreq-policy4: performance / 2400 MHz
    cpufreq-policy6: performance / 2400 MHz
    dmc: performance / 2736 MHz
    fdab0000.npu: performance / 1000 MHz

Status of performance related policies found below /sys:

    /sys/module/pcie_aspm/parameters/policy: default [performance] powersave powersupersave

### Clockspeeds (idle vs. heated up):

Before at 33.3°C:

    cpu0-cpu3 (Cortex-A55): OPP: 1800, Measured: 1805 
    cpu4-cpu5 (Cortex-A76): OPP: 2400, Measured: 2303      (-4.0%)
    cpu6-cpu7 (Cortex-A76): OPP: 2400, Measured: 2318      (-3.4%)

After at 75.8°C:

    cpu0-cpu3 (Cortex-A55): OPP: 1800, Measured: 1781      (-1.1%)
    cpu4-cpu5 (Cortex-A76): OPP: 2400, Measured: 2268      (-5.5%)
    cpu6-cpu7 (Cortex-A76): OPP: 2400, Measured: 2285      (-4.8%)

### Performance baseline

  * cpu0 (Cortex-A55): memcpy: 6711.0 MB/s, memchr: 3274.7 MB/s, memset: 21923.5 MB/s
  * cpu4 (Cortex-A76): memcpy: 13171.5 MB/s, memchr: 17246.4 MB/s, memset: 28986.3 MB/s
  * cpu6 (Cortex-A76): memcpy: 13119.1 MB/s, memchr: 17216.0 MB/s, memset: 28922.9 MB/s
  * cpu0 (Cortex-A55) 16M latency: 131.1 132.5 126.3 130.9 126.3 132.2 207.2 358.7 
  * cpu4 (Cortex-A76) 16M latency: 131.1 120.4 129.8 119.6 129.6 120.8 124.6 123.8 
  * cpu6 (Cortex-A76) 16M latency: 132.6 120.0 129.7 124.0 129.0 119.4 124.2 127.6 
  * cpu0 (Cortex-A55) 128M latency: 156.7 156.3 155.4 156.0 155.9 157.4 225.7 383.9 
  * cpu4 (Cortex-A76) 128M latency: 147.6 145.9 147.4 145.7 147.3 145.1 145.2 148.7 
  * cpu6 (Cortex-A76) 128M latency: 149.9 148.7 149.2 148.0 149.5 147.3 147.1 149.4 
  * 7-zip MIPS (3 consecutive runs): 16016, 15977, 15881 (15960 avg), single-threaded: 3038
  * `aes-256-cbc     151303.81k   391929.28k   654044.59k   789710.85k   839655.42k   843623.08k (Cortex-A55)`
  * `aes-256-cbc     586053.71k  1011990.29k  1219568.55k  1280048.47k  1305113.94k  1307787.26k (Cortex-A76)`
  * `aes-256-cbc     591266.13k  1015557.48k  1228154.45k  1288198.49k  1313477.97k  1316132.18k (Cortex-A76)`

### PCIe and storage devices:

  * ASMedia ASM1164 Serial ATA AHCI: Speed 8GT/s (ok), Width x2 (ok), driver in use: ahci
  * Realtek RTL8125 2.5GbE: Speed 5GT/s (ok), Width x1 (ok), driver in use: r8125
  * Realtek RTL8125 2.5GbE: Speed 5GT/s (ok), Width x1 (ok), driver in use: r8125
  * 29.1GB "Samsung BJTD4R" HS400 Enhanced strobe eMMC card as /dev/mmcblk0: date 09/2023, manfid/oemid: 0x000015/0x0100, hw/fw rev: 0x0/0x0300000000000000
  * 238.8GB "Samsung EE4S5" UHS SDR104 SDXC card as /dev/mmcblk1: date 05/2023, manfid/oemid: 0x00001b/0x534d, hw/fw rev: 0x3/0x0
  * 16MB SPI NOR flash, drivers in use: spi-nor/rockchip-sfc

### Swap configuration:

  * /dev/zram0: 3.9G (0K used, zstd, 8 streams, 4K data, 58B compressed, 4K total)

### Software versions:

  * Debian GNU/Linux 11 (bullseye)
  * Build scripts: Radxa rbuild 5dd622e5f3e550fd780f33d94dc10dd2407dd38c, --test-repo --timestamp=test-build-4 --compress --native-build --shrink rock-5-itx bullseye cli, u-boot-rknext 2017.09-10-52701b7, 22 Feb 2024
  * Compiler: /usr/bin/gcc (Debian 10.2.1-6) 10.2.1 20210110 / aarch64-linux-gnu
  * OpenSSL 1.1.1w, built on 11 Sep 2023          

### Kernel info:

  * `/proc/cmdline: root=UUID=b998a418-a089-4615-90cd-6a6a459e12c2 console=ttyFIQ0,1500000n8 quiet splash loglevel=4 rw earlycon consoleblank=0 console=tty1 coherent_pool=2M irqchip.gicv3_pseudo_nmi=0 cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory swapaccount=1`
  * Vulnerability Spec store bypass: Mitigation; Speculative Store Bypass disabled via prctl
  * Vulnerability Spectre v1:        Mitigation; __user pointer sanitization
  * Vulnerability Spectre v2:        Mitigation; CSV2, BHB
  * Kernel 5.10.110-30-rockchip / CONFIG_HZ=300

Kernel 5.10.110 is not latest 5.10.214 LTS that was released on 2024-03-26.

See https://endoflife.date/linux for details. It is somewhat likely that
a lot of exploitable vulnerabilities exist for this kernel as well as many
unfixed bugs.

But this version string doesn't matter since this is not an official LTS Linux
from kernel.org. This device runs a Rockchip vendor/BSP kernel.

This kernel is based on a mixture of Android GKI and other sources. Also some
community attempts to do version string cosmetics might have happened, see
https://tinyurl.com/2p8fuubd for example. To examine how far away this 5.10.110
is from an official LTS of same version someone would have to reapply Rockchip's
thousands of patches to a clean 5.10.110 LTS.