# Radxa ROCK 5B

Tested on Thu, 16 Feb 2023 23:36:03 +0100. Full info: [http://ix.io/4ohT](http://ix.io/4ohT)

### General information:

    Rockchip RK3588/RK3588s (35880000), Kernel: aarch64, Userland: arm64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      408    1800   Cortex-A55 / r2p0
      1        0        0      408    1800   Cortex-A55 / r2p0
      2        0        0      408    1800   Cortex-A55 / r2p0
      3        0        0      408    1800   Cortex-A55 / r2p0
      4        1        4      408    2400   Cortex-A76 / r4p0
      5        1        4      408    2400   Cortex-A76 / r4p0
      6        2        6      408    2400   Cortex-A76 / r4p0
      7        2        6      408    2400   Cortex-A76 / r4p0

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: ondemand / 1200 MHz (conservative ondemand userspace powersave performance schedutil)
    cpufreq-policy4: ondemand / 408 MHz (conservative ondemand userspace powersave performance schedutil)
    cpufreq-policy6: ondemand / 408 MHz (conservative ondemand userspace powersave performance schedutil)
    dmc: dmc_ondemand / 528 MHz (dmc_ondemand userspace powersave performance simple_ondemand)
    fb000000.gpu: simple_ondemand / 300 MHz (dmc_ondemand userspace powersave performance simple_ondemand)
    fdab0000.npu: userspace / 1000 MHz (dmc_ondemand userspace powersave performance simple_ondemand)

Tuned governor settings:

    cpufreq-policy0: performance / 1800 MHz
    cpufreq-policy4: performance / 2400 MHz
    cpufreq-policy6: performance / 2400 MHz
    dmc: performance / 2112 MHz
    fb000000.gpu: performance / 1000 MHz
    fdab0000.npu: performance / 1000 MHz

Status of performance related policies found below /sys:

    /sys/devices/platform/fb000000.gpu/power_policy: [coarse_demand] always_on
    /sys/module/pcie_aspm/parameters/policy: default [performance] powersave powersupersave

### Clockspeeds (idle vs. heated up):

Before at 43.5°C:

    cpu0-cpu3 (Cortex-A55): OPP: 1800, Measured: 1821      (+1.2%)
    cpu4-cpu5 (Cortex-A76): OPP: 2400, Measured: 2329      (-3.0%)
    cpu6-cpu7 (Cortex-A76): OPP: 2400, Measured: 2328      (-3.0%)

After at 81.3°C:

    cpu0-cpu3 (Cortex-A55): OPP: 1800, Measured: 1792 
    cpu4-cpu5 (Cortex-A76): OPP: 2400, Measured: 2282      (-4.9%)
    cpu6-cpu7 (Cortex-A76): OPP: 2400, Measured: 2282      (-4.9%)

### Attached PCIe and storage devices:

  * KXG50ZNV256G NVMe TOSHIBA 256GB SSD as /dev/nvme0n1: Speed 8GT/s, Width x4, 13% worn out, 0/0 errors, 67°C
  * Realtek RTL8125 2.5GbE: Speed 5GT/s, Width x1, driver in use: r8125
  * TS-RDF5SD Transcend as /dev/sda: USB, Driver=usb-storage, 5000M

### Software versions:

  * Ubuntu 22.10 (kinetic) arm64
  * Build scripts: Rock 5B, rockchip-rk3588, rockchip-rk3588, 22.11.0-trunk.0114, https://github.com/armbian/build
  * Compiler: /usr/bin/gcc (Ubuntu 12.2.0-3ubuntu1) 12.2.0 / aarch64-linux-gnu
  * OpenSSL 3.0.5, built on 5 Jul 2022 (Library: OpenSSL 3.0.5 5 Jul 2022)
  * Kernel 5.10.72-rockchip-rk3588 / CONFIG_HZ=300

Kernel 5.10.72 is not latest 5.10.168 LTS that was released on 2023-02-15.

Please check https://endoflife.date/linux for details. It is somewhat likely
that a lot of exploitable vulnerabilities exist for this kernel as well as
many unfixed bugs. Better upgrade to a supported version ASAP.

But this version string doesn't matter that much since this device is not
running an official LTS Linux from kernel.org.

This device runs a Rockchip BSP kernel based on a mixture of Android GKI and
other sources. Also some community attempts to do version string cosmetics
might have happened, see https://tinyurl.com/2p8fuubd for example. To examine
how far away this 5.10.72 is from an official LTS of same version someone
would have to reapply Rockchip's thousands of patches to a clean 5.10.72 LTS.