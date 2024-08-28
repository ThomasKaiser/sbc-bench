# Radxa X4 / N100

Tested with sbc-bench v0.9.67 on Wed, 31 Jul 2024 11:56:12 -0500. Full info: [https://0x0.st/XObB.bin](https://0x0.st/XObB.bin)

### General information:

    Information courtesy of cpufetch:
    
    Name:                Intel(R) N100
    Microarchitecture:   Alder Lake
    Technology:          10nm
    Max Frequency:       3.400 GHz
    Cores:               4 cores
    AVX:                 AVX,AVX2
    FMA:                 FMA3
    L1i Size:            64KB (256KB Total)
    L1d Size:            32KB (128KB Total)
    L2 Size:             2MB
    L3 Size:             6MB
    
    N100, Kernel: x86_64, Userland: amd64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      700    3400   Alder Lake
      1        0        1      700    3400   Alder Lake
      2        0        2      700    3400   Alder Lake
      3        0        3      700    3400   Alder Lake

7717 KB available RAM

### Policies (performance vs. idle consumption):

Status of performance related policies found below /sys:

    /sys/module/pcie_aspm/parameters/policy: default [performance] powersave powersupersave

### Clockspeeds (idle vs. heated up):

Before at 49.0°C:

    cpu0: OPP: 3400, Measured: 3387 

After at 57.0°C:

    cpu0: OPP: 3400, Measured: 3387 

### Performance baseline

  * memcpy: 8144.4 MB/s, memchr: 13252.6 MB/s, memset: 7965.4 MB/s
  * 16M latency: 144.3 125.7 146.3 125.6 144.3 124.6 118.5 125.8 
  * 128M latency: 159.8 144.7 161.1 144.8 160.7 170.8 137.9 140.6 
  * 7-zip MIPS (3 consecutive runs): 7985, 8027, 8022 (8010 avg), single-threaded: 3582
  * `aes-256-cbc     894653.29k  1178107.88k  1214575.10k  1228173.99k  1231290.37k  1230738.77k`
  * `aes-256-cbc     903163.26k  1178130.43k  1217936.55k  1228097.54k  1230364.67k  1231454.21k`

### PCIe and storage devices:

  * Intel Alder Lake-N [UHD Graphics] (Onboard - Video): driver in use: i915
  * Intel Alder Lake-N Thunderbolt 4 USB (Onboard - Other): driver in use: xhci_hcd
  * Intel Device 54fc (Onboard - Other): driver in use: 
  * Intel Alder Lake-N PCH USB 3.2 xHCI Host (Onboard - Other): driver in use: xhci_hcd
  * Intel Device 54c4 (Onboard - Other): driver in use: sdhci-pci
  * Realtek RTL8852BE PCIe 802.11ax Wireless Network: Speed 2.5GT/s, Width x1, driver in use: rtw89_8852be, 
  * Intel Ethernet I226-V: Speed 5GT/s, Width x1, driver in use: igc, 
  * 953.9GB "KBG40ZNS1T02 TOSHIBA MEMORY" SSD as /dev/nvme0: Speed 8GT/s, Width x4, 0% worn out, unhealthy drive temp: 75°C, ASPM Disabled
  * Winbond W25Q128 16MB SPI NOR flash, drivers in use: spi-nor/intel-spi

"smartctl -x /dev/nvme0" could be used to get further information about the reported issues.

### Swap configuration:

  * /swap.img on /dev/nvme0n1p2: 4.0G (0K used)

### Software versions:

  * Ubuntu 24.04 LTS (noble)
  * Compiler: /usr/bin/gcc (Ubuntu 13.2.0-23ubuntu4) 13.2.0 / x86_64-linux-gnu
  * OpenSSL 3.0.13, built on 30 Jan 2024 (Library: OpenSSL 3.0.13 30 Jan 2024)    

### Kernel info:

  * `/proc/cmdline: BOOT_IMAGE=/boot/vmlinuz-6.8.0-39-generic root=UUID=9206411e-187b-4c4d-bb6c-2743b6ecd854 ro quiet splash vt.handoff=7`
  * Vulnerability Reg file data sampling: Mitigation; Clear Register File
  * Vulnerability Spec store bypass:      Mitigation; Speculative Store Bypass disabled via prctl
  * Vulnerability Spectre v1:             Mitigation; usercopy/swapgs barriers and __user pointer sanitization
  * Kernel 6.8.0-39-generic / CONFIG_HZ=1000