# ARMv8 Crypto Extensions

### Basics

SoC vendors who license ARMv8 cores (usually 64-bit capable) can decide between certain optional features: for example cryptographic acceleration called ['ARMv8 Cryptography Extensions'](https://developer.arm.com/documentation/ddi0500/e/CJHDEBAF).

Usually SoC vendors do, the only known exceptions are early Cortex-A53 SoCs like Qualcomm's Snapdragon 410, Amlogic's very first 64-bit SoC S905 (used only on ODROID-C2 and NanoPi K2), Phytium's FTC662 core and BroadCom's SoCs powering all 64-bit capable Raspberry Pis: all lack any crypto acceleration and perform way lower than all other 64-bit ARM SoCs in this area.

If the kernel has been built correctly, availability of accelerated cryptography functions can be checked by querying `/proc/cpuinfo`: The 'Features' entry will additionally show `aes pmull sha1 sha2`.

### sbc-bench's use of OpenSSL

`sbc-bench` is using OpenSSL's internal AES benchmark as a _detection_ for crypto acceleration testing single-threaded through AES-128, AES-192 and AES-256. For the latter a benchmark run looks like this:

    openssl speed -elapsed -evp aes-256-cbc
    You have chosen to measure elapsed time instead of user CPU time.
    Doing aes-256-cbc for 3s on 16 size blocks: 63579690 aes-256-cbc's in 3.00s
    Doing aes-256-cbc for 3s on 64 size blocks: 34729604 aes-256-cbc's in 3.00s
    Doing aes-256-cbc for 3s on 256 size blocks: 11848770 aes-256-cbc's in 3.00s
    Doing aes-256-cbc for 3s on 1024 size blocks: 3221240 aes-256-cbc's in 3.00s
    Doing aes-256-cbc for 3s on 8192 size blocks: 419117 aes-256-cbc's in 3.00s
    Doing aes-256-cbc for 3s on 16384 size blocks: 209578 aes-256-cbc's in 3.00s
    ...
    The 'numbers' are in 1000s of bytes per second processed.
    type             16 bytes     64 bytes    256 bytes   1024 bytes   8192 bytes  16384 bytes
    aes-256-cbc     339091.68k   740898.22k  1011095.04k  1099516.59k  1144468.82k  1144575.32k

The results are '1000s of bytes per second processed' and we'll focus from now on only on most right column since not affected by initialization overhead (16K chunk size with a `1144575.32k` score in the example above). 

_ARMv8 Crypto Extensions_ are not a classic 'crypto engine' running at a fixed clock (like Marvell's CESA for example) but scale linearly with clockspeed. Also with the openssl benchmark it doesn't matter how DRAM configuration/performance looks like since the whole benchmark runs inside CPU caches and while OpenSSL uses userspace crypto the scores are identical regardless whether userland is `armhf` or `arm64` (see Samsung/Nexell S5P6818 numbers below). Distro used as well as OpenSSL version also don't seem to matter.

### Scores predictable based on CPU core and clockspeed

It all boils down to type of ARM core and CPU clockspeed since the ratio between openssl score and CPU clockspeed is fixed in the following way (using sbc-bench result collection):

  * Cortex-A35: ~217, an A35 running at 1000 MHz will produce an ~217000k aes-256-cbc score (or ~434000k at 2000 MHz)
  * Cortex-A57: ~359, an A57 running at 1000 MHz will produce an ~359000k aes-256-cbc score (or ~718000k at 2000 MHz)
  * Cortex-A53/A55: ~467, A53/A55 running at 1000 MHz will produce an ~467000k aes-256-cbc score (or ~935000k at 2000 MHz)
  * Cortex-A72/A73/A76/A77/A78: ~570, A72/A73/A76 running at 1000 MHz will produce an ~570000k aes-256-cbc score (or ~1140000k at 2000 MHz)

Amazon's Graviton/Graviton2 ARM CPUs and Neoverse-N1 cores score identical to A72/A73/A76/A77/A78 and the custom FTC663 core inside the [Feiteng D2000 CPU](https://en.wikipedia.org/wiki/FeiTeng_(processor)#Future_processors) performs identical to an A57 ([another hint wrt similarity](https://github.com/martin-frbg/OpenBLAS/blob/b3b4672c30f613c0043ad0557d33a34ffa3bbd0d/kernel/arm64/KERNEL.FT2000)). NVidia's Carmel core performs marginally better than Cortex-A57 (~374, the Jetson Xavier NX numbers below). Qualcomm's Kryo Silver cores are based on A55 and perform exactly the same here while Qualcomm's Qualcomm Falkor V1 behaves like Cortex-A72 and onwards.

### Implications

Encryption/decryption performance with real-world tasks is an entirely different thing than looking at these results from a synthetic benchmark that runs completly inside the CPU cores/caches. Real performance with real use cases might look really different (e.g. full disk encryption or performance as a VPN gateway).

The `openssl speed -elapsed -evp aes-256-cbc` test is still more of a check whether crypto acceleration is available than a benchmark for real-world crypto performance. But if and only if ARMv8 Crypto Extensions have been licensed by an ARM SoC vendor simple conclusions can be drawn since there exists a fixed correlation between core type, clockspeed and `aes-256-cbc` score. So if we know that a new SoC features e.g. A55 cores, cheats with reported clockspeeds and we're not able to [measure clockspeeds](https://github.com/wtarreau/mhz) then we can use the openssl benchmark to guess real CPU clockspeeds. Vice versa should work too but it's better to [look up the CPU ID](https://github.com/ThomasKaiser/sbc-bench/blob/21d544d73c2055e42c71d980d78635766b005c73/sbc-bench.sh#L139-L282) instead.

All of this **only** applies to ARM SoCs with _ARMv8 Crypto Extensions_ licensed. Since otherwise scores thrown out by `openssl` depend heavily on compiler version/settings and even different code paths. Check out ODROID-C2 and RPi 4 'AES-256 (16 KB)' scores in [official results list](../Results.md): with C2 'modern OS' outperforms higher CPU clock and with RPi 4 comparing armhf userland (32-bit) and arm64 (64-bit) is even more telling since `openssl` reports less than 50% of 'AES performance' when running 64-bit compared to 32-bit since different code paths: generic C with 64-bit vs. optimized assembler routines with 32-bit.

### Numbers the aforementioned conclusions are based on

Crawling through [sbc-bench results collection](../Results.md) comparing +30 different SoCs/CPUs from various vendors at various clockspeeds using OpenSSL versions 1.1.0f (25 May 2017) through 3.0.2 (15 Mar 2022) shows always the same relation between openssl score and clockspeed for those four core families (right column is OpenSSL's aes-256-cbc score divided through clockspeed in MHz):

| ARM core | MHz | aes-256-cbc | score/mhz |
| :----: | ----:  | :----:  | :----:  |
| Cortex-A35 | | | |
| [RK3308](http://ix.io/1XKY) | 1300 | 282290 | 217 |
| [S905Y4](http://ix.io/4bbv) | 2000 | 436550 | 218 |
| Apple Firestorm | | | |
| [M1 Pro](http://ix.io/443N) | 3030 | 1064110 | 351 |
| Cortex-A57 | | | |
| [Jetson Nano](http://ix.io/1I4j) | 1430 | 513700 | 359 |
| [Nintendo Switch](http://ix.io/1Rnj) | 1780| 642670 | 361 |
| [Jetson Nano](http://ix.io/3Ufc) | 2000 | 717500 | 358 |
| [Nintendo Switch](http://ix.io/3Di2) | 2090 | 746680 | 357 |
| FTC663 | | | |
| [Phytium D2000](http://ix.io/3Sl9) | 2300 | 828520 | 360 |
| Carmel | | | |
| [Jetson Xavier NX](http://ix.io/3YWp) | 1890 | 706280 | 374 |
| Apple Icestorm | | | |
| [M1 Pro](http://ix.io/443N) | 2060 | 784430 | 381 |
| Qualcomm Kryo 3XX Gold | | | |
| [Snapdragon 845](http://ix.io/4dJV) | 2705 | 1059800 | 392 |
| Cortex-A53 | | | |
| [Armada 3700LP](http://ix.io/1kt2) | 790 | 368330 | 466 |
| [S912](http://ix.io/1iJ7) | 1000 | 466780 | 466 |
| [Allwinner A64](http://ix.io/1tJg) | 1050 | 491590 | 468 |
| [RK3328](http://ix.io/1iGW) | 1290 | 601200 | 466 |
| [Allwinner H5](http://ix.io/2kTH) | 1370 | 637980 | 465 |
| [RK3328](http://ix.io/1iFx) | 1380 | 644200 | 467 |
| [S5P6818](http://ix.io/3GmP) (64-bit) | 1400 | 653770 | 466 |
| [S5P6818](http://ix.io/1iyp) (32-bit) | 1400 | 651000 | 465 |
| [RTD1395](http://ix.io/1Dt1) | 1400 | 651460 | 465 |
| [S905X](http://ix.io/3QLN) | 1410 | 659460 | 467 |
| [S912](http://ix.io/1iJ7) | 1420 | 659603 | 464 |
| [i.MX8M Quad](http://ix.io/27FC) | 1500 | 695540 | 463 |
| [RK3399](http://ix.io/2yIx) | 1510 | 695265 | 460 |
| [S905Y2](http://ix.io/3JCm) | 1800 | 838360 | 465 |
| [i.MX8M Quad](http://ix.io/44Lq) | 1800 | 839321 | 466 |
| [RK3399](http://ix.io/2ICt) | 1800| 839360 | 466 |
| [Allwinner H6](http://ix.io/26Ph) | 1800 | 839870 | 466 |
| [Allwinner H616](http://ix.io/4bSf) | 1800 | 840275 | 467 |
| [A311D](http://ix.io/3VfL) | 2010 | 940425 | 467 |
| [A311D2](http://ix.io/3Wq0) | 2010 | 941040 | 468 |
| Cortex-A55 | | | |
| [RK3588](http://ix.io/3XzI) | 915 | 427750 | 467 |
| [RK3566](http://ix.io/45X1) | 1750 |  818550 | 467 |
| [RK3588s](http://ix.io/3XTA) | 1780 | 830640 | 467 |
| [QRB5165](http://ix.io/49kx) | 1790 | 837220 | 468 |
| [RK3566](http://ix.io/3rUb) | 1810 | 845490 | 469 |
| [RK3588s](http://ix.io/3XYo) | 1815 | 846760 | 467 |
| [S905X3](http://ix.io/3Vdt) | 1908 | 890730 | 466 |
| [RK3568](http://ix.io/3Ug9) | 1930 | 898610 | 465 |
| [RK3568](http://ix.io/3UXa) | 1950 | 911730 | 467 |
| [S905X3](http://ix.io/2kaS) | 2010 | 941590 | 468 |
| [S905X3](http://ix.io/3TQ2) | 2100 | 981940 | 467 |
| [Snapdragon 835](http://ix.io/4fdD) | 1900 | 883330 | 465 |
| [Snapdragon 845](http://ix.io/4dJV) | 1760 | 824640 | 469 |
| Cortex-A72 | | | |
| [RK3399](http://ix.io/1iWU) | 1800 | 1023600 | 568 |
| [LX2160A](http://ix.io/1ET3) | 1900 | 1079480 | 568 |
| [RK3399](http://ix.io/2yIx) | 2010 | 1144950 | 569 |
| [RK3399](http://ix.io/2ICt) | 2088 | 1184306 | 567 |
| [LX2160A](http://ix.io/3Y4f) | 2200 | 1251710 | 569 |
| [Amazon a1.xlarge](http://ix.io/2iFY) | 2300 | 1297960 | 564 |
| Cortex-A73 | | | |
| [S922X](http://ix.io/1BsF) | 1800 | 1024680 | 569 |
| [S922X](http://ix.io/3MuT) | 1900 | 1085350 | 571 |
| [A311D2](http://ix.io/3Wq0) | 2200 | 1252070 | 569 |
| [A311D](http://ix.io/3VfL) | 2400 | 1365900 | 569 |
| Cortex-A76 | | | |
| [RK3588](http://ix.io/3XzI) | 985 | 560200 | 569 |
| [RK3588s](http://ix.io/3XYo) | 2330 | 1325370 | 569 |
| Cortex-A77 | | | |
| [QRB5165](http://ix.io/49kx) | 2410 | 1348440 | 560 |
| [QRB5165](http://ix.io/49kx) | 2840 | 1598490 | 563 |
| Cortex-A78AE | | | |
| [NVIDIA Orin](http://ix.io/4ax9) | 2200 | 1242940 | 565 |
| Qualcomm Falkor V1 | | | |
| [Snapdragon 835](http://ix.io/4fea) | 2360 | 1342240 | 569 |
| Neoverse-N1 | | | |
| [Ampere Altra](http://ix.io/4dsC) | 3000 | 1706150 | 569 |
| [Amazon m6g.8xlarge](http://ix.io/2FrG) | 2500 | 1424770 | 570 |


