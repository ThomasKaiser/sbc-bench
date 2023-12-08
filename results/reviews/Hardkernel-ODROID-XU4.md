# Hardkernel Odroid XU4

Tested with sbc-bench v0.9.36 on Wed, 01 Mar 2023 17:45:14 +0100. Full info: [http://ix.io/4pC7](../4pC7.txt)

### General information:

The CPU features 2 clusters of different core types:

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

1990 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: ondemand / 1400 MHz (powersave userspace conservative ondemand performance schedutil / 200 300 400 500 600 700 800 900 1000 1100 1200 1300 1400)
    cpufreq-policy4: ondemand / 2000 MHz (powersave userspace conservative ondemand performance schedutil / 200 300 400 500 600 700 800 900 1000 1100 1200 1300 1400 1500 1600 1700 1800 1900 2000)
    soc:bus_wcore: simple_ondemand / 84 MHz (userspace powersave performance simple_ondemand / 84 111 222 333 400)
    10c20000.memory-controller: simple_ondemand / 825 MHz (userspace powersave performance simple_ondemand / 165 206 275 413 543 633 728 825)

Tuned governor settings:

    cpufreq-policy0: performance / 1400 MHz
    cpufreq-policy4: performance / 2000 MHz
    soc:bus_wcore: performance / 400 MHz
    10c20000.memory-controller: performance / 825 MHz

Status of performance related policies found below /sys:

    /sys/devices/platform/soc/11800000.gpu/power_policy: [demand] coarse_demand always_on

### Clockspeeds (idle vs. heated up):

Before at 31.0°C:

    cpu0-cpu3 (Cortex-A7): OPP: 1400, Measured: 1396 
    cpu4-cpu7 (Cortex-A15): OPP: 2000, Measured: 1996 

After at 76.0°C (throttled):

    cpu0-cpu3 (Cortex-A7): OPP: 1400, Measured: 1396 
    cpu4-cpu7 (Cortex-A15): OPP: 2000, Measured: 1996 

### Performance baseline

  * cpu0 (Cortex-A7): memcpy: 330.5 MB/s, memchr: 424.2 MB/s, memset: 799.6 MB/s
  * cpu4 (Cortex-A15): memcpy: 2286.5 MB/s, memchr: 3050.9 MB/s, memset: 4837.3 MB/s
  * cpu0 (Cortex-A7) 16M latency: 159.5 163.8 159.5 165.5 159.5 165.3 297.0 570.8 
  * cpu4 (Cortex-A15) 16M latency: 174.8 175.4 174.8 175.4 174.8 175.6 175.3 202.8 
  * 7-zip MIPS (3 consecutive runs): 8465, 8304, 8221 (8330 avg), single-threaded: 1724
  * `aes-256-cbc      20446.77k    25319.72k    26717.87k    27091.29k    27202.90k    27148.29k (Cortex-A7)`
  * `aes-256-cbc      58473.23k    66768.11k    70337.28k    71281.66k    71516.16k    71538.01k (Cortex-A15)`

### Storage devices:

  * 3.7TB "HGST HDN724040ALE640" HDD as /dev/sda [SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)]: behind JMicron JMS578 SATA 6Gb/s bridge, Driver=uas, 5000Mbps (capable of 12Mbps, 480Mbps, 5Gbps), drive temp: 27°C
  * 14.9GB "SanDisk SC16G" UHS SDR104 SD card as /dev/mmcblk1: date 06/2019, manfid/oemid: 0x000003/0x5344, hw/fw rev: 0x8/0x0

### Swap configuration:

  * /dev/zram0: 995.2M (0K used, lzo-rle, 8 streams, 4K data, 74B compressed, 4K total)

### Software versions:

  * Ubuntu 20.04.3 LTS (focal) arm
  * Build scripts: https://github.com/armbian/build, 21.08.3, Odroid XU4, odroidxu4, odroidxu4
  * Compiler: /usr/bin/gcc (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0 / arm-linux-gnueabihf
  * OpenSSL 1.1.1f, built on 31 Mar 2020          

### Kernel info:

  * `/proc/cmdline: console=ttySAC2,115200n8 console=tty1 consoleblank=0 loglevel=1 root=UUID=57f06418-7fe0-4d7a-89b9-31dcc07b8b27 rootfstype=ext4 rootwait rw  smsc95xx.macaddr=00:1e:06:61:7a:55 governor=performance hdmi_tx_amp_lvl=31 hdmi_tx_lvl_ch0=3 hdmi_tx_lvl_ch1=3 hdmi_tx_lvl_ch2=3 hdmi_tx_emp_lvl=6 hdmi_clk_amp_lvl=31 hdmi_tx_res=0 HPD=true vout=hdmi usb-storage.quirks= `
  * Kernel 5.4.151-odroidxu4 / CONFIG_HZ=100

Kernel 5.4.151 is not latest 5.4.233 LTS that was released on 2023-02-25.

See https://endoflife.date/linux for details. It is somewhat likely that
a lot of exploitable vulnerabilities exist for this kernel as well as many
unfixed bugs.

But this version string doesn't matter since this is not an official LTS Linux
from kernel.org. This device runs a Samsung vendor/BSP kernel.
