# RPi 4 Model B Rev 1.4 / BCM2711 Rev B0

Tested with sbc-bench v0.9.72 on Fri, 03 Jul 2026 12:15:53 -0500.

### General information:

    Information courtesy of cpufetch:
    
    SoC:                 Broadcom BCM2711
    Technology:          28nm
    Microarchitecture:   Cortex-A72
    Max Frequency:       1.300 GHz
    Cores:               4 cores
    Features:            NEON,CRC32
    
The CPU features 2 clusters of same core type:

    BCM2711B0, RPi 4 Model B Rev 1.4 / BCM2711 Rev B0, Kernel: aarch64, Userland: arm64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      600    1300   Cortex-A72 / r0p3
      1        0        0      600    1300   Cortex-A72 / r0p3
      2        0        0      600    1300   Cortex-A72 / r0p3
      3        0        0      600    1300   Cortex-A72 / r0p3

7819 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: performance / 1250 MHz (conservative ondemand userspace powersave performance schedutil / 600 700 800 900 1000 1100 1200 1300)

Tuned governor settings:

    cpufreq-policy0: performance / 1250 MHz

Status of performance related policies found below /sys:

    /sys/module/pcie_aspm/parameters/policy: default [performance] powersave powersupersave

### Clockspeeds (idle vs. heated up):

Before at 35.5°C:

    cpu0-cpu-1 (Cortex-A72): OPP: 1300, ThreadX: 1250, Measured: 1248      (-4.0%)
    cpu0-cpu3 (Cortex-A72): OPP: 1300, ThreadX: 1250, Measured: 1248      (-4.0%)

After at 47.2°C:

    cpu0-cpu-1 (Cortex-A72): OPP: 1300, ThreadX: 1250, Measured: 1248      (-4.0%)
    cpu0-cpu3 (Cortex-A72): OPP: 1300, ThreadX: 1250, Measured: 1248      (-4.0%)

### Performance baseline

  * cpu0 (Cortex-A72): memcpy: 2782.3 MB/s, memchr: 4175.5 MB/s, memset: 3378.6 MB/s
  * cpu0 (Cortex-A72): memcpy: 2660.4 MB/s, memchr: 4175.4 MB/s, memset: 3379.7 MB/s
  * cpu0 (Cortex-A72) 16M latency: 159.3 160.9 160.0 160.9 158.6 166.1 172.7 216.3 
  * cpu0 (Cortex-A72) 16M latency: 159.0 160.1 159.7 159.9 159.7 164.5 172.4 205.5 
  * cpu0 (Cortex-A72) 128M latency: 181.0 180.5 183.0 181.8 187.6 184.9 200.5 228.9 
  * cpu0 (Cortex-A72) 128M latency: 179.4 180.7 178.4 184.2 194.3 186.5 200.7 228.4 
  * 7-zip MIPS (3 consecutive runs): 4494, 4513, 4503 (4500 avg), single-threaded: 1339
  * `aes-256-cbc      22861.24k    24400.00k    24970.07k    25119.74k    25165.82k    25165.82k (Cortex-A72)`
  * `aes-256-cbc      22888.61k    24409.62k    24981.08k    25120.77k    25165.82k    25165.82k (Cortex-A72)`

### PCIe and storage devices:

  * VIA VL805/806 xHCI USB 3.0: Speed 5GT/s, Width x1, driver in use: xhci_hcd, 
  * 58.9GB "Longsys USD00" UHS-I speed DDR50 SDXC card as /dev/mmcblk0: date 08/2024, manfid/oemid: 0x0000ad/0x4c53, hw/fw rev: 0x2/0x1

### Swap configuration:

  * /dev/zram0: 2G (15.7M used, zstd, 9.5M streams, 1.5M data, 2.6M compressed,  total)

### Software versions:

  * Debian GNU/Linux 13 (trixie)
  * Compiler: /usr/bin/gcc (Debian 14.2.0-19) 14.2.0 / aarch64-linux-gnu
  * OpenSSL 3.5.6, built on 7 Apr 2026 (Library: OpenSSL 3.5.6 7 Apr 2026)    
  * ThreadX: 288930ab4712b99596f32732664aaaeb881ef1e0 / May 21 2026 11:20:25 

### Kernel info:

  * `/proc/cmdline: coherent_pool=1M 8250.nr_uarts=1 snd_bcm2835.enable_headphones=0 cgroup_disable=memory numa_policy=interleave nvme.max_host_mem_size_mb=32 snd_bcm2835.enable_headphones=1 snd_bcm2835.enable_hdmi=1 snd_bcm2835.enable_hdmi=0  numa=fake=2 system_heap.max_order=0 iommu_dma_numa_policy=interleave smsc95xx.macaddr=DC:A6:32:D1:28:D4 vc_mem.mem_base=0x3ec00000 vc_mem.mem_size=0x40000000  console=ttyS0,115200 console=tty1 root=PARTUUID=f8c2f9d1-02 rootfstype=ext4 fsck.repair=yes rootwait cfg80211.ieee80211_regdom=US`
  * Vulnerability Spec store bypass:         Vulnerable
  * Vulnerability Spectre v1:                Mitigation; __user pointer sanitization
  * Vulnerability Spectre v2:                Vulnerable
  * Kernel 6.18.34+rpt-rpi-v8 / CONFIG_HZ=250

Results didn't seem to upload for me, though, so here it is above ^^