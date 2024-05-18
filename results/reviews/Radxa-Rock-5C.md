# Radxa ROCK 5C

Tested with sbc-bench v0.9.65 on Fri, 17 May 2024 04:16:47 +0000. Full info: [https://sprunge.us/5pv8oh](../5pv8oh.txt)

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
      Max Frequency:     2.304 GHz
      Cores:             2 cores
      Features:          NEON,SHA1,SHA2,AES,CRC32
    CPU 3:
      Microarchitecture: Cortex-A76
      Max Frequency:     2.352 GHz
      Cores:             2 cores
      Features:          NEON,SHA1,SHA2,AES,CRC32
    
The CPU features 3 clusters consisting of 2 different core types:

    Rockchip RK3588S2 (35881000 / 35 88 12 fe 53 41  32 58 4b 5a 00 00 00 00), Kernel: aarch64, Userland: arm64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      408    1800   Cortex-A55 / r2p0
      1        0        0      408    1800   Cortex-A55 / r2p0
      2        0        0      408    1800   Cortex-A55 / r2p0
      3        0        0      408    1800   Cortex-A55 / r2p0
      4        0        4      408    2304   Cortex-A76 / r4p0
      5        0        4      408    2304   Cortex-A76 / r4p0
      6        0        6      408    2352   Cortex-A76 / r4p0
      7        0        6      408    2352   Cortex-A76 / r4p0

3921 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: performance / 1800 MHz (interactive ondemand performance schedutil / 408 600 816 1008 1200 1416 1608 1800)
    cpufreq-policy4: performance / 2304 MHz (interactive ondemand performance schedutil / 408 600 816 1008 1200 1416 1608 1800 2016 2208 2304)
    cpufreq-policy6: performance / 2352 MHz (interactive ondemand performance schedutil / 408 600 816 1008 1200 1416 1608 1800 2016 2208 2352)
    dmc: dmc_ondemand / 528 MHz (powersave performance rknpu_ondemand dmc_ondemand simple_ondemand / 528 1068 1560 2112)
    fb000000.gpu: simple_ondemand / 300 MHz (powersave performance rknpu_ondemand dmc_ondemand simple_ondemand / 300 400 500 600 700 800 900 1000)
    fdab0000.npu: rknpu_ondemand / 1000 MHz (powersave performance rknpu_ondemand dmc_ondemand simple_ondemand / 300 400 500 600 700 800 900 1000)

Tuned governor settings:

    cpufreq-policy0: performance / 1800 MHz
    cpufreq-policy4: performance / 2304 MHz
    cpufreq-policy6: performance / 2352 MHz
    dmc: performance / 2112 MHz
    fb000000.gpu: performance / 1000 MHz
    fdab0000.npu: performance / 1000 MHz

Status of performance related policies found below /sys:

    /sys/devices/platform/fb000000.gpu/power_policy: [coarse_demand] always_on
    /sys/module/pcie_aspm/parameters/policy: default [performance] powersave powersupersave

### Clockspeeds (idle vs. heated up):

Before at 35.2°C:

    cpu0-cpu3 (Cortex-A55): OPP: 1800, Measured: 1793 
    cpu4-cpu5 (Cortex-A76): OPP: 2304, Measured: 2273      (-1.3%)
    cpu6-cpu7 (Cortex-A76): OPP: 2352, Measured: 2303      (-2.1%)

After at 76.7°C:

    cpu0-cpu3 (Cortex-A55): OPP: 1800, Measured: 1777      (-1.3%)
    cpu4-cpu5 (Cortex-A76): OPP: 2304, Measured: 2251      (-2.3%)
    cpu6-cpu7 (Cortex-A76): OPP: 2352, Measured: 2283      (-2.9%)

### Performance baseline

  * cpu0 (Cortex-A55): memcpy: 6754.2 MB/s, memchr: 2770.6 MB/s, memset: 21752.1 MB/s
  * cpu4 (Cortex-A76): memcpy: 12281.7 MB/s, memchr: 17168.7 MB/s, memset: 29756.9 MB/s
  * cpu6 (Cortex-A76): memcpy: 12279.1 MB/s, memchr: 17203.8 MB/s, memset: 29750.5 MB/s
  * cpu0 (Cortex-A55) 16M latency: 115.9 116.3 114.2 116.2 112.6 117.2 177.2 320.8 
  * cpu4 (Cortex-A76) 16M latency: 115.2 107.3 114.6 106.6 114.7 108.8 109.5 103.2 
  * cpu6 (Cortex-A76) 16M latency: 114.8 116.8 116.8 106.7 114.9 108.7 105.6 102.8 
  * cpu0 (Cortex-A55) 128M latency: 136.7 137.9 136.6 137.8 135.7 137.9 194.4 337.8 
  * cpu4 (Cortex-A76) 128M latency: 129.9 130.9 129.4 130.8 129.3 129.7 130.6 134.4 
  * cpu6 (Cortex-A76) 128M latency: 128.8 129.8 128.6 129.8 128.6 129.0 129.9 134.6 
  * 7-zip MIPS (3 consecutive runs): 16298, 16375, 16515 (16400 avg), single-threaded: 3174
  * `aes-256-cbc     142978.49k   379968.79k   645755.22k   783114.58k   835431.08k   839379.63k (Cortex-A55)`
  * `aes-256-cbc     522422.87k   959406.06k  1191036.76k  1262408.70k  1289347.07k  1292096.85k (Cortex-A76)`
  * `aes-256-cbc     563644.82k  1004550.51k  1217982.12k  1280535.89k  1306094.25k  1308786.69k (Cortex-A76)`

### Storage devices:

  * 477.5GB "Samsung FF8S9" UHS SDR104 SDXC card as /dev/mmcblk1: date 06/2023, manfid/oemid: 0x00001b/0x534d, hw/fw rev: 0x3/0x0

### Swap configuration:

  * /dev/zram0: 1.9G (90.0M used, zstd, 8 streams, 89.1M data, 17.4M compressed, 18.5M total)

### Software versions:

  * Debian GNU/Linux 12 (bookworm)
  * Build scripts: Radxa rbuild , ,  ,   
  * Compiler: /usr/bin/gcc (Debian 12.2.0-14) 12.2.0 / aarch64-linux-gnu
  * OpenSSL 3.0.11, built on 19 Sep 2023 (Library: OpenSSL 3.0.11 19 Sep 2023)    

### Kernel info:

  * `/proc/cmdline: root=UUID=7fda52bb-aaca-4e19-84ff-24c167c7b4a1 console=ttyFIQ0,1500000n8 quiet splash loglevel=4 rw earlycon consoleblank=0 console=tty1 coherent_pool=2M irqchip.gicv3_pseudo_nmi=0 cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory swapaccount=1 androidboot.fwver=ddr-v1.16-9fffbe1e78,bl31-v1.45,uboot-17.09-26-5-04/26/2024`
  * Vulnerability Spec store bypass: Mitigation; Speculative Store Bypass disabled via prctl
  * Vulnerability Spectre v1:        Mitigation; __user pointer sanitization
  * Vulnerability Spectre v2:        Mitigation; CSV2, BHB
  * Kernel 6.1.43-7-rk2312 / CONFIG_HZ=300
