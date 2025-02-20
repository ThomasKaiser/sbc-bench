# Hardkernel ODROID HC2

Tested with sbc-bench v0.9.70 on Thu, 20 Feb 2025 09:32:57 +0100. Full info: [https://0x0.st/8ctH.bin](.../8ctH.txt)

### General information:

    Information courtesy of cpufetch:
    
    SoC:                 Samsung Exynos (Flattened Device Tree)
    CPU 1:
      Microarchitecture: Cortex-A7
      Max Frequency:     1.400 GHz
      Cores:             4 cores
      Features:          NEON
    CPU 2:
      Microarchitecture: Cortex-A15
      Max Frequency:     2.000 GHz
      Cores:             4 cores
      Features:          NEON
    
The CPU features 2 clusters of different core types:

    Samsung Exynos EXYNOS5800 rev 1, Exynos 5422, Kernel: armv7l, Userland: armhf
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        1        0      200    1400   Cortex-A7 / r0p3
      1        1        0      200    1400   Cortex-A7 / r0p3
      2        1        0      200    1400   Cortex-A7 / r0p3
      3        1        0      200    1400   Cortex-A7 / r0p3
      4        0        4      200    2000   Cortex-A15 / r2p3
      5        0        4      200    2000   Cortex-A15 / r2p3
      6        0        4      200    2000   Cortex-A15 / r2p3
      7        0        4      200    2000   Cortex-A15 / r2p3

1987 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    bus-wcore: simple_ondemand / 89 MHz (userspace powersave performance simple_ondemand / 89 133 177 266 532)
    cpufreq-policy0: ondemand / 1400 MHz (powersave userspace conservative ondemand performance schedutil / 200 300 400 500 600 700 800 900 1000 1100 1200 1300 1400)
    cpufreq-policy4: ondemand / 2000 MHz (powersave userspace conservative ondemand performance schedutil / 200 300 400 500 600 700 800 900 1000 1100 1200 1300 1400 1500 1600 1700 1800 1900 2000)
    10c20000.memory-controller: simple_ondemand / 543 MHz (userspace powersave performance simple_ondemand / 165 206 275 413 543 633 728 825)

Tuned governor settings:

    bus-wcore: performance / 532 MHz
    cpufreq-policy0: performance / 1400 MHz
    cpufreq-policy4: performance / 2000 MHz
    10c20000.memory-controller: performance / 825 MHz

### Clockspeeds (idle vs. heated up):

Before at 15.0°C:

    cpu0-cpu3 (Cortex-A7): OPP: 1400, Measured: 1396 
    cpu4-cpu7 (Cortex-A15): OPP: 2000, Measured: 1995 

After at 52.0°C (throttled):

    cpu0-cpu3 (Cortex-A7): OPP: 1400, Measured: 1396 
    cpu4-cpu7 (Cortex-A15): OPP: 2000, Measured: 1995 

### Performance baseline

  * cpu0 (Cortex-A7): memcpy: 325.2 MB/s, memchr: 397.8 MB/s, memset: 797.9 MB/s
  * cpu4 (Cortex-A15): memcpy: 2271.2 MB/s, memchr: 3001.4 MB/s, memset: 4815.9 MB/s
  * cpu0 (Cortex-A7) 16M latency: 164.6 166.9 163.8 168.2 163.7 168.0 305.8 576.4 
  * cpu4 (Cortex-A15) 16M latency: 174.9 175.7 175.0 175.7 174.9 174.2 175.2 202.0 
  * cpu0 (Cortex-A7) 128M latency: 173.5 180.8 173.0 178.6 172.6 177.1 308.1 574.7 
  * cpu4 (Cortex-A15) 128M latency: 188.5 189.9 188.6 190.1 188.3 185.5 189.4 206.7 
  * 7-zip MIPS (3 consecutive runs): 8792, 8734, 8663 (8730 avg), single-threaded: 1706
  * `aes-256-cbc      18328.72k    24574.98k    26494.81k    27027.11k    27164.67k    27131.90k (Cortex-A7)`
  * `aes-256-cbc      56995.94k    66654.31k    70749.70k    71856.13k    71903.91k    71685.46k (Cortex-A15)`

### Storage devices:

  * "JMicron JMS578 SATA 6Gb/s bridge" as /dev/sda: USB, Driver=uas, 5Gbps (capable of 12Mbps, 480Mbps, 5Gbps)
  * 29.7GB "SanDisk SP32G" UHS SDR104 SD card as /dev/mmcblk2: date 03/2020, manfid/oemid: 0x000003/0x5344, hw/fw rev: 0x8/0x0

### Software versions:

  * Debian 12 (bookworm) tampered by Armbian 25.2.1 bookworm
  * Build scripts: https://github.com/armbian/build, 25.2.1, Odroid XU4, odroidxu4, odroidxu4
  * Compiler: /usr/bin/gcc (Debian 12.2.0-14) 12.2.0 / arm-linux-gnueabihf
  * OpenSSL 3.0.15, built on 3 Sep 2024 (Library: OpenSSL 3.0.15 3 Sep 2024)    

### Kernel info:

  * `/proc/cmdline: splash=verbose console=ttySAC2,115200n8 console=tty1 consoleblank=0 loglevel=1 root=UUID=9ad0337c-4fe8-4162-9918-517aa758d00c rootfstype=ext4 rootwait rw  smsc95xx.macaddr=00:1e:06:61:7a:55 governor=performance hdmi_tx_amp_lvl=31 hdmi_tx_lvl_ch0=3 hdmi_tx_lvl_ch1=3 hdmi_tx_lvl_ch2=3 hdmi_tx_emp_lvl=6 hdmi_clk_amp_lvl=31 hdmi_tx_res=0 HPD=true vout=hdmi usb-storage.quirks= `
  * Vulnerability Spectre v1:             Mitigation; __user pointer sanitization
  * Vulnerability Spectre v2:             Vulnerable: Unprivileged eBPF enabled
  * Kernel 6.6.75-current-odroidxu4 / CONFIG_HZ=100