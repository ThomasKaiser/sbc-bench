# Framework Desktop (AMD Ryzen AI Max 300 Series) A6 / RYZEN AI MAX+ 395 w/ Radeon 8060S

Tested with sbc-bench v0.9.72 on Thu, 07 Aug 2025 09:56:35 -0500. Full info: [https://0x0.st/8hUb.bin](../8hUb.txt)

### General information:

    Information courtesy of cpufetch:
    
    Name:                AMD RYZEN AI MAX+ 395 w/ Radeon 8060S 
    Microarchitecture:   Zen 5
    Technology:          4nm
    Max Frequency:       5.187 GHz
    Cores:               16 cores (32 threads)
    AVX:                 AVX,AVX2,AVX512
    FMA:                 FMA3
    L1i Size:            32KB (512KB Total)
    L1d Size:            48KB (768KB Total)
    L2 Size:             1MB (16MB Total)
    L3 Size:             32MB (64MB Total)
    
    RYZEN AI MAX+ 395 w/ Radeon 8060S, Kernel: x86_64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      625    5188       -
      1        0        1      625    5188       -
      2        0        2      625    5188       -
      3        0        3      625    5188       -
      4        0        4      625    5188       -
      5        0        5      625    5188       -
      6        0        6      625    5188       -
      7        0        7      625    5188       -
      8        0        8      625    5188       -
      9        0        9      625    5188       -
     10        0       10      625    5188       -
     11        0       11      625    5188       -
     12        0       12      625    5188       -
     13        0       13      625    5188       -
     14        0       14      625    5188       -
     15        0       15      625    5188       -
     16        0       16      625    5188       -
     17        0       17      625    5188       -
     18        0       18      625    5188       -
     19        0       19      625    5188       -
     20        0       20      625    5188       -
     21        0       21      625    5188       -
     22        0       22      625    5188       -
     23        0       23      625    5188       -
     24        0       24      625    5188       -
     25        0       25      625    5188       -
     26        0       26      625    5188       -
     27        0       27      625    5188       -
     28        0       28      625    5188       -
     29        0       29      625    5188       -
     30        0       30      625    5188       -
     31        0       31      625    5188       -

128077 KB available RAM

### Policies (performance vs. idle consumption):

Status of performance related policies found below /sys:

    /sys/module/pcie_aspm/parameters/policy: default [performance] powersave powersupersave

### Clockspeeds (idle vs. heated up):

Before:

    cpu0: OPP: 5187, Measured: 5134 

After:

    cpu0: OPP: 5187, Measured: 5135 

### Performance baseline

  * memcpy: 36252.2 MB/s, memchr: 76121.1 MB/s, memset: 65521.7 MB/s
  * 16M latency: 14.40 11.95 13.21 12.02 13.06 12.15 12.12 12.69 
  * 128M latency: 133.3 135.7 128.9 134.6 127.8 137.8 143.0 145.7 
  * 7-zip MIPS (3 consecutive runs): 134400, 133620, 133463 (133830 avg), single-threaded: 6361
  * `aes-256-cbc    1210971.86k  1360321.81k  1401286.49k  1412290.56k  1415004.16k  1414135.81k`
  * `aes-256-cbc    1212328.85k  1360229.25k  1401537.45k  1412318.55k  1415446.53k  1415637.67k`

### PCIe and storage devices:

  * Realtek RTL8126 5GbE: Speed 8GT/s, Width x1, driver in use: r8169, 
  * AMD Strix Halo [Radeon Graphics / Radeon 8050S Graphics / Radeon 8060S Graphics]: Speed 16GT/s, Width x16, driver in use: amdgpu, ASPM Disabled
  * AMD Strix Halo USB 3.1 xHCI: Speed 16GT/s, Width x16, driver in use: xhci_hcd, ASPM Disabled
  * AMD Strix Halo USB 3.1 xHCI: Speed 16GT/s, Width x16, driver in use: xhci_hcd, ASPM Disabled
  * AMD Strix Halo USB 3.1 xHCI: Speed 16GT/s, Width x16, driver in use: xhci_hcd, ASPM Disabled
  * AMD Strix Halo USB 3.1 xHCI: Speed 16GT/s, Width x16, driver in use: xhci_hcd, ASPM Disabled
  * AMD Strix Halo USB4 Host Router: Speed 16GT/s, Width x16, driver in use: thunderbolt, ASPM Disabled
  * AMD Strix Halo USB4 Host Router: Speed 16GT/s, Width x16, driver in use: thunderbolt, ASPM Disabled
  * 931.5GB "WD_BLACK SN7100 1TB" SSD as /dev/nvme0: Speed 16GT/s, Width x4, 0% worn out, drive temp: 43°C, ASPM Disabled

### Swap configuration:

  * /dev/zram0: 8G (0K used, lzo-rle, 4K streams, 80B data, 12K compressed,  total)

### Software versions:

  * Fedora Linux 43 (Workstation Edition Prerelease)
  * Compiler: /usr/sbin/gcc (GCC) 15.1.1 20250719 (Red Hat 15.1.1-5) / x86_64-redhat-linux
  * OpenSSL 3.5.1, built on 1 Jul 2025 (Library: OpenSSL 3.5.1 1 Jul 2025)    

### Kernel info:

  * `/proc/cmdline: BOOT_IMAGE=(hd0,gpt2)/vmlinuz-6.17.0-0.rc0.250804gd2eedaa3909b.10.fc43.x86_64 root=UUID=7138d111-30d8-4fe0-af64-0d8cf3b01c3c ro rootflags=subvol=root rhgb quiet amdgpu.gttsize=108000 amdttm.pages_limit=27648000 amdttm.page_pool_size =27648000`
  * Vulnerability Spec rstack overflow:      Mitigation; IBPB on VMEXIT only
  * Vulnerability Spec store bypass:         Mitigation; Speculative Store Bypass disabled via prctl
  * Vulnerability Spectre v1:                Mitigation; usercopy/swapgs barriers and __user pointer sanitization
  * Kernel 6.17.0-0.rc0.250804gd2eedaa3909b.10.fc43.x86_64 / CONFIG_HZ=1000