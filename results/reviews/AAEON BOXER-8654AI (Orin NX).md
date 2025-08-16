Full results uploaded to https://0x0.st/87lq.txt
 
# AAEON BOXER-8654AI_RefKit` platform
 
Tested with sbc-bench v0.9.72 on Sun, 03 Aug 2025 12:15:38 +0200. Full info: [https://0x0.st/87lq.txt](../87lq.txt)
 
### General information:
 
    Information courtesy of cpufetch:
    
    SoC:                 NVIDIA Tegra Orin
    Technology:          8nm
    Microarchitecture:   Cortex-A78AE
    Max Frequency:       1.728 GHz
    Cores:               6 cores
    Features:            NEON,SHA1,SHA2,AES,CRC32
    
The CPU features 2 clusters of same core type:
 
    Tegra 35 rev Silicon A01, Nvidia Jetson Orin NX, Kernel: aarch64, Userland: arm64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      115    1728   Cortex-A78AE / r0p1
      1        0        0      115    1728   Cortex-A78AE / r0p1
      2        0        0      115    1728   Cortex-A78AE / r0p1
      3        0        0      115    1728   Cortex-A78AE / r0p1
      4        1        4      115    1728   Cortex-A78AE / r0p1
      5        1        4      115    1728   Cortex-A78AE / r0p1
 
7620 KB available RAM
 
### Governors/policies (performance vs. idle consumption):
 
Original governor settings:
 
    cpufreq-policy0: schedutil / 1114 MHz (powersave ondemand userspace performance schedutil / 115 192 269 346 422 499 576 653 730 806 883 960 1037 1114 1190 1267 1344 1421 1498 1574 1651 1728)
    cpufreq-policy4: schedutil / 115 MHz (powersave ondemand userspace performance schedutil / 115 192 269 346 422 499 576 653 730 806 883 960 1037 1114 1190 1267 1344 1421 1498 1574 1651 1728)
    15a50000.ofa: performance / 538 MHz (userspace tegra_wmark nvhost_podgov performance simple_ondemand / 115 128 141 154 166 179 192 205 218 230 243 256 269 282 294 307 320 333 346 358 371 384 397 410 422 435 448 461 474 486 499 512 525 538)
    15340000.vic: performance / 435 MHz (userspace tegra_wmark nvhost_podgov performance simple_ondemand / 115 128 141 154 166 179 192 205 218 230 243 256 269 282 294 307 320 333 346 358 371 384 397 410 422 435)
    15380000.nvjpg: performance / 499 MHz (userspace tegra_wmark nvhost_podgov performance simple_ondemand / 115 128 141 154 166 179 192 205 218 230 243 256 269 282 294 307 320 333 346 358 371 384 397 410 422 435 448 461 474 486 499)
    15480000.nvdec: performance / 525 MHz (userspace tegra_wmark nvhost_podgov performance simple_ondemand / 115 128 141 154 166 179 192 205 218 230 243 256 269 282 294 307 320 333 346 358 371 384 397 410 422 435 448 461 474 486 499 512 525)
    15540000.nvjpg: performance / 499 MHz (userspace tegra_wmark nvhost_podgov performance simple_ondemand / 115 128 141 154 166 179 192 205 218 230 243 256 269 282 294 307 320 333 346 358 371 384 397 410 422 435 448 461 474 486 499)
    17000000.gpu: performance / 918 MHz (userspace tegra_wmark nvhost_podgov performance simple_ondemand / 306 408 510 612 714 816 918 1020)
 
Tuned governor settings:
 
    cpufreq-policy0: performance / 1728 MHz
    cpufreq-policy4: performance / 1728 MHz
    15a50000.ofa: performance / 538 MHz
    15340000.vic: performance / 435 MHz
    15380000.nvjpg: performance / 499 MHz
    15480000.nvdec: performance / 525 MHz
    15540000.nvjpg: performance / 499 MHz
    17000000.gpu: performance / 918 MHz
 
Status of performance related policies found below /sys:
 
    /sys/module/pcie_aspm/parameters/policy: default [performance] powersave powersupersave
 
### Clockspeeds (idle vs. heated up):
 
Before at 46.4°C:
 
    cpu0-cpu3 (Cortex-A78AE): OPP: 1728, Measured: 1724 
    cpu4-cpu5 (Cortex-A78AE): OPP: 1728, Measured: 1724 
 
After at 50.7°C:
 
    cpu0-cpu3 (Cortex-A78AE): OPP: 1728, Measured: 1725 
    cpu4-cpu5 (Cortex-A78AE): OPP: 1728, Measured: 1725 
 
### Performance baseline
 
  * cpu0 (Cortex-A78AE): memcpy: 6861.5 MB/s, memchr: 10045.8 MB/s, memset: 20414.3 MB/s
  * cpu4 (Cortex-A78AE): memcpy: 6916.3 MB/s, memchr: 9868.5 MB/s, memset: 20473.1 MB/s
  * cpu0 (Cortex-A78AE) 16M latency: 224.4 163.8 206.2 163.2 199.3 175.2 129.8 147.0 
  * cpu4 (Cortex-A78AE) 16M latency: 206.8 159.5 195.4 155.6 190.3 171.2 128.9 147.2 
  * cpu0 (Cortex-A78AE) 128M latency: 292.6 292.0 293.2 294.8 292.1 288.5 262.9 237.2 
  * cpu4 (Cortex-A78AE) 128M latency: 290.4 288.9 289.9 289.0 289.9 285.8 253.7 236.9 
  * 7-zip MIPS (3 consecutive runs): 14779, 14859, 14825 (14820 avg), single-threaded: 2379
  * `aes-256-cbc     637441.10k   885772.91k   951931.65k   967357.10k   972936.53k   973597.35k (Cortex-A78AE)`
  * `aes-256-cbc     637271.62k   885940.31k   952617.81k   968131.24k   973335.21k   974061.57k (Cortex-A78AE)`
 
### PCIe and storage devices:
 
  * Intel I210 Gigabit Network Connection: Speed 2.5GT/s (ok), Width x1 (ok), driver in use: igb, ASPM Disabled
  * Intel I210 Gigabit Network Connection: Speed 2.5GT/s (ok), Width x1 (ok), driver in use: igb, ASPM Disabled
  * Intel I210 Gigabit Network Connection: Speed 2.5GT/s (ok), Width x1 (ok), driver in use: igb, ASPM Disabled
  * Realtek RTL8111/8168/8211/8411 PCI Express Gigabit Ethernet: Speed 2.5GT/s (ok), Width x1 (ok), driver in use: r8168, ASPM Disabled
  * 238.5GB "Phison ESMP256GKB5G2-E13TI" SSD as /dev/nvme0: Speed 8GT/s (ok), Width x4 (ok), 0% worn out, drive temp: 54°C, ASPM Disabled
  * "ASMedia SATA 6Gb/s bridge" as /dev/sda: USB, Driver=usb-storage, 5Gbps (capable of 12Mbps, 480Mbps, 5Gbps)
 
### Swap configuration:
 
  * /dev/zram0: 635M (0K used, lzo-rle, 6 streams, 4K data, 74B compressed, 12K total)
  * /dev/zram1: 635M (0K used, lzo-rle, 6 streams, 4K data, 74B compressed, 12K total)
  * /dev/zram2: 635M (0K used, lzo-rle, 6 streams, 4K data, 74B compressed, 12K total)
  * /dev/zram3: 635M (0K used, lzo-rle, 6 streams, 4K data, 74B compressed, 12K total)
  * /dev/zram4: 635M (0K used, lzo-rle, 6 streams, 4K data, 74B compressed, 12K total)
  * /dev/zram5: 635M (0K used, lzo-rle, 6 streams, 4K data, 74B compressed, 12K total)
 
### Software versions:
 
  * Ubuntu 22.04.5 LTS (jammy)
  * Compiler: /usr/bin/gcc (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0 / aarch64-linux-gnu
  * OpenSSL 3.0.2, built on 15 Mar 2022 (Library: OpenSSL 3.0.2 15 Mar 2022)    
 
### Kernel info:
 
  * `/proc/cmdline: root=/dev/nvme0n1p1 rw rootwait rootfstype=ext4 mminit_loglevel=4 console=ttyTCU0,115200 firmware_class.path=/etc/firmware fbcon=map:0 net.ifnames=0 nospectre_bhb video=efifb:off console=tty0 bl_prof_dataptr=2031616@0x271E10000 bl_prof_ro_ptr=65536@0x271E00000 `
  * Vulnerability Spec store bypass:    Mitigation; Speculative Store Bypass disabled via prctl
  * Vulnerability Spectre v1:           Mitigation; __user pointer sanitization
  * Vulnerability Spectre v2:           Mitigation; CSV2, but not BHB
  * Kernel 5.15.148-tegra / CONFIG_HZ=250