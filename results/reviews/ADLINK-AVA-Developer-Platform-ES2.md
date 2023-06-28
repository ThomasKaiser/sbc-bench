# ADLINK AVA Developer Platform ES2

Tested with sbc-bench v0.9.42 on Wed, 28 Jun 2023 16:30:50 +0000.

### General information:

   jep106:0a16 jep106:0a16:0001 rev 0x000000a1, Ampere Altra / Altra Max, Kernel: aarch64, Userland: arm64

   CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                    cpufreq   min    max
    CPU    cluster  policy   speed  speed   core type
     0      128        0     1000    2600   Neoverse-N1 / r3p1
     1      128        1     1000    2600   Neoverse-N1 / r3p1
     2      128        2     1000    2600   Neoverse-N1 / r3p1
     3      128        3     1000    2600   Neoverse-N1 / r3p1
     4      128        4     1000    2600   Neoverse-N1 / r3p1
     5      128        5     1000    2600   Neoverse-N1 / r3p1
     6      128        6     1000    2600   Neoverse-N1 / r3p1
     7      128        7     1000    2600   Neoverse-N1 / r3p1
     8      128        8     1000    2600   Neoverse-N1 / r3p1
     9      128        9     1000    2600   Neoverse-N1 / r3p1
    10      128       10     1000    2600   Neoverse-N1 / r3p1
    11      128       11     1000    2600   Neoverse-N1 / r3p1
    12      128       12     1000    2600   Neoverse-N1 / r3p1
    13      128       13     1000    2600   Neoverse-N1 / r3p1
    14      128       14     1000    2600   Neoverse-N1 / r3p1
    15      128       15     1000    2600   Neoverse-N1 / r3p1
    16      128       16     1000    2600   Neoverse-N1 / r3p1
    17      128       17     1000    2600   Neoverse-N1 / r3p1
    18      128       18     1000    2600   Neoverse-N1 / r3p1
    19      128       19     1000    2600   Neoverse-N1 / r3p1
    20      128       20     1000    2600   Neoverse-N1 / r3p1
    21      128       21     1000    2600   Neoverse-N1 / r3p1
    22      128       22     1000    2600   Neoverse-N1 / r3p1
    23      128       23     1000    2600   Neoverse-N1 / r3p1
    24      128       24     1000    2600   Neoverse-N1 / r3p1
    25      128       25     1000    2600   Neoverse-N1 / r3p1
    26      128       26     1000    2600   Neoverse-N1 / r3p1
    27      128       27     1000    2600   Neoverse-N1 / r3p1
    28      128       28     1000    2600   Neoverse-N1 / r3p1
    29      128       29     1000    2600   Neoverse-N1 / r3p1
    30      128       30     1000    2600   Neoverse-N1 / r3p1
    31      128       31     1000    2600   Neoverse-N1 / r3p1
    32      128       32     1000    2600   Neoverse-N1 / r3p1
    33      128       33     1000    2600   Neoverse-N1 / r3p1
    34      128       34     1000    2600   Neoverse-N1 / r3p1
    35      128       35     1000    2600   Neoverse-N1 / r3p1
    36      128       36     1000    2600   Neoverse-N1 / r3p1
    37      128       37     1000    2600   Neoverse-N1 / r3p1
    38      128       38     1000    2600   Neoverse-N1 / r3p1
    39      128       39     1000    2600   Neoverse-N1 / r3p1
    40      128       40     1000    2600   Neoverse-N1 / r3p1
    41      128       41     1000    2600   Neoverse-N1 / r3p1
    42      128       42     1000    2600   Neoverse-N1 / r3p1
    43      128       43     1000    2600   Neoverse-N1 / r3p1
    44      128       44     1000    2600   Neoverse-N1 / r3p1
    45      128       45     1000    2600   Neoverse-N1 / r3p1
    46      128       46     1000    2600   Neoverse-N1 / r3p1
    47      128       47     1000    2600   Neoverse-N1 / r3p1
    48      128       48     1000    2600   Neoverse-N1 / r3p1
    49      128       49     1000    2600   Neoverse-N1 / r3p1
    50      128       50     1000    2600   Neoverse-N1 / r3p1
    51      128       51     1000    2600   Neoverse-N1 / r3p1
    52      128       52     1000    2600   Neoverse-N1 / r3p1
    53      128       53     1000    2600   Neoverse-N1 / r3p1
    54      128       54     1000    2600   Neoverse-N1 / r3p1
    55      128       55     1000    2600   Neoverse-N1 / r3p1
    56      128       56     1000    2600   Neoverse-N1 / r3p1
    57      128       57     1000    2600   Neoverse-N1 / r3p1
    58      128       58     1000    2600   Neoverse-N1 / r3p1
    59      128       59     1000    2600   Neoverse-N1 / r3p1
    60      128       60     1000    2600   Neoverse-N1 / r3p1
    61      128       61     1000    2600   Neoverse-N1 / r3p1
    62      128       62     1000    2600   Neoverse-N1 / r3p1
    63      128       63     1000    2600   Neoverse-N1 / r3p1
    64      128       64     1000    2600   Neoverse-N1 / r3p1
    65      128       65     1000    2600   Neoverse-N1 / r3p1
    66      128       66     1000    2600   Neoverse-N1 / r3p1
    67      128       67     1000    2600   Neoverse-N1 / r3p1
    68      128       68     1000    2600   Neoverse-N1 / r3p1
    69      128       69     1000    2600   Neoverse-N1 / r3p1
    70      128       70     1000    2600   Neoverse-N1 / r3p1
    71      128       71     1000    2600   Neoverse-N1 / r3p1
    72      128       72     1000    2600   Neoverse-N1 / r3p1
    73      128       73     1000    2600   Neoverse-N1 / r3p1
    74      128       74     1000    2600   Neoverse-N1 / r3p1
    75      128       75     1000    2600   Neoverse-N1 / r3p1
    76      128       76     1000    2600   Neoverse-N1 / r3p1
    77      128       77     1000    2600   Neoverse-N1 / r3p1
    78      128       78     1000    2600   Neoverse-N1 / r3p1
    79      128       79     1000    2600   Neoverse-N1 / r3p1

96093 KB available RAM

### Governors/policies (performance vs. idle consumption):

Original governor settings:

   cpufreq-policy0: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy10: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy11: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy12: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy13: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy14: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy15: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy16: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy17: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy18: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy19: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy1: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy20: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy21: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy22: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy23: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy24: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy25: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy26: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy27: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy28: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy29: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy2: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy30: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy31: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy32: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy33: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy34: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy35: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy36: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy37: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy38: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy39: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy3: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy40: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy41: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy42: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy43: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy44: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy45: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy46: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy47: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy48: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy49: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy4: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy50: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy51: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy52: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy53: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy54: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy55: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy56: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy57: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy58: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy59: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy5: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy60: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy61: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy62: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy63: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy64: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy65: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy66: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy67: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy68: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy69: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy6: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy70: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy71: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy72: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy73: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy74: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy75: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy76: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy77: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy78: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy79: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy7: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy8: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)
   cpufreq-policy9: performance / 2600 MHz (conservative ondemand userspace powersave performance schedutil)

Tuned governor settings:

   cpufreq-policy0: performance / 2600 MHz
   cpufreq-policy10: performance / 2600 MHz
   cpufreq-policy11: performance / 2600 MHz
   cpufreq-policy12: performance / 2600 MHz
   cpufreq-policy13: performance / 2600 MHz
   cpufreq-policy14: performance / 2600 MHz
   cpufreq-policy15: performance / 2600 MHz
   cpufreq-policy16: performance / 2600 MHz
   cpufreq-policy17: performance / 2600 MHz
   cpufreq-policy18: performance / 2600 MHz
   cpufreq-policy19: performance / 2600 MHz
   cpufreq-policy1: performance / 2600 MHz
   cpufreq-policy20: performance / 2600 MHz
   cpufreq-policy21: performance / 2600 MHz
   cpufreq-policy22: performance / 2600 MHz
   cpufreq-policy23: performance / 2600 MHz
   cpufreq-policy24: performance / 2600 MHz
   cpufreq-policy25: performance / 2600 MHz
   cpufreq-policy26: performance / 2600 MHz
   cpufreq-policy27: performance / 2600 MHz
   cpufreq-policy28: performance / 2600 MHz
   cpufreq-policy29: performance / 2600 MHz
   cpufreq-policy2: performance / 2600 MHz
   cpufreq-policy30: performance / 2600 MHz
   cpufreq-policy31: performance / 2600 MHz
   cpufreq-policy32: performance / 2600 MHz
   cpufreq-policy33: performance / 2600 MHz
   cpufreq-policy34: performance / 2600 MHz
   cpufreq-policy35: performance / 2600 MHz
   cpufreq-policy36: performance / 2600 MHz
   cpufreq-policy37: performance / 2600 MHz
   cpufreq-policy38: performance / 2600 MHz
   cpufreq-policy39: performance / 2600 MHz
   cpufreq-policy3: performance / 2600 MHz
   cpufreq-policy40: performance / 2600 MHz
   cpufreq-policy41: performance / 2600 MHz
   cpufreq-policy42: performance / 2600 MHz
   cpufreq-policy43: performance / 2600 MHz
   cpufreq-policy44: performance / 2600 MHz
   cpufreq-policy45: performance / 2600 MHz
   cpufreq-policy46: performance / 2600 MHz
   cpufreq-policy47: performance / 2600 MHz
   cpufreq-policy48: performance / 2600 MHz
   cpufreq-policy49: performance / 2600 MHz
   cpufreq-policy4: performance / 2600 MHz
   cpufreq-policy50: performance / 2600 MHz
   cpufreq-policy51: performance / 2600 MHz
   cpufreq-policy52: performance / 2600 MHz
   cpufreq-policy53: performance / 2600 MHz
   cpufreq-policy54: performance / 2600 MHz
   cpufreq-policy55: performance / 2600 MHz
   cpufreq-policy56: performance / 2600 MHz
   cpufreq-policy57: performance / 2600 MHz
   cpufreq-policy58: performance / 2600 MHz
   cpufreq-policy59: performance / 2600 MHz
   cpufreq-policy5: performance / 2600 MHz
   cpufreq-policy60: performance / 2600 MHz
   cpufreq-policy61: performance / 2600 MHz
   cpufreq-policy62: performance / 2600 MHz
   cpufreq-policy63: performance / 2600 MHz
   cpufreq-policy64: performance / 2600 MHz
   cpufreq-policy65: performance / 2600 MHz
   cpufreq-policy66: performance / 2600 MHz
   cpufreq-policy67: performance / 2600 MHz
   cpufreq-policy68: performance / 2600 MHz
   cpufreq-policy69: performance / 2600 MHz
   cpufreq-policy6: performance / 2600 MHz
   cpufreq-policy70: performance / 2600 MHz
   cpufreq-policy71: performance / 2600 MHz
   cpufreq-policy72: performance / 2600 MHz
   cpufreq-policy73: performance / 2600 MHz
   cpufreq-policy74: performance / 2600 MHz
   cpufreq-policy75: performance / 2600 MHz
   cpufreq-policy76: performance / 2600 MHz
   cpufreq-policy77: performance / 2600 MHz
   cpufreq-policy78: performance / 2600 MHz
   cpufreq-policy79: performance / 2600 MHz
   cpufreq-policy7: performance / 2600 MHz
   cpufreq-policy8: performance / 2600 MHz
   cpufreq-policy9: performance / 2600 MHz

Status of performance related policies found below /sys:

   /sys/module/pcie_aspm/parameters/policy: [default] performance powersave powersupersave

### Clockspeeds (idle vs. heated up):

Before:

   cpu0 (Neoverse-N1): OPP: 2600, Measured: 2598 

After:

   cpu0 (Neoverse-N1): OPP: 2600, Measured: 2598 

### Performance baseline

 * memcpy: 11685.4 MB/s, memchr: 17699.9 MB/s, memset: 41559.2 MB/s
 * 16M latency: 50.04 45.62 50.98 45.66 51.05 46.65 48.53 51.87 
 * 128M latency: 124.9 122.0 124.8 122.1 124.9 118.2 116.2 111.6 
 * 7-zip MIPS (3 consecutive runs): 214253, 213711, 215215 (214390 avg), single-threaded: 3748
 * `aes-256-cbc     661734.81k  1140657.49k  1379542.70k  1451484.50k  1479644.50k  1482304.17k`
 * `aes-256-cbc     666252.28k  1145904.77k  1382941.10k  1452698.28k  1479494.31k  1482080.26k`

### PCIe and storage devices:

 * Renesas uPD720201 USB 3.0 Host: Speed 5GT/s (ok), Width x1 (ok), driver in use: xhci_hcd
 * Intel I210 Gigabit Network Connection: Speed 2.5GT/s (ok), Width x1 (ok), driver in use: igb
 * Mellanox MT2892 Family [ConnectX-6 Dx]: Speed 8GT/s (downgraded), Width x16 (ok), driver in use: mlx5_core
 * Mellanox MT2892 Family [ConnectX-6 Dx]: Speed 8GT/s (downgraded), Width x16 (ok), driver in use: mlx5_core
 * 238.5GB "Patriot M.2 P300 256GB" SSD as /dev/nvme0: Speed 8GT/s (ok), Width x4 (ok), 0% worn out, drive temp: 55°C
 * 238.5GB "Patriot M.2 P300 256GB" SSD as /dev/nvme1: Speed 8GT/s (ok), Width x4 (ok), 0% worn out, drive temp: 56°C

### Swap configuration:

 * /dev/nvme0n1p4: 15.4G (0K used)

### Software versions:

 * Ubuntu 22.04.2 LTS
 * Compiler: /usr/bin/gcc (Ubuntu 11.3.0-1ubuntu1~22.04.1) 11.3.0 / aarch64-linux-gnu

### Kernel info:

 * `/proc/cmdline: BOOT_IMAGE=/vmlinuz-5.15.0-75-generic root=UUID=70b695cc-47ed-495b-a657-e3e0c0c91eb2 ro mitigations=off net.ifnames=0 biosdevname=0`
 * Vulnerability Spectre v1:        Mitigation; __user pointer sanitization
 * Vulnerability Spectre v2:        Mitigation; CSV2, but not BHB
 * Kernel 5.15.0-75-generic / CONFIG_HZ=250

Kernel 5.15.0 is not latest 5.15.118 LTS that was released on 2023-06-21.

See https://endoflife.date/linux for details. It is somewhat likely that
a lot of exploitable vulnerabilities exist for this kernel as well as many
unfixed bugs.