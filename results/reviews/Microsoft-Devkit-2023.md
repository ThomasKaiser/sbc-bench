# Microsoft Devkit 2023

Tested with sbc-bench v0.9.38 on Mon, 13 Mar 2023 14:10:27 +0100. Full info: [http://ix.io/4qIj](http://ix.io/4qIj)

Interestingly single-threaded 7-zip MIPS are significantly lower compared to running the 7-zip benchmark in a WSL2 VM on otherwise identical hardware. This is caused by [memory latency with larg(er) blocks being way worse with Linux running bare metal compared to running in a VM on top of Windows 11](https://github.com/ThomasKaiser/sbc-bench/issues/60#issuecomment-1466069724).

### General information:

The CPU features 2 clusters of different core types:

    Snapdragon 449 rev 1.1, Qualcomm Snapdragon 8cx Gen 3, Kernel: aarch64, Userland: arm64

    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      300    2438   Cortex-A78C / r0p0
      1        0        0      300    2438   Cortex-A78C / r0p0
      2        0        0      300    2438   Cortex-A78C / r0p0
      3        0        0      300    2438   Cortex-A78C / r0p0
      4        0        4      826    2995   Cortex-X1C / r0p0
      5        0        4      826    2995   Cortex-X1C / r0p0
      6        0        4      826    2995   Cortex-X1C / r0p0
      7        0        4      826    2995   Cortex-X1C / r0p0

31420 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: performance / 2438 MHz (conservative ondemand userspace powersave performance schedutil / 300 403 499 595 691 806 902 1018 1114 1210 1325 1440 1555 1670 1786 1882 1997 2112 2227 2342 2438)
    cpufreq-policy4: performance / 2995 MHz (conservative ondemand userspace powersave performance schedutil / 826 941 1056 1171 1286 1402 1517 1632 1747 1862 1978 2074 2170 2285 2400 2496 2592 2688 2803 2899 2995)

Tuned governor settings:

    cpufreq-policy0: performance / 2438 MHz
    cpufreq-policy4: performance / 2995 MHz

Status of performance related policies found below /sys:

    /sys/module/pcie_aspm/parameters/policy: default [performance] powersave powersupersave

### Clockspeeds (idle vs. heated up):

Before at 35.2°C:

    cpu0-cpu3 (Cortex-A78C): OPP: 2438, Measured: 2433
    cpu4-cpu7 (Cortex-X1C): OPP: 2995, Measured: 2991

After at 59.1°C:

    cpu0-cpu3 (Cortex-A78C): OPP: 2438, Measured: 2433
    cpu4-cpu7 (Cortex-X1C): OPP: 2995, Measured: 2991

### Performance baseline

  * cpu0 (Cortex-A78C): memcpy: 15206.9 MB/s, memchr: 23040.3 MB/s, memset: 38607.5 MB/s
  * cpu4 (Cortex-X1C): memcpy: 17704.5 MB/s, memchr: 27147.2 MB/s, memset: 42187.9 MB/s
  * cpu0 (Cortex-A78C) 16M latency: 64.26 47.70 68.82 47.89 63.67 36.73 31.92 51.79
  * cpu4 (Cortex-X1C) 16M latency: 44.93 30.58 39.82 30.58 41.85 25.39 27.55 48.23
  * 7-zip MIPS (3 consecutive runs): 35268, 35481, 35392 (35380 avg), single-threaded: 4278
  * `aes-256-cbc     822719.49k  1181035.69k  1317447.08k  1359060.31k  1372359.34k  1373170.35k (Cortex-A78C)`
  * `aes-256-cbc    1161465.83k  1541332.95k  1644596.65k  1683085.31k  1693589.50k  1694493.35k (Cortex-X1C)`

### Storage devices:

  * 476.9GB "KBG40ZNS512G BG4A KIOXIA" SSD as /dev/nvme0: Speed 8GT/s, Width x4, 0% worn out, drive temp: 51°C
  * 59.5GB "Realtek Card Reader" as /dev/sda: USB, Driver=usb-storage, 480Mbps (capable of 12Mbps, 480Mbps, 5Gbps)

### Challenging filesystems:

The following partitions are NTFS: nvme0n1p4

When this OS uses FUSE/userland methods to access NTFS filesystems performance
will be significantly harmed or at least likely be bottlenecked by maxing out
one or more CPU cores. It is highly advised when benchmarking with any NTFS to
monitor closely CPU utilization or better switch to a 'Linux native' filesystem
like ext4 since representing 'storage performance' a lot more than 'somewhat
dealing with a foreign filesystem' as with NTFS.

### Software versions:

  * Ubuntu 22.10
  * Build scripts: git@github.com:armbian/build.git, 23.02.0-trunk, UEFI arm64, uefi-arm64, arm64
  * Compiler: /usr/bin/gcc (Ubuntu 12.2.0-3ubuntu1) 12.2.0 / aarch64-linux-gnu

### Kernel info:

  * `/proc/cmdline: BOOT_IMAGE=/boot/vmlinuz-6.2.2-arm64 root=UUID=0a2efc89-1705-459e-ad2b-a6da7fe27af3 ro console=tty1 clk_ignore_unused efi=novamap earlycon=efifb console=efifb loglevel=9`
  * Vulnerability Spec store bypass: Mitigation; Speculative Store Bypass disabled via prctl
  * Vulnerability Spectre v1:        Mitigation; __user pointer sanitization
  * Vulnerability Spectre v2:        Mitigation; CSV2, BHB
  * Kernel 6.2.2-arm64 / CONFIG_HZ=1000
