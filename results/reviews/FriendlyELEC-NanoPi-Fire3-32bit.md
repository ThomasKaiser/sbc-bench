# FriendlyElec NanoPi Fire3

Tested with sbc-bench v0.9.37 on Thu, 09 Mar 2023 15:46:43 +0000. Full info: [http://ix.io/4qm8](http://ix.io/4qm8)

### General information:

    Nexell S5P6818, Kernel: armv7l, Userland: armhf
    
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

    cpufreq-policy0: ondemand / 1400 MHz (conservative ondemand userspace powersave interactive performance schedutil / 400 500 600 700 800 900 1000 1100 1200 1300 1400)

Tuned governor settings:

    cpufreq-policy0: performance / 1400 MHz

### Clockspeeds (idle vs. heated up):

Before at 65.0°C:

    cpu0 (Cortex-A53): OPP: 1400, Measured: 1395 

After at 47.0°C (throttled):

    cpu0 (Cortex-A53): OPP: 1400, Measured: 1396 

### Performance baseline

  * memcpy: 1645.5 MB/s, memchr: 2057.3 MB/s, memset: 3714.1 MB/s
  * 16M latency: 159.0 160.6 159.1 159.3 159.0 160.2 230.1 444.8 
  * 7-zip MIPS (3 consecutive runs): 7366, 7365, 7463 (7400 avg), single-threaded: 1144
  * `aes-256-cbc      98707.27k   273482.94k   478640.04k   599685.02k   648536.06k   650771.39k`
  * `aes-256-cbc      99225.53k   272750.03k   478245.72k   601413.63k   647042.81k   652875.09k`

### Storage devices:

  * 111.8GB "Transcend TS120GMTS420" SSD as /dev/sda [SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)]: behind JMicron JMS578 SATA 6Gb/s bridge, 1% worn out, Driver=uas, 480Mbps (capable of 12Mbps, 480Mbps, 5Gbps), drive temp: 30°C
  * 7.4GB "SanDisk SU08G" HS SD card as /dev/mmcblk0: date 06/2013, manfid/oemid: 0x000003/0x5344, hw/fw rev: 0x8/0x0

### Swap configuration:

  * /swapfile on /dev/mmcblk0p2: 2.0G (30.2M used) on ultra slow SD card storage

### Software versions:

  * Ubuntu 20.04 LTS
  * Compiler: /usr/bin/gcc (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0 / arm-linux-gnueabihf

### Kernel info:

  * `/proc/cmdline: console=ttySAC0,115200n8 root=/dev/mmcblk0p2 rootfstype=ext4 rootwait data=/dev/mmcblk0p3 init=/sbin/init loglevel=7 printk.time=1 consoleblank=0 cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory swapaccount=1 lcd=HDMI720P60 bootdev=2`
  * Kernel 4.4.172-s5p6818 / CONFIG_HZ=250

Kernel version 4.4.172 is not covered by any active release cycle any more.

See https://endoflife.date/linux for details. It is highly likely countless
exploitable vulnerabilities do exist for this kernel as well as tons of bugs.

This device runs a Nexell vendor/BSP kernel.

The 4.4 series has reached end-of-life on 2022-02-03 with version 4.4.302.

All known settings adjusted for performance. Device now ready for benchmarking.
Once finished stop with [ctrl]-[c] to get info about throttling, frequency cap
and too high background activity all potentially invalidating benchmark scores.
All changes with storage and PCIe devices as well as suspicious dmesg contents
will be reported too.
