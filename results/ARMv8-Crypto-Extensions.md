# ARMv8 Crypto Extensions

### Basics

SoC vendors who license ARMv8 cores (usually 64-bit capable) can decide between certain optional features: for example cryptographic acceleration called ['ARMv8 Cryptography Extensions'](https://developer.arm.com/documentation/ddi0500/e/CJHDEBAF).

Usually SoC vendors do, the only known exceptions are early Cortex-A53 SoCs like Qualcomm's Snapdragon 410, Amlogic's very first 64-bit SoC S905 (used only on ODROID-C2 and NanoPi K2), Phytium's FTC662 core and BroadCom's SoCs powering all 64-bit capable Raspberry Pis except BCM2712: those lack any crypto acceleration and perform way lower than all other 64-bit ARM SoCs in this area.

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
  * Cortex-A520: ~290, an A520 running at 1000 MHz will produce an ~290000k aes-256-cbc score (or ~580000k at 2000 MHz)
  * Cortex-A57: ~359, an A57 running at 1000 MHz will produce an ~359000k aes-256-cbc score (or ~718000k at 2000 MHz)
  * Cortex-A53/A55: ~467, A53/A55 running at 1000 MHz will produce an ~467000k aes-256-cbc score (or ~935000k at 2000 MHz)
  * Cortex-A72/A73/A76/A77/A78/X1: ~570, A72/A73/A76/A77/A78/X1 running at 1000 MHz will produce an ~570000k aes-256-cbc score (or ~1140000k at 2000 MHz)

Amazon's Graviton/Graviton2 ARM CPUs and Neoverse-N1 cores score identical to A72/A73/A76/A77/A78 and the custom FTC663 core inside the [Feiteng D2000 CPU](https://en.wikipedia.org/wiki/FeiTeng_(processor)#Future_processors) performs identical to an A57 ([another hint wrt similarity](https://github.com/martin-frbg/OpenBLAS/blob/b3b4672c30f613c0043ad0557d33a34ffa3bbd0d/kernel/arm64/KERNEL.FT2000)). NVidia's Carmel core performs marginally better than Cortex-A57 (~374, the Jetson Xavier NX numbers below). Qualcomm's Kryo Silver cores are based on A55 and perform exactly the same here while Qualcomm's Qualcomm Falkor V1 behaves like Cortex-A72 and onwards.

### Implications

Encryption/decryption performance with real-world tasks is an entirely different thing than looking at these results from a synthetic benchmark that runs completly inside the CPU cores/caches. Real performance with real use cases might look really different (e.g. full disk encryption or performance as a VPN gateway).

The `openssl speed -elapsed -evp aes-256-cbc` test is still more of a check whether crypto acceleration is available than a benchmark for real-world crypto performance. But if and only if ARMv8 Crypto Extensions have been licensed by an ARM SoC vendor simple conclusions can be drawn since there exists a fixed correlation between core type, clockspeed and `aes-256-cbc` score. So if we know that a new SoC features e.g. A55 cores, cheats with reported clockspeeds and we're not able to [measure clockspeeds](https://github.com/wtarreau/mhz) then we can use the openssl benchmark to guess real CPU clockspeeds. Vice versa should work too but it's better to [look up the CPU ID](https://github.com/ThomasKaiser/sbc-bench/blob/21d544d73c2055e42c71d980d78635766b005c73/sbc-bench.sh#L139-L282) instead.

All of this **only** applies to ARM SoCs with _ARMv8 Crypto Extensions_ licensed. Since otherwise scores thrown out by `openssl` depend heavily on compiler version/settings and even different code paths. Check out ODROID-C2 and RPi 4 'AES-256 (16 KB)' scores in [official results list](../Results.md): with C2 'modern OS' outperforms higher CPU clock and with RPi 4 comparing armhf userland (32-bit) and arm64 (64-bit) is even more telling since `openssl` reports less than 50% of 'AES performance' when running 64-bit compared to 32-bit since different code paths: generic C with 64-bit vs. optimized assembler routines with 32-bit.

### Numbers the aforementioned conclusions are based on

Crawling through [sbc-bench results collection](../Results.md) comparing ~100 different SoCs/CPUs from various vendors at various clockspeeds using OpenSSL versions 1.1.0f (25 May 2017) through 3.0.16 (11 Feb 2025) shows always the same relation between openssl score and clockspeed for the known core families (right column is OpenSSL's aes-256-cbc score divided through clockspeed in MHz):

| ARM core | MHz | aes-256-cbc | score/mhz |
| :----: | ----:  | :----:  | :----:  |
| Cortex-A35 | | | |
| [PX30](4IT1.txt) | 1235 | 268860 | 218 |
| [RK3308](4sNe.txt) | 1300 | 282030 | 217 |
| [S905Y4](4bbv.txt) | 2000 | 436550 | 218 |
| Apple Firestorm | | | |
| [M1 Pro](443N.txt) | 3030 | 1064110 | 351 |
| Cortex-A57 | | | |
| [Jetson Nano](1I4j.txt) | 1430 | 513700 | 359 |
| [Nintendo Switch](1Rnj.txt) | 1780| 642670 | 361 |
| [Jetson Nano](3Ufc.txt) | 2000 | 717500 | 358 |
| [Opteron A1100](4Kqn.txt) | 2000 | 720710 | 360 |
| [Nintendo Switch](3Di2.txt) | 2090 | 746680 | 357 |
| FTC663 | | | |
| [Phytium D2000](3Sl9.txt) | 2300 | 828520 | 360 |
| [Phytium FT-2000](4ioj.txt) | 2600 | 936740 | 360 |
| Carmel | | | |
| [Jetson Xavier NX](3YWp.txt) | 1890 | 706280 | 374 |
| Apple Icestorm/Avalanche | | | |
| [M1 Pro](443N.txt) | 2060 | 784430 | 381 |
| [M2 Pro](4sp4.txt) | 3500 | 1320470 | 377 |
| Qualcomm Kryo 3XX Gold | | | |
| [Snapdragon 845](4dJV.txt) | 2705 | 1059800 | 392 |
| Cortex-A53 | | | |
| [Armada 3700LP](1kt2.txt) | 790 | 368330 | 466 |
| [S912](1iJ7.txt) | 1000 | 466780 | 466 |
| [Allwinner A64](1tJg.txt) | 1050 | 491590 | 468 |
| [RK3328](1iGW.txt) | 1290 | 601200 | 466 |
| [Allwinner H5](2kTH.txt) | 1370 | 637980 | 465 |
| [RK3328](1iFx.txt) | 1380 | 644200 | 467 |
| [S5P6818](3GmP.txt) (64-bit.txt) | 1400 | 652554 | 466 |
| [S5P6818](1iyp.txt) (32-bit.txt) | 1400 | 651000 | 465 |
| [RTD1395](1Dt1.txt) | 1400 | 651460 | 465 |
| [S905X](3QLN.txt) | 1410 | 659460 | 467 |
| [S912](1iJ7.txt) | 1420 | 659603 | 464 |
| [i.MX8M Quad](27FC.txt) | 1500 | 695540 | 463 |
| [Allwinner H618](4CPF.txt) | 1510 | 705330 | 468 |
| [RK3399](3Q2q.txt) | 1510 | 706041 | 468 |
| [S905Y2](3JCm.txt) | 1800 | 838360 | 465 |
| [i.MX8M Quad](44Lq.txt) | 1800 | 839321 | 466 |
| [RK3399](2ICt.txt) | 1800| 839360 | 466 |
| [Allwinner H6](26Ph.txt) | 1800 | 839870 | 466 |
| [Allwinner H616](4bSf.txt) | 1800 | 840275 | 467 |
| [RK3576](8Qwk.txt) | 1980 | 925450 | 467 |
| [RK3528](4I93.txt) | 2000 | 933630 | 467 |
| [A311D](3VfL.txt) | 2010 | 940425 | 467 |
| [A311D2](3Wq0.txt) | 2010 | 941040 | 468 |
| [RK3576](8g-p.txt) | 2040 | 952220 | 467 |
| Cortex-A55 | | | |
| [RK3588](3XzI.txt) | 915 | 427750 | 467 |
| [RK3566](45X1.txt) | 1750 |  818550 | 467 |
| [Snapdragon 845](4dJV.txt) | 1760 | 824640 | 469 |
| [RK3588s](3XTA.txt) | 1780 | 830640 | 467 |
| [QRB5165](49kx.txt) | 1790 | 837220 | 468 |
| [Snapdragon 7c](4xEW.txt) | 1800 | 840140 | 467 |
| [RK3566](3rUb.txt) | 1810 | 845490 | 469 |
| [RK3588s](3XYo.txt) | 1815 | 846760 | 467 |
| [Snapdragon 835](4fdD.txt) | 1900 | 883330 | 465 |
| [S905X3](3Vdt.txt) | 1908 | 890730 | 466 |
| [RK3568](3Ug9.txt) | 1930 | 898610 | 465 |
| [RK3568](3UXa.txt) | 1950 | 911730 | 467 |
| [Qualcomm QCS6490](8WlQ.txt) | 1950 | 913300 | 468 |
| [Genio 1200](4Kvg.txt) | 2000 | 935000 | 468 |
| [UMS9620](4yFl.txt) | 2000 | 936310 | 468 |
| [S905X3](2kaS.txt) | 2010 | 941590 | 468 |
| [S905X3](3TQ2.txt) | 2100 | 981940 | 467 |
| Ampere-1a | | | |
| [AmpereOne A192-32X](XUpQ.txt) | 3200 | 1823250 | 570 |
| Cortex-A72 | | | |
| [Armada 8040](4zcm.txt) | 1600 | 909420 | 568 |
| [RK3399](1iWU.txt) | 1800 | 1023600 | 568 |
| [LX2160A](1ET3.txt) | 1900 | 1079480 | 568 |
| [TI J721E](4DLw.txt) | 2000 | 1130390 | 565 |
| [LX2160A](4ju5.txt) | 2000 | 1136690 | 568 |
| [RK3399](2yIx.txt) | 2010 | 1144950 | 569 |
| [RK3399](2ICt.txt) | 2088 | 1184306 | 567 |
| [RK3576](8Qwk.txt) | 2120 | 1205280 | 567 |
| [LX2160A](3Y4f.txt) | 2200 | 1251710 | 569 |
| [RK3576](8g-p.txt) | 2230 | 1267790 | 569 |
| [Amazon a1.xlarge](2iFY.txt) | 2300 | 1297960 | 564 |
| Cortex-A73 | | | |
| [S922X](1BsF.txt) | 1800 | 1024680 | 569 |
| [S922X](3MuT.txt) | 1900 | 1085350 | 571 |
| [A311D2](3Wq0.txt) | 2200 | 1252070 | 569 |
| [A311D](3VfL.txt) | 2400 | 1365900 | 569 |
| Cortex-A76 | | | |
| [RK3588](3XzI.txt) | 985 | 560200 | 569 |
| [UMS9620](4yFl.txt) | 2210 | 1258230 | 569 |
| [RK3588s](3XYo.txt) | 2330 | 1325370 | 569 |
| [BCM2712](4HDw.txt) | 2400 | 1367990 | 570 |
| [Snapdragon 7c](4xEW.txt) | 2550 | 1454480 | 570 |
| [BCM2712](4I1w.txt) | 3000 | 1710050 | 570 |
| Cortex-A77 | | | |
| [QRB5165](49kx.txt) | 2410 | 1348440 | 560 |
| [QRB5165](49kx.txt) | 2840 | 1598490 | 563 |
| Cortex-A78/A78C/A78AE | | | |
| [NVIDIA Orin](4Ebd.txt) | 1500 | 850750 | 567 |
| [Genio 1200](4Kvg.txt) | 2200 | 1240850 | 564 |
| [NVIDIA Orin](4ax9.txt) | 2200 | 1242940 | 565 |
| [Snapdragon 8cx Gen 3](4xwT.txt) | 2420 | 1365680 | 564 |
| [Qualcomm QCS6490](8WlQ.txt) | 2700 | 1539030 | 570 |
| Cortex-X1C | | | |
| [Snapdragon 8cx Gen 3](4xwT.txt) | 2990 | 1686160 | 564 |
| Qualcomm Falkor V1 | | | |
| [Snapdragon 835](4fea.txt) | 2360 | 1342240 | 569 |
| Phytium FTC862 | | | |
| [Phytium D3000](84GG.txt) | 2500 | 1425820 | 570 |
| Neoverse-N1 | | | |
| [Amazon m6g.8xlarge](2FrG.txt) | 2500 | 1424770 | 570 |
| [Ampere Altra Q80](4zkJ.txt) | 2600 | 1482190 | 570 |
| [Ampere Altra M96](4zGI.txt) | 2800 | 1596110 | 570 |
| [Ampere Altra Max](4kiu.txt) | 3000 | 1710010 | 570 |
| Cortex-A520 | | | |
| [Cix CD8180](88LE.txt) | 1800 | 520990 | 289 |
| Cortex-A720 | | | |
| [Cix CD8180](88LE.txt) | 2600 | 1458410 | 561 |
| Oryon X1 | | | |
| [Snapdragon X1E001DE](8SWL.txt) | 3800 | 2015260 | 530 |
| [Snapdragon X1E001DE](8SWL.txt) | 4300 | 2274190 | 529 |