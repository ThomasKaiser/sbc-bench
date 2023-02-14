# Radxa ROCK Pi 4A

Tested on Tue, 14 Feb 2023 11:57:30 +0000. Full info: [http://ix.io/4o0G](http://ix.io/4o0G)

### General information:

    Rockchip RK3399, Kernel: aarch64, Userland: arm64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      408    1416   Cortex-A53 / r0p4
      1        0        0      408    1416   Cortex-A53 / r0p4
      2        0        0      408    1416   Cortex-A53 / r0p4
      3        0        0      408    1416   Cortex-A53 / r0p4
      4        1        4      408    1800   Cortex-A72 / r0p2
      5        1        4      408    1800   Cortex-A72 / r0p2

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: ondemand / 1008 MHz (ondemand performance schedutil)
    cpufreq-policy4: ondemand / 408 MHz (ondemand performance schedutil)
    dmc: dmc_ondemand / 856 MHz (dmc_ondemand simple_ondemand)
    ff9a0000.gpu: simple_ondemand / 200 MHz (dmc_ondemand simple_ondemand)

Tuned governor settings:

    cpufreq-policy0: performance / 1416 MHz
    cpufreq-policy4: performance / 1800 MHz
    dmc: performance / 856 MHz
    ff9a0000.gpu: performance / 800 MHz

Status of performance related policies found below /sys:

    /sys/devices/platform/ff9a0000.gpu/core_availability_policy: [fixed] devfreq
    /sys/devices/platform/ff9a0000.gpu/power_policy: [coarse_demand] always_on
    /sys/module/pcie_aspm/parameters/policy: default [performance] powersave powersupersave

### Clockspeeds (idle vs. heated up):

Before at 46.2°C:

    cpu0-cpu3 (Cortex-A53): OPP: 1416, Measured: 1412 
    cpu4-cpu5 (Cortex-A72): OPP: 1800, Measured: 1797 

After at 81.1°C:

    cpu0-cpu3 (Cortex-A53): OPP: 1416, Measured: 1412 
    cpu4-cpu5 (Cortex-A72): OPP: 1800, Measured: 1443     (-19.8%)

### Software versions:

  * Debian GNU/Linux 11 (bullseye)
  * Compiler: /usr/bin/gcc (Debian 10.2.1-6) 10.2.1 20210110 / aarch64-linux-gnu
  * OpenSSL 1.1.1n, built on 15 Mar 2022
  * Kernel 5.10.110-1-rockchip / CONFIG_HZ=300

Kernel 5.10.110 is not latest 5.10.166 LTS that was released on 2023-02-01.

Please check https://endoflife.date/linux for details. It is somewhat likely
that a lot of exploitable vulnerabilities exist for this kernel as well as
many unfixed bugs. Better upgrade to a supported version ASAP.

But this version string doesn't matter that much since this device is not
running an official LTS Linux from kernel.org.

This device runs a Rockchip BSP kernel based on a mixture of Android GKI and
other sources. Also some community attempts to do version string cosmetics
might have happened, see https://tinyurl.com/2p8fuubd for example. To examine
how far away this 5.10.110 is from an official LTS of same version someone
would have to reapply Rockchip's thousands of patches to a clean 5.10.110 LTS.
