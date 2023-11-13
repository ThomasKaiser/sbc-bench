# FriendlyElec NanoPi R5S

Tested with sbc-bench v0.9.50 on Thu, 09 Nov 2023 13:38:32 +0000. Full info: [http://ix.io/4L4u](http://ix.io/4L4u)

### General information:

    Rockchip RK3568 (35682000), Kernel: aarch64, Userland: arm64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      408    1992   Cortex-A55 / r2p0
      1        0        0      408    1992   Cortex-A55 / r2p0
      2        0        0      408    1992   Cortex-A55 / r2p0
      3        0        0      408    1992   Cortex-A55 / r2p0

1958 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: schedutil / 1104 MHz (conservative ondemand userspace powersave performance schedutil / 408 600 816 1104 1416 1608 1800 1992)
    fde40000.npu: rknpu_ondemand / 0 MHz (rknpu_ondemand vdec2_ondemand venc_ondemand userspace powersave performance simple_ondemand / 200000 297000 400000 600000 700000 800000 900000)
    fde60000.gpu: simple_ondemand / 200 MHz (rknpu_ondemand vdec2_ondemand venc_ondemand userspace powersave performance simple_ondemand / 200 300 400 600 700 800)
    fdf40000.rkvenc: venc_ondemand / 0 MHz (rknpu_ondemand vdec2_ondemand venc_ondemand userspace powersave performance simple_ondemand / 297000 400000)
    fdf80200.rkvdec: vdec2_ondemand / 0 MHz (rknpu_ondemand vdec2_ondemand venc_ondemand userspace powersave performance simple_ondemand / 297000 400000)

Tuned governor settings:

    cpufreq-policy0: performance / 1992 MHz
    fde40000.npu: performance / 900 MHz
    fde60000.gpu: performance / 800 MHz
    fdf40000.rkvenc: performance / 400 MHz
    fdf80200.rkvdec: performance / 400 MHz

Status of performance related policies found below /sys:

    /sys/devices/platform/fde60000.gpu/power_policy: [coarse_demand] always_on
    /sys/module/pcie_aspm/parameters/policy: default [performance] powersave powersupersave

### Clockspeeds (idle vs. heated up):

Before at 37.2°C:

    cpu0 (Cortex-A55): OPP: 1992, Measured: 1959      (-1.7%)

After at 47.8°C:

    cpu0 (Cortex-A55): OPP: 1992, Measured: 1950      (-2.1%)

### Performance baseline

  * memcpy: 3066.5 MB/s, memchr: 2979.7 MB/s, memset: 6243.8 MB/s
  * 16M latency: 163.8 164.6 163.6 164.7 165.3 164.3 217.7 398.6 
  * 128M latency: 180.2 180.1 178.5 191.5 178.8 179.8 226.9 416.1 
  * 7-zip MIPS (3 consecutive runs): 5015, 5058, 5033 (5040 avg), single-threaded: 1427
  * `aes-256-cbc     156188.08k   416266.15k   702350.42k   854077.44k   911488.34k   915881.98k`
  * `aes-256-cbc     156215.43k   415491.37k   703741.53k   853168.13k   909778.94k   914292.74k`

### PCIe and storage devices:

  * Realtek RTL8125 2.5GbE: Speed 5GT/s, Width x1, driver in use: r8169
  * Realtek RTL8125 2.5GbE: Speed 5GT/s, Width x1, driver in use: r8169
  * 111.8GB "Samsung SSD 750 EVO 120GB" SSD as /dev/sda [SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)]: behind ASMedia SATA 6Gb/s bridge (174c:55aa), 3% worn out, Driver=uas, 5Gbps (capable of 12Mbps, 480Mbps, 5Gbps), drive temp: 24°C
  * 59.5GB "SanDisk SN64G" UHS SDR104 SDXC card as /dev/mmcblk0: date 03/2022, manfid/oemid: 0x000003/0x5344, hw/fw rev: 0x8/0x6
  * 7.3GB "Samsung 8GTF4R" HS200 eMMC 5.1 card as /dev/mmcblk2: date 03/2022, manfid/oemid: 0x000015/0x0100, hw/fw rev: 0x0/0x0600000000000000

### Software versions:

  * Debian GNU/Linux 12 (bookworm)
  * Build scripts: DietPi 8.23.3, https://github.com/MichaIng/DietPi/tree/master
  * Compiler: /usr/bin/gcc (Debian 12.2.0-14) 12.2.0 / aarch64-linux-gnu
  * OpenSSL 3.0.11, built on 19 Sep 2023 (Library: OpenSSL 3.0.11 19 Sep 2023)    

### Kernel info:

  * `/proc/cmdline: storagemedia=sd androidboot.storagemedia=sd androidboot.mode=normal androidboot.dtbo_idx=1 androidboot.verifiedbootstate=orange earlycon=uart8250,mmio32,0xfe660000 console=ttyFIQ0 coherent_pool=1m rw root=/dev/mmcblk0p8 rootfstype=ext4 data=/dev/mmcblk0p9 consoleblank=0 cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory swapaccount=1`
  * Vulnerability Spectre v1:        Mitigation; __user pointer sanitization
  * Kernel 5.10.160 / CONFIG_HZ=100

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

All known settings adjusted for performance. Device now ready for benchmarking.
Once finished stop with [ctrl]-[c] to get info about throttling, frequency cap
and too high background activity all potentially invalidating benchmark scores.
All changes with storage and PCIe devices as well as suspicious dmesg contents
will be reported too.