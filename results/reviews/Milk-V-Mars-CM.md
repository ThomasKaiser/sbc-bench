# Milk-V Mars CM eMMC

Tested with sbc-bench v0.9.49 on Sat, 28 Oct 2023 00:53:32 +0000.  Full info: [http://ix.io/4K7E](http://ix.io/4K7E)

### General information:

    StarFive JH7110, Kernel: riscv64, Userland: riscv64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      375    1500   sifive,u74-mc
      1        0        0      375    1500   sifive,u74-mc
      2        0        0      375    1500   sifive,u74-mc
      3        0        0      375    1500   sifive,u74-mc

3874 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: ondemand / 1500 MHz (conservative ondemand userspace powersave performance schedutil / 375 500 750 1500)

Tuned governor settings:

    cpufreq-policy0: performance / 1500 MHz

### Clockspeeds (idle vs. heated up):

Before at 34.6°C:

    cpu0 (sifive,u74-mc): OPP: 1500, Measured: 1497 

After at 45.8°C:

    cpu0 (sifive,u74-mc): OPP: 1500, Measured: 1498 

### Performance baseline

  * memcpy: 927.7 MB/s, memchr: 1196.6 MB/s, memset: 827.8 MB/s
  * 16M latency: 167.2 276.6 166.1 276.5 166.0 275.3 502.3 957.9 
  * 128M latency: 173.1 292.6 174.9 289.7 172.8 287.9 516.3 978.5 
  * 7-zip MIPS (3 consecutive runs): 4117, 4150, 4053 (4110 avg), single-threaded: 1195
  * `aes-256-cbc      18511.97k    23119.89k    24572.50k    24961.37k    25083.90k    25067.52k`
  * `aes-256-cbc      18532.47k    23117.03k    24585.05k    24964.44k    25083.90k    25072.98k`

### Storage devices:

  * 14.6GB "Samsung AJTD4R" HS200 eMMC 5.1 card as /dev/mmcblk0: date 08/2022, manfid/oemid: 0x000015/0x0100, hw/fw rev: 0x0/0x0600000000000000
  * Gigadevice GD25LQ128D SPI NOR flash (3 partitions: spl: 256KB, uboot: 3072KB, data: 1024KB), drivers in use: spi-nor/cadence-qspi/simple-pm-bus

### Software versions:

  * Debian GNU/Linux bookworm/sid
  * Compiler: /usr/bin/gcc (Debian 12.2.0-10) 12.2.0 / riscv64-linux-gnu
  * OpenSSL 3.0.7, built on 1 Nov 2022 (Library: OpenSSL 3.0.7 1 Nov 2022)    

### Kernel info:

  * `/proc/cmdline: root=/dev/mmcblk0p4 rw console=tty0 console=ttyS0,115200 earlycon rootwait stmmaceth=chain_mode:1 selinux=0 net.ifnames=0`
  * Kernel 5.15.0 / CONFIG_HZ=100

Kernel 5.15.0 is not latest 5.15.137 LTS that was released on 2023-10-25.

See https://endoflife.date/linux for details. It is somewhat likely that
a lot of exploitable vulnerabilities exist for this kernel as well as many
unfixed bugs.

But this version string doesn't matter since this is not an official LTS Linux
from kernel.org. This device runs a StarFive vendor/BSP kernel.

