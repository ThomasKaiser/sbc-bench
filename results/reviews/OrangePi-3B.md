# Rockchip RK3566 OPi 3B

Tested with sbc-bench v0.9.45 on Tue, 07 Nov 2023 11:22:57 +0000. Full info: [http://ix.io/4KU0](../4KU0.txt)

### General information:

    Rockchip RK3566 (35662000), Kernel: aarch64, Userland: arm64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      408    1800   Cortex-A55 / r2p0
      1        0        0      408    1800   Cortex-A55 / r2p0
      2        0        0      408    1800   Cortex-A55 / r2p0
      3        0        0      408    1800   Cortex-A55 / r2p0

1978 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: performance / 1800 MHz (conservative ondemand userspace powersave performance schedutil / 408 600 816 1104 1416 1608 1800)
    fde40000.npu: performance / 900 MHz (rknpu_ondemand vdec2_ondemand venc_ondemand userspace powersave performance simple_ondemand / 200 297 400 600 700 800 900)
    fde60000.gpu: performance / 800 MHz (rknpu_ondemand vdec2_ondemand venc_ondemand userspace powersave performance simple_ondemand / 200 300 400 600 700 800)
    fdf40000.rkvenc: performance / 400 MHz (rknpu_ondemand vdec2_ondemand venc_ondemand userspace powersave performance simple_ondemand / 297 400)
    fdf80200.rkvdec: performance / 400 MHz (rknpu_ondemand vdec2_ondemand venc_ondemand userspace powersave performance simple_ondemand / 297 400)

Tuned governor settings:

    cpufreq-policy0: performance / 1800 MHz
    fde40000.npu: performance / 900 MHz
    fde60000.gpu: performance / 800 MHz
    fdf40000.rkvenc: performance / 400 MHz
    fdf80200.rkvdec: performance / 400 MHz

Status of performance related policies found below /sys:

    /sys/devices/platform/fde60000.gpu/power_policy: [coarse_demand] always_on
    /sys/module/pcie_aspm/parameters/policy: default [performance] powersave powersupersave

### Clockspeeds (idle vs. heated up):

Before at 48.3°C:

    cpu0 (Cortex-A55): OPP: 1800, Measured: 1849      (+2.7%)

After at 76.9°C:

    cpu0 (Cortex-A55): OPP: 1800, Measured: 1824      (+1.3%)

### Performance baseline

  * memcpy: 2812.5 MB/s, memchr: 2769.5 MB/s, memset: 7435.8 MB/s
  * 16M latency: 183.6 188.5 183.5 185.3 183.8 185.2 252.0 469.9 
  * 128M latency: 206.5 206.9 203.7 207.5 203.2 206.8 288.5 491.4 
  * 7-zip MIPS (3 consecutive runs): 4564, 4569, 4606 (4580 avg), single-threaded: 1315
  * `aes-256-cbc     150844.81k   397120.13k   666512.98k   807478.61k   859627.52k   863272.96k`
  * `aes-256-cbc     151367.86k   397159.79k   667582.38k   807349.59k   859542.87k   863573.33k`

### Storage devices:

  * 28.9GB "Foresee A3A551" HS200 eMMC 5.1 card as /dev/mmcblk0: date 01/2022, manfid/oemid: 0x0000d6/0x0103, hw/fw rev: 0x0/0x1200000000000000
  * 16MB SPI NOR flash, drivers in use: spi-nor/rockchip-sfc

### Swap configuration:

  * /dev/zram0: 989.2M (0K used, lzo-rle, 4 streams, 4K data, 74B compressed, 12K total)

### Software versions:

  * Ubuntu 22.04.3 LTS
  * Build scripts: https://github.com/armbian/build, 1.0.2, OPI 3B, rockchip-rk356x, rockchip-rk356x
  * Compiler: /usr/bin/gcc (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0 / aarch64-linux-gnu

### Kernel info:

  * `/proc/cmdline: root=UUID=4422a412-441a-4a68-b73f-2494d34afea5 rootwait rootfstype=ext4 splash=verbose console=ttyFIQ0 console=tty1 consoleblank=0 loglevel=1 ubootpart=659f73d2-935b-cf45-8dce-308152394b87 usb-storage.quirks=0x2537:0x1066:u,0x2537:0x1068:u cma=128M  cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory swapaccount=1 earlycon=uart8250,mmio32,0xfe660000`
  * Vulnerability Spectre v1:        Mitigation; __user pointer sanitization
  * Kernel 5.10.160-rockchip-rk356x / CONFIG_HZ=300