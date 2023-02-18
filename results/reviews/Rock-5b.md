# Radxa ROCK 5B

Tested on Sat, 18 Feb 2023 11:59:16 +0100. Full info: [http://ix.io/4oqS](http://ix.io/4oqS)

### General information:

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

    cpufreq-policy0: ondemand / 1800 MHz (conservative ondemand userspace powersave performance schedutil)
    cpufreq-policy4: ondemand / 408 MHz (conservative ondemand userspace powersave performance schedutil)
    cpufreq-policy6: ondemand / 408 MHz (conservative ondemand userspace powersave performance schedutil)
    dmc: dmc_ondemand / 528 MHz (rknpu_ondemand dmc_ondemand userspace powersave performance simple_ondemand)
    fb000000.gpu: simple_ondemand / 300 MHz (rknpu_ondemand dmc_ondemand userspace powersave performance simple_ondemand)
    fdab0000.npu: rknpu_ondemand / 1000 MHz (rknpu_ondemand dmc_ondemand userspace powersave performance simple_ondemand)

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

Before at 49.0°C:

    cpu0-cpu3 (Cortex-A55): OPP: 1800, Measured: 1816 
    cpu4-cpu5 (Cortex-A76): OPP: 2400, Measured: 2320      (-3.3%)
    cpu6-cpu7 (Cortex-A76): OPP: 2400, Measured: 2319      (-3.4%)

After at 83.2°C:

    cpu0-cpu3 (Cortex-A55): OPP: 1800, Measured: 1789 
    cpu4-cpu5 (Cortex-A76): OPP: 2400, Measured: 2278      (-5.1%)
    cpu6-cpu7 (Cortex-A76): OPP: 2400, Measured: 2278      (-5.1%)

### PCIe and storage devices:

  * KXG50ZNV256G NVMe TOSHIBA 256GB SSD as /dev/nvme0n1: Speed 8GT/s (ok), Width x4 (ok), 13% worn out, 0/0 errors, 68°C
  * Realtek RTL8125 2.5GbE: Speed 5GT/s (ok), Width x1 (ok), driver in use: r8125
  * 14.5GB Foresee NCard eMMC 5.0 as /dev/mmcblk1: date 08/2016, man/oem ID: 0x000088/0x0103, hw/fw rev: 0x0/0x0100000000000000
  * 16MB SPI NOR flash as /dev/mtd0, drivers in use: spi-nor/rockchip-sfc
  * 7.4GB SanDisk SL08G SD card as /dev/mmcblk0: date 06/2016, man/oem ID: 0x000003/0x5344, hw/fw rev: 0x8/0x0
  * SanDisk Corp. Ultra Dual as /dev/sda: USB, Driver=usb-storage, 480M
  * TOSHIBA MK7559GSXF HDD as /dev/sdb as /dev/sdb: USB, Driver=uas, 5000M, 24°C

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

Kernel 5.10.110 is not latest 5.10.168 LTS that was released on 2023-02-15.

Please check https://endoflife.date/linux for details. It is somewhat likely
that a lot of exploitable vulnerabilities exist for this kernel as well as
many unfixed bugs. Better upgrade to a supported version ASAP.

But this version string doesn't matter since this is not an official LTS Linux
from kernel.org. This device runs a Rockchip vendor/BSP kernel.

This kernel is based on a mixture of Android GKI and other sources. Also some
community attempts to do version string cosmetics might have happened, see
https://tinyurl.com/2p8fuubd for example. To examine how far away this 5.10.110
is from an official LTS of same version someone would have to reapply Rockchip's
thousands of patches to a clean 5.10.110 LTS.
