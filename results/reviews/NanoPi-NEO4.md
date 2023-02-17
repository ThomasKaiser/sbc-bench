# NanoPi NEO4

Tested on Fri, 17 Feb 2023 18:59:01 +0100. Full info: [http://ix.io/4omz](http://ix.io/4omz)

### General information:

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

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: ondemand / 1512 MHz (conservative ondemand userspace powersave performance schedutil)
    cpufreq-policy4: ondemand / 2016 MHz (conservative ondemand userspace powersave performance schedutil)
    ff9a0000.gpu: performance / 800 MHz (performance simple_ondemand)

Tuned governor settings:

    cpufreq-policy0: performance / 1512 MHz
    cpufreq-policy4: performance / 2016 MHz
    ff9a0000.gpu: performance / 800 MHz

Status of performance related policies found below /sys:

    /sys/module/pcie_aspm/parameters/policy: default [performance] powersave powersupersave

### Clockspeeds (idle vs. heated up):

Before at 53.3°C:

    cpu0-cpu3 (Cortex-A53): OPP: 1512, Measured: 1509 
    cpu4-cpu5 (Cortex-A72): OPP: 2016, Measured: 2014 

After at 81.1°C:

    cpu0-cpu3 (Cortex-A53): OPP: 1512, Measured: 1509 
    cpu4-cpu5 (Cortex-A72): OPP: 2016, Measured: 2014 

### Storage devices:

  * 7.3GB Samsung 8WPD3R eMMC as /dev/mmcblk2: date 09/2017, man/oem ID: 0x000015/0x0100, hw/fw rev: 0x0/0x0000000000000000

### Software versions:

  * Ubuntu 20.04.3 LTS (focal) arm64
  * Build scripts: https://github.com/armbian/build, 21.08.3, NanoPi Neo 4, rk3399, rockchip64
  * Compiler: /usr/bin/gcc (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0 / aarch64-linux-gnu
  * OpenSSL 1.1.1f, built on 31 Mar 2020

### Kernel info:

  * `/proc/cmdline: root=UUID=3e246dd1-0772-496f-8d13-59d2f372e2b0 rootwait rootfstype=btrfs console=ttyS2,1500000 console=tty1 consoleblank=0 loglevel=1 ubootpart=60578a52-01 usb-storage.quirks=0x2537:0x1066:u,0x2537:0x1068:u CONFIG_RAID6_PQ_DEFAULT_ALG=neonx4  cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory swapaccount=1`
  * Vulnerability Spec store bypass: Vulnerable
  * Vulnerability Spectre v1:        Mitigation; __user pointer sanitization
  * Vulnerability Spectre v2:        Vulnerable
  * Kernel 5.10.63-rockchip64 / CONFIG_HZ=250

Kernel 5.10.63 is not latest 5.10.168 LTS that was released on 2023-02-15.

Please check https://endoflife.date/linux for details. It is somewhat likely
that a lot of exploitable vulnerabilities exist for this kernel as well as
many unfixed bugs. Better upgrade to a supported version ASAP.

All known settings adjusted for performance. System now\033[0m ready for benchmarking.
Once finished stop with [ctrl]-[c] to get info about throttling, frequency cap
and too high background activity all potentially invalidating benchmark scores.