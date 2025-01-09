# Raspberry Pi Compute Module 5 Rev 1.0

Tested with sbc-bench v0.9.68 on Mon, 09 Dec 2024 10:57:47 -0600. Full info: [https://0x0.st/Xh2H.txt](../Xh2H.txt) and [Jeff Geerling's review thread](https://github.com/geerlingguy/sbc-reviews/issues/58).

### General information:

    Information courtesy of cpufetch:
    
    SoC:                 Broadcom BCM2712
    Technology:          16nm
    Microarchitecture:   Cortex-A76
    Max Frequency:       2.400 GHz
    Cores:               4 cores
    Features:            NEON,SHA1,SHA2,AES,CRC32
    
    BCM2712, Kernel: aarch64, Userland: arm64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0     1500    2400   Cortex-A76 / r4p1
      1        0        0     1500    2400   Cortex-A76 / r4p1
      2        0        0     1500    2400   Cortex-A76 / r4p1
      3        0        0     1500    2400   Cortex-A76 / r4p1

4046 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: performance / 2400 MHz (conservative ondemand userspace powersave performance schedutil / 1500 1600 1700 1800 1900 2000 2100 2200 2300 2400)

Tuned governor settings:

    cpufreq-policy0: performance / 2400 MHz

Status of performance related policies found below /sys:

    /sys/module/pcie_aspm/parameters/policy: default [performance] powersave powersupersave

### Clockspeeds (idle vs. heated up):

Before at 54.5°C:

    cpu0 (Cortex-A76): OPP: 2400, ThreadX: 2400, Measured: 2399 

After at 65.5°C:

    cpu0 (Cortex-A76): OPP: 2400, ThreadX: 2400, Measured: 2399 

### Performance baseline

  * memcpy: 5892.4 MB/s, memchr: 14188.5 MB/s, memset: 9675.1 MB/s
  * 16M latency: 100.1 101.0 103.3 100.9 99.88 114.8 130.4 146.9 
  * 128M latency: 116.7 115.2 116.6 115.2 119.5 115.8 116.6 118.4 
  * 7-zip MIPS (3 consecutive runs): 11819, 11858, 11809 (11830 avg), single-threaded: 3306
  * `aes-256-cbc     540521.66k  1003777.26k  1256054.36k  1332929.88k  1365549.06k  1368053.08k`
  * `aes-256-cbc     540683.01k  1003568.53k  1256005.03k  1332878.68k  1365235.03k  1368211.46k`

### PCIe and storage devices:

  * Raspberry RP1 PCIe 2.0 South Bridge: Speed 5GT/s, Width x4, driver in use: rp1, ASPM Disabled
  * 238.5GB "SAMSUNG MZ9LQ256HBJD-00BVL" SSD as /dev/nvme0: Speed 5GT/s (downgraded), Width x1 (downgraded), 0% worn out, drive temp: 31°C, ASPM Disabled
  * 29.1GB "Samsung BJTD4R" HS400 Enhanced strobe eMMC 5.1 card as /dev/mmcblk0: date 07/2024, manfid/oemid: 0x000015/0x0100, hw/fw rev: 0x0/0x0300000000000000

### Swap configuration:

  * /var/swap on /dev/nvme0n1p2: 512.0M (22.0M used)

### Software versions:

  * Debian GNU/Linux 12 (bookworm)
  * Build scripts: http://archive.raspberrypi.com/debian/ bookworm main
  * Compiler: /usr/bin/gcc (Debian 12.2.0-14) 12.2.0 / aarch64-linux-gnu
  * OpenSSL 3.0.15, built on 3 Sep 2024 (Library: OpenSSL 3.0.15 3 Sep 2024)    
  * ThreadX: 3858f977 / 2024/12/07 12:42:23 

### Kernel info:

  * `/proc/cmdline: reboot=w coherent_pool=1M 8250.nr_uarts=1 pci=pcie_bus_safe cgroup_disable=memory numa_policy=interleave  numa=fake=8 system_heap.max_order=0 smsc95xx.macaddr=2C:CF:67:B2:90:2F vc_mem.mem_base=0x3fc00000 vc_mem.mem_size=0x40000000  console=ttyAMA0,115200 console=tty1 root=PARTUUID=ed0632d0-02 rootfstype=ext4 fsck.repair=yes rootwait quiet splash plymouth.ignore-serial-consoles`
  * Vulnerability Spec store bypass:      Mitigation; Speculative Store Bypass disabled via prctl
  * Vulnerability Spectre v1:             Mitigation; __user pointer sanitization
  * Vulnerability Spectre v2:             Mitigation; CSV2, BHB
  * Kernel 6.6.63-v8-16k+ / CONFIG_HZ=250