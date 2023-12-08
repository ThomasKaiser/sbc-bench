# Raspberry Pi 5 Model B Rev 1.0

Tested with sbc-bench v0.9.48 on Sat, 21 Oct 2023 16:31:49 +0100. Full info: [http://ix.io/4JAv](../4JAv.txt) and [Jeff Geerling's review thread](https://github.com/geerlingguy/sbc-reviews/issues/21).

### General information:

    BCM2712, Kernel: aarch64, Userland: arm64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0     1000    2400   Cortex-A76 / r4p1
      1        0        0     1000    2400   Cortex-A76 / r4p1
      2        0        0     1000    2400   Cortex-A76 / r4p1
      3        0        0     1000    2400   Cortex-A76 / r4p1

8049 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: ondemand / 2400 MHz (conservative ondemand userspace powersave performance schedutil / 1000 1100 1200 1300 1400 1500 1600 1700 1800 1900 2000 2100 2200 2300 2400)

Tuned governor settings:

    cpufreq-policy0: performance / 2400 MHz

Status of performance related policies found below /sys:

    /sys/module/pcie_aspm/parameters/policy: default [performance] powersave powersupersave

### Clockspeeds (idle vs. heated up):

Before at 46.3°C:

    cpu0 (Cortex-A76): OPP: 2400, ThreadX: 2400, Measured: 2398 

After at 59.5°C:

    cpu0 (Cortex-A76): OPP: 2400, ThreadX: 2400, Measured: 2398 

### Performance baseline

  * memcpy: 4447.8 MB/s, memchr: 11853.4 MB/s, memset: 9842.5 MB/s
  * 16M latency: 138.8 139.9 160.6 140.3 139.5 140.7 152.4 173.1 
  * 128M latency: 157.5 157.0 157.9 156.9 157.3 170.1 158.0 160.3 
  * 7-zip MIPS (3 consecutive runs): 10290, 10356, 10379 (10340 avg), single-threaded: 2967
  * `aes-256-cbc     590066.19k  1051399.34k  1274036.31k  1338756.78k  1365185.88k  1367594.33k`
  * `aes-256-cbc     590348.62k  1051432.32k  1273951.06k  1338761.56k  1364658.86k  1367965.70k`

### PCIe and storage devices:

  * Raspberry Pi Ltd. RP1: Speed 5GT/s, Width x4, driver in use: rp1
  * 29GB "Probable counterfeit Texas Instruments SPCC" UHS SDR104 SD card as /dev/mmcblk0: date 08/2023, manfid/oemid: 0x00009f/0x5449, hw/fw rev: 0x2/0x0

### Swap configuration:

  * /var/swap on /dev/mmcblk0p2: 100.0M (0K used) on ultra slow SD card storage

### Software versions:

  * Debian GNU/Linux 12 (bookworm)
  * Build scripts: http://archive.raspberrypi.com/debian/ bookworm main
  * Compiler: /usr/bin/gcc (Debian 12.2.0-14) 12.2.0 / aarch64-linux-gnu
  * ThreadX: b74d18ae / 2023/09/28 11:24:57 

### Kernel info:

  * `/proc/cmdline: coherent_pool=1M 8250.nr_uarts=1 pci=pcie_bus_safe snd_bcm2835.enable_compat_alsa=0 snd_bcm2835.enable_hdmi=1  smsc95xx.macaddr=D8:3A:DD:97:A8:E3 vc_mem.mem_base=0x3fc00000 vc_mem.mem_size=0x40000000  console=ttyAMA10,115200 console=tty1 root=PARTUUID=321da940-02 rootfstype=ext4 fsck.repair=yes rootwait quiet splash plymouth.ignore-serial-consoles cfg80211.ieee80211_regdom=GB`
  * Vulnerability Spec store bypass:    Mitigation; Speculative Store Bypass disabled via prctl
  * Vulnerability Spectre v1:           Mitigation; __user pointer sanitization
  * Vulnerability Spectre v2:           Mitigation; CSV2, BHB
  * Kernel 6.1.0-rpi4-rpi-2712 / CONFIG_HZ=250

Kernel 6.1.0 is not latest 6.1.59 LTS that was released on 2023-10-19.

See https://endoflife.date/linux for details. It is somewhat likely that
a lot of exploitable vulnerabilities exist for this kernel as well as many
unfixed bugs.
