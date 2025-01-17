# GEEKOM  GT1 Mega   / Ultra 9 185H

Tested with sbc-bench v0.9.68 on Sun, 01 Dec 2024 16:53:00 +0700. Full info: [https://0x0.st/XRRi.bin](../XRRi.txt)

### General information:

The CPU features 3 clusters of different core types:

    Ultra 9 185H, Kernel: x86_64, Userland: amd64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      400    4800   Redwood Cove
      1        0        1      400    5100   Redwood Cove
      2        0        2      400    5100   Redwood Cove
      3        0        3      400    5100   Redwood Cove
      4        0        4      400    5100   Redwood Cove
      5        0        5      400    4800   Redwood Cove
      6        0        6      400    4800   Redwood Cove
      7        0        7      400    4800   Redwood Cove
      8        0        8      400    4800   Redwood Cove
      9        0        9      400    4800   Redwood Cove
     10        0       10      400    4800   Redwood Cove
     11        0       11      400    4800   Redwood Cove
     12        0       12      400    3800   Crestmont
     13        0       13      400    3800   Crestmont
     14        0       14      400    3800   Crestmont
     15        0       15      400    3800   Crestmont
     16        0       16      400    3800   Crestmont
     17        0       17      400    3800   Crestmont
     18        0       18      400    3800   Crestmont
     19        0       19      400    3800   Crestmont
     20        0       20      400    2500   Crestmont
     21        0       21      400    2500   Crestmont

31101 KB available RAM

### Policies (performance vs. idle consumption):

Status of performance related policies found below /sys:

    /sys/module/pcie_aspm/parameters/policy: default [performance] powersave powersupersave

### Clockspeeds (idle vs. heated up):

Before at 47.0°C:

    cpu0-cpu11 (Redwood Cove): OPP: 4800, Measured: 4780 
    cpu12-cpu19 (Crestmont): OPP: 3800, Measured: 3781 
    cpu20-cpu21 (Crestmont): OPP: 2500, Measured: 2487 

After at 68.0°C:

    cpu0-cpu11 (Redwood Cove): OPP: 4800, Measured: 4782 
    cpu12-cpu19 (Crestmont): OPP: 3800, Measured: 3781 
    cpu20-cpu21 (Crestmont): OPP: 2500, Measured: 2487 

### Performance baseline

  * cpu0 (Redwood Cove): memcpy: 21364.6 MB/s, memchr: 27649.3 MB/s, memset: 36928.3 MB/s
  * cpu12 (Crestmont): memcpy: 12085.2 MB/s, memchr: 11963.9 MB/s, memset: 21992.2 MB/s
  * cpu20 (Crestmont): memcpy: 9243.4 MB/s, memchr: 9979.2 MB/s, memset: 14459.5 MB/s
  * cpu0 (Redwood Cove) 16M latency: 24.89 19.82 21.85 20.03 21.53 20.30 19.84 22.44 
  * cpu12 (Crestmont) 16M latency: 33.55 29.04 32.08 29.38 31.53 29.93 29.47 35.50 
  * cpu20 (Crestmont) 16M latency: 172.4 173.3 172.5 173.5 171.7 164.6 166.6 172.2 
  * cpu0 (Redwood Cove) 128M latency: 127.6 111.8 134.4 122.8 125.1 104.6 96.52 97.63 
  * cpu12 (Crestmont) 128M latency: 236.3 204.6 240.5 212.0 233.8 224.8 188.5 194.2 
  * cpu20 (Crestmont) 128M latency: 397.3 400.6 362.5 192.5 189.5 181.8 188.4 199.1 
  * 7-zip MIPS (3 consecutive runs): 71623, 68178, 64074 (67960 avg), single-threaded: 5558
  * `aes-256-cbc    1473766.42k  1635492.37k  1687675.22k  1692901.72k  1698067.80k  1698239.83k (Redwood Cove)`
  * `aes-256-cbc    1052766.34k  1310007.51k  1324641.02k  1346352.81k  1364325.72k  1336044.20k (Crestmont)`
  * `aes-256-cbc     696278.79k   864204.27k   871684.44k   888091.31k   901551.45k   902589.10k (Crestmont)`

### PCIe and storage devices:

  * Intel Meteor Lake-P [Intel Arc Graphics] (Onboard - Video): driver in use: i915
  * Intel Meteor Lake-P Thunderbolt 4 USB (Onboard - Other): driver in use: xhci_hcd
  * Intel Meteor Lake-P Thunderbolt 4 NHI #0 (Onboard - Other): driver in use: thunderbolt
  * Intel Meteor Lake-P Thunderbolt 4 NHI #1 (Onboard - Other): driver in use: thunderbolt
  * Intel Meteor Lake-P USB 3.2 Gen 2x1 xHCI Host (Onboard - Other): driver in use: xhci_hcd
  * Intel Device 7e63 (Onboard - SATA): driver in use: ahci
  * Intel Meteor Lake-P HD Audio (Onboard - Sound): driver in use: sof-audio-pci-intel-mtl
  * Intel Ethernet I226-V: Speed 5GT/s, Width x1, driver in use: igc, ASPM Disabled
  * Intel Ethernet I226-V: Speed 5GT/s, Width x1, driver in use: igc, ASPM Disabled
  * Intel Wi-Fi 7(802.11be) AX1775*/AX1790*/BE20*/BE401/BE1750* 2x2: Speed 16GT/s, Width x1, driver in use: iwlwifi, ASPM Disabled
  * 1.8TB "Crucial CT2000P3PSSD8" SSD as /dev/nvme0: Speed 16GT/s, Width x4, 0% worn out, drive temp: 44°C, ASPM Disabled
  * 32MB SPI NOR flash, drivers in use: spi-nor/intel-spi

### Challenging filesystems:

The following partitions are NTFS: nvme0n1p3,nvme0n1p4 -> https://tinyurl.com/mv7wvzct

### Swap configuration:

  * /swap.img on /dev/nvme0n1p5: 8.0G (0K used)

### Software versions:

  * Ubuntu 24.10 (oracular)
  * Compiler: /usr/bin/gcc (Ubuntu 14.2.0-4ubuntu2) 14.2.0 / x86_64-linux-gnu
  * OpenSSL 3.3.1, built on 4 Jun 2024 (Library: OpenSSL 3.3.1 4 Jun 2024)    

### Kernel info:

  * `/proc/cmdline: BOOT_IMAGE=/boot/vmlinuz-6.11.0-9-generic root=UUID=cc5cd19a-0aa5-435b-8bf0-162f0b7b8949 ro quiet splash crashkernel=2G-4G:320M,4G-32G:512M,32G-64G:1024M,64G-128G:2048M,128G-:4096M vt.handoff=7`
  * Vulnerability Spec store bypass:      Mitigation; Speculative Store Bypass disabled via prctl
  * Vulnerability Spectre v1:             Mitigation; usercopy/swapgs barriers and __user pointer sanitization
  * Kernel 6.11.0-9-generic / CONFIG_HZ=1000
