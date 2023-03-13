# Radxa ROCK 5B

Tested with sbc-bench v0.9.38 on Mon, 13 Mar 2023 08:57:20 +0100. Full info: [http://ix.io/4qH9](http://ix.io/4qH9)

### General information:

The CPU features 3 clusters consisting of 2 different core types:

    Rockchip RK3588/RK3588s (35880000), Kernel: aarch64, Userland: arm64
    
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

15719 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: ondemand / 1800 MHz (conservative ondemand userspace powersave performance schedutil / 408 600 816 1008 1200 1416 1608 1800)
    cpufreq-policy4: ondemand / 2400 MHz (conservative ondemand userspace powersave performance schedutil / 408 600 816 1008 1200 1416 1608 1800 2016 2208 2256 2304 2352 2400)
    cpufreq-policy6: ondemand / 408 MHz (conservative ondemand userspace powersave performance schedutil / 408 600 816 1008 1200 1416 1608 1800 2016 2208 2256 2304 2352 2400)
    dmc: dmc_ondemand / 528 MHz (rknpu_ondemand dmc_ondemand userspace powersave performance simple_ondemand / 528 1068 1560 2112)
    fb000000.gpu: simple_ondemand / 300 MHz (rknpu_ondemand dmc_ondemand userspace powersave performance simple_ondemand / 300 400 500 600 700 800 900 1000)
    fdab0000.npu: rknpu_ondemand / 1000 MHz (rknpu_ondemand dmc_ondemand userspace powersave performance simple_ondemand / 300 400 500 600 700 800 900 1000)

Tuned governor settings:

    cpufreq-policy0: performance / 1800 MHz
    cpufreq-policy4: performance / 2400 MHz
    cpufreq-policy6: performance / 2400 MHz
    dmc: performance / 2112 MHz
    fb000000.gpu: performance / 1000 MHz
    fdab0000.npu: performance / 1000 MHz

Status of performance related policies found below /sys:

    /sys/devices/platform/fb000000.gpu/power_policy: [coarse_demand] always_on
    /sys/module/pcie_aspm/parameters/policy: default [performance] powersave powersupersave

### Clockspeeds (idle vs. heated up):

Before at 33.3°C:

    cpu0-cpu3 (Cortex-A55): OPP: 1800, Measured: 1830      (+1.7%)
    cpu4-cpu5 (Cortex-A76): OPP: 2400, Measured: 2345      (-2.3%)
    cpu6-cpu7 (Cortex-A76): OPP: 2400, Measured: 2344      (-2.3%)

After at 75.8°C:

    cpu0-cpu3 (Cortex-A55): OPP: 1800, Measured: 1799 
    cpu4-cpu5 (Cortex-A76): OPP: 2400, Measured: 2294      (-4.4%)
    cpu6-cpu7 (Cortex-A76): OPP: 2400, Measured: 2295      (-4.4%)

### Performance baseline

  * cpu0 (Cortex-A55): memcpy: 5660.2 MB/s, memchr: 3323.4 MB/s, memset: 22205.0 MB/s
  * cpu4 (Cortex-A76): memcpy: 9580.7 MB/s, memchr: 13162.4 MB/s, memset: 29026.5 MB/s
  * cpu6 (Cortex-A76): memcpy: 9593.1 MB/s, memchr: 13172.9 MB/s, memset: 28749.2 MB/s
  * cpu0 (Cortex-A55) 16M latency: 118.2 119.9 116.8 120.0 116.1 125.7 212.4 382.7 
  * cpu4 (Cortex-A76) 16M latency: 125.3 109.4 126.1 112.1 117.8 106.2 108.2 108.5 
  * cpu6 (Cortex-A76) 16M latency: 119.3 110.1 118.4 110.1 118.2 107.4 105.0 108.5 
  * 7-zip MIPS (3 consecutive runs): 16247, 16371, 16329 (16320 avg), single-threaded: 3122
  * `aes-256-cbc     160825.49k   412219.99k   674238.38k   802143.91k   849589.59k   853224.11k (Cortex-A55)`
  * `aes-256-cbc     647010.43k  1057898.82k  1250635.78k  1303447.21k  1326290.26k  1328840.70k (Cortex-A76)`
  * `aes-256-cbc     644804.91k  1060585.73k  1250964.48k  1303821.99k  1326661.63k  1329217.54k (Cortex-A76)`

### PCIe and storage devices:

  * Realtek RTL8125 2.5GbE: Speed 5GT/s (ok), Width x1 (ok), driver in use: r8125
  * 14.5GB "Foresee NCard" HS200 eMMC 5.0 card as /dev/mmcblk0: date 08/2016, manfid/oemid: 0x000088/0x0103, hw/fw rev: 0x0/0x0100000000000000
  * 7.4GB "SanDisk SL08G" UHS SDR50 SD card as /dev/mmcblk1: date 06/2016, manfid/oemid: 0x000003/0x5344, hw/fw rev: 0x8/0x0
  * 16MB SPI NOR flash, drivers in use: spi-nor/rockchip-sfc

### Swap configuration:

  * /dev/zram0: 7.7G (0K used, lzo-rle, 8 streams, 4K data, 74B compressed, 12K total)

### Software versions:

  * Ubuntu 20.04.5 LTS
  * Build scripts: https://github.com/armbian/build, 23.02.2, Rock 5B, rockchip-rk3588, rockchip-rk3588
  * Compiler: /usr/bin/gcc (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0 / aarch64-linux-gnu

### Kernel info:

  * `/proc/cmdline: root=UUID=a98b51b6-4f19-4fbb-966d-e835e9b7eb15 rootwait rootfstype=ext4 console=ttyS2,1500000 console=tty1 consoleblank=0 loglevel=1 ubootpart=8917ce6a-4dc2-a145-b073-1492d425c2b8 usb-storage.quirks=0x2537:0x1066:u,0x2537:0x1068:u   cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory swapaccount=1`
  * Vulnerability Spec store bypass: Mitigation; Speculative Store Bypass disabled via prctl
  * Vulnerability Spectre v1:        Mitigation; __user pointer sanitization
  * Vulnerability Spectre v2:        Vulnerable: Unprivileged eBPF enabled
  * Kernel 5.10.110-rockchip-rk3588 / CONFIG_HZ=300

Kernel 5.10.110 is not latest 5.10.172 LTS that was released on 2023-03-03.

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

### Idle consumption (measured with Netio 4KF, FW v3.2.0):

  * everything set to powersave: 1500 mW
  * /sys/devices/platform/dmc/devfreq/dmc set to performance: 1930 mW
  * /sys/devices/platform/fb000000.gpu/devfreq/fb000000.gpu set to performance: 1960 mW
  * /sys/devices/platform/fdab0000.npu/devfreq/fdab0000.npu set to performance: 1930 mW
  * /sys/devices/system/cpu/cpufreq/policy0 set to performance: 1980 mW
  * /sys/devices/system/cpu/cpufreq/policy4 set to performance: 2050 mW
  * /sys/devices/system/cpu/cpufreq/policy6 set to performance: 2080 mW
  * /sys/module/pcie_aspm/parameters/policy set to performance: 2210 mW
