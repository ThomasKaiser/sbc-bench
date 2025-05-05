# Phytium D3000 mATX CRB

Tested with sbc-bench v0.9.71 on Mon, 05 May 2025 00:14:30 +1000. Full info: [https://0x0.st/84GG.bin](../84GG.txt)

### General information:

    Phytium D3000/8, Kernel: aarch64, Userland: arm64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0       36        0      625    2500   Phytium FTC862 / r0p0
      1       36        1      625    2500   Phytium FTC862 / r0p0
      2       36        2      625    2500   Phytium FTC862 / r0p0
      3       36        3      625    2500   Phytium FTC862 / r0p0
      4       36        4      625    2500   Phytium FTC862 / r0p0
      5       36        5      625    2500   Phytium FTC862 / r0p0
      6       36        6      625    2500   Phytium FTC862 / r0p0
      7       36        7      625    2500   Phytium FTC862 / r0p0

31954 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: performance / 2500 MHz (conservative ondemand powersave userspace performance schedutil)
    cpufreq-policy1: performance / 2500 MHz (conservative ondemand powersave userspace performance schedutil)
    cpufreq-policy2: performance / 2500 MHz (conservative ondemand powersave userspace performance schedutil)
    cpufreq-policy3: performance / 2500 MHz (conservative ondemand powersave userspace performance schedutil)
    cpufreq-policy4: performance / 2500 MHz (conservative ondemand powersave userspace performance schedutil)
    cpufreq-policy5: performance / 2500 MHz (conservative ondemand powersave userspace performance schedutil)
    cpufreq-policy6: performance / 2500 MHz (conservative ondemand powersave userspace performance schedutil)
    cpufreq-policy7: performance / 2500 MHz (conservative ondemand powersave userspace performance schedutil)

Tuned governor settings:

    cpufreq-policy0: performance / 2500 MHz
    cpufreq-policy1: performance / 2500 MHz
    cpufreq-policy2: performance / 2500 MHz
    cpufreq-policy3: performance / 2500 MHz
    cpufreq-policy4: performance / 2500 MHz
    cpufreq-policy5: performance / 2500 MHz
    cpufreq-policy6: performance / 2500 MHz
    cpufreq-policy7: performance / 2500 MHz

Status of performance related policies found below /sys:

    /sys/module/pcie_aspm/parameters/policy: default [performance] powersave powersupersave

### Clockspeeds (idle vs. heated up):

Before at 29.0°C:

    cpu0 (Phytium FTC862): OPP: 2500, Measured: 2498 

After at 34.0°C:

    cpu0 (Phytium FTC862): OPP: 2500, Measured: 2498 

### Performance baseline

  * memcpy: 15094.1 MB/s, memchr: 19059.1 MB/s, memset: 39814.3 MB/s
  * 16M latency: 83.53 62.56 83.15 63.14 82.37 65.65 67.93 76.58 
  * 128M latency: 135.9 135.3 135.9 135.2 135.9 134.8 135.4 139.9 
  * 7-zip MIPS (3 consecutive runs): 28055, 28069, 28086 (28070 avg), single-threaded: 3617
  * `aes-256-cbc     587227.48k  1174792.36k  1353980.67k  1406049.28k  1423706.79k  1425118.55k`
  * `aes-256-cbc     587950.56k  1175944.49k  1355359.32k  1407310.17k  1425055.74k  1426522.11k`

### PCIe and storage devices:

  * Renesas uPD720201 USB 3.0 Host: Speed 5GT/s, Width x1, driver in use: xhci_hcd, ASPM Disabled
  * AMD Navi 21 [Radeon RX 6800/6800 XT / 6900 XT]: Speed 16GT/s, Width x16, driver in use: amdgpu, ASPM Disabled
  * 238.5GB "WD PC SN740 SDDPNQD-256G-2006" SSD as /dev/nvme0: Speed 16GT/s, Width x4, 0% worn out, 5 error log entries, drive temp: 41°C, ASPM Disabled

"nvme error-log /dev/nvme0 ; smartctl -x /dev/nvme0" could be used to get further information about the reported issues.

### Swap configuration:

  * /dev/nvme0n1p3: 15.7G (0K used)

### Software versions:

  * Deepin 23.1
  * Compiler: /usr/bin/gcc (Deepin 12.3.0-17deepin12) 12.3.0 / aarch64-linux-gnu
  * OpenSSL 3.2.4, built on 11 Feb 2025 (Library: OpenSSL 3.2.4 11 Feb 2025)    

### Kernel info:

  * `/proc/cmdline: BOOT_IMAGE=/boot/vmlinuz-6.6.84-arm64-desktop-hwe root=UUID=ac986561-2588-4a99-919f-e4e28a2485f7 ro loglevel=8 mitigations=off cma=32M splash quiet console=tty plymouth.ignore-serial-consoles DEEPIN_GFXMODE=`
  * Vulnerability Spectre v1:             Mitigation; __user pointer sanitization
  * Kernel 6.6.84-arm64-desktop-hwe / CONFIG_HZ=250