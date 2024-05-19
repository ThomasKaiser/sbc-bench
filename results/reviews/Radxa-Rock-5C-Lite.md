# Radxa ROCK 5C

Tested with sbc-bench v0.9.66 on Sun, 19 May 2024 18:48:55 +0000. Full info: [https://sprunge.us/c9ZIGh](../c9ZIGh.txt)

### General information:

The CPU features 2 clusters of different core types:

    Rockchip RK3582 (35821000 / 35 82 12 fe 21 41  32 47 41 31 00 00 00 00), Kernel: aarch64, Userland: arm64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      408    1800   Cortex-A55 / r2p0
      1        0        0      408    1800   Cortex-A55 / r2p0
      2        0        0      408    1800   Cortex-A55 / r2p0
      3        0        0      408    1800   Cortex-A55 / r2p0
      4        0        4      408    2256   Cortex-A76 / r4p0
      5        0        4      408    2256   Cortex-A76 / r4p0

3921 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: performance / 1800 MHz (powersave interactive ondemand performance schedutil / 408 600 816 1008 1200 1416 1608 1800)
    cpufreq-policy4: performance / 2256 MHz (powersave interactive ondemand performance schedutil / 408 600 816 1008 1200 1416 1608 1800 2016 2208 2256)
    dmc: performance / 2112 MHz (powersave performance rknpu_ondemand dmc_ondemand simple_ondemand / 528 1068 1560 2112)
    fdab0000.npu: performance / 1000 MHz (powersave performance rknpu_ondemand dmc_ondemand simple_ondemand / 300 400 500 600 700 800 900 1000)

Tuned governor settings:

    cpufreq-policy0: performance / 1800 MHz
    cpufreq-policy4: performance / 2256 MHz
    dmc: performance / 2112 MHz
    fdab0000.npu: performance / 1000 MHz

Status of performance related policies found below /sys:

    /sys/module/pcie_aspm/parameters/policy: default [performance] powersave powersupersave

### Clockspeeds (idle vs. heated up):

Before at 50.8°C:

    cpu0-cpu3 (Cortex-A55): OPP: 1800, Measured: 1784 
    cpu4-cpu5 (Cortex-A76): OPP: 2256, Measured: 2250 

After at 59.2°C:

    cpu0-cpu3 (Cortex-A55): OPP: 1800, Measured: 1784 
    cpu4-cpu5 (Cortex-A76): OPP: 2256, Measured: 2251 

### Performance baseline

  * cpu0 (Cortex-A55): memcpy: 6716.8 MB/s, memchr: 2752.4 MB/s, memset: 21628.2 MB/s
  * cpu4 (Cortex-A76): memcpy: 12405.7 MB/s, memchr: 17499.1 MB/s, memset: 29621.3 MB/s
  * cpu0 (Cortex-A55) 16M latency: 112.4 113.4 110.3 113.4 109.6 115.0 175.3 306.8 
  * cpu4 (Cortex-A76) 16M latency: 112.7 104.3 111.4 103.0 112.5 103.5 106.4 102.6 
  * cpu0 (Cortex-A55) 128M latency: 136.3 136.5 136.2 136.5 135.0 137.1 194.1 333.4 
  * cpu4 (Cortex-A76) 128M latency: 128.1 129.0 127.8 128.9 128.1 126.8 127.0 128.8 
  * 7-zip MIPS (3 consecutive runs): 11154, 11125, 11189 (11160 avg), single-threaded: 3094
  * `aes-256-cbc     142072.03k   378142.63k   640619.86k   778788.86k   830365.70k   834327.89k (Cortex-A55)`
  * `aes-256-cbc     551001.94k   982201.79k  1191055.27k  1252113.07k  1276881.58k  1279426.56k (Cortex-A76)`

### Storage devices:

  * 29.7GB "SanDisk SE32G" UHS SDR104 SD card as /dev/mmcblk1: date 10/2017, manfid/oemid: 0x000003/0x5344, hw/fw rev: 0x8/0x0

### Swap configuration:

  * /dev/zram0: 1.9G (0K used, zstd, 6 streams, 4K data, 59B compressed, 4K total)

### Software versions:

  * Debian GNU/Linux 12 (bookworm)
  * Build scripts: Radxa rbuild: build_date: '2024-05-16T09:20:28+00:00', edition: kde, product: rock-5c, suite: bookworm
  * Compiler: /usr/bin/gcc (Debian 12.2.0-14) 12.2.0 / aarch64-linux-gnu
  * OpenSSL 3.0.11, built on 19 Sep 2023 (Library: OpenSSL 3.0.11 19 Sep 2023)    
  * Boot environment: ddr-v1.16-9fffbe1e78, bl31-v1.45, uboot-17.09-26-5-04/26/2024

### Kernel info:

  * `/proc/cmdline: root=UUID=7fda52bb-aaca-4e19-84ff-24c167c7b4a1 console=ttyFIQ0,1500000n8 quiet splash loglevel=4 rw earlycon consoleblank=0 console=tty1 coherent_pool=2M irqchip.gicv3_pseudo_nmi=0 cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory swapaccount=1 androidboot.fwver=ddr-v1.16-9fffbe1e78,bl31-v1.45,uboot-17.09-26-5-04/26/2024`
  * Vulnerability Spec store bypass: Mitigation; Speculative Store Bypass disabled via prctl
  * Vulnerability Spectre v1:        Mitigation; __user pointer sanitization
  * Vulnerability Spectre v2:        Mitigation; CSV2, BHB
  * Kernel 6.1.43-7-rk2312 / CONFIG_HZ=300