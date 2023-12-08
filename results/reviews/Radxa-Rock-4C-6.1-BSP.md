# Radxa ROCK Pi 4C

Tested with sbc-bench v0.9.51 on Sun, 19 Nov 2023 11:34:51 +0300. Full info: [http://ix.io/4LT2](../4LT2.txt)

### General information:

The CPU features 2 clusters of different core types:

    Rockchip RK3399, Kernel: aarch64, Userland: arm64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      408    1416   Cortex-A53 / r0p4
      1        0        0      408    1416   Cortex-A53 / r0p4
      2        0        0      408    1416   Cortex-A53 / r0p4
      3        0        0      408    1416   Cortex-A53 / r0p4
      4        0        4      408    1800   Cortex-A72 / r0p2
      5        0        4      408    1800   Cortex-A72 / r0p2

3863 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: performance / 1416 MHz (conservative ondemand userspace powersave performance schedutil / 408 600 816 1008 1200 1416)
    cpufreq-policy4: performance / 1800 MHz (conservative ondemand userspace powersave performance schedutil / 408 600 816 1008 1200 1416 1608 1800)
    ff9a0000.gpu: simple_ondemand / 200 MHz (powersave performance simple_ondemand / 200 297 400 500 600 800)

Tuned governor settings:

    cpufreq-policy0: performance / 1416 MHz
    cpufreq-policy4: performance / 1800 MHz
    ff9a0000.gpu: performance / 800 MHz

Status of performance related policies found below /sys:

    /sys/module/pcie_aspm/parameters/policy: default [performance] powersave powersupersave

### Clockspeeds (idle vs. heated up):

Before at 38.1°C:

    cpu0-cpu3 (Cortex-A53): OPP: 1416, Measured: 1413 
    cpu4-cpu5 (Cortex-A72): OPP: 1800, Measured: 1798 

After at 56.7°C:

    cpu0-cpu3 (Cortex-A53): OPP: 1416, Measured: 1413 
    cpu4-cpu5 (Cortex-A72): OPP: 1800, Measured: 1798 

### Performance baseline

  * cpu0 (Cortex-A53): memcpy: 1755.4 MB/s, memchr: 1762.9 MB/s, memset: 8268.7 MB/s
  * cpu4 (Cortex-A72): memcpy: 3402.9 MB/s, memchr: 6120.0 MB/s, memset: 8265.7 MB/s
  * cpu0 (Cortex-A53) 16M latency: 184.7 187.7 183.8 186.9 183.8 187.1 234.3 447.0 
  * cpu4 (Cortex-A72) 16M latency: 194.9 195.7 195.4 195.4 195.1 198.7 205.1 240.6 
  * cpu0 (Cortex-A53) 128M latency: 194.0 197.6 193.2 197.5 193.1 197.0 242.5 455.8 
  * cpu4 (Cortex-A72) 128M latency: 220.8 210.5 207.5 210.1 210.4 217.6 233.6 259.5 
  * 7-zip MIPS (3 consecutive runs): 6488, 6477, 6463 (6480 avg), single-threaded: 1732
  * `aes-256-cbc      95627.65k   266993.19k   473485.74k   603906.05k   656263.85k   660209.66k (Cortex-A53)`
  * `aes-256-cbc     279186.01k   618499.80k   859511.04k   967358.46k  1019830.27k  1020291.75k (Cortex-A72)`

### Storage devices:

  * 119.2GB "ADATA SX6000LNP" SSD as /dev/nvme0: Speed 5GT/s (downgraded), Width x4, 0% worn out, drive temp: 43°C
  * 14.8GB "SanDisk SC16G" HS SD card as /dev/mmcblk0: date 04/2018, manfid/oemid: 0x000003/0x5344, hw/fw rev: 0x8/0x0
  * Xtx XT25F32B 4MB SPI NOR flash, drivers in use: spi-nor/rockchip-spi

### Swap configuration:

  * /dev/zram0: 1.9G (0K used, lzo-rle, 6 streams, 4K data, 74B compressed, 12K total)

### Software versions:

  * Armbian 23.8.3 bookworm arm64
  * Build scripts: https://github.com/armbian/build, 23.8.1, Rockpi 4C, rockchip64, rockchip64
  * Compiler: /usr/bin/gcc (Debian 12.2.0-14) 12.2.0 / aarch64-linux-gnu
  * OpenSSL 3.0.11, built on 19 Sep 2023 (Library: OpenSSL 3.0.11 19 Sep 2023)    

### Kernel info:

  * `/proc/cmdline: root=UUID=0a2806ef-0e7b-4f8d-8845-2949566d33b7 rootwait rootfstype=ext4 splash=verbose console=ttyS2,1500000 console=tty1 consoleblank=0 loglevel=1 ubootpart=67fb20dc-01 usb-storage.quirks=0x2537:0x1066:u,0x2537:0x1068:u apparmor=1 security=apparmor  cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory swapaccount=1`
  * Vulnerability Spec store bypass:    Vulnerable
  * Vulnerability Spectre v1:           Mitigation; __user pointer sanitization
  * Vulnerability Spectre v2:           Vulnerable
  * Kernel 6.1.50-current-rockchip64 / CONFIG_HZ=250

Kernel 6.1.50 is not latest 6.1.62 LTS that was released on 2023-11-08.

See https://endoflife.date/linux for details. Perhaps some kernel bugs have
been fixed in the meantime and maybe vulnerabilities as well.