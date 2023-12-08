# NanoPi NEO4

Tested with sbc-bench v0.9.36 on Wed, 01 Mar 2023 19:38:19 +0100. Full info: [http://ix.io/4pCK](../4pCK.txt)

### General information:

The CPU features 2 clusters of different core types:

    Rockchip RK3399, Kernel: aarch64, Userland: arm64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      408    1512   Cortex-A53 / r0p4
      1        0        0      408    1512   Cortex-A53 / r0p4
      2        0        0      408    1512   Cortex-A53 / r0p4
      3        0        0      408    1512   Cortex-A53 / r0p4
      4        1        4      408    2016   Cortex-A72 / r0p2
      5        1        4      408    2016   Cortex-A72 / r0p2

977 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: ondemand / 1512 MHz (conservative ondemand userspace powersave performance schedutil / 408 600 816 1008 1200 1416 1512)
    cpufreq-policy4: ondemand / 2016 MHz (conservative ondemand userspace powersave performance schedutil / 408 600 816 1008 1200 1416 1608 1800 2016)
    ff9a0000.gpu: performance / 800 MHz (powersave performance simple_ondemand / 200 297 400 500 600 800)

Tuned governor settings:

    cpufreq-policy0: performance / 1512 MHz
    cpufreq-policy4: performance / 2016 MHz
    ff9a0000.gpu: performance / 800 MHz

Status of performance related policies found below /sys:

    /sys/module/pcie_aspm/parameters/policy: default [performance] powersave powersupersave

### Clockspeeds (idle vs. heated up):

Before at 21.1°C:

    cpu0-cpu3 (Cortex-A53): OPP: 1512, Measured: 1509 
    cpu4-cpu5 (Cortex-A72): OPP: 2016, Measured: 2014 

After at 72.2°C:

    cpu0-cpu3 (Cortex-A53): OPP: 1512, Measured: 1509 
    cpu4-cpu5 (Cortex-A72): OPP: 2016, Measured: 2014 

### Performance baseline

  * cpu0 (Cortex-A53): memcpy: 1749.6 MB/s, memchr: 2036.7 MB/s, memset: 6106.6 MB/s
  * cpu4 (Cortex-A72): memcpy: 2421.4 MB/s, memchr: 5997.6 MB/s, memset: 6131.8 MB/s
  * cpu0 (Cortex-A53) 16M latency: 173.3 173.8 170.8 173.7 170.8 173.6 209.0 403.6 
  * cpu4 (Cortex-A72) 16M latency: 173.5 175.5 175.1 175.0 173.9 175.2 177.4 211.1 
  * 7-zip MIPS (3 consecutive runs): 6993, 6973, 6962 (6980 avg), single-threaded: 1911
  * `aes-256-cbc     117663.17k   314397.78k   533072.55k   655871.32k   703031.98k   705325.74k (Cortex-A53)`
  * `aes-256-cbc     354084.03k   740885.42k  1009262.93k  1099571.88k  1138778.11k  1140801.54k (Cortex-A72)`

### Storage devices:

  * 7.3GB "Silicon Motion Flash Drive" as /dev/sda: USB, Driver=usb-storage, 480Mbps
  * 7.3GB "Samsung 8WPD3R" HS200 eMMC 5.0 card as /dev/mmcblk2: date 09/2017, manfid/oemid: 0x000015/0x0100, hw/fw rev: 0x0/0x0000000000000000

### Swap configuration:

  * /dev/zram0: 488.8M (0K used, lzo-rle, 6 streams, 4K data, 73B compressed, 12K total)

### Software versions:

  * Ubuntu 20.04.3 LTS (focal) arm64
  * Build scripts: https://github.com/armbian/build, 21.08.3, NanoPi Neo 4, rk3399, rockchip64
  * Compiler: /usr/bin/gcc (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0 / aarch64-linux-gnu

### Kernel info:

  * `/proc/cmdline: root=UUID=3e246dd1-0772-496f-8d13-59d2f372e2b0 rootwait rootfstype=btrfs console=ttyS2,1500000 console=tty1 consoleblank=0 loglevel=1 ubootpart=60578a52-01 usb-storage.quirks=0x2537:0x1066:u,0x2537:0x1068:u CONFIG_RAID6_PQ_DEFAULT_ALG=neonx4  cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory swapaccount=1`
  * Vulnerability Spec store bypass: Vulnerable
  * Vulnerability Spectre v1:        Mitigation; __user pointer sanitization
  * Vulnerability Spectre v2:        Vulnerable
  * Kernel 5.10.63-rockchip64 / CONFIG_HZ=250

Kernel 5.10.63 is not latest 5.10.170 LTS that was released on 2023-02-25.

See https://endoflife.date/linux for details. It is somewhat likely that
a lot of exploitable vulnerabilities exist for this kernel as well as many
unfixed bugs.
