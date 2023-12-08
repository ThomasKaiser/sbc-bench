# Radxa ZERO 3W

Tested with sbc-bench v0.9.50 on Thu, 09 Nov 2023 13:23:38 +0000. Full info: [http://ix.io/4L4k](../4L4k.txt)

### General information:

    Rockchip RK3566 (35662000), Kernel: aarch64, Userland: arm64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      408    1416   Cortex-A55 / r2p0
      1        0        0      408    1416   Cortex-A55 / r2p0
      2        0        0      408    1416   Cortex-A55 / r2p0
      3        0        0      408    1416   Cortex-A55 / r2p0

979 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: ondemand / 1416 MHz (ondemand performance schedutil / 408 600 816 1104 1416)
    dmc: dmc_ondemand / 780 MHz (powersave performance dmc_ondemand vdec2_ondemand venc_ondemand simple_ondemand / 324 528 780 1056)
    fde60000.gpu: simple_ondemand / 200 MHz (powersave performance dmc_ondemand vdec2_ondemand venc_ondemand simple_ondemand / 200 300 400)
    fdf40000.rkvenc: venc_ondemand / 0 MHz (powersave performance dmc_ondemand vdec2_ondemand venc_ondemand simple_ondemand / 297000)
    fdf80200.rkvdec: vdec2_ondemand / 0 MHz (powersave performance dmc_ondemand vdec2_ondemand venc_ondemand simple_ondemand / 297000 400000)

Tuned governor settings:

    cpufreq-policy0: performance / 1416 MHz
    dmc: performance / 1056 MHz
    fde60000.gpu: performance / 400 MHz
    fdf40000.rkvenc: performance / 297 MHz
    fdf80200.rkvdec: performance / 400 MHz

Status of performance related policies found below /sys:

    /sys/devices/platform/fde60000.gpu/power_policy: [coarse_demand] always_on

### Clockspeeds (idle vs. heated up):

Before at 30.6°C:

    cpu0 (Cortex-A55): OPP: 1416, Measured: 1610     (+13.7%)

After at 69.4°C:

    cpu0 (Cortex-A55): OPP: 1416, Measured: 1590     (+12.3%)

### Performance baseline

  * memcpy: 2400.1 MB/s, memchr: 2425.9 MB/s, memset: 5578.9 MB/s
  * 16M latency: 201.1 202.9 201.6 203.1 200.5 202.5 272.4 500.3 
  * 128M latency: 210.0 213.5 211.3 212.6 212.1 212.4 296.5 514.1 
  * 7-zip MIPS (3 consecutive runs): 4009, 3982, 4019 (4000 avg), single-threaded: 1155
  * `aes-256-cbc     131187.82k   345379.82k   580173.91k   701992.96k   747787.61k   750409.05k`
  * `aes-256-cbc     131738.88k   345688.41k   580980.31k   702567.42k   748150.78k   751523.16k`

### Storage devices:

  * 29.5GB "SK Hynix USD00" UHS SDR104 SD card as /dev/mmcblk1: date 05/2022, manfid/oemid: 0x0000ad/0x4c53, hw/fw rev: 0x1/0x0

### Swap configuration:

  * /dev/zram0: 979.2M (99.0M used, lzo-rle, 4 streams, 98.6M data, 24M compressed, 27.6M total)
  * /var/swap on /dev/mmcblk1p3: 2.0G (0K used) on ultra slow SD card storage

### Software versions:

  * Ubuntu 22.04.3 LTS
  * Build scripts: Radxa rbuild 6573d0341cf76b0d7bd0ab532dad5f84ea4cea88, --timestamp=b2 --compress --native-build --shrink radxa-zero3 jammy cli, u-boot-latest 2023.07.02-4-413cb6eb, 21 Sep 2023
  * Compiler: /usr/bin/gcc (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0 / aarch64-linux-gnu

### Kernel info:

  * `/proc/cmdline: root=UUID=56ec0632-d2b4-4811-aa35-0bb3e35ec750 quiet splash loglevel=4 rw earlycon consoleblank=0 console=tty0 console=ttyFIQ0,1500000n8 console=ttyAML0,115200n8 console=ttyS2,1500000n8 console=ttyS0,1500000n8 coherent_pool=2M irqchip.gicv3_pseudo_nmi=0 cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory swapaccount=1`
  * Vulnerability Spectre v1:        Mitigation; __user pointer sanitization
  * Kernel 5.10.160-15-rk356x / CONFIG_HZ=300

Kernel 5.10.160 is not latest 5.10.200 LTS that was released on 2023-11-08.

See https://endoflife.date/linux for details. It is somewhat likely that some
exploitable vulnerabilities exist for this kernel as well as many unfixed bugs.

But this version string doesn't matter since this is not an official LTS Linux
from kernel.org. This device runs a Rockchip vendor/BSP kernel.

This kernel is based on a mixture of Android GKI and other sources. Also some
community attempts to do version string cosmetics might have happened, see
https://tinyurl.com/2p8fuubd for example. To examine how far away this 5.10.160
is from an official LTS of same version someone would have to reapply Rockchip's
thousands of patches to a clean 5.10.160 LTS.