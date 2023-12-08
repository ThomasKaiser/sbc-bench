# Helios64

Tested with sbc-bench v0.9.50 on Tue, 14 Nov 2023 14:32:09 +0100. Full info: [http://ix.io/4LtI](../4LtI.txt)

### General information:

The CPU features 2 clusters of different core types:

    Rockchip RK3399, Kernel: aarch64, Userland: arm64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      408    1416   Cortex-A53 / r0p4
      1        0        0      408    1416   Cortex-A53 / r0p4
      2        0        0      408    1416   Cortex-A53 / r0p4
      3        0        0      408    1416   Cortex-A53 / r0p4
      4        1        4      408    1800   Cortex-A72 / r0p2
      5        1        4      408    1800   Cortex-A72 / r0p2

3863 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: performance / 1416 MHz (conservative ondemand userspace powersave performance schedutil / 408 600 816 1008 1200 1416)
    cpufreq-policy4: performance / 1800 MHz (conservative ondemand userspace powersave performance schedutil / 408 600 816 1008 1200 1416 1608 1800)
    ff9a0000.gpu: simple_ondemand / 200 MHz (powersave performance simple_ondemand / 200 297 400 500 600 800)

Tuned governor settings:

    cpufreq-policy0: performance / 1416 MHz
    cpufreq-policy4: performance / 1800 MHz
    ff9a0000.gpu: performance / 800 MHz

Status of performance related policies found below /sys:

    /sys/module/pcie_aspm/parameters/policy: default [performance] powersave powersupersave

### Clockspeeds (idle vs. heated up):

Before at 46.2°C:

    cpu0-cpu3 (Cortex-A53): OPP: 1416, Measured: 1412 
    cpu4-cpu5 (Cortex-A72): OPP: 1800, Measured: 1798 

After at 80.0°C (throttled):

    cpu0-cpu3 (Cortex-A53): OPP: 1416, Measured: 1413 
    cpu4-cpu5 (Cortex-A72): OPP: 1800, Measured: 1798 

### Performance baseline

  * cpu0 (Cortex-A53): memcpy: 1682.3 MB/s, memchr: 1712.1 MB/s, memset: 8127.7 MB/s
  * cpu4 (Cortex-A72): memcpy: 2149.0 MB/s, memchr: 4254.1 MB/s, memset: 5018.3 MB/s
  * cpu0 (Cortex-A53) 16M latency: 194.5 197.5 194.1 197.4 194.1 197.3 244.4 466.4 
  * cpu4 (Cortex-A72) 16M latency: 202.6 204.4 203.9 204.5 203.5 207.2 211.4 248.1 
  * cpu0 (Cortex-A53) 128M latency: 199.6 201.5 198.1 201.2 198.0 202.4 244.1 462.5 
  * cpu4 (Cortex-A72) 128M latency: 215.1 221.8 210.7 217.3 218.5 230.7 238.7 259.6 
  * 7-zip MIPS (3 consecutive runs): 5901, 5794, 6340 (6010 avg), single-threaded: 1473
  * `aes-256-cbc      95983.33k   268404.95k   473590.10k   604001.96k   656097.28k   654731.95k (Cortex-A53)`
  * `aes-256-cbc     278810.82k   617622.85k   881163.78k   975858.01k  1020032.34k  1017331.71k (Cortex-A72)`

### PCIe and storage devices:

  * JMicron JMB58x AHCI SATA controller: Speed 5GT/s (downgraded), Width x2, driver in use: ahci
  * 3.6TB "Samsung SSD 860 EVO 4TB" SSD as /dev/sda: SATA 3.2, 6.0 Gb/s (current: 6.0 Gb/s), 0% worn out, drive temp: 23°C
  * 14.6GB "Samsung AJTD4R" HS400 Enhanced strobe eMMC 5.1 card as /dev/mmcblk2: date 01/2020, manfid/oemid: 0x000015/0x0100, hw/fw rev: 0x0/0x0600000000000000

### Swap configuration:

  * /dev/zram0: 1.9G (479.8M used, lzo-rle, 6 streams, 479M data, 92M compressed, 115.5M total)

### Software versions:

  * Armbian 23.08.0-trunk bookworm arm64
  * Build scripts: https://github.com/armbian/build, 23.08.0-trunk, Helios64, rk3399, rockchip64
  * Compiler: /usr/bin/gcc (Debian 12.2.0-14) 12.2.0 / aarch64-linux-gnu
  * OpenSSL 3.0.11, built on 19 Sep 2023 (Library: OpenSSL 3.0.11 19 Sep 2023)    

### Kernel info:

  * `/proc/cmdline: root=UUID=8e6114d6-1337-4a2f-be19-86d90da5bcb4 rootwait rootfstype=ext4 splash=verbose console=ttyS2,1500000 console=tty1 consoleblank=0 loglevel=1 ubootpart=741db17e-01 usb-storage.quirks=0x2537:0x1066:u,0x2537:0x1068:u   cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory swapaccount=1`
  * Vulnerability Spec store bypass: Vulnerable
  * Vulnerability Spectre v1:        Mitigation; __user pointer sanitization
  * Vulnerability Spectre v2:        Vulnerable
  * Kernel 5.10.43-rockchip64 / CONFIG_HZ=250

Kernel 5.10.43 is not latest 5.10.200 LTS that was released on 2023-11-08.

See https://endoflife.date/linux for details. It is somewhat likely that
a lot of exploitable vulnerabilities exist for this kernel as well as many
unfixed bugs.