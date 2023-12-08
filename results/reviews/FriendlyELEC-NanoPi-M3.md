# FriendlyElec NanoPi M3

Tested with sbc-bench v0.9.37 on Tue, 07 Mar 2023 13:28:32 +0000. Full info: [http://ix.io/4qaC](../4qaC.txt)

### General information:

    Nexell S5P6818, Kernel: aarch64, Userland: arm64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      400    1400   Cortex-A53 / r0p3
      1        0        0      400    1400   Cortex-A53 / r0p3
      2        0        0      400    1400   Cortex-A53 / r0p3
      3        0        0      400    1400   Cortex-A53 / r0p3
      4        1        0      400    1400   Cortex-A53 / r0p3
      5        1        0      400    1400   Cortex-A53 / r0p3
      6        1        0      400    1400   Cortex-A53 / r0p3
      7        1        0      400    1400   Cortex-A53 / r0p3

954 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: performance / 1400 MHz (conservative ondemand userspace powersave interactive performance schedutil / 400 500 600 700 800 900 1000 1100 1200 1300 1400)

Tuned governor settings:

    cpufreq-policy0: performance / 1400 MHz

### Clockspeeds (idle vs. heated up):

Before at 41.0°C:

    cpu0 (Cortex-A53): OPP: 1400, Measured: 1395 

After at 66.0°C:

    cpu0 (Cortex-A53): OPP: 1400, Measured: 1395 

### Performance baseline

  * memcpy: 1529.7 MB/s, memchr: 2131.0 MB/s, memset: 4576.5 MB/s
  * 16M latency: 156.1 158.7 156.4 158.4 156.1 157.2 223.5 416.3 
  * 7-zip MIPS (3 consecutive runs): 6709, 6770, 7015 (6830 avg), single-threaded: 1136
  * `aes-256-cbc     108851.57k   292273.17k   492536.18k   607809.19k   650906.28k   650755.06k`
  * `aes-256-cbc     109601.95k   291240.63k   494520.41k   605415.68k   651433.30k   653650.60k`

### Storage devices:

  * 59.5GB "SanDisk SD64G" HS SDXC card as /dev/mmcblk0: date 08/2020, manfid/oemid: 0x000003/0x5344, hw/fw rev: 0x8/0x5

### Swap configuration:

  * /swapfile: 2.0G (40.5M used) on ultra slow SD card storage

### Software versions:

  * Ubuntu 20.04.5 LTS
  * Compiler: /usr/bin/gcc (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0 / aarch64-linux-gnu

### Kernel info:

  * `/proc/cmdline: console=ttySAC0,115200n8 root=/dev/mmcblk0p2 rootfstype=ext4 rootwait data=/dev/mmcblk0p3 init=/sbin/init loglevel=7 printk.time=1 consoleblank=0 cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory swapaccount=1 lcd=HDMI720P60 bootdev=2`
  * Kernel 4.4.172-s5p6818 / CONFIG_HZ=250

Kernel version 4.4.172 is not covered by any active release cycle any more.

See https://endoflife.date/linux for details. It is highly likely countless
exploitable vulnerabilities do exist for this kernel as well as tons of bugs.

This device runs a Nexell vendor/BSP kernel.

The 4.4 series has reached end-of-life on 2022-02-03 with version 4.4.302.