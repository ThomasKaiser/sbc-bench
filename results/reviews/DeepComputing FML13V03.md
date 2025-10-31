# DeepComputing FML13V03

Tested with sbc-bench v0.9.72 on Sun, 12 Oct 2025 13:19:37 +0800. Full info: [fml13v03.txt](../fml13v03.txt)

### General information:

The CPU features 2 clusters of same core type:

    Eswin EIC7702X, Kernel: riscv64, Userland: riscv64
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      700    1800   eswin,eic770x
      1        0        0      700    1800   eswin,eic770x
      2        0        0      700    1800   eswin,eic770x
      3        0        0      700    1800   eswin,eic770x
      4        0        4      700    1800   eswin,eic770x
      5        0        4      700    1800   eswin,eic770x
      6        0        4      700    1800   eswin,eic770x
      7        0        4      700    1800   eswin,eic770x

14682 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: performance / 1800 MHz (conservative ondemand userspace powersave performance schedutil / 700 800 900 1400 1500 1600 1700 1800)
    cpufreq-policy4: performance / 1800 MHz (conservative ondemand userspace powersave performance schedutil / 700 800 900 1400 1500 1600 1700 1800)
    soc:video-decoder0@50100000: performance / 800 MHz (userspace performance simple_ondemand / 200 229 267 320 400 533 800)
    soc:video-decoder1@70100000: performance / 800 MHz (userspace performance simple_ondemand / 200 229 267 320 400 533 800)
    soc:video-encoder@50110000: performance / 800 MHz (userspace performance simple_ondemand / 200 229 267 320 400 533 800)
    soc:video-encoder@70110000: performance / 800 MHz (userspace performance simple_ondemand / 200 229 267 320 400 533 800)
    51c00000.eswin-npu: performance / 1500 MHz (userspace performance simple_ondemand / 520 750 1040 1500)
    71c00000.eswin-npu: performance / 1500 MHz (userspace performance simple_ondemand / 520 750 1040 1500)
    50140000.g2d: performance / 1040 MHz (userspace performance simple_ondemand / 260 520 693 1040)
    51400000.gpu: performance / 800 MHz (userspace performance simple_ondemand / 200 400 800)
    52280400.dsp_subsys:es_dsp@0: performance / 1040 MHz (userspace performance simple_ondemand / 520 1040)
    52280400.dsp_subsys:es_dsp@1: performance / 1040 MHz (userspace performance simple_ondemand / 520 1040)
    52280400.dsp_subsys:es_dsp@2: performance / 1040 MHz (userspace performance simple_ondemand / 520 1040)
    52280400.dsp_subsys:es_dsp@3: performance / 1040 MHz (userspace performance simple_ondemand / 520 1040)
    70140000.g2d: performance / 1040 MHz (userspace performance simple_ondemand / 260 520 693 1040)
    72280400.dsp_subsys:es_dsp@0: performance / 1040 MHz (userspace performance simple_ondemand / 520 1040)
    72280400.dsp_subsys:es_dsp@1: performance / 1040 MHz (userspace performance simple_ondemand / 520 1040)
    72280400.dsp_subsys:es_dsp@2: performance / 1040 MHz (userspace performance simple_ondemand / 520 1040)
    72280400.dsp_subsys:es_dsp@3: performance / 1040 MHz (userspace performance simple_ondemand / 520 1040)

Tuned governor settings:

    cpufreq-policy0: performance / 1800 MHz
    cpufreq-policy4: performance / 1800 MHz
    soc:video-decoder0@50100000: performance / 800 MHz
    soc:video-decoder1@70100000: performance / 800 MHz
    soc:video-encoder@50110000: performance / 800 MHz
    soc:video-encoder@70110000: performance / 800 MHz
    51c00000.eswin-npu: performance / 1500 MHz
    71c00000.eswin-npu: performance / 1500 MHz
    50140000.g2d: performance / 1040 MHz
    51400000.gpu: performance / 800 MHz
    52280400.dsp_subsys:es_dsp@0: performance / 1040 MHz
    52280400.dsp_subsys:es_dsp@1: performance / 1040 MHz
    52280400.dsp_subsys:es_dsp@2: performance / 1040 MHz
    52280400.dsp_subsys:es_dsp@3: performance / 1040 MHz
    70140000.g2d: performance / 1040 MHz
    72280400.dsp_subsys:es_dsp@0: performance / 1040 MHz
    72280400.dsp_subsys:es_dsp@1: performance / 1040 MHz
    72280400.dsp_subsys:es_dsp@2: performance / 1040 MHz
    72280400.dsp_subsys:es_dsp@3: performance / 1040 MHz

Status of performance related policies found below /sys:

    /sys/module/pcie_aspm/parameters/policy: default [performance] powersave powersupersave

### Clockspeeds (idle vs. heated up):

Before at 48.1°C:

    cpu0-cpu3 (eswin,eic770x): OPP: 1800, Measured: 1797 
    cpu4-cpu7 (eswin,eic770x): OPP: 1800, Measured: 1796 

After at 52.1°C:

    cpu0-cpu3 (eswin,eic770x): OPP: 1800, Measured: 1797 
    cpu4-cpu7 (eswin,eic770x): OPP: 1800, Measured: 1796 

### Performance baseline

  * cpu0 (eswin,eic770x): memcpy: 4849.1 MB/s, memchr: 3569.9 MB/s, memset: 7464.5 MB/s
  * cpu4 (eswin,eic770x): memcpy: 4737.1 MB/s, memchr: 3521.9 MB/s, memset: 6913.4 MB/s
  * cpu0 (eswin,eic770x) 16M latency: 
  * cpu4 (eswin,eic770x) 16M latency: 
  * cpu0 (eswin,eic770x) 128M latency: 
  * cpu4 (eswin,eic770x) 128M latency: 
  * 7-zip MIPS (3 consecutive runs): 9103, 9325, 9804 (9410 avg), single-threaded: 1787
  * `aes-256-cbc      37028.54k    46267.99k    49204.65k    50033.32k    50383.53k    50402.65k (eswin,eic770x)`
  * `aes-256-cbc      37347.37k    46391.55k    49263.27k    50114.90k    50345.30k    50348.03k (eswin,eic770x)`

### PCIe and storage devices:

  * Intel Wi-Fi 6 AX200: Speed 5GT/s, Width x1, driver in use: iwlwifi, ASPM L1 Enabled; RCB 64 bytes, Disabled- CommClk+
ASPM L1 Enabled; RCB 64 bytes, Disabled- CommClk+ PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ L1_PM_Substates+ PortCommonModeRestoreTime=10us PortTPowerOnTime=1000us -- PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ L1_PM_Substates+ PortCommonModeRestoreTime=30us PortTPowerOnTime=18us  PCI-PM_L1.2- PCI-PM_L1.1- ASPM_L1.2- ASPM_L1.1- T_CommonMode=0us LTR1.2_Threshold=1016832ns -- PCI-PM_L1.2- PCI-PM_L1.1- ASPM_L1.2- ASPM_L1.1- T_CommonMode=0us LTR1.2_Threshold=54272ns  T_PwrOn=1000us T_PwrOn=18us 
  * 476.9GB "ZHITAI TiPlus7100 512GB" SSD as /dev/nvme0: Speed 8GT/s (downgraded), Width x4, 0% worn out, drive temp: 53°C, ASPM L1 Enabled; RCB 64 bytes, Disabled- CommClk+ PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ L1_PM_Substates+ PortCommonModeRestoreTime=10us PortTPowerOnTime=1000us  PCI-PM_L1.2- PCI-PM_L1.1- ASPM_L1.2- ASPM_L1.1- T_CommonMode=0us LTR1.2_Threshold=1016832ns  T_PwrOn=1000us 

### Swap configuration:

  * /dev/nvme0n1p2: 2.0G (0K used)

### Software versions:

  * Ubuntu 24.04 LTS  v1.0.15009 (noble)
  * Compiler: /usr/bin/gcc (Ubuntu 13.3.0-6ubuntu2~24.04) 13.3.0 / riscv64-linux-gnu
  * OpenSSL 3.0.13, built on 30 Jan 2024 (Library: OpenSSL 3.0.13 30 Jan 2024)    

### Kernel info:

  * `/proc/cmdline: BOOT_IMAGE=/boot/vmlinuz-6.6.92-eic7x-2025.07 root=UUID=31e38c8c-d8f2-48bd-9a86-071e2d2299f1 ro quiet splash console=tty0 console=ttys0,115200n8 earlycon=sbi console=ttyS0,115200n8 clk_ignore_unused cma_pernuma=0x20000000 disable_bypass=false no_console_suspend firmware_class.path=/lib/firmware/eic7x/`
  * Kernel 6.6.92-eic7x-2025.07 / CONFIG_HZ=250