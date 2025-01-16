# Radxa Computer (Shenzhen) Co., Ltd. Radxa Orion O6 1.0

Tested with sbc-bench v0.9.69 on Thu, 16 Jan 2025 10:56:02 +0900. Full info: [https://0x0.st/8opg.bin](../8op.txt).

### General information:

The CPU features 5 clusters consisting of 3 different core types:

    Kernel: aarch64, Userland: arm64
    
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

15765 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: schedutil / 362 MHz (performance schedutil)
    cpufreq-policy1: schedutil / 1459 MHz (performance schedutil)
    cpufreq-policy5: schedutil / 541 MHz (performance schedutil)
    cpufreq-policy7: schedutil / 554 MHz (performance schedutil)
    cpufreq-policy9: schedutil / 817 MHz (performance schedutil)

Tuned governor settings:

    cpufreq-policy0: performance / 1147 MHz
    cpufreq-policy1: performance / 1890 MHz
    cpufreq-policy5: performance / 783 MHz
    cpufreq-policy7: performance / 796 MHz
    cpufreq-policy9: performance / 862 MHz

Status of performance related policies found below /sys:

    /sys/module/pcie_aspm/parameters/policy: default [performance] powersave powersupersave

### Clockspeeds (idle vs. heated up):

Before:

    cpu0 (Cortex-A720): OPP: 2500, Measured: 2499 
    cpu1-cpu4 (Cortex-A520): OPP: 1800, Measured: 1796 
    cpu5-cpu6 (Cortex-A720): OPP: 2300, Measured: 2299 
    cpu7-cpu8 (Cortex-A720): OPP: 2200, Measured: 2199 
    cpu9-cpu11 (Cortex-A720): OPP: 2400, Measured: 2399 

After:

    cpu0 (Cortex-A720): OPP: 2500, Measured: 2499 
    cpu1-cpu4 (Cortex-A520): OPP: 1800, Measured: 1796 
    cpu5-cpu6 (Cortex-A720): OPP: 2300, Measured: 2299 
    cpu7-cpu8 (Cortex-A720): OPP: 2200, Measured: 2199 
    cpu9-cpu11 (Cortex-A720): OPP: 2400, Measured: 2399 

### Performance baseline

  * cpu0 (Cortex-A720): memcpy: 16041.0 MB/s, memchr: 25690.2 MB/s, memset: 46218.5 MB/s
  * cpu1 (Cortex-A520): memcpy: 8855.3 MB/s, memchr: 1793.6 MB/s, memset: 20580.3 MB/s
  * cpu5 (Cortex-A720): memcpy: 17020.6 MB/s, memchr: 23956.7 MB/s, memset: 39676.3 MB/s
  * cpu7 (Cortex-A720): memcpy: 17253.4 MB/s, memchr: 22948.8 MB/s, memset: 46439.3 MB/s
  * cpu9 (Cortex-A720): memcpy: 17168.4 MB/s, memchr: 24970.9 MB/s, memset: 47925.8 MB/s
  * cpu0 (Cortex-A720) 16M latency: 44.98 26.75 36.21 26.73 37.96 29.99 33.05 45.56 
  * cpu1 (Cortex-A520) 16M latency: 60.54 57.52 55.41 56.91 54.86 56.76 67.30 94.89 
  * cpu5 (Cortex-A720) 16M latency: 35.13 25.96 34.42 25.88 35.14 28.52 31.59 43.56 
  * cpu7 (Cortex-A720) 16M latency: 35.53 25.48 35.18 25.20 33.82 28.17 32.23 44.24 
  * cpu9 (Cortex-A720) 16M latency: 35.87 25.20 33.51 24.93 33.54 27.80 31.50 42.58 
  * cpu0 (Cortex-A720) 128M latency: 49.03 68.96 49.30 72.50 48.22 67.63 97.34 140.0 
  * cpu1 (Cortex-A520) 128M latency: 226.9 226.1 229.9 227.1 229.3 224.3 235.2 325.6 
  * cpu5 (Cortex-A720) 128M latency: 50.55 72.92 50.23 69.88 50.19 65.88 97.81 137.1 
  * cpu7 (Cortex-A720) 128M latency: 48.60 70.35 48.85 70.86 49.30 65.35 97.66 136.8 
  * cpu9 (Cortex-A720) 128M latency: 49.56 70.62 50.24 67.22 49.17 65.01 91.60 135.8 

### PCIe and storage devices:

  * Realtek Device 8126: Speed 8GT/s, Width x1, driver in use: , 
  * Realtek Device 8126: Speed 8GT/s, Width x1, driver in use: , 
  * MEDIATEK Device 7925: Speed 5GT/s, Width x1, driver in use: , 
  * Realtek RTL8125 2.5GbE: Speed 5GT/s, Width x1, driver in use: r8169, ASPM Disabled
  * 119.2GB "WTPCIe-SSD-128GB" SSD as /dev/nvme0: Speed 8GT/s, Width x4, 0% worn out, drive temp: 25°C, ASPM Disabled

### Swap configuration:

  * /dev/nvme0n1p3: 977.0M (0K used)

### Software versions:

  * Debian GNU/Linux 12 (bookworm)
  * Compiler: /usr/bin/gcc (Debian 12.2.0-14) 12.2.0 / aarch64-linux-gnu
  * OpenSSL 3.0.15, built on 3 Sep 2024 (Library: OpenSSL 3.0.15 3 Sep 2024)    

### Kernel info:

  * `/proc/cmdline: BOOT_IMAGE=/boot/vmlinuz-6.1.0-30-arm64 root=UUID=e97fa2d7-6c62-4d09-be1d-e104157994fb ro console=ttyAMA2,115200 quiet`
  * Vulnerability Spec store bypass:      Mitigation; Speculative Store Bypass disabled via prctl
  * Vulnerability Spectre v1:             Mitigation; __user pointer sanitization
  * Kernel 6.1.0-30-arm64 / CONFIG_HZ=250