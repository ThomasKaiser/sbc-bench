# Dell Inc. XPS 13 DX13260 1.3.0 / 5 320

Tested with sbc-bench v0.9.72 on Tue, 04 Aug 2026 11:08:42 -0500.

### General information:

The CPU features 2 clusters of different core types:

    5 320, Kernel: x86_64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      400    4600   Performance
      1        0        1      400    4800   Performance
      2        0        2      400    3400   Efficiency
      3        0        3      400    3400   Efficiency
      4        0        4      400    3400   Efficiency
      5        0        5      400    3400   Efficiency

7515 KB available RAM

### Policies (performance vs. idle consumption):

Status of performance related policies found below /sys:

    /sys/module/pcie_aspm/parameters/policy: default [performance] powersave powersupersave

### Clockspeeds (idle vs. heated up):

Before at 46.0°C:

    cpu0-cpu1 (Performance): OPP: 4600, Measured: 4485      (-2.5%)
    cpu2-cpu5 (Efficiency): OPP: 3400, Measured: 3382 

After at 73.0°C:

    cpu0-cpu1 (Performance): OPP: 4600, Measured: 4486      (-2.5%)
    cpu2-cpu5 (Efficiency): OPP: 3400, Measured: 3381 

### Performance baseline

  * cpu0 (Performance): memcpy: 21611.7 MB/s, memchr: 31973.4 MB/s, memset: 57483.0 MB/s
  * cpu2 (Efficiency): memcpy: 16566.1 MB/s, memchr: 23259.1 MB/s, memset: 24001.2 MB/s
  * cpu0 (Performance) 16M latency: 80.28 58.71 80.50 58.83 79.57 54.53 50.24 47.12 
  * cpu2 (Efficiency) 16M latency: 117.3 106.1 126.4 106.4 122.0 91.54 72.62 65.90 
  * cpu0 (Performance) 128M latency: 137.0 133.2 139.3 132.5 140.5 127.6 115.3 110.4 
  * cpu2 (Efficiency) 128M latency: 136.8 144.5 148.2 149.3 147.4 139.3 132.1 125.8 
  * 7-zip MIPS (3 consecutive runs): 26296, 21974, 22065 (23440 avg), single-threaded: 5461
  * `aes-256-cbc    1378099.04k  1543226.56k  1581501.18k  1591609.34k  1593319.42k  1594518.19k (Performance)`
  * `aes-256-cbc    1039158.83k  1174169.19k  1213851.48k  1224311.47k  1227251.71k  1224720.38k (Efficiency)`

### Storage devices:

  * 476.9GB "BIWIN CE430T5D100-512G" SSD as /dev/nvme0: Speed 8GT/s, Width x4, 0% worn out, drive temp: 48°C, ASPM Disabled
  * Winbond W25Q256JW 32MB SPI NOR flash, drivers in use: spi-nor/intel-spi

### Swap configuration:

  * /dev/zram0: 7.3G (2.2G used, lzo-rle, 1.7G streams, 567.5M data, 581.7M compressed,  total)

### Software versions:

  * Fedora Linux 44 (Workstation Edition)
  * Compiler: /usr/sbin/gcc (GCC) 16.1.1 20260515 (Red Hat 16.1.1-2) / x86_64-redhat-linux
  * OpenSSL 3.5.7, built on 9 Jun 2026 (Library: OpenSSL 3.5.7 9 Jun 2026)    

### Kernel info:

  * `/proc/cmdline: BOOT_IMAGE=(hd0,gpt2)/vmlinuz-7.1.5-201.fc44.x86_64 root=UUID=22993722-024d-4db8-8ab0-73fb3019eab7 ro rootflags=subvol=root rhgb quiet`
  * Vulnerability Spec store bypass:         Mitigation; Speculative Store Bypass disabled via prctl
  * Vulnerability Spectre v1:                Mitigation; usercopy/swapgs barriers and __user pointer sanitization
  * Kernel 7.1.5-201.fc44.x86_64 / CONFIG_HZ=1000