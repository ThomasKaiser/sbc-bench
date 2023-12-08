# Radxa ROCK 5B

Tested with sbc-bench v0.9.39 on Mon, 13 Mar 2023 17:55:48 +0100. Full info: [http://ix.io/4qJr](../4qJr.txt)

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
    cpufreq-policy6: ondemand / 2400 MHz (conservative ondemand userspace powersave performance schedutil / 408 600 816 1008 1200 1416 1608 1800 2016 2208 2256 2304 2352 2400)
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

Before at 41.6°C:

    cpu0-cpu3 (Cortex-A55): OPP: 1800, Measured: 1823      (+1.3%)
    cpu4-cpu5 (Cortex-A76): OPP: 2400, Measured: 2333      (-2.8%)
    cpu6-cpu7 (Cortex-A76): OPP: 2400, Measured: 2334      (-2.7%)

After at 77.6°C:

    cpu0-cpu3 (Cortex-A55): OPP: 1800, Measured: 1797 
    cpu4-cpu5 (Cortex-A76): OPP: 2400, Measured: 2291      (-4.5%)
    cpu6-cpu7 (Cortex-A76): OPP: 2400, Measured: 2293      (-4.5%)

### Performance baseline

  * cpu0 (Cortex-A55): memcpy: 5885.4 MB/s, memchr: 3279.7 MB/s, memset: 22141.2 MB/s
  * cpu4 (Cortex-A76): memcpy: 10464.3 MB/s, memchr: 14858.1 MB/s, memset: 29162.6 MB/s
  * cpu6 (Cortex-A76): memcpy: 10465.7 MB/s, memchr: 14900.9 MB/s, memset: 29000.5 MB/s
  * cpu0 (Cortex-A55) 16M latency: 120.9 121.0 118.1 121.2 116.8 126.6 203.6 371.3 
  * cpu4 (Cortex-A76) 16M latency: 120.8 109.5 118.6 109.4 118.7 107.7 109.7 109.1 
  * cpu6 (Cortex-A76) 16M latency: 128.6 114.1 119.0 110.4 118.3 106.1 104.0 107.7 
  * cpu0 (Cortex-A55) 128M latency: 145.5 146.0 145.1 146.0 144.4 150.7 225.1 397.9 
  * cpu4 (Cortex-A76) 128M latency: 137.1 137.9 137.0 137.8 136.9 132.1 131.0 136.1 
  * cpu6 (Cortex-A76) 128M latency: 137.9 138.2 138.0 138.3 137.2 132.3 130.5 134.8 
  * 7-zip MIPS (3 consecutive runs): 16542, 16444, 16248 (16410 avg), single-threaded: 3121
  * `aes-256-cbc     158764.21k   407795.78k   668686.34k   799750.83k   847765.50k   851542.02k (Cortex-A55)`
  * `aes-256-cbc     645699.40k  1057904.92k  1246935.72k  1300131.16k  1323152.73k  1325705.90k (Cortex-A76)`
  * `aes-256-cbc     645555.88k  1056458.05k  1248653.82k  1300471.81k  1323379.37k  1326006.27k (Cortex-A76)`

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

Kernel 5.10.110 is not latest 5.10.173 LTS that was released on 2023-03-11.

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

  * everything set to powersave: 1490 mW
  * /sys/devices/platform/dmc/devfreq/dmc set to performance: 1900 mW
  * /sys/devices/platform/fb000000.gpu/devfreq/fb000000.gpu set to performance: 1970 mW
  * /sys/devices/platform/fdab0000.npu/devfreq/fdab0000.npu set to performance: 1950 mW
  * /sys/devices/system/cpu/cpufreq/policy0 set to performance: 2040 mW
  * /sys/devices/system/cpu/cpufreq/policy4 set to performance: 2070 mW
  * /sys/devices/system/cpu/cpufreq/policy6 set to performance: 2080 mW
  * /sys/module/pcie_aspm/parameters/policy set to performance: 2220 mW
