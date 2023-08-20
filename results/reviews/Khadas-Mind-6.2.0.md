# Khadas Mind 1.0 / i7-1360P

Tested with sbc-bench v0.9.44 on Sun, 20 Aug 2023 20:50:55 +0700. Full info: [http://ix.io/4E5J](http://ix.io/4E5J)

### General information:

The CPU features 2 clusters of different core types:

    i7-1360P, Kernel: x86_64, Userland: amd64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      400    5000   Raptor Cove
      1        0        1      400    5000   Raptor Cove
      2        0        2      400    5000   Raptor Cove
      3        0        3      400    5000   Raptor Cove
      4        0        4      400    5000   Raptor Cove
      5        0        5      400    5000   Raptor Cove
      6        0        6      400    5000   Raptor Cove
      7        0        7      400    5000   Raptor Cove
      8        0        8      400    3700   Gracemont
      9        0        9      400    3700   Gracemont
     10        0       10      400    3700   Gracemont
     11        0       11      400    3700   Gracemont
     12        0       12      400    3700   Gracemont
     13        0       13      400    3700   Gracemont
     14        0       14      400    3700   Gracemont
     15        0       15      400    3700   Gracemont

31820 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: performance / 3301 MHz (performance powersave)
    cpufreq-policy10: performance / 2600 MHz (performance powersave)
    cpufreq-policy11: performance / 2600 MHz (performance powersave)
    cpufreq-policy12: performance / 638 MHz (performance powersave)
    cpufreq-policy13: performance / 2600 MHz (performance powersave)
    cpufreq-policy14: performance / 2600 MHz (performance powersave)
    cpufreq-policy15: performance / 2600 MHz (performance powersave)
    cpufreq-policy1: performance / 2600 MHz (performance powersave)
    cpufreq-policy2: performance / 4343 MHz (performance powersave)
    cpufreq-policy3: performance / 2600 MHz (performance powersave)
    cpufreq-policy4: performance / 3811 MHz (performance powersave)
    cpufreq-policy5: performance / 3423 MHz (performance powersave)
    cpufreq-policy6: performance / 3706 MHz (performance powersave)
    cpufreq-policy7: performance / 2600 MHz (performance powersave)
    cpufreq-policy8: performance / 400 MHz (performance powersave)
    cpufreq-policy9: performance / 2039 MHz (performance powersave)

Tuned governor settings:

    cpufreq-policy0: performance / 1075 MHz
    cpufreq-policy10: performance / 2600 MHz
    cpufreq-policy11: performance / 2600 MHz
    cpufreq-policy12: performance / 2600 MHz
    cpufreq-policy13: performance / 2600 MHz
    cpufreq-policy14: performance / 2600 MHz
    cpufreq-policy15: performance / 2600 MHz
    cpufreq-policy1: performance / 2741 MHz
    cpufreq-policy2: performance / 3853 MHz
    cpufreq-policy3: performance / 2600 MHz
    cpufreq-policy4: performance / 3478 MHz
    cpufreq-policy5: performance / 2600 MHz
    cpufreq-policy6: performance / 3348 MHz
    cpufreq-policy7: performance / 2600 MHz
    cpufreq-policy8: performance / 400 MHz
    cpufreq-policy9: performance / 2600 MHz

Status of performance related policies found below /sys:

    /sys/module/pcie_aspm/parameters/policy: default [performance] powersave powersupersave

### Clockspeeds (idle vs. heated up):

Before at 62.0°C:

    cpu0-cpu7 (Raptor Cove): OPP: 5000, Measured: 4970 
    cpu8-cpu15 (Gracemont): OPP: 3700, Measured: 3690 

After at 82.0°C:

    cpu0-cpu7 (Raptor Cove): OPP: 5000, Measured: 4986 
    cpu8-cpu15 (Gracemont): OPP: 3700, Measured: 3690 

### Performance baseline

  * cpu0 (Raptor Cove): memcpy: 25389.5 MB/s, memchr: 30560.0 MB/s, memset: 24731.8 MB/s
  * cpu8 (Gracemont): memcpy: 7165.4 MB/s, memchr: 9257.6 MB/s, memset: 8117.8 MB/s
  * cpu0 (Raptor Cove) 16M latency: 27.34 21.84 27.56 22.00 26.56 22.73 23.19 30.48 
  * cpu8 (Gracemont) 16M latency: 42.34 34.27 42.40 35.83 42.24 36.45 36.41 38.83 
  * cpu0 (Raptor Cove) 128M latency: 90.93 86.37 90.33 88.11 90.51 81.06 80.37 81.29 
  * cpu8 (Gracemont) 128M latency: 114.0 113.8 114.2 114.6 113.8 111.0 110.6 112.8 
  * 7-zip MIPS (3 consecutive runs): 50396, 41152, 41747 (44430 avg), single-threaded: 5867
  * `aes-256-cbc    1438828.64k  1733297.96k  1757919.91k  1769635.50k  1772008.79k  1771334.31k (Raptor Cove)`
  * `aes-256-cbc    1010215.46k  1283383.51k  1326648.58k  1337359.70k  1341131.43k  1341521.92k (Gracemont)`

### Storage devices:

  * 953.9GB "WD PC SN740 SDDPTQD-1T00" SSD as /dev/nvme0: Speed 16GT/s (ok), Width x4 (ok), 0% worn out, 4 error log entries, drive temp: 55°C
  * "Realtek Card reader" as /dev/sda: USB, Driver=usb-storage, 5000Mbps (capable of 12Mbps, 480Mbps, 5Gbps)
  * 447.1GB "JMicron JMS583 NVMe bridge (SuperSpeed Plus / Gen3 x2)" as /dev/sdb: USB, Driver=uas, 5000Mbps (capable of 12Mbps, 480Mbps, 5Gbps)
  * "Realtek Card reader" as /dev/sdc: USB, Driver=usb-storage, 5000Mbps (capable of 12Mbps, 480Mbps, 5Gbps)
  * 58.6GB "Kingston Technology DataTraveler 100 G3/G4/SE9 G2/50" as /dev/sdd: USB, Driver=usb-storage, 5000Mbps (capable of 12Mbps, 480Mbps, 5Gbps)
  * 238.5GB "JMicron JMS583" as /dev/sde: USB, Driver=uas, 10000Mbps (capable of 12Mbps, 480Mbps, 5Gbps, 10Gb/s Symmetric RX SuperSpeedPlus, 10Gb/s Symmetric TX SuperSpeedPlus)
  * 931.5GB "Seagate RSS LLC Ultra Slim GD" as /dev/sdf: USB, Driver=uas, 5000Mbps (capable of 12Mbps, 480Mbps, 5Gbps)
  * Winbond W25Q256 32MB SPI NOR flash, drivers in use: spi-nor/intel-spi

"nvme error-log /dev/nvme0 ; smartctl -x /dev/nvme0" could be used to get further information about the reported issues.

### Challenging filesystems:

The following partitions are NTFS: sdb1,sde1,sdf1,nvme0n1p3,nvme0n1p4

When this OS uses FUSE/userland methods to access NTFS filesystems performance
will be significantly harmed or at least likely be bottlenecked by maxing out
one or more CPU cores. It is highly advised when benchmarking with any NTFS to
monitor closely CPU utilization or better switch to a 'Linux native' filesystem
like ext4 since representing 'storage performance' a lot more than 'somewhat
dealing with a foreign filesystem' as with NTFS.

### Software versions:

  * Ubuntu 22.04.3 LTS
  * Compiler: /usr/bin/gcc (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0 / x86_64-linux-gnu
  * OpenSSL 3.0.2, built on 15 Mar 2022 (Library: OpenSSL 3.0.2 15 Mar 2022)    

### Kernel info:

  * `/proc/cmdline: BOOT_IMAGE=/boot/vmlinuz-6.2.0-26-generic root=UUID=facdf161-c898-4860-ac44-74e9d68a6b7d ro quiet splash vt.handoff=7`
  * Vulnerability Spec store bypass: Mitigation; Speculative Store Bypass disabled via prctl
  * Vulnerability Spectre v1:        Mitigation; usercopy/swapgs barriers and __user pointer sanitization
  * Vulnerability Spectre v2:        Mitigation; Enhanced IBRS, IBPB conditional, RSB filling, PBRSB-eIBRS SW sequence
  * Kernel 6.2.0-26-generic / CONFIG_HZ=250