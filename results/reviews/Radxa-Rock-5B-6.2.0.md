# Radxa ROCK 5 Model B

Tested with sbc-bench v0.9.38 on Mon, 13 Mar 2023 09:59:29 +0100. Full info: [http://ix.io/4qHs](http://ix.io/4qHs)

### General information:

The CPU features 3 clusters consisting of 2 different core types:

    Rockchip RK3588/RK3588s, Kernel: aarch64, Userland: arm64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      408    1800   Cortex-A55 / r2p0
      1        0        0      408    1800   Cortex-A55 / r2p0
      2        0        0      408    1800   Cortex-A55 / r2p0
      3        0        0      408    1800   Cortex-A55 / r2p0
      4        0        4      408    2208   Cortex-A76 / r4p0
      5        0        4      408    2208   Cortex-A76 / r4p0
      6        0        6      408    2208   Cortex-A76 / r4p0
      7        0        6      408    2208   Cortex-A76 / r4p0

15723 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: ondemand / 1008 MHz (conservative ondemand userspace powersave performance schedutil / 408 600 816 1008 1200 1416 1608 1800)
    cpufreq-policy4: ondemand / 816 MHz (conservative ondemand userspace powersave performance schedutil / 408 600 816 1008 1200 1416 1608 1800 2016 2208)
    cpufreq-policy6: ondemand / 816 MHz (conservative ondemand userspace powersave performance schedutil / 408 600 816 1008 1200 1416 1608 1800 2016 2208)

Tuned governor settings:

    cpufreq-policy0: performance / 1800 MHz
    cpufreq-policy4: performance / 2208 MHz
    cpufreq-policy6: performance / 2208 MHz

Status of performance related policies found below /sys:

    /sys/module/pcie_aspm/parameters/policy: default [performance] powersave powersupersave

### Clockspeeds (idle vs. heated up):

Before at 57.3°C:

    cpu0-cpu3 (Cortex-A55): OPP: 1800, Measured: 1914      (+6.3%)
    cpu4-cpu5 (Cortex-A76): OPP: 2208, Measured: 2181      (-1.2%)
    cpu6-cpu7 (Cortex-A76): OPP: 2208, Measured: 2183      (-1.1%)

After at 74.8°C (throttled):

    cpu0-cpu3 (Cortex-A55): OPP: 1800, Measured: 1900      (+5.6%)
    cpu4-cpu5 (Cortex-A76): OPP: 2208, Measured: 2165      (-1.9%)
    cpu6-cpu7 (Cortex-A76): OPP: 2208, Measured: 2166      (-1.9%)

### Performance baseline

  * cpu0 (Cortex-A55): memcpy: 5979.1 MB/s, memchr: 2932.0 MB/s, memset: 23281.8 MB/s
  * cpu4 (Cortex-A76): memcpy: 9457.3 MB/s, memchr: 12676.2 MB/s, memset: 29438.6 MB/s
  * cpu6 (Cortex-A76): memcpy: 9425.7 MB/s, memchr: 12666.3 MB/s, memset: 29566.5 MB/s
  * cpu0 (Cortex-A55) 16M latency: 115.5 118.1 115.9 118.5 114.3 123.7 209.1 377.4 
  * cpu4 (Cortex-A76) 16M latency: 118.9 109.2 118.5 119.9 117.9 107.8 109.0 107.8 
  * cpu6 (Cortex-A76) 16M latency: 120.2 110.0 119.7 109.9 119.8 110.2 106.3 107.9 
  * 7-zip MIPS (3 consecutive runs): 15657, 15806, 15774 (15740 avg), single-threaded: 2967
  * `aes-256-cbc     149535.40k   398629.65k   683161.69k   834064.73k   891655.51k   896237.57k (Cortex-A55)`
  * `aes-256-cbc     506252.57k   932121.17k  1148119.30k  1215015.94k  1240331.61k  1242966.70k (Cortex-A76)`
  * `aes-256-cbc     509503.30k   931815.47k  1148465.15k  1214641.83k  1241025.19k  1243600.21k (Cortex-A76)`

### PCIe and storage devices:

  * Realtek RTL8125 2.5GbE: Speed 5GT/s, Width x1, driver in use: r8169
  * 14.5GB "Foresee NCard" HS200 eMMC 5.0 card as /dev/mmcblk0: date 08/2016, manfid/oemid: 0x000088/0x0103, hw/fw rev: 0x0/0x0100000000000000
  * Macronix MX25U12835F 16MB SPI NOR flash, drivers in use: spi-nor/rockchip-sfc

### Swap configuration:

  * /dev/zram0: 7.7G (0K used, lzo-rle, 8 streams, 4K data, 74B compressed, 12K total)

### Software versions:

  * Ubuntu Lunar Lobster (development branch)
  * Build scripts: https://github.com/armbian/build, 23.05.0.0070, Rock 5B, rockchip-rk3588, rockchip-rk3588
  * Compiler: /usr/bin/gcc (Ubuntu 12.2.0-15ubuntu1) 12.2.0 / aarch64-linux-gnu

### Kernel info:

  * `/proc/cmdline: root=UUID=be9f7bc1-39d3-4f82-8b80-c2dc8ae94462 rootwait rootfstype=ext4 splash=verbose console=ttyS2,1500000 console=tty1 consoleblank=0 loglevel=1 ubootpart=bf52041d-fa47-2d41-a8bd-0b0c4dfc17a8 usb-storage.quirks=   cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory swapaccount=1`
  * Vulnerability Spec store bypass: Mitigation; Speculative Store Bypass disabled via prctl
  * Vulnerability Spectre v1:        Mitigation; __user pointer sanitization
  * Vulnerability Spectre v2:        Mitigation; CSV2, BHB
  * Kernel 6.2.0-rc1-rockchip-rk3588 / CONFIG_HZ=300

### Idle consumption (measured with Netio 4KF, FW v3.2.0):

  * everything set to powersave: 3610 mW
  * /sys/devices/system/cpu/cpufreq/policy0 set to performance: 3570 mW
  * /sys/devices/system/cpu/cpufreq/policy4 set to performance: 3570 mW
  * /sys/devices/system/cpu/cpufreq/policy6 set to performance: 3560 mW
  * /sys/module/pcie_aspm/parameters/policy set to performance: 3710 mW
