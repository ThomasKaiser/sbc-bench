# SiFive HiFive Premier P550

Tested with sbc-bench v0.9.70 on Thu, 06 Feb 2025 19:49:36 +0000. Full info: [https://0x0.st/8PA8.bin](../8PA8.txt)

### General information:

    Eswin EIC7700X, Kernel: riscv64, Userland: riscv64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0       24    1400   eswin,eic770x
      1        0        0       24    1400   eswin,eic770x
      2        0        0       24    1400   eswin,eic770x
      3        0        0       24    1400   eswin,eic770x

15999 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: performance / 1400 MHz (conservative ondemand userspace powersave performance schedutil / 24 100 200 400 500 600 700 800 900 1000 1200 1300 1400)

Tuned governor settings:

    cpufreq-policy0: performance / 1400 MHz

Status of performance related policies found below /sys:

    /sys/module/pcie_aspm/parameters/policy: default [performance] powersave powersupersave

### Clockspeeds (idle vs. heated up):

Before:

    cpu0 (eswin,eic770x): OPP: 1400, Measured: 1397 

After:

    cpu0 (eswin,eic770x): OPP: 1400, Measured: 1397 

### Performance baseline

  * memcpy: 1146.8 MB/s, memchr: 2595.3 MB/s, memset: 10087.9 MB/s
  * 16M latency: 196.9 198.6 195.6 197.9 196.0 195.6 245.3 253.8 
  * 128M latency: 216.0 218.5 214.7 218.3 214.3 216.5 290.4 307.5 
  * 7-zip MIPS (3 consecutive runs): 5222, 5230, 5225 (5220 avg), single-threaded: 1449
  * `aes-256-cbc      28831.30k    35987.39k    38302.46k    38979.24k    39176.87k    39190.53k`
  * `aes-256-cbc      29289.48k    36157.80k    38354.09k    39000.41k    39190.53k    39195.99k`

### Storage devices:

  * 116.5GB "Samsung DUTB42" HS400 eMMC 5.1 card as /dev/mmcblk0: date 04/2024, manfid/oemid: 0x000015/0x0100, hw/fw rev: 0x0/0x0200000000000000

### Software versions:

  * Ubuntu 24.04.1 LTS (noble)
  * Compiler: /usr/bin/gcc (Ubuntu 13.3.0-6ubuntu2~24.04) 13.3.0 / riscv64-linux-gnu
  * OpenSSL 3.0.13, built on 30 Jan 2024 (Library: OpenSSL 3.0.13 30 Jan 2024)    

### Kernel info:

  * `/proc/cmdline: BOOT_IMAGE=/boot/vmlinuz-6.6.21-9-premier root=UUID=42713e07-4e13-4248-b7b9-7147d117e059 ro efi=debug earlycon=sbi clk_ignore_unused`
  * Kernel 6.6.21-9-premier / CONFIG_HZ=250