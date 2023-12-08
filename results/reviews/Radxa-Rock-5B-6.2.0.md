# Radxa ROCK 5 Model B

Tested with sbc-bench v0.9.39 on Mon, 13 Mar 2023 18:31:36 +0100. Full info: [http://ix.io/4qJG](../4qJG.txt)

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

Before at 39.8°C:

    cpu0-cpu3 (Cortex-A55): OPP: 1800, Measured: 1934      (+7.4%)
    cpu4-cpu5 (Cortex-A76): OPP: 2208, Measured: 2200 
    cpu6-cpu7 (Cortex-A76): OPP: 2208, Measured: 2200 

After at 73.9°C (throttled):

    cpu0-cpu3 (Cortex-A55): OPP: 1800, Measured: 1901      (+5.6%)
    cpu4-cpu5 (Cortex-A76): OPP: 2208, Measured: 2165      (-1.9%)
    cpu6-cpu7 (Cortex-A76): OPP: 2208, Measured: 2166      (-1.9%)

### Performance baseline

  * cpu0 (Cortex-A55): memcpy: 6304.2 MB/s, memchr: 2953.1 MB/s, memset: 23443.4 MB/s
  * cpu4 (Cortex-A76): memcpy: 11010.9 MB/s, memchr: 15649.1 MB/s, memset: 29903.2 MB/s
  * cpu6 (Cortex-A76): memcpy: 10960.2 MB/s, memchr: 15558.6 MB/s, memset: 29896.8 MB/s
  * cpu0 (Cortex-A55) 16M latency: 118.6 119.4 116.7 119.4 115.4 120.5 195.2 355.9 
  * cpu4 (Cortex-A76) 16M latency: 119.9 108.8 117.2 108.7 118.2 109.7 110.9 107.7 
  * cpu6 (Cortex-A76) 16M latency: 121.4 109.3 117.9 108.9 118.9 112.2 108.3 107.5 
  * cpu0 (Cortex-A55) 128M latency: 143.3 144.0 143.0 143.9 141.9 143.8 216.7 374.7 
  * cpu4 (Cortex-A76) 128M latency: 139.8 140.1 139.5 139.9 139.7 139.1 135.7 140.2 
  * cpu6 (Cortex-A76) 128M latency: 137.7 137.3 137.6 137.0 137.3 136.2 133.4 138.4 
  * 7-zip MIPS (3 consecutive runs): 16080, 16167, 15941 (16060 avg), single-threaded: 2989
  * `aes-256-cbc     150078.27k   398867.56k   683696.21k   836602.20k   894814.89k   899366.91k (Cortex-A55)`
  * `aes-256-cbc     507982.99k   935091.14k  1152068.18k  1219231.40k  1244585.98k  1247040.85k (Cortex-A76)`
  * `aes-256-cbc     506464.87k   935066.86k  1152521.05k  1218229.59k  1244987.39k  1247494.14k (Cortex-A76)`

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

  * everything set to powersave: 3590 mW
  * /sys/devices/system/cpu/cpufreq/policy0 set to performance: 3620 mW
  * /sys/devices/system/cpu/cpufreq/policy4 set to performance: 3530 mW
  * /sys/devices/system/cpu/cpufreq/policy6 set to performance: 3480 mW
  * /sys/module/pcie_aspm/parameters/policy set to performance: 3690 mW
