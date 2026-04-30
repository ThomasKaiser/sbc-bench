# Radxa Cubie A7S

Tested with sbc-bench v0.9.72 on Thu, 30 Apr 2026 12:22:41 +0200. Full info: [rca7s.txt](../rca7s.txt)

### General information:

The CPU features 2 clusters of different core types:

    Allwinner A733, Kernel: aarch64, Userland: arm64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      416    1794   Cortex-A55 / r2p0
      1        0        0      416    1794   Cortex-A55 / r2p0
      2        0        0      416    1794   Cortex-A55 / r2p0
      3        0        0      416    1794   Cortex-A55 / r2p0
      4        0        0      416    1794   Cortex-A55 / r2p0
      5        0        0      416    1794   Cortex-A55 / r2p0
      6        0        6      416    2002   Cortex-A76 / r4p1
      7        0        6      416    2002   Cortex-A76 / r4p1

5914 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    a020000.dmcfreq: performance / 2400 MHz (powersave sunxi_actmon userspace performance simple_ondemand / 400 800 1200 2400)
    cpufreq-policy0: ondemand / 1014 MHz (ondemand performance schedutil / 416 780 1014 1196 1404 1508 1612 1716 1794)
    cpufreq-policy6: ondemand / 780 MHz (ondemand performance schedutil / 416 780 1014 1196 1404 1508 1612 1716 1794 1898 1950 2002)
    3600000.npu: performance / 1008 MHz (powersave sunxi_actmon userspace performance simple_ondemand / 492 852 1008)

Tuned governor settings:

    a020000.dmcfreq: performance / 2400 MHz
    cpufreq-policy0: performance / 1794 MHz
    cpufreq-policy6: performance / 2002 MHz
    3600000.npu: performance / 1008 MHz

### Clockspeeds (idle vs. heated up):

Before at 37.6°C:

    cpu0-cpu5 (Cortex-A55): OPP: 1794, Measured: 1792 
    cpu6-cpu7 (Cortex-A76): OPP: 2002, Measured: 2000 

After at 63.5°C:

    cpu0-cpu5 (Cortex-A55): OPP: 1794, Measured: 1792 
    cpu6-cpu7 (Cortex-A76): OPP: 2002, Measured: 2001 

### Performance baseline

  * cpu0 (Cortex-A55): memcpy: 4167.2 MB/s, memchr: 2684.9 MB/s, memset: 8484.6 MB/s
  * cpu6 (Cortex-A76): memcpy: 6897.6 MB/s, memchr: 11187.5 MB/s, memset: 8500.2 MB/s
  * cpu0 (Cortex-A55) 16M latency: 156.5 159.4 155.5 157.9 157.9 158.4 220.3 405.2 
  * cpu6 (Cortex-A76) 16M latency: 164.3 158.7 162.6 161.9 162.4 163.1 167.1 168.1 
  * cpu0 (Cortex-A55) 128M latency: 182.4 182.3 181.4 182.5 180.4 181.5 235.0 421.8 
  * cpu6 (Cortex-A76) 128M latency: 184.1 183.5 182.7 182.3 184.1 184.6 189.1 192.7 
  * 7-zip MIPS (3 consecutive runs): 11257, 11284, 11302 (11280 avg), single-threaded: 2478
  * `aes-256-cbc     137625.58k   369481.88k   635810.05k   780274.69k   834139.48k   838118.06k (Cortex-A55)`
  * `aes-256-cbc     466789.29k   844659.22k  1053297.41k  1113431.38k  1138854.57k  1141112.83k (Cortex-A76)`

### Storage devices:

  * 58.6GB "SDABC" UHS SDR104 SDXC card as /dev/mmcblk0: date 12/2023, manfid/oemid: 0x00006f/0x0303, hw/fw rev: 0x1/0x0

### Swap configuration:

  * /dev/zram0: 2.9G (0K used, lzo-rle, 8 streams, 4K data, 74B compressed, 12K total)

### Software versions:

  * Debian 13 (trixie) tampered by Armbian 26.2.1 trixie
  * Build scripts: https://github.com/NickAlilovic/build.git, 26.02.0-trunk, radxa cubie a7s, sun60iw2, sun60iw2
  * Compiler: /usr/bin/gcc (Debian 14.2.0-19) 14.2.0 / aarch64-linux-gnu
  * OpenSSL 3.5.5, built on 27 Jan 2026 (Library: OpenSSL 3.5.5 27 Jan 2026)    

### Kernel info:

  * `/proc/cmdline: root=UUID=f3930d98-b5ea-4479-bb1c-e39aa6d09c75 rootwait rootfstype=ext4 splash plymouth.ignore-serial-consoles console=ttyAS0,115200 console=tty1 consoleblank=0 loglevel=7 ubootpart=efc2431b-64bf-4d5d-a260-3f53def9a861 usb-storage.quirks=0x2537:0x1066:u,0x2537:0x1068:u clk_ignore_unused mac_addr= coherent_pool=2M irqchip.gicv3_pseudo_nmi=0 kasan=off no_console_suspend fsck.fix=yes fsck.repair=yes net.ifnames=0  cgroup_enable=cpuset cgroup_memory=1 swapaccount=1 cgroup_enable=memory`
  * Vulnerability Spec store bypass:         Mitigation; Speculative Store Bypass disabled via prctl
  * Vulnerability Spectre v1:                Mitigation; __user pointer sanitization
  * Vulnerability Spectre v2:                Mitigation; CSV2, BHB
  * Kernel 6.6.98-vendor-sun60iw2 / CONFIG_HZ=250
