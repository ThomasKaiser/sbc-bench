# Apple Inc. Apple Virtualization Generic Platform 1

Tested with sbc-bench v0.9.40 on Sat, 01 Apr 2023 15:28:35 +0200. Full info: [http://ix.io/4sp4](http://ix.io/4sp4)

### General information:

    Apple Silicon / guess flawed since running in apple-hypervisor v1, Kernel: aarch64 / apple-hypervisor v1, Userland: arm64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0       -      -     Virtualized Apple Silicon / r0p0
      1        0        0       -      -     Virtualized Apple Silicon / r0p0
      2        0        0       -      -     Virtualized Apple Silicon / r0p0
      3        0        0       -      -     Virtualized Apple Silicon / r0p0
      4        0        0       -      -     Virtualized Apple Silicon / r0p0
      5        0        0       -      -     Virtualized Apple Silicon / r0p0
      6        0        0       -      -     Virtualized Apple Silicon / r0p0
      7        0        0       -      -     Virtualized Apple Silicon / r0p0
      8        0        0       -      -     Virtualized Apple Silicon / r0p0
      9        0        0       -      -     Virtualized Apple Silicon / r0p0
     10        0        0       -      -     Virtualized Apple Silicon / r0p0
     11        0        0       -      -     Virtualized Apple Silicon / r0p0

3911 KB available RAM

### Clockspeeds (idle vs. heated up):

Before:

    cpu0 (Virtualized Apple Silicon): Measured: 3493

After:

    cpu0 (Virtualized Apple Silicon): Measured: 3399

### Performance baseline

  * memcpy: 29399.2 MB/s, memchr: 45024.9 MB/s, memset: 42712.4 MB/s
  * 16M latency: 41.11 41.34 40.70 41.27 39.74 41.90 33.14 31.71 
  * 128M latency: 133.2 132.8 132.5 132.9 133.1 123.1 112.4 106.5 
  * 7-zip MIPS (3 consecutive runs): 60164, 61620, 61662 (61150 avg), single-threaded: 5776
  * `aes-256-cbc     342798.53k   861036.76k  1169507.93k  1275521.71k  1316850.35k  1318890.15k`
  * `aes-256-cbc     345031.93k   861389.80k  1167827.11k  1277829.12k  1314204.33k  1322046.81k`

### Storage devices:

  * 3.7GB "Apple, Inc. Virtual USB Mass Storage Device" as /dev/sda: USB, Driver=usb-storage, 480Mbps
  * 20GB Virtual disk: /dev/vda, Driver=virtio-pci

### Swap configuration:

  * /dev/vda2: 2.1G (267.4M used)

### Software versions:

  * Ubuntu 22.04.2 LTS
  * Compiler: /usr/bin/gcc (Ubuntu 11.3.0-1ubuntu1~22.04) 11.3.0 / aarch64-linux-gnu

### Kernel info:

  * `/proc/cmdline: BOOT_IMAGE=/BOOT/ubuntu_s040fe@/vmlinuz-5.19.0-38-generic root=ZFS=rpool/ROOT/ubuntu_s040fe ro quiet splash vt.handoff=1`
  * Vulnerability Spec store bypass: Mitigation; Speculative Store Bypass disabled via prctl
  * Vulnerability Spectre v1:        Mitigation; __user pointer sanitization
  * Kernel 5.19.0-38-generic / CONFIG_HZ=250
