# StarFive VisionFive V2

Tested with sbc-bench v0.9.36 on Wed, 01 Mar 2023 15:24:08 +0000.. Full info: [http://ix.io/4pBf](http://ix.io/4pBf)

### General information:

   StarFive JH7110, Kernel: riscv64, Userland: riscv64

   CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                    cpufreq   min    max
    CPU    cluster  policy   speed  speed   core type
     0       -1        0      375    1500   sifive,u74-mc
     1       -1        0      375    1500   sifive,u74-mc
     2       -1        0      375    1500   sifive,u74-mc
     3       -1        0      375    1500   sifive,u74-mc

7927 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

   cpufreq-policy0: performance / 1500 MHz (conservative ondemand userspace powersave performance schedutil / 375 500 750 1500)

Tuned governor settings:

   cpufreq-policy0: performance / 1500 MHz

### Clockspeeds (idle vs. heated up):

Before at 39.0°C:

   cpu0 (sifive,u74-mc): OPP: 1500, Measured: 1498 

After at 44.1°C:

   cpu0 (sifive,u74-mc): OPP: 1500, Measured: 1498 

### Performance baseline

 * memcpy: 861.8 MB/s, memchr: 1185.9 MB/s, memset: 763.7 MB/s
 * 16M latency: 167.8 281.2 166.7 279.4 166.2 279.6 505.3 962.5 
 * 7-zip MIPS (3 consecutive runs): 4061, 4151, 4079 (4100 avg), single-threaded: 1191
 * `aes-256-cbc      18500.44k    23116.80k    24578.56k    24974.34k    25056.60k    25062.06k`
 * `aes-256-cbc      19686.55k    23346.69k    24642.13k    24959.66k    25072.98k    25040.21k`

### PCIe and storage devices:

 * VIA VL805/806 xHCI USB 3.0: Speed 5GT/s, Width x1, driver in use: xhci_hcd
 * 232.9GB "HP SSD EX900 250GB" SSD as /dev/nvme0: Speed 5GT/s (downgraded), Width x1 (downgraded), 0% worn out, drive temp: 38°C
 * 28.9GB "Foresee SLD32G" HS200 eMMC 5.1 card as /dev/mmcblk0: date 04/2021, manfid/oemid: 0x000088/0x0103, hw/fw rev: 0x0/0x0202020000000000
 * Gigadevice GD25LQ128D SPI NOR flash (3 partitions: spl: 128KB, uboot: 3072KB, data: 1024KB), drivers in use: spi-nor/cadence-qspi/simple-pm-bus

### Software versions:

 * Debian GNU/Linux bookworm/sid
 * Compiler: /usr/bin/gcc (Debian 12.2.0-10) 12.2.0 / riscv64-linux-gnu
 * OpenSSL 3.0.7, built on 1 Nov 2022 (Library: OpenSSL 3.0.7 1 Nov 2022)    

### Kernel info:

 * `/proc/cmdline: root=/dev/mmcblk0p4 rw console=tty0 console=ttyS0,115200 earlycon rootwait stmmaceth=chain_mode:1 selinux=0`
 * Kernel 5.15.0-starfive / CONFIG_HZ=100

Kernel 5.15.0 is not latest 5.15.96 LTS that was released on 2023-02-25.

See https://endoflife.date/linux for details. It is somewhat likely that
a lot of exploitable vulnerabilities exist for this kernel as well as many
unfixed bugs.

But this version string doesn't matter since this is not an official LTS Linux
from kernel.org. This device runs a StarFive vendor/BSP kernel.
