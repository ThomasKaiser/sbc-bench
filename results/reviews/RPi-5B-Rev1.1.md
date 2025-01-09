# Raspberry Pi 5 Model B Rev 1.1

Tested with sbc-bench v0.9.68 on Thu, 09 Jan 2025 02:16:54 -0600. Full info: [https://0x0.st/8-NK.txt](../8-NK.txt) and [Jeff Geerling's review thread](https://github.com/geerlingguy/sbc-reviews/issues/21#issuecomment-2579400396).

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

16220 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: ondemand / 2400 MHz (conservative ondemand userspace powersave performance schedutil / 1500 1600 1700 1800 1900 2000 2100 2200 2300 2400)

Tuned governor settings:

    cpufreq-policy0: performance / 2400 MHz

Status of performance related policies found below /sys:

    /sys/module/pcie_aspm/parameters/policy: default [performance] powersave powersupersave

### Clockspeeds (idle vs. heated up):

Before at 44.6°C:

    cpu0 (Cortex-A76): OPP: 2400, ThreadX: 2400, Measured: 2399 

After at 56.8°C:

    cpu0 (Cortex-A76): OPP: 2400, ThreadX: 2400, Measured: 2399 

### Performance baseline

  * memcpy: 6025.0 MB/s, memchr: 14859.1 MB/s, memset: 9985.2 MB/s
  * 16M latency: 101.9 101.5 101.6 101.0 103.3 113.3 130.2 145.5 
  * 128M latency: 117.1 115.6 116.7 115.7 117.9 117.4 117.0 118.2 
  * 7-zip MIPS (3 consecutive runs): 11783, 11866, 11842 (11830 avg), single-threaded: 3305
  * `aes-256-cbc     540351.57k  1003572.29k  1255937.02k  1332891.65k  1365543.59k  1368096.77k`
  * `aes-256-cbc     517353.36k   989511.57k  1250450.18k  1332705.96k  1365412.52k  1368238.76k`

### PCIe and storage devices:

  * Raspberry RP1 PCIe 2.0 South Bridge: Speed 5GT/s, Width x4, driver in use: rp1, 
  * 58.9GB "Longsys USD00" UHS SDR104 SDXC card as /dev/mmcblk0: date 08/2024, manfid/oemid: 0x0000ad/0x4c53, hw/fw rev: 0x2/0x1

### Swap configuration:

  * /var/swap on /dev/mmcblk0p2: 512.0M (249.5M used) on ultra slow SD card storage

### Software versions:

  * Debian GNU/Linux 12 (bookworm)
  * Build scripts: http://archive.raspberrypi.com/debian/ bookworm main
  * Compiler: /usr/bin/gcc (Debian 12.2.0-14) 12.2.0 / aarch64-linux-gnu
  * OpenSSL 3.0.15, built on 3 Sep 2024 (Library: OpenSSL 3.0.15 3 Sep 2024)    
  * ThreadX: 97facbf4 / 2025/01/08 17:52:48 

### Kernel info:

  * `/proc/cmdline: reboot=w coherent_pool=1M 8250.nr_uarts=1 pci=pcie_bus_safe cgroup_disable=memory numa_policy=interleave  numa=fake=8 system_heap.max_order=0 smsc95xx.macaddr=2C:CF:67:C7:6E:8B vc_mem.mem_base=0x3fc00000 vc_mem.mem_size=0x40000000  console=ttyAMA10,115200 console=tty1 root=PARTUUID=85d76a1a-02 rootfstype=ext4 fsck.repair=yes rootwait quiet splash plymouth.ignore-serial-consoles cfg80211.ieee80211_regdom=US`
  * Vulnerability Spec store bypass:      Mitigation; Speculative Store Bypass disabled via prctl
  * Vulnerability Spectre v1:             Mitigation; __user pointer sanitization
  * Vulnerability Spectre v2:             Mitigation; CSV2, BHB
  * Kernel 6.6.69-v8-16k+ / CONFIG_HZ=250