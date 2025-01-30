# Radxa Orion O6

Tested with sbc-bench v0.9.70 on Thu, 30 Jan 2025 18:12:34 +0800. Full info: [https://0x0.st/88LE.bin](../88LE.txt)

### General information:

The CPU features 6 clusters consisting of 2 different core types:

    Cix P1/CD8180, Kernel: aarch64, Userland: arm64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      800    2600   Cortex-A720 / r0p1
      1        0        1      800    1800   Cortex-A520 / r0p1
      2        0        1      800    1800   Cortex-A520 / r0p1
      3        0        1      800    1800   Cortex-A520 / r0p1
      4        0        1      800    1800   Cortex-A520 / r0p1
      5        0        5      800    2300   Cortex-A720 / r0p1
      6        0        5      800    2300   Cortex-A720 / r0p1
      7        0        7      800    2200   Cortex-A720 / r0p1
      8        0        7      800    2200   Cortex-A720 / r0p1
      9        0        9      800    2500   Cortex-A720 / r0p1
     10        0        9      800    2500   Cortex-A720 / r0p1
     11        0        9      800    2500   Cortex-A720 / r0p1

15222 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: performance / 2600 MHz (userspace performance schedutil / 800 1200 1500 1800 2100 2300 2600)
    cpufreq-policy1: performance / 1800 MHz (userspace performance schedutil / 800 1800)
    cpufreq-policy5: performance / 2300 MHz (userspace performance schedutil / 800 1200 1500 1800 2000 2100 2300)
    cpufreq-policy7: performance / 2200 MHz (userspace performance schedutil / 800 1200 1500 1800 1900 2000 2200)
    cpufreq-policy9: performance / 2500 MHz (userspace performance schedutil / 800 1200 1500 1800 2000 2200 2500)
    14230000.vpu: performance / 1200 MHz (userspace performance simple_ondemand / 150 300 480 600 800 1200)
    14260000.aipu: performance / 1200 MHz (userspace performance simple_ondemand / 400 600 800 1200)
    15000000.gpu: performance / 900 MHz (userspace performance simple_ondemand / 72 216 350 600 800 900)

Tuned governor settings:

    cpufreq-policy0: performance / 2600 MHz
    cpufreq-policy1: performance / 1800 MHz
    cpufreq-policy5: performance / 2300 MHz
    cpufreq-policy7: performance / 2200 MHz
    cpufreq-policy9: performance / 2500 MHz
    14230000.vpu: performance / 1200 MHz
    14260000.aipu: performance / 1200 MHz
    15000000.gpu: performance / 900 MHz

Status of performance related policies found below /sys:

    /sys/devices/platform/soc@0/14260000.aipu/gm_policy: [1] AIPU GM is shared by tasks of all QoS level.
    /sys/devices/platform/soc@0/15000000.gpu/power_policy: [coarse_demand] always_on
    /sys/module/pcie_aspm/parameters/policy: default [performance] powersave powersupersave

### Clockspeeds (idle vs. heated up):

Before at 28.0°C:

    cpu0 (Cortex-A720): OPP: 2600, Measured: 2598 
    cpu1-cpu4 (Cortex-A520): OPP: 1799, Measured: 1796 
    cpu5-cpu6 (Cortex-A720): OPP: 2299, Measured: 2299 
    cpu7-cpu8 (Cortex-A720): OPP: 2199, Measured: 2199 
    cpu9-cpu10 (Cortex-A720): OPP: 2499, Measured: 2499 
    cpu11 (Cortex-A720): Measured: 2598

After at 46.0°C:

    cpu0 (Cortex-A720): OPP: 2600, Measured: 2598 
    cpu1-cpu4 (Cortex-A520): OPP: 1799, Measured: 1796 
    cpu5-cpu6 (Cortex-A720): OPP: 2299, Measured: 2298 
    cpu7-cpu8 (Cortex-A720): OPP: 2199, Measured: 2199 
    cpu9-cpu10 (Cortex-A720): OPP: 2499, Measured: 2499 
    cpu11 (Cortex-A720): Measured: 2598

### Performance baseline

  * cpu0 (Cortex-A720): memcpy: 13338.2 MB/s, memchr: 26833.0 MB/s, memset: 31438.5 MB/s
  * cpu1 (Cortex-A520): memcpy: 8870.4 MB/s, memchr: 1792.8 MB/s, memset: 28407.7 MB/s
  * cpu5 (Cortex-A720): memcpy: 15861.2 MB/s, memchr: 23934.9 MB/s, memset: 44449.0 MB/s
  * cpu7 (Cortex-A720): memcpy: 16877.3 MB/s, memchr: 22912.1 MB/s, memset: 47083.7 MB/s
  * cpu9 (Cortex-A720): memcpy: 15264.6 MB/s, memchr: 25926.8 MB/s, memset: 48033.5 MB/s
  * cpu11 (Cortex-A720): memcpy: 13525.7 MB/s, memchr: 26331.8 MB/s, memset: 39928.0 MB/s
  * cpu0 (Cortex-A720) 16M latency: 36.88 26.52 35.63 26.50 35.14 29.51 31.97 44.90 
  * cpu1 (Cortex-A520) 16M latency: 59.50 56.44 54.05 56.21 53.60 55.75 66.05 94.07 
  * cpu5 (Cortex-A720) 16M latency: 36.14 25.94 34.29 25.74 33.61 28.69 32.27 43.48 
  * cpu7 (Cortex-A720) 16M latency: 36.82 25.39 32.57 25.32 33.23 29.23 30.68 43.06 
  * cpu9 (Cortex-A720) 16M latency: 34.91 25.00 33.97 24.80 34.59 27.66 30.54 41.51 
  * cpu11 (Cortex-A720) 16M latency: 33.12 25.20 32.83 25.18 33.04 27.55 30.31 41.83 
  * cpu0 (Cortex-A720) 128M latency: 50.57 73.38 50.24 73.80 50.34 67.51 99.35 139.5 
  * cpu1 (Cortex-A520) 128M latency: 218.7 222.3 220.7 222.7 220.0 222.1 234.8 325.1 
  * cpu5 (Cortex-A720) 128M latency: 49.71 73.37 48.91 73.30 50.02 67.09 99.19 138.0 
  * cpu7 (Cortex-A720) 128M latency: 49.53 73.46 49.75 72.16 48.80 64.93 98.31 136.8 
  * cpu9 (Cortex-A720) 128M latency: 48.61 70.06 49.51 67.60 49.83 62.42 98.66 137.3 
  * cpu11 (Cortex-A720) 128M latency: 49.58 71.82 49.01 70.11 48.89 63.16 94.08 136.9 
  * 7-zip MIPS (3 consecutive runs): 32796, 32540, 32737 (32690 avg), single-threaded: 3945
  * `aes-256-cbc     865957.21k  1308442.84k  1430646.19k  1451713.54k  1457979.39k  1458416.30k (Cortex-A720)`
  * `aes-256-cbc     171534.68k   344544.45k   463446.53k   506069.67k   520238.42k   520989.35k (Cortex-A520)`
  * `aes-256-cbc     766195.43k  1157482.97k  1265519.45k  1284163.24k  1289710.25k  1290114.39k (Cortex-A720)`
  * `aes-256-cbc     732927.11k  1107198.83k  1210558.12k  1228357.63k  1233704.28k  1234097.49k (Cortex-A720)`
  * `aes-256-cbc     832910.49k  1258453.10k  1375737.17k  1395967.32k  1402008.92k  1402475.86k (Cortex-A720)`
  * `aes-256-cbc     866090.98k  1308479.81k  1430496.43k  1451707.73k  1457785.51k  1458410.84k (Cortex-A720)`

### PCIe and storage devices:

  * Realtek Device 8126: Speed 8GT/s, Width x1, driver in use: r8126, ASPM Disabled
  * Realtek Device 8126: Speed 8GT/s, Width x1, driver in use: r8126, ASPM Disabled
  * 1.8TB "Samsung SSD 990 PRO with Heatsink 2TB" SSD as /dev/nvme0: Speed 16GT/s, Width x4, 0% worn out, drive temp: 34°C, ASPM Disabled
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