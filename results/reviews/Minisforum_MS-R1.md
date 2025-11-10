# Micro Computer (HK) Tech Limited MS-R1 1.0

Tested with sbc-bench v0.9.72 on Tue, 11 Nov 2025 00:06:19 +0800. Full info: [http://0x0.st/1ET4](../1ET4.txt)

### General information:

The CPU features 4 clusters consisting of 2 different core types:

    Kernel: aarch64, Userland: arm64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      800    2600   Cortex-A720 / r0p1
      1        0        0      800    2600   Cortex-A720 / r0p1
      2        0        2      800    1800   Cortex-A520 / r0p1
      3        0        2      800    1800   Cortex-A520 / r0p1
      4        0        2      800    1800   Cortex-A520 / r0p1
      5        0        2      800    1800   Cortex-A520 / r0p1
      6        0        6      800    2300   Cortex-A720 / r0p1
      7        0        6      800    2300   Cortex-A720 / r0p1
      8        0        8      800    2200   Cortex-A720 / r0p1
      9        0        8      800    2200   Cortex-A720 / r0p1
     10        0       10      800    2500   Cortex-A720 / r0p1
     11        0       10      800    2500   Cortex-A720 / r0p1

63833 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    CIXH3010:00: simple_ondemand / 150 MHz (dsu_pc_governor userspace performance simple_ondemand / 150 300 480 600 800 1200)
    CIXH4000:00: userspace / 1200 MHz (dsu_pc_governor userspace performance simple_ondemand / 400 600 800 1200)
    CIXH5000:00: simple_ondemand / 72 MHz (dsu_pc_governor userspace performance simple_ondemand / 72 216 350 600 800 1000)
    cpufreq-policy0: schedutil / 2600 MHz (userspace performance schedutil)
    cpufreq-policy10: schedutil / 1227 MHz (userspace performance schedutil)
    cpufreq-policy2: schedutil / 1141 MHz (userspace performance schedutil)
    cpufreq-policy6: schedutil / 1385 MHz (userspace performance schedutil)
    cpufreq-policy8: schedutil / 1308 MHz (userspace performance schedutil)

Tuned governor settings:

    CIXH3010:00: performance / 1200 MHz
    CIXH4000:00: performance / 1200 MHz
    CIXH5000:00: performance / 1000 MHz
    cpufreq-policy0: performance / 2600 MHz
    cpufreq-policy10: performance / 2500 MHz
    cpufreq-policy2: performance / 1800 MHz
    cpufreq-policy6: performance / 2300 MHz
    cpufreq-policy8: performance / 2200 MHz

Status of performance related policies found below /sys:

    /sys/devices/platform/CIXH4000:00/gm_policy: [1] AIPU GM is shared by tasks of all QoS level.
    /sys/devices/platform/CIXH5000:00/power_policy: [coarse_demand] always_on
    /sys/module/pcie_aspm/parameters/policy: [default] performance powersave powersupersave

### Clockspeeds (idle vs. heated up):

Before at 32.0°C:

    cpu0-cpu1 (Cortex-A720): OPP: 2600, Measured: 2598 
    cpu2-cpu5 (Cortex-A520): OPP: 1800, Measured: 1795 
    cpu6-cpu7 (Cortex-A720): OPP: 2300, Measured: 2297 
    cpu8-cpu11 (Cortex-A720): OPP: 2200, Measured: 2198 

After at 48.0°C:

    cpu0-cpu1 (Cortex-A720): OPP: 2600, Measured: 2598 
    cpu2-cpu5 (Cortex-A520): OPP: 1800, Measured: 1795 
    cpu6-cpu7 (Cortex-A720): OPP: 2300, Measured: 2297 
    cpu8-cpu11 (Cortex-A720): OPP: 2200, Measured: 2198 

### Performance baseline

  * cpu0 (Cortex-A720): memcpy: 17507.8 MB/s, memchr: 26934.2 MB/s, memset: 48833.6 MB/s
  * cpu2 (Cortex-A520): memcpy: 8866.8 MB/s, memchr: 1791.9 MB/s, memset: 28370.5 MB/s
  * cpu6 (Cortex-A720): memcpy: 17156.5 MB/s, memchr: 23916.9 MB/s, memset: 44865.7 MB/s
  * cpu8 (Cortex-A720): memcpy: 17951.9 MB/s, memchr: 22907.7 MB/s, memset: 45544.5 MB/s
  * cpu0 (Cortex-A720) 16M latency: 38.16 26.40 36.21 26.58 37.13 29.49 32.85 44.77 
  * cpu2 (Cortex-A520) 16M latency: 60.74 54.74 54.11 55.91 53.69 55.74 65.64 93.32 
  * cpu6 (Cortex-A720) 16M latency: 37.13 25.81 33.25 25.63 33.13 28.43 31.95 42.93 
  * cpu8 (Cortex-A720) 16M latency: 34.58 25.59 33.12 25.40 34.22 28.16 31.09 44.06 
  * cpu0 (Cortex-A720) 128M latency: 52.42 72.42 51.15 72.60 49.50 66.37 95.08 138.5 
  * cpu2 (Cortex-A520) 128M latency: 216.0 220.1 218.3 219.8 218.0 221.0 235.3 325.5 
  * cpu6 (Cortex-A720) 128M latency: 49.50 70.77 49.20 70.61 49.35 65.03 93.42 138.4 
  * cpu8 (Cortex-A720) 128M latency: 51.04 70.33 50.00 65.60 50.51 67.61 95.53 136.1 
  * 7-zip MIPS (3 consecutive runs): 32932, 32911, 33087 (32980 avg), single-threaded: 3899
  * `aes-256-cbc     848212.30k  1326481.54k  1434583.47k  1453447.85k  1457924.78k  1458356.22k (Cortex-A720)`
  * `aes-256-cbc     169779.88k   344076.48k   462005.08k   505280.17k   519558.49k   520421.38k (Cortex-A520)`
  * `aes-256-cbc     750177.83k  1172743.89k  1268454.14k  1285163.01k  1289063.08k  1289546.41k (Cortex-A720)`
  * `aes-256-cbc     717912.01k  1123501.50k  1213899.09k  1229800.79k  1233534.98k  1233971.88k (Cortex-A720)`

### PCIe and storage devices:

  * Realtek RTL8127 10GbE: Speed 16GT/s, Width x1, driver in use: r8127, 
  * Realtek RTL8127 10GbE: Speed 16GT/s, Width x1, driver in use: r8127, 
  * MEDIATEK MT7922 802.11ax PCI Express Wireless Network Adapter: Speed 5GT/s, Width x1, driver in use: mt7921e, 
  * 953.9GB "KINGSTON OM8TAP41024K1-A00" SSD as /dev/nvme0: Speed 16GT/s, Width x4, 0% worn out, drive temp: 38°C, ASPM Disabled

### Software versions:

  * Debian GNU/Linux 12 (bookworm)
  * Compiler: /usr/bin/gcc (Debian 12.2.0-14+deb12u1) 12.2.0 / aarch64-linux-gnu
  * OpenSSL 3.0.17, built on 1 Jul 2025 (Library: OpenSSL 3.0.17 1 Jul 2025)    

### Kernel info:

  * `/proc/cmdline: BOOT_IMAGE=/Image console=tty0 console=ttyAMA0,115200 earlycon=pl011,0x040d0000 loglevel=4 arm-smmu-v3.disable_bypass=0 cma=640M acpi=force splash pcie_aspm=off root=PARTUUID=1733039a-9fa3-41c3-944d-85420869d4a8 rootwait rw`
  * Vulnerability Spec store bypass:    Mitigation; Speculative Store Bypass disabled via prctl
  * Vulnerability Spectre v1:           Mitigation; __user pointer sanitization
  * Kernel 6.6.10-cix-build-generic / CONFIG_HZ=250