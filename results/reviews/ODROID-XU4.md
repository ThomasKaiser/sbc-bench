# Hardkernel Odroid XU4

Tested on Sat, 18 Feb 2023 11:55:37 +0100. Full info: [http://ix.io/4oqR](http://ix.io/4oqR)

### General information:

    Samsung Exynos EXYNOS5800 rev 1, Exynos 5422, Kernel: armv7l, Userland: armhf
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        1        0      200    1400   Cortex-A7 / r0p3
      1        1        0      200    1400   Cortex-A7 / r0p3
      2        1        0      200    1400   Cortex-A7 / r0p3
      3        1        0      200    1400   Cortex-A7 / r0p3
      4        0        4      200    2000   Cortex-A15 / r2p3
      5        0        4      200    2000   Cortex-A15 / r2p3
      6        0        4      200    2000   Cortex-A15 / r2p3
      7        0        4      200    2000   Cortex-A15 / r2p3

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: ondemand / 1400 MHz (powersave userspace conservative ondemand performance schedutil)
    cpufreq-policy4: ondemand / 2000 MHz (powersave userspace conservative ondemand performance schedutil)
    soc:bus_wcore: simple_ondemand / 84 MHz (userspace powersave performance simple_ondemand)
    10c20000.memory-controller: simple_ondemand / 413 MHz (userspace powersave performance simple_ondemand)

Tuned governor settings:

    cpufreq-policy0: performance / 1400 MHz
    cpufreq-policy4: performance / 2000 MHz
    soc:bus_wcore: performance / 400 MHz
    10c20000.memory-controller: performance / 825 MHz

Status of performance related policies found below /sys:

    /sys/devices/platform/soc/11800000.gpu/power_policy: [demand] coarse_demand always_on

### Clockspeeds (idle vs. heated up):

Before at 49.0°C:

    cpu0-cpu3 (Cortex-A7): OPP: 1400, Measured: 1396 
    cpu4-cpu7 (Cortex-A15): OPP: 2000, Measured: 1996 

After at 77.0°C:

    cpu0-cpu3 (Cortex-A7): OPP: 1400, Measured: 1396 
    cpu4-cpu7 (Cortex-A15): OPP: 2000, Measured: 1996 

### Storage devices:

  * 14.9GB SanDisk SC16G SD card as /dev/mmcblk1: date 06/2019, man/oem ID: 0x000003/0x5344, hw/fw rev: 0x8/0x0
  * HGST HDN724040ALE640 HDD as /dev/sda as /dev/sda: USB, Driver=uas, 5000M, 40°C

### Software versions:

  * Ubuntu 20.04.3 LTS (focal) arm
  * Build scripts: https://github.com/armbian/build, 21.08.3, Odroid XU4, odroidxu4, odroidxu4
  * Compiler: /usr/bin/gcc (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0 / arm-linux-gnueabihf
  * OpenSSL 1.1.1f, built on 31 Mar 2020

### Kernel info:

  * `/proc/cmdline: console=ttySAC2,115200n8 console=tty1 consoleblank=0 loglevel=1 root=UUID=57f06418-7fe0-4d7a-89b9-31dcc07b8b27 rootfstype=ext4 rootwait rw  smsc95xx.macaddr=00:1e:06:61:7a:55 governor=performance hdmi_tx_amp_lvl=31 hdmi_tx_lvl_ch0=3 hdmi_tx_lvl_ch1=3 hdmi_tx_lvl_ch2=3 hdmi_tx_emp_lvl=6 hdmi_clk_amp_lvl=31 hdmi_tx_res=0 HPD=true vout=hdmi usb-storage.quirks= `
  * Kernel 5.4.151-odroidxu4 / CONFIG_HZ=100

Kernel 5.4.151 is not latest 5.4.231 LTS that was released on 2023-02-06.

Please check https://endoflife.date/linux for details. It is somewhat likely
that a lot of exploitable vulnerabilities exist for this kernel as well as
many unfixed bugs. Better upgrade to a supported version ASAP.

But this version string doesn't matter since this is not an official LTS Linux
from kernel.org. This device runs a Samsung vendor/BSP kernel.
