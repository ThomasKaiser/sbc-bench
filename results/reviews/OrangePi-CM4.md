# Rockchip RK3566 Orange Pi CM4 Board

Tested with sbc-bench v0.9.50 on Sat, 04 Nov 2023 02:31:03 +0000. Full info: [http://ix.io/4KDv](http://ix.io/4KDv) and [Jeff Geerling's review thread](https://github.com/geerlingguy/sbc-reviews/issues/26).

### General information:

    Rockchip RK3566 (35662000), Kernel: aarch64, Userland: arm64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      408    1800   Cortex-A55 / r2p0
      1        0        0      408    1800   Cortex-A55 / r2p0
      2        0        0      408    1800   Cortex-A55 / r2p0
      3        0        0      408    1800   Cortex-A55 / r2p0

3922 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: performance / 1104 MHz (conservative ondemand userspace powersave performance schedutil / 408 600 816 1104 1416 1608 1800)
    fde40000.npu: rknpu_ondemand / 600 MHz (rknpu_ondemand vdec2_ondemand venc_ondemand userspace powersave performance simple_ondemand / 200 297 400 600 700 800 900)
    fde60000.gpu: simple_ondemand / 200 MHz (rknpu_ondemand vdec2_ondemand venc_ondemand userspace powersave performance simple_ondemand / 200 300 400 600 700 800)
    fdf40000.rkvenc: venc_ondemand / 0 MHz (rknpu_ondemand vdec2_ondemand venc_ondemand userspace powersave performance simple_ondemand / 297000 400000)
    fdf80200.rkvdec: vdec2_ondemand / 0 MHz (rknpu_ondemand vdec2_ondemand venc_ondemand userspace powersave performance simple_ondemand / 297000 400000)

Tuned governor settings:

    cpufreq-policy0: performance / 1104 MHz
    fde40000.npu: performance / 900 MHz
    fde60000.gpu: performance / 800 MHz
    fdf40000.rkvenc: performance / 400 MHz
    fdf80200.rkvdec: performance / 400 MHz

Status of performance related policies found below /sys:

    /sys/devices/platform/fde60000.gpu/power_policy: [coarse_demand] always_on
    /sys/module/pcie_aspm/parameters/policy: default [performance] powersave powersupersave

### Clockspeeds (idle vs. heated up):

Before at 34.4°C:

    cpu0 (Cortex-A55): OPP: 1800, Measured: 1882      (+4.6%)

After at 61.7°C:

    cpu0 (Cortex-A55): OPP: 1800, Measured: 1862      (+3.4%)

### Performance baseline

  * memcpy: 3007.1 MB/s, memchr: 2839.8 MB/s, memset: 8154.5 MB/s
  * 16M latency: 174.1 175.2 176.1 175.2 174.0 174.9 235.1 437.8 
  * 128M latency: 188.5 203.5 187.5 188.4 192.6 193.1 247.3 459.6 
  * 7-zip MIPS (3 consecutive runs): 4789, 4770, 4794 (4780 avg), single-threaded: 1351
  * `aes-256-cbc     149498.53k   397778.54k   674988.12k   819383.64k   873231.70k   877150.21k`
  * `aes-256-cbc     149940.32k   398175.77k   674771.29k   818883.24k   872964.10k   876920.83k`

### Storage devices:

  * 29.1GB "SanDisk/Toshiba DV4032" HS200 eMMC 5.1 card as /dev/mmcblk0: date 06/2023, manfid/oemid: 0x000045/0x0100, hw/fw rev: 0x0/0x5243333042303037
  * 14.8GB "SanDisk SE16G" HS SD card (speed negotiation problems and errors, check dmesg) as /dev/mmcblk1: date 09/2014, manfid/oemid: 0x000003/0x5344, hw/fw rev: 0x8/0x0

### Swap configuration:

  * /dev/zram0: 1.9G (768K used, lzo-rle, 4 streams, 72K data, 14.5K compressed, 156K total)

### Software versions:

  * Debian GNU/Linux 12 (bookworm)
  * Build scripts: https://github.com/orangepi-xunlong/orangepi-build, 1.0.0, OPI CM4, rockchip-rk356x, rockchip-rk356x
  * Compiler: /usr/bin/gcc (Debian 12.2.0-14) 12.2.0 / aarch64-linux-gnu

### Kernel info:

  * `/proc/cmdline: root=UUID=2793ecd8-43c2-48b5-871e-613753fc80d8 rootwait rootfstype=ext4 splash=verbose console=ttyFIQ0 console=tty1 consoleblank=0 loglevel=1 ubootpart=35d7178c-c5a9-fc47-9b28-8ad639310fae usb-storage.quirks= cma=128M  cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory swapaccount=1 earlycon=uart8250,mmio32,0xfe660000`
  * Vulnerability Spectre v1:        Mitigation; __user pointer sanitization
  * Kernel 5.10.160-rockchip-rk356x / CONFIG_HZ=300

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