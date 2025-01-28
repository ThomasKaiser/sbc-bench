# Radxa Orion O6

Tested with sbc-bench v0.9.69 on Wed, 29 Jan 2025 00:40:38 +0800. Full info: [https://0x0.st/888t.bin](../888t.txt)

### General information:

The CPU features 5 clusters consisting of 2 different core types:

    Cix P1/CD8180, Kernel: aarch64, Userland: arm64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      800    2500   Cortex-A720 / r0p1
      1        0        1      800    1800   Cortex-A520 / r0p1
      2        0        1      800    1800   Cortex-A520 / r0p1
      3        0        1      800    1800   Cortex-A520 / r0p1
      4        0        1      800    1800   Cortex-A520 / r0p1
      5        0        5      800    2300   Cortex-A720 / r0p1
      6        0        5      800    2300   Cortex-A720 / r0p1
      7        0        7      800    2200   Cortex-A720 / r0p1
      8        0        7      800    2200   Cortex-A720 / r0p1
      9        0        9      800    2400   Cortex-A720 / r0p1
     10        0        9      800    2400   Cortex-A720 / r0p1
     11        0        9      800    2400   Cortex-A720 / r0p1

15222 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: schedutil / 1800 MHz (userspace performance schedutil / 800 1200 1500 1800 2100 2300 2500)
    cpufreq-policy1: schedutil / 1800 MHz (userspace performance schedutil / 800 1800)
    cpufreq-policy5: schedutil / 800 MHz (userspace performance schedutil / 800 1200 1500 1800 2000 2100 2300)
    cpufreq-policy7: schedutil / 1500 MHz (userspace performance schedutil / 800 1200 1500 1800 1900 2000 2200)
    cpufreq-policy9: schedutil / 1800 MHz (userspace performance schedutil / 800 1200 1500 1800 2000 2200 2400)
    14230000.vpu: simple_ondemand / 150 MHz (userspace performance simple_ondemand / 150 300 480 600 800 1200)
    14260000.aipu: userspace / 1200 MHz (userspace performance simple_ondemand / 400 600 800 1200)
    15000000.gpu: simple_ondemand / 72 MHz (userspace performance simple_ondemand / 72 216 350 600 800 900)

Tuned governor settings:

    cpufreq-policy0: performance / 2500 MHz
    cpufreq-policy1: performance / 1800 MHz
    cpufreq-policy5: performance / 2300 MHz
    cpufreq-policy7: performance / 2200 MHz
    cpufreq-policy9: performance / 2400 MHz
    14230000.vpu: performance / 1200 MHz
    14260000.aipu: performance / 1200 MHz
    15000000.gpu: performance / 900 MHz

Status of performance related policies found below /sys:

    /sys/devices/platform/soc@0/14260000.aipu/gm_policy: [1] AIPU GM is shared by tasks of all QoS level.
    /sys/devices/platform/soc@0/15000000.gpu/power_policy: [coarse_demand] always_on
    /sys/module/pcie_aspm/parameters/policy: default [performance] powersave powersupersave

### Clockspeeds (idle vs. heated up):

Before at 24.0°C:

    cpu0 (Cortex-A720): OPP: 2500, Measured: 2498 
    cpu1-cpu4 (Cortex-A520): OPP: 1799, Measured: 1795 
    cpu5-cpu6 (Cortex-A720): OPP: 2299, Measured: 2298 
    cpu7-cpu8 (Cortex-A720): OPP: 2199, Measured: 2198 
    cpu9-cpu11 (Cortex-A720): OPP: 2399, Measured: 2398 

After at 45.0°C:

    cpu0 (Cortex-A720): OPP: 2500, Measured: 2498 
    cpu1-cpu4 (Cortex-A520): OPP: 1799, Measured: 1795 
    cpu5-cpu6 (Cortex-A720): OPP: 2299, Measured: 2298 
    cpu7-cpu8 (Cortex-A720): OPP: 2199, Measured: 2198 
    cpu9-cpu11 (Cortex-A720): OPP: 2399, Measured: 2398 

### Performance baseline

  * cpu0 (Cortex-A720): memcpy: 13751.8 MB/s, memchr: 25564.3 MB/s, memset: 42551.8 MB/s
  * cpu1 (Cortex-A520): memcpy: 8854.3 MB/s, memchr: 1792.1 MB/s, memset: 28377.4 MB/s
  * cpu5 (Cortex-A720): memcpy: 16209.2 MB/s, memchr: 23918.7 MB/s, memset: 42042.4 MB/s
  * cpu7 (Cortex-A720): memcpy: 16930.6 MB/s, memchr: 22942.8 MB/s, memset: 46148.3 MB/s
  * cpu9 (Cortex-A720): memcpy: 15731.2 MB/s, memchr: 24929.8 MB/s, memset: 46238.0 MB/s
  * cpu0 (Cortex-A720) 16M latency: 37.58 26.64 40.03 28.38 37.06 29.81 33.36 50.64 
  * cpu1 (Cortex-A520) 16M latency: 67.89 59.04 110.2 77.19 56.47 66.37 94.97 95.27 
  * cpu5 (Cortex-A720) 16M latency: 35.98 27.61 39.66 26.87 34.04 28.38 32.21 46.69 
  * cpu7 (Cortex-A720) 16M latency: 34.82 25.63 44.24 25.53 33.78 28.77 34.09 46.78 
  * cpu9 (Cortex-A720) 16M latency: 41.10 25.08 35.21 26.39 33.39 29.04 30.06 46.73 
  * cpu0 (Cortex-A720) 128M latency: 50.53 69.11 50.60 73.06 50.18 66.26 97.18 140.6 
  * cpu1 (Cortex-A520) 128M latency: 220.1 222.1 220.8 221.9 219.9 222.9 235.2 325.7 
  * cpu5 (Cortex-A720) 128M latency: 50.30 73.45 51.43 70.65 50.67 66.43 94.82 138.5 
  * cpu7 (Cortex-A720) 128M latency: 48.71 71.84 49.17 72.43 49.42 66.19 97.64 137.2 
  * cpu9 (Cortex-A720) 128M latency: 48.09 70.17 48.18 71.44 48.01 63.58 92.58 137.2 
  * 7-zip MIPS (3 consecutive runs): 31807, 31461, 31889 (31720 avg), single-threaded: 3757
  * `aes-256-cbc     832655.35k  1258333.12k  1375561.56k  1395807.91k  1401823.23k  1402273.79k (Cortex-A720)`
  * `aes-256-cbc     171904.42k   344348.65k   462950.31k   505559.72k   519746.90k   520421.38k (Cortex-A520)`
  * `aes-256-cbc     766124.92k  1157587.75k  1265379.67k  1284026.03k  1289557.33k  1289994.24k (Cortex-A720)`
  * `aes-256-cbc     732656.24k  1106904.04k  1210114.73k  1227927.21k  1233193.64k  1233469.44k (Cortex-A720)`
  * `aes-256-cbc     799441.87k  1207768.00k  1320429.65k  1339925.16k  1345661.61k  1346164.05k (Cortex-A720)`

### PCIe and storage devices:

  * Realtek Device 8126: Speed 8GT/s, Width x1, driver in use: r8126, ASPM Disabled
  * Realtek Device 8126: Speed 8GT/s, Width x1, driver in use: r8126, ASPM Disabled
  * 1.8TB "Samsung SSD 990 PRO with Heatsink 2TB" SSD as /dev/nvme0: Speed 16GT/s, Width x4, 0% worn out, drive temp: 33°C, ASPM Disabled
  * 119.2GB "SAMSUNG MZ7TE128HMGR-00004" SSD as /dev/sda [SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)]: behind VIA Labs VL715/VL716 SATA 6Gb/s bridge (2109:0715), 4% worn out, Driver=uas, 10Gbps (capable of 12Mbps, 480Mbps, 5Gbps, 10Gb/s Symmetric RX SuperSpeedPlus, 10Gb/s Symmetric TX SuperSpeedPlus), drive temp: 24°C

### Software versions:

  * Debian GNU/Linux 12 (bookworm)
  * Compiler: /usr/bin/gcc (Debian 12.2.0-14) 12.2.0 / aarch64-linux-gnu
  * OpenSSL 3.0.15, built on 3 Sep 2024 (Library: OpenSSL 3.0.15 3 Sep 2024)    

### Kernel info:

  * `/proc/cmdline: BOOT_IMAGE=/Image loglevel=0 console=ttyAMA2,115200 efi=noruntime earlycon=pl011,0x040d0000 arm-smmu-v3.disable_bypass=0 acpi=off root=/dev/sda2 rootwait rw`
  * Vulnerability Spec store bypass:    Mitigation; Speculative Store Bypass disabled via prctl
  * Vulnerability Spectre v1:           Mitigation; __user pointer sanitization
  * Kernel 6.1.44-cix-build-generic / CONFIG_HZ=250

Kernel 6.1.44 is not latest 6.1.127 LTS that was released on 2025-01-23.

See https://endoflife.date/linux for details. It is somewhat likely that
a lot of exploitable vulnerabilities exist for this kernel as well as many
unfixed bugs.

### Idle consumption (measured with Netio 4KF, FW v4.0.5):

  * everything set to performance: 17610 mW
  * /sys/devices/platform/soc@0/14230000.vpu/devfreq/14230000.vpu set to powersave: 17400 mW
  * /sys/devices/platform/soc@0/14260000.aipu/devfreq/14260000.aipu set to powersave: 17100 mW
  * /sys/devices/platform/soc@0/15000000.gpu/devfreq/15000000.gpu set to powersave: 17170 mW
  * /sys/devices/system/cpu/cpufreq/policy0 set to powersave: 16970 mW
  * /sys/devices/system/cpu/cpufreq/policy1 set to powersave: 16780 mW
  * /sys/devices/system/cpu/cpufreq/policy5 set to powersave: 17240 mW
  * /sys/devices/system/cpu/cpufreq/policy7 set to powersave: 17290 mW
  * /sys/devices/system/cpu/cpufreq/policy9 set to powersave: 16970 mW
  * /sys/module/pcie_aspm/parameters/policy set to powersave: 15840 mW