# Radxa ROCK 5 ITX

Tested with sbc-bench v0.9.65 on Tue, 23 Apr 2024 14:55:04 +0000. Full info: [https://sprunge.us/Mc2cjH](http://sprunge.us/Mc2cjH)

### General information:

    Information courtesy of cpufetch:
    
    SoC:                 Rockchip RK3588
    Technology:          8nm
    CPU 1:
      Microarchitecture: Cortex-A55
      Max Frequency:     1.800 GHz
      Cores:             4 cores
      Features:          NEON,SHA1,SHA2,AES,CRC32
    CPU 2:
      Microarchitecture: Cortex-A76
      Max Frequency:     2.400 GHz
      Cores:             4 cores
      Features:          NEON,SHA1,SHA2,AES,CRC32
    
The CPU features 3 clusters consisting of 2 different core types:

    Rockchip RK3588 (35881000 / 35 88 12 fe 21 41  32 4e 48 46 00 00 00 00), Kernel: aarch64, Userland: arm64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      408    1800   Cortex-A55 / r2p0
      1        0        0      408    1800   Cortex-A55 / r2p0
      2        0        0      408    1800   Cortex-A55 / r2p0
      3        0        0      408    1800   Cortex-A55 / r2p0
      4        1        4      408    2400   Cortex-A76 / r4p0
      5        1        4      408    2400   Cortex-A76 / r4p0
      6        2        6      408    2400   Cortex-A76 / r4p0
      7        2        6      408    2400   Cortex-A76 / r4p0

7945 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: ondemand / 1800 MHz (ondemand performance schedutil / 408 600 816 1008 1200 1416 1608 1800)
    cpufreq-policy4: ondemand / 2400 MHz (ondemand performance schedutil / 408 600 816 1008 1200 1416 1608 1800 2016 2208 2400)
    cpufreq-policy6: ondemand / 2400 MHz (ondemand performance schedutil / 408 600 816 1008 1200 1416 1608 1800 2016 2208 2400)
    dmc: dmc_ondemand / 534 MHz (powersave performance rknpu_ondemand dmc_ondemand simple_ondemand / 534 1320 2400)
    fdab0000.npu: rknpu_ondemand / 1000 MHz (powersave performance rknpu_ondemand dmc_ondemand simple_ondemand / 300 400 500 600 700 800 900 1000)

Tuned governor settings:

    cpufreq-policy0: performance / 1800 MHz
    cpufreq-policy4: performance / 2400 MHz
    cpufreq-policy6: performance / 2400 MHz
    dmc: performance / 2400 MHz
    fdab0000.npu: performance / 1000 MHz

Status of performance related policies found below /sys:

    /sys/module/pcie_aspm/parameters/policy: default [performance] powersave powersupersave

### Clockspeeds (idle vs. heated up):

Before at 36.1°C:

    cpu0-cpu3 (Cortex-A55): OPP: 1800, Measured: 1806 
    cpu4-cpu5 (Cortex-A76): OPP: 2400, Measured: 2302      (-4.1%)
    cpu6-cpu7 (Cortex-A76): OPP: 2400, Measured: 2315      (-3.5%)

After at 76.7°C:

    cpu0-cpu3 (Cortex-A55): OPP: 1800, Measured: 1777      (-1.3%)
    cpu4-cpu5 (Cortex-A76): OPP: 2400, Measured: 2265      (-5.6%)
    cpu6-cpu7 (Cortex-A76): OPP: 2400, Measured: 2281      (-5.0%)

### Performance baseline

  * cpu0 (Cortex-A55): memcpy: 6599.4 MB/s, memchr: 3261.2 MB/s, memset: 21901.1 MB/s
  * cpu4 (Cortex-A76): memcpy: 12294.5 MB/s, memchr: 17607.4 MB/s, memset: 28276.4 MB/s
  * cpu6 (Cortex-A76): memcpy: 12344.3 MB/s, memchr: 17554.3 MB/s, memset: 28139.8 MB/s
  * cpu0 (Cortex-A55) 16M latency: 136.4 137.9 132.8 137.6 132.7 138.8 215.6 382.7 
  * cpu4 (Cortex-A76) 16M latency: 136.5 125.4 135.2 124.3 134.8 126.0 131.3 132.4 
  * cpu6 (Cortex-A76) 16M latency: 135.3 123.7 133.7 123.4 132.9 123.3 125.5 126.6 
  * cpu0 (Cortex-A55) 128M latency: 160.3 160.7 159.8 160.4 159.4 160.4 233.9 400.2 
  * cpu4 (Cortex-A76) 128M latency: 155.0 152.7 154.7 152.6 154.6 151.9 151.6 152.2 
  * cpu6 (Cortex-A76) 128M latency: 153.9 151.8 153.6 151.4 153.2 150.2 150.2 152.4 
  * 7-zip MIPS (3 consecutive runs): 15753, 15760, 15714 (15740 avg), single-threaded: 3010
  * `aes-256-cbc     149926.11k   390616.36k   654121.98k   788048.21k   838440.28k   842377.90k (Cortex-A55)`
  * `aes-256-cbc     583822.63k  1010174.14k  1218457.60k  1278378.33k  1303352.66k  1305914.03k (Cortex-A76)`
  * `aes-256-cbc     587884.82k  1016750.59k  1225344.43k  1285991.42k  1311211.52k  1313931.26k (Cortex-A76)`

### PCIe and storage devices:

  * ASMedia ASM1164 Serial ATA AHCI: Speed 8GT/s (ok), Width x2 (ok), driver in use: ahci, ASPM Disabled
  * Realtek RTL8125 2.5GbE: Speed 5GT/s (ok), Width x1 (ok), driver in use: r8125, ASPM Disabled
  * Realtek RTL8125 2.5GbE: Speed 5GT/s (ok), Width x1 (ok), driver in use: r8125, ASPM Disabled
  * 238.5GB "KXG50ZNV256G NVMe TOSHIBA 256GB" SSD as /dev/nvme0: Speed 8GT/s (ok), Width x2 (downgraded), 13% worn out, drive temp: 44°C
  * 111.8GB "Samsung SSD 750 EVO 120GB" SSD as /dev/sda: SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s), 3% worn out, drive temp: 25°C
  * 111.8GB "Samsung SSD 840 EVO 120GB" SSD as /dev/sdb: SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s), 3% worn out, drive temp: 24°C
  * 119.2GB "SAMSUNG MZ7TE128HMGR-00004" SSD as /dev/sdc: SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s), 3% worn out, drive temp: 25°C
  * 29.1GB "Samsung BJTD4R" HS400 Enhanced strobe eMMC 5.1 card as /dev/mmcblk0: date 09/2023, manfid/oemid: 0x000015/0x0100, hw/fw rev: 0x0/0x0300000000000000
  * 238.8GB "Samsung EE4S5" UHS SDR104 SDXC card as /dev/mmcblk1: date 05/2023, manfid/oemid: 0x00001b/0x534d, hw/fw rev: 0x3/0x0
  * 16MB SPI NOR flash, drivers in use: spi-nor/rockchip-sfc

### Swap configuration:

  * /dev/zram0: 3.9G (0K used, zstd, 8 streams, 4K data, 62B compressed, 4K total)

### Software versions:

  * Debian GNU/Linux 11 (bullseye)
  * Build scripts: Radxa rbuild bfa5c44974e4024570b647979590dac5d39f1e73, --timestamp=b1 --compress --native-build --shrink rock-5-itx bullseye cli, u-boot-rknext 2017.09-24-e919685, 17 Apr 2024
  * Compiler: /usr/bin/gcc (Debian 10.2.1-6) 10.2.1 20210110 / aarch64-linux-gnu
  * OpenSSL 1.1.1w, built on 11 Sep 2023          

### Kernel info:

  * `/proc/cmdline: root=UUID=2c8ef374-87a4-4f7e-8491-6a6e4c1308ad console=ttyFIQ0,1500000n8 quiet splash loglevel=4 rw earlycon consoleblank=0 console=tty1 coherent_pool=2M irqchip.gicv3_pseudo_nmi=0 cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory pcie_aspm=force pcie_aspm.policy=powersave swapaccount=1 androidboot.fwver=ddr-v1.16-9fffbe1e78,bl31-v1.45,uboot-17.09-24-e-04/16/2024`
  * Vulnerability Spec store bypass: Mitigation; Speculative Store Bypass disabled via prctl
  * Vulnerability Spectre v1:        Mitigation; __user pointer sanitization
  * Vulnerability Spectre v2:        Mitigation; CSV2, BHB
  * Kernel 5.10.110-33-rockchip / CONFIG_HZ=300

Kernel 5.10.110 is not latest 5.10.215 LTS that was released on 2024-04-13.

See https://endoflife.date/linux for details. It is somewhat likely that
a lot of exploitable vulnerabilities exist for this kernel as well as many
unfixed bugs.

But this version string doesn't matter since this is not an official LTS Linux
from kernel.org. This device runs a Rockchip vendor/BSP kernel.

This kernel is based on a mixture of Android GKI and other sources. Also some
community attempts to do version string cosmetics might have happened, see
https://tinyurl.com/2p8fuubd for example. To examine how far away this 5.10.110
is from an official LTS of same version someone would have to reapply Rockchip's
thousands of patches to a clean 5.10.110 LTS.