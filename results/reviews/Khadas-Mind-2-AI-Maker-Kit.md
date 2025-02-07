# KHADAS Mind 2 AI Maker Kit / Ultra 7 258V

Tested with sbc-bench v0.9.69 on Sun, 02 Feb 2025 14:15:36 +0700. Full info: [https://0x0.st/8Ko-.bin](.../8Ko-.txt)
 
### General information:
 
The CPU features 2 clusters of different core types:
 
    Ultra 7 258V, Kernel: x86_64, Userland: amd64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      400    4700   Lion Cove
      1        0        1      400    4800   Lion Cove
      2        0        2      400    4800   Lion Cove
      3        0        3      400    4700   Lion Cove
      4        0        4      400    3700   Skymont
      5        0        5      400    3700   Skymont
      6        0        6      400    3700   Skymont
      7        0        7      400    3700   Skymont
 
31153 KB available RAM
 
### Policies (performance vs. idle consumption):
 
Status of performance related policies found below /sys:
 
    /sys/module/pcie_aspm/parameters/policy: default [performance] powersave powersupersave
 
### Clockspeeds (idle vs. heated up):
 
Before at 40.0°C:
 
    cpu0-cpu3 (Lion Cove): OPP: 4700, Measured: 4685 
    cpu4-cpu7 (Skymont): OPP: 3700, Measured: 3656      (-1.2%)
 
After at 66.0°C:
 
    cpu0-cpu3 (Lion Cove): OPP: 4700, Measured: 4685 
    cpu4-cpu7 (Skymont): OPP: 3700, Measured: 3654      (-1.2%)
 
### Performance baseline
 
  * cpu0 (Lion Cove): memcpy: 30172.9 MB/s, memchr: 39503.0 MB/s, memset: 99951.2 MB/s
  * cpu4 (Skymont): memcpy: 13892.6 MB/s, memchr: 16834.2 MB/s, memset: 23418.1 MB/s
  * cpu0 (Lion Cove) 16M latency: 31.41 24.92 31.32 25.03 31.37 26.91 25.82 34.49 
  * cpu4 (Skymont) 16M latency: 159.3 139.1 159.4 141.9 159.7 126.8 111.3 103.7 
  * cpu0 (Lion Cove) 128M latency: 123.2 109.0 123.0 112.2 124.0 106.7 96.59 86.69 
  * cpu4 (Skymont) 128M latency: 197.2 199.4 201.7 197.6 201.2 185.7 189.8 187.5 
  * 7-zip MIPS (3 consecutive runs): 32768, 31335, 30330 (31480 avg), single-threaded: 5807
  * `aes-256-cbc    1440358.14k  1612205.21k  1652203.43k  1662480.04k  1665529.17k  1661348.52k (Lion Cove)`
  * `aes-256-cbc    1122405.06k  1268959.79k  1311087.87k  1322728.79k  1325938.01k  1327579.14k (Skymont)`
 
### PCIe and storage devices:
 
  * Intel Lunar Lake [Intel Arc Graphics 130V / 140V] (Onboard - Video): driver in use: xe
  * Intel Lunar Lake-M Thunderbolt 4 USB (Onboard - Other): driver in use: xhci_hcd
  * Intel Lunar Lake-M Thunderbolt 4 NHI #0 (Onboard - Other): driver in use: thunderbolt
  * Intel Lunar Lake-M USB 3.2 Gen 2x1 xHCI Host (Onboard - Other): driver in use: xhci_hcd
  * Intel BE201 320MHz (Onboard - Ethernet): driver in use: 
  * Intel Lunar Lake-M HD Audio (Onboard - Sound): driver in use: snd_hda_intel
  * 953.9GB "WD PC SN740 SDDPTQD-1T00" SSD as /dev/nvme0: Speed 16GT/s, Width x4, 0% worn out, 2 error log entries, drive temp: 47°C, ASPM Disabled
  * Winbond W25Q256JW 32MB SPI NOR flash, drivers in use: spi-nor/intel-spi
 
"nvme error-log /dev/nvme0 ; smartctl -x /dev/nvme0" could be used to get further information about the reported issues.
 
### Challenging filesystems:
 
The following partitions are NTFS: nvme0n1p3,nvme0n1p4 -> https://tinyurl.com/mv7wvzct
 
### Swap configuration:
 
  * /swap.img on /dev/nvme0n1p5: 8.0G (0K used)
 
### Software versions:
 
  * Ubuntu 24.10 (oracular)
  * Compiler: /usr/bin/gcc (Ubuntu 14.2.0-4ubuntu2) 14.2.0 / x86_64-linux-gnu
  * OpenSSL 3.3.1, built on 4 Jun 2024 (Library: OpenSSL 3.3.1 4 Jun 2024)    
 
### Kernel info:
 
  * `/proc/cmdline: BOOT_IMAGE=/boot/vmlinuz-6.11.0-14-generic root=UUID=c4b6c017-6b2e-4679-8bc1-122fb68a434e ro intel_iommu=on quiet splash crashkernel=2G-4G:320M,4G-32G:512M,32G-64G:1024M,64G-128G:2048M,128G-:4096M vt.handoff=7`
  * Vulnerability Spec store bypass:      Mitigation; Speculative Store Bypass disabled via prctl
  * Vulnerability Spectre v1:             Mitigation; usercopy/swapgs barriers and __user pointer sanitization
  * Kernel 6.11.0-14-generic / CONFIG_HZ=1000