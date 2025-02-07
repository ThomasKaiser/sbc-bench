# GMKtec NucBoxG3 Plus  / N150

Tested with sbc-bench v0.9.70 on Thu, 30 Jan 2025 17:42:17 -0600. Full info: [https://0x0.st/88vb.bin](../88vb.txt)

### General information:

    Information courtesy of cpufetch:
    
    Name:                Intel(R) N150
    Microarchitecture:   Alder Lake
    Technology:          10nm
    Max Frequency:       3.600 GHz
    Cores:               4 cores
    AVX:                 AVX,AVX2
    FMA:                 FMA3
    L1i Size:            64KB (256KB Total)
    L1d Size:            32KB (128KB Total)
    L2 Size:             2MB
    L3 Size:             6MB
    
    N150, Kernel: x86_64, Userland: amd64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      700    3600       -
      1        0        1      700    3600       -
      2        0        2      700    3600       -
      3        0        3      700    3600       -

15736 KB available RAM

### Policies (performance vs. idle consumption):

Status of performance related policies found below /sys:

    /sys/module/pcie_aspm/parameters/policy: [default] performance powersave powersupersave

### Clockspeeds (idle vs. heated up):

Before at 63.0°C:

    cpu0: OPP: 3600, Measured: 3586 

After at 73.0°C:

    cpu0: OPP: 3600, Measured: 3586 

### Performance baseline

  * memcpy: 9403.3 MB/s, memchr: 15423.3 MB/s, memset: 8434.2 MB/s
  * 16M latency: 111.1 99.57 111.7 99.73 111.3 98.34 99.39 107.4 
  * 128M latency: 123.3 116.4 124.1 117.3 122.7 122.5 117.9 121.1 
  * 7-zip MIPS (3 consecutive runs): 10796, 10091, 10114 (10330 avg), single-threaded: 3997
  * `aes-256-cbc     929885.15k  1246829.78k  1289329.32k  1300053.33k  1303188.82k  1302380.54k`
  * `aes-256-cbc     955655.73k  1247196.78k  1289070.85k  1299956.74k  1301919.06k  1297694.72k`

### PCIe and storage devices:

  * Intel Alder Lake-N [Intel Graphics] (Onboard - Video): driver in use: 
  * Intel Alder Lake-N PCH USB 3.2 xHCI Host (Onboard - Other): driver in use: xhci_hcd
  * Intel Alder Lake-N SATA AHCI (Onboard - SATA): driver in use: ahci
  * Intel Device 54c4 (Onboard - Other): driver in use: sdhci-pci
  * Realtek RTL8852BE PCIe 802.11ax Wireless Network: Speed 2.5GT/s, Width x1, driver in use: rtw89_8852be, 
  * Intel Ethernet I226-V: Speed 5GT/s, Width x1, driver in use: igc, ASPM Disabled
  * 953.9GB "TEAM TM8FP4001T" SSD as /dev/nvme0: Speed 8GT/s, Width x2 (downgraded), 0% worn out, drive temp: 56°C, ASPM Disabled
  * 16MB SPI NOR flash, drivers in use: spi-nor/intel-spi

### Swap configuration:

  * /swap.img on /dev/nvme0n1p2: 4.0G (351.8M used)

### Software versions:

  * Ubuntu 24.04.1 LTS (noble)
  * Compiler: /usr/bin/gcc (Ubuntu 13.3.0-6ubuntu2~24.04) 13.3.0 / x86_64-linux-gnu
  * OpenSSL 3.0.13, built on 30 Jan 2024 (Library: OpenSSL 3.0.13 30 Jan 2024)    

### Kernel info:

  * `/proc/cmdline: BOOT_IMAGE=/boot/vmlinuz-6.8.0-51-generic root=UUID=d2cc812c-129b-4785-8af5-493bf4e63084 ro quiet splash vt.handoff=7`
  * Vulnerability Reg file data sampling: Mitigation; Clear Register File
  * Vulnerability Spec store bypass:      Mitigation; Speculative Store Bypass disabled via prctl
  * Vulnerability Spectre v1:             Mitigation; usercopy/swapgs barriers and __user pointer sanitization
  * Kernel 6.8.0-51-generic / CONFIG_HZ=1000