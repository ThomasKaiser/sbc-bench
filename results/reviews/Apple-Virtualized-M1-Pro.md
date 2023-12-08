# Apple Inc. Apple Virtualization Generic Platform 1

Tested with sbc-bench v0.9.40 on Fri, 31 Mar 2023 13:20:09 +0200. Full info: [http://ix.io/4sjK](../4sjK.txt)

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

3912 KB available RAM

### Clockspeeds (idle vs. heated up):

Before:

    cpu0 (Virtualized Apple Silicon): Measured: 3194

After:

    cpu0 (Virtualized Apple Silicon): Measured: 3217

### Performance baseline

  * memcpy: 26933.3 MB/s, memchr: 42299.4 MB/s, memset: 41132.1 MB/s
  * 16M latency: 68.54 69.82 72.44 64.60 75.24 67.39 55.15 55.03 
  * 128M latency: 161.5 159.4 159.7 166.3 161.9 159.3 145.4 139.7 
  * 7-zip MIPS (3 consecutive runs): 44601, 45937, 44340 (44960 avg), single-threaded: 4986
  * `aes-256-cbc     226471.40k   613499.37k   928709.03k  1062234.11k  1122754.56k  1123620.18k`
  * `aes-256-cbc     229440.87k   619120.90k   922292.39k  1059065.17k  1114537.98k  1122364.07k`

### Storage devices:

  * 3.7GB "Apple, Inc. Virtual USB Mass Storage Device" as /dev/sda: USB, Driver=usb-storage, 480Mbps
  * 20GB Virtual disk: /dev/vda, Driver=virtio-pci

### Swap configuration:

  * /dev/vda2: 2.1G (0K used)

### Software versions:

  * Ubuntu 22.04.2 LTS
  * Compiler: /usr/bin/gcc (Ubuntu 11.3.0-1ubuntu1~22.04) 11.3.0 / aarch64-linux-gnu

### Kernel info:

  * `/proc/cmdline: BOOT_IMAGE=/BOOT/ubuntu_d8ngpo@/vmlinuz-5.19.0-38-generic root=ZFS=rpool/ROOT/ubuntu_d8ngpo ro quiet splash vt.handoff=1`
  * Vulnerability Spec store bypass: Mitigation; Speculative Store Bypass disabled via prctl
  * Vulnerability Spectre v1:        Mitigation; __user pointer sanitization
  * Kernel 5.19.0-38-generic / CONFIG_HZ=250