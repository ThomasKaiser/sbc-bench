# Turing Machines RK1

Tested with sbc-bench v0.9.50 on Fri, 03 Nov 2023 18:40:15 +0000. Full benchmark info: [http://sprunge.us/Xuf1O1](http://sprunge.us/Xuf1O1) and [review thread](https://github.com/geerlingguy/sbc-reviews/issues/25).

### General information:

The CPU features 3 clusters consisting of 2 different core types:

    Rockchip RK3588/RK3588s (35881000), Kernel: aarch64, Userland: arm64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      408    1800   Cortex-A55 / r2p0
      1        0        0      408    1800   Cortex-A55 / r2p0
      2        0        0      408    1800   Cortex-A55 / r2p0
      3        0        0      408    1800   Cortex-A55 / r2p0
      4        1        4      408    2304   Cortex-A76 / r4p0
      5        1        4      408    2304   Cortex-A76 / r4p0
      6        2        6      408    2304   Cortex-A76 / r4p0
      7        2        6      408    2304   Cortex-A76 / r4p0

15715 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: performance / 1800 MHz (conservative ondemand userspace powersave performance schedutil / 408 600 816 1008 1200 1416 1608 1800)
    cpufreq-policy4: performance / 2304 MHz (conservative ondemand userspace powersave performance schedutil / 408 600 816 1008 1200 1416 1608 1800 2016 2208 2304)
    cpufreq-policy6: performance / 2304 MHz (conservative ondemand userspace powersave performance schedutil / 408 600 816 1008 1200 1416 1608 1800 2016 2208 2304)
    dmc: dmc_ondemand / 528 MHz (rknpu_ondemand dmc_ondemand userspace powersave performance simple_ondemand / 528 1068 1560 2112)
    fb000000.gpu: performance / 1000 MHz (rknpu_ondemand dmc_ondemand userspace powersave performance simple_ondemand / 300 400 500 600 700 800 900 1000)
    fdab0000.npu: rknpu_ondemand / 1000 MHz (rknpu_ondemand dmc_ondemand userspace powersave performance simple_ondemand / 300 400 500 600 700 800 900 1000)

Tuned governor settings:

    cpufreq-policy0: performance / 1800 MHz
    cpufreq-policy4: performance / 2304 MHz
    cpufreq-policy6: performance / 2304 MHz
    dmc: performance / 2112 MHz
    fb000000.gpu: performance / 1000 MHz
    fdab0000.npu: performance / 1000 MHz

Status of performance related policies found below /sys:

    /sys/devices/platform/fb000000.gpu/power_policy: [coarse_demand] always_on
    /sys/module/pcie_aspm/parameters/policy: default [performance] powersave powersupersave

### Clockspeeds (idle vs. heated up):

Before at 35.2°C:

    cpu0-cpu3 (Cortex-A55): OPP: 1800, Measured: 1827      (+1.5%)
    cpu4-cpu5 (Cortex-A76): OPP: 2304, Measured: 2283 
    cpu6-cpu7 (Cortex-A76): OPP: 2304, Measured: 2291 

After at 52.7°C:

    cpu0-cpu3 (Cortex-A55): OPP: 1800, Measured: 1820      (+1.1%)
    cpu4-cpu5 (Cortex-A76): OPP: 2304, Measured: 2273      (-1.3%)
    cpu6-cpu7 (Cortex-A76): OPP: 2304, Measured: 2281 

### Performance baseline

  * cpu0 (Cortex-A55): memcpy: 6833.7 MB/s, memchr: 2826.4 MB/s, memset: 22198.2 MB/s
  * cpu4 (Cortex-A76): memcpy: 12220.2 MB/s, memchr: 16809.7 MB/s, memset: 30022.0 MB/s
  * cpu6 (Cortex-A76): memcpy: 12231.5 MB/s, memchr: 16812.8 MB/s, memset: 29918.2 MB/s
  * cpu0 (Cortex-A55) 16M latency: 111.9 112.6 110.0 112.5 108.9 114.0 174.9 319.2 
  * cpu4 (Cortex-A76) 16M latency: 112.7 102.0 110.9 103.3 111.1 113.9 110.9 109.8 
  * cpu6 (Cortex-A76) 16M latency: 113.7 107.3 116.8 105.3 111.0 108.8 105.6 106.5 
  * cpu0 (Cortex-A55) 128M latency: 133.8 134.6 133.4 134.6 132.7 134.5 191.9 336.5 
  * cpu4 (Cortex-A76) 128M latency: 126.4 126.7 125.7 126.7 125.7 125.1 125.9 129.3 
  * cpu6 (Cortex-A76) 128M latency: 126.9 127.3 126.3 127.3 126.5 125.1 126.2 128.1 
  * 7-zip MIPS (3 consecutive runs): 16740, 16686, 16783 (16740 avg), single-threaded: 3158
  * `aes-256-cbc     149515.66k   392904.04k   661567.57k   798774.61k   850455.21k   854578.52k (Cortex-A55)`
  * `aes-256-cbc     581743.22k  1001314.43k  1210961.15k  1273206.44k  1297107.63k  1299551.57k (Cortex-A76)`
  * `aes-256-cbc     586253.09k  1003451.82k  1214030.68k  1276712.96k  1300936.02k  1303254.36k (Cortex-A76)`

### Storage devices:

  * 29.1GB "Samsung BJTD4R" HS200 eMMC 5.1 card as /dev/mmcblk0: date 10/2022, manfid/oemid: 0x000015/0x0100, hw/fw rev: 0x0/0x0900000000000000

### Swap configuration:

  * /swapfile on /dev/mmcblk0p2: 2.0G (0K used) on MMC storage

### Software versions:

  * Ubuntu 22.04.3 LTS
  * Compiler: /usr/bin/gcc (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0 / aarch64-linux-gnu

### Kernel info:

  * `/proc/cmdline: root=UUID=6d9dfb61-51ad-468b-bb1d-5e95fc5b5aca rootfstype=ext4 rootwait rw console=ttyS9,115200 console=ttyS2,1500000 console=tty1 cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory swapaccount=1 systemd.unified_cgroup_hierarchy=0 `
  * Vulnerability Spec store bypass: Mitigation; Speculative Store Bypass disabled via prctl
  * Vulnerability Spectre v1:        Mitigation; __user pointer sanitization
  * Vulnerability Spectre v2:        Vulnerable: Unprivileged eBPF enabled
  * Kernel 5.10.160-rockchip / CONFIG_HZ=300

Kernel 5.10.160 is not latest 5.10.199 LTS that was released on 2023-10-25.

See https://endoflife.date/linux for details. It is somewhat likely that some
exploitable vulnerabilities exist for this kernel as well as many unfixed bugs.

But this version string doesn't matter since this is not an official LTS Linux
from kernel.org. This device runs a Rockchip vendor/BSP kernel.

This kernel is based on a mixture of Android GKI and other sources. Also some
community attempts to do version string cosmetics might have happened, see
https://tinyurl.com/2p8fuubd for example. To examine how far away this 5.10.160
is from an official LTS of same version someone would have to reapply Rockchip's
thousands of patches to a clean 5.10.160 LTS.
