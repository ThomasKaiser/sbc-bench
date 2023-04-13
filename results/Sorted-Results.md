# sbc-bench results sorted

**WARNING: Do NOT blindly trust into these numbers without reading [the explanations](../Results.md#explanations) first!**

  * [7-zip multi-threaded](#7-zip-mips-multi-threaded)
  * [7-zip single-threaded](#7-zip-mips-single-threaded)
  * [aes-256-cbc](#openssl-speed--elapsed--evp-aes-256-cbc)
  * [memcpy](#memcpy)
  * [memset](#memset)
  * [clockspeed](#clockspeed)

## 7-zip MIPS multi-threaded

| Device / details | Clockspeed | Kernel | Distro | *7-zip multi* | 7-zip single | AES | memcpy | memset | kH/s |
| ----- | :--------: | :----: | :----: | ----: | ------: | ------: | -----: | -----: | ---: |
| [Huaqin P6410](http://ix.io/4kiu) | 3000 MHz | 5.4 | Focal arm64 | **430860** | 4211 | 1710010 | 13310 | 47970 | - |
| [Gigabyte H270-T70](http://ix.io/3N5c) | 2000 Mhz | 5.16 | Sid arm64 | **107180** | 1826 | 340750 | 4180 | 17130 | - |
| [Apple M1 Pro](http://ix.io/443N) | 3030/2060 MHz | 5.18 | Gentoo 2.8 arm64 | **43800** | 5010 | 1064450 | 27110 | 71910 | 48.28 |
| [Jetson AGX Orin](http://ix.io/4ax9) | 2200 MHz | 5.10 | Focal arm64 | **39450** | 3187 | 1242940 | 10600 | 30350 | 59.96 |
| [Qualcomm Snapdragon 8cx Gen 3](http://ix.io/4qG1) | 3000/2440 MHz | 6.2 | Kinetic arm64 | **35320** | 4283 | 1694260 | 17710 | 42110 | 42.76 |
| [Qualcomm Snapdragon 8cx Gen 3 (WSL2)](http://ix.io/4kEp) | 2980/? MHz | 5.15 | Jammy arm64 | **33600** | 4789 | 1679480 | 21010 | 41540 | 50.65 |
| [Honeycomb LX2](http://ix.io/3Y4f) | 2200 MHz | 5.16 | Fedora 35 aarch64 | **30690** | 2288 | 1251710 | 5050 | 16220 | 46.09 |
| [Clearfog CX](http://ix.io/4ju5) | 2000 MHz | 5.10 | Focal arm64 | **25260** | 2236 | 1136690 | 4460 | 12500 | - |
| [Jetson Xavier AGX](http://ix.io/4ebH) | 2250 MHz | 4.9 | Bionic arm64 | **21590** | 2742 | 853250 | 10910 | 22520 | 26.57 |
| [i3-N305](http://ix.io/4qpr) | 3800 MHz | 5.19 | Jammy amd64 | **20000** | 4398 | 1377280 | 9950 | 8990 | 41.43 |
| [Qualcomm QRB5165](http://ix.io/49kx) | 2840/2410/1790 MHz | 4.19 | Focal arm64 | **18860** | 3898 | 1598490 | 14470 | 23910 | 25.56 |
| [Phytium D2000 2xSO-DIMM](http://ix.io/446h) | 2300 MHz | 5.19 | Jammy arm64 | **16670** | 2252 | 828130 | 3480 | 16110 | - |
| [Khadas Edge2](http://ix.io/4a5U) | 2260/1800 MHz | 5.10 | Jammy arm64 | **16470** | 3096 | 1287490 | 10860 | 29110 | - |
| [Radxa ROCK 5B](http://ix.io/41BH) | 2350/1830 MHz | 5.10 | Focal arm64 | **16450** | 3146 | 1337540 | 10830 | 29220 | 25.31 |
| [Phytium D2000 1xSO-DIMM](http://ix.io/445T) | 2300 MHz | 5.19 | Jammy arm64 | **16390** | 2220 | 827090 | 2820 | 6490 | - |
| [Ampere A1](http://ix.io/4dsC) | 3000 MHz | 5.15 | Jammy arm64 | **16300** | 4009 | 1706150 | 11910 | 47780 | - |
| [Jetson Xavier NX](http://ix.io/3YWp) | 1890 MHz | 4.9 | Bionic arm64 | **13230** | 2201 | 706280 | 9190 | 18480 | - |
| [Khadas VIM4](http://ix.io/4cHh) | 2200/2010 MHz | 5.4 | Jammy arm64 | **12120** | 2067 | 1254540 | 8180 | 11680 | - |
| [Khadas VIM4](http://ix.io/3Wvv) | 2200/1970 MHz | 5.4 | Focal arm64 | **12090** | 2081 | 1253200 | 7810 | 11600 | - |
| [Pentium G4600](http://ix.io/2jVw) | 3600 MHz | 4.19 | Buster amd64 | **11810** | 4448 | 984820 | 15120 | 33380 | 21.88 |
| [Celeron N5105](http://ix.io/3Qf7) | 2900/2000 MHz | 5.13 | Focal amd64 | **11450** | 3059 | 811760 | 7710 | 9290 | 21.79 |
| [Loongson-3A5000-HV](http://ix.io/4dzX) | 2500 MHz | 4.19 | Loongnix 20 loongarch64 | **11120** | 2990 | 116900 | 6930 | 19170 | - |
| [Pentium N6005](http://ix.io/4f3I) | 3300/2000 MHz | 6.0 | Jammy amd64 | **10810** | 3485 | 922000 | 9600 | 11300 | 20.15 |
| [Celeron N5100](http://ix.io/3IlQ) | 2800/1100 MHz | 5.13 | Focal amd64 | **10550** | 3088 | 783800 | 7750 | 8090 | 19.22 |
| [Phytium FT-2000/4 1xSO-DIMM](http://ix.io/4ioj) | 2600 MHz | 5.15 | Bullseye arm64 | **10020** | 2755 | 936740 | 3760 | 14540 | - |
| [OnePlus 5](http://ix.io/4fdD) | 2360/1900 MHz | 6.1 | Jammy arm64 | **9800** | 2474 | 883330 | 9720 | 14070 | 12.58 |
| [ODROID-N2+](http://ix.io/3DtN) | 2400/2015 MHz | 5.14 | Impish arm64 | **9790** | 2253 | 1366930 | 4300 | 7480 | - |
| [ODROID-N2+](http://ix.io/4rWn) | 2400/2015 MHz | 6.1 | Bullseye arm64 | **9710** | 2373 | 1366180 | 4220 | 7720 | - |
| [ODROID-N2+](http://ix.io/3R1a) | 2400/2015 MHz | 5.10 | Focal arm64 | **9680** | 2372 | 1366730 | 4030 | 7120 | - |
| [Khadas VIM3](http://ix.io/4o1A) | 2400/2015 MHz | 6.0 | Bullseye arm64 | **9650** | 2379 | 1366300 | 5080 | 9240 | - |
| [Khadas VIM3](http://ix.io/3R2Z) | 2400/2015 MHz | 5.10 | Bullseye arm64 | **9650** | 2376 | 1366350 | 4850 | 7380 | - |
| [Pentium J5005](http://ix.io/21rE) | 2700/1500 MHz | 5.0 | Bionic amd64 | **9230** | 2455 | 778360 | 5530 | 7130 | 20.74 |
| [ODROID-N2](http://ix.io/3MuT) | 2000/1900 MHz | 5.10 | Buster arm64 | **9090** | 2012 | 1085350 | 4260 | 9080 | - |
| [Celeron J4105](http://ix.io/1qal) | 2400/1500 MHz | 4.15 | Bionic amd64 | **9020** | 2290 | 697100 | 5500 | 7410 | 19.07 |
| [ODROID-XU4](http://ix.io/3GnC) | 2000/1400 MHz | 5.4 | Focal armhf | **8980** | 1604 | 72020 | 2280 | 4910 | - |
| [Celeron J4105](http://ix.io/1qb0) | 2400/1500 MHz | 4.15 | Bionic amd64 | **8960** | 2274 | 697080 | 5620 | 7650 | 19.13 |
| [Amazon a1.xlarge](http://ix.io/2iFY) | 2300 MHz | 4.15 | Bionic arm64 | **8610** | 2406 | 1297960 | 4280 | 14220 | - |
| [Khadas VIM3](http://ix.io/1MFD) | 2200/1800 MHz | 4.9 | Bionic arm64 | **8600** | 2026 | 1256910 | 4980 | 9300 | 13.12 |
| [Celeron N4100](http://ix.io/1uTS) | 2300/1100 MHz | 4.15 | Bionic amd64 | **8510** | 2222 | 669350 | 4750 | 5240 | 18.33 |
| [ODROID-N2](http://ix.io/1BsF) | 1800/1900 MHz | 4.9 | Bionic arm64 | **8140** | 1669 | 1024680 | 4120 | 8610 | 11.39 |
| [Ryzen R1606G](http://ix.io/2tQQ) | 2600/1400 MHz | 5.4 | Focal amd64 | **7970** | 2854 | 700780 | 8230 | 5970 | 16.45 |
| [Hugsun X99](http://ix.io/2ICt) | 2088/1800 MHz | 5.9 | Focal arm64 | **7710** | 1927 | 1184306 | 2270 | 5970 | - |
| [Pentium J4205](http://ix.io/1m5t) | 2560/1500 MHz | 4.17 | Stretch amd64 | **7570** | 2146 | 480640 | 5070 | 5170 | 18.82 |
| [NanoPC T3+](http://ix.io/1iRJ) | 1400 MHz | 4.14 | Bionic arm64 | **7480** | 1053 | 652600 | 1440 | 4540 | 10.99 |
| [Pentium N4200](http://ix.io/1ngq) | 2560/1100 MHz | 4.14 | Bionic amd64 | **7469** | 1976 | 468008 | 4682 | 4997 | 18.75 |
| [NanoPi Fire3](http://ix.io/1jjm) | 1400 MHz | 4.14 | Bionic arm64 | **7440** | 1052 | 653000 | 1560 | 4600 | 10.96 |
| [NanoPi Fire3](http://ix.io/1jiU) | 1380 MHz | 4.14 | Stretch arm64 | **7420** | 1038 | 645400 | 1520 | 4570 | 8.53 |
| [NanoPi Fire3](http://ix.io/3ZxU) | 1400 MHz | 4.14 | Focal arm64 | **7350** | 1093 | 652640 | 1530 | 4590 | 11.18 |
| [RockPro64](http://ix.io/2yIx) | 2010/1510 MHz | 5.8 | Bullseye arm64 | **7000** | 1833 | 1144950 | 3690 | 8360 | 11.08 |
| [Celeron J3455](http://ix.io/1m5p) | 2300/1500 MHz | 4.17 | Stretch amd64 | **7000** | 2037 | 429660 | 4090 | 4050 | 17.26 |
| [NanoPi NEO4](http://ix.io/3GmR) | 2016/1512 MHz | 5.10 | Focal arm64 | **6970** | 1906 | 1145030 | 2450 | 6190 | 11.36 |
| [RockPro64](http://ix.io/2sZH) | 2010/1510 MHz | 5.4 | Focal arm64 | **6920** | 1826 | 1145300 | 3700 | 8430 | 11.55 |
| [Rock Pi 4](http://ix.io/21fX) | 2000/1500 MHz | 5.3 | Bionic arm64 | **6910** | 1817 | 1147370 | 3660 | 8310 | 10.71 |
| [Rock Pi 4](http://ix.io/3Q2q) | 2000/1500 MHz | 5.10 | Focal arm64 | **6900** | 1899 | 1146500 | 3430 | 8260 | - |
| [ODROID-XU4](http://ix.io/1ixL) | 1900/1400 MHz | 3.10 | Jessie armhf | **6750** | - | 68200 | 2200 | 4800 | - |
| [NanoPi NEO4](http://ix.io/1p3T) | 2000/1500 MHz | 4.19 | Stretch arm64 | **6750** | 1814 | 1139850 | 2370 | 6110 | 8.84 |
| [Nintendo Switch](http://ix.io/3Di2) | 2060 MHz | 4.9 | Bionic arm64 | **6720** | 1901 | 746680 | 2370 | 3670 | 9.25 |
| [NanoPi M4v2](http://ix.io/3MAK) | 2015/1510 MHz | 5.10 | Bullseye arm64 | **6680** | 1855 | 921980 | 3110 | 7640 | - |
| [Khadas Edge](http://ix.io/1uar) | 2000/1500 MHz | 4.4 | Stretch arm64 | **6600** | 1703 | 1127780 | 2860 | 4880 | 8.85 |
| [x7-Z8700](http://ix.io/4iDX) | 2400 MHz | 5.15 | Bullseye amd64 | **6580** | 1784 | 296680 | 3510 | 3580 | - |
| [Celeron J1900](http://ix.io/4hKV) | 2415/1333 MHz | 5.4 | Focal amd64 | **6560** | 1806 | 34900 | 3780 | 3390 | - |
| [Raspberry Pi 400](http://ix.io/2Cyi) | 1800 MHz | 5.4 | Raspberry Pi OS Buster | **6550** | 1903 | 77890 | 2680 | 3110 | - |
| [Raspberry Pi 4 B](http://ix.io/3Gia) | 1800 MHz | 5.10 | Raspberry Pi OS Buster | **6550** | 1897 | 77830 | 2780 | 3080 | - |
| [Khadas Edge](http://ix.io/1rYm) | 2000/1500 MHz | 4.4 | Bionic arm64 | **6550** | 1721 | 1130400 | 2810 | 4860 | 10.50 |
| [NanoPi NEO4](http://ix.io/1oim) | 2000/1500 MHz | 4.4| Stretch arm64 | **6520** | 1718 | 1123190 | 2280 | 4770 | 8.83 |
| [NanoPi NEO4](http://ix.io/1oho) | 2000/1500 MHz | 4.4| Stretch arm64 | **6510** | 1703 | 1128860 | 2260 | 4770 | 8.71 |
| [Atom E3950](http://ix.io/4dd5) | 2000 MHz | 5.15 | Jammy amd64 | **6440** | 1636 | 374800 | 4400 | 4840 | - |
| [RockPro64](http://ix.io/1ub9) | 1800/1400 MHz | 4.4 | Stretch arm64 | **6420** | 1673 | 1018480 | 3720 | 8400 | 8.24 |
| [ODROID-XU4](http://ix.io/1iWL) | 2000/1400 MHz | 4.9 | Stretch armhf | **6400** | 1622 | 72075 | 2230 | 4850 | - |
| [NanoPi M4](http://ix.io/1lzP) | 2000/1500 MHz | 4.19 | Stretch arm64 | **6400** | 1835 | 1128330 | 4080 | 8270 | 8.86 |
| [NanoPC T3+](http://ix.io/1iyp) | 1400 MHz | 4.4 | Xenial armhf | **6400** | 943 | 651000 | 1650 | 3700 | - |
| [NanoPC T4](http://ix.io/1iZq) | 1800/1400 MHz | 4.17 | Stretch arm64 | **6380** | 1741 | 1022600 | 4160 | 9000 | 9.36 |
| [RockPro64](http://ix.io/1iFp) | 1800/1400 MHz | 4.18 | Stretch arm64 | **6300** | 1755 | 1021500 | 3650 | 8450 | 8.20 |
| [Raspberry Pi 4 B](http://ix.io/3VME) | 1800 MHz | 5.15 | Jammy armhf | **6300** | 1844 | 82750 | 1190 | 3110 | - |
| [Celeron N4500](http://ix.io/3HUU) | 2800/1100 MHz | 5.13 | Impish amd64 | **6300** | 3091 | 783840 | 8100 | 8350 | - |
| [Jetson Nano](http://ix.io/3Ufc) | 2000 MHz | 4.9 | Bionic arm64 | **6260** | 1977 | 717500 | 4100 | 11760 | 8.72 |
| [RockPro64](http://ix.io/1iFZ) | 1800/1400 MHz | 4.4 | Stretch armhf | **6250** | 1809 | 1000150 | 2000 | 4835 | - |
| [NanoPC T4](http://ix.io/1iFz) | 1800/1400 MHz | 4.17 | Stretch arm64 | **6250** | 1809 | 1022500 | 4100 | 9000 | 8.24 |
| [NanoPC T4](http://ix.io/1iWU) | 1800/1400 MHz | 4.17 | Stretch arm64 | **6230** | 1756 | 1023600 | 4100 | 9060 | 10.30 |
| [Nintendo Switch](http://ix.io/1Rnj) | 1780 MHz | 4.9 | Fedora 30 arm-64 | **6170** | 1719 | 642670 | 2500 | 3570 | - |
| [RockPro64](http://ix.io/1lBC) | 1800/1400 MHz | 4.4 | Stretch arm64 | **6140** | 1580 | 1015600 | 2770 | 4850 | 8.14 |
| [NanoPi NEO4](http://ix.io/1oib) | 2000/1500 MHz | 4.4| Stretch arm64 | **6030** | 1343 | 1121380 | 2230 | 4770 | 8.57 |
| [Libre Computer AML-S912-PC](http://ix.io/40cj) | 1415/1000 MHz | 5.15 | Bullseye arm64 | **5980** | 1012 | 659290 | 1650 | 5170 | - |
| [Raspberry Pi 4 B](http://ix.io/3N94) | 1800 MHz | 5.10 | Raspberry Pi OS Bullseye | **5940** | 1738 | 77670 | 2310 | 2690 | - |
| [NanoPC T4](http://ix.io/1lkG) | 2000/1500 MHz | 4.4 | Stretch arm64 | **5870** | 1336 | 1124040 | 2810 | 4890 | 8.70 |
| [Raspberry Pi 4 B](http://ix.io/3OBF) | 1800 MHz | 5.10 | Raspberry Pi OS Bullseye arm64 | **5790** | 1769 | 36260 | 2330 | 3120 | 8.74 |
| [Tinkerboard](http://ix.io/3X9q) | 1800 MHz | 5.10 | Buster armhf | **5770** | 1713 | 67060 | 1540 | 4110 | - |
| [ODROID-C4](http://ix.io/3TQ2) | 2100 MHz | 5.10 | Buster arm64 | **5770** | 1679 | 981940 | 3540 | 5150 | - |
| [Raspberry Pi 4 B](http://ix.io/3F9C) | 1800 MHz | 5.10 | Raspberry Pi OS Buster arm64 | **5760** | 1741 | 36240 | 2240 | 3120 | 9.46 |
| [Raspberry Pi 4 B](http://ix.io/3EgS) | 1500 MHz | 5.10 | Raspberry Pi OS Buster | **5750** | 1661 | 64930 | 2550 | 3430 | - |
| [ODROID-HC4](http://ix.io/3Na5) | 2100 MHz | 5.10 | Buster arm64 | **5730** | 1672 | 980970 | 3540 | 5150 | - |
| [Raspberry Pi 4 B](http://ix.io/3InF) | 1800 MHz | 5.15 | Armbian Jammy arm64 | **5640** | 1752 | 36260 | 2580 | 3110 | - |
| [Raspberry Pi 4 B](http://ix.io/1MFf) | 1500 MHz | 4.19 | Raspbian Buster | **5500** | 1606 | 64860 | 2460 | 3170 | - |
| [ODROID-C4](http://ix.io/2kaS) | 2010 MHz | 4.9 | Focal arm64 | **5450** | 1459 | 941590 | 3310 | 6270 | 7.71 |
| [Khadas VIM2](http://ix.io/1iJ7) | 1415/1000 MHz | 4.17 | Bionic arm64 | **5450** | 993 | 659600 | 1920 | 5920 | 8.59 |
| [Tinkerboard](http://ix.io/3Lir) | 1800 MHz | 4.4 | Buster armhf | **5440** | 1693 | 66300 | 1340 | 3510 | - |
| [ODROID-M1](http://ix.io/4ijy) | 2060 MHz | 5.18 | Bullseye arm64 | **5430** | 1567 | 961090 | 3310 | 5960 | 7.76 |
| [Tinkerboard](http://ix.io/1iSX) | 1730 MHz | 4.14 | Stretch armhf | **5350** | 1563 | 66600 | 1480 | 3900 | - |
| [AMedia X96 Max+](http://ix.io/3QOj) | 2100 MHz | 5.15 | Focal arm64 | **5270** | 1330 | 981830 | 2630 | 5150 | - |
| [Jetson Nano](http://ix.io/4rLX) | 1480 MHz | 4.9 | Bullseye arm64 | **5260** | 1578 | 531940 | 3730 | 8870 | - |
| [Khadas VIM3L](http://ix.io/26Wy) | 1900 MHz | 4.9 | Bionic arm64 | **5160** | 1399 | 892110 | 3670 | 6360 | 7.29 |
| [Radxa ROCK 3A](http://ix.io/40TX) | 2000 MHz | 5.18 | Bullseye arm64 | **5110** | 1450 | 935920 | 3150 | 6250 | 7.58 |
| [Khadas VIM3L](http://ix.io/3Vdt) | 1900 MHz | 5.16 | Bullseye arm64 | **5110** | 1403 | 890730 | 3700 | 5140 | - |
| [RK3568-ROC-PC](http://ix.io/3Rsg) | 1960 MHz | 4.19 | Bullseye arm64 | **5040** | 1424 | 912800 | 3130 | 6240 | - |
| [NanoPi R5S](http://ix.io/4jfZ) | 1960 MHz | 6.1 | Bullseye arm64 | **5030** | 1482 | 914340 | 2990 | 5970 | 7.33 |
| [ODROID-M1](http://ix.io/3Ug9) | 1930 MHz | 4.19 | Focal arm64 | **5010** | 1450 | 898610 | 3070 | 6220 | 7.14 |
| [i.MX8MPlus EVK board](http://ix.io/4hx0) | 1800 MHz | 5.15 | Focal arm64 | **4990** | 1348 | 837680 | 2740 | 12420 | 7.02 |
| [Quartz64-A](http://ix.io/4qJF) | 1890 MHz | 6.2 | Jammy arm64 | **4980** | 1457 | 884590 | 3240 | 6100 | 6.98 |
| [Quartz64-A](http://ix.io/3rUb) | 1810 MHz | 5.13 | Buster arm64 | **4840** | 1353 | 845490 | 2980 | 7650| - |
| [Khadas VIM2](http://ix.io/1ixi) | 1415/1000 MHz | 4.9 | Xenial arm64 | **4800** | 1128 | 659000 | 1690 | 5610 | - |
| [x5-Z8350](http://ix.io/2Jdb) | 1920/1680 MHz | 5.4 | Focal amd64 | **4790** | 1454 | 237230 | 3170 | 2960 | 9.38 |
| [Athlon II X3 420e](http://ix.io/4eOo) | 2600 MHz | 4.19 | Buster amd64 | **4780** | 2566 | 98840 | 4120 | 3870 | - |
| [x5-Z8350](http://ix.io/1HnC) | 1920/1680 MHz | 4.15 | Bionic amd64 | **4710** | 1272 | 207640 | 2740 | 3140 | - |
| [PineH64](http://ix.io/26Ph) | 1800 MHz | 5.4 | Buster arm64 | **4710** | 1293 | 839870 | 1420 | 5560 | 7.10 |
| [PineH64](http://ix.io/1jEr) | 1800 MHz | 4.18 | Stretch arm64 | **4650** | 1274 | 836900 | 1380 | 5530 | 5.62 |
| [Radxa Zero](http://ix.io/3wZn) | 1800 MHz | 5.10 | Focal arm64 | **4610** | 1267 | 840080 | 1600 | 5370 | - |
| [Radxa Zero](http://ix.io/3JCm) | 1800 MHz | 5.10 | Bullseye arm64 | **4580** | 1353 | 838360 | 1600 | 5360 | 7.13 |
| [Radxa Zero](http://ix.io/3PlT) | 1800 MHz | 5.10 | Buster arm64 | **4570** | 1373 | 839080 | 1610 | 5250 | 6.82 |
| [Atom Z3735F](http://ix.io/4r54) | 1830 MHz | 5.15 | Jammy amd64 | **4510** | 1437 | 227900 | 3020 | 2780 | - |
| [x5-Z8300](http://ix.io/4j4o) | 1840 MHz | 5.15 | Jammy amd64 | **4430** | 1368 | 227030 | 2270 | 2380 | 8.84 |
| [HummingBoard Pulse i.MX8M Quad](http://ix.io/27FC) | 1500 MHz | 4.19 | Buster arm64 | **4330** | 1201 | 695540 | 2230 | 9900 | - |
| [MangoPi Mcore](http://ix.io/4bSf) | 1800 MHz | 5.19 | Jammy arm64 | **4100** | 1218 | 840270 | 990 | 2380 | - |
| [ODROID-C2](http://ix.io/1ixI) | 1750 MHz | 3.14 | Xenial arm64 | **4070** | 1128 | 48500 | 1750 | 3100 | - |
| [Celeron 5205U](http://ix.io/4eiM) | 1900 MHz | 5.15 | Jammy amd64 | **4060** | 2171 | 521090 | 7350 | 16020 | 11.20 |
| [ODROID-C2](http://ix.io/4hOp) | 1530 MHz | 5.19 | Jammy arm64 | **4020** | 1187 | 51390 | 1590 | 2730 | - |
| [Khadas VIM1S](http://ix.io/4bbv) | 2000 MHz | 5.4 | Jammy arm64 | **4000** | 1148 | 436540 | 1970 | 7530 | - |
| [Star64](http://ix.io/4tjq) | 1500 MHz | 5.15 | Sid riscv64 | **3970** | 1175 | 24990 | 820 | 770 | - |
| [x5-Z8300](http://ix.io/1lgD) | 1420 MHz | 4.9 | Stretch amd64 | **3900** | 950 | 178010 | 2380 | 2380 | 7.81 |
| [StarFive VisionFive V2](http://ix.io/4swT) | 1500 MHz | 5.15 | Sid riscv64 | **3890** | 1196 | 24580 | 880 | 770 | - |
| [Tronsmart MXIII Plus](http://ix.io/3S5U) | 1560 MHz | 5.10 | Buster armhf | **3880** | 1113 | 42570 | 1470 | 3430 | - |
| [NanoPi K2](http://ix.io/3Qve) | 1480 MHz | 5.10 | Bullseye arm64 | **3880** | 1154 | 51490 | 1850 | 3790 | - |
| [Khadas VIM1](http://ix.io/4bee) | 1415 MHz | 5.1 | Buster arm64 | **3860** | 1136 | 660160 | 1940 | 5900 | - |
| [NanoPi K2](http://ix.io/1iT1) | 1480 MHz | 4.14 | Stretch arm64 | **3850** | 1095 | 50370 | 1660 | 3870 | 4.61 |
| [Celeron N3350](http://ix.io/4rJj) | 2400 MHz | 6.0 | Bullseye amd64 | **3810** | 2034 | 446170 | 5190 | 5700 | - |
| [Le Potato](http://ix.io/1iSQ) | 1410 MHz | 4.18 | Stretch arm64 | **3780** | 1057 | 657200 | 1810 | 5730 | 3.92 |
| [Renegade](http://ix.io/1iFx) | 1400 MHz | 4.4 | Stretch arm64 | **3710** | 1069 | 644200 | 1565 | 7435 | 3.92 |
| [Raspberry Pi 3 B+](http://ix.io/1isD) | with fan | 4.14 | Raspbian Stretch | **3670** | 1046 | 42600 | 1120 | 1600 | - |
| [Tronsmart S82](http://ix.io/41ML) | 1600 MHz | 5.14 | Focal armhf | **3640** | 1114 | 43150 | 500 | 3200 | - |
| [Raspberry Pi Zero 2](http://ix.io/3DeL) | 1200 MHz | 5.10 | Raspberry Pi OS Buster | **3640** | 1007 | 36300 | 1320 | 1790 | - |
| [Rock64](http://ix.io/1iwz) | 1400 MHz | 4.4 | Stretch armhf | **3620** | 1006 | 624000 | 1430 | 3620 | - |
| [Rock64](http://ix.io/1iFm) | 1400 MHz | 4.4 | Stretch arm64 | **3610** | 1034 | 644250 | 1330 | 5700 | 3.85 |
| [Raspberry Pi 3 B+](http://ix.io/1iI5) | original | 4.9 | Raspbian Stretch | **3600** | 1076 | 42700 | 1230 | 1640 | - |
| [Rock64](http://ix.io/1iZj) | 1400 MHz | 4.4 | Stretch arm64 | **3590** | 1030 | 643700 | 1320 | 5640 | 4.40 |
| [Orange Pi Prime](http://ix.io/2kTH) | 1370 MHz | 5.4 | Buster | **3590** | 984 | 637980 | 1180 | 3540 | - |
| [Rock64](http://ix.io/1iYK) | 1400 MHz | 4.4 | Stretch arm64 | **3580** | 1032 | 644380 | 1330 | 5680 | 4.63 |
| [Rock64](http://ix.io/1iHB) | 1300 MHz | 4.18 | Stretch arm64 | **3560** | 1002 | 603800 | 1340 | 5770 | 3.80 |
| [Orange Pi Zero 2](http://ix.io/4knM) | 1510 MHz | 4.9 | Buster arm64 | **3550** | 1067 | 703300 | 1190 | 2820 | 5.01 |
| [Rock64](http://ix.io/1iH4) | 1300 MHz | 4.18 | Bionic arm64 | **3530** | 996 | 605250 | 1340 | 5770 | 4.65 |
| [NanoPi K1 Plus](http://ix.io/3N7H) | 1370 MHz | 5.10 | Focal arm64 | **3520** | 1022 | 638880 | 1070 | 3680 | 5.50 |
| [Orange Pi PC 2](http://ix.io/3MQJ) | 1370 MHz | 5.10 | Focal arm64 | **3500** | 1023 | 637410 | 1070 | 3680 | - |
| [BPi M4](http://ix.io/1Dt1) | 1400 MHz | 4.9 | Bionic arm64 | **3500** | - | 651460 | 1010 | 4360 | 5.48 |
| [Rock64](http://ix.io/1iHo) | 1300 MHz | 4.4 | Stretch arm64 | **3430** | 952 | 601000 | 1350 | 5680 | 3.64 |
| [Rock64](http://ix.io/1iGW) | 1300 MHz | 4.4 | Bionic arm64 | **3410** | 945 | 601200 | 1310 | 5680 | 4.46 |
| [Ugoos UT2](http://ix.io/408h) | 1560 MHz | 5.10 | Jammy armhf | **3320** | 994 | 43250 | 320 | 2020 | - |
| [Raspberry Pi 3 B+](http://ix.io/1ism) | normal | 4.14 | Raspbian Stretch | **3240** | 914 | 36600 | 1130 | 1530 | - |
| [RK3318 BOX](http://ix.io/4kor) | 1390 MHz | 6.0 | Jammy arm64 | **3200** | 867 | 644750 | 700 | 2460 | - |
| [Marvell PXA1908](http://ix.io/46hs) | 1245 MHz | 3.14 | Bullseye arm64 | **3180** | 951 | 581840 | 740 | 2220 | - |
| [Raspberry Pi 3 B+](http://ix.io/1iGz) | OC/normal | 4.14 | Raspbian Stretch | **3130** | 843 | 36620 | 1230 | 1780 | - |
| [TRONFY MXQ S805](http://ix.io/3MiR) | 1536 MHz | 5.10 | Focal armhf | **3100** | 897 | 29080 | 980 | 2990 | - |
| [Orange Pi PC Plus](http://ix.io/3MQV) | 1370 MHz | 5.10 | Focal armhf | **3060** | 879 | 26590 | 890 | 3450 | - |
| [Akaso M8S](http://ix.io/3R3N) | 1200 MHz | 5.10 | Buster armhf | **3050** | 885 | 32120 | 1160 | 3330 | - |
| [Raspberry Pi 3 B+](http://ix.io/1iGM) | normal | 4.14 | Raspbian Stretch | **3040** | 856 | 36600 | 1050 | 1500 | - |
| [Raspberry Pi Zero 2](http://ix.io/3E85) | 1000 MHz | 5.10 | Raspberry Pi OS Buster | **3030** | 838 | 29860 | 1300 | 1570 | - |
| [NanoPi M1 Plus](http://ix.io/3N2z) | 1370 MHz | 4.19 | Bionic armhf | **3030** | 881 | 26660 | 830 | 3450 | - |
| [ODROID-C1](http://ix.io/4eg5) | 1500 MHz | 5.19 | Jammy armhf | **3010** | 878 | 29260 | 390 | 2910 | - |
| [BPi R2](http://ix.io/4dO7) | 1300 MHz | 4.19 | Focal armhf | **2990** | 854 | 25260 | 1550 | 3220 | - |
| [Raspberry Pi 3 B](http://ix.io/4hOP) | 1200 MHz | 5.15 | Raspbian Sid | **2970** | 977 | 36230 | 1110 | 1700 | 2.89 |
| [Atom N2800](http://ix.io/4nt8) | 1860 MHz | 5.15 | Bullseye amd64 | **2970** | 1006 | 21780 | 2050 | 1570 | - |
| [MT6580 K9M1](http://ix.io/466y) | 1300 MHz | 5.19 | Sid armhf | **2930** | 860 | 25300 | 1250 | 3300 | - |
| [Orange Pi Plus 2](http://ix.io/1iX4) | 1300 MHz | 4.14 | Stretch armhf | **2890** | 812 | 25250 | 830 | 3240 | - |
| [Teres-I](http://ix.io/1tJg) | 1050 MHz | 4.19 | Stretch arm64 | **2785** | 780 | 491590 | 1080 | 2820 | - |
| [Celeron N2830](http://ix.io/4pEc) | 2160 MHz | 5.19 | Jammy amd64 | **2760** | 1664 | 31270 | 3780 | 3520 | 6.10 |
| [BPi M2U](http://ix.io/4kmM) | 1200 MHz | 6.0 | Bullseye armhf | **2690** | 767 | 23320 | 780 | 3010 | - |
| [Rock Pi S](http://ix.io/4sNe) | 1300 MHz | 6.1 | Jammy arm64 | **2540** | 732 | 282030 | 820 | 1870 | - |
| [AMD E-450 APU](http://ix.io/4hwl) | 1650 MHz | 5.15 | Jammy amd64 | **2430** | 1258 | 27450 | 1710 | 1740 | - |
| [Cubox-i4](http://ix.io/4132) | 980 MHz | 5.15 | Jammy armhf | **2360** | 657 | 27000 | 340 | 340 | - |
| [RK3228A TV Box](http://ix.io/3M9F) | 1200 MHz | 4.4 | Buster armhf | **2310** | 710 | 23070 | 410 | 1230 | - |
| [Clearfog A1](http://ix.io/4d1U) | 1600 MHz | 5.15 | Bullseye armhf | **2230** | 1239 | 44080 | 910 | 5060 | - |
| [Helios4](http://ix.io/1jCy) | 1600 MHz | 4.14 | Stretch armhf | **2210** | 1215 | 42500 &ast;98560 | 910 | 4840 | - |
| [Raspberry Pi 2 B+](http://ix.io/3MGs) | 900 MHz | 5.10 | Raspberry Pi OS Bullseye | **2150** | 620 | 16500 | 1000 | 1180 | - |
| [Atom E3826](http://ix.io/44pd) | 1460 MHz | 5.18 | Jammy amd64 | **2140** | 1112 | 182190 | 2840 | 2760 | - |
| [Raspberry Pi 3 B+](http://ix.io/1iH0) | UV/normal | 4.14 | Raspbian Stretch | **2100** | 856 | 36400 | 1040 | 1460 | - |
| [Raspberry Pi 2 B+](http://ix.io/1iFf) | 900 MHz | 4.14 | Debian Stretch | **2070** | 592 | 17450 | 615 | 1175 | - |
| [SBC2D70 (SSD202D)](http://ix.io/3N1U) | 1700 MHz | 5.16 | Sid armhf | **1960** | 1094 | 33120 | 770 | 3190 | - |
| [Atom E3825](http://ix.io/4kFQ) | 1330 MHz | 5.10 | Bullseye amd64 | **1950** | 1109 | 165840 | 2890 | 2890 | - |
| [Raspberry Pi Zero 2](http://ix.io/3Dfo) | 600 MHz | 5.10 | Raspberry Pi OS Buster | **1900** | 529 | 18150 | 1040 | 1130 | - |
| [T-HEAD C910 RVB-ICE](http://ix.io/41AB) | 1200 MHz | 5.10 | Sid riscv64 | **1760** | 1007 | 26930 | 3340 | 6470 | - |
| [EspressoBin](http://ix.io/1lCe) | 1200 MHz | 4.18 | Stretch arm64 | **1630** | 869 | 544240 | 1000 | 2400 | 1.82 |
| [Atom N270](http://ix.io/461n) | 1600 MHz | 4.19 | Buster i386 | **1220** | 824 | 18760 | 1420 | 2840 | - |
| [EspressoBin](http://ix.io/1kt2) | 800 MHz | 4.17 | Stretch arm64 | **1138** | 636 | 368330 | 1040 | 2490 | 1.23 |
| [Olimex A20-Lime2](http://ix.io/4rRV) | 960 MHz | 5.10 | Bullseye armhf | **1080** | 589 | 18630 | 430 | 2020 | 0.87 |
| [LeMaker Banana Pi](http://ix.io/3PLr) | 960 MHz | 5.10 | Bullseye armhf | **1040** | 542 | 18640 | 440 | 2020 | - |
| [Cubietruck](http://ix.io/3Naw) | 960 MHz | 5.10 | Bullseye armhf | **1030** | 541 | 18640 | 440 | 2010 | - |
| [Kendryte K510](http://ix.io/41Qa) | 790 MHz | 4.17 | Sid riscv64 | **690** | 402 | 7410 | 280 | 440 | - |
| [Lime A10](http://ix.io/1j1L) | 910 MHz | 4.14 | Stretch armhf | **550** | 550 | 28250 | 440 | 1300 | - |
| [Raspberry Pi Zero](http://ix.io/3Njz) | 1000 MHz | 5.10 | Bullseye armv6l/armhf | **460** | 460 | 17060 | 430 | 1670 | - |
| [Raspberry Pi Zero](http://ix.io/1niO) | 1000 MHz | 4.14 | Raspbian Stretch | **450** | 450 | 16820 | 400 | 1590 | - |
| [ClockworkPi R-01](http://ix.io/40BJ) | 1000 MHz | 5.4 | Focal riscv64 | **450** | 450 | 9040 | 1220 | 2640 | - |
| [Raspberry Pi B](http://ix.io/3MGN) | 700 MHz | 5.10 | Raspberry Pi OS Bullseye | **320** | 320 | 11630 | 360 | 1420 | - |
| [Raspberry Pi B](http://ix.io/3E7U) | 700 MHz | 5.10 | Raspberry Pi OS Buster | **310** | 310 | 11310 | 340 | 1400 | - |

[(back to top of the page)](#sbc-bench-results-sorted)

## 7-zip MIPS single-threaded

| Device / details | Clockspeed | Kernel | Distro | 7-zip multi | *7-zip single* | AES | memcpy | memset | kH/s |
| ----- | :--------: | :----: | :----: | ----: | ------: | ------: | -----: | -----: | ---: |
| [Apple M1 Pro](http://ix.io/443N) | 3030/2060 MHz | 5.18 | Gentoo 2.8 arm64 | 43800 | **5010** | 1064450 | 27110 | 71910 | 48.28 |
| [Qualcomm Snapdragon 8cx Gen 3 (WSL2)](http://ix.io/4kEp) | 2980/? MHz | 5.15 | Jammy arm64 | 33600 | **4789** | 1679480 | 21010 | 41540 | 50.65 |
| [Pentium G4600](http://ix.io/2jVw) | 3600 MHz | 4.19 | Buster amd64 | 11810 | **4448** | 984820 | 15120 | 33380 | 21.88 |
| [i3-N305](http://ix.io/4qpr) | 3800 MHz | 5.19 | Jammy amd64 | 20000 | **4398** | 1377280 | 9950 | 8990 | 41.43 |
| [Qualcomm Snapdragon 8cx Gen 3](http://ix.io/4qG1) | 3000/2440 MHz | 6.2 | Kinetic arm64 | 35320 | **4283** | 1694260 | 17710 | 42110 | 42.76 |
| [Huaqin P6410](http://ix.io/4kiu) | 3000 MHz | 5.4 | Focal arm64 | 430860 | **4211** | 1710010 | 13310 | 47970 | - |
| [Ampere A1](http://ix.io/4dsC) | 3000 MHz | 5.15 | Jammy arm64 | 16300 | **4009** | 1706150 | 11910 | 47780 | - |
| [Qualcomm QRB5165](http://ix.io/49kx) | 2840/2410/1790 MHz | 4.19 | Focal arm64 | 18860 | **3898** | 1598490 | 14470 | 23910 | 25.56 |
| [Pentium N6005](http://ix.io/4f3I) | 3300/2000 MHz | 6.0 | Jammy amd64 | 10810 | **3485** | 922000 | 9600 | 11300 | 20.15 |
| [Jetson AGX Orin](http://ix.io/4ax9) | 2200 MHz | 5.10 | Focal arm64 | 39450 | **3187** | 1242940 | 10600 | 30350 | 59.96 |
| [Radxa ROCK 5B](http://ix.io/41BH) | 2350/1830 MHz | 5.10 | Focal arm64 | 16450 | **3146** | 1337540 | 10830 | 29220 | 25.31 |
| [Khadas Edge2](http://ix.io/4a5U) | 2260/1800 MHz | 5.10 | Jammy arm64 | 16470 | **3096** | 1287490 | 10860 | 29110 | - |
| [Celeron N4500](http://ix.io/3HUU) | 2800/1100 MHz | 5.13 | Impish amd64 | 6300 | **3091** | 783840 | 8100 | 8350 | - |
| [Celeron N5100](http://ix.io/3IlQ) | 2800/1100 MHz | 5.13 | Focal amd64 | 10550 | **3088** | 783800 | 7750 | 8090 | 19.22 |
| [Celeron N5105](http://ix.io/3Qf7) | 2900/2000 MHz | 5.13 | Focal amd64 | 11450 | **3059** | 811760 | 7710 | 9290 | 21.79 |
| [Loongson-3A5000-HV](http://ix.io/4dzX) | 2500 MHz | 4.19 | Loongnix 20 loongarch64 | 11120 | **2990** | 116900 | 6930 | 19170 | - |
| [Ryzen R1606G](http://ix.io/2tQQ) | 2600/1400 MHz | 5.4 | Focal amd64 | 7970 | **2854** | 700780 | 8230 | 5970 | 16.45 |
| [Phytium FT-2000/4 1xSO-DIMM](http://ix.io/4ioj) | 2600 MHz | 5.15 | Bullseye arm64 | 10020 | **2755** | 936740 | 3760 | 14540 | - |
| [Jetson Xavier AGX](http://ix.io/4ebH) | 2250 MHz | 4.9 | Bionic arm64 | 21590 | **2742** | 853250 | 10910 | 22520 | 26.57 |
| [Athlon II X3 420e](http://ix.io/4eOo) | 2600 MHz | 4.19 | Buster amd64 | 4780 | **2566** | 98840 | 4120 | 3870 | - |
| [OnePlus 5](http://ix.io/4fdD) | 2360/1900 MHz | 6.1 | Jammy arm64 | 9800 | **2474** | 883330 | 9720 | 14070 | 12.58 |
| [Pentium J5005](http://ix.io/21rE) | 2700/1500 MHz | 5.0 | Bionic amd64 | 9230 | **2455** | 778360 | 5530 | 7130 | 20.74 |
| [Amazon a1.xlarge](http://ix.io/2iFY) | 2300 MHz | 4.15 | Bionic arm64 | 8610 | **2406** | 1297960 | 4280 | 14220 | - |
| [Khadas VIM3](http://ix.io/4o1A) | 2400/2015 MHz | 6.0 | Bullseye arm64 | 9650 | **2379** | 1366300 | 5080 | 9240 | - |
| [Khadas VIM3](http://ix.io/3R2Z) | 2400/2015 MHz | 5.10 | Bullseye arm64 | 9650 | **2376** | 1366350 | 4850 | 7380 | - |
| [ODROID-N2+](http://ix.io/4rWn) | 2400/2015 MHz | 6.1 | Bullseye arm64 | 9710 | **2373** | 1366180 | 4220 | 7720 | - |
| [ODROID-N2+](http://ix.io/3R1a) | 2400/2015 MHz | 5.10 | Focal arm64 | 9680 | **2372** | 1366730 | 4030 | 7120 | - |
| [Celeron J4105](http://ix.io/1qal) | 2400/1500 MHz | 4.15 | Bionic amd64 | 9020 | **2290** | 697100 | 5500 | 7410 | 19.07 |
| [Honeycomb LX2](http://ix.io/3Y4f) | 2200 MHz | 5.16 | Fedora 35 aarch64 | 30690 | **2288** | 1251710 | 5050 | 16220 | 46.09 |
| [Celeron J4105](http://ix.io/1qb0) | 2400/1500 MHz | 4.15 | Bionic amd64 | 8960 | **2274** | 697080 | 5620 | 7650 | 19.13 |
| [ODROID-N2+](http://ix.io/3DtN) | 2400/2015 MHz | 5.14 | Impish arm64 | 9790 | **2253** | 1366930 | 4300 | 7480 | - |
| [Phytium D2000 2xSO-DIMM](http://ix.io/446h) | 2300 MHz | 5.19 | Jammy arm64 | 16670 | **2252** | 828130 | 3480 | 16110 | - |
| [Clearfog CX](http://ix.io/4ju5) | 2000 MHz | 5.10 | Focal arm64 | 25260 | **2236** | 1136690 | 4460 | 12500 | - |
| [Celeron N4100](http://ix.io/1uTS) | 2300/1100 MHz | 4.15 | Bionic amd64 | 8510 | **2222** | 669350 | 4750 | 5240 | 18.33 |
| [Phytium D2000 1xSO-DIMM](http://ix.io/445T) | 2300 MHz | 5.19 | Jammy arm64 | 16390 | **2220** | 827090 | 2820 | 6490 | - |
| [Jetson Xavier NX](http://ix.io/3YWp) | 1890 MHz | 4.9 | Bionic arm64 | 13230 | **2201** | 706280 | 9190 | 18480 | - |
| [Celeron 5205U](http://ix.io/4eiM) | 1900 MHz | 5.15 | Jammy amd64 | 4060 | **2171** | 521090 | 7350 | 16020 | 11.20 |
| [Pentium J4205](http://ix.io/1m5t) | 2560/1500 MHz | 4.17 | Stretch amd64 | 7570 | **2146** | 480640 | 5070 | 5170 | 18.82 |
| [Khadas VIM4](http://ix.io/3Wvv) | 2200/1970 MHz | 5.4 | Focal arm64 | 12090 | **2081** | 1253200 | 7810 | 11600 | - |
| [Khadas VIM4](http://ix.io/4cHh) | 2200/2010 MHz | 5.4 | Jammy arm64 | 12120 | **2067** | 1254540 | 8180 | 11680 | - |
| [Celeron J3455](http://ix.io/1m5p) | 2300/1500 MHz | 4.17 | Stretch amd64 | 7000 | **2037** | 429660 | 4090 | 4050 | 17.26 |
| [Celeron N3350](http://ix.io/4rJj) | 2400 MHz | 6.0 | Bullseye amd64 | 3810 | **2034** | 446170 | 5190 | 5700 | - |
| [Khadas VIM3](http://ix.io/1MFD) | 2200/1800 MHz | 4.9 | Bionic arm64 | 8600 | **2026** | 1256910 | 4980 | 9300 | 13.12 |
| [ODROID-N2](http://ix.io/3MuT) | 2000/1900 MHz | 5.10 | Buster arm64 | 9090 | **2012** | 1085350 | 4260 | 9080 | - |
| [Jetson Nano](http://ix.io/3Ufc) | 2000 MHz | 4.9 | Bionic arm64 | 6260 | **1977** | 717500 | 4100 | 11760 | 8.72 |
| [Pentium N4200](http://ix.io/1ngq) | 2560/1100 MHz | 4.14 | Bionic amd64 | 7469 | **1976** | 468008 | 4682 | 4997 | 18.75 |
| [Hugsun X99](http://ix.io/2ICt) | 2088/1800 MHz | 5.9 | Focal arm64 | 7710 | **1927** | 1184306 | 2270 | 5970 | - |
| [NanoPi NEO4](http://ix.io/3GmR) | 2016/1512 MHz | 5.10 | Focal arm64 | 6970 | **1906** | 1145030 | 2450 | 6190 | 11.36 |
| [Raspberry Pi 400](http://ix.io/2Cyi) | 1800 MHz | 5.4 | Raspberry Pi OS Buster | 6550 | **1903** | 77890 | 2680 | 3110 | - |
| [Nintendo Switch](http://ix.io/3Di2) | 2060 MHz | 4.9 | Bionic arm64 | 6720 | **1901** | 746680 | 2370 | 3670 | 9.25 |
| [Rock Pi 4](http://ix.io/3Q2q) | 2000/1500 MHz | 5.10 | Focal arm64 | 6900 | **1899** | 1146500 | 3430 | 8260 | - |
| [Raspberry Pi 4 B](http://ix.io/3Gia) | 1800 MHz | 5.10 | Raspberry Pi OS Buster | 6550 | **1897** | 77830 | 2780 | 3080 | - |
| [NanoPi M4v2](http://ix.io/3MAK) | 2015/1510 MHz | 5.10 | Bullseye arm64 | 6680 | **1855** | 921980 | 3110 | 7640 | - |
| [Raspberry Pi 4 B](http://ix.io/3VME) | 1800 MHz | 5.15 | Jammy armhf | 6300 | **1844** | 82750 | 1190 | 3110 | - |
| [NanoPi M4](http://ix.io/1lzP) | 2000/1500 MHz | 4.19 | Stretch arm64 | 6400 | **1835** | 1128330 | 4080 | 8270 | 8.86 |
| [RockPro64](http://ix.io/2yIx) | 2010/1510 MHz | 5.8 | Bullseye arm64 | 7000 | **1833** | 1144950 | 3690 | 8360 | 11.08 |
| [RockPro64](http://ix.io/2sZH) | 2010/1510 MHz | 5.4 | Focal arm64 | 6920 | **1826** | 1145300 | 3700 | 8430 | 11.55 |
| [Gigabyte H270-T70](http://ix.io/3N5c) | 2000 Mhz | 5.16 | Sid arm64 | 107180 | **1826** | 340750 | 4180 | 17130 | - |
| [Rock Pi 4](http://ix.io/21fX) | 2000/1500 MHz | 5.3 | Bionic arm64 | 6910 | **1817** | 1147370 | 3660 | 8310 | 10.71 |
| [NanoPi NEO4](http://ix.io/1p3T) | 2000/1500 MHz | 4.19 | Stretch arm64 | 6750 | **1814** | 1139850 | 2370 | 6110 | 8.84 |
| [RockPro64](http://ix.io/1iFZ) | 1800/1400 MHz | 4.4 | Stretch armhf | 6250 | **1809** | 1000150 | 2000 | 4835 | - |
| [NanoPC T4](http://ix.io/1iFz) | 1800/1400 MHz | 4.17 | Stretch arm64 | 6250 | **1809** | 1022500 | 4100 | 9000 | 8.24 |
| [Celeron J1900](http://ix.io/4hKV) | 2415/1333 MHz | 5.4 | Focal amd64 | 6560 | **1806** | 34900 | 3780 | 3390 | - |
| [x7-Z8700](http://ix.io/4iDX) | 2400 MHz | 5.15 | Bullseye amd64 | 6580 | **1784** | 296680 | 3510 | 3580 | - |
| [Raspberry Pi 4 B](http://ix.io/3OBF) | 1800 MHz | 5.10 | Raspberry Pi OS Bullseye arm64 | 5790 | **1769** | 36260 | 2330 | 3120 | 8.74 |
| [NanoPC T4](http://ix.io/1iWU) | 1800/1400 MHz | 4.17 | Stretch arm64 | 6230 | **1756** | 1023600 | 4100 | 9060 | 10.30 |
| [RockPro64](http://ix.io/1iFp) | 1800/1400 MHz | 4.18 | Stretch arm64 | 6300 | **1755** | 1021500 | 3650 | 8450 | 8.20 |
| [Raspberry Pi 4 B](http://ix.io/3InF) | 1800 MHz | 5.15 | Armbian Jammy arm64 | 5640 | **1752** | 36260 | 2580 | 3110 | - |
| [Raspberry Pi 4 B](http://ix.io/3F9C) | 1800 MHz | 5.10 | Raspberry Pi OS Buster arm64 | 5760 | **1741** | 36240 | 2240 | 3120 | 9.46 |
| [NanoPC T4](http://ix.io/1iZq) | 1800/1400 MHz | 4.17 | Stretch arm64 | 6380 | **1741** | 1022600 | 4160 | 9000 | 9.36 |
| [Raspberry Pi 4 B](http://ix.io/3N94) | 1800 MHz | 5.10 | Raspberry Pi OS Bullseye | 5940 | **1738** | 77670 | 2310 | 2690 | - |
| [Khadas Edge](http://ix.io/1rYm) | 2000/1500 MHz | 4.4 | Bionic arm64 | 6550 | **1721** | 1130400 | 2810 | 4860 | 10.50 |
| [Nintendo Switch](http://ix.io/1Rnj) | 1780 MHz | 4.9 | Fedora 30 arm-64 | 6170 | **1719** | 642670 | 2500 | 3570 | - |
| [NanoPi NEO4](http://ix.io/1oim) | 2000/1500 MHz | 4.4| Stretch arm64 | 6520 | **1718** | 1123190 | 2280 | 4770 | 8.83 |
| [Tinkerboard](http://ix.io/3X9q) | 1800 MHz | 5.10 | Buster armhf | 5770 | **1713** | 67060 | 1540 | 4110 | - |
| [NanoPi NEO4](http://ix.io/1oho) | 2000/1500 MHz | 4.4| Stretch arm64 | 6510 | **1703** | 1128860 | 2260 | 4770 | 8.71 |
| [Khadas Edge](http://ix.io/1uar) | 2000/1500 MHz | 4.4 | Stretch arm64 | 6600 | **1703** | 1127780 | 2860 | 4880 | 8.85 |
| [Tinkerboard](http://ix.io/3Lir) | 1800 MHz | 4.4 | Buster armhf | 5440 | **1693** | 66300 | 1340 | 3510 | - |
| [ODROID-C4](http://ix.io/3TQ2) | 2100 MHz | 5.10 | Buster arm64 | 5770 | **1679** | 981940 | 3540 | 5150 | - |
| [RockPro64](http://ix.io/1ub9) | 1800/1400 MHz | 4.4 | Stretch arm64 | 6420 | **1673** | 1018480 | 3720 | 8400 | 8.24 |
| [ODROID-HC4](http://ix.io/3Na5) | 2100 MHz | 5.10 | Buster arm64 | 5730 | **1672** | 980970 | 3540 | 5150 | - |
| [ODROID-N2](http://ix.io/1BsF) | 1800/1900 MHz | 4.9 | Bionic arm64 | 8140 | **1669** | 1024680 | 4120 | 8610 | 11.39 |
| [Celeron N2830](http://ix.io/4pEc) | 2160 MHz | 5.19 | Jammy amd64 | 2760 | **1664** | 31270 | 3780 | 3520 | 6.10 |
| [Raspberry Pi 4 B](http://ix.io/3EgS) | 1500 MHz | 5.10 | Raspberry Pi OS Buster | 5750 | **1661** | 64930 | 2550 | 3430 | - |
| [Atom E3950](http://ix.io/4dd5) | 2000 MHz | 5.15 | Jammy amd64 | 6440 | **1636** | 374800 | 4400 | 4840 | - |
| [ODROID-XU4](http://ix.io/1iWL) | 2000/1400 MHz | 4.9 | Stretch armhf | 6400 | **1622** | 72075 | 2230 | 4850 | - |
| [Raspberry Pi 4 B](http://ix.io/1MFf) | 1500 MHz | 4.19 | Raspbian Buster | 5500 | **1606** | 64860 | 2460 | 3170 | - |
| [ODROID-XU4](http://ix.io/3GnC) | 2000/1400 MHz | 5.4 | Focal armhf | 8980 | **1604** | 72020 | 2280 | 4910 | - |
| [RockPro64](http://ix.io/1lBC) | 1800/1400 MHz | 4.4 | Stretch arm64 | 6140 | **1580** | 1015600 | 2770 | 4850 | 8.14 |
| [Jetson Nano](http://ix.io/4rLX) | 1480 MHz | 4.9 | Bullseye arm64 | 5260 | **1578** | 531940 | 3730 | 8870 | - |
| [ODROID-M1](http://ix.io/4ijy) | 2060 MHz | 5.18 | Bullseye arm64 | 5430 | **1567** | 961090 | 3310 | 5960 | 7.76 |
| [Tinkerboard](http://ix.io/1iSX) | 1730 MHz | 4.14 | Stretch armhf | 5350 | **1563** | 66600 | 1480 | 3900 | - |
| [NanoPi R5S](http://ix.io/4jfZ) | 1960 MHz | 6.1 | Bullseye arm64 | 5030 | **1482** | 914340 | 2990 | 5970 | 7.33 |
| [ODROID-C4](http://ix.io/2kaS) | 2010 MHz | 4.9 | Focal arm64 | 5450 | **1459** | 941590 | 3310 | 6270 | 7.71 |
| [Quartz64-A](http://ix.io/4qJF) | 1890 MHz | 6.2 | Jammy arm64 | 4980 | **1457** | 884590 | 3240 | 6100 | 6.98 |
| [x5-Z8350](http://ix.io/2Jdb) | 1920/1680 MHz | 5.4 | Focal amd64 | 4790 | **1454** | 237230 | 3170 | 2960 | 9.38 |
| [Radxa ROCK 3A](http://ix.io/40TX) | 2000 MHz | 5.18 | Bullseye arm64 | 5110 | **1450** | 935920 | 3150 | 6250 | 7.58 |
| [ODROID-M1](http://ix.io/3Ug9) | 1930 MHz | 4.19 | Focal arm64 | 5010 | **1450** | 898610 | 3070 | 6220 | 7.14 |
| [Atom Z3735F](http://ix.io/4r54) | 1830 MHz | 5.15 | Jammy amd64 | 4510 | **1437** | 227900 | 3020 | 2780 | - |
| [RK3568-ROC-PC](http://ix.io/3Rsg) | 1960 MHz | 4.19 | Bullseye arm64 | 5040 | **1424** | 912800 | 3130 | 6240 | - |
| [Khadas VIM3L](http://ix.io/3Vdt) | 1900 MHz | 5.16 | Bullseye arm64 | 5110 | **1403** | 890730 | 3700 | 5140 | - |
| [Khadas VIM3L](http://ix.io/26Wy) | 1900 MHz | 4.9 | Bionic arm64 | 5160 | **1399** | 892110 | 3670 | 6360 | 7.29 |
| [Radxa Zero](http://ix.io/3PlT) | 1800 MHz | 5.10 | Buster arm64 | 4570 | **1373** | 839080 | 1610 | 5250 | 6.82 |
| [x5-Z8300](http://ix.io/4j4o) | 1840 MHz | 5.15 | Jammy amd64 | 4430 | **1368** | 227030 | 2270 | 2380 | 8.84 |
| [Radxa Zero](http://ix.io/3JCm) | 1800 MHz | 5.10 | Bullseye arm64 | 4580 | **1353** | 838360 | 1600 | 5360 | 7.13 |
| [Quartz64-A](http://ix.io/3rUb) | 1810 MHz | 5.13 | Buster arm64 | 4840 | **1353** | 845490 | 2980 | 7650| - |
| [i.MX8MPlus EVK board](http://ix.io/4hx0) | 1800 MHz | 5.15 | Focal arm64 | 4990 | **1348** | 837680 | 2740 | 12420 | 7.02 |
| [NanoPi NEO4](http://ix.io/1oib) | 2000/1500 MHz | 4.4| Stretch arm64 | 6030 | **1343** | 1121380 | 2230 | 4770 | 8.57 |
| [NanoPC T4](http://ix.io/1lkG) | 2000/1500 MHz | 4.4 | Stretch arm64 | 5870 | **1336** | 1124040 | 2810 | 4890 | 8.70 |
| [AMedia X96 Max+](http://ix.io/3QOj) | 2100 MHz | 5.15 | Focal arm64 | 5270 | **1330** | 981830 | 2630 | 5150 | - |
| [PineH64](http://ix.io/26Ph) | 1800 MHz | 5.4 | Buster arm64 | 4710 | **1293** | 839870 | 1420 | 5560 | 7.10 |
| [PineH64](http://ix.io/1jEr) | 1800 MHz | 4.18 | Stretch arm64 | 4650 | **1274** | 836900 | 1380 | 5530 | 5.62 |
| [x5-Z8350](http://ix.io/1HnC) | 1920/1680 MHz | 4.15 | Bionic amd64 | 4710 | **1272** | 207640 | 2740 | 3140 | - |
| [Radxa Zero](http://ix.io/3wZn) | 1800 MHz | 5.10 | Focal arm64 | 4610 | **1267** | 840080 | 1600 | 5370 | - |
| [AMD E-450 APU](http://ix.io/4hwl) | 1650 MHz | 5.15 | Jammy amd64 | 2430 | **1258** | 27450 | 1710 | 1740 | - |
| [Clearfog A1](http://ix.io/4d1U) | 1600 MHz | 5.15 | Bullseye armhf | 2230 | **1239** | 44080 | 910 | 5060 | - |
| [MangoPi Mcore](http://ix.io/4bSf) | 1800 MHz | 5.19 | Jammy arm64 | 4100 | **1218** | 840270 | 990 | 2380 | - |
| [Helios4](http://ix.io/1jCy) | 1600 MHz | 4.14 | Stretch armhf | 2210 | **1215** | 42500 &ast;98560 | 910 | 4840 | - |
| [HummingBoard Pulse i.MX8M Quad](http://ix.io/27FC) | 1500 MHz | 4.19 | Buster arm64 | 4330 | **1201** | 695540 | 2230 | 9900 | - |
| [StarFive VisionFive V2](http://ix.io/4swT) | 1500 MHz | 5.15 | Sid riscv64 | 3890 | **1196** | 24580 | 880 | 770 | - |
| [ODROID-C2](http://ix.io/4hOp) | 1530 MHz | 5.19 | Jammy arm64 | 4020 | **1187** | 51390 | 1590 | 2730 | - |
| [Star64](http://ix.io/4tjq) | 1500 MHz | 5.15 | Sid riscv64 | 3970 | **1175** | 24990 | 820 | 770 | - |
| [NanoPi K2](http://ix.io/3Qve) | 1480 MHz | 5.10 | Bullseye arm64 | 3880 | **1154** | 51490 | 1850 | 3790 | - |
| [Khadas VIM1S](http://ix.io/4bbv) | 2000 MHz | 5.4 | Jammy arm64 | 4000 | **1148** | 436540 | 1970 | 7530 | - |
| [Khadas VIM1](http://ix.io/4bee) | 1415 MHz | 5.1 | Buster arm64 | 3860 | **1136** | 660160 | 1940 | 5900 | - |
| [ODROID-C2](http://ix.io/1ixI) | 1750 MHz | 3.14 | Xenial arm64 | 4070 | **1128** | 48500 | 1750 | 3100 | - |
| [Khadas VIM2](http://ix.io/1ixi) | 1415/1000 MHz | 4.9 | Xenial arm64 | 4800 | **1128** | 659000 | 1690 | 5610 | - |
| [Tronsmart S82](http://ix.io/41ML) | 1600 MHz | 5.14 | Focal armhf | 3640 | **1114** | 43150 | 500 | 3200 | - |
| [Tronsmart MXIII Plus](http://ix.io/3S5U) | 1560 MHz | 5.10 | Buster armhf | 3880 | **1113** | 42570 | 1470 | 3430 | - |
| [Atom E3826](http://ix.io/44pd) | 1460 MHz | 5.18 | Jammy amd64 | 2140 | **1112** | 182190 | 2840 | 2760 | - |
| [Atom E3825](http://ix.io/4kFQ) | 1330 MHz | 5.10 | Bullseye amd64 | 1950 | **1109** | 165840 | 2890 | 2890 | - |
| [NanoPi K2](http://ix.io/1iT1) | 1480 MHz | 4.14 | Stretch arm64 | 3850 | **1095** | 50370 | 1660 | 3870 | 4.61 |
| [SBC2D70 (SSD202D)](http://ix.io/3N1U) | 1700 MHz | 5.16 | Sid armhf | 1960 | **1094** | 33120 | 770 | 3190 | - |
| [NanoPi Fire3](http://ix.io/3ZxU) | 1400 MHz | 4.14 | Focal arm64 | 7350 | **1093** | 652640 | 1530 | 4590 | 11.18 |
| [Raspberry Pi 3 B+](http://ix.io/1iI5) | original | 4.9 | Raspbian Stretch | 3600 | **1076** | 42700 | 1230 | 1640 | - |
| [Renegade](http://ix.io/1iFx) | 1400 MHz | 4.4 | Stretch arm64 | 3710 | **1069** | 644200 | 1565 | 7435 | 3.92 |
| [Orange Pi Zero 2](http://ix.io/4knM) | 1510 MHz | 4.9 | Buster arm64 | 3550 | **1067** | 703300 | 1190 | 2820 | 5.01 |
| [Le Potato](http://ix.io/1iSQ) | 1410 MHz | 4.18 | Stretch arm64 | 3780 | **1057** | 657200 | 1810 | 5730 | 3.92 |
| [NanoPC T3+](http://ix.io/1iRJ) | 1400 MHz | 4.14 | Bionic arm64 | 7480 | **1053** | 652600 | 1440 | 4540 | 10.99 |
| [NanoPi Fire3](http://ix.io/1jjm) | 1400 MHz | 4.14 | Bionic arm64 | 7440 | **1052** | 653000 | 1560 | 4600 | 10.96 |
| [Raspberry Pi 3 B+](http://ix.io/1isD) | with fan | 4.14 | Raspbian Stretch | 3670 | **1046** | 42600 | 1120 | 1600 | - |
| [NanoPi Fire3](http://ix.io/1jiU) | 1380 MHz | 4.14 | Stretch arm64 | 7420 | **1038** | 645400 | 1520 | 4570 | 8.53 |
| [Rock64](http://ix.io/1iFm) | 1400 MHz | 4.4 | Stretch arm64 | 3610 | **1034** | 644250 | 1330 | 5700 | 3.85 |
| [Rock64](http://ix.io/1iYK) | 1400 MHz | 4.4 | Stretch arm64 | 3580 | **1032** | 644380 | 1330 | 5680 | 4.63 |
| [Rock64](http://ix.io/1iZj) | 1400 MHz | 4.4 | Stretch arm64 | 3590 | **1030** | 643700 | 1320 | 5640 | 4.40 |
| [Orange Pi PC 2](http://ix.io/3MQJ) | 1370 MHz | 5.10 | Focal arm64 | 3500 | **1023** | 637410 | 1070 | 3680 | - |
| [NanoPi K1 Plus](http://ix.io/3N7H) | 1370 MHz | 5.10 | Focal arm64 | 3520 | **1022** | 638880 | 1070 | 3680 | 5.50 |
| [Libre Computer AML-S912-PC](http://ix.io/40cj) | 1415/1000 MHz | 5.15 | Bullseye arm64 | 5980 | **1012** | 659290 | 1650 | 5170 | - |
| [T-HEAD C910 RVB-ICE](http://ix.io/41AB) | 1200 MHz | 5.10 | Sid riscv64 | 1760 | **1007** | 26930 | 3340 | 6470 | - |
| [Raspberry Pi Zero 2](http://ix.io/3DeL) | 1200 MHz | 5.10 | Raspberry Pi OS Buster | 3640 | **1007** | 36300 | 1320 | 1790 | - |
| [Rock64](http://ix.io/1iwz) | 1400 MHz | 4.4 | Stretch armhf | 3620 | **1006** | 624000 | 1430 | 3620 | - |
| [Atom N2800](http://ix.io/4nt8) | 1860 MHz | 5.15 | Bullseye amd64 | 2970 | **1006** | 21780 | 2050 | 1570 | - |
| [Rock64](http://ix.io/1iHB) | 1300 MHz | 4.18 | Stretch arm64 | 3560 | **1002** | 603800 | 1340 | 5770 | 3.80 |
| [Rock64](http://ix.io/1iH4) | 1300 MHz | 4.18 | Bionic arm64 | 3530 | **996** | 605250 | 1340 | 5770 | 4.65 |
| [Ugoos UT2](http://ix.io/408h) | 1560 MHz | 5.10 | Jammy armhf | 3320 | **994** | 43250 | 320 | 2020 | - |
| [Khadas VIM2](http://ix.io/1iJ7) | 1415/1000 MHz | 4.17 | Bionic arm64 | 5450 | **993** | 659600 | 1920 | 5920 | 8.59 |
| [Orange Pi Prime](http://ix.io/2kTH) | 1370 MHz | 5.4 | Buster | 3590 | **984** | 637980 | 1180 | 3540 | - |
| [Raspberry Pi 3 B](http://ix.io/4hOP) | 1200 MHz | 5.15 | Raspbian Sid | 2970 | **977** | 36230 | 1110 | 1700 | 2.89 |
| [Rock64](http://ix.io/1iHo) | 1300 MHz | 4.4 | Stretch arm64 | 3430 | **952** | 601000 | 1350 | 5680 | 3.64 |
| [Marvell PXA1908](http://ix.io/46hs) | 1245 MHz | 3.14 | Bullseye arm64 | 3180 | **951** | 581840 | 740 | 2220 | - |
| [x5-Z8300](http://ix.io/1lgD) | 1420 MHz | 4.9 | Stretch amd64 | 3900 | **950** | 178010 | 2380 | 2380 | 7.81 |
| [Rock64](http://ix.io/1iGW) | 1300 MHz | 4.4 | Bionic arm64 | 3410 | **945** | 601200 | 1310 | 5680 | 4.46 |
| [NanoPC T3+](http://ix.io/1iyp) | 1400 MHz | 4.4 | Xenial armhf | 6400 | **943** | 651000 | 1650 | 3700 | - |
| [Raspberry Pi 3 B+](http://ix.io/1ism) | normal | 4.14 | Raspbian Stretch | 3240 | **914** | 36600 | 1130 | 1530 | - |
| [TRONFY MXQ S805](http://ix.io/3MiR) | 1536 MHz | 5.10 | Focal armhf | 3100 | **897** | 29080 | 980 | 2990 | - |
| [Akaso M8S](http://ix.io/3R3N) | 1200 MHz | 5.10 | Buster armhf | 3050 | **885** | 32120 | 1160 | 3330 | - |
| [NanoPi M1 Plus](http://ix.io/3N2z) | 1370 MHz | 4.19 | Bionic armhf | 3030 | **881** | 26660 | 830 | 3450 | - |
| [Orange Pi PC Plus](http://ix.io/3MQV) | 1370 MHz | 5.10 | Focal armhf | 3060 | **879** | 26590 | 890 | 3450 | - |
| [ODROID-C1](http://ix.io/4eg5) | 1500 MHz | 5.19 | Jammy armhf | 3010 | **878** | 29260 | 390 | 2910 | - |
| [EspressoBin](http://ix.io/1lCe) | 1200 MHz | 4.18 | Stretch arm64 | 1630 | **869** | 544240 | 1000 | 2400 | 1.82 |
| [RK3318 BOX](http://ix.io/4kor) | 1390 MHz | 6.0 | Jammy arm64 | 3200 | **867** | 644750 | 700 | 2460 | - |
| [MT6580 K9M1](http://ix.io/466y) | 1300 MHz | 5.19 | Sid armhf | 2930 | **860** | 25300 | 1250 | 3300 | - |
| [Raspberry Pi 3 B+](http://ix.io/1iH0) | UV/normal | 4.14 | Raspbian Stretch | 2100 | **856** | 36400 | 1040 | 1460 | - |
| [Raspberry Pi 3 B+](http://ix.io/1iGM) | normal | 4.14 | Raspbian Stretch | 3040 | **856** | 36600 | 1050 | 1500 | - |
| [BPi R2](http://ix.io/4dO7) | 1300 MHz | 4.19 | Focal armhf | 2990 | **854** | 25260 | 1550 | 3220 | - |
| [Raspberry Pi 3 B+](http://ix.io/1iGz) | OC/normal | 4.14 | Raspbian Stretch | 3130 | **843** | 36620 | 1230 | 1780 | - |
| [Raspberry Pi Zero 2](http://ix.io/3E85) | 1000 MHz | 5.10 | Raspberry Pi OS Buster | 3030 | **838** | 29860 | 1300 | 1570 | - |
| [Atom N270](http://ix.io/461n) | 1600 MHz | 4.19 | Buster i386 | 1220 | **824** | 18760 | 1420 | 2840 | - |
| [Orange Pi Plus 2](http://ix.io/1iX4) | 1300 MHz | 4.14 | Stretch armhf | 2890 | **812** | 25250 | 830 | 3240 | - |
| [Teres-I](http://ix.io/1tJg) | 1050 MHz | 4.19 | Stretch arm64 | 2785 | **780** | 491590 | 1080 | 2820 | - |
| [BPi M2U](http://ix.io/4kmM) | 1200 MHz | 6.0 | Bullseye armhf | 2690 | **767** | 23320 | 780 | 3010 | - |
| [Rock Pi S](http://ix.io/4sNe) | 1300 MHz | 6.1 | Jammy arm64 | 2540 | **732** | 282030 | 820 | 1870 | - |
| [RK3228A TV Box](http://ix.io/3M9F) | 1200 MHz | 4.4 | Buster armhf | 2310 | **710** | 23070 | 410 | 1230 | - |
| [Cubox-i4](http://ix.io/4132) | 980 MHz | 5.15 | Jammy armhf | 2360 | **657** | 27000 | 340 | 340 | - |
| [EspressoBin](http://ix.io/1kt2) | 800 MHz | 4.17 | Stretch arm64 | 1138 | **636** | 368330 | 1040 | 2490 | 1.23 |
| [Raspberry Pi 2 B+](http://ix.io/3MGs) | 900 MHz | 5.10 | Raspberry Pi OS Bullseye | 2150 | **620** | 16500 | 1000 | 1180 | - |
| [Raspberry Pi 2 B+](http://ix.io/1iFf) | 900 MHz | 4.14 | Debian Stretch | 2070 | **592** | 17450 | 615 | 1175 | - |
| [Olimex A20-Lime2](http://ix.io/4rRV) | 960 MHz | 5.10 | Bullseye armhf | 1080 | **589** | 18630 | 430 | 2020 | 0.87 |
| [Lime A10](http://ix.io/1j1L) | 910 MHz | 4.14 | Stretch armhf | 550 | **550** | 28250 | 440 | 1300 | - |
| [LeMaker Banana Pi](http://ix.io/3PLr) | 960 MHz | 5.10 | Bullseye armhf | 1040 | **542** | 18640 | 440 | 2020 | - |
| [Cubietruck](http://ix.io/3Naw) | 960 MHz | 5.10 | Bullseye armhf | 1030 | **541** | 18640 | 440 | 2010 | - |
| [Raspberry Pi Zero 2](http://ix.io/3Dfo) | 600 MHz | 5.10 | Raspberry Pi OS Buster | 1900 | **529** | 18150 | 1040 | 1130 | - |
| [Raspberry Pi Zero](http://ix.io/3Njz) | 1000 MHz | 5.10 | Bullseye armv6l/armhf | 460 | **460** | 17060 | 430 | 1670 | - |
| [Raspberry Pi Zero](http://ix.io/1niO) | 1000 MHz | 4.14 | Raspbian Stretch | 450 | **450** | 16820 | 400 | 1590 | - |
| [ClockworkPi R-01](http://ix.io/40BJ) | 1000 MHz | 5.4 | Focal riscv64 | 450 | **450** | 9040 | 1220 | 2640 | - |
| [Kendryte K510](http://ix.io/41Qa) | 790 MHz | 4.17 | Sid riscv64 | 690 | **402** | 7410 | 280 | 440 | - |
| [Raspberry Pi B](http://ix.io/3MGN) | 700 MHz | 5.10 | Raspberry Pi OS Bullseye | 320 | **320** | 11630 | 360 | 1420 | - |
| [Raspberry Pi B](http://ix.io/3E7U) | 700 MHz | 5.10 | Raspberry Pi OS Buster | 310 | **310** | 11310 | 340 | 1400 | - |
| [ODROID-XU4](http://ix.io/1ixL) | 1900/1400 MHz | 3.10 | Jessie armhf | 6750 | **-** | 68200 | 2200 | 4800 | - |
| [BPi M4](http://ix.io/1Dt1) | 1400 MHz | 4.9 | Bionic arm64 | 3500 | **-** | 651460 | 1010 | 4360 | 5.48 |

[(back to top of the page)](#sbc-bench-results-sorted)

## openssl speed -elapsed -evp aes-256-cbc

(For an in-depth explanation of ARMv8 AES scores see [here](ARMv8-Crypto-Extensions.md))

| Device / details | Clockspeed | Kernel | Distro | 7-zip multi | 7-zip single | *AES* | memcpy | memset | kH/s |
| ----- | :--------: | :----: | :----: | ----: | ------: | ------: | -----: | -----: | ---: |
| [Huaqin P6410](http://ix.io/4kiu) | 3000 MHz | 5.4 | Focal arm64 | 430860 | 4211 | **1710010** | 13310 | 47970 | - |
| [Ampere A1](http://ix.io/4dsC) | 3000 MHz | 5.15 | Jammy arm64 | 16300 | 4009 | **1706150** | 11910 | 47780 | - |
| [Qualcomm Snapdragon 8cx Gen 3](http://ix.io/4qG1) | 3000/2440 MHz | 6.2 | Kinetic arm64 | 35320 | 4283 | **1694260** | 17710 | 42110 | 42.76 |
| [Qualcomm Snapdragon 8cx Gen 3 (WSL2)](http://ix.io/4kEp) | 2980/? MHz | 5.15 | Jammy arm64 | 33600 | 4789 | **1679480** | 21010 | 41540 | 50.65 |
| [Qualcomm QRB5165](http://ix.io/49kx) | 2840/2410/1790 MHz | 4.19 | Focal arm64 | 18860 | 3898 | **1598490** | 14470 | 23910 | 25.56 |
| [i3-N305](http://ix.io/4qpr) | 3800 MHz | 5.19 | Jammy amd64 | 20000 | 4398 | **1377280** | 9950 | 8990 | 41.43 |
| [ODROID-N2+](http://ix.io/3DtN) | 2400/2015 MHz | 5.14 | Impish arm64 | 9790 | 2253 | **1366930** | 4300 | 7480 | - |
| [ODROID-N2+](http://ix.io/3R1a) | 2400/2015 MHz | 5.10 | Focal arm64 | 9680 | 2372 | **1366730** | 4030 | 7120 | - |
| [Khadas VIM3](http://ix.io/3R2Z) | 2400/2015 MHz | 5.10 | Bullseye arm64 | 9650 | 2376 | **1366350** | 4850 | 7380 | - |
| [Khadas VIM3](http://ix.io/4o1A) | 2400/2015 MHz | 6.0 | Bullseye arm64 | 9650 | 2379 | **1366300** | 5080 | 9240 | - |
| [ODROID-N2+](http://ix.io/4rWn) | 2400/2015 MHz | 6.1 | Bullseye arm64 | 9710 | 2373 | **1366180** | 4220 | 7720 | - |
| [Radxa ROCK 5B](http://ix.io/41BH) | 2350/1830 MHz | 5.10 | Focal arm64 | 16450 | 3146 | **1337540** | 10830 | 29220 | 25.31 |
| [Amazon a1.xlarge](http://ix.io/2iFY) | 2300 MHz | 4.15 | Bionic arm64 | 8610 | 2406 | **1297960** | 4280 | 14220 | - |
| [Khadas Edge2](http://ix.io/4a5U) | 2260/1800 MHz | 5.10 | Jammy arm64 | 16470 | 3096 | **1287490** | 10860 | 29110 | - |
| [Khadas VIM3](http://ix.io/1MFD) | 2200/1800 MHz | 4.9 | Bionic arm64 | 8600 | 2026 | **1256910** | 4980 | 9300 | 13.12 |
| [Khadas VIM4](http://ix.io/4cHh) | 2200/2010 MHz | 5.4 | Jammy arm64 | 12120 | 2067 | **1254540** | 8180 | 11680 | - |
| [Khadas VIM4](http://ix.io/3Wvv) | 2200/1970 MHz | 5.4 | Focal arm64 | 12090 | 2081 | **1253200** | 7810 | 11600 | - |
| [Honeycomb LX2](http://ix.io/3Y4f) | 2200 MHz | 5.16 | Fedora 35 aarch64 | 30690 | 2288 | **1251710** | 5050 | 16220 | 46.09 |
| [Jetson AGX Orin](http://ix.io/4ax9) | 2200 MHz | 5.10 | Focal arm64 | 39450 | 3187 | **1242940** | 10600 | 30350 | 59.96 |
| [Hugsun X99](http://ix.io/2ICt) | 2088/1800 MHz | 5.9 | Focal arm64 | 7710 | 1927 | **1184306** | 2270 | 5970 | - |
| [Rock Pi 4](http://ix.io/21fX) | 2000/1500 MHz | 5.3 | Bionic arm64 | 6910 | 1817 | **1147370** | 3660 | 8310 | 10.71 |
| [Rock Pi 4](http://ix.io/3Q2q) | 2000/1500 MHz | 5.10 | Focal arm64 | 6900 | 1899 | **1146500** | 3430 | 8260 | - |
| [RockPro64](http://ix.io/2sZH) | 2010/1510 MHz | 5.4 | Focal arm64 | 6920 | 1826 | **1145300** | 3700 | 8430 | 11.55 |
| [NanoPi NEO4](http://ix.io/3GmR) | 2016/1512 MHz | 5.10 | Focal arm64 | 6970 | 1906 | **1145030** | 2450 | 6190 | 11.36 |
| [RockPro64](http://ix.io/2yIx) | 2010/1510 MHz | 5.8 | Bullseye arm64 | 7000 | 1833 | **1144950** | 3690 | 8360 | 11.08 |
| [NanoPi NEO4](http://ix.io/1p3T) | 2000/1500 MHz | 4.19 | Stretch arm64 | 6750 | 1814 | **1139850** | 2370 | 6110 | 8.84 |
| [Clearfog CX](http://ix.io/4ju5) | 2000 MHz | 5.10 | Focal arm64 | 25260 | 2236 | **1136690** | 4460 | 12500 | - |
| [Khadas Edge](http://ix.io/1rYm) | 2000/1500 MHz | 4.4 | Bionic arm64 | 6550 | 1721 | **1130400** | 2810 | 4860 | 10.50 |
| [NanoPi NEO4](http://ix.io/1oho) | 2000/1500 MHz | 4.4| Stretch arm64 | 6510 | 1703 | **1128860** | 2260 | 4770 | 8.71 |
| [NanoPi M4](http://ix.io/1lzP) | 2000/1500 MHz | 4.19 | Stretch arm64 | 6400 | 1835 | **1128330** | 4080 | 8270 | 8.86 |
| [Khadas Edge](http://ix.io/1uar) | 2000/1500 MHz | 4.4 | Stretch arm64 | 6600 | 1703 | **1127780** | 2860 | 4880 | 8.85 |
| [NanoPC T4](http://ix.io/1lkG) | 2000/1500 MHz | 4.4 | Stretch arm64 | 5870 | 1336 | **1124040** | 2810 | 4890 | 8.70 |
| [NanoPi NEO4](http://ix.io/1oim) | 2000/1500 MHz | 4.4| Stretch arm64 | 6520 | 1718 | **1123190** | 2280 | 4770 | 8.83 |
| [NanoPi NEO4](http://ix.io/1oib) | 2000/1500 MHz | 4.4| Stretch arm64 | 6030 | 1343 | **1121380** | 2230 | 4770 | 8.57 |
| [ODROID-N2](http://ix.io/3MuT) | 2000/1900 MHz | 5.10 | Buster arm64 | 9090 | 2012 | **1085350** | 4260 | 9080 | - |
| [Apple M1 Pro](http://ix.io/443N) | 3030/2060 MHz | 5.18 | Gentoo 2.8 arm64 | 43800 | 5010 | **1064450** | 27110 | 71910 | 48.28 |
| [ODROID-N2](http://ix.io/1BsF) | 1800/1900 MHz | 4.9 | Bionic arm64 | 8140 | 1669 | **1024680** | 4120 | 8610 | 11.39 |
| [NanoPC T4](http://ix.io/1iWU) | 1800/1400 MHz | 4.17 | Stretch arm64 | 6230 | 1756 | **1023600** | 4100 | 9060 | 10.30 |
| [NanoPC T4](http://ix.io/1iZq) | 1800/1400 MHz | 4.17 | Stretch arm64 | 6380 | 1741 | **1022600** | 4160 | 9000 | 9.36 |
| [NanoPC T4](http://ix.io/1iFz) | 1800/1400 MHz | 4.17 | Stretch arm64 | 6250 | 1809 | **1022500** | 4100 | 9000 | 8.24 |
| [RockPro64](http://ix.io/1iFp) | 1800/1400 MHz | 4.18 | Stretch arm64 | 6300 | 1755 | **1021500** | 3650 | 8450 | 8.20 |
| [RockPro64](http://ix.io/1ub9) | 1800/1400 MHz | 4.4 | Stretch arm64 | 6420 | 1673 | **1018480** | 3720 | 8400 | 8.24 |
| [RockPro64](http://ix.io/1lBC) | 1800/1400 MHz | 4.4 | Stretch arm64 | 6140 | 1580 | **1015600** | 2770 | 4850 | 8.14 |
| [RockPro64](http://ix.io/1iFZ) | 1800/1400 MHz | 4.4 | Stretch armhf | 6250 | 1809 | **1000150** | 2000 | 4835 | - |
| [Pentium G4600](http://ix.io/2jVw) | 3600 MHz | 4.19 | Buster amd64 | 11810 | 4448 | **984820** | 15120 | 33380 | 21.88 |
| [ODROID-C4](http://ix.io/3TQ2) | 2100 MHz | 5.10 | Buster arm64 | 5770 | 1679 | **981940** | 3540 | 5150 | - |
| [AMedia X96 Max+](http://ix.io/3QOj) | 2100 MHz | 5.15 | Focal arm64 | 5270 | 1330 | **981830** | 2630 | 5150 | - |
| [ODROID-HC4](http://ix.io/3Na5) | 2100 MHz | 5.10 | Buster arm64 | 5730 | 1672 | **980970** | 3540 | 5150 | - |
| [ODROID-M1](http://ix.io/4ijy) | 2060 MHz | 5.18 | Bullseye arm64 | 5430 | 1567 | **961090** | 3310 | 5960 | 7.76 |
| [ODROID-C4](http://ix.io/2kaS) | 2010 MHz | 4.9 | Focal arm64 | 5450 | 1459 | **941590** | 3310 | 6270 | 7.71 |
| [Phytium FT-2000/4 1xSO-DIMM](http://ix.io/4ioj) | 2600 MHz | 5.15 | Bullseye arm64 | 10020 | 2755 | **936740** | 3760 | 14540 | - |
| [Radxa ROCK 3A](http://ix.io/40TX) | 2000 MHz | 5.18 | Bullseye arm64 | 5110 | 1450 | **935920** | 3150 | 6250 | 7.58 |
| [Pentium N6005](http://ix.io/4f3I) | 3300/2000 MHz | 6.0 | Jammy amd64 | 10810 | 3485 | **922000** | 9600 | 11300 | 20.15 |
| [NanoPi M4v2](http://ix.io/3MAK) | 2015/1510 MHz | 5.10 | Bullseye arm64 | 6680 | 1855 | **921980** | 3110 | 7640 | - |
| [NanoPi R5S](http://ix.io/4jfZ) | 1960 MHz | 6.1 | Bullseye arm64 | 5030 | 1482 | **914340** | 2990 | 5970 | 7.33 |
| [RK3568-ROC-PC](http://ix.io/3Rsg) | 1960 MHz | 4.19 | Bullseye arm64 | 5040 | 1424 | **912800** | 3130 | 6240 | - |
| [ODROID-M1](http://ix.io/3Ug9) | 1930 MHz | 4.19 | Focal arm64 | 5010 | 1450 | **898610** | 3070 | 6220 | 7.14 |
| [Khadas VIM3L](http://ix.io/26Wy) | 1900 MHz | 4.9 | Bionic arm64 | 5160 | 1399 | **892110** | 3670 | 6360 | 7.29 |
| [Khadas VIM3L](http://ix.io/3Vdt) | 1900 MHz | 5.16 | Bullseye arm64 | 5110 | 1403 | **890730** | 3700 | 5140 | - |
| [Quartz64-A](http://ix.io/4qJF) | 1890 MHz | 6.2 | Jammy arm64 | 4980 | 1457 | **884590** | 3240 | 6100 | 6.98 |
| [OnePlus 5](http://ix.io/4fdD) | 2360/1900 MHz | 6.1 | Jammy arm64 | 9800 | 2474 | **883330** | 9720 | 14070 | 12.58 |
| [Jetson Xavier AGX](http://ix.io/4ebH) | 2250 MHz | 4.9 | Bionic arm64 | 21590 | 2742 | **853250** | 10910 | 22520 | 26.57 |
| [Quartz64-A](http://ix.io/3rUb) | 1810 MHz | 5.13 | Buster arm64 | 4840 | 1353 | **845490** | 2980 | 7650| - |
| [MangoPi Mcore](http://ix.io/4bSf) | 1800 MHz | 5.19 | Jammy arm64 | 4100 | 1218 | **840270** | 990 | 2380 | - |
| [Radxa Zero](http://ix.io/3wZn) | 1800 MHz | 5.10 | Focal arm64 | 4610 | 1267 | **840080** | 1600 | 5370 | - |
| [PineH64](http://ix.io/26Ph) | 1800 MHz | 5.4 | Buster arm64 | 4710 | 1293 | **839870** | 1420 | 5560 | 7.10 |
| [Radxa Zero](http://ix.io/3PlT) | 1800 MHz | 5.10 | Buster arm64 | 4570 | 1373 | **839080** | 1610 | 5250 | 6.82 |
| [Radxa Zero](http://ix.io/3JCm) | 1800 MHz | 5.10 | Bullseye arm64 | 4580 | 1353 | **838360** | 1600 | 5360 | 7.13 |
| [i.MX8MPlus EVK board](http://ix.io/4hx0) | 1800 MHz | 5.15 | Focal arm64 | 4990 | 1348 | **837680** | 2740 | 12420 | 7.02 |
| [PineH64](http://ix.io/1jEr) | 1800 MHz | 4.18 | Stretch arm64 | 4650 | 1274 | **836900** | 1380 | 5530 | 5.62 |
| [Phytium D2000 2xSO-DIMM](http://ix.io/446h) | 2300 MHz | 5.19 | Jammy arm64 | 16670 | 2252 | **828130** | 3480 | 16110 | - |
| [Phytium D2000 1xSO-DIMM](http://ix.io/445T) | 2300 MHz | 5.19 | Jammy arm64 | 16390 | 2220 | **827090** | 2820 | 6490 | - |
| [Celeron N5105](http://ix.io/3Qf7) | 2900/2000 MHz | 5.13 | Focal amd64 | 11450 | 3059 | **811760** | 7710 | 9290 | 21.79 |
| [Celeron N4500](http://ix.io/3HUU) | 2800/1100 MHz | 5.13 | Impish amd64 | 6300 | 3091 | **783840** | 8100 | 8350 | - |
| [Celeron N5100](http://ix.io/3IlQ) | 2800/1100 MHz | 5.13 | Focal amd64 | 10550 | 3088 | **783800** | 7750 | 8090 | 19.22 |
| [Pentium J5005](http://ix.io/21rE) | 2700/1500 MHz | 5.0 | Bionic amd64 | 9230 | 2455 | **778360** | 5530 | 7130 | 20.74 |
| [Nintendo Switch](http://ix.io/3Di2) | 2060 MHz | 4.9 | Bionic arm64 | 6720 | 1901 | **746680** | 2370 | 3670 | 9.25 |
| [Jetson Nano](http://ix.io/3Ufc) | 2000 MHz | 4.9 | Bionic arm64 | 6260 | 1977 | **717500** | 4100 | 11760 | 8.72 |
| [Jetson Xavier NX](http://ix.io/3YWp) | 1890 MHz | 4.9 | Bionic arm64 | 13230 | 2201 | **706280** | 9190 | 18480 | - |
| [Orange Pi Zero 2](http://ix.io/4knM) | 1510 MHz | 4.9 | Buster arm64 | 3550 | 1067 | **703300** | 1190 | 2820 | 5.01 |
| [Ryzen R1606G](http://ix.io/2tQQ) | 2600/1400 MHz | 5.4 | Focal amd64 | 7970 | 2854 | **700780** | 8230 | 5970 | 16.45 |
| [Celeron J4105](http://ix.io/1qal) | 2400/1500 MHz | 4.15 | Bionic amd64 | 9020 | 2290 | **697100** | 5500 | 7410 | 19.07 |
| [Celeron J4105](http://ix.io/1qb0) | 2400/1500 MHz | 4.15 | Bionic amd64 | 8960 | 2274 | **697080** | 5620 | 7650 | 19.13 |
| [HummingBoard Pulse i.MX8M Quad](http://ix.io/27FC) | 1500 MHz | 4.19 | Buster arm64 | 4330 | 1201 | **695540** | 2230 | 9900 | - |
| [Celeron N4100](http://ix.io/1uTS) | 2300/1100 MHz | 4.15 | Bionic amd64 | 8510 | 2222 | **669350** | 4750 | 5240 | 18.33 |
| [Khadas VIM1](http://ix.io/4bee) | 1415 MHz | 5.1 | Buster arm64 | 3860 | 1136 | **660160** | 1940 | 5900 | - |
| [Khadas VIM2](http://ix.io/1iJ7) | 1415/1000 MHz | 4.17 | Bionic arm64 | 5450 | 993 | **659600** | 1920 | 5920 | 8.59 |
| [Libre Computer AML-S912-PC](http://ix.io/40cj) | 1415/1000 MHz | 5.15 | Bullseye arm64 | 5980 | 1012 | **659290** | 1650 | 5170 | - |
| [Khadas VIM2](http://ix.io/1ixi) | 1415/1000 MHz | 4.9 | Xenial arm64 | 4800 | 1128 | **659000** | 1690 | 5610 | - |
| [Le Potato](http://ix.io/1iSQ) | 1410 MHz | 4.18 | Stretch arm64 | 3780 | 1057 | **657200** | 1810 | 5730 | 3.92 |
| [NanoPi Fire3](http://ix.io/1jjm) | 1400 MHz | 4.14 | Bionic arm64 | 7440 | 1052 | **653000** | 1560 | 4600 | 10.96 |
| [NanoPi Fire3](http://ix.io/3ZxU) | 1400 MHz | 4.14 | Focal arm64 | 7350 | 1093 | **652640** | 1530 | 4590 | 11.18 |
| [NanoPC T3+](http://ix.io/1iRJ) | 1400 MHz | 4.14 | Bionic arm64 | 7480 | 1053 | **652600** | 1440 | 4540 | 10.99 |
| [BPi M4](http://ix.io/1Dt1) | 1400 MHz | 4.9 | Bionic arm64 | 3500 | - | **651460** | 1010 | 4360 | 5.48 |
| [NanoPC T3+](http://ix.io/1iyp) | 1400 MHz | 4.4 | Xenial armhf | 6400 | 943 | **651000** | 1650 | 3700 | - |
| [NanoPi Fire3](http://ix.io/1jiU) | 1380 MHz | 4.14 | Stretch arm64 | 7420 | 1038 | **645400** | 1520 | 4570 | 8.53 |
| [RK3318 BOX](http://ix.io/4kor) | 1390 MHz | 6.0 | Jammy arm64 | 3200 | 867 | **644750** | 700 | 2460 | - |
| [Rock64](http://ix.io/1iYK) | 1400 MHz | 4.4 | Stretch arm64 | 3580 | 1032 | **644380** | 1330 | 5680 | 4.63 |
| [Rock64](http://ix.io/1iFm) | 1400 MHz | 4.4 | Stretch arm64 | 3610 | 1034 | **644250** | 1330 | 5700 | 3.85 |
| [Renegade](http://ix.io/1iFx) | 1400 MHz | 4.4 | Stretch arm64 | 3710 | 1069 | **644200** | 1565 | 7435 | 3.92 |
| [Rock64](http://ix.io/1iZj) | 1400 MHz | 4.4 | Stretch arm64 | 3590 | 1030 | **643700** | 1320 | 5640 | 4.40 |
| [Nintendo Switch](http://ix.io/1Rnj) | 1780 MHz | 4.9 | Fedora 30 arm-64 | 6170 | 1719 | **642670** | 2500 | 3570 | - |
| [NanoPi K1 Plus](http://ix.io/3N7H) | 1370 MHz | 5.10 | Focal arm64 | 3520 | 1022 | **638880** | 1070 | 3680 | 5.50 |
| [Orange Pi Prime](http://ix.io/2kTH) | 1370 MHz | 5.4 | Buster | 3590 | 984 | **637980** | 1180 | 3540 | - |
| [Orange Pi PC 2](http://ix.io/3MQJ) | 1370 MHz | 5.10 | Focal arm64 | 3500 | 1023 | **637410** | 1070 | 3680 | - |
| [Rock64](http://ix.io/1iwz) | 1400 MHz | 4.4 | Stretch armhf | 3620 | 1006 | **624000** | 1430 | 3620 | - |
| [Rock64](http://ix.io/1iH4) | 1300 MHz | 4.18 | Bionic arm64 | 3530 | 996 | **605250** | 1340 | 5770 | 4.65 |
| [Rock64](http://ix.io/1iHB) | 1300 MHz | 4.18 | Stretch arm64 | 3560 | 1002 | **603800** | 1340 | 5770 | 3.80 |
| [Rock64](http://ix.io/1iGW) | 1300 MHz | 4.4 | Bionic arm64 | 3410 | 945 | **601200** | 1310 | 5680 | 4.46 |
| [Rock64](http://ix.io/1iHo) | 1300 MHz | 4.4 | Stretch arm64 | 3430 | 952 | **601000** | 1350 | 5680 | 3.64 |
| [Marvell PXA1908](http://ix.io/46hs) | 1245 MHz | 3.14 | Bullseye arm64 | 3180 | 951 | **581840** | 740 | 2220 | - |
| [EspressoBin](http://ix.io/1lCe) | 1200 MHz | 4.18 | Stretch arm64 | 1630 | 869 | **544240** | 1000 | 2400 | 1.82 |
| [Jetson Nano](http://ix.io/4rLX) | 1480 MHz | 4.9 | Bullseye arm64 | 5260 | 1578 | **531940** | 3730 | 8870 | - |
| [Celeron 5205U](http://ix.io/4eiM) | 1900 MHz | 5.15 | Jammy amd64 | 4060 | 2171 | **521090** | 7350 | 16020 | 11.20 |
| [Teres-I](http://ix.io/1tJg) | 1050 MHz | 4.19 | Stretch arm64 | 2785 | 780 | **491590** | 1080 | 2820 | - |
| [Pentium J4205](http://ix.io/1m5t) | 2560/1500 MHz | 4.17 | Stretch amd64 | 7570 | 2146 | **480640** | 5070 | 5170 | 18.82 |
| [Pentium N4200](http://ix.io/1ngq) | 2560/1100 MHz | 4.14 | Bionic amd64 | 7469 | 1976 | **468008** | 4682 | 4997 | 18.75 |
| [Celeron N3350](http://ix.io/4rJj) | 2400 MHz | 6.0 | Bullseye amd64 | 3810 | 2034 | **446170** | 5190 | 5700 | - |
| [Khadas VIM1S](http://ix.io/4bbv) | 2000 MHz | 5.4 | Jammy arm64 | 4000 | 1148 | **436540** | 1970 | 7530 | - |
| [Celeron J3455](http://ix.io/1m5p) | 2300/1500 MHz | 4.17 | Stretch amd64 | 7000 | 2037 | **429660** | 4090 | 4050 | 17.26 |
| [Atom E3950](http://ix.io/4dd5) | 2000 MHz | 5.15 | Jammy amd64 | 6440 | 1636 | **374800** | 4400 | 4840 | - |
| [EspressoBin](http://ix.io/1kt2) | 800 MHz | 4.17 | Stretch arm64 | 1138 | 636 | **368330** | 1040 | 2490 | 1.23 |
| [Gigabyte H270-T70](http://ix.io/3N5c) | 2000 Mhz | 5.16 | Sid arm64 | 107180 | 1826 | **340750** | 4180 | 17130 | - |
| [x7-Z8700](http://ix.io/4iDX) | 2400 MHz | 5.15 | Bullseye amd64 | 6580 | 1784 | **296680** | 3510 | 3580 | - |
| [Rock Pi S](http://ix.io/4sNe) | 1300 MHz | 6.1 | Jammy arm64 | 2540 | 732 | **282030** | 820 | 1870 | - |
| [x5-Z8350](http://ix.io/2Jdb) | 1920/1680 MHz | 5.4 | Focal amd64 | 4790 | 1454 | **237230** | 3170 | 2960 | 9.38 |
| [Atom Z3735F](http://ix.io/4r54) | 1830 MHz | 5.15 | Jammy amd64 | 4510 | 1437 | **227900** | 3020 | 2780 | - |
| [x5-Z8300](http://ix.io/4j4o) | 1840 MHz | 5.15 | Jammy amd64 | 4430 | 1368 | **227030** | 2270 | 2380 | 8.84 |
| [x5-Z8350](http://ix.io/1HnC) | 1920/1680 MHz | 4.15 | Bionic amd64 | 4710 | 1272 | **207640** | 2740 | 3140 | - |
| [Atom E3826](http://ix.io/44pd) | 1460 MHz | 5.18 | Jammy amd64 | 2140 | 1112 | **182190** | 2840 | 2760 | - |
| [x5-Z8300](http://ix.io/1lgD) | 1420 MHz | 4.9 | Stretch amd64 | 3900 | 950 | **178010** | 2380 | 2380 | 7.81 |
| [Atom E3825](http://ix.io/4kFQ) | 1330 MHz | 5.10 | Bullseye amd64 | 1950 | 1109 | **165840** | 2890 | 2890 | - |
| [Loongson-3A5000-HV](http://ix.io/4dzX) | 2500 MHz | 4.19 | Loongnix 20 loongarch64 | 11120 | 2990 | **116900** | 6930 | 19170 | - |
| [Athlon II X3 420e](http://ix.io/4eOo) | 2600 MHz | 4.19 | Buster amd64 | 4780 | 2566 | **98840** | 4120 | 3870 | - |
| [Raspberry Pi 4 B](http://ix.io/3VME) | 1800 MHz | 5.15 | Jammy armhf | 6300 | 1844 | **82750** | 1190 | 3110 | - |
| [Raspberry Pi 400](http://ix.io/2Cyi) | 1800 MHz | 5.4 | Raspberry Pi OS Buster | 6550 | 1903 | **77890** | 2680 | 3110 | - |
| [Raspberry Pi 4 B](http://ix.io/3Gia) | 1800 MHz | 5.10 | Raspberry Pi OS Buster | 6550 | 1897 | **77830** | 2780 | 3080 | - |
| [Raspberry Pi 4 B](http://ix.io/3N94) | 1800 MHz | 5.10 | Raspberry Pi OS Bullseye | 5940 | 1738 | **77670** | 2310 | 2690 | - |
| [ODROID-XU4](http://ix.io/1iWL) | 2000/1400 MHz | 4.9 | Stretch armhf | 6400 | 1622 | **72075** | 2230 | 4850 | - |
| [ODROID-XU4](http://ix.io/3GnC) | 2000/1400 MHz | 5.4 | Focal armhf | 8980 | 1604 | **72020** | 2280 | 4910 | - |
| [ODROID-XU4](http://ix.io/1ixL) | 1900/1400 MHz | 3.10 | Jessie armhf | 6750 | - | **68200** | 2200 | 4800 | - |
| [Tinkerboard](http://ix.io/3X9q) | 1800 MHz | 5.10 | Buster armhf | 5770 | 1713 | **67060** | 1540 | 4110 | - |
| [Tinkerboard](http://ix.io/1iSX) | 1730 MHz | 4.14 | Stretch armhf | 5350 | 1563 | **66600** | 1480 | 3900 | - |
| [Tinkerboard](http://ix.io/3Lir) | 1800 MHz | 4.4 | Buster armhf | 5440 | 1693 | **66300** | 1340 | 3510 | - |
| [Raspberry Pi 4 B](http://ix.io/3EgS) | 1500 MHz | 5.10 | Raspberry Pi OS Buster | 5750 | 1661 | **64930** | 2550 | 3430 | - |
| [Raspberry Pi 4 B](http://ix.io/1MFf) | 1500 MHz | 4.19 | Raspbian Buster | 5500 | 1606 | **64860** | 2460 | 3170 | - |
| [NanoPi K2](http://ix.io/3Qve) | 1480 MHz | 5.10 | Bullseye arm64 | 3880 | 1154 | **51490** | 1850 | 3790 | - |
| [ODROID-C2](http://ix.io/4hOp) | 1530 MHz | 5.19 | Jammy arm64 | 4020 | 1187 | **51390** | 1590 | 2730 | - |
| [NanoPi K2](http://ix.io/1iT1) | 1480 MHz | 4.14 | Stretch arm64 | 3850 | 1095 | **50370** | 1660 | 3870 | 4.61 |
| [ODROID-C2](http://ix.io/1ixI) | 1750 MHz | 3.14 | Xenial arm64 | 4070 | 1128 | **48500** | 1750 | 3100 | - |
| [Clearfog A1](http://ix.io/4d1U) | 1600 MHz | 5.15 | Bullseye armhf | 2230 | 1239 | **44080** | 910 | 5060 | - |
| [Ugoos UT2](http://ix.io/408h) | 1560 MHz | 5.10 | Jammy armhf | 3320 | 994 | **43250** | 320 | 2020 | - |
| [Tronsmart S82](http://ix.io/41ML) | 1600 MHz | 5.14 | Focal armhf | 3640 | 1114 | **43150** | 500 | 3200 | - |
| [Raspberry Pi 3 B+](http://ix.io/1iI5) | original | 4.9 | Raspbian Stretch | 3600 | 1076 | **42700** | 1230 | 1640 | - |
| [Raspberry Pi 3 B+](http://ix.io/1isD) | with fan | 4.14 | Raspbian Stretch | 3670 | 1046 | **42600** | 1120 | 1600 | - |
| [Tronsmart MXIII Plus](http://ix.io/3S5U) | 1560 MHz | 5.10 | Buster armhf | 3880 | 1113 | **42570** | 1470 | 3430 | - |
| [Helios4](http://ix.io/1jCy) | 1600 MHz | 4.14 | Stretch armhf | 2210 | 1215 | **42500 &ast;98560** | 910 | 4840 | - |
| [Raspberry Pi 3 B+](http://ix.io/1iGz) | OC/normal | 4.14 | Raspbian Stretch | 3130 | 843 | **36620** | 1230 | 1780 | - |
| [Raspberry Pi 3 B+](http://ix.io/1ism) | normal | 4.14 | Raspbian Stretch | 3240 | 914 | **36600** | 1130 | 1530 | - |
| [Raspberry Pi 3 B+](http://ix.io/1iGM) | normal | 4.14 | Raspbian Stretch | 3040 | 856 | **36600** | 1050 | 1500 | - |
| [Raspberry Pi 3 B+](http://ix.io/1iH0) | UV/normal | 4.14 | Raspbian Stretch | 2100 | 856 | **36400** | 1040 | 1460 | - |
| [Raspberry Pi Zero 2](http://ix.io/3DeL) | 1200 MHz | 5.10 | Raspberry Pi OS Buster | 3640 | 1007 | **36300** | 1320 | 1790 | - |
| [Raspberry Pi 4 B](http://ix.io/3OBF) | 1800 MHz | 5.10 | Raspberry Pi OS Bullseye arm64 | 5790 | 1769 | **36260** | 2330 | 3120 | 8.74 |
| [Raspberry Pi 4 B](http://ix.io/3InF) | 1800 MHz | 5.15 | Armbian Jammy arm64 | 5640 | 1752 | **36260** | 2580 | 3110 | - |
| [Raspberry Pi 4 B](http://ix.io/3F9C) | 1800 MHz | 5.10 | Raspberry Pi OS Buster arm64 | 5760 | 1741 | **36240** | 2240 | 3120 | 9.46 |
| [Raspberry Pi 3 B](http://ix.io/4hOP) | 1200 MHz | 5.15 | Raspbian Sid | 2970 | 977 | **36230** | 1110 | 1700 | 2.89 |
| [Celeron J1900](http://ix.io/4hKV) | 2415/1333 MHz | 5.4 | Focal amd64 | 6560 | 1806 | **34900** | 3780 | 3390 | - |
| [SBC2D70 (SSD202D)](http://ix.io/3N1U) | 1700 MHz | 5.16 | Sid armhf | 1960 | 1094 | **33120** | 770 | 3190 | - |
| [Akaso M8S](http://ix.io/3R3N) | 1200 MHz | 5.10 | Buster armhf | 3050 | 885 | **32120** | 1160 | 3330 | - |
| [Celeron N2830](http://ix.io/4pEc) | 2160 MHz | 5.19 | Jammy amd64 | 2760 | 1664 | **31270** | 3780 | 3520 | 6.10 |
| [Raspberry Pi Zero 2](http://ix.io/3E85) | 1000 MHz | 5.10 | Raspberry Pi OS Buster | 3030 | 838 | **29860** | 1300 | 1570 | - |
| [ODROID-C1](http://ix.io/4eg5) | 1500 MHz | 5.19 | Jammy armhf | 3010 | 878 | **29260** | 390 | 2910 | - |
| [TRONFY MXQ S805](http://ix.io/3MiR) | 1536 MHz | 5.10 | Focal armhf | 3100 | 897 | **29080** | 980 | 2990 | - |
| [Lime A10](http://ix.io/1j1L) | 910 MHz | 4.14 | Stretch armhf | 550 | 550 | **28250** | 440 | 1300 | - |
| [AMD E-450 APU](http://ix.io/4hwl) | 1650 MHz | 5.15 | Jammy amd64 | 2430 | 1258 | **27450** | 1710 | 1740 | - |
| [Cubox-i4](http://ix.io/4132) | 980 MHz | 5.15 | Jammy armhf | 2360 | 657 | **27000** | 340 | 340 | - |
| [T-HEAD C910 RVB-ICE](http://ix.io/41AB) | 1200 MHz | 5.10 | Sid riscv64 | 1760 | 1007 | **26930** | 3340 | 6470 | - |
| [NanoPi M1 Plus](http://ix.io/3N2z) | 1370 MHz | 4.19 | Bionic armhf | 3030 | 881 | **26660** | 830 | 3450 | - |
| [Orange Pi PC Plus](http://ix.io/3MQV) | 1370 MHz | 5.10 | Focal armhf | 3060 | 879 | **26590** | 890 | 3450 | - |
| [MT6580 K9M1](http://ix.io/466y) | 1300 MHz | 5.19 | Sid armhf | 2930 | 860 | **25300** | 1250 | 3300 | - |
| [BPi R2](http://ix.io/4dO7) | 1300 MHz | 4.19 | Focal armhf | 2990 | 854 | **25260** | 1550 | 3220 | - |
| [Orange Pi Plus 2](http://ix.io/1iX4) | 1300 MHz | 4.14 | Stretch armhf | 2890 | 812 | **25250** | 830 | 3240 | - |
| [Star64](http://ix.io/4tjq) | 1500 MHz | 5.15 | Sid riscv64 | 3970 | 1175 | **24990** | 820 | 770 | - |
| [StarFive VisionFive V2](http://ix.io/4swT) | 1500 MHz | 5.15 | Sid riscv64 | 3890 | 1196 | **24580** | 880 | 770 | - |
| [BPi M2U](http://ix.io/4kmM) | 1200 MHz | 6.0 | Bullseye armhf | 2690 | 767 | **23320** | 780 | 3010 | - |
| [RK3228A TV Box](http://ix.io/3M9F) | 1200 MHz | 4.4 | Buster armhf | 2310 | 710 | **23070** | 410 | 1230 | - |
| [Atom N2800](http://ix.io/4nt8) | 1860 MHz | 5.15 | Bullseye amd64 | 2970 | 1006 | **21780** | 2050 | 1570 | - |
| [Atom N270](http://ix.io/461n) | 1600 MHz | 4.19 | Buster i386 | 1220 | 824 | **18760** | 1420 | 2840 | - |
| [LeMaker Banana Pi](http://ix.io/3PLr) | 960 MHz | 5.10 | Bullseye armhf | 1040 | 542 | **18640** | 440 | 2020 | - |
| [Cubietruck](http://ix.io/3Naw) | 960 MHz | 5.10 | Bullseye armhf | 1030 | 541 | **18640** | 440 | 2010 | - |
| [Olimex A20-Lime2](http://ix.io/4rRV) | 960 MHz | 5.10 | Bullseye armhf | 1080 | 589 | **18630** | 430 | 2020 | 0.87 |
| [Raspberry Pi Zero 2](http://ix.io/3Dfo) | 600 MHz | 5.10 | Raspberry Pi OS Buster | 1900 | 529 | **18150** | 1040 | 1130 | - |
| [Raspberry Pi 2 B+](http://ix.io/1iFf) | 900 MHz | 4.14 | Debian Stretch | 2070 | 592 | **17450** | 615 | 1175 | - |
| [Raspberry Pi Zero](http://ix.io/3Njz) | 1000 MHz | 5.10 | Bullseye armv6l/armhf | 460 | 460 | **17060** | 430 | 1670 | - |
| [Raspberry Pi Zero](http://ix.io/1niO) | 1000 MHz | 4.14 | Raspbian Stretch | 450 | 450 | **16820** | 400 | 1590 | - |
| [Raspberry Pi 2 B+](http://ix.io/3MGs) | 900 MHz | 5.10 | Raspberry Pi OS Bullseye | 2150 | 620 | **16500** | 1000 | 1180 | - |
| [Raspberry Pi B](http://ix.io/3MGN) | 700 MHz | 5.10 | Raspberry Pi OS Bullseye | 320 | 320 | **11630** | 360 | 1420 | - |
| [Raspberry Pi B](http://ix.io/3E7U) | 700 MHz | 5.10 | Raspberry Pi OS Buster | 310 | 310 | **11310** | 340 | 1400 | - |
| [ClockworkPi R-01](http://ix.io/40BJ) | 1000 MHz | 5.4 | Focal riscv64 | 450 | 450 | **9040** | 1220 | 2640 | - |
| [Kendryte K510](http://ix.io/41Qa) | 790 MHz | 4.17 | Sid riscv64 | 690 | 402 | **7410** | 280 | 440 | - |

[(back to top of the page)](#sbc-bench-results-sorted)

## memcpy

| Device / details | Clockspeed | Kernel | Distro | 7-zip multi | 7-zip single | AES | *memcpy* | memset | kH/s |
| ----- | :--------: | :----: | :----: | ----: | ------: | ------: | -----: | -----: | ---: |
| [Apple M1 Pro](http://ix.io/443N) | 3030/2060 MHz | 5.18 | Gentoo 2.8 arm64 | 43800 | 5010 | 1064450 | **27110** | 71910 | 48.28 |
| [Qualcomm Snapdragon 8cx Gen 3 (WSL2)](http://ix.io/4kEp) | 2980/? MHz | 5.15 | Jammy arm64 | 33600 | 4789 | 1679480 | **21010** | 41540 | 50.65 |
| [Qualcomm Snapdragon 8cx Gen 3](http://ix.io/4qG1) | 3000/2440 MHz | 6.2 | Kinetic arm64 | 35320 | 4283 | 1694260 | **17710** | 42110 | 42.76 |
| [Pentium G4600](http://ix.io/2jVw) | 3600 MHz | 4.19 | Buster amd64 | 11810 | 4448 | 984820 | **15120** | 33380 | 21.88 |
| [Qualcomm QRB5165](http://ix.io/49kx) | 2840/2410/1790 MHz | 4.19 | Focal arm64 | 18860 | 3898 | 1598490 | **14470** | 23910 | 25.56 |
| [Huaqin P6410](http://ix.io/4kiu) | 3000 MHz | 5.4 | Focal arm64 | 430860 | 4211 | 1710010 | **13310** | 47970 | - |
| [Ampere A1](http://ix.io/4dsC) | 3000 MHz | 5.15 | Jammy arm64 | 16300 | 4009 | 1706150 | **11910** | 47780 | - |
| [Jetson Xavier AGX](http://ix.io/4ebH) | 2250 MHz | 4.9 | Bionic arm64 | 21590 | 2742 | 853250 | **10910** | 22520 | 26.57 |
| [Khadas Edge2](http://ix.io/4a5U) | 2260/1800 MHz | 5.10 | Jammy arm64 | 16470 | 3096 | 1287490 | **10860** | 29110 | - |
| [Radxa ROCK 5B](http://ix.io/41BH) | 2350/1830 MHz | 5.10 | Focal arm64 | 16450 | 3146 | 1337540 | **10830** | 29220 | 25.31 |
| [Jetson AGX Orin](http://ix.io/4ax9) | 2200 MHz | 5.10 | Focal arm64 | 39450 | 3187 | 1242940 | **10600** | 30350 | 59.96 |
| [i3-N305](http://ix.io/4qpr) | 3800 MHz | 5.19 | Jammy amd64 | 20000 | 4398 | 1377280 | **9950** | 8990 | 41.43 |
| [OnePlus 5](http://ix.io/4fdD) | 2360/1900 MHz | 6.1 | Jammy arm64 | 9800 | 2474 | 883330 | **9720** | 14070 | 12.58 |
| [Pentium N6005](http://ix.io/4f3I) | 3300/2000 MHz | 6.0 | Jammy amd64 | 10810 | 3485 | 922000 | **9600** | 11300 | 20.15 |
| [Jetson Xavier NX](http://ix.io/3YWp) | 1890 MHz | 4.9 | Bionic arm64 | 13230 | 2201 | 706280 | **9190** | 18480 | - |
| [Ryzen R1606G](http://ix.io/2tQQ) | 2600/1400 MHz | 5.4 | Focal amd64 | 7970 | 2854 | 700780 | **8230** | 5970 | 16.45 |
| [Khadas VIM4](http://ix.io/4cHh) | 2200/2010 MHz | 5.4 | Jammy arm64 | 12120 | 2067 | 1254540 | **8180** | 11680 | - |
| [Celeron N4500](http://ix.io/3HUU) | 2800/1100 MHz | 5.13 | Impish amd64 | 6300 | 3091 | 783840 | **8100** | 8350 | - |
| [Khadas VIM4](http://ix.io/3Wvv) | 2200/1970 MHz | 5.4 | Focal arm64 | 12090 | 2081 | 1253200 | **7810** | 11600 | - |
| [Celeron N5100](http://ix.io/3IlQ) | 2800/1100 MHz | 5.13 | Focal amd64 | 10550 | 3088 | 783800 | **7750** | 8090 | 19.22 |
| [Celeron N5105](http://ix.io/3Qf7) | 2900/2000 MHz | 5.13 | Focal amd64 | 11450 | 3059 | 811760 | **7710** | 9290 | 21.79 |
| [Celeron 5205U](http://ix.io/4eiM) | 1900 MHz | 5.15 | Jammy amd64 | 4060 | 2171 | 521090 | **7350** | 16020 | 11.20 |
| [Loongson-3A5000-HV](http://ix.io/4dzX) | 2500 MHz | 4.19 | Loongnix 20 loongarch64 | 11120 | 2990 | 116900 | **6930** | 19170 | - |
| [Celeron J4105](http://ix.io/1qb0) | 2400/1500 MHz | 4.15 | Bionic amd64 | 8960 | 2274 | 697080 | **5620** | 7650 | 19.13 |
| [Pentium J5005](http://ix.io/21rE) | 2700/1500 MHz | 5.0 | Bionic amd64 | 9230 | 2455 | 778360 | **5530** | 7130 | 20.74 |
| [Celeron J4105](http://ix.io/1qal) | 2400/1500 MHz | 4.15 | Bionic amd64 | 9020 | 2290 | 697100 | **5500** | 7410 | 19.07 |
| [Celeron N3350](http://ix.io/4rJj) | 2400 MHz | 6.0 | Bullseye amd64 | 3810 | 2034 | 446170 | **5190** | 5700 | - |
| [Khadas VIM3](http://ix.io/4o1A) | 2400/2015 MHz | 6.0 | Bullseye arm64 | 9650 | 2379 | 1366300 | **5080** | 9240 | - |
| [Pentium J4205](http://ix.io/1m5t) | 2560/1500 MHz | 4.17 | Stretch amd64 | 7570 | 2146 | 480640 | **5070** | 5170 | 18.82 |
| [Honeycomb LX2](http://ix.io/3Y4f) | 2200 MHz | 5.16 | Fedora 35 aarch64 | 30690 | 2288 | 1251710 | **5050** | 16220 | 46.09 |
| [Khadas VIM3](http://ix.io/1MFD) | 2200/1800 MHz | 4.9 | Bionic arm64 | 8600 | 2026 | 1256910 | **4980** | 9300 | 13.12 |
| [Khadas VIM3](http://ix.io/3R2Z) | 2400/2015 MHz | 5.10 | Bullseye arm64 | 9650 | 2376 | 1366350 | **4850** | 7380 | - |
| [Celeron N4100](http://ix.io/1uTS) | 2300/1100 MHz | 4.15 | Bionic amd64 | 8510 | 2222 | 669350 | **4750** | 5240 | 18.33 |
| [Pentium N4200](http://ix.io/1ngq) | 2560/1100 MHz | 4.14 | Bionic amd64 | 7469 | 1976 | 468008 | **4682** | 4997 | 18.75 |
| [Clearfog CX](http://ix.io/4ju5) | 2000 MHz | 5.10 | Focal arm64 | 25260 | 2236 | 1136690 | **4460** | 12500 | - |
| [Atom E3950](http://ix.io/4dd5) | 2000 MHz | 5.15 | Jammy amd64 | 6440 | 1636 | 374800 | **4400** | 4840 | - |
| [ODROID-N2+](http://ix.io/3DtN) | 2400/2015 MHz | 5.14 | Impish arm64 | 9790 | 2253 | 1366930 | **4300** | 7480 | - |
| [Amazon a1.xlarge](http://ix.io/2iFY) | 2300 MHz | 4.15 | Bionic arm64 | 8610 | 2406 | 1297960 | **4280** | 14220 | - |
| [ODROID-N2](http://ix.io/3MuT) | 2000/1900 MHz | 5.10 | Buster arm64 | 9090 | 2012 | 1085350 | **4260** | 9080 | - |
| [ODROID-N2+](http://ix.io/4rWn) | 2400/2015 MHz | 6.1 | Bullseye arm64 | 9710 | 2373 | 1366180 | **4220** | 7720 | - |
| [Gigabyte H270-T70](http://ix.io/3N5c) | 2000 Mhz | 5.16 | Sid arm64 | 107180 | 1826 | 340750 | **4180** | 17130 | - |
| [NanoPC T4](http://ix.io/1iZq) | 1800/1400 MHz | 4.17 | Stretch arm64 | 6380 | 1741 | 1022600 | **4160** | 9000 | 9.36 |
| [ODROID-N2](http://ix.io/1BsF) | 1800/1900 MHz | 4.9 | Bionic arm64 | 8140 | 1669 | 1024680 | **4120** | 8610 | 11.39 |
| [Athlon II X3 420e](http://ix.io/4eOo) | 2600 MHz | 4.19 | Buster amd64 | 4780 | 2566 | 98840 | **4120** | 3870 | - |
| [NanoPC T4](http://ix.io/1iWU) | 1800/1400 MHz | 4.17 | Stretch arm64 | 6230 | 1756 | 1023600 | **4100** | 9060 | 10.30 |
| [NanoPC T4](http://ix.io/1iFz) | 1800/1400 MHz | 4.17 | Stretch arm64 | 6250 | 1809 | 1022500 | **4100** | 9000 | 8.24 |
| [Jetson Nano](http://ix.io/3Ufc) | 2000 MHz | 4.9 | Bionic arm64 | 6260 | 1977 | 717500 | **4100** | 11760 | 8.72 |
| [Celeron J3455](http://ix.io/1m5p) | 2300/1500 MHz | 4.17 | Stretch amd64 | 7000 | 2037 | 429660 | **4090** | 4050 | 17.26 |
| [NanoPi M4](http://ix.io/1lzP) | 2000/1500 MHz | 4.19 | Stretch arm64 | 6400 | 1835 | 1128330 | **4080** | 8270 | 8.86 |
| [ODROID-N2+](http://ix.io/3R1a) | 2400/2015 MHz | 5.10 | Focal arm64 | 9680 | 2372 | 1366730 | **4030** | 7120 | - |
| [Celeron N2830](http://ix.io/4pEc) | 2160 MHz | 5.19 | Jammy amd64 | 2760 | 1664 | 31270 | **3780** | 3520 | 6.10 |
| [Celeron J1900](http://ix.io/4hKV) | 2415/1333 MHz | 5.4 | Focal amd64 | 6560 | 1806 | 34900 | **3780** | 3390 | - |
| [Phytium FT-2000/4 1xSO-DIMM](http://ix.io/4ioj) | 2600 MHz | 5.15 | Bullseye arm64 | 10020 | 2755 | 936740 | **3760** | 14540 | - |
| [Jetson Nano](http://ix.io/4rLX) | 1480 MHz | 4.9 | Bullseye arm64 | 5260 | 1578 | 531940 | **3730** | 8870 | - |
| [RockPro64](http://ix.io/1ub9) | 1800/1400 MHz | 4.4 | Stretch arm64 | 6420 | 1673 | 1018480 | **3720** | 8400 | 8.24 |
| [RockPro64](http://ix.io/2sZH) | 2010/1510 MHz | 5.4 | Focal arm64 | 6920 | 1826 | 1145300 | **3700** | 8430 | 11.55 |
| [Khadas VIM3L](http://ix.io/3Vdt) | 1900 MHz | 5.16 | Bullseye arm64 | 5110 | 1403 | 890730 | **3700** | 5140 | - |
| [RockPro64](http://ix.io/2yIx) | 2010/1510 MHz | 5.8 | Bullseye arm64 | 7000 | 1833 | 1144950 | **3690** | 8360 | 11.08 |
| [Khadas VIM3L](http://ix.io/26Wy) | 1900 MHz | 4.9 | Bionic arm64 | 5160 | 1399 | 892110 | **3670** | 6360 | 7.29 |
| [Rock Pi 4](http://ix.io/21fX) | 2000/1500 MHz | 5.3 | Bionic arm64 | 6910 | 1817 | 1147370 | **3660** | 8310 | 10.71 |
| [RockPro64](http://ix.io/1iFp) | 1800/1400 MHz | 4.18 | Stretch arm64 | 6300 | 1755 | 1021500 | **3650** | 8450 | 8.20 |
| [ODROID-HC4](http://ix.io/3Na5) | 2100 MHz | 5.10 | Buster arm64 | 5730 | 1672 | 980970 | **3540** | 5150 | - |
| [ODROID-C4](http://ix.io/3TQ2) | 2100 MHz | 5.10 | Buster arm64 | 5770 | 1679 | 981940 | **3540** | 5150 | - |
| [x7-Z8700](http://ix.io/4iDX) | 2400 MHz | 5.15 | Bullseye amd64 | 6580 | 1784 | 296680 | **3510** | 3580 | - |
| [Phytium D2000 2xSO-DIMM](http://ix.io/446h) | 2300 MHz | 5.19 | Jammy arm64 | 16670 | 2252 | 828130 | **3480** | 16110 | - |
| [Rock Pi 4](http://ix.io/3Q2q) | 2000/1500 MHz | 5.10 | Focal arm64 | 6900 | 1899 | 1146500 | **3430** | 8260 | - |
| [T-HEAD C910 RVB-ICE](http://ix.io/41AB) | 1200 MHz | 5.10 | Sid riscv64 | 1760 | 1007 | 26930 | **3340** | 6470 | - |
| [ODROID-M1](http://ix.io/4ijy) | 2060 MHz | 5.18 | Bullseye arm64 | 5430 | 1567 | 961090 | **3310** | 5960 | 7.76 |
| [ODROID-C4](http://ix.io/2kaS) | 2010 MHz | 4.9 | Focal arm64 | 5450 | 1459 | 941590 | **3310** | 6270 | 7.71 |
| [Quartz64-A](http://ix.io/4qJF) | 1890 MHz | 6.2 | Jammy arm64 | 4980 | 1457 | 884590 | **3240** | 6100 | 6.98 |
| [x5-Z8350](http://ix.io/2Jdb) | 1920/1680 MHz | 5.4 | Focal amd64 | 4790 | 1454 | 237230 | **3170** | 2960 | 9.38 |
| [Radxa ROCK 3A](http://ix.io/40TX) | 2000 MHz | 5.18 | Bullseye arm64 | 5110 | 1450 | 935920 | **3150** | 6250 | 7.58 |
| [RK3568-ROC-PC](http://ix.io/3Rsg) | 1960 MHz | 4.19 | Bullseye arm64 | 5040 | 1424 | 912800 | **3130** | 6240 | - |
| [NanoPi M4v2](http://ix.io/3MAK) | 2015/1510 MHz | 5.10 | Bullseye arm64 | 6680 | 1855 | 921980 | **3110** | 7640 | - |
| [ODROID-M1](http://ix.io/3Ug9) | 1930 MHz | 4.19 | Focal arm64 | 5010 | 1450 | 898610 | **3070** | 6220 | 7.14 |
| [Atom Z3735F](http://ix.io/4r54) | 1830 MHz | 5.15 | Jammy amd64 | 4510 | 1437 | 227900 | **3020** | 2780 | - |
| [NanoPi R5S](http://ix.io/4jfZ) | 1960 MHz | 6.1 | Bullseye arm64 | 5030 | 1482 | 914340 | **2990** | 5970 | 7.33 |
| [Quartz64-A](http://ix.io/3rUb) | 1810 MHz | 5.13 | Buster arm64 | 4840 | 1353 | 845490 | **2980** | 7650| - |
| [Atom E3825](http://ix.io/4kFQ) | 1330 MHz | 5.10 | Bullseye amd64 | 1950 | 1109 | 165840 | **2890** | 2890 | - |
| [Khadas Edge](http://ix.io/1uar) | 2000/1500 MHz | 4.4 | Stretch arm64 | 6600 | 1703 | 1127780 | **2860** | 4880 | 8.85 |
| [Atom E3826](http://ix.io/44pd) | 1460 MHz | 5.18 | Jammy amd64 | 2140 | 1112 | 182190 | **2840** | 2760 | - |
| [Phytium D2000 1xSO-DIMM](http://ix.io/445T) | 2300 MHz | 5.19 | Jammy arm64 | 16390 | 2220 | 827090 | **2820** | 6490 | - |
| [NanoPC T4](http://ix.io/1lkG) | 2000/1500 MHz | 4.4 | Stretch arm64 | 5870 | 1336 | 1124040 | **2810** | 4890 | 8.70 |
| [Khadas Edge](http://ix.io/1rYm) | 2000/1500 MHz | 4.4 | Bionic arm64 | 6550 | 1721 | 1130400 | **2810** | 4860 | 10.50 |
| [Raspberry Pi 4 B](http://ix.io/3Gia) | 1800 MHz | 5.10 | Raspberry Pi OS Buster | 6550 | 1897 | 77830 | **2780** | 3080 | - |
| [RockPro64](http://ix.io/1lBC) | 1800/1400 MHz | 4.4 | Stretch arm64 | 6140 | 1580 | 1015600 | **2770** | 4850 | 8.14 |
| [x5-Z8350](http://ix.io/1HnC) | 1920/1680 MHz | 4.15 | Bionic amd64 | 4710 | 1272 | 207640 | **2740** | 3140 | - |
| [i.MX8MPlus EVK board](http://ix.io/4hx0) | 1800 MHz | 5.15 | Focal arm64 | 4990 | 1348 | 837680 | **2740** | 12420 | 7.02 |
| [Raspberry Pi 400](http://ix.io/2Cyi) | 1800 MHz | 5.4 | Raspberry Pi OS Buster | 6550 | 1903 | 77890 | **2680** | 3110 | - |
| [AMedia X96 Max+](http://ix.io/3QOj) | 2100 MHz | 5.15 | Focal arm64 | 5270 | 1330 | 981830 | **2630** | 5150 | - |
| [Raspberry Pi 4 B](http://ix.io/3InF) | 1800 MHz | 5.15 | Armbian Jammy arm64 | 5640 | 1752 | 36260 | **2580** | 3110 | - |
| [Raspberry Pi 4 B](http://ix.io/3EgS) | 1500 MHz | 5.10 | Raspberry Pi OS Buster | 5750 | 1661 | 64930 | **2550** | 3430 | - |
| [Nintendo Switch](http://ix.io/1Rnj) | 1780 MHz | 4.9 | Fedora 30 arm-64 | 6170 | 1719 | 642670 | **2500** | 3570 | - |
| [Raspberry Pi 4 B](http://ix.io/1MFf) | 1500 MHz | 4.19 | Raspbian Buster | 5500 | 1606 | 64860 | **2460** | 3170 | - |
| [NanoPi NEO4](http://ix.io/3GmR) | 2016/1512 MHz | 5.10 | Focal arm64 | 6970 | 1906 | 1145030 | **2450** | 6190 | 11.36 |
| [x5-Z8300](http://ix.io/1lgD) | 1420 MHz | 4.9 | Stretch amd64 | 3900 | 950 | 178010 | **2380** | 2380 | 7.81 |
| [Nintendo Switch](http://ix.io/3Di2) | 2060 MHz | 4.9 | Bionic arm64 | 6720 | 1901 | 746680 | **2370** | 3670 | 9.25 |
| [NanoPi NEO4](http://ix.io/1p3T) | 2000/1500 MHz | 4.19 | Stretch arm64 | 6750 | 1814 | 1139850 | **2370** | 6110 | 8.84 |
| [Raspberry Pi 4 B](http://ix.io/3OBF) | 1800 MHz | 5.10 | Raspberry Pi OS Bullseye arm64 | 5790 | 1769 | 36260 | **2330** | 3120 | 8.74 |
| [Raspberry Pi 4 B](http://ix.io/3N94) | 1800 MHz | 5.10 | Raspberry Pi OS Bullseye | 5940 | 1738 | 77670 | **2310** | 2690 | - |
| [ODROID-XU4](http://ix.io/3GnC) | 2000/1400 MHz | 5.4 | Focal armhf | 8980 | 1604 | 72020 | **2280** | 4910 | - |
| [NanoPi NEO4](http://ix.io/1oim) | 2000/1500 MHz | 4.4| Stretch arm64 | 6520 | 1718 | 1123190 | **2280** | 4770 | 8.83 |
| [x5-Z8300](http://ix.io/4j4o) | 1840 MHz | 5.15 | Jammy amd64 | 4430 | 1368 | 227030 | **2270** | 2380 | 8.84 |
| [Hugsun X99](http://ix.io/2ICt) | 2088/1800 MHz | 5.9 | Focal arm64 | 7710 | 1927 | 1184306 | **2270** | 5970 | - |
| [NanoPi NEO4](http://ix.io/1oho) | 2000/1500 MHz | 4.4| Stretch arm64 | 6510 | 1703 | 1128860 | **2260** | 4770 | 8.71 |
| [Raspberry Pi 4 B](http://ix.io/3F9C) | 1800 MHz | 5.10 | Raspberry Pi OS Buster arm64 | 5760 | 1741 | 36240 | **2240** | 3120 | 9.46 |
| [ODROID-XU4](http://ix.io/1iWL) | 2000/1400 MHz | 4.9 | Stretch armhf | 6400 | 1622 | 72075 | **2230** | 4850 | - |
| [NanoPi NEO4](http://ix.io/1oib) | 2000/1500 MHz | 4.4| Stretch arm64 | 6030 | 1343 | 1121380 | **2230** | 4770 | 8.57 |
| [HummingBoard Pulse i.MX8M Quad](http://ix.io/27FC) | 1500 MHz | 4.19 | Buster arm64 | 4330 | 1201 | 695540 | **2230** | 9900 | - |
| [ODROID-XU4](http://ix.io/1ixL) | 1900/1400 MHz | 3.10 | Jessie armhf | 6750 | - | 68200 | **2200** | 4800 | - |
| [Atom N2800](http://ix.io/4nt8) | 1860 MHz | 5.15 | Bullseye amd64 | 2970 | 1006 | 21780 | **2050** | 1570 | - |
| [RockPro64](http://ix.io/1iFZ) | 1800/1400 MHz | 4.4 | Stretch armhf | 6250 | 1809 | 1000150 | **2000** | 4835 | - |
| [Khadas VIM1S](http://ix.io/4bbv) | 2000 MHz | 5.4 | Jammy arm64 | 4000 | 1148 | 436540 | **1970** | 7530 | - |
| [Khadas VIM1](http://ix.io/4bee) | 1415 MHz | 5.1 | Buster arm64 | 3860 | 1136 | 660160 | **1940** | 5900 | - |
| [Khadas VIM2](http://ix.io/1iJ7) | 1415/1000 MHz | 4.17 | Bionic arm64 | 5450 | 993 | 659600 | **1920** | 5920 | 8.59 |
| [NanoPi K2](http://ix.io/3Qve) | 1480 MHz | 5.10 | Bullseye arm64 | 3880 | 1154 | 51490 | **1850** | 3790 | - |
| [Le Potato](http://ix.io/1iSQ) | 1410 MHz | 4.18 | Stretch arm64 | 3780 | 1057 | 657200 | **1810** | 5730 | 3.92 |
| [ODROID-C2](http://ix.io/1ixI) | 1750 MHz | 3.14 | Xenial arm64 | 4070 | 1128 | 48500 | **1750** | 3100 | - |
| [AMD E-450 APU](http://ix.io/4hwl) | 1650 MHz | 5.15 | Jammy amd64 | 2430 | 1258 | 27450 | **1710** | 1740 | - |
| [Khadas VIM2](http://ix.io/1ixi) | 1415/1000 MHz | 4.9 | Xenial arm64 | 4800 | 1128 | 659000 | **1690** | 5610 | - |
| [NanoPi K2](http://ix.io/1iT1) | 1480 MHz | 4.14 | Stretch arm64 | 3850 | 1095 | 50370 | **1660** | 3870 | 4.61 |
| [NanoPC T3+](http://ix.io/1iyp) | 1400 MHz | 4.4 | Xenial armhf | 6400 | 943 | 651000 | **1650** | 3700 | - |
| [Libre Computer AML-S912-PC](http://ix.io/40cj) | 1415/1000 MHz | 5.15 | Bullseye arm64 | 5980 | 1012 | 659290 | **1650** | 5170 | - |
| [Radxa Zero](http://ix.io/3PlT) | 1800 MHz | 5.10 | Buster arm64 | 4570 | 1373 | 839080 | **1610** | 5250 | 6.82 |
| [Radxa Zero](http://ix.io/3wZn) | 1800 MHz | 5.10 | Focal arm64 | 4610 | 1267 | 840080 | **1600** | 5370 | - |
| [Radxa Zero](http://ix.io/3JCm) | 1800 MHz | 5.10 | Bullseye arm64 | 4580 | 1353 | 838360 | **1600** | 5360 | 7.13 |
| [ODROID-C2](http://ix.io/4hOp) | 1530 MHz | 5.19 | Jammy arm64 | 4020 | 1187 | 51390 | **1590** | 2730 | - |
| [Renegade](http://ix.io/1iFx) | 1400 MHz | 4.4 | Stretch arm64 | 3710 | 1069 | 644200 | **1565** | 7435 | 3.92 |
| [NanoPi Fire3](http://ix.io/1jjm) | 1400 MHz | 4.14 | Bionic arm64 | 7440 | 1052 | 653000 | **1560** | 4600 | 10.96 |
| [BPi R2](http://ix.io/4dO7) | 1300 MHz | 4.19 | Focal armhf | 2990 | 854 | 25260 | **1550** | 3220 | - |
| [Tinkerboard](http://ix.io/3X9q) | 1800 MHz | 5.10 | Buster armhf | 5770 | 1713 | 67060 | **1540** | 4110 | - |
| [NanoPi Fire3](http://ix.io/3ZxU) | 1400 MHz | 4.14 | Focal arm64 | 7350 | 1093 | 652640 | **1530** | 4590 | 11.18 |
| [NanoPi Fire3](http://ix.io/1jiU) | 1380 MHz | 4.14 | Stretch arm64 | 7420 | 1038 | 645400 | **1520** | 4570 | 8.53 |
| [Tinkerboard](http://ix.io/1iSX) | 1730 MHz | 4.14 | Stretch armhf | 5350 | 1563 | 66600 | **1480** | 3900 | - |
| [Tronsmart MXIII Plus](http://ix.io/3S5U) | 1560 MHz | 5.10 | Buster armhf | 3880 | 1113 | 42570 | **1470** | 3430 | - |
| [NanoPC T3+](http://ix.io/1iRJ) | 1400 MHz | 4.14 | Bionic arm64 | 7480 | 1053 | 652600 | **1440** | 4540 | 10.99 |
| [Rock64](http://ix.io/1iwz) | 1400 MHz | 4.4 | Stretch armhf | 3620 | 1006 | 624000 | **1430** | 3620 | - |
| [PineH64](http://ix.io/26Ph) | 1800 MHz | 5.4 | Buster arm64 | 4710 | 1293 | 839870 | **1420** | 5560 | 7.10 |
| [Atom N270](http://ix.io/461n) | 1600 MHz | 4.19 | Buster i386 | 1220 | 824 | 18760 | **1420** | 2840 | - |
| [PineH64](http://ix.io/1jEr) | 1800 MHz | 4.18 | Stretch arm64 | 4650 | 1274 | 836900 | **1380** | 5530 | 5.62 |
| [Rock64](http://ix.io/1iHo) | 1300 MHz | 4.4 | Stretch arm64 | 3430 | 952 | 601000 | **1350** | 5680 | 3.64 |
| [Tinkerboard](http://ix.io/3Lir) | 1800 MHz | 4.4 | Buster armhf | 5440 | 1693 | 66300 | **1340** | 3510 | - |
| [Rock64](http://ix.io/1iHB) | 1300 MHz | 4.18 | Stretch arm64 | 3560 | 1002 | 603800 | **1340** | 5770 | 3.80 |
| [Rock64](http://ix.io/1iH4) | 1300 MHz | 4.18 | Bionic arm64 | 3530 | 996 | 605250 | **1340** | 5770 | 4.65 |
| [Rock64](http://ix.io/1iYK) | 1400 MHz | 4.4 | Stretch arm64 | 3580 | 1032 | 644380 | **1330** | 5680 | 4.63 |
| [Rock64](http://ix.io/1iFm) | 1400 MHz | 4.4 | Stretch arm64 | 3610 | 1034 | 644250 | **1330** | 5700 | 3.85 |
| [Rock64](http://ix.io/1iZj) | 1400 MHz | 4.4 | Stretch arm64 | 3590 | 1030 | 643700 | **1320** | 5640 | 4.40 |
| [Raspberry Pi Zero 2](http://ix.io/3DeL) | 1200 MHz | 5.10 | Raspberry Pi OS Buster | 3640 | 1007 | 36300 | **1320** | 1790 | - |
| [Rock64](http://ix.io/1iGW) | 1300 MHz | 4.4 | Bionic arm64 | 3410 | 945 | 601200 | **1310** | 5680 | 4.46 |
| [Raspberry Pi Zero 2](http://ix.io/3E85) | 1000 MHz | 5.10 | Raspberry Pi OS Buster | 3030 | 838 | 29860 | **1300** | 1570 | - |
| [MT6580 K9M1](http://ix.io/466y) | 1300 MHz | 5.19 | Sid armhf | 2930 | 860 | 25300 | **1250** | 3300 | - |
| [Raspberry Pi 3 B+](http://ix.io/1iI5) | original | 4.9 | Raspbian Stretch | 3600 | 1076 | 42700 | **1230** | 1640 | - |
| [Raspberry Pi 3 B+](http://ix.io/1iGz) | OC/normal | 4.14 | Raspbian Stretch | 3130 | 843 | 36620 | **1230** | 1780 | - |
| [ClockworkPi R-01](http://ix.io/40BJ) | 1000 MHz | 5.4 | Focal riscv64 | 450 | 450 | 9040 | **1220** | 2640 | - |
| [Raspberry Pi 4 B](http://ix.io/3VME) | 1800 MHz | 5.15 | Jammy armhf | 6300 | 1844 | 82750 | **1190** | 3110 | - |
| [Orange Pi Zero 2](http://ix.io/4knM) | 1510 MHz | 4.9 | Buster arm64 | 3550 | 1067 | 703300 | **1190** | 2820 | 5.01 |
| [Orange Pi Prime](http://ix.io/2kTH) | 1370 MHz | 5.4 | Buster | 3590 | 984 | 637980 | **1180** | 3540 | - |
| [Akaso M8S](http://ix.io/3R3N) | 1200 MHz | 5.10 | Buster armhf | 3050 | 885 | 32120 | **1160** | 3330 | - |
| [Raspberry Pi 3 B+](http://ix.io/1ism) | normal | 4.14 | Raspbian Stretch | 3240 | 914 | 36600 | **1130** | 1530 | - |
| [Raspberry Pi 3 B+](http://ix.io/1isD) | with fan | 4.14 | Raspbian Stretch | 3670 | 1046 | 42600 | **1120** | 1600 | - |
| [Raspberry Pi 3 B](http://ix.io/4hOP) | 1200 MHz | 5.15 | Raspbian Sid | 2970 | 977 | 36230 | **1110** | 1700 | 2.89 |
| [Teres-I](http://ix.io/1tJg) | 1050 MHz | 4.19 | Stretch arm64 | 2785 | 780 | 491590 | **1080** | 2820 | - |
| [Orange Pi PC 2](http://ix.io/3MQJ) | 1370 MHz | 5.10 | Focal arm64 | 3500 | 1023 | 637410 | **1070** | 3680 | - |
| [NanoPi K1 Plus](http://ix.io/3N7H) | 1370 MHz | 5.10 | Focal arm64 | 3520 | 1022 | 638880 | **1070** | 3680 | 5.50 |
| [Raspberry Pi 3 B+](http://ix.io/1iGM) | normal | 4.14 | Raspbian Stretch | 3040 | 856 | 36600 | **1050** | 1500 | - |
| [Raspberry Pi Zero 2](http://ix.io/3Dfo) | 600 MHz | 5.10 | Raspberry Pi OS Buster | 1900 | 529 | 18150 | **1040** | 1130 | - |
| [Raspberry Pi 3 B+](http://ix.io/1iH0) | UV/normal | 4.14 | Raspbian Stretch | 2100 | 856 | 36400 | **1040** | 1460 | - |
| [EspressoBin](http://ix.io/1kt2) | 800 MHz | 4.17 | Stretch arm64 | 1138 | 636 | 368330 | **1040** | 2490 | 1.23 |
| [BPi M4](http://ix.io/1Dt1) | 1400 MHz | 4.9 | Bionic arm64 | 3500 | - | 651460 | **1010** | 4360 | 5.48 |
| [Raspberry Pi 2 B+](http://ix.io/3MGs) | 900 MHz | 5.10 | Raspberry Pi OS Bullseye | 2150 | 620 | 16500 | **1000** | 1180 | - |
| [EspressoBin](http://ix.io/1lCe) | 1200 MHz | 4.18 | Stretch arm64 | 1630 | 869 | 544240 | **1000** | 2400 | 1.82 |
| [MangoPi Mcore](http://ix.io/4bSf) | 1800 MHz | 5.19 | Jammy arm64 | 4100 | 1218 | 840270 | **990** | 2380 | - |
| [TRONFY MXQ S805](http://ix.io/3MiR) | 1536 MHz | 5.10 | Focal armhf | 3100 | 897 | 29080 | **980** | 2990 | - |
| [Helios4](http://ix.io/1jCy) | 1600 MHz | 4.14 | Stretch armhf | 2210 | 1215 | 42500 &ast;98560 | **910** | 4840 | - |
| [Clearfog A1](http://ix.io/4d1U) | 1600 MHz | 5.15 | Bullseye armhf | 2230 | 1239 | 44080 | **910** | 5060 | - |
| [Orange Pi PC Plus](http://ix.io/3MQV) | 1370 MHz | 5.10 | Focal armhf | 3060 | 879 | 26590 | **890** | 3450 | - |
| [StarFive VisionFive V2](http://ix.io/4swT) | 1500 MHz | 5.15 | Sid riscv64 | 3890 | 1196 | 24580 | **880** | 770 | - |
| [Orange Pi Plus 2](http://ix.io/1iX4) | 1300 MHz | 4.14 | Stretch armhf | 2890 | 812 | 25250 | **830** | 3240 | - |
| [NanoPi M1 Plus](http://ix.io/3N2z) | 1370 MHz | 4.19 | Bionic armhf | 3030 | 881 | 26660 | **830** | 3450 | - |
| [Star64](http://ix.io/4tjq) | 1500 MHz | 5.15 | Sid riscv64 | 3970 | 1175 | 24990 | **820** | 770 | - |
| [Rock Pi S](http://ix.io/4sNe) | 1300 MHz | 6.1 | Jammy arm64 | 2540 | 732 | 282030 | **820** | 1870 | - |
| [BPi M2U](http://ix.io/4kmM) | 1200 MHz | 6.0 | Bullseye armhf | 2690 | 767 | 23320 | **780** | 3010 | - |
| [SBC2D70 (SSD202D)](http://ix.io/3N1U) | 1700 MHz | 5.16 | Sid armhf | 1960 | 1094 | 33120 | **770** | 3190 | - |
| [Marvell PXA1908](http://ix.io/46hs) | 1245 MHz | 3.14 | Bullseye arm64 | 3180 | 951 | 581840 | **740** | 2220 | - |
| [RK3318 BOX](http://ix.io/4kor) | 1390 MHz | 6.0 | Jammy arm64 | 3200 | 867 | 644750 | **700** | 2460 | - |
| [Raspberry Pi 2 B+](http://ix.io/1iFf) | 900 MHz | 4.14 | Debian Stretch | 2070 | 592 | 17450 | **615** | 1175 | - |
| [Tronsmart S82](http://ix.io/41ML) | 1600 MHz | 5.14 | Focal armhf | 3640 | 1114 | 43150 | **500** | 3200 | - |
| [Lime A10](http://ix.io/1j1L) | 910 MHz | 4.14 | Stretch armhf | 550 | 550 | 28250 | **440** | 1300 | - |
| [LeMaker Banana Pi](http://ix.io/3PLr) | 960 MHz | 5.10 | Bullseye armhf | 1040 | 542 | 18640 | **440** | 2020 | - |
| [Cubietruck](http://ix.io/3Naw) | 960 MHz | 5.10 | Bullseye armhf | 1030 | 541 | 18640 | **440** | 2010 | - |
| [Raspberry Pi Zero](http://ix.io/3Njz) | 1000 MHz | 5.10 | Bullseye armv6l/armhf | 460 | 460 | 17060 | **430** | 1670 | - |
| [Olimex A20-Lime2](http://ix.io/4rRV) | 960 MHz | 5.10 | Bullseye armhf | 1080 | 589 | 18630 | **430** | 2020 | 0.87 |
| [RK3228A TV Box](http://ix.io/3M9F) | 1200 MHz | 4.4 | Buster armhf | 2310 | 710 | 23070 | **410** | 1230 | - |
| [Raspberry Pi Zero](http://ix.io/1niO) | 1000 MHz | 4.14 | Raspbian Stretch | 450 | 450 | 16820 | **400** | 1590 | - |
| [ODROID-C1](http://ix.io/4eg5) | 1500 MHz | 5.19 | Jammy armhf | 3010 | 878 | 29260 | **390** | 2910 | - |
| [Raspberry Pi B](http://ix.io/3MGN) | 700 MHz | 5.10 | Raspberry Pi OS Bullseye | 320 | 320 | 11630 | **360** | 1420 | - |
| [Raspberry Pi B](http://ix.io/3E7U) | 700 MHz | 5.10 | Raspberry Pi OS Buster | 310 | 310 | 11310 | **340** | 1400 | - |
| [Cubox-i4](http://ix.io/4132) | 980 MHz | 5.15 | Jammy armhf | 2360 | 657 | 27000 | **340** | 340 | - |
| [Ugoos UT2](http://ix.io/408h) | 1560 MHz | 5.10 | Jammy armhf | 3320 | 994 | 43250 | **320** | 2020 | - |
| [Kendryte K510](http://ix.io/41Qa) | 790 MHz | 4.17 | Sid riscv64 | 690 | 402 | 7410 | **280** | 440 | - |

[(back to top of the page)](#sbc-bench-results-sorted)

## memset

| Device / details | Clockspeed | Kernel | Distro | 7-zip multi | 7-zip single | AES | memcpy | *memset* | kH/s |
| ----- | :--------: | :----: | :----: | ----: | ------: | ------: | -----: | -----: | ---: |
| [Apple M1 Pro](http://ix.io/443N) | 3030/2060 MHz | 5.18 | Gentoo 2.8 arm64 | 43800 | 5010 | 1064450 | 27110 | **71910** | 48.28 |
| [Huaqin P6410](http://ix.io/4kiu) | 3000 MHz | 5.4 | Focal arm64 | 430860 | 4211 | 1710010 | 13310 | **47970** | - |
| [Ampere A1](http://ix.io/4dsC) | 3000 MHz | 5.15 | Jammy arm64 | 16300 | 4009 | 1706150 | 11910 | **47780** | - |
| [Qualcomm Snapdragon 8cx Gen 3](http://ix.io/4qG1) | 3000/2440 MHz | 6.2 | Kinetic arm64 | 35320 | 4283 | 1694260 | 17710 | **42110** | 42.76 |
| [Qualcomm Snapdragon 8cx Gen 3 (WSL2)](http://ix.io/4kEp) | 2980/? MHz | 5.15 | Jammy arm64 | 33600 | 4789 | 1679480 | 21010 | **41540** | 50.65 |
| [Pentium G4600](http://ix.io/2jVw) | 3600 MHz | 4.19 | Buster amd64 | 11810 | 4448 | 984820 | 15120 | **33380** | 21.88 |
| [Jetson AGX Orin](http://ix.io/4ax9) | 2200 MHz | 5.10 | Focal arm64 | 39450 | 3187 | 1242940 | 10600 | **30350** | 59.96 |
| [Radxa ROCK 5B](http://ix.io/41BH) | 2350/1830 MHz | 5.10 | Focal arm64 | 16450 | 3146 | 1337540 | 10830 | **29220** | 25.31 |
| [Khadas Edge2](http://ix.io/4a5U) | 2260/1800 MHz | 5.10 | Jammy arm64 | 16470 | 3096 | 1287490 | 10860 | **29110** | - |
| [Qualcomm QRB5165](http://ix.io/49kx) | 2840/2410/1790 MHz | 4.19 | Focal arm64 | 18860 | 3898 | 1598490 | 14470 | **23910** | 25.56 |
| [Jetson Xavier AGX](http://ix.io/4ebH) | 2250 MHz | 4.9 | Bionic arm64 | 21590 | 2742 | 853250 | 10910 | **22520** | 26.57 |
| [Loongson-3A5000-HV](http://ix.io/4dzX) | 2500 MHz | 4.19 | Loongnix 20 loongarch64 | 11120 | 2990 | 116900 | 6930 | **19170** | - |
| [Jetson Xavier NX](http://ix.io/3YWp) | 1890 MHz | 4.9 | Bionic arm64 | 13230 | 2201 | 706280 | 9190 | **18480** | - |
| [Gigabyte H270-T70](http://ix.io/3N5c) | 2000 Mhz | 5.16 | Sid arm64 | 107180 | 1826 | 340750 | 4180 | **17130** | - |
| [Honeycomb LX2](http://ix.io/3Y4f) | 2200 MHz | 5.16 | Fedora 35 aarch64 | 30690 | 2288 | 1251710 | 5050 | **16220** | 46.09 |
| [Phytium D2000 2xSO-DIMM](http://ix.io/446h) | 2300 MHz | 5.19 | Jammy arm64 | 16670 | 2252 | 828130 | 3480 | **16110** | - |
| [Celeron 5205U](http://ix.io/4eiM) | 1900 MHz | 5.15 | Jammy amd64 | 4060 | 2171 | 521090 | 7350 | **16020** | 11.20 |
| [Phytium FT-2000/4 1xSO-DIMM](http://ix.io/4ioj) | 2600 MHz | 5.15 | Bullseye arm64 | 10020 | 2755 | 936740 | 3760 | **14540** | - |
| [Amazon a1.xlarge](http://ix.io/2iFY) | 2300 MHz | 4.15 | Bionic arm64 | 8610 | 2406 | 1297960 | 4280 | **14220** | - |
| [OnePlus 5](http://ix.io/4fdD) | 2360/1900 MHz | 6.1 | Jammy arm64 | 9800 | 2474 | 883330 | 9720 | **14070** | 12.58 |
| [Clearfog CX](http://ix.io/4ju5) | 2000 MHz | 5.10 | Focal arm64 | 25260 | 2236 | 1136690 | 4460 | **12500** | - |
| [i.MX8MPlus EVK board](http://ix.io/4hx0) | 1800 MHz | 5.15 | Focal arm64 | 4990 | 1348 | 837680 | 2740 | **12420** | 7.02 |
| [Jetson Nano](http://ix.io/3Ufc) | 2000 MHz | 4.9 | Bionic arm64 | 6260 | 1977 | 717500 | 4100 | **11760** | 8.72 |
| [Khadas VIM4](http://ix.io/4cHh) | 2200/2010 MHz | 5.4 | Jammy arm64 | 12120 | 2067 | 1254540 | 8180 | **11680** | - |
| [Khadas VIM4](http://ix.io/3Wvv) | 2200/1970 MHz | 5.4 | Focal arm64 | 12090 | 2081 | 1253200 | 7810 | **11600** | - |
| [Pentium N6005](http://ix.io/4f3I) | 3300/2000 MHz | 6.0 | Jammy amd64 | 10810 | 3485 | 922000 | 9600 | **11300** | 20.15 |
| [HummingBoard Pulse i.MX8M Quad](http://ix.io/27FC) | 1500 MHz | 4.19 | Buster arm64 | 4330 | 1201 | 695540 | 2230 | **9900** | - |
| [Khadas VIM3](http://ix.io/1MFD) | 2200/1800 MHz | 4.9 | Bionic arm64 | 8600 | 2026 | 1256910 | 4980 | **9300** | 13.12 |
| [Celeron N5105](http://ix.io/3Qf7) | 2900/2000 MHz | 5.13 | Focal amd64 | 11450 | 3059 | 811760 | 7710 | **9290** | 21.79 |
| [Khadas VIM3](http://ix.io/4o1A) | 2400/2015 MHz | 6.0 | Bullseye arm64 | 9650 | 2379 | 1366300 | 5080 | **9240** | - |
| [ODROID-N2](http://ix.io/3MuT) | 2000/1900 MHz | 5.10 | Buster arm64 | 9090 | 2012 | 1085350 | 4260 | **9080** | - |
| [NanoPC T4](http://ix.io/1iWU) | 1800/1400 MHz | 4.17 | Stretch arm64 | 6230 | 1756 | 1023600 | 4100 | **9060** | 10.30 |
| [NanoPC T4](http://ix.io/1iZq) | 1800/1400 MHz | 4.17 | Stretch arm64 | 6380 | 1741 | 1022600 | 4160 | **9000** | 9.36 |
| [NanoPC T4](http://ix.io/1iFz) | 1800/1400 MHz | 4.17 | Stretch arm64 | 6250 | 1809 | 1022500 | 4100 | **9000** | 8.24 |
| [i3-N305](http://ix.io/4qpr) | 3800 MHz | 5.19 | Jammy amd64 | 20000 | 4398 | 1377280 | 9950 | **8990** | 41.43 |
| [Jetson Nano](http://ix.io/4rLX) | 1480 MHz | 4.9 | Bullseye arm64 | 5260 | 1578 | 531940 | 3730 | **8870** | - |
| [ODROID-N2](http://ix.io/1BsF) | 1800/1900 MHz | 4.9 | Bionic arm64 | 8140 | 1669 | 1024680 | 4120 | **8610** | 11.39 |
| [RockPro64](http://ix.io/1iFp) | 1800/1400 MHz | 4.18 | Stretch arm64 | 6300 | 1755 | 1021500 | 3650 | **8450** | 8.20 |
| [RockPro64](http://ix.io/2sZH) | 2010/1510 MHz | 5.4 | Focal arm64 | 6920 | 1826 | 1145300 | 3700 | **8430** | 11.55 |
| [RockPro64](http://ix.io/1ub9) | 1800/1400 MHz | 4.4 | Stretch arm64 | 6420 | 1673 | 1018480 | 3720 | **8400** | 8.24 |
| [RockPro64](http://ix.io/2yIx) | 2010/1510 MHz | 5.8 | Bullseye arm64 | 7000 | 1833 | 1144950 | 3690 | **8360** | 11.08 |
| [Celeron N4500](http://ix.io/3HUU) | 2800/1100 MHz | 5.13 | Impish amd64 | 6300 | 3091 | 783840 | 8100 | **8350** | - |
| [Rock Pi 4](http://ix.io/21fX) | 2000/1500 MHz | 5.3 | Bionic arm64 | 6910 | 1817 | 1147370 | 3660 | **8310** | 10.71 |
| [NanoPi M4](http://ix.io/1lzP) | 2000/1500 MHz | 4.19 | Stretch arm64 | 6400 | 1835 | 1128330 | 4080 | **8270** | 8.86 |
| [Rock Pi 4](http://ix.io/3Q2q) | 2000/1500 MHz | 5.10 | Focal arm64 | 6900 | 1899 | 1146500 | 3430 | **8260** | - |
| [Celeron N5100](http://ix.io/3IlQ) | 2800/1100 MHz | 5.13 | Focal amd64 | 10550 | 3088 | 783800 | 7750 | **8090** | 19.22 |
| [ODROID-N2+](http://ix.io/4rWn) | 2400/2015 MHz | 6.1 | Bullseye arm64 | 9710 | 2373 | 1366180 | 4220 | **7720** | - |
| [Quartz64-A](http://ix.io/3rUb) | 1810 MHz | 5.13 | Buster arm64 | 4840 | 1353 | 845490 | 2980 | **7650**| - |
| [Celeron J4105](http://ix.io/1qb0) | 2400/1500 MHz | 4.15 | Bionic amd64 | 8960 | 2274 | 697080 | 5620 | **7650** | 19.13 |
| [NanoPi M4v2](http://ix.io/3MAK) | 2015/1510 MHz | 5.10 | Bullseye arm64 | 6680 | 1855 | 921980 | 3110 | **7640** | - |
| [Khadas VIM1S](http://ix.io/4bbv) | 2000 MHz | 5.4 | Jammy arm64 | 4000 | 1148 | 436540 | 1970 | **7530** | - |
| [ODROID-N2+](http://ix.io/3DtN) | 2400/2015 MHz | 5.14 | Impish arm64 | 9790 | 2253 | 1366930 | 4300 | **7480** | - |
| [Renegade](http://ix.io/1iFx) | 1400 MHz | 4.4 | Stretch arm64 | 3710 | 1069 | 644200 | 1565 | **7435** | 3.92 |
| [Celeron J4105](http://ix.io/1qal) | 2400/1500 MHz | 4.15 | Bionic amd64 | 9020 | 2290 | 697100 | 5500 | **7410** | 19.07 |
| [Khadas VIM3](http://ix.io/3R2Z) | 2400/2015 MHz | 5.10 | Bullseye arm64 | 9650 | 2376 | 1366350 | 4850 | **7380** | - |
| [Pentium J5005](http://ix.io/21rE) | 2700/1500 MHz | 5.0 | Bionic amd64 | 9230 | 2455 | 778360 | 5530 | **7130** | 20.74 |
| [ODROID-N2+](http://ix.io/3R1a) | 2400/2015 MHz | 5.10 | Focal arm64 | 9680 | 2372 | 1366730 | 4030 | **7120** | - |
| [Phytium D2000 1xSO-DIMM](http://ix.io/445T) | 2300 MHz | 5.19 | Jammy arm64 | 16390 | 2220 | 827090 | 2820 | **6490** | - |
| [T-HEAD C910 RVB-ICE](http://ix.io/41AB) | 1200 MHz | 5.10 | Sid riscv64 | 1760 | 1007 | 26930 | 3340 | **6470** | - |
| [Khadas VIM3L](http://ix.io/26Wy) | 1900 MHz | 4.9 | Bionic arm64 | 5160 | 1399 | 892110 | 3670 | **6360** | 7.29 |
| [ODROID-C4](http://ix.io/2kaS) | 2010 MHz | 4.9 | Focal arm64 | 5450 | 1459 | 941590 | 3310 | **6270** | 7.71 |
| [Radxa ROCK 3A](http://ix.io/40TX) | 2000 MHz | 5.18 | Bullseye arm64 | 5110 | 1450 | 935920 | 3150 | **6250** | 7.58 |
| [RK3568-ROC-PC](http://ix.io/3Rsg) | 1960 MHz | 4.19 | Bullseye arm64 | 5040 | 1424 | 912800 | 3130 | **6240** | - |
| [ODROID-M1](http://ix.io/3Ug9) | 1930 MHz | 4.19 | Focal arm64 | 5010 | 1450 | 898610 | 3070 | **6220** | 7.14 |
| [NanoPi NEO4](http://ix.io/3GmR) | 2016/1512 MHz | 5.10 | Focal arm64 | 6970 | 1906 | 1145030 | 2450 | **6190** | 11.36 |
| [NanoPi NEO4](http://ix.io/1p3T) | 2000/1500 MHz | 4.19 | Stretch arm64 | 6750 | 1814 | 1139850 | 2370 | **6110** | 8.84 |
| [Quartz64-A](http://ix.io/4qJF) | 1890 MHz | 6.2 | Jammy arm64 | 4980 | 1457 | 884590 | 3240 | **6100** | 6.98 |
| [Ryzen R1606G](http://ix.io/2tQQ) | 2600/1400 MHz | 5.4 | Focal amd64 | 7970 | 2854 | 700780 | 8230 | **5970** | 16.45 |
| [NanoPi R5S](http://ix.io/4jfZ) | 1960 MHz | 6.1 | Bullseye arm64 | 5030 | 1482 | 914340 | 2990 | **5970** | 7.33 |
| [Hugsun X99](http://ix.io/2ICt) | 2088/1800 MHz | 5.9 | Focal arm64 | 7710 | 1927 | 1184306 | 2270 | **5970** | - |
| [ODROID-M1](http://ix.io/4ijy) | 2060 MHz | 5.18 | Bullseye arm64 | 5430 | 1567 | 961090 | 3310 | **5960** | 7.76 |
| [Khadas VIM2](http://ix.io/1iJ7) | 1415/1000 MHz | 4.17 | Bionic arm64 | 5450 | 993 | 659600 | 1920 | **5920** | 8.59 |
| [Khadas VIM1](http://ix.io/4bee) | 1415 MHz | 5.1 | Buster arm64 | 3860 | 1136 | 660160 | 1940 | **5900** | - |
| [Rock64](http://ix.io/1iHB) | 1300 MHz | 4.18 | Stretch arm64 | 3560 | 1002 | 603800 | 1340 | **5770** | 3.80 |
| [Rock64](http://ix.io/1iH4) | 1300 MHz | 4.18 | Bionic arm64 | 3530 | 996 | 605250 | 1340 | **5770** | 4.65 |
| [Le Potato](http://ix.io/1iSQ) | 1410 MHz | 4.18 | Stretch arm64 | 3780 | 1057 | 657200 | 1810 | **5730** | 3.92 |
| [Rock64](http://ix.io/1iFm) | 1400 MHz | 4.4 | Stretch arm64 | 3610 | 1034 | 644250 | 1330 | **5700** | 3.85 |
| [Celeron N3350](http://ix.io/4rJj) | 2400 MHz | 6.0 | Bullseye amd64 | 3810 | 2034 | 446170 | 5190 | **5700** | - |
| [Rock64](http://ix.io/1iYK) | 1400 MHz | 4.4 | Stretch arm64 | 3580 | 1032 | 644380 | 1330 | **5680** | 4.63 |
| [Rock64](http://ix.io/1iHo) | 1300 MHz | 4.4 | Stretch arm64 | 3430 | 952 | 601000 | 1350 | **5680** | 3.64 |
| [Rock64](http://ix.io/1iGW) | 1300 MHz | 4.4 | Bionic arm64 | 3410 | 945 | 601200 | 1310 | **5680** | 4.46 |
| [Rock64](http://ix.io/1iZj) | 1400 MHz | 4.4 | Stretch arm64 | 3590 | 1030 | 643700 | 1320 | **5640** | 4.40 |
| [Khadas VIM2](http://ix.io/1ixi) | 1415/1000 MHz | 4.9 | Xenial arm64 | 4800 | 1128 | 659000 | 1690 | **5610** | - |
| [PineH64](http://ix.io/26Ph) | 1800 MHz | 5.4 | Buster arm64 | 4710 | 1293 | 839870 | 1420 | **5560** | 7.10 |
| [PineH64](http://ix.io/1jEr) | 1800 MHz | 4.18 | Stretch arm64 | 4650 | 1274 | 836900 | 1380 | **5530** | 5.62 |
| [Radxa Zero](http://ix.io/3wZn) | 1800 MHz | 5.10 | Focal arm64 | 4610 | 1267 | 840080 | 1600 | **5370** | - |
| [Radxa Zero](http://ix.io/3JCm) | 1800 MHz | 5.10 | Bullseye arm64 | 4580 | 1353 | 838360 | 1600 | **5360** | 7.13 |
| [Radxa Zero](http://ix.io/3PlT) | 1800 MHz | 5.10 | Buster arm64 | 4570 | 1373 | 839080 | 1610 | **5250** | 6.82 |
| [Celeron N4100](http://ix.io/1uTS) | 2300/1100 MHz | 4.15 | Bionic amd64 | 8510 | 2222 | 669350 | 4750 | **5240** | 18.33 |
| [Pentium J4205](http://ix.io/1m5t) | 2560/1500 MHz | 4.17 | Stretch amd64 | 7570 | 2146 | 480640 | 5070 | **5170** | 18.82 |
| [Libre Computer AML-S912-PC](http://ix.io/40cj) | 1415/1000 MHz | 5.15 | Bullseye arm64 | 5980 | 1012 | 659290 | 1650 | **5170** | - |
| [ODROID-HC4](http://ix.io/3Na5) | 2100 MHz | 5.10 | Buster arm64 | 5730 | 1672 | 980970 | 3540 | **5150** | - |
| [ODROID-C4](http://ix.io/3TQ2) | 2100 MHz | 5.10 | Buster arm64 | 5770 | 1679 | 981940 | 3540 | **5150** | - |
| [AMedia X96 Max+](http://ix.io/3QOj) | 2100 MHz | 5.15 | Focal arm64 | 5270 | 1330 | 981830 | 2630 | **5150** | - |
| [Khadas VIM3L](http://ix.io/3Vdt) | 1900 MHz | 5.16 | Bullseye arm64 | 5110 | 1403 | 890730 | 3700 | **5140** | - |
| [Clearfog A1](http://ix.io/4d1U) | 1600 MHz | 5.15 | Bullseye armhf | 2230 | 1239 | 44080 | 910 | **5060** | - |
| [Pentium N4200](http://ix.io/1ngq) | 2560/1100 MHz | 4.14 | Bionic amd64 | 7469 | 1976 | 468008 | 4682 | **4997** | 18.75 |
| [ODROID-XU4](http://ix.io/3GnC) | 2000/1400 MHz | 5.4 | Focal armhf | 8980 | 1604 | 72020 | 2280 | **4910** | - |
| [NanoPC T4](http://ix.io/1lkG) | 2000/1500 MHz | 4.4 | Stretch arm64 | 5870 | 1336 | 1124040 | 2810 | **4890** | 8.70 |
| [Khadas Edge](http://ix.io/1uar) | 2000/1500 MHz | 4.4 | Stretch arm64 | 6600 | 1703 | 1127780 | 2860 | **4880** | 8.85 |
| [Khadas Edge](http://ix.io/1rYm) | 2000/1500 MHz | 4.4 | Bionic arm64 | 6550 | 1721 | 1130400 | 2810 | **4860** | 10.50 |
| [RockPro64](http://ix.io/1lBC) | 1800/1400 MHz | 4.4 | Stretch arm64 | 6140 | 1580 | 1015600 | 2770 | **4850** | 8.14 |
| [ODROID-XU4](http://ix.io/1iWL) | 2000/1400 MHz | 4.9 | Stretch armhf | 6400 | 1622 | 72075 | 2230 | **4850** | - |
| [Helios4](http://ix.io/1jCy) | 1600 MHz | 4.14 | Stretch armhf | 2210 | 1215 | 42500 &ast;98560 | 910 | **4840** | - |
| [Atom E3950](http://ix.io/4dd5) | 2000 MHz | 5.15 | Jammy amd64 | 6440 | 1636 | 374800 | 4400 | **4840** | - |
| [RockPro64](http://ix.io/1iFZ) | 1800/1400 MHz | 4.4 | Stretch armhf | 6250 | 1809 | 1000150 | 2000 | **4835** | - |
| [ODROID-XU4](http://ix.io/1ixL) | 1900/1400 MHz | 3.10 | Jessie armhf | 6750 | - | 68200 | 2200 | **4800** | - |
| [NanoPi NEO4](http://ix.io/1oim) | 2000/1500 MHz | 4.4| Stretch arm64 | 6520 | 1718 | 1123190 | 2280 | **4770** | 8.83 |
| [NanoPi NEO4](http://ix.io/1oib) | 2000/1500 MHz | 4.4| Stretch arm64 | 6030 | 1343 | 1121380 | 2230 | **4770** | 8.57 |
| [NanoPi NEO4](http://ix.io/1oho) | 2000/1500 MHz | 4.4| Stretch arm64 | 6510 | 1703 | 1128860 | 2260 | **4770** | 8.71 |
| [NanoPi Fire3](http://ix.io/1jjm) | 1400 MHz | 4.14 | Bionic arm64 | 7440 | 1052 | 653000 | 1560 | **4600** | 10.96 |
| [NanoPi Fire3](http://ix.io/3ZxU) | 1400 MHz | 4.14 | Focal arm64 | 7350 | 1093 | 652640 | 1530 | **4590** | 11.18 |
| [NanoPi Fire3](http://ix.io/1jiU) | 1380 MHz | 4.14 | Stretch arm64 | 7420 | 1038 | 645400 | 1520 | **4570** | 8.53 |
| [NanoPC T3+](http://ix.io/1iRJ) | 1400 MHz | 4.14 | Bionic arm64 | 7480 | 1053 | 652600 | 1440 | **4540** | 10.99 |
| [BPi M4](http://ix.io/1Dt1) | 1400 MHz | 4.9 | Bionic arm64 | 3500 | - | 651460 | 1010 | **4360** | 5.48 |
| [Tinkerboard](http://ix.io/3X9q) | 1800 MHz | 5.10 | Buster armhf | 5770 | 1713 | 67060 | 1540 | **4110** | - |
| [Celeron J3455](http://ix.io/1m5p) | 2300/1500 MHz | 4.17 | Stretch amd64 | 7000 | 2037 | 429660 | 4090 | **4050** | 17.26 |
| [Tinkerboard](http://ix.io/1iSX) | 1730 MHz | 4.14 | Stretch armhf | 5350 | 1563 | 66600 | 1480 | **3900** | - |
| [NanoPi K2](http://ix.io/1iT1) | 1480 MHz | 4.14 | Stretch arm64 | 3850 | 1095 | 50370 | 1660 | **3870** | 4.61 |
| [Athlon II X3 420e](http://ix.io/4eOo) | 2600 MHz | 4.19 | Buster amd64 | 4780 | 2566 | 98840 | 4120 | **3870** | - |
| [NanoPi K2](http://ix.io/3Qve) | 1480 MHz | 5.10 | Bullseye arm64 | 3880 | 1154 | 51490 | 1850 | **3790** | - |
| [NanoPC T3+](http://ix.io/1iyp) | 1400 MHz | 4.4 | Xenial armhf | 6400 | 943 | 651000 | 1650 | **3700** | - |
| [Orange Pi PC 2](http://ix.io/3MQJ) | 1370 MHz | 5.10 | Focal arm64 | 3500 | 1023 | 637410 | 1070 | **3680** | - |
| [NanoPi K1 Plus](http://ix.io/3N7H) | 1370 MHz | 5.10 | Focal arm64 | 3520 | 1022 | 638880 | 1070 | **3680** | 5.50 |
| [Nintendo Switch](http://ix.io/3Di2) | 2060 MHz | 4.9 | Bionic arm64 | 6720 | 1901 | 746680 | 2370 | **3670** | 9.25 |
| [Rock64](http://ix.io/1iwz) | 1400 MHz | 4.4 | Stretch armhf | 3620 | 1006 | 624000 | 1430 | **3620** | - |
| [x7-Z8700](http://ix.io/4iDX) | 2400 MHz | 5.15 | Bullseye amd64 | 6580 | 1784 | 296680 | 3510 | **3580** | - |
| [Nintendo Switch](http://ix.io/1Rnj) | 1780 MHz | 4.9 | Fedora 30 arm-64 | 6170 | 1719 | 642670 | 2500 | **3570** | - |
| [Orange Pi Prime](http://ix.io/2kTH) | 1370 MHz | 5.4 | Buster | 3590 | 984 | 637980 | 1180 | **3540** | - |
| [Celeron N2830](http://ix.io/4pEc) | 2160 MHz | 5.19 | Jammy amd64 | 2760 | 1664 | 31270 | 3780 | **3520** | 6.10 |
| [Tinkerboard](http://ix.io/3Lir) | 1800 MHz | 4.4 | Buster armhf | 5440 | 1693 | 66300 | 1340 | **3510** | - |
| [Orange Pi PC Plus](http://ix.io/3MQV) | 1370 MHz | 5.10 | Focal armhf | 3060 | 879 | 26590 | 890 | **3450** | - |
| [NanoPi M1 Plus](http://ix.io/3N2z) | 1370 MHz | 4.19 | Bionic armhf | 3030 | 881 | 26660 | 830 | **3450** | - |
| [Tronsmart MXIII Plus](http://ix.io/3S5U) | 1560 MHz | 5.10 | Buster armhf | 3880 | 1113 | 42570 | 1470 | **3430** | - |
| [Raspberry Pi 4 B](http://ix.io/3EgS) | 1500 MHz | 5.10 | Raspberry Pi OS Buster | 5750 | 1661 | 64930 | 2550 | **3430** | - |
| [Celeron J1900](http://ix.io/4hKV) | 2415/1333 MHz | 5.4 | Focal amd64 | 6560 | 1806 | 34900 | 3780 | **3390** | - |
| [Akaso M8S](http://ix.io/3R3N) | 1200 MHz | 5.10 | Buster armhf | 3050 | 885 | 32120 | 1160 | **3330** | - |
| [MT6580 K9M1](http://ix.io/466y) | 1300 MHz | 5.19 | Sid armhf | 2930 | 860 | 25300 | 1250 | **3300** | - |
| [Orange Pi Plus 2](http://ix.io/1iX4) | 1300 MHz | 4.14 | Stretch armhf | 2890 | 812 | 25250 | 830 | **3240** | - |
| [BPi R2](http://ix.io/4dO7) | 1300 MHz | 4.19 | Focal armhf | 2990 | 854 | 25260 | 1550 | **3220** | - |
| [Tronsmart S82](http://ix.io/41ML) | 1600 MHz | 5.14 | Focal armhf | 3640 | 1114 | 43150 | 500 | **3200** | - |
| [SBC2D70 (SSD202D)](http://ix.io/3N1U) | 1700 MHz | 5.16 | Sid armhf | 1960 | 1094 | 33120 | 770 | **3190** | - |
| [Raspberry Pi 4 B](http://ix.io/1MFf) | 1500 MHz | 4.19 | Raspbian Buster | 5500 | 1606 | 64860 | 2460 | **3170** | - |
| [x5-Z8350](http://ix.io/1HnC) | 1920/1680 MHz | 4.15 | Bionic amd64 | 4710 | 1272 | 207640 | 2740 | **3140** | - |
| [Raspberry Pi 4 B](http://ix.io/3OBF) | 1800 MHz | 5.10 | Raspberry Pi OS Bullseye arm64 | 5790 | 1769 | 36260 | 2330 | **3120** | 8.74 |
| [Raspberry Pi 4 B](http://ix.io/3F9C) | 1800 MHz | 5.10 | Raspberry Pi OS Buster arm64 | 5760 | 1741 | 36240 | 2240 | **3120** | 9.46 |
| [Raspberry Pi 400](http://ix.io/2Cyi) | 1800 MHz | 5.4 | Raspberry Pi OS Buster | 6550 | 1903 | 77890 | 2680 | **3110** | - |
| [Raspberry Pi 4 B](http://ix.io/3VME) | 1800 MHz | 5.15 | Jammy armhf | 6300 | 1844 | 82750 | 1190 | **3110** | - |
| [Raspberry Pi 4 B](http://ix.io/3InF) | 1800 MHz | 5.15 | Armbian Jammy arm64 | 5640 | 1752 | 36260 | 2580 | **3110** | - |
| [ODROID-C2](http://ix.io/1ixI) | 1750 MHz | 3.14 | Xenial arm64 | 4070 | 1128 | 48500 | 1750 | **3100** | - |
| [Raspberry Pi 4 B](http://ix.io/3Gia) | 1800 MHz | 5.10 | Raspberry Pi OS Buster | 6550 | 1897 | 77830 | 2780 | **3080** | - |
| [BPi M2U](http://ix.io/4kmM) | 1200 MHz | 6.0 | Bullseye armhf | 2690 | 767 | 23320 | 780 | **3010** | - |
| [TRONFY MXQ S805](http://ix.io/3MiR) | 1536 MHz | 5.10 | Focal armhf | 3100 | 897 | 29080 | 980 | **2990** | - |
| [x5-Z8350](http://ix.io/2Jdb) | 1920/1680 MHz | 5.4 | Focal amd64 | 4790 | 1454 | 237230 | 3170 | **2960** | 9.38 |
| [ODROID-C1](http://ix.io/4eg5) | 1500 MHz | 5.19 | Jammy armhf | 3010 | 878 | 29260 | 390 | **2910** | - |
| [Atom E3825](http://ix.io/4kFQ) | 1330 MHz | 5.10 | Bullseye amd64 | 1950 | 1109 | 165840 | 2890 | **2890** | - |
| [Atom N270](http://ix.io/461n) | 1600 MHz | 4.19 | Buster i386 | 1220 | 824 | 18760 | 1420 | **2840** | - |
| [Teres-I](http://ix.io/1tJg) | 1050 MHz | 4.19 | Stretch arm64 | 2785 | 780 | 491590 | 1080 | **2820** | - |
| [Orange Pi Zero 2](http://ix.io/4knM) | 1510 MHz | 4.9 | Buster arm64 | 3550 | 1067 | 703300 | 1190 | **2820** | 5.01 |
| [Atom Z3735F](http://ix.io/4r54) | 1830 MHz | 5.15 | Jammy amd64 | 4510 | 1437 | 227900 | 3020 | **2780** | - |
| [Atom E3826](http://ix.io/44pd) | 1460 MHz | 5.18 | Jammy amd64 | 2140 | 1112 | 182190 | 2840 | **2760** | - |
| [ODROID-C2](http://ix.io/4hOp) | 1530 MHz | 5.19 | Jammy arm64 | 4020 | 1187 | 51390 | 1590 | **2730** | - |
| [Raspberry Pi 4 B](http://ix.io/3N94) | 1800 MHz | 5.10 | Raspberry Pi OS Bullseye | 5940 | 1738 | 77670 | 2310 | **2690** | - |
| [ClockworkPi R-01](http://ix.io/40BJ) | 1000 MHz | 5.4 | Focal riscv64 | 450 | 450 | 9040 | 1220 | **2640** | - |
| [EspressoBin](http://ix.io/1kt2) | 800 MHz | 4.17 | Stretch arm64 | 1138 | 636 | 368330 | 1040 | **2490** | 1.23 |
| [RK3318 BOX](http://ix.io/4kor) | 1390 MHz | 6.0 | Jammy arm64 | 3200 | 867 | 644750 | 700 | **2460** | - |
| [EspressoBin](http://ix.io/1lCe) | 1200 MHz | 4.18 | Stretch arm64 | 1630 | 869 | 544240 | 1000 | **2400** | 1.82 |
| [x5-Z8300](http://ix.io/4j4o) | 1840 MHz | 5.15 | Jammy amd64 | 4430 | 1368 | 227030 | 2270 | **2380** | 8.84 |
| [x5-Z8300](http://ix.io/1lgD) | 1420 MHz | 4.9 | Stretch amd64 | 3900 | 950 | 178010 | 2380 | **2380** | 7.81 |
| [MangoPi Mcore](http://ix.io/4bSf) | 1800 MHz | 5.19 | Jammy arm64 | 4100 | 1218 | 840270 | 990 | **2380** | - |
| [Marvell PXA1908](http://ix.io/46hs) | 1245 MHz | 3.14 | Bullseye arm64 | 3180 | 951 | 581840 | 740 | **2220** | - |
| [Ugoos UT2](http://ix.io/408h) | 1560 MHz | 5.10 | Jammy armhf | 3320 | 994 | 43250 | 320 | **2020** | - |
| [Olimex A20-Lime2](http://ix.io/4rRV) | 960 MHz | 5.10 | Bullseye armhf | 1080 | 589 | 18630 | 430 | **2020** | 0.87 |
| [LeMaker Banana Pi](http://ix.io/3PLr) | 960 MHz | 5.10 | Bullseye armhf | 1040 | 542 | 18640 | 440 | **2020** | - |
| [Cubietruck](http://ix.io/3Naw) | 960 MHz | 5.10 | Bullseye armhf | 1030 | 541 | 18640 | 440 | **2010** | - |
| [Rock Pi S](http://ix.io/4sNe) | 1300 MHz | 6.1 | Jammy arm64 | 2540 | 732 | 282030 | 820 | **1870** | - |
| [Raspberry Pi Zero 2](http://ix.io/3DeL) | 1200 MHz | 5.10 | Raspberry Pi OS Buster | 3640 | 1007 | 36300 | 1320 | **1790** | - |
| [Raspberry Pi 3 B+](http://ix.io/1iGz) | OC/normal | 4.14 | Raspbian Stretch | 3130 | 843 | 36620 | 1230 | **1780** | - |
| [AMD E-450 APU](http://ix.io/4hwl) | 1650 MHz | 5.15 | Jammy amd64 | 2430 | 1258 | 27450 | 1710 | **1740** | - |
| [Raspberry Pi 3 B](http://ix.io/4hOP) | 1200 MHz | 5.15 | Raspbian Sid | 2970 | 977 | 36230 | 1110 | **1700** | 2.89 |
| [Raspberry Pi Zero](http://ix.io/3Njz) | 1000 MHz | 5.10 | Bullseye armv6l/armhf | 460 | 460 | 17060 | 430 | **1670** | - |
| [Raspberry Pi 3 B+](http://ix.io/1iI5) | original | 4.9 | Raspbian Stretch | 3600 | 1076 | 42700 | 1230 | **1640** | - |
| [Raspberry Pi 3 B+](http://ix.io/1isD) | with fan | 4.14 | Raspbian Stretch | 3670 | 1046 | 42600 | 1120 | **1600** | - |
| [Raspberry Pi Zero](http://ix.io/1niO) | 1000 MHz | 4.14 | Raspbian Stretch | 450 | 450 | 16820 | 400 | **1590** | - |
| [Raspberry Pi Zero 2](http://ix.io/3E85) | 1000 MHz | 5.10 | Raspberry Pi OS Buster | 3030 | 838 | 29860 | 1300 | **1570** | - |
| [Atom N2800](http://ix.io/4nt8) | 1860 MHz | 5.15 | Bullseye amd64 | 2970 | 1006 | 21780 | 2050 | **1570** | - |
| [Raspberry Pi 3 B+](http://ix.io/1ism) | normal | 4.14 | Raspbian Stretch | 3240 | 914 | 36600 | 1130 | **1530** | - |
| [Raspberry Pi 3 B+](http://ix.io/1iGM) | normal | 4.14 | Raspbian Stretch | 3040 | 856 | 36600 | 1050 | **1500** | - |
| [Raspberry Pi 3 B+](http://ix.io/1iH0) | UV/normal | 4.14 | Raspbian Stretch | 2100 | 856 | 36400 | 1040 | **1460** | - |
| [Raspberry Pi B](http://ix.io/3MGN) | 700 MHz | 5.10 | Raspberry Pi OS Bullseye | 320 | 320 | 11630 | 360 | **1420** | - |
| [Raspberry Pi B](http://ix.io/3E7U) | 700 MHz | 5.10 | Raspberry Pi OS Buster | 310 | 310 | 11310 | 340 | **1400** | - |
| [Lime A10](http://ix.io/1j1L) | 910 MHz | 4.14 | Stretch armhf | 550 | 550 | 28250 | 440 | **1300** | - |
| [RK3228A TV Box](http://ix.io/3M9F) | 1200 MHz | 4.4 | Buster armhf | 2310 | 710 | 23070 | 410 | **1230** | - |
| [Raspberry Pi 2 B+](http://ix.io/3MGs) | 900 MHz | 5.10 | Raspberry Pi OS Bullseye | 2150 | 620 | 16500 | 1000 | **1180** | - |
| [Raspberry Pi 2 B+](http://ix.io/1iFf) | 900 MHz | 4.14 | Debian Stretch | 2070 | 592 | 17450 | 615 | **1175** | - |
| [Raspberry Pi Zero 2](http://ix.io/3Dfo) | 600 MHz | 5.10 | Raspberry Pi OS Buster | 1900 | 529 | 18150 | 1040 | **1130** | - |
| [StarFive VisionFive V2](http://ix.io/4swT) | 1500 MHz | 5.15 | Sid riscv64 | 3890 | 1196 | 24580 | 880 | **770** | - |
| [Star64](http://ix.io/4tjq) | 1500 MHz | 5.15 | Sid riscv64 | 3970 | 1175 | 24990 | 820 | **770** | - |
| [Kendryte K510](http://ix.io/41Qa) | 790 MHz | 4.17 | Sid riscv64 | 690 | 402 | 7410 | 280 | **440** | - |
| [Cubox-i4](http://ix.io/4132) | 980 MHz | 5.15 | Jammy armhf | 2360 | 657 | 27000 | 340 | **340** | - |

[(back to top of the page)](#sbc-bench-results-sorted)

## clockspeed

| Device / details | *Clockspeed* | Kernel | Distro | 7-zip multi | 7-zip single | AES | memcpy | memset | kH/s |
| ----- | :--------: | :----: | :----: | ----: | ------: | ------: | -----: | -----: | ---: |
| [i3-N305](http://ix.io/4qpr) | **3800** MHz| 5.19 | Jammy amd64 | 20000 | 4398 | 1377280 | 9950 | 8990 | 41.43 |
| [Pentium G4600](http://ix.io/2jVw) | **3600** MHz| 4.19 | Buster amd64 | 11810 | 4448 | 984820 | 15120 | 33380 | 21.88 |
| [Pentium N6005](http://ix.io/4f3I) | **3300/2000** MHz| 6.0 | Jammy amd64 | 10810 | 3485 | 922000 | 9600 | 11300 | 20.15 |
| [Apple M1 Pro](http://ix.io/443N) | **3030/2060** MHz| 5.18 | Gentoo 2.8 arm64 | 43800 | 5010 | 1064450 | 27110 | 71910 | 48.28 |
| [Qualcomm Snapdragon 8cx Gen 3](http://ix.io/4qG1) | **3000/2440** MHz| 6.2 | Kinetic arm64 | 35320 | 4283 | 1694260 | 17710 | 42110 | 42.76 |
| [Huaqin P6410](http://ix.io/4kiu) | **3000** MHz| 5.4 | Focal arm64 | 430860 | 4211 | 1710010 | 13310 | 47970 | - |
| [Ampere A1](http://ix.io/4dsC) | **3000** MHz| 5.15 | Jammy arm64 | 16300 | 4009 | 1706150 | 11910 | 47780 | - |
| [Qualcomm Snapdragon 8cx Gen 3 (WSL2)](http://ix.io/4kEp) | **2980/?** MHz| 5.15 | Jammy arm64 | 33600 | 4789 | 1679480 | 21010 | 41540 | 50.65 |
| [Celeron N5105](http://ix.io/3Qf7) | **2900/2000** MHz| 5.13 | Focal amd64 | 11450 | 3059 | 811760 | 7710 | 9290 | 21.79 |
| [Qualcomm QRB5165](http://ix.io/49kx) | **2840/2410/1790** MHz| 4.19 | Focal arm64 | 18860 | 3898 | 1598490 | 14470 | 23910 | 25.56 |
| [Celeron N5100](http://ix.io/3IlQ) | **2800/1100** MHz| 5.13 | Focal amd64 | 10550 | 3088 | 783800 | 7750 | 8090 | 19.22 |
| [Celeron N4500](http://ix.io/3HUU) | **2800/1100** MHz| 5.13 | Impish amd64 | 6300 | 3091 | 783840 | 8100 | 8350 | - |
| [Pentium J5005](http://ix.io/21rE) | **2700/1500** MHz| 5.0 | Bionic amd64 | 9230 | 2455 | 778360 | 5530 | 7130 | 20.74 |
| [Ryzen R1606G](http://ix.io/2tQQ) | **2600/1400** MHz| 5.4 | Focal amd64 | 7970 | 2854 | 700780 | 8230 | 5970 | 16.45 |
| [Phytium FT-2000/4 1xSO-DIMM](http://ix.io/4ioj) | **2600** MHz| 5.15 | Bullseye arm64 | 10020 | 2755 | 936740 | 3760 | 14540 | - |
| [Athlon II X3 420e](http://ix.io/4eOo) | **2600** MHz| 4.19 | Buster amd64 | 4780 | 2566 | 98840 | 4120 | 3870 | - |
| [Pentium N4200](http://ix.io/1ngq) | **2560/1100** MHz| 4.14 | Bionic amd64 | 7469 | 1976 | 468008 | 4682 | 4997 | 18.75 |
| [Pentium J4205](http://ix.io/1m5t) | **2560/1500** MHz| 4.17 | Stretch amd64 | 7570 | 2146 | 480640 | 5070 | 5170 | 18.82 |
| [Loongson-3A5000-HV](http://ix.io/4dzX) | **2500** MHz| 4.19 | Loongnix 20 loongarch64 | 11120 | 2990 | 116900 | 6930 | 19170 | - |
| [Celeron J1900](http://ix.io/4hKV) | **2415/1333** MHz| 5.4 | Focal amd64 | 6560 | 1806 | 34900 | 3780 | 3390 | - |
| [x7-Z8700](http://ix.io/4iDX) | **2400** MHz| 5.15 | Bullseye amd64 | 6580 | 1784 | 296680 | 3510 | 3580 | - |
| [ODROID-N2+](http://ix.io/4rWn) | **2400/2015** MHz| 6.1 | Bullseye arm64 | 9710 | 2373 | 1366180 | 4220 | 7720 | - |
| [ODROID-N2+](http://ix.io/3R1a) | **2400/2015** MHz| 5.10 | Focal arm64 | 9680 | 2372 | 1366730 | 4030 | 7120 | - |
| [ODROID-N2+](http://ix.io/3DtN) | **2400/2015** MHz| 5.14 | Impish arm64 | 9790 | 2253 | 1366930 | 4300 | 7480 | - |
| [Khadas VIM3](http://ix.io/4o1A) | **2400/2015** MHz| 6.0 | Bullseye arm64 | 9650 | 2379 | 1366300 | 5080 | 9240 | - |
| [Khadas VIM3](http://ix.io/3R2Z) | **2400/2015** MHz| 5.10 | Bullseye arm64 | 9650 | 2376 | 1366350 | 4850 | 7380 | - |
| [Celeron N3350](http://ix.io/4rJj) | **2400** MHz| 6.0 | Bullseye amd64 | 3810 | 2034 | 446170 | 5190 | 5700 | - |
| [Celeron J4105](http://ix.io/1qb0) | **2400/1500** MHz| 4.15 | Bionic amd64 | 8960 | 2274 | 697080 | 5620 | 7650 | 19.13 |
| [Celeron J4105](http://ix.io/1qal) | **2400/1500** MHz| 4.15 | Bionic amd64 | 9020 | 2290 | 697100 | 5500 | 7410 | 19.07 |
| [OnePlus 5](http://ix.io/4fdD) | **2360/1900** MHz| 6.1 | Jammy arm64 | 9800 | 2474 | 883330 | 9720 | 14070 | 12.58 |
| [Radxa ROCK 5B](http://ix.io/41BH) | **2350/1830** MHz| 5.10 | Focal arm64 | 16450 | 3146 | 1337540 | 10830 | 29220 | 25.31 |
| [Phytium D2000 2xSO-DIMM](http://ix.io/446h) | **2300** MHz| 5.19 | Jammy arm64 | 16670 | 2252 | 828130 | 3480 | 16110 | - |
| [Phytium D2000 1xSO-DIMM](http://ix.io/445T) | **2300** MHz| 5.19 | Jammy arm64 | 16390 | 2220 | 827090 | 2820 | 6490 | - |
| [Celeron N4100](http://ix.io/1uTS) | **2300/1100** MHz| 4.15 | Bionic amd64 | 8510 | 2222 | 669350 | 4750 | 5240 | 18.33 |
| [Celeron J3455](http://ix.io/1m5p) | **2300/1500** MHz| 4.17 | Stretch amd64 | 7000 | 2037 | 429660 | 4090 | 4050 | 17.26 |
| [Amazon a1.xlarge](http://ix.io/2iFY) | **2300** MHz| 4.15 | Bionic arm64 | 8610 | 2406 | 1297960 | 4280 | 14220 | - |
| [Khadas Edge2](http://ix.io/4a5U) | **2260/1800** MHz| 5.10 | Jammy arm64 | 16470 | 3096 | 1287490 | 10860 | 29110 | - |
| [Jetson Xavier AGX](http://ix.io/4ebH) | **2250** MHz| 4.9 | Bionic arm64 | 21590 | 2742 | 853250 | 10910 | 22520 | 26.57 |
| [Khadas VIM4](http://ix.io/4cHh) | **2200/2010** MHz| 5.4 | Jammy arm64 | 12120 | 2067 | 1254540 | 8180 | 11680 | - |
| [Khadas VIM4](http://ix.io/3Wvv) | **2200/1970** MHz| 5.4 | Focal arm64 | 12090 | 2081 | 1253200 | 7810 | 11600 | - |
| [Khadas VIM3](http://ix.io/1MFD) | **2200/1800** MHz| 4.9 | Bionic arm64 | 8600 | 2026 | 1256910 | 4980 | 9300 | 13.12 |
| [Jetson AGX Orin](http://ix.io/4ax9) | **2200** MHz| 5.10 | Focal arm64 | 39450 | 3187 | 1242940 | 10600 | 30350 | 59.96 |
| [Honeycomb LX2](http://ix.io/3Y4f) | **2200** MHz| 5.16 | Fedora 35 aarch64 | 30690 | 2288 | 1251710 | 5050 | 16220 | 46.09 |
| [Celeron N2830](http://ix.io/4pEc) | **2160** MHz| 5.19 | Jammy amd64 | 2760 | 1664 | 31270 | 3780 | 3520 | 6.10 |
| [ODROID-HC4](http://ix.io/3Na5) | **2100** MHz| 5.10 | Buster arm64 | 5730 | 1672 | 980970 | 3540 | 5150 | - |
| [ODROID-C4](http://ix.io/3TQ2) | **2100** MHz| 5.10 | Buster arm64 | 5770 | 1679 | 981940 | 3540 | 5150 | - |
| [AMedia X96 Max+](http://ix.io/3QOj) | **2100** MHz| 5.15 | Focal arm64 | 5270 | 1330 | 981830 | 2630 | 5150 | - |
| [Hugsun X99](http://ix.io/2ICt) | **2088/1800** MHz| 5.9 | Focal arm64 | 7710 | 1927 | 1184306 | 2270 | 5970 | - |
| [ODROID-M1](http://ix.io/4ijy) | **2060** MHz| 5.18 | Bullseye arm64 | 5430 | 1567 | 961090 | 3310 | 5960 | 7.76 |
| [Nintendo Switch](http://ix.io/3Di2) | **2060** MHz| 4.9 | Bionic arm64 | 6720 | 1901 | 746680 | 2370 | 3670 | 9.25 |
| [NanoPi NEO4](http://ix.io/3GmR) | **2016/1512** MHz| 5.10 | Focal arm64 | 6970 | 1906 | 1145030 | 2450 | 6190 | 11.36 |
| [NanoPi M4v2](http://ix.io/3MAK) | **2015/1510** MHz| 5.10 | Bullseye arm64 | 6680 | 1855 | 921980 | 3110 | 7640 | - |
| [RockPro64](http://ix.io/2yIx) | **2010/1510** MHz| 5.8 | Bullseye arm64 | 7000 | 1833 | 1144950 | 3690 | 8360 | 11.08 |
| [RockPro64](http://ix.io/2sZH) | **2010/1510** MHz| 5.4 | Focal arm64 | 6920 | 1826 | 1145300 | 3700 | 8430 | 11.55 |
| [ODROID-C4](http://ix.io/2kaS) | **2010** MHz| 4.9 | Focal arm64 | 5450 | 1459 | 941590 | 3310 | 6270 | 7.71 |
| [Rock Pi 4](http://ix.io/3Q2q) | **2000/1500** MHz| 5.10 | Focal arm64 | 6900 | 1899 | 1146500 | 3430 | 8260 | - |
| [Rock Pi 4](http://ix.io/21fX) | **2000/1500** MHz| 5.3 | Bionic arm64 | 6910 | 1817 | 1147370 | 3660 | 8310 | 10.71 |
| [Radxa ROCK 3A](http://ix.io/40TX) | **2000** MHz| 5.18 | Bullseye arm64 | 5110 | 1450 | 935920 | 3150 | 6250 | 7.58 |
| [ODROID-XU4](http://ix.io/3GnC) | **2000/1400** MHz| 5.4 | Focal armhf | 8980 | 1604 | 72020 | 2280 | 4910 | - |
| [ODROID-XU4](http://ix.io/1iWL) | **2000/1400** MHz| 4.9 | Stretch armhf | 6400 | 1622 | 72075 | 2230 | 4850 | - |
| [ODROID-N2](http://ix.io/3MuT) | **2000/1900** MHz| 5.10 | Buster arm64 | 9090 | 2012 | 1085350 | 4260 | 9080 | - |
| [NanoPi NEO4](http://ix.io/1p3T) | **2000/1500** MHz| 4.19 | Stretch arm64 | 6750 | 1814 | 1139850 | 2370 | 6110 | 8.84 |
| [NanoPi NEO4](http://ix.io/1oim) | **2000/1500** MHz| 4.4| Stretch arm64 | 6520 | 1718 | 1123190 | 2280 | 4770 | 8.83 |
| [NanoPi NEO4](http://ix.io/1oib) | **2000/1500** MHz| 4.4| Stretch arm64 | 6030 | 1343 | 1121380 | 2230 | 4770 | 8.57 |
| [NanoPi NEO4](http://ix.io/1oho) | **2000/1500** MHz| 4.4| Stretch arm64 | 6510 | 1703 | 1128860 | 2260 | 4770 | 8.71 |
| [NanoPi M4](http://ix.io/1lzP) | **2000/1500** MHz| 4.19 | Stretch arm64 | 6400 | 1835 | 1128330 | 4080 | 8270 | 8.86 |
| [NanoPC T4](http://ix.io/1lkG) | **2000/1500** MHz| 4.4 | Stretch arm64 | 5870 | 1336 | 1124040 | 2810 | 4890 | 8.70 |
| [Khadas VIM1S](http://ix.io/4bbv) | **2000** MHz| 5.4 | Jammy arm64 | 4000 | 1148 | 436540 | 1970 | 7530 | - |
| [Khadas Edge](http://ix.io/1uar) | **2000/1500** MHz| 4.4 | Stretch arm64 | 6600 | 1703 | 1127780 | 2860 | 4880 | 8.85 |
| [Khadas Edge](http://ix.io/1rYm) | **2000/1500** MHz| 4.4 | Bionic arm64 | 6550 | 1721 | 1130400 | 2810 | 4860 | 10.50 |
| [Jetson Nano](http://ix.io/3Ufc) | **2000** MHz| 4.9 | Bionic arm64 | 6260 | 1977 | 717500 | 4100 | 11760 | 8.72 |
| [Clearfog CX](http://ix.io/4ju5) | **2000** MHz| 5.10 | Focal arm64 | 25260 | 2236 | 1136690 | 4460 | 12500 | - |
| [Atom E3950](http://ix.io/4dd5) | **2000** MHz| 5.15 | Jammy amd64 | 6440 | 1636 | 374800 | 4400 | 4840 | - |
| [RK3568-ROC-PC](http://ix.io/3Rsg) | **1960** MHz| 4.19 | Bullseye arm64 | 5040 | 1424 | 912800 | 3130 | 6240 | - |
| [NanoPi R5S](http://ix.io/4jfZ) | **1960** MHz| 6.1 | Bullseye arm64 | 5030 | 1482 | 914340 | 2990 | 5970 | 7.33 |
| [ODROID-M1](http://ix.io/3Ug9) | **1930** MHz| 4.19 | Focal arm64 | 5010 | 1450 | 898610 | 3070 | 6220 | 7.14 |
| [x5-Z8350](http://ix.io/2Jdb) | **1920/1680** MHz| 5.4 | Focal amd64 | 4790 | 1454 | 237230 | 3170 | 2960 | 9.38 |
| [x5-Z8350](http://ix.io/1HnC) | **1920/1680** MHz| 4.15 | Bionic amd64 | 4710 | 1272 | 207640 | 2740 | 3140 | - |
| [ODROID-XU4](http://ix.io/1ixL) | **1900/1400** MHz| 3.10 | Jessie armhf | 6750 | - | 68200 | 2200 | 4800 | - |
| [Khadas VIM3L](http://ix.io/3Vdt) | **1900** MHz| 5.16 | Bullseye arm64 | 5110 | 1403 | 890730 | 3700 | 5140 | - |
| [Khadas VIM3L](http://ix.io/26Wy) | **1900** MHz| 4.9 | Bionic arm64 | 5160 | 1399 | 892110 | 3670 | 6360 | 7.29 |
| [Celeron 5205U](http://ix.io/4eiM) | **1900** MHz| 5.15 | Jammy amd64 | 4060 | 2171 | 521090 | 7350 | 16020 | 11.20 |
| [Quartz64-A](http://ix.io/4qJF) | **1890** MHz| 6.2 | Jammy arm64 | 4980 | 1457 | 884590 | 3240 | 6100 | 6.98 |
| [Jetson Xavier NX](http://ix.io/3YWp) | **1890** MHz| 4.9 | Bionic arm64 | 13230 | 2201 | 706280 | 9190 | 18480 | - |
| [Atom N2800](http://ix.io/4nt8) | **1860** MHz| 5.15 | Bullseye amd64 | 2970 | 1006 | 21780 | 2050 | 1570 | - |
| [x5-Z8300](http://ix.io/4j4o) | **1840** MHz| 5.15 | Jammy amd64 | 4430 | 1368 | 227030 | 2270 | 2380 | 8.84 |
| [Atom Z3735F](http://ix.io/4r54) | **1830** MHz| 5.15 | Jammy amd64 | 4510 | 1437 | 227900 | 3020 | 2780 | - |
| [Quartz64-A](http://ix.io/3rUb) | **1810** MHz| 5.13 | Buster arm64 | 4840 | 1353 | 845490 | 2980 | 7650| - |
| [i.MX8MPlus EVK board](http://ix.io/4hx0) | **1800** MHz| 5.15 | Focal arm64 | 4990 | 1348 | 837680 | 2740 | 12420 | 7.02 |
| [Tinkerboard](http://ix.io/3X9q) | **1800** MHz| 5.10 | Buster armhf | 5770 | 1713 | 67060 | 1540 | 4110 | - |
| [Tinkerboard](http://ix.io/3Lir) | **1800** MHz| 4.4 | Buster armhf | 5440 | 1693 | 66300 | 1340 | 3510 | - |
| [RockPro64](http://ix.io/1ub9) | **1800/1400** MHz| 4.4 | Stretch arm64 | 6420 | 1673 | 1018480 | 3720 | 8400 | 8.24 |
| [RockPro64](http://ix.io/1lBC) | **1800/1400** MHz| 4.4 | Stretch arm64 | 6140 | 1580 | 1015600 | 2770 | 4850 | 8.14 |
| [RockPro64](http://ix.io/1iFp) | **1800/1400** MHz| 4.18 | Stretch arm64 | 6300 | 1755 | 1021500 | 3650 | 8450 | 8.20 |
| [RockPro64](http://ix.io/1iFZ) | **1800/1400** MHz| 4.4 | Stretch armhf | 6250 | 1809 | 1000150 | 2000 | 4835 | - |
| [Raspberry Pi 400](http://ix.io/2Cyi) | **1800** MHz| 5.4 | Raspberry Pi OS Buster | 6550 | 1903 | 77890 | 2680 | 3110 | - |
| [Raspberry Pi 4 B](http://ix.io/3VME) | **1800** MHz| 5.15 | Jammy armhf | 6300 | 1844 | 82750 | 1190 | 3110 | - |
| [Raspberry Pi 4 B](http://ix.io/3OBF) | **1800** MHz| 5.10 | Raspberry Pi OS Bullseye arm64 | 5790 | 1769 | 36260 | 2330 | 3120 | 8.74 |
| [Raspberry Pi 4 B](http://ix.io/3N94) | **1800** MHz| 5.10 | Raspberry Pi OS Bullseye | 5940 | 1738 | 77670 | 2310 | 2690 | - |
| [Raspberry Pi 4 B](http://ix.io/3InF) | **1800** MHz| 5.15 | Armbian Jammy arm64 | 5640 | 1752 | 36260 | 2580 | 3110 | - |
| [Raspberry Pi 4 B](http://ix.io/3Gia) | **1800** MHz| 5.10 | Raspberry Pi OS Buster | 6550 | 1897 | 77830 | 2780 | 3080 | - |
| [Raspberry Pi 4 B](http://ix.io/3F9C) | **1800** MHz| 5.10 | Raspberry Pi OS Buster arm64 | 5760 | 1741 | 36240 | 2240 | 3120 | 9.46 |
| [Radxa Zero](http://ix.io/3wZn) | **1800** MHz| 5.10 | Focal arm64 | 4610 | 1267 | 840080 | 1600 | 5370 | - |
| [Radxa Zero](http://ix.io/3PlT) | **1800** MHz| 5.10 | Buster arm64 | 4570 | 1373 | 839080 | 1610 | 5250 | 6.82 |
| [Radxa Zero](http://ix.io/3JCm) | **1800** MHz| 5.10 | Bullseye arm64 | 4580 | 1353 | 838360 | 1600 | 5360 | 7.13 |
| [PineH64](http://ix.io/26Ph) | **1800** MHz| 5.4 | Buster arm64 | 4710 | 1293 | 839870 | 1420 | 5560 | 7.10 |
| [PineH64](http://ix.io/1jEr) | **1800** MHz| 4.18 | Stretch arm64 | 4650 | 1274 | 836900 | 1380 | 5530 | 5.62 |
| [ODROID-N2](http://ix.io/1BsF) | **1800/1900** MHz| 4.9 | Bionic arm64 | 8140 | 1669 | 1024680 | 4120 | 8610 | 11.39 |
| [NanoPC T4](http://ix.io/1iZq) | **1800/1400** MHz| 4.17 | Stretch arm64 | 6380 | 1741 | 1022600 | 4160 | 9000 | 9.36 |
| [NanoPC T4](http://ix.io/1iWU) | **1800/1400** MHz| 4.17 | Stretch arm64 | 6230 | 1756 | 1023600 | 4100 | 9060 | 10.30 |
| [NanoPC T4](http://ix.io/1iFz) | **1800/1400** MHz| 4.17 | Stretch arm64 | 6250 | 1809 | 1022500 | 4100 | 9000 | 8.24 |
| [MangoPi Mcore](http://ix.io/4bSf) | **1800** MHz| 5.19 | Jammy arm64 | 4100 | 1218 | 840270 | 990 | 2380 | - |
| [Nintendo Switch](http://ix.io/1Rnj) | **1780** MHz| 4.9 | Fedora 30 arm-64 | 6170 | 1719 | 642670 | 2500 | 3570 | - |
| [ODROID-C2](http://ix.io/1ixI) | **1750** MHz| 3.14 | Xenial arm64 | 4070 | 1128 | 48500 | 1750 | 3100 | - |
| [Tinkerboard](http://ix.io/1iSX) | **1730** MHz| 4.14 | Stretch armhf | 5350 | 1563 | 66600 | 1480 | 3900 | - |
| [SBC2D70 (SSD202D)](http://ix.io/3N1U) | **1700** MHz| 5.16 | Sid armhf | 1960 | 1094 | 33120 | 770 | 3190 | - |
| [AMD E-450 APU](http://ix.io/4hwl) | **1650** MHz| 5.15 | Jammy amd64 | 2430 | 1258 | 27450 | 1710 | 1740 | - |
| [Tronsmart S82](http://ix.io/41ML) | **1600** MHz| 5.14 | Focal armhf | 3640 | 1114 | 43150 | 500 | 3200 | - |
| [Helios4](http://ix.io/1jCy) | **1600** MHz| 4.14 | Stretch armhf | 2210 | 1215 | 42500 &ast;98560 | 910 | 4840 | - |
| [Clearfog A1](http://ix.io/4d1U) | **1600** MHz| 5.15 | Bullseye armhf | 2230 | 1239 | 44080 | 910 | 5060 | - |
| [Atom N270](http://ix.io/461n) | **1600** MHz| 4.19 | Buster i386 | 1220 | 824 | 18760 | 1420 | 2840 | - |
| [Ugoos UT2](http://ix.io/408h) | **1560** MHz| 5.10 | Jammy armhf | 3320 | 994 | 43250 | 320 | 2020 | - |
| [Tronsmart MXIII Plus](http://ix.io/3S5U) | **1560** MHz| 5.10 | Buster armhf | 3880 | 1113 | 42570 | 1470 | 3430 | - |
| [TRONFY MXQ S805](http://ix.io/3MiR) | **1536** MHz| 5.10 | Focal armhf | 3100 | 897 | 29080 | 980 | 2990 | - |
| [ODROID-C2](http://ix.io/4hOp) | **1530** MHz| 5.19 | Jammy arm64 | 4020 | 1187 | 51390 | 1590 | 2730 | - |
| [Orange Pi Zero 2](http://ix.io/4knM) | **1510** MHz| 4.9 | Buster arm64 | 3550 | 1067 | 703300 | 1190 | 2820 | 5.01 |
| [StarFive VisionFive V2](http://ix.io/4swT) | **1500** MHz| 5.15 | Sid riscv64 | 3890 | 1196 | 24580 | 880 | 770 | - |
| [Star64](http://ix.io/4tjq) | **1500** MHz| 5.15 | Sid riscv64 | 3970 | 1175 | 24990 | 820 | 770 | - |
| [Raspberry Pi 4 B](http://ix.io/3EgS) | **1500** MHz| 5.10 | Raspberry Pi OS Buster | 5750 | 1661 | 64930 | 2550 | 3430 | - |
| [Raspberry Pi 4 B](http://ix.io/1MFf) | **1500** MHz| 4.19 | Raspbian Buster | 5500 | 1606 | 64860 | 2460 | 3170 | - |
| [ODROID-C1](http://ix.io/4eg5) | **1500** MHz| 5.19 | Jammy armhf | 3010 | 878 | 29260 | 390 | 2910 | - |
| [HummingBoard Pulse i.MX8M Quad](http://ix.io/27FC) | **1500** MHz| 4.19 | Buster arm64 | 4330 | 1201 | 695540 | 2230 | 9900 | - |
| [NanoPi K2](http://ix.io/3Qve) | **1480** MHz| 5.10 | Bullseye arm64 | 3880 | 1154 | 51490 | 1850 | 3790 | - |
| [NanoPi K2](http://ix.io/1iT1) | **1480** MHz| 4.14 | Stretch arm64 | 3850 | 1095 | 50370 | 1660 | 3870 | 4.61 |
| [Jetson Nano](http://ix.io/4rLX) | **1480** MHz| 4.9 | Bullseye arm64 | 5260 | 1578 | 531940 | 3730 | 8870 | - |
| [Atom E3826](http://ix.io/44pd) | **1460** MHz| 5.18 | Jammy amd64 | 2140 | 1112 | 182190 | 2840 | 2760 | - |
| [x5-Z8300](http://ix.io/1lgD) | **1420** MHz| 4.9 | Stretch amd64 | 3900 | 950 | 178010 | 2380 | 2380 | 7.81 |
| [Libre Computer AML-S912-PC](http://ix.io/40cj) | **1415/1000** MHz| 5.15 | Bullseye arm64 | 5980 | 1012 | 659290 | 1650 | 5170 | - |
| [Khadas VIM2](http://ix.io/1ixi) | **1415/1000** MHz| 4.9 | Xenial arm64 | 4800 | 1128 | 659000 | 1690 | 5610 | - |
| [Khadas VIM2](http://ix.io/1iJ7) | **1415/1000** MHz| 4.17 | Bionic arm64 | 5450 | 993 | 659600 | 1920 | 5920 | 8.59 |
| [Khadas VIM1](http://ix.io/4bee) | **1415** MHz| 5.1 | Buster arm64 | 3860 | 1136 | 660160 | 1940 | 5900 | - |
| [Le Potato](http://ix.io/1iSQ) | **1410** MHz| 4.18 | Stretch arm64 | 3780 | 1057 | 657200 | 1810 | 5730 | 3.92 |
| [Rock64](http://ix.io/1iwz) | **1400** MHz| 4.4 | Stretch armhf | 3620 | 1006 | 624000 | 1430 | 3620 | - |
| [Rock64](http://ix.io/1iZj) | **1400** MHz| 4.4 | Stretch arm64 | 3590 | 1030 | 643700 | 1320 | 5640 | 4.40 |
| [Rock64](http://ix.io/1iYK) | **1400** MHz| 4.4 | Stretch arm64 | 3580 | 1032 | 644380 | 1330 | 5680 | 4.63 |
| [Rock64](http://ix.io/1iFm) | **1400** MHz| 4.4 | Stretch arm64 | 3610 | 1034 | 644250 | 1330 | 5700 | 3.85 |
| [Renegade](http://ix.io/1iFx) | **1400** MHz| 4.4 | Stretch arm64 | 3710 | 1069 | 644200 | 1565 | 7435 | 3.92 |
| [NanoPi Fire3](http://ix.io/3ZxU) | **1400** MHz| 4.14 | Focal arm64 | 7350 | 1093 | 652640 | 1530 | 4590 | 11.18 |
| [NanoPi Fire3](http://ix.io/1jjm) | **1400** MHz| 4.14 | Bionic arm64 | 7440 | 1052 | 653000 | 1560 | 4600 | 10.96 |
| [NanoPC T3+](http://ix.io/1iyp) | **1400** MHz| 4.4 | Xenial armhf | 6400 | 943 | 651000 | 1650 | 3700 | - |
| [NanoPC T3+](http://ix.io/1iRJ) | **1400** MHz| 4.14 | Bionic arm64 | 7480 | 1053 | 652600 | 1440 | 4540 | 10.99 |
| [BPi M4](http://ix.io/1Dt1) | **1400** MHz| 4.9 | Bionic arm64 | 3500 | - | 651460 | 1010 | 4360 | 5.48 |
| [RK3318 BOX](http://ix.io/4kor) | **1390** MHz| 6.0 | Jammy arm64 | 3200 | 867 | 644750 | 700 | 2460 | - |
| [NanoPi Fire3](http://ix.io/1jiU) | **1380** MHz| 4.14 | Stretch arm64 | 7420 | 1038 | 645400 | 1520 | 4570 | 8.53 |
| [Orange Pi Prime](http://ix.io/2kTH) | **1370** MHz| 5.4 | Buster | 3590 | 984 | 637980 | 1180 | 3540 | - |
| [Orange Pi PC Plus](http://ix.io/3MQV) | **1370** MHz| 5.10 | Focal armhf | 3060 | 879 | 26590 | 890 | 3450 | - |
| [Orange Pi PC 2](http://ix.io/3MQJ) | **1370** MHz| 5.10 | Focal arm64 | 3500 | 1023 | 637410 | 1070 | 3680 | - |
| [NanoPi M1 Plus](http://ix.io/3N2z) | **1370** MHz| 4.19 | Bionic armhf | 3030 | 881 | 26660 | 830 | 3450 | - |
| [NanoPi K1 Plus](http://ix.io/3N7H) | **1370** MHz| 5.10 | Focal arm64 | 3520 | 1022 | 638880 | 1070 | 3680 | 5.50 |
| [Atom E3825](http://ix.io/4kFQ) | **1330** MHz| 5.10 | Bullseye amd64 | 1950 | 1109 | 165840 | 2890 | 2890 | - |
| [Rock64](http://ix.io/1iHo) | **1300** MHz| 4.4 | Stretch arm64 | 3430 | 952 | 601000 | 1350 | 5680 | 3.64 |
| [Rock64](http://ix.io/1iHB) | **1300** MHz| 4.18 | Stretch arm64 | 3560 | 1002 | 603800 | 1340 | 5770 | 3.80 |
| [Rock64](http://ix.io/1iH4) | **1300** MHz| 4.18 | Bionic arm64 | 3530 | 996 | 605250 | 1340 | 5770 | 4.65 |
| [Rock64](http://ix.io/1iGW) | **1300** MHz| 4.4 | Bionic arm64 | 3410 | 945 | 601200 | 1310 | 5680 | 4.46 |
| [Rock Pi S](http://ix.io/4sNe) | **1300** MHz| 6.1 | Jammy arm64 | 2540 | 732 | 282030 | 820 | 1870 | - |
| [Orange Pi Plus 2](http://ix.io/1iX4) | **1300** MHz| 4.14 | Stretch armhf | 2890 | 812 | 25250 | 830 | 3240 | - |
| [MT6580 K9M1](http://ix.io/466y) | **1300** MHz| 5.19 | Sid armhf | 2930 | 860 | 25300 | 1250 | 3300 | - |
| [BPi R2](http://ix.io/4dO7) | **1300** MHz| 4.19 | Focal armhf | 2990 | 854 | 25260 | 1550 | 3220 | - |
| [Marvell PXA1908](http://ix.io/46hs) | **1245** MHz| 3.14 | Bullseye arm64 | 3180 | 951 | 581840 | 740 | 2220 | - |
| [T-HEAD C910 RVB-ICE](http://ix.io/41AB) | **1200** MHz| 5.10 | Sid riscv64 | 1760 | 1007 | 26930 | 3340 | 6470 | - |
| [Raspberry Pi Zero 2](http://ix.io/3DeL) | **1200** MHz| 5.10 | Raspberry Pi OS Buster | 3640 | 1007 | 36300 | 1320 | 1790 | - |
| [Raspberry Pi 3 B](http://ix.io/4hOP) | **1200** MHz| 5.15 | Raspbian Sid | 2970 | 977 | 36230 | 1110 | 1700 | 2.89 |
| [RK3228A TV Box](http://ix.io/3M9F) | **1200** MHz| 4.4 | Buster armhf | 2310 | 710 | 23070 | 410 | 1230 | - |
| [EspressoBin](http://ix.io/1lCe) | **1200** MHz| 4.18 | Stretch arm64 | 1630 | 869 | 544240 | 1000 | 2400 | 1.82 |
| [BPi M2U](http://ix.io/4kmM) | **1200** MHz| 6.0 | Bullseye armhf | 2690 | 767 | 23320 | 780 | 3010 | - |
| [Akaso M8S](http://ix.io/3R3N) | **1200** MHz| 5.10 | Buster armhf | 3050 | 885 | 32120 | 1160 | 3330 | - |
| [Teres-I](http://ix.io/1tJg) | **1050** MHz| 4.19 | Stretch arm64 | 2785 | 780 | 491590 | 1080 | 2820 | - |
| [Raspberry Pi Zero](http://ix.io/3Njz) | **1000** MHz| 5.10 | Bullseye armv6l/armhf | 460 | 460 | 17060 | 430 | 1670 | - |
| [Raspberry Pi Zero](http://ix.io/1niO) | **1000** MHz| 4.14 | Raspbian Stretch | 450 | 450 | 16820 | 400 | 1590 | - |
| [Raspberry Pi Zero 2](http://ix.io/3E85) | **1000** MHz| 5.10 | Raspberry Pi OS Buster | 3030 | 838 | 29860 | 1300 | 1570 | - |
| [ClockworkPi R-01](http://ix.io/40BJ) | **1000** MHz| 5.4 | Focal riscv64 | 450 | 450 | 9040 | 1220 | 2640 | - |
| [Cubox-i4](http://ix.io/4132) | **980** MHz| 5.15 | Jammy armhf | 2360 | 657 | 27000 | 340 | 340 | - |
| [Olimex A20-Lime2](http://ix.io/4rRV) | **960** MHz| 5.10 | Bullseye armhf | 1080 | 589 | 18630 | 430 | 2020 | 0.87 |
| [LeMaker Banana Pi](http://ix.io/3PLr) | **960** MHz| 5.10 | Bullseye armhf | 1040 | 542 | 18640 | 440 | 2020 | - |
| [Cubietruck](http://ix.io/3Naw) | **960** MHz| 5.10 | Bullseye armhf | 1030 | 541 | 18640 | 440 | 2010 | - |
| [Lime A10](http://ix.io/1j1L) | **910** MHz| 4.14 | Stretch armhf | 550 | 550 | 28250 | 440 | 1300 | - |
| [Raspberry Pi 2 B+](http://ix.io/3MGs) | **900** MHz| 5.10 | Raspberry Pi OS Bullseye | 2150 | 620 | 16500 | 1000 | 1180 | - |
| [Raspberry Pi 2 B+](http://ix.io/1iFf) | **900** MHz| 4.14 | Debian Stretch | 2070 | 592 | 17450 | 615 | 1175 | - |
| [EspressoBin](http://ix.io/1kt2) | **800** MHz| 4.17 | Stretch arm64 | 1138 | 636 | 368330 | 1040 | 2490 | 1.23 |
| [Kendryte K510](http://ix.io/41Qa) | **790** MHz| 4.17 | Sid riscv64 | 690 | 402 | 7410 | 280 | 440 | - |
| [Raspberry Pi B](http://ix.io/3MGN) | **700** MHz| 5.10 | Raspberry Pi OS Bullseye | 320 | 320 | 11630 | 360 | 1420 | - |
| [Raspberry Pi B](http://ix.io/3E7U) | **700** MHz| 5.10 | Raspberry Pi OS Buster | 310 | 310 | 11310 | 340 | 1400 | - |
| [Raspberry Pi Zero 2](http://ix.io/3Dfo) | **600** MHz| 5.10 | Raspberry Pi OS Buster | 1900 | 529 | 18150 | 1040 | 1130 | - |

[(back to top of the page)](#sbc-bench-results-sorted)
