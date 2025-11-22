# Dell  Inc. Dell Pro Max with GB10 FCM1253

Tested with sbc-bench v0.9.72 on Sat, 22 Nov 2025 00:52:12 -0600. Full info: [fcm1253](../fcm1253.txt)

### General information:

The CPU features 10 clusters consisting of 2 different core types:

    jep106:0426 jep106:0426:8901 rev 0x00000000, Kernel: aarch64, Userland: arm64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0       36        0      338    2808   Cortex-A725 / r0p1
      1       36        1      338    2808   Cortex-A725 / r0p1
      2       36        2      338    2808   Cortex-A725 / r0p1
      3       36        3      338    2808   Cortex-A725 / r0p1
      4       36        4      338    2808   Cortex-A725 / r0p1
      5       36        5     1378    3900   Cortex-X925 / r0p1
      6       36        6     1378    3900   Cortex-X925 / r0p1
      7       36        7     1378    3900   Cortex-X925 / r0p1
      8       36        8     1378    3900   Cortex-X925 / r0p1
      9       36        9     1378    3900   Cortex-X925 / r0p1
     10       36       10      338    2860   Cortex-A725 / r0p1
     11       36       11      338    2860   Cortex-A725 / r0p1
     12       36       12      338    2860   Cortex-A725 / r0p1
     13       36       13      338    2860   Cortex-A725 / r0p1
     14       36       14      338    2860   Cortex-A725 / r0p1
     15       36       15     1378    3978   Cortex-X925 / r0p1
     16       36       16     1378    3978   Cortex-X925 / r0p1
     17       36       17     1378    3978   Cortex-X925 / r0p1
     18       36       18     1378    3978   Cortex-X925 / r0p1
     19       36       19     1378    4004   Cortex-X925 / r0p1

122506 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: performance / 2210 MHz (performance powersave)
    cpufreq-policy10: performance / 3484 MHz (performance powersave)
    cpufreq-policy11: performance / 3666 MHz (performance powersave)
    cpufreq-policy12: performance / 3276 MHz (performance powersave)
    cpufreq-policy13: performance / 3172 MHz (performance powersave)
    cpufreq-policy14: performance / 2184 MHz (performance powersave)
    cpufreq-policy15: performance / 2964 MHz (performance powersave)
    cpufreq-policy16: performance / 3094 MHz (performance powersave)
    cpufreq-policy17: performance / 6916 MHz (performance powersave)
    cpufreq-policy18: performance / 2418 MHz (performance powersave)
    cpufreq-policy19: performance / 3406 MHz (performance powersave)
    cpufreq-policy1: performance / 2236 MHz (performance powersave)
    cpufreq-policy2: performance / 2288 MHz (performance powersave)
    cpufreq-policy3: performance / 3250 MHz (performance powersave)
    cpufreq-policy4: performance / 2912 MHz (performance powersave)
    cpufreq-policy5: performance / 7228 MHz (performance powersave)
    cpufreq-policy6: performance / 3198 MHz (performance powersave)
    cpufreq-policy7: performance / 3094 MHz (performance powersave)
    cpufreq-policy8: performance / 3536 MHz (performance powersave)
    cpufreq-policy9: performance / 3432 MHz (performance powersave)

Tuned governor settings:

    cpufreq-policy0: performance / 4030 MHz
    cpufreq-policy10: performance / 2262 MHz
    cpufreq-policy11: performance / 2158 MHz
    cpufreq-policy12: performance / 2210 MHz
    cpufreq-policy13: performance / 2210 MHz
    cpufreq-policy14: performance / 2184 MHz
    cpufreq-policy15: performance / 3016 MHz
    cpufreq-policy16: performance / 5278 MHz
    cpufreq-policy17: performance / 5018 MHz
    cpufreq-policy18: performance / 3484 MHz
    cpufreq-policy19: performance / 5772 MHz
    cpufreq-policy1: performance / 2522 MHz
    cpufreq-policy2: performance / 2938 MHz
    cpufreq-policy3: performance / 2184 MHz
    cpufreq-policy4: performance / 3406 MHz
    cpufreq-policy5: performance / 3146 MHz
    cpufreq-policy6: performance / 3120 MHz
    cpufreq-policy7: performance / 3146 MHz
    cpufreq-policy8: performance / 5434 MHz
    cpufreq-policy9: performance / 3432 MHz

Status of performance related policies found below /sys:

    /sys/module/pcie_aspm/parameters/policy: default [performance] powersave powersupersave

### Clockspeeds (idle vs. heated up):

Before at 37.5°C:

    cpu0 (Cortex-A725): OPP: 2808, Measured: 2801 
    cpu1 (Cortex-A725): OPP: 2808, Measured: 2803 
    cpu2 (Cortex-A725): OPP: 2808, Measured: 2802 
    cpu3 (Cortex-A725): OPP: 2808, Measured: 2801 
    cpu4 (Cortex-A725): OPP: 2808, Measured: 2800 
    cpu5 (Cortex-X925): OPP: 3900, Measured: 3889 
    cpu6 (Cortex-X925): OPP: 3900, Measured: 3890 
    cpu7 (Cortex-X925): OPP: 3900, Measured: 3891 
    cpu8 (Cortex-X925): OPP: 3900, Measured: 3888 
    cpu9-cpu19 (Cortex-X925): OPP: 3900, Measured: 3889 

After at 86.9°C:

    cpu0 (Cortex-A725): OPP: 2808, Measured: 2802 
    cpu1 (Cortex-A725): OPP: 2808, Measured: 2802 
    cpu2 (Cortex-A725): OPP: 2808, Measured: 2802 
    cpu3 (Cortex-A725): OPP: 2808, Measured: 2802 
    cpu4 (Cortex-A725): OPP: 2808, Measured: 2801 
    cpu5 (Cortex-X925): OPP: 3900, Measured: 3894 
    cpu6 (Cortex-X925): OPP: 3900, Measured: 3894 
    cpu7 (Cortex-X925): OPP: 3900, Measured: 3889 
    cpu8 (Cortex-X925): OPP: 3900, Measured: 3893 
    cpu9-cpu19 (Cortex-X925): OPP: 3900, Measured: 3892 

### Performance baseline

  * cpu0 (Cortex-A725): memcpy: 25666.1 MB/s, memchr: 29340.2 MB/s, memset: 58935.3 MB/s
  * cpu1 (Cortex-A725): memcpy: 25579.8 MB/s, memchr: 29331.4 MB/s, memset: 59075.9 MB/s
  * cpu2 (Cortex-A725): memcpy: 25594.1 MB/s, memchr: 28950.0 MB/s, memset: 58728.4 MB/s
  * cpu3 (Cortex-A725): memcpy: 25412.2 MB/s, memchr: 29232.2 MB/s, memset: 59065.9 MB/s
  * cpu4 (Cortex-A725): memcpy: 24239.0 MB/s, memchr: 29286.5 MB/s, memset: 59852.9 MB/s
  * cpu5 (Cortex-X925): memcpy: 26746.4 MB/s, memchr: 37258.2 MB/s, memset: 54667.7 MB/s
  * cpu6 (Cortex-X925): memcpy: 26958.7 MB/s, memchr: 37731.1 MB/s, memset: 56295.8 MB/s
  * cpu7 (Cortex-X925): memcpy: 26083.5 MB/s, memchr: 36670.7 MB/s, memset: 57225.4 MB/s
  * cpu8 (Cortex-X925): memcpy: 26472.0 MB/s, memchr: 37572.4 MB/s, memset: 58022.6 MB/s
  * cpu9 (Cortex-X925): memcpy: 27104.8 MB/s, memchr: 39149.6 MB/s, memset: 63396.0 MB/s
  * cpu0 (Cortex-A725) 16M latency: 17.24 14.93 16.57 14.85 16.96 16.43 25.82 45.27 
  * cpu1 (Cortex-A725) 16M latency: 16.35 16.14 16.72 15.99 16.72 18.48 27.54 47.31 
  * cpu2 (Cortex-A725) 16M latency: 16.50 14.99 16.67 14.72 16.27 16.72 26.53 45.39 
  * cpu3 (Cortex-A725) 16M latency: 16.15 15.28 16.57 14.41 16.00 17.36 26.64 46.16 
  * cpu4 (Cortex-A725) 16M latency: 16.41 14.48 16.67 15.33 16.18 17.58 27.83 49.02 
  * cpu5 (Cortex-X925) 16M latency: 8.486 7.690 8.746 7.835 8.738 12.87 14.55 18.36 
  * cpu6 (Cortex-X925) 16M latency: 8.785 7.680 8.955 7.855 8.967 12.86 15.19 18.40 
  * cpu7 (Cortex-X925) 16M latency: 8.741 7.866 9.027 7.998 8.935 13.30 15.19 19.36 
  * cpu8 (Cortex-X925) 16M latency: 8.895 7.746 9.084 7.940 9.093 13.45 15.11 18.61 
  * cpu9 (Cortex-X925) 16M latency: 8.723 7.604 8.947 7.757 8.846 13.09 15.09 18.14 
  * cpu0 (Cortex-A725) 128M latency: 29.77 42.09 29.43 41.47 30.38 36.02 51.83 79.15 
  * cpu1 (Cortex-A725) 128M latency: 29.05 40.66 29.13 40.61 29.46 35.68 50.22 77.62 
  * cpu2 (Cortex-A725) 128M latency: 28.83 41.18 29.48 41.13 29.39 34.81 49.12 77.59 
  * cpu3 (Cortex-A725) 128M latency: 28.87 40.56 29.47 40.72 29.48 35.08 51.05 78.37 
  * cpu4 (Cortex-A725) 128M latency: 29.74 41.87 29.98 42.12 29.30 36.04 54.55 80.71 
  * cpu5 (Cortex-X925) 128M latency: 19.36 32.72 20.53 32.30 20.06 23.49 26.23 37.04 
  * cpu6 (Cortex-X925) 128M latency: 20.92 32.19 21.81 33.12 21.67 23.57 26.70 37.50 
  * cpu7 (Cortex-X925) 128M latency: 20.89 34.64 21.58 33.81 21.31 24.50 27.81 40.23 
  * cpu8 (Cortex-X925) 128M latency: 21.59 34.19 21.89 33.74 21.49 24.05 27.43 38.55 
  * cpu9 (Cortex-X925) 128M latency: 19.96 31.60 20.21 32.10 20.23 23.22 25.78 37.42 
  * 7-zip MIPS (3 consecutive runs): 114958, 115142, 114661 (114920 avg), single-threaded: 6704
  * `aes-256-cbc     878540.57k  1458809.34k  1551885.74k  1569451.69k  1572044.80k  1572017.49k (Cortex-A725)`
  * `aes-256-cbc     878604.57k  1461518.02k  1552595.37k  1570016.60k  1571990.19k  1572301.48k (Cortex-A725)`
  * `aes-256-cbc     878555.92k  1458791.38k  1552581.46k  1569194.67k  1571394.90k  1571618.82k (Cortex-A725)`
  * `aes-256-cbc     878581.15k  1459021.74k  1551829.16k  1569518.59k  1571864.58k  1572192.26k (Cortex-A725)`
  * `aes-256-cbc     878499.00k  1458915.05k  1551894.87k  1569602.56k  1572077.57k  1572263.25k (Cortex-A725)`
  * `aes-256-cbc    1556000.57k  1993272.34k  2158398.12k  2207505.75k  2221056.00k  2221959.85k (Cortex-X925)`
  * `aes-256-cbc    1556149.87k  1990981.74k  2157605.97k  2206159.53k  2220209.49k  2221157.03k (Cortex-X925)`
  * `aes-256-cbc    1556427.44k  1991735.74k  2159387.82k  2207656.62k  2220834.82k  2221998.08k (Cortex-X925)`
  * `aes-256-cbc    1556078.26k  1990137.00k  2159421.70k  2207116.63k  2220894.89k  2221877.93k (Cortex-X925)`
  * `aes-256-cbc    1556324.90k  1990794.56k  2157336.06k  2207155.88k  2220597.25k  2221402.79k (Cortex-X925)`

### PCIe and storage devices:

  * Mellanox MT2910 Family [ConnectX-7]: Speed 32GT/s, Width x4, driver in use: mlx5_core, 
  * Mellanox MT2910 Family [ConnectX-7]: Speed 32GT/s, Width x4, driver in use: mlx5_core, 
  * Mellanox MT2910 Family [ConnectX-7]: Speed 32GT/s, Width x4, driver in use: mlx5_core, 
  * Mellanox MT2910 Family [ConnectX-7]: Speed 32GT/s, Width x4, driver in use: mlx5_core, 
  * Realtek RTL8127 10GbE: Speed 16GT/s, Width x1, driver in use: r8127, ASPM Disabled
  * MEDIATEK MT7925 802.11be 160MHz 2x2 PCIe Wireless Network Adapter [Filogic 360]: Speed 5GT/s, Width x1, driver in use: mt7925e, ASPM Disabled
  * NVIDIA GB20B [GB10]: Speed 2.5GT/s, Width x1 (downgraded), driver in use: nvidia, ASPM Disabled
  * 3.6TB "ESL04TBTLCZ-27J4-TYN" SSD as /dev/nvme0: Speed 16GT/s, Width x4, 0% worn out, drive temp: 49°C, ASPM Disabled

### Swap configuration:

  * /swap.img on /dev/nvme0n1p2: 16.0G (512K used)

### Software versions:

  * Ubuntu 24.04.3 LTS (noble)
  * Compiler: /usr/bin/gcc (Ubuntu 13.3.0-6ubuntu2~24.04) 13.3.0 / aarch64-linux-gnu
  * OpenSSL 3.0.13, built on 30 Jan 2024 (Library: OpenSSL 3.0.13 30 Jan 2024)    

### Kernel info:

  * `/proc/cmdline: BOOT_IMAGE=/boot/vmlinuz-6.14.0-1013-nvidia root=UUID=2be3a853-c2c9-4436-b999-9a8322efb0f8 ro init_on_alloc=0 console=tty0 plymouth.ignore-serial-consoles plymouth.use-simpledrm earlycon=uart,mmio32,0x16A00000 console=tty0 console=ttyS0,921600 crashkernel=1G-:0M quiet splash pci=pcie_bus_safe vt.handoff=7`
  * Vulnerability Spec store bypass:         Mitigation; Speculative Store Bypass disabled via prctl
  * Vulnerability Spectre v1:                Mitigation; __user pointer sanitization
  * Vulnerability Spectre v2:                Mitigation; CSV2, BHB
  * Kernel 6.14.0-1013-nvidia / CONFIG_HZ=1000
