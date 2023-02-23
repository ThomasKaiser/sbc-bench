# StarFive VisionFive V2

Tested with sbc-bench v0.9.28 on Wed, 22 Feb 2023 15:32:04 +0000. Full info: [http://ix.io/4oLx](http://ix.io/4oLx)

### General information:

   StarFive JH7110, Kernel: riscv64, Userland: riscv64

   CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                    cpufreq   min    max
    CPU    cluster  policy   speed  speed   core type
     0       -1        0      375    1500   sifive,u74-mc
     1       -1        0      375    1500   sifive,u74-mc
     2       -1        0      375    1500   sifive,u74-mc
     3       -1        0      375    1500   sifive,u74-mc

### Governors/policies (performance vs. idle consumption):

Original governor settings:

   cpufreq-policy0: ondemand / 1500 MHz (conservative ondemand userspace powersave performance schedutil / 375 500 750 1500)

Tuned governor settings:

   cpufreq-policy0: performance / 1500 MHz

### Clockspeeds (idle vs. heated up):

Before at 37.9°C:

   cpu0 (sifive,u74-mc): OPP: 1500, Measured: 1498 

After at 43.7°C:

   cpu0 (sifive,u74-mc): OPP: 1500, Measured: 1498 

### Memory performance

 * memcpy: 870.7 MB/s, memchr: 1192.7 MB/s, memset: 766.4 MB/s
 * 16M latency: 167.2 279.2 167.2 280.6 165.9 278.3 504.5 961.5 

### PCIe and storage devices:

 * VIA VL805/806 xHCI USB 3.0: Speed 5GT/s, Width x1, driver in use: xhci_hcd
 * 232.9GB "HP SSD EX900 250GB" SSD as /dev/nvme0n1: Speed 5GT/s (downgraded), Width x1 (downgraded), 0% worn out, 40°C
 * 465.8GB "WD Blue SN570 500GB" SSD as /dev/sda [NVMe]: behind Realtek RTL9210 M.2 NVME Adapter, 0% worn out, 1 error log entries, Driver=uas, 5000Mbps (capable of 12Mbps, 480Mbps, 5Gbps, 10Gb/s Symmetric RX SuperSpeedPlus, 10Gb/s Symmetric TX SuperSpeedPlus), 34°C
 * 238.5GB "KBG40ZNS256G NVMe KIOXIA 256GB" SSD as /dev/sdb [NVMe]: behind JMicron JMS583Gen 2 to PCIe Gen3x2 Bridge, 0% worn out, Driver=uas, 5000Mbps (capable of 12Mbps, 480Mbps, 5Gbps, 10Gb/s Symmetric RX SuperSpeedPlus, 10Gb/s Symmetric TX SuperSpeedPlus), 54°C
 * 238.5GB "TOSHIBA KSG60ZMV256G M.2 2280 256GB" SSD as /dev/sdc [SATA 3.3, 6.0 Gb/s (current: 6.0 Gb/s)]: behind JMicron JMS576 SATA 6Gb/s bridge, 8% worn out, Driver=uas, 5000Mbps (capable of 12Mbps, 480Mbps, 5Gbps), 53°C°C
 * 31.3GB "Unknown manufacturer Disk (Thumb drive)" as /dev/sdd: USB, Driver=usb-storage, 480Mbps
 * 28.9GB "Foresee SLD32G" HS200 eMMC 5.1 card as /dev/mmcblk0: date 04/2021, manfid/oemid: 0x000088/0x0103, hw/fw rev: 0x0/0x0202020000000000
 * 29.1GB "Texas Instruments SD32G" HS SD card as /dev/mmcblk1: date 10/2020, manfid/oemid: 0x00009f/0x5449, hw/fw rev: 0x6/0x1
 * Gigadevice GD25LQ128D SPI NOR flash (3 partitions: spl: 128KB, uboot: 3072KB, data: 1024KB), drivers in use: spi-nor/cadence-qspi/simple-pm-bus

### Challenging filesystems:

The following partitions are NTFS: sdc1

When this OS uses FUSE/userland methods to access NTFS filesystems performance
will be significantly harmed or at least likely be bottlenecked by maxing out
one or more CPU cores. It is highly advised when benchmarking with any NTFS to
monitor closely CPU utilization or better switch to a 'Linux native' filesystem
like ext4 since representing 'storage performance' a lot more than 'somewhat 
dealing with a foreign filesystem' as with NTFS.

### Software versions:

 * Debian GNU/Linux bookworm/sid
 * Compiler: /usr/bin/gcc (Debian 12.2.0-14) 12.2.0 / riscv64-linux-gnu
 * OpenSSL 1.1.1f, built on 31 Mar 2020

### Kernel info:

 * `/proc/cmdline: root=/dev/nvme0n1p1 rw console=tty0 console=ttyS0,115200 earlycon rootwait stmmaceth=chain_mode:1 selinux=0`
 * Kernel 5.15.0-starfive / CONFIG_HZ=100

Kernel 5.15.0 is not latest 5.15.95 LTS that was released on 2023-02-22.

See https://endoflife.date/linux for details. It is somewhat likely that
a lot of exploitable vulnerabilities exist for this kernel as well as many
unfixed bugs.

But this version string doesn't matter since this is not an official LTS Linux
from kernel.org. This device runs a StarFive vendor/BSP kernel.