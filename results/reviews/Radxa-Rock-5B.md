# Radxa ROCK 5B

Tested with sbc-bench v0.9.29 on Thu, 23 Feb 2023 16:10:47 +0100. Full info: [http://ix.io/4oZ7](http://ix.io/4oZ7)

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

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: ondemand / 1800 MHz (conservative ondemand userspace powersave performance schedutil / 408 600 816 1008 1200 1416 1608 1800)
    cpufreq-policy4: ondemand / 408 MHz (conservative ondemand userspace powersave performance schedutil / 408 600 816 1008 1200 1416 1608 1800 2016 2208 2256 2304 2352 2400)
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

Before at 50.8°C:

    cpu0-cpu3 (Cortex-A55): OPP: 1800, Measured: 1815 
    cpu4-cpu5 (Cortex-A76): OPP: 2400, Measured: 2319      (-3.4%)
    cpu6-cpu7 (Cortex-A76): OPP: 2400, Measured: 2318      (-3.4%)

After at 82.2°C (throttled):

    cpu0-cpu3 (Cortex-A55): OPP: 1800, Measured: 1790 
    cpu4-cpu5 (Cortex-A76): OPP: 2400, Measured: 2280      (-5.0%)
    cpu6-cpu7 (Cortex-A76): OPP: 2400, Measured: 2280      (-5.0%)

### Memory performance

  * cpu0 (Cortex-A55): memcpy: 5853.7 MB/s, memchr: 3279.8 MB/s, memset: 22022.8 MB/s
  * cpu4 (Cortex-A76): memcpy: 10062.2 MB/s, memchr: 14305.6 MB/s, memset: 28951.3 MB/s
  * cpu6 (Cortex-A76): memcpy: 10039.7 MB/s, memchr: 14337.7 MB/s, memset: 28900.5 MB/s
  * cpu0 (Cortex-A55) 16M latency: 117.2 119.9 116.9 120.1 115.8 125.3 206.3 382.0 
  * cpu4 (Cortex-A76) 16M latency: 119.9 109.6 118.9 120.9 120.0 108.9 112.0 115.1 
  * cpu6 (Cortex-A76) 16M latency: 120.1 110.1 118.8 109.5 118.4 108.2 107.4 108.6 

### PCIe and storage devices:

  * 238.5GB "KXG50ZNV256G NVMe TOSHIBA 256GB" SSD as /dev/nvme0n1: Speed 8GT/s (ok), Width x4 (ok), 13% worn out, 67°C
  * Realtek RTL8125 2.5GbE: Speed 5GT/s (ok), Width x1 (ok), driver in use: r8125
  * 7.4GB "SanDisk SL08G" UHS SDR50 SD card as /dev/mmcblk0: date 06/2016, manfid/oemid: 0x000003/0x5344, hw/fw rev: 0x8/0x0
  * 14.5GB "Foresee NCard" HS200 eMMC 5.0 card as /dev/mmcblk1: date 08/2016, manfid/oemid: 0x000088/0x0103, hw/fw rev: 0x0/0x0100000000000000
  * 16MB SPI NOR flash, drivers in use: spi-nor/rockchip-sfc

"smartctl -x $device" could be used to get further information about the reported issues.

### Challenging filesystems:

The following partitions are NTFS: nvme0n1p1

When this OS uses FUSE/userland methods to access NTFS filesystems performance
will be significantly harmed or at least likely be bottlenecked by maxing out
one or more CPU cores. It is highly advised when benchmarking with any NTFS to
monitor closely CPU utilization or better switch to a 'Linux native' filesystem
like ext4 since representing 'storage performance' a lot more than 'somewhat 
dealing with a foreign filesystem' as with NTFS.

### Software versions:

  * Ubuntu 20.04.5 LTS (focal) arm64
  * Build scripts: https://github.com/armbian/build, 22.11.4, Rock 5B, rockchip-rk3588, rockchip-rk3588
  * Compiler: /usr/bin/gcc (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0 / aarch64-linux-gnu
  * OpenSSL 1.1.1f, built on 31 Mar 2020

### Kernel info:

  * `/proc/cmdline: root=UUID=a98b51b6-4f19-4fbb-966d-e835e9b7eb15 rootwait rootfstype=ext4 console=ttyS2,1500000 console=tty1 consoleblank=0 loglevel=1 ubootpart=8917ce6a-4dc2-a145-b073-1492d425c2b8 usb-storage.quirks=0x2537:0x1066:u,0x2537:0x1068:u   cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory swapaccount=1`
  * Vulnerability Spec store bypass: Mitigation; Speculative Store Bypass disabled via prctl
  * Vulnerability Spectre v1:        Mitigation; __user pointer sanitization
  * Vulnerability Spectre v2:        Vulnerable: Unprivileged eBPF enabled
  * Kernel 5.10.110-rockchip-rk3588 / CONFIG_HZ=300

Kernel 5.10.110 is not latest 5.10.169 LTS that was released on 2023-02-22.

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
