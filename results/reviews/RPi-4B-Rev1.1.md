# RPi 4 Model B Rev 1.1 / BCM2711 Rev B0

Tested on Fri, 17 Feb 2023 22:54:24 +0100. Full info: [http://ix.io/4onR](http://ix.io/4onR)

### General information:

    BCM2711B0, RPi 4 Model B Rev 1.1 / BCM2711 Rev B0, Kernel: armv7l, Userland: armhf
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      600    1500   Cortex-A72 / r0p3
      1        0        0      600    1500   Cortex-A72 / r0p3
      2        0        0      600    1500   Cortex-A72 / r0p3
      3        0        0      600    1500   Cortex-A72 / r0p3

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: ondemand / 1500 MHz (conservative ondemand userspace powersave performance schedutil)

Tuned governor settings:

    cpufreq-policy0: performance / 1500 MHz

### Clockspeeds (idle vs. heated up):

Before at 35.0°C:

    cpu0 (Cortex-A72): OPP: 1500, ThreadX: 1500, Measured: 1499 

After at 47.7°C:

    cpu0 (Cortex-A72): OPP: 1500, ThreadX: 1500, Measured: 1499 

### PCIe and storage devices:

  * VIA VL805/806 xHCI USB 3.0: Speed 5GT/s (ok), Width x1 (ok), driver in use: xhci_hcd
  * 59.5GB SanDisk SR64G SD card as /dev/mmcblk0: date 08/2018, man/oem ID: 0x000003/0x5344, hw/fw rev: 0x8/0x0

### Software versions:

  * Raspbian GNU/Linux 11 (bullseye)
  * Build scripts: http://archive.raspberrypi.org/debian/ bullseye main
  * Compiler: /usr/bin/gcc (Raspbian 10.2.1-6+rpi1) 10.2.1 20210110 / arm-linux-gnueabihf
  * OpenSSL 1.1.1n, built on 15 Mar 2022
  * ThreadX: 8ba17717fbcedd4c3b6d4bce7e50c7af4155cba9 / Jan  5 2023 10:46:54 

### Kernel info:

  * `/proc/cmdline: coherent_pool=1M 8250.nr_uarts=0 snd_bcm2835.enable_compat_alsa=0 snd_bcm2835.enable_hdmi=1  smsc95xx.macaddr=DC:A6:32:00:93:F2 vc_mem.mem_base=0x3ec00000 vc_mem.mem_size=0x40000000  console=ttyS0,115200 console=tty1 root=PARTUUID=0a735582-02 rootfstype=ext4 fsck.repair=yes rootwait quiet splash plymouth.ignore-serial-consoles`
  * Vulnerability Spectre v1:        Mitigation; __user pointer sanitization
  * Vulnerability Spectre v2:        Vulnerable
  * Kernel 5.15.84-v7l+ / CONFIG_HZ=100

Kernel 5.15.84 is not latest 5.15.94 LTS that was released on 2023-02-14.

Please check https://endoflife.date/linux for details. It is somewhat likely
some kernel bugs have been fixed in the meantime and maybe vulnerabilities
as well.
