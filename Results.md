# Results

Below some results collected. Please keep in mind that these are **NOT** hardware performance numbers but depend on software/settings (see the differences kernel version makes for RockPro64 for example). The purpose of `sbc-bench` is to generate insights and not colorful graphs representing numbers without meaning. It's perfectly fine for the same hardware appearing multiple times with different numbers since those differ for a reason (software/settings).

Especially *openssl* numbers should be taken with a huge grain of salt since the benchmark numbers depend on kernel features and performance with other use cases (e.g. disk/filesystem encryption) [might look  differently](https://forum.armbian.com/topic/7763-benchmarking-cpus/?do=findComment&comment=59235).

So do **not** rely on collected numbers unless you carefully read through all the explanations and insights below and be prepared to conduct your own benchmarks if you really want to choose appropriate hardware for **your** use case.

## Some numbers

*The below table is also available sorted: [7-zip multi-threaded](results/Sorted-Results.md#7-zip-mips-multi-threaded), [7-zip single-threaded](results/Sorted-Results.md#7-zip-mips-single-threaded), [aes-256-cbc](results/Sorted-Results.md#openssl-speed--elapsed--evp-aes-256-cbc), [memcpy](results/Sorted-Results.md#memcpy), [memset](results/Sorted-Results.md#memset) and [clockspeed](results/Sorted-Results.md#clockspeed).*

*ODROID-M1, Quartz64, R5S, ROCK 3A, ROCK 5B, RK3568-ROC-PC and Khadas VIM4 numbers are preliminary since software support situation for RK3566/RK3568/RK3588 and A311D2 is still in a very early stage. Same applies to all RISC-V numbers and [Apple M1 Pro](https://github.com/ThomasKaiser/sbc-bench/issues/47#issue-1300572558). Please also note that with RK35xx devices so far [measured clockspeeds differ from what's defined in device-tree due to PVTM](https://github.com/ThomasKaiser/Knowledge/blob/master/articles/Quick_Preview_of_ROCK_5B.md#pvtm).*

| Device / details | Clockspeed | Kernel | Distro | 7-zip multi | 7-zip single | AES | memcpy | memset | kH/s |
| ----- | :--------: | :----: | :----: | ----: | ------: | ------: | -----: | -----: | ---: |
| [Akaso M8S](http://ix.io/3R3N) | 1200 MHz | 5.10 | Buster armhf | 3050 | 885 | 32120 | 1160 | 3330 | - |
| [Amazon a1.xlarge](http://ix.io/2iFY) | 2300 MHz | 4.15 | Bionic arm64 | 8610 | 2406 | 1297960 | 4280 | 14220 | - |
| [AMedia X96 Max+](http://ix.io/3QOj) | 2100 MHz | 5.15 | Focal arm64 | 5270 | 1330 | 981830 | 2630 | 5150 | - |
| [Ampere A1](http://ix.io/4dsC) | 3000 MHz | 5.15 | Jammy arm64 | 16300 | 4009 | 1706150 | 11910 | 47780 | - |
| [Apple M1 Pro](http://ix.io/443N) | 3030/2060 MHz | 5.18 | Gentoo 2.8 arm64 | 43800 | 5010 | 1064450 | 27110 | 71910 | 48.28 |
| [BPi M2U](http://ix.io/4kmM) | 1200 MHz | 6.0 | Bullseye armhf | 2690 | 767 | 23320 | 780 | 3010 | - |
| [BPi M4](http://ix.io/1Dt1) | 1400 MHz | 4.9 | Bionic arm64 | 3500 | - | 651460 | 1010 | 4360 | 5.48 |
| [BPi R2](http://ix.io/4dO7) | 1300 MHz | 4.19 | Focal armhf | 2990 | 854 | 25260 | 1550 | 3220 | - |
| [Clearfog A1](http://ix.io/4d1U) | 1600 MHz | 5.15 | Bullseye armhf | 2230 | 1239 | 44080 | 910 | 5060 | - |
| [Clearfog CX](http://ix.io/4ju5) | 2000 MHz | 5.10 | Focal arm64 | 25260 | 2236 | 1136690 | 4460 | 12500 | - |
| [ClockworkPi R-01](http://ix.io/40BJ) | 1000 MHz | 5.4 | Focal riscv64 | 450 | 450 | 9040 | 1220 | 2640 | - |
| [Cubietruck](http://ix.io/3Naw) | 960 MHz | 5.10 | Bullseye armhf | 1030 | 541 | 18640 | 440 | 2010 | - |
| [Cubox-i4](http://ix.io/4132) | 980 MHz | 5.15 | Jammy armhf | 2360 | 657 | 27000 | 340 | 340 | - |
| [EspressoBin](http://ix.io/1kt2) | 800 MHz | 4.17 | Stretch arm64 | 1138 | 636 | 368330 | 1040 | 2490 | 1.23 |
| [EspressoBin](http://ix.io/1lCe) | 1200 MHz | 4.18 | Stretch arm64 | 1630 | 869 | 544240 | 1000 | 2400 | 1.82 |
| [Gigabyte H270-T70](http://ix.io/3N5c) | 2000 Mhz | 5.16 | Sid arm64 | 107180 | 1826 | 340750 | 4180 | 17130 | - |
| [Helios4](http://ix.io/1jCy) | 1600 MHz | 4.14 | Stretch armhf | 2210 | 1215 | 42500 &ast;98560 | 910 | 4840 | - |
| [Honeycomb LX2](http://ix.io/3Y4f) | 2200 MHz | 5.16 | **Fedora 35 aarch64** | 30690 | 2288 | 1251710 | 5050 | 16220 | 46.09 |
| [Huaqin P6410](http://ix.io/4kiu) | 3000 MHz | 5.4 | Focal arm64 | 430860 | 4211 | 1710010 | 13310 | 47970 | - |
| [Hugsun X99](http://ix.io/2ICt) | 2088/1800 MHz | 5.9 | Focal arm64 | 7710 | 1927 | 1184306 | 2270 | 5970 | - |
| [HummingBoard Pulse i.MX8M Quad](http://ix.io/27FC) | 1500 MHz | 4.19 | Buster arm64 | 4330 | 1201 | 695540 | 2230 | 9900 | - |
| [i.MX8MPlus EVK board](http://ix.io/4hx0) | 1800 MHz | 5.15 | Focal arm64 | 4990 | 1348 | 837680 | 2740 | 12420 | 7.02 |
| [Jetson AGX Orin](http://ix.io/4ax9) | 2200 MHz | 5.10 | Focal arm64 | 39450 | 3187 | 1242940 | 10600 | 30350 | 59.96 |
| [Jetson Nano](http://ix.io/1I4j) | 1430 MHz | 4.9 | Bionic arm64 | 5060 | 1473 | 513700 | 3680 | 8560 | 6.64 |
| [Jetson Nano](http://ix.io/3Ufc) | 2000 MHz | 4.9 | Bionic arm64 | 6260 | 1977 | 717500 | 4100 | 11760 | 8.72 |
| [Jetson Xavier AGX](http://ix.io/4ebH) | 2250 MHz | 4.9 | Bionic arm64 | 21590 | 2742 | 853250 | 10910 | 22520 | 26.57 |
| [Jetson Xavier NX](http://ix.io/3YWp) | 1890 MHz | 4.9 | Bionic arm64 | 13230 | 2201 | 706280 | 9190 | 18480 | - |
| [Kendryte K510](http://ix.io/41Qa) | 790 MHz | 4.17 | Sid riscv64 | 690 | 402 | 7410 | 280 | 440 | - |
| [Khadas Edge](http://ix.io/1rYm) | 2000/1500 MHz | 4.4 | Bionic arm64 | 6550 | 1721 | 1130400 | 2810 | 4860 | 10.50 |
| [Khadas Edge](http://ix.io/1uar) | 2000/1500 MHz | 4.4 | Stretch arm64 | 6600 | 1703 | 1127780 | 2860 | 4880 | 8.85 |
| [Khadas Edge2](http://ix.io/4a5U) | 2260/1800 MHz | 5.10 | Jammy arm64 | 16470 | 3096 | 1287490 | 10860 | 29110 | - |
| [Khadas VIM1](http://ix.io/4bee) | 1415 MHz | 5.1 | Buster arm64 | 3860 | 1136 | 660160 | 1940 | 5900 | - |
| [Khadas VIM1S](http://ix.io/4bbv) | 2000 MHz | 5.4 | Jammy arm64 | 4000 | 1148 | 436540 | 1970 | 7530 | - |
| [Khadas VIM2](http://ix.io/1ixi) | 1415/1000 MHz | 4.9 | **Xenial** arm64 | 4800 | 1128 | 659000 | 1690 | 5610 | - |
| [Khadas VIM2](http://ix.io/1iJ7) | 1415/1000 MHz | 4.17 | Bionic arm64 | 5450 | 993 | 659600 | 1920 | 5920 | 8.59 |
| [Khadas VIM3](http://ix.io/1MFD) | 2200/1800 MHz | 4.9 | Bionic arm64 | 8600 | 2026 | 1256910 | 4980 | 9300 | 13.12 |
| [Khadas VIM3](http://ix.io/3R2Z) | 2400/2015 MHz | 5.10 | Bullseye arm64 | 9650 | 2376 | 1366350 | 4850 | 7380 | - |
| [Khadas VIM3](http://ix.io/3VfL) | 2400/2015 MHz | 5.10 | Focal arm64 | 9760 | 2374 | 1365900 | 4840 | 8260 | - |
| [Khadas VIM3L](http://ix.io/26Wy) | 1900 MHz | 4.9 | Bionic arm64 | 5160 | 1399 | 892110 | 3670 | 6360 | 7.29 |
| [Khadas VIM3L](http://ix.io/3Vdt) | 1900 MHz | 5.16 | Bullseye arm64 | 5110 | 1403 | 890730 | 3700 | 5140 | - |
| [Khadas VIM4](http://ix.io/3Wvv) | 2200/1970 MHz | 5.4 | Focal arm64 | 12090 | 2081 | 1253200 | 7810 | 11600 | - |
| [Khadas VIM4](http://ix.io/4cHh) | 2200/2010 MHz | 5.4 | Jammy arm64 | 12120 | 2067 | 1254540 | 8180 | 11680 | - |
| [Le Potato](http://ix.io/1iSQ) | 1410 MHz | 4.18 | Stretch arm64 | 3780 | 1057 | 657200 | 1810 | 5730 | 3.92 |
| [LeMaker Banana Pi](http://ix.io/3PLr) | 960 MHz | 5.10 | Bullseye armhf | 1040 | 542 | 18640 | 440 | 2020 | - |
| [Libre Computer AML-S912-PC](http://ix.io/40cj) | 1415/1000 MHz | 5.15 | Bullseye arm64 | 5980 | 1012 | 659290 | 1650 | 5170 | - |
| [Lime A10](http://ix.io/1j1L) | 910 MHz | 4.14 | Stretch armhf | 550 | 550 | 28250 | 440 | 1300 | - |
| [Loongson-3A5000-HV](http://ix.io/4dzX) | 2500 MHz | 4.19 | Loongnix 20 loongarch64 | 11120 | 2990 | 116900 | 6930 | 19170 | - |
| [MangoPi Mcore](http://ix.io/4bSf) | 1800 MHz | 5.19 | Jammy arm64 | 4100 | 1218 | 840270 | 990 | 2380 | - |
| [Marvell PXA1908](http://ix.io/46hs) | 1245 MHz | 3.14 | Bullseye arm64 | 3180 | 951 | 581840 | 740 | 2220 | - |
| [MT6580 K9M1](http://ix.io/466y) | 1300 MHz | 5.19 | Sid armhf | 2930 | 860 | 25300 | 1250 | 3300 | - |
| [NanoPC T3+](http://ix.io/1iyp) | 1400 MHz | 4.4 | **Xenial armhf** | 6400 | 943 | 651000 | 1650 | 3700 | - |
| [NanoPC T3+](http://ix.io/1iRJ) | 1400 MHz | 4.14 | Bionic arm64 | 7480 | 1053 | 652600 | 1440 | 4540 | 10.99 |
| [NanoPC T4](http://ix.io/1iFz) | 1800/1400 MHz | 4.17 | Stretch arm64 | 6250 | 1809 | 1022500 | 4100 | 9000 | 8.24 |
| [NanoPC T4](http://ix.io/1iZq) | 1800/1400 MHz | 4.17 | Stretch arm64 | 6380 | 1741 | 1022600 | 4160 | 9000 | 9.36 |
| [NanoPC T4](http://ix.io/1iWU) | 1800/1400 MHz | 4.17 | Stretch arm64 | 6230 | 1756 | 1023600 | 4100 | 9060 | 10.30 |
| [NanoPC T4](http://ix.io/1lkG) | 2000/1500 MHz | 4.4 | Stretch arm64 | 5870 | 1336 | 1124040 | 2810 | 4890 | 8.70 |
| [NanoPi Fire3](http://ix.io/1jiU) | 1380 MHz | 4.14 | Stretch arm64 | 7420 | 1038 | 645400 | 1520 | 4570 | 8.53 |
| [NanoPi Fire3](http://ix.io/1jjm) | 1400 MHz | 4.14 | Bionic arm64 | 7440 | 1052 | 653000 | 1560 | 4600 | 10.96 |
| [NanoPi Fire3](http://ix.io/3ZxU) | 1400 MHz | 4.14 | Focal arm64 | 7350 | 1093 | 652640 | 1530 | 4590 | 11.18 |
| [NanoPi K1 Plus](http://ix.io/3N7H) | 1370 MHz | 5.10 | Focal arm64 | 3520 | 1022 | 638880 | 1070 | 3680 | 5.50 |
| [NanoPi K2](http://ix.io/1iT1) | 1480 MHz | 4.14 | Stretch arm64 | 3850 | 1095 | 50370 | 1660 | 3870 | 4.61 |
| [NanoPi K2](http://ix.io/3Qve) | 1480 MHz | 5.10 | Bullseye arm64 | 3880 | 1154 | 51490 | 1850 | 3790 | - |
| [NanoPi M1 Plus](http://ix.io/3N2z) | 1370 MHz | 4.19 | Bionic armhf | 3030 | 881 | 26660 | 830 | 3450 | - |
| [NanoPi M4](http://ix.io/1lzP) | 2000/1500 MHz | 4.19 | Stretch arm64 | 6400 | 1835 | 1128330 | 4080 | 8270 | 8.86 |
| [NanoPi M4v2](http://ix.io/3MAK) | 2015/1510 MHz | 5.10 | Bullseye arm64 | 6680 | 1855 | 921980 | 3110 | 7640 | - |
| [NanoPi NEO4](http://ix.io/1oho) | 2000/1500 MHz | 4.4| Stretch arm64 | 6510 | 1703 | 1128860 | 2260 | 4770 | 8.71 |
| [NanoPi NEO4](http://ix.io/1oib) | 2000/1500 MHz | 4.4| Stretch arm64 | 6030 | 1343 | 1121380 | 2230 | 4770 | 8.57 |
| [NanoPi NEO4](http://ix.io/1oim) | 2000/1500 MHz | 4.4| Stretch arm64 | 6520 | 1718 | 1123190 | 2280 | 4770 | 8.83 |
| [NanoPi NEO4](http://ix.io/1p3T) | 2000/1500 MHz | 4.19 | Stretch arm64 | 6750 | 1814 | 1139850 | 2370 | 6110 | 8.84 |
| [NanoPi NEO4](http://ix.io/3GmR) | 2016/1512 MHz | 5.10 | Focal arm64 | 6970 | 1906 | 1145030 | 2450 | 6190 | 11.36 |
| [NanoPi R5S](http://ix.io/4jfZ) | 1960 MHz | 6.1 | Bullseye arm64 | 5030 | 1482 | 914340 | 2990 | 5970 | 7.33 |
| [Nintendo Switch](http://ix.io/1Rnj) | 1780 MHz | 4.9 | **Fedora 30 arm-64** | 6170 | 1719 | 642670 | 2500 | 3570 | - |
| [Nintendo Switch](http://ix.io/3Di2) | 2060 MHz | 4.9 | Bionic arm64 | 6720 | 1901 | 746680 | 2370 | 3670 | 9.25 |
| [ODROID-C1](http://ix.io/4eg5) | 1500 MHz | 5.19 | Jammy armhf | 3010 | 878 | 29260 | 390 | 2910 | - |
| [ODROID-C2](http://ix.io/1ixI) | 1750 MHz | 3.14 | **Xenial** arm64 | 4070 | 1128 | 48500 | 1750 | 3100 | - |
| [ODROID-C2](http://ix.io/4hOp) | 1530 MHz | 5.19 | Jammy arm64 | 4020 | 1187 | 51390 | 1590 | 2730 | - |
| [ODROID-C4](http://ix.io/2kaS) | 2010 MHz | 4.9 | Focal arm64 | 5450 | 1459 | 941590 | 3310 | 6270 | 7.71 |
| [ODROID-C4](http://ix.io/3TQ2) | 2100 MHz | 5.10 | Buster arm64 | 5770 | 1679 | 981940 | 3540 | 5150 | - |
| [ODROID-HC4](http://ix.io/3Na5) | 2100 MHz | 5.10 | Buster arm64 | 5730 | 1672 | 980970 | 3540 | 5150 | - |
| [ODROID-M1](http://ix.io/3Ug9) | 1930 MHz | 4.19 | Focal arm64 | 5010 | 1450 | 898610 | 3070 | 6220 | 7.14 |
| [ODROID-M1](http://ix.io/4ijy) | 2060 MHz | 5.18 | Bullseye arm64 | 5430 | 1567 | 961090 | 3310 | 5960 | 7.76 |
| [ODROID-N2](http://ix.io/1BsF) | 1800/1900 MHz | 4.9 | Bionic arm64 | 8140 | 1669 | 1024680 | 4120 | 8610 | 11.39 |
| [ODROID-N2](http://ix.io/3MuT) | 2000/1900 MHz | 5.10 | Buster arm64 | 9090 | 2012 | 1085350 | 4260 | 9080 | - |
| [ODROID-N2+](http://ix.io/3R1a) | 2400/2015 MHz | 5.10 | Focal arm64 | 9680 | 2372 | 1366730 | 4030 | 7120 | - |
| [ODROID-N2+](http://ix.io/3DtN) | 2400/2015 MHz | 5.14 | Impish arm64 | 9790 | 2253 | 1366930 | 4300 | 7480 | - |
| [ODROID-N2+](http://ix.io/3LoH) | 2400/2015 MHz | 5.14 | Hirsute arm64 | 9780 | 2386 | 1366090 | 4030 | 7120 | - |
| [ODROID-XU4](http://ix.io/1ixL) | 1900/1400 MHz | 3.10 | **Jessie** armhf | 6750 | - | 68200 | 2200 | 4800 | - |
| [ODROID-XU4](http://ix.io/1iWL) | 2000/1400 MHz | 4.9 | Stretch armhf | 6400 | 1622 | 72075 | 2230 | 4850 | - |
| [ODROID-XU4](http://ix.io/3GnC) | 2000/1400 MHz | 5.4 | Focal armhf | 8980 | 1604 | 72020 | 2280 | 4910 | - |
| [Olimex A20-Lime2](http://ix.io/3EOw) | 960 MHz | 5.10 | Bullseye armhf | 1040 | 540 | 18670 | 460 | 2020 | - |
| [OnePlus 5](http://ix.io/4fdD) | 2360/1900 MHz | 6.1 | Jammy arm64 | 9800 | 2474 | 883330 | 9720 | 14070 | 12.58 |
| [Orange Pi PC Plus](http://ix.io/3MQV) | 1370 MHz | 5.10 | Focal armhf | 3060 | 879 | 26590 | 890 | 3450 | - |
| [Orange Pi PC 2](http://ix.io/3MQJ) | 1370 MHz | 5.10 | Focal arm64 | 3500 | 1023 | 637410 | 1070 | 3680 | - |
| [Orange Pi Plus 2](http://ix.io/1iX4) | 1300 MHz | 4.14 | Stretch armhf | 2890 | 812 | 25250 | 830 | 3240 | - |
| [Orange Pi Prime](http://ix.io/2kTH) | 1370 MHz | 5.4 | Buster | 3590 | 984 | 637980 | 1180 | 3540 | - |
| [Orange Pi Zero 2](http://ix.io/4knM) | 1510 MHz | 4.9 | Buster arm64 | 3550 | 1067 | 703300 | 1190 | 2820 | 5.01 |
| [Phytium FT-2000/4 1xSO-DIMM](http://ix.io/4ioj) | 2600 MHz | 5.15 | Bullseye arm64 | 10020 | 2755 | 936740 | 3760 | 14540 | - |
| [Phytium D2000 1xSO-DIMM](http://ix.io/445T) | 2300 MHz | 5.19 | Jammy arm64 | 16390 | 2220 | 827090 | 2820 | 6490 | - |
| [Phytium D2000 2xSO-DIMM](http://ix.io/446h) | 2300 MHz | 5.19 | Jammy arm64 | 16670 | 2252 | 828130 | 3480 | 16110 | - |
| [PineH64](http://ix.io/1jEr) | 1800 MHz | 4.18 | Stretch arm64 | 4650 | 1274 | 836900 | 1380 | 5530 | 5.62 |
| [PineH64](http://ix.io/26Ph) | 1800 MHz | 5.4 | Buster arm64 | 4710 | 1293 | 839870 | 1420 | 5560 | 7.10 |
| [Qualcomm QRB5165](http://ix.io/49kx) | 2840/2410/1790 MHz | 4.19 | Focal arm64 | 18860 | 3898 | 1598490 | 14470 | 23910 | 25.56 |
| [Qualcomm Snapdragon 8cx Gen 3](http://ix.io/4kEp) | 2980/? MHz | 5.15 | Jammy arm64 | 33600 | 4789 | 1679480 | 21010 | 41540 | 50.65 |
| [Quartz64](http://ix.io/3rUb) | 1810 MHz | 5.13 | Buster arm64 | 4840 | 1353 | 845490 | 2980 | 7650| - |
| [Radxa ROCK 3A](http://ix.io/40TX) | 2000 MHz | 5.18 | Bullseye arm64 | 5110 | 1450 | 935920 | 3150 | 6250 | 7.58 |
| [Radxa ROCK 5B](http://ix.io/41BH) | 2350/1830 MHz | 5.10 | Focal arm64 | 16450 | 3146 | 1337540 | 10830 | 29220 | 25.31 |
| [Radxa Zero](http://ix.io/3wZn) | 1800 MHz | 5.10 | Focal arm64 | 4610 | 1267 | 840080 | 1600 | 5370 | - |
| [Radxa Zero](http://ix.io/3PlT) | 1800 MHz | 5.10 | Buster arm64 | 4570 | 1373 | 839080 | 1610 | 5250 | 6.82 |
| [Radxa Zero](http://ix.io/3JCm) | 1800 MHz | 5.10 | Bullseye arm64 | 4580 | 1353 | 838360 | 1600 | 5360 | 7.13 |
| [Renegade](http://ix.io/1iFx) | 1400 MHz | 4.4 | Stretch arm64 | 3710 | 1069 | 644200 | 1565 | 7435 | 3.92 |
| [Raspberry Pi B](http://ix.io/3E7U) | 700 MHz | 5.10 | Raspberry Pi OS Buster | 310 | 310 | 11310 | 340 | 1400 | - |
| [Raspberry Pi B](http://ix.io/3MGN) | 700 MHz | 5.10 | Raspberry Pi OS Bullseye | 320 | 320 | 11630 | 360 | 1420 | - |
| [Raspberry Pi Zero](http://ix.io/3Njz) | 1000 MHz | 5.10 | Bullseye armv6l/armhf | 460 | 460 | 17060 | 430 | 1670 | - |
| [Raspberry Pi 2 B+](http://ix.io/1iFf) | 900 MHz | 4.14 | **Debian** Stretch | 2070 | 592 | 17450 | 615 | 1175 | - |
| [Raspberry Pi 2 B+](http://ix.io/3MGs) | 900 MHz | 5.10 | Raspberry Pi OS Bullseye | 2150 | 620 | 16500 | 1000 | 1180 | - |
| [Raspberry Pi 3 B](http://ix.io/4hOP) | 1200 MHz | 5.15 | Raspbian Sid | 2970 | 977 | 36230 | 1110 | 1700 | 2.89 |
| [Raspberry Pi 3 B+](http://ix.io/1iI5) | original | 4.9 | Raspbian Stretch | 3600 | 1076 | 42700 | 1230 | 1640 | - |
| [Raspberry Pi 3 B+](http://ix.io/1ism) | normal | 4.14 | Raspbian Stretch | 3240 | 914 | 36600 | 1130 | 1530 | - |
| [Raspberry Pi 3 B+](http://ix.io/1iGM) | normal | 4.14 | Raspbian Stretch | 3040 | 856 | 36600 | 1050 | 1500 | - |
| [Raspberry Pi 3 B+](http://ix.io/1iH0) | UV/normal | 4.14 | Raspbian Stretch | 2100 | 856 | 36400 | 1040 | 1460 | - |
| [Raspberry Pi 3 B+](http://ix.io/1iGz) | OC/normal | 4.14 | Raspbian Stretch | 3130 | 843 | 36620 | 1230 | 1780 | - |
| [Raspberry Pi 3 B+](http://ix.io/1isD) | with fan | 4.14 | Raspbian Stretch | 3670 | 1046 | 42600 | 1120 | 1600 | - |
| [Raspberry Pi Zero](http://ix.io/1niO) | 1000 MHz | 4.14 | Raspbian Stretch | 450 | 450 | 16820 | 400 | 1590 | - |
| [Raspberry Pi Zero 2](http://ix.io/3Dfo) | 600 MHz | 5.10 | Raspberry Pi OS Buster | 1900 | 529 | 18150 | 1040 | 1130 | - |
| [Raspberry Pi Zero 2](http://ix.io/3E85) | 1000 MHz | 5.10 | Raspberry Pi OS Buster | 3030 | 838 | 29860 | 1300 | 1570 | - |
| [Raspberry Pi Zero 2](http://ix.io/3DeL) | 1200 MHz | 5.10 | Raspberry Pi OS Buster | 3640 | 1007 | 36300 | 1320 | 1790 | - |
| [Raspberry Pi 4 B](http://ix.io/1MFf) | 1500 MHz | 4.19 | Raspbian Buster | 5500 | 1606 | 64860 | 2460 | 3170 | - |
| [Raspberry Pi 4 B](http://ix.io/3EgS) | 1500 MHz | 5.10 | Raspberry Pi OS Buster | 5750 | 1661 | 64930 | 2550 | 3430 | - |
| [Raspberry Pi 4 B](http://ix.io/3Gia) | 1800 MHz | 5.10 | Raspberry Pi OS Buster | 6550 | 1897 | 77830 | 2780 | 3080 | - |
| [Raspberry Pi 4 B](http://ix.io/3N94) | 1800 MHz | 5.10 | Raspberry Pi OS Bullseye | 5940 | 1738 | 77670 | 2310 | 2690 | - |
| [Raspberry Pi 4 B](http://ix.io/3F9C) | 1800 MHz | 5.10 | Raspberry Pi OS Buster **arm64** | 5760 | 1741 | 36240 | 2240 | 3120 | 9.46 |
| [Raspberry Pi 4 B](http://ix.io/3OBF) | 1800 MHz | 5.10 | Raspberry Pi OS Bullseye **arm64** | 5790 | 1769 | 36260 | 2330 | 3120 | 8.74 |
| [Raspberry Pi 4 B](http://ix.io/3InF) | 1800 MHz | 5.15 | Armbian **Jammy arm64** | 5640 | 1752 | 36260 | 2580 | 3110 | - |
| [Raspberry Pi 4 B](http://ix.io/3VME) | 1800 MHz | 5.15 | Jammy armhf | 6300 | 1844 | 82750 | 1190 | 3110 | - |
| [Raspberry Pi 400](http://ix.io/2Cyi) | 1800 MHz | 5.4 | Raspberry Pi OS Buster | 6550 | 1903 | 77890 | 2680 | 3110 | - |
| [RK3228A TV Box](http://ix.io/3M9F) | 1200 MHz | 4.4 | Buster armhf | 2310 | 710 | 23070 | 410 | 1230 | - |
| [RK3568-ROC-PC](http://ix.io/3Rsg) | 1960 MHz | 4.19 | Bullseye arm64 | 5040 | 1424 | 912800 | 3130 | 6240 | - |
| [RK3318 BOX](http://ix.io/4kor) | 1390 MHz | 6.0 | Jammy arm64 | 3200 | 867 | 644750 | 700 | 2460 | - |
| [Rock64](http://ix.io/1iGW) | 1300 MHz | 4.4 | Bionic arm64 | 3410 | 945 | 601200 | 1310 | 5680 | 4.46 |
| [Rock64](http://ix.io/1iH4) | 1300 MHz | 4.18 | Bionic arm64 | 3530 | 996 | 605250 | 1340 | 5770 | 4.65 |
| [Rock64](http://ix.io/1iHo) | 1300 MHz | 4.4 | Stretch arm64 | 3430 | 952 | 601000 | 1350 | 5680 | 3.64 |
| [Rock64](http://ix.io/1iHB) | 1300 MHz | 4.18 | Stretch arm64 | 3560 | 1002 | 603800 | 1340 | 5770 | 3.80 |
| [Rock64](http://ix.io/1iFm) | 1400 MHz | 4.4 | Stretch arm64 | 3610 | 1034 | 644250 | 1330 | 5700 | 3.85 |
| [Rock64](http://ix.io/1iZj) | 1400 MHz | 4.4 | Stretch arm64 | 3590 | 1030 | 643700 | 1320 | 5640 | 4.40 |
| [Rock64](http://ix.io/1iYK) | 1400 MHz | 4.4 | Stretch arm64 | 3580 | 1032 | 644380 | 1330 | 5680 | 4.63 |
| [Rock64](http://ix.io/1iwz) | 1400 MHz | 4.4 | Stretch **armhf** | 3620 | 1006 | 624000 | 1430 | 3620 | - |
| [Rock Pi 4](http://ix.io/21fX) | 2000/1500 MHz | 5.3 | Bionic arm64 | 6910 | 1817 | 1147370 | 3660 | 8310 | 10.71 |
| [Rock Pi 4](http://ix.io/3Q2q) | 2000/1500 MHz | 5.10 | Focal arm64 | 6900 | 1899 | 1146500 | 3430 | 8260 | - |
| [Rock Pi S](http://ix.io/1XKY) | 1300 MHz | 4.4 | Buster | 2590 | 716 | 282290 | 830 | 1880 | - |
| [RockPro64](http://ix.io/1lBC) | 1800/1400 MHz | 4.4 | Stretch arm64 | 6140 | 1580 | 1015600 | 2770 | 4850 | 8.14 |
| [RockPro64](http://ix.io/1iFZ) | 1800/1400 MHz | 4.4 | Stretch **armhf** | 6250 | 1809 | 1000150 | 2000 | 4835 | - |
| [RockPro64](http://ix.io/1ub9) | 1800/1400 MHz | 4.4 | Stretch arm64 | 6420 | 1673 | 1018480 | 3720 | 8400 | 8.24 |
| [RockPro64](http://ix.io/1iFp) | 1800/1400 MHz | 4.18 | Stretch arm64 | 6300 | 1755 | 1021500 | 3650 | 8450 | 8.20 |
| [RockPro64](http://ix.io/2sZH) | 2010/1510 MHz | 5.4 | Focal arm64 | 6920 | 1826 | 1145300 | 3700 | 8430 | 11.55 |
| [RockPro64](http://ix.io/2yIx) | 2010/1510 MHz | 5.8 | Bullseye arm64 | 7000 | 1833 | 1144950 | 3690 | 8360 | 11.08 |
| [Star64](http://ix.io/4a3s) | 1750 MHz | 5.15 | Sid riscv64 | 4820 | 1396 | 28970 | 1170 | 1120 | - |
| [SBC2D70 (SSD202D)](http://ix.io/3N1U) | 1700 MHz | 5.16 | Sid armhf | 1960 | 1094 | 33120 | 770 | 3190 | - |
| [T-HEAD C910 RVB-ICE](http://ix.io/41AB) | 1200 MHz | 5.10 | Sid riscv64 | 1760 | 1007 | 26930 | 3340 | 6470 | - |
| [Teres-I](http://ix.io/1tJg) | 1050 MHz | 4.19 | Stretch arm64 | 2785 | 780 | 491590 | 1080 | 2820 | - |
| [Tinkerboard](http://ix.io/1iSX) | 1730 MHz | 4.14 | Stretch armhf | 5350 | 1563 | 66600 | 1480 | 3900 | - |
| [Tinkerboard](http://ix.io/3Lir) | 1800 MHz | 4.4 | Buster armhf | 5440 | 1693 | 66300 | 1340 | 3510 | - |
| [Tinkerboard](http://ix.io/3X9q) | 1800 MHz | 5.10 | Buster armhf | 5770 | 1713 | 67060 | 1540 | 4110 | - |
| [TRONFY MXQ S805](http://ix.io/3MiR) | 1536 MHz | 5.10 | Focal armhf | 3100 | 897 | 29080 | 980 | 2990 | - |
| [Tronsmart MXIII Plus](http://ix.io/3S5U) | 1560 MHz | 5.10 | Buster armhf | 3880 | 1113 | 42570 | 1470 | 3430 | - |
| [Tronsmart S82](http://ix.io/41ML) | 1600 MHz | 5.14 | Focal armhf | 3640 | 1114 | 43150 | 500 | 3200 | - |
| [Ugoos UT2](http://ix.io/408h) | 1560 MHz | 5.10 | Jammy armhf | 3320 | 994 | 43250 | 320 | 2020 | - |
| [Atom N270](http://ix.io/461n) | 1600 MHz | 4.19 | Buster i386 | 1220 | 824 | 18760 | 1420 | 2840 | - |
| [Atom E3826](http://ix.io/44pd) | 1460 MHz | 5.18 | Jammy amd64 | 2140 | 1112 | 182190 | 2840 | 2760 | - |
| [AMD E-450 APU](http://ix.io/4hwl) | 1650 MHz | 5.15 | Jammy amd64 | 2430 | 1258 | 27450 | 1710 | 1740 | - |
| [x5-Z8300](http://ix.io/1lgD) | 1420 MHz | 4.9 | Stretch amd64 | 3900 | 950 | 178010 | 2380 | 2380 | 7.81 |
| [Celeron 5205U](http://ix.io/4eiM) | 1900 MHz | 5.15 | Jammy amd64 | 4060 | 2171 | 521090 | 7350 | 16020 | 11.20 |
| [x5-Z8300](http://ix.io/4j4o) | 1840 MHz | 5.15 | Jammy amd64 | 4430 | 1368 | 227030 | 2270 | 2380 | 8.84 |
| [x5-Z8350](http://ix.io/1HnC) | 1920/1680 MHz | 4.15 | Bionic amd64 | 4710 | 1272 | 207640 | 2740 | 3140 | - |
| [Athlon II X3 420e](http://ix.io/4eOo) | 2600 MHz | 4.19 | Buster amd64 | 4780 | 2566 | 98840 | 4120 | 3870 | - |
| [x5-Z8350](http://ix.io/2Jdb) | 1920/1680 MHz | 5.4 | Focal amd64 | 4790 | 1454 | 237230 | 3170 | 2960 | 9.38 |
| [Atom E3950](http://ix.io/4dd5) | 2000 MHz | 5.15 | Jammy amd64 | 6440 | 1636 | 374800 | 4400 | 4840 | - |
| [Celeron J1900](http://ix.io/4hKV) | 2415/1333 MHz | 5.4 | Focal amd64 | 6560 | 1806 | 34900 | 3780 | 3390 | - |
| [x7-Z8700](http://ix.io/4iDX) | 2400 MHz | 5.15 | Bullseye amd64 | 6580 | 1784 | 296680 | 3510 | 3580 | - |
| [Celeron J3455](http://ix.io/1m5p) | 2300/1500 MHz | 4.17 | Stretch amd64 | 7000 | 2037 | 429660 | 4090 | 4050 | 17.26 |
| [Pentium N4200](http://ix.io/1ngq) | 2560/1100 MHz | 4.14 | Bionic amd64 | 7469 | 1976 | 468008 | 4682 | 4997 | 18.75 |
| [Pentium J4205](http://ix.io/1m5t) | 2560/1500 MHz | 4.17 | Stretch amd64 | 7570 | 2146 | 480640 | 5070 | 5170 | 18.82 |
| [Ryzen R1606G](http://ix.io/2tQQ) | 2600/1400 MHz | 5.4 | Focal amd64 | 7970 | 2854 | 700780 | 8230 | 5970 | 16.45 |
| [Celeron N4100](http://ix.io/1uTS) | 2300/1100 MHz | 4.15 | Bionic amd64 | 8510 | 2222 | 669350 | 4750 | 5240 | 18.33 |
| [Celeron J4105](http://ix.io/1qal) | 2400/1500 MHz | 4.15 | Bionic amd64 | 9020 | 2290 | 697100 | 5500 | 7410 | 19.07 |
| [Celeron J4105](http://ix.io/1qb0) | 2400/1500 MHz | 4.15 | Bionic amd64 | 8960 | 2274 | 697080 | 5620 | 7650 | 19.13 |
| [Pentium J5005](http://ix.io/21rE) | 2700/1500 MHz | 5.0 | Bionic amd64 | 9230 | 2455 | 778360 | 5530 | 7130 | 20.74 |
| [Celeron N4500](http://ix.io/3HUU) | 2800/1100 MHz | 5.13 | Impish amd64 | 6300 | 3091 | 783840 | 8100 | 8350 | - |
| [Celeron N5100](http://ix.io/3IlQ) | 2800/1100 MHz | 5.13 | Focal amd64 | 10550 | 3088 | 783800 | 7750 | 8090 | 19.22 |
| [Pentium N6005](http://ix.io/4f3I) | 3300/2000 MHz | 6.0 | Jammy amd64 | 10810 | 3485 | 922000 | 9600 | 11300 | 20.15 |
| [Celeron N5105](http://ix.io/3Qf7) | 2900/2000 MHz | 5.13 | Focal amd64 | 11450 | 3059 | 811760 | 7710 | 9290 | 21.79 |
| [Pentium G4600](http://ix.io/2jVw) | 3600 MHz | 4.19 | Buster amd64 | 11810 | 4448 | 984820 | 15120 | 33380 | 21.88 |

&ast; Number obtained with cryptodev (Marvell's CESA).

## Explanations

* The *7-zip multi* number is an averaged **multi threaded** score from 3 consecutive `7z b` runs. Only relevant for server workloads where stuff happens in parallel and scales well with count of threads.
* The *7-zip single* number is a **single threaded** score measured on the fastest core of all available clusters.
* *AES* is a **single threaded** encryption score with rather huge chunks of data (`openssl speed -elapsed -evp aes-256-cbc`). On hybrid designs (big.LITTLE, DynamicIQ, Alder/Raptor Lake) numbers show big/performance core results. In case an ARM SoC supports ARMv8 Crypto Extensions [scores are pretty much predictable based on CPU clockspeeds](results/ARMv8-Crypto-Extensions.md).
* *memcpy* and *memset* are tinymembench measurements for memory bandwidth. On hybrid designs big/performance core results are shown. Both numbers are way overrated with regard to 'general performance', see for example the two `Phytium D2000` scores comparing single/dual channel memory and how much of bandwidth difference results in other numbers changing
* *kH/s* is a **multi threaded** cpuminer score showing the board's performance when executing NEON/SSE optimized code. To get the performance difference between big and little cores click the links in the left column
* The Akaso M8S and Tronsmart MXIII Plus numbers may be representative for other Amlogic S812 devices (quad Cortex-A9 @ 1.2/1.55 GHz), Tronsmart S82 for other S802 devices (quad Cortex-A9 @ 1.6 GHz)
* The Amazon a1.xlarge numbers represent a 1st gen Graviton CPU (64-bit 'ARM Neoverse') limited to four A72 cores and 8GB memory while the Ampere A1 numbers represent an Ampere Altra limited to four Neoverse-N1 cores.
* Cubietruck and 'LeMaker Banana Pi' numbers are more or less representative for all other Allwinner A20 devices, same with Lime for Allwinner A10, Olimex Teres-I for Allwinner A64, Orange Pi "PC Plus" and "Plus 2" for Allwinner H2+/H3 and NanoPi K1 Plus, Orange Pi "PC 2" and Prime for Allwinner H5, PineH64 for Allwinner H6, Orange Pi Zero 2 and MangoPi Mcore for Allwinner H616/H313 (though MangoPi clocking 300 MHz higher than usual). AMedia X96 Max+ numbers represent Amlogic S905X3 devices. OnePlus 5 scores may represent properly other Snapdragon 835 devices though in Oneplus some sort of throttling occured (15% drop in 7-zip scores within three consecutive multi-threaded runs) so other Snapdragon 835 devices might perform even better.
* Honeycomb LX2 numbers (based on SolidRun's CEx7 LX2160A COM) might vary somewhat with memory configuration but are more or less representative for LX2160A in general.
* Clearfog A1 and Helios4 use exactly same SoC (Armada 385) and clockspeeds and the only reason why OpenSSL numbers differ is since Helios4 numbers were made using [Marvell's CESA crypto accelerator via cryptodev](https://forum.armbian.com/topic/7763-benchmarking-cpus/?do=findComment&comment=59569) which provides nice speed improvements with larger block sizes but also some initialization overhead with tiny block sizes. Also CPU utilization is way lower so the SoC is free for other stuff while performing better at the same time.
* EspressoBin's boot BLOB claims to run at up to 1GHz while real clockspeeds are lower maxing out with this setting at 790MHz (obviously a kernel bug -- see [details](https://forum.armbian.com/topic/4089-espressobin-support-development-efforts/?do=findComment&comment=60082))
* Gigabyte H270-T70 numbers are for one [blade module equipped with two Cavium ThunderX CN8890 (48 cores each)](https://twitter.com/linux_chenxing/status/1449603003057532930). With different DRAM config/settings results vary (see [here](http://ix.io/3Owk) and [there](http://ix.io/3Owv)).
* [Huaqin P6410](https://solutions.amperecomputing.com/systems/altra/huaqin_P6410) numbers were made with a dual socket Ampere Altra Max setup and 12 DDR4 3200MT/s DIMMs.
* Hugsun X99 is an [overclocked RK3399 TV box](https://github.com/ThomasKaiser/sbc-bench/issues/20), just to show the effect of overclocking the A53 cores to 1.8 GHz and the A72 to 2.1 GHz on an RK3399.
* Jetson Nano was [properly powered with 5V/5A via barrel plug](https://forum.armbian.com/topic/9921-nvidia-jetson-nano/?do=findComment&comment=78467) (when powering through Micro USB the board enters a lower consumption/performance profile)
* Phytium D2000 consists of 8 [custom 64-bit ARMv8-compatible FTC663 cores](https://en.wikipedia.org/wiki/FeiTeng_(processor)). The 2 numbers above only differ by RAM config: one or two 16GB DDR4 SO-DIMMs. While memory bandwidth differs significantly latency does not and as such the `7-zip` benchmark is almost unaffected while the `openssl` test does not depend on memory performance by design. Though other tasks that are sensitive to memory bandwidth might benefit a lot from a dual channel memory config.
* NanoPi NEO4 numbers: 1st result is from my NEO4 N°1 running with a [NanoPi M4 image](https://github.com/armbian/build/blob/1c00822819f7fdfeac57bff8f991be526ca1add7/config/sources/rk3399.conf#L91). This NEO uses the vendor supplied thermal pad between SoC and heatsink. 2nd number from my 2nd NEO4 this time using NEO4 settings (`rk3399-nanopi4-rev04.dtb` loaded) with a copper shim between heatsink and SoC which as usual improves 'thermal performance' a lot. Since memory bandwidth and especially latency is too low another test needed with my NEO4 N°2, this time again with M4 settings (`rk3399-nanopi4-rev01.dtb` loaded) and an additional fan. Memory performance restored, slightly better performance due to colder SoC. 4th result made with 4.19.0-rc4. Please be aware that RK3399 memory performance numbers differ alot between 4.4 and mainline kernel for yet unknown reasons!
* ODROID-N2 number should be taken with a grain of salt since made with a [pretty early software stack](https://forum.armbian.com/topic/9619-announcement-odroid-n2/?do=findComment&comment=72764). Most probably scores will slightly improve over time. 'Overclocked' executions with both CPU clusters set to 2.0 GHz showed reliability issues most probably due to DVFS undervoltage (cpuminer quit almost immediately [here](http://ix.io/1BrG) while it ran only 50 seconds [there](http://ix.io/1Bsz) -- this tool since being a load generator checking for data corruption can also be used for reliability testing but I would prefer our [StabilityTester](https://github.com/ThomasKaiser/StabilityTester) instead)
* Rock Pi S is based on RK3308 Quad Cortex-A35 but the above numbers are not typical for A35 since the SoC design is severly limited: only a 16-bit RAM bus and 589MHz(*2) DDR clock in Rockchip’s DDR loader
* RPi 3 B+ performance shown as *original* was measured with an older ThreadX release (6e08617e7767b09ef97b3d6cee8b75eba6d7ee0b from Mar 13 2018). Back then the 3B+ was faster than the 3B. This changed with a newer ThreadX release (4800f08a139d6ca1c5ecbee345ea6682e2160881 from Jun 7 2018) since RPi Trading people decided to trash performance on every RPi 3 B+ to masquerade instability issues on a fraction of boards ([details](https://www.raspberrypi.org/forums/viewtopic.php?f=63&t=217056#p1334921))
* RPi 3 B+ performance numbers shown as *normal* were made with no or just a heatsink (in contrast to *with fan*)
* RPi 3 B+ marked as 'UV/normal' means: normal settings and average Micro USB cable resulting in **UV** (undervoltage). Once the demanding 7-zip benchmark started voltage dropped below 4.63V and 'frequency capping' (downclocking to 600 MHz) happened destroying performance. See the [detailed log](http://ix.io/1iH0): 1400 MHz are reported by the kernel while it's 600 MHz in reality. Is this just highly misleading or already cheating?
* RPi 3 B+ marked as 'OC/normal' means: **OC** (overclocked) settings, stable voltage but no fan used. Since SoC temperature exceeds 60°C the 'firmware' starts to cheat and downclocks to 1200 MHz while the kernel reports running at 1570 MHz. At least memory overclocking is somewhat effective.
* RPi 4 B numbers improved over time partly due to 'firmware' optimisations resulting in faster memory access (lower latency). Using a 64-bit kernel (`arm_64bit=1`) just takes away 50MB of RAM, the worst choice is to combine 64-bit kernel and 64-bit userland since everything relevant get slower, same tasks require much more memory and the device will start to swap if low on memory or even kill processes due to out of memory. As a rule of thumb you need almost twice as much RAM with a 64-bit userland compared to 32-bit with the same programs/services running.
* The highest clockspeeds listed for RPi 4/400 are 1800 MHz since this is what can be achieved with little overvoltage on early BCM2711B0 SoC revisions and is default _without overvolting_ on revision C0 or later. While it's possible to 'overclock' the RPi 4 to [2.15 GHz](http://ix.io/3Llk), [2.3 GHz](http://ix.io/3L37) and even [2.4 GHz](http://ix.io/3KVs) all of this requires overvolting the SoC up to `over_voltage=15`. Unfortunately the ThreadX DFVS ([Dynamic voltage and frequency scaling](https://developer.arm.com/documentation/100960/0100/Dynamic-Voltage-and-Frequency-Scaling)) implementation is rather primitive and as such this overvolting happens also when the CPU cores idle at low frequencies which pretty much fries the CPU cores all the time resulting in high(er) temperatures and consumption figures than necessary. That's why 1.8 GHz is considered the reasonable maximum here.
* Last RockPro64 entry has been made after ayufan solved memory performance problem with Rockchip's 4.4 kernel on his images (see [discussion](https://forum.khadas.com/t/painlessly-usable-linux-distro/3124/24?u=tkaiser))
* [SBC2D70](http://linux-chenxing.org/infinity2/ido-sbc2d70/) results are somewhat representative for [SigmaStar SSD201/SSD202D dual Cortex-A7](http://linux-chenxing.org/infinity2/#ssd201ssd202d) in general even though clockspeeds exceeding 1.3 GHz are considered boost frequencies and require appropriate cooling.
* The Snapdragon 8cx Gen 3 numbers were generated on a Windows Dev Kit 2023 inside WSL2 (Windows subsystem for Linux 2). As such they suffer from minimal virtualization overhead losses and a scheduler speciality pinning single-threaded tasks always to the fastest core available (Cortex-X1C). So we have almost correct multi-threaded scores but single-threaded those for the Cortex-A78C are missing.
* Ugoos UT2 might be representative for other RK3188 devices though memory performance with UT2 seems severely limited
* Vim2 is somewhat special: not a real big.LITTLE design but two A53 clusters controlled by a firmware BLOB that allows cluster 0 to clock up to 1414 MHz (reported falsely as 1512 MHz) and cluster 1 able to reach 1 GHz ([details](https://forum.khadas.com/t/cpu-frequency-up-to-2ghz/2010/23?u=tkaiser))
* All the RISC-V scores (ClockworkPi R-01 which scores identical to [Allwinner D1 Nezha](http://ix.io/4knR), Kendryte K510, Star64/JH7110, T-HEAD C910 RVB-ICE) suffer from missing software optimizations. For example the `openssl` benchmark is currently generic C on RISC-V vs. optimized assembler on ARM or even [ARMv8 Crypto Extensions](https://github.com/ThomasKaiser/sbc-bench/blob/master/results/ARMv8-Crypto-Extensions.md) or AES-NI on x64.
* x86 numbers are meant as comparison. Atom E3826 numbers were made with a [Minnowboard Turbot](https://www.minnowboard.org), x5-Z8300 numbers with an [UP Board](https://wiki.up-community.org/Hardware_Specification), 1st x5-Z8350 is an Atomic Pi and the 2nd a RockPi X, Celeron J3455 with an [ASRock J3455-ITX mainboard](https://forum.openmediavault.org/index.php/Thread/24093), Pentium N4200 on [UP2 Board](https://wiki.up-community.org/Hardware_Specification_UP2), Pentium J4205 on an [ASRock J4205-ITX](https://forum.openmediavault.org/index.php/Thread/24093-Efficient-low-cost-home-made-NAS/?postID=182578#post182578), Ryzen Embedded R1606G on [DFI GHF51 SBC](https://www.cnx-software.com/2020/08/10/amd-ryzen-embedded-sbc-review-with-ubuntu-20-04/), Celeron J4105 on two ODROID-H2 with different DDR4-PC19200 (2400MT/s) SO-DIMMs (remotely accessed via maze.odroid.com) and Celeron N4100 tested on an [ODROID-H2 engineering sample](https://forum.odroid.com/viewtopic.php?f=168&t=32911&p=239613#p239581) with single channel DRAM config, Pentium J5005 is in an [MINIX NEO J50C-4](https://www.cnx-software.com/2019/12/12/a-look-at-ubuntu-on-minix-neo-g41v-4-and-j50c-4-mini-pcs/), Pentium N6005 is an ODROID-H3 with dual-channel RAM, Pentium G4600 is inside a [TK Microserver MI106+](https://www.thomas-krenn.com/de/produkte/tower-systeme/silent-tower-server/microserver-mi106-plus.html).
* Both Jasper Lake numbers (N4500/N5100) were obtained using passively cooled Mini PC with only one DIMM. With dual channel memory (and better cooling in N5100's case) some scores might be significantly higher.

## Insights

* Benchmarking the Raspberry Pi is useless when not taking into account that there always is a primary operating system running on the primary CPU (VideoCore) that fully controls the hardware. ARM cores are just guests here. That's why `sbc-bench` starting with v0.2 also logs ThreadX version and configuration (/boot/config.txt).
* Looking at RPi 2 B+ numbers this is 2 times the same hardware, one time running latest Raspbian Stretch Lite and one time [OMV/Armbian](https://sourceforge.net/projects/openmediavault/files/Raspberry%20Pi%20images/). Userland is both times Debian Stretch but Raspbian packages are built for ARMv6 while upstream Debian builds for ARMv7 ([though with less effective compiler switches](https://forum.armbian.com/topic/1748-sbc-consumptionperformance-comparisons/?page=2)). Overall performance looks more or less the same except a very low `memcopy` bandwidth value with OMV. What's the reason since same ditro and kernel is used and same GCC to compile `tinymembench`? Is it firmware 'af8084725947aa2c7314172068f79dad9be1c8b4 from Apr 16 2018' vs. '47b05c853342eb6e4ea5b017d981e0ef247fb8be from Jul 3 2018'?
* Looking at RPi 3 B+ numbers it's obvious that 'firmware' version is the most important factor. With original firmware (6e08617e7767b09ef97b3d6cee8b75eba6d7ee0b from Mar 13 2018) performance is ok just to get trashed after applying firmware 4800f08a139d6ca1c5ecbee345ea6682e2160881 from Jun 7 2018 which totally changes throttling behaviour. From then on you either need a fan for good performance or add a `temp_soft_limit=` entry to the firmware config file (we can't have a look what all those partially undocumented settings really do since RPi's main operating system is closed source).
* `tinymembench` when executed on an A53 in an *armhf* userland compared to *arm64* seems to generate lower `memset` numbers (78% on RK3399 -- see [RockPro64 arm64](http://ix.io/1ivR) vs. [RockPro64 armhf](http://ix.io/1iFZ) -- and 64% on RK3328 -- see [Rock64 arm64](http://ix.io/1iFm) vs. [Rock64 armhf](http://ix.io/1iwz)). Status: needs further investigation and confirmation.
* Distro version doesn't seem to make a difference with `7-zip` scores. Applies to both *armhf* and *arm64* too -- see Rock64 numbers above.
* `7-zip` scores benefit slightly from memory performance (lower latency). See RK3328 equipped Renegade at 1.4 GHz with 4.4 kernel and Rock64 with same setup.
* `openssl` numbers are not affected by memory performance and are the same with same CPU cores and same clockspeeds. At least with Cortex-A53 running at 1.4 GHz with a Debian Stretch arm64 binary: Le Potato, NanoPi Fire3, Renegade, Rock64 and [RockPro64 with openssl pinned to an A53 core](http://ix.io/1ivR): ~96000k with AES-128/16bit and ~650000k with AES-256/16KB.
* It seems the combination arm64 Bionic with very recent kernel improves AES encryption results with small data chunks (less than 1KB -- see [Rock64 with 4.18 at 1.3GHz](http://ix.io/1iH4) and [Vim2 with 4.17 at 1.4GHz](http://ix.io/1iJ7) vs. [Rock64 with 4.4 at 1.3GHz](http://ix.io/1iGW)). Status: Needs further investigations (most probably related to GCC version).
* It seems running an *armhf* userland on 64-bit SoCs also improves AES encryption results with small data chunks (see *armhf* entries for NanoPC T3+, Rock64, RockPro64 and Vim2). Status: very interesting, needs further investigations.
* It seems running Xenial binaries even further improves AES/SSL performance when ARMv8 Crypto Extensions are available. Status: while interesting irrelevant, we should get rid of Xenial and Jessie numbers.
* It makes a huge difference whether ARMv8 Crypto Extensions can be used or not. See the many 64-bit SBC results above and compare with 32-bit SoCs or RPi 3B+, RPi 4B, ODROID-C2 and NanoPi K2 (the latter four basing on 64-bit ARMv8 SoCs without ARMv8 Crypto Extensions licensed).
* The used distribution makes a big difference with `cpuminer`. Libs and GCC versions obviously matter (GCC 9.3 on Focal vs. 8.3 on Buster vs. 7.3 on Bionic vs. 6.3 on Stretch -- [some benchmarks heavily depend on compiler versions](https://forum.armbian.com/topic/7763-benchmarking-cpus/?do=findComment&comment=58530)). Stretch with GCC 7.3 provides a 15% performance increase with cpuminer on RK3328 and RK3399 (see Rock64 and NanoPC T4 numbers above and there the logs to compare performance of big and little cores). With GCC 8.2 and Stretch it's 20% with RK3328 and even 25% with RK3399 (the A72 performance increasing more compared to the A53 cores -- check individual kH/s numbers in the logs). With Focal (GCC 9.3) it's even more, compare Rock Pi 4A with last RockPro64 entry or NanoPi Fire3 results.
* *(more to come soon)*

## The bigger picture

* To compare different hardware exactly the same software environment (apps, libs, compiler, kernel) is needed. Ignoring this will produce numbers without meaning.
* ARM's big cores (A15, A17, A57, A7x) perform a lot better than the little cores (A7, A53, A55). Everything that needs high **single threaded** performance will hugely benefit from running on such a core. This puts SoCs like RK3288 (Tinkerboard), Exynos 5244 (ODROID XU4), S922X/A311D/A311D2 or RK3399 and RK3588(s) in a better position. For the big.LITTLE/DynamicIQ designs a working HMP scheduler is mandatory since otherwise performance hungry tasks end up on a slow core. This is even true for [pseudo big.LITTLE like on the VIM2/S912](https://forum.khadas.com/t/s912-limited-to-1200-mhz-with-multithreaded-loads/2311/71?u=tkaiser).
* *7-zip's* benchmark still looks like a nice indicator for a 'server workloads' performance index (**multi threaded** tasks that do not rely on floating point arithmetics but partially on memory performance). Though these scores are totally irrelevant when it's about SBC use cases that focus on something different (e.g. a 'Desktop Linux' needing high single threaded CPU performance, HW accelerated GPU and VPU and also fast random IO on the rootfs)
* We see a huge variation in *tinymembench* numbers with some boards outperforming others by magnitudes while the effect in reality for CPU bound workloads is rather minimal though high memory bandwidth is a requirement for certain other tasks (e.g. playing 4K video). At least numbers are there to generate further insights.
* Identical SoCs perform more or less identical if 'environmental conditions' (clockspeeds) are the same -- see Renegade vs. Rock64 numbers or NanoPC T4 vs. RockPro64 or ODROID-C2 vs. NanoPi K2 or Rock 5B vs. Khadas Edge 2 (performance differences between RK3588(s) devices are mostly due to [DMC governor](https://github.com/ThomasKaiser/Knowledge/blob/master/articles/Quick_Preview_of_ROCK_5B.md#consumption) and [PVTM](https://github.com/ThomasKaiser/Knowledge/blob/master/articles/Quick_Preview_of_ROCK_5B.md#pvtm)).
* Same could be said for different Cortex-A cores. One A53 performs like the other as long as both run at the same clockspeed (with some exceptions most probably due to internal cache sizes -- see *cpuminer* numbers for Amlogic S905 vs. S905X/RK3328). With same count of cores you get similar performance (if the task(s) in question benefits from parallel execution).
* Cortex-A53 running at the same clockspeed as A7 shows almost ~30% better performance (~3500 7-zip MIPS vs. ~2700). This is even true when running ARMv7 code (see RPi 3 B+ numbers). In general it seems irrelevant whether the A53 cores run an *armhf* or *arm64* userland, some numbers are even higher when running *armhf* code. This is very interesting since there are scenarios where running an *armhf* userland results in [needing way less physical memory for the same task](https://github.com/nodesource/distributions/issues/375#issuecomment-290428448) while performing identical. Please note: it's about the userland (32-bit vs. 64-bit) and not kernel (64-bit of course).

## TODO

* On SoCs that contain an own crypto engine the *openssl* numbers above don't tell the whole truth ([userspace vs. in-kernel crypto](https://forum.armbian.com/topic/7763-benchmarking-cpus/?do=findComment&comment=59235)). It needs additional benchmarks to get an idea how CESA ([Clearfog/Helios4 with Armada 38x](https://forum.armbian.com/topic/2138-armbian-for-amlogic-s912/?do=findComment&comment=20949)), sun4i-ss ([Allwinner SoCs](http://sunxi.montjoie.ovh)), Samsung's Slim SSS ([ODROID XU4/HC1/HC2](https://wiki.odroid.com/odroid-xu4/software/disk_encryption)) or MediaTek's crypto accelerator ([BPi R2 / MT7623](https://forum.armbian.com/topic/5004-bpi-r2-board-bring-up/?do=findComment&comment=59037)) perform with real-world workloads like disk encryption.
