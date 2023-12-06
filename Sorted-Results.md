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
| [Huaqin P6410<br />(2 x Ampere Altra Max)](results/4kiu.txt) | 3000 MHz | 5.4 | Focal arm64 | **430860** | 4211 | 1710010 | 13310 | 47970 | - |
| [Ampere Altra M96-28](results/4zGI.txt) | 2800 MHz | 5.15 | Jammy arm64 | **249380** | 3858 | 1596110 | 10130 | 44750 | - |
| [Ampere Altra Q80-26](results/4zkJ.txt) | 2600 MHz | 5.15 | Jammy arm64 | **214390** | 3748 | 1482190 | 11685 | 41560 | 316.50 |
| [H270-T70<br />(2 x ThunderX CN8890)](results/3N5c.txt) | 2000 Mhz | 5.16 | Sid arm64 | **107180** | 1826 | 340750 | 4180 | 17130 | - |
| [Milk-V Pioneer (SG2042)](results/4wYE.txt) | 2000 MHz | 6.1 | Kinetic riscv64 | **59820** | 1622 | 43500 | 3620 | 4760 | - |
| [Apple M1 Pro](results/443N.txt) | 3030/2060 MHz | 5.18 | Gentoo 2.8 arm64 | **43800** | 5010 | 1064450 | 27110 | 71910 | 48.28 |
| [Jetson AGX Orin](results/4ax9.txt) | 2200 MHz | 5.10 | Focal arm64 | **39450** | 3187 | 1242940 | 10600 | 30350 | 59.96 |
| [Qualcomm Snapdragon 8cx Gen 3](results/4xwT.txt) | 3000/2440 MHz | 6.3 | Lunar arm64 | **35370** | 4312 | 1686160 | 17500 | 41780 | 42.76 |
| [Qualcomm Snapdragon 8cx Gen 3 (WSL2)](results/4kEp.txt) | 2980/? MHz | 5.15 | Jammy arm64 | **33600** | 4789 | 1679480 | 21010 | 41540 | 50.65 |
| [Honeycomb LX2 (NXP LX2160A)](results/3Y4f.txt) | 2200 MHz | 5.16 | Fedora 35 aarch64 | **30690** | 2288 | 1251710 | 5050 | 16220 | 46.09 |
| [Clearfog CX (NXP LX2160A)](results/4ju5.txt) | 2000 MHz | 5.10 | Focal arm64 | **25260** | 2236 | 1136690 | 4460 | 12500 | - |
| [Jetson Xavier AGX](results/4ebH.txt) | 2250 MHz | 4.9 | Bionic arm64 | **21590** | 2742 | 853250 | 10910 | 22520 | 26.57 |
| [Intel i3-N305](results/4qpr.txt) | 3800 MHz | 5.19 | Jammy amd64 | **20000** | 4398 | 1377280 | 9950 | 8990 | 41.43 |
| [Qualcomm QRB5165](results/49kx.txt) | 2840/2410/1790 MHz | 4.19 | Focal arm64 | **18860** | 3898 | 1598490 | 14470 | 23910 | 25.56 |
| [MT8395 Genio 1200](results/4Kvg.txt) | 2200/2000 MHz | 5.15 | Jammy arm64 | **18130** | 3298 | 1240850 | 14200 | 19000 | 27.60 |
| [Orange Pi 5 (RK3588)](results/4D0a.txt) | 2400/1800 MHz | 5.10 | Jammy arm64 | **16780** | 2689 | 1366590 | 12800 | 29900 | - |
| [Phytium D2000<br />(2 x SO-DIMM)](results/446h.txt) | 2300 MHz | 5.19 | Jammy arm64 | **16670** | 2252 | 828130 | 3480 | 16110 | - |
| [Khadas Edge2 (RK3588s)](results/4a5U.txt) | 2260/1800 MHz | 5.10 | Jammy arm64 | **16470** | 3096 | 1287490 | 10860 | 29110 | - |
| [Radxa ROCK 5B (RK3588)](results/41BH.txt) | 2350/1830 MHz | 5.10 | Focal arm64 | **16450** | 3146 | 1337540 | 10830 | 29220 | 25.31 |
| [Phytium D2000<br />(1 x SO-DIMM)](results/445T.txt) | 2300 MHz | 5.19 | Jammy arm64 | **16390** | 2220 | 827090 | 2820 | 6490 | - |
| [Intel N100](results/4vxM.txt) | 3400 MHz | 6.1 | Lunar amd64 | **14150** | 4073 | 1232790 | 11600 | 12270 | 36.24 |
| [AMD Seattle (Opteron A1100)](results/4Kqn.txt) | 2000 MHz | 4.15 | Bionic arm64 | **14080** | 2006 | 720710 | 3020 | 9530 | - |
| [Jetson Orin Nano](results/4vy7.txt) | 1510 MHz | 5.10 | Focal arm64 | **13650** | 2153 | 854400 | 6730 | 20240 | 20.68 |
| [Jetson Xavier NX](results/3YWp.txt) | 1890 MHz | 4.9 | Bionic arm64 | **13230** | 2201 | 706280 | 9190 | 18480 | - |
| [Intel N95](results/4xwq.txt) | 3400 MHz | 5.15 | Jammy amd64 | **13070** | 3993 | 1232880 | 9710 | 8730 | 34.60 |
| [Qualcomm Snapdragon 7c](results/4Lyf.txt) | 2550/1800 MHz | 6.6 | Bookworm arm64 | **13040** | 3113 | 1455700 | 6710 | 14880 | - |
| [Raspberry Pi 5 B (BCM2712)](results/4I1w.txt) | 3000 MHz | 6.1 | Bookworm arm64 | **12740** | 3747 | 1710050 | 4940 | 12640 | - |
| [Khadas VIM4 (A311D2)](results/4cHh.txt) | 2200/2010 MHz | 5.4 | Jammy arm64 | **12120** | 2067 | 1254540 | 8180 | 11680 | - |
| [Khadas VIM4 (A311D2)](results/3Wvv.txt) | 2200/1970 MHz | 5.4 | Focal arm64 | **12090** | 2081 | 1253200 | 7810 | 11600 | - |
| [Pentium G4600](results/2jVw.txt) | 3600 MHz | 4.19 | Buster amd64 | **11810** | 4448 | 984820 | 15120 | 33380 | 21.88 |
| [Pentium N6005](results/4BtC.txt) | 3300/2000 MHz | 5.15 | Jammy amd64 | **11510** | 3369 | 923550 | 9650 | 10280 | 22.18 |
| [Celeron N5105](results/3Qf7.txt) | 2900/2000 MHz | 5.13 | Focal amd64 | **11450** | 3059 | 811760 | 7710 | 9290 | 21.79 |
| [Loongson-3A5000-HV](results/4dzX.txt) | 2500 MHz | 4.19 | Loongnix 20 loongarch64 | **11120** | 2990 | 116900 | 6930 | 19170 | - |
| [Raspberry Pi 5 B (BCM2712)](results/4HDw.txt) | 2400 MHz | 6.1 | Bookworm arm64 | **10950** | 3160 | 1367990 | 5260 | 11520 | 15.42 |
| [Celeron N5100](results/3IlQ.txt) | 2800/1100 MHz | 5.13 | Focal amd64 | **10550** | 3088 | 783800 | 7750 | 8090 | 19.22 |
| [Phytium<br />FT-2000/4<br />(1 x SO-DIMM)](results/4ioj.txt) | 2600 MHz | 5.15 | Bullseye arm64 | **10020** | 2755 | 936740 | 3760 | 14540 | - |
| [Qualcomm Snapdragon 835](results/4fdD.txt) | 2360/1900 MHz | 6.1 | Jammy arm64 | **9800** | 2474 | 883330 | 9720 | 14070 | 12.58 |
| [ODROID-N2+ (Amlogic S922X)](results/3DtN.txt) | 2400/2015 MHz | 5.14 | Impish arm64 | **9790** | 2253 | 1366930 | 4300 | 7480 | - |
| [ODROID-N2+ (Amlogic S922X)](results/4rWn.txt) | 2400/2015 MHz | 6.1 | Bullseye arm64 | **9710** | 2373 | 1366180 | 4220 | 7720 | - |
| [ODROID-N2+ (Amlogic S922X)](results/3R1a.txt) | 2400/2015 MHz | 5.10 | Focal arm64 | **9680** | 2372 | 1366730 | 4030 | 7120 | - |
| [Khadas VIM3 (Amlogic A311D)](results/4o1A.txt) | 2400/2015 MHz | 6.0 | Bullseye arm64 | **9650** | 2379 | 1366300 | 5080 | 9240 | - |
| [Khadas VIM3 (Amlogic A311D)](results/3R2Z.txt) | 2400/2015 MHz | 5.10 | Bullseye arm64 | **9650** | 2376 | 1366350 | 4850 | 7380 | - |
| [Pentium J5005](results/21rE.txt) | 2700/1500 MHz | 5.0 | Bionic amd64 | **9230** | 2455 | 778360 | 5530 | 7130 | 20.74 |
| [ODROID-N2 (Amlogic S922X)](results/3MuT.txt) | 2000/1900 MHz | 5.10 | Buster arm64 | **9090** | 2012 | 1085350 | 4260 | 9080 | - |
| [Ryzen R1505G](results/4HYd.txt) | 3270 MHz | 6.1 | Bookworm amd64 | **9080** | 3327 | 886980 | 10520 | 8160 | 18.14 |
| [Celeron J4105](results/1qal.txt) | 2400/1500 MHz | 4.15 | Bionic amd64 | **9020** | 2290 | 697100 | 5500 | 7410 | 19.07 |
| [ODROID-XU4 (Exynos 5422)](results/3GnC.txt) | 2000/1400 MHz | 5.4 | Focal armhf | **8980** | 1604 | 72020 | 2280 | 4910 | - |
| [Celeron J4105](results/1qb0.txt) | 2400/1500 MHz | 4.15 | Bionic amd64 | **8960** | 2274 | 697080 | 5620 | 7650 | 19.13 |
| [Amazon a1.xlarge](results/2iFY.txt) | 2300 MHz | 4.15 | Bionic arm64 | **8610** | 2406 | 1297960 | 4280 | 14220 | - |
| [Khadas VIM3 (Amlogic A311D)](results/1MFD.txt) | 2200/1800 MHz | 4.9 | Bionic arm64 | **8600** | 2026 | 1256910 | 4980 | 9300 | 13.12 |
| [Celeron N4100](results/1uTS.txt) | 2300/1100 MHz | 4.15 | Bionic amd64 | **8510** | 2222 | 669350 | 4750 | 5240 | 18.33 |
| [ODROID-N2 (Amlogic S922X)](results/1BsF.txt) | 1800/1900 MHz | 4.9 | Bionic arm64 | **8140** | 1669 | 1024680 | 4120 | 8610 | 11.39 |
| [Hetzner CAX11 (Ampere Altra)](results/4HdL.txt) | 3000 MHz | 5.15 | Jammy arm64 | **8060** | 3842 | 1705600 | 11250 | 47670 | 11.44 |
| [Ryzen R1606G](results/2tQQ.txt) | 2600/1400 MHz | 5.4 | Focal amd64 | **7970** | 2854 | 700780 | 8230 | 5970 | 16.45 |
| [Hugsun X99 (RK3399)](results/2ICt.txt) | 2088/1800 MHz | 5.9 | Focal arm64 | **7710** | 1927 | 1184306 | 2270 | 5970 | - |
| [Celeron J4125](results/4hau.txt) | 2700/2000 MHz | 5.15 | Jammy amd64 | **7620** | 2367 | 751360 | 5110 | 5960 | 18.30 |
| [Pentium J4205](results/1m5t.txt) | 2560/1500 MHz | 4.17 | Stretch amd64 | **7570** | 2146 | 480640 | 5070 | 5170 | 18.82 |
| [NanoPC T3+ (Nexell S5P6818)](results/1iRJ.txt) | 1400 MHz | 4.14 | Bionic arm64 | **7480** | 1053 | 652600 | 1440 | 4540 | 10.99 |
| [Pentium N4200](results/1ngq.txt) | 2560/1100 MHz | 4.14 | Bionic amd64 | **7469** | 1976 | 468008 | 4682 | 4997 | 18.75 |
| [NanoPi Fire3 (Nexell S5P6818)](results/1jjm.txt) | 1400 MHz | 4.14 | Bionic arm64 | **7440** | 1052 | 653000 | 1560 | 4600 | 10.96 |
| [NanoPi Fire3 (Nexell S5P6818)](results/1jiU.txt) | 1380 MHz | 4.14 | Stretch arm64 | **7420** | 1038 | 645400 | 1520 | 4570 | 8.53 |
| [NanoPi Fire3 (Nexell S5P6818)](results/3ZxU.txt) | 1400 MHz | 4.14 | Focal arm64 | **7350** | 1093 | 652640 | 1530 | 4590 | 11.18 |
| [RockPro64 (RK3399)](results/2yIx.txt) | 2010/1510 MHz | 5.8 | Bullseye arm64 | **7000** | 1833 | 1144950 | 3690 | 8360 | 11.08 |
| [Celeron J3455](results/1m5p.txt) | 2300/1500 MHz | 4.17 | Stretch amd64 | **7000** | 2037 | 429660 | 4090 | 4050 | 17.26 |
| [NanoPi NEO4 (RK3399)](results/3GmR.txt) | 2016/1512 MHz | 5.10 | Focal arm64 | **6970** | 1906 | 1145030 | 2450 | 6190 | 11.36 |
| [RockPro64 (RK3399)](results/2sZH.txt) | 2010/1510 MHz | 5.4 | Focal arm64 | **6920** | 1826 | 1145300 | 3700 | 8430 | 11.55 |
| [Radxa Rock Pi 4 (RK3399)](results/21fX.txt) | 2000/1500 MHz | 5.3 | Bionic arm64 | **6910** | 1817 | 1147370 | 3660 | 8310 | 10.71 |
| [Radxa Rock Pi 4 (RK3399)](results/3Q2q.txt) | 2000/1500 MHz | 5.10 | Focal arm64 | **6900** | 1899 | 1146500 | 3430 | 8260 | - |
| [OrangePi 4 (RK3399)](results/4Kau.txt) | 2010/1510 MHz | 6.1 | Bookworm arm64 | **6880** | 1891 | 1145840 | 3490 | 8430 | - |
| [ODROID-XU4 (Exynos 5422)](results/1ixL.txt) | 1900/1400 MHz | 3.10 | Jessie armhf | **6750** | - | 68200 | 2200 | 4800 | - |
| [NanoPi NEO4 (RK3399)](results/1p3T.txt) | 2000/1500 MHz | 4.19 | Stretch arm64 | **6750** | 1814 | 1139850 | 2370 | 6110 | 8.84 |
| [Nintendo Switch (Tegra X1)](results/3Di2.txt) | 2060 MHz | 4.9 | Bionic arm64 | **6720** | 1901 | 746680 | 2370 | 3670 | 9.25 |
| [NanoPi M4v2 (RK3399)](results/3MAK.txt) | 2015/1510 MHz | 5.10 | Bullseye arm64 | **6680** | 1855 | 921980 | 3110 | 7640 | - |
| [Khadas Edge (RK3399)](results/1uar.txt) | 2000/1500 MHz | 4.4 | Stretch arm64 | **6600** | 1703 | 1127780 | 2860 | 4880 | 8.85 |
| [x7-Z8700](results/4iDX.txt) | 2400 MHz | 5.15 | Bullseye amd64 | **6580** | 1784 | 296680 | 3510 | 3580 | - |
| [Celeron J1900](results/4hKV.txt) | 2415/1333 MHz | 5.4 | Focal amd64 | **6560** | 1806 | 34900 | 3780 | 3390 | - |
| [Raspberry Pi 400 (BCM2711)](results/2Cyi.txt) | 1800 MHz | 5.4 | Raspberry Pi OS Buster | **6550** | 1903 | 77890 | 2680 | 3110 | - |
| [Raspberry Pi 4 B (BCM2711)](results/3Gia.txt) | 1800 MHz | 5.10 | Raspberry Pi OS Buster | **6550** | 1897 | 77830 | 2780 | 3080 | - |
| [Khadas Edge (RK3399)](results/1rYm.txt) | 2000/1500 MHz | 4.4 | Bionic arm64 | **6550** | 1721 | 1130400 | 2810 | 4860 | 10.50 |
| [NanoPi NEO4 (RK3399)](results/1oim.txt) | 2000/1500 MHz | 4.4| Stretch arm64 | **6520** | 1718 | 1123190 | 2280 | 4770 | 8.83 |
| [NanoPi NEO4 (RK3399)](results/1oho.txt) | 2000/1500 MHz | 4.4| Stretch arm64 | **6510** | 1703 | 1128860 | 2260 | 4770 | 8.71 |
| [Atom E3950](results/4dd5.txt) | 2000 MHz | 5.15 | Jammy amd64 | **6440** | 1636 | 374800 | 4400 | 4840 | - |
| [RockPro64 (RK3399)](results/1ub9.txt) | 1800/1400 MHz | 4.4 | Stretch arm64 | **6420** | 1673 | 1018480 | 3720 | 8400 | 8.24 |
| [ODROID-XU4 (Exynos 5422)](results/1iWL.txt) | 2000/1400 MHz | 4.9 | Stretch armhf | **6400** | 1622 | 72075 | 2230 | 4850 | - |
| [NanoPi M4 (RK3399)](results/1lzP.txt) | 2000/1500 MHz | 4.19 | Stretch arm64 | **6400** | 1835 | 1128330 | 4080 | 8270 | 8.86 |
| [NanoPC T3+ (Nexell S5P6818)](results/1iyp.txt) | 1400 MHz | 4.4 | Xenial armhf | **6400** | 943 | 651000 | 1650 | 3700 | - |
| [NanoPC T4 (RK3399)](results/1iZq.txt) | 1800/1400 MHz | 4.17 | Stretch arm64 | **6380** | 1741 | 1022600 | 4160 | 9000 | 9.36 |
| [RockPro64 (RK3399)](results/1iFp.txt) | 1800/1400 MHz | 4.18 | Stretch arm64 | **6300** | 1755 | 1021500 | 3650 | 8450 | 8.20 |
| [Raspberry Pi 4 B (BCM2711)](results/3VME.txt) | 1800 MHz | 5.15 | Jammy armhf | **6300** | 1844 | 82750 | 1190 | 3110 | - |
| [Celeron N4500](results/3HUU.txt) | 2800/1100 MHz | 5.13 | Impish amd64 | **6300** | 3091 | 783840 | 8100 | 8350 | - |
| [Jetson Nano](results/3Ufc.txt) | 2000 MHz | 4.9 | Bionic arm64 | **6260** | 1977 | 717500 | 4100 | 11760 | 8.72 |
| [RockPro64 (RK3399)](results/1iFZ.txt) | 1800/1400 MHz | 4.4 | Stretch armhf | **6250** | 1809 | 1000150 | 2000 | 4835 | - |
| [NanoPC T4 (RK3399)](results/1iFz.txt) | 1800/1400 MHz | 4.17 | Stretch arm64 | **6250** | 1809 | 1022500 | 4100 | 9000 | 8.24 |
| [NanoPC T4 (RK3399)](results/1iWU.txt) | 1800/1400 MHz | 4.17 | Stretch arm64 | **6230** | 1756 | 1023600 | 4100 | 9060 | 10.30 |
| [Nintendo Switch (Tegra X1)](results/1Rnj.txt) | 1780 MHz | 4.9 | Fedora 30 arm-64 | **6170** | 1719 | 642670 | 2500 | 3570 | - |
| [RockPro64 (RK3399)](results/1lBC.txt) | 1800/1400 MHz | 4.4 | Stretch arm64 | **6140** | 1580 | 1015600 | 2770 | 4850 | 8.14 |
| [NanoPi NEO4 (RK3399)](results/1oib.txt) | 2000/1500 MHz | 4.4| Stretch arm64 | **6030** | 1343 | 1121380 | 2230 | 4770 | 8.57 |
| [Libre Computer AML-S912-PC](results/40cj.txt) | 1415/1000 MHz | 5.15 | Bullseye arm64 | **5980** | 1012 | 659290 | 1650 | 5170 | - |
| [Raspberry Pi 4 B (BCM2711)](results/3N94.txt) | 1800 MHz | 5.10 | Raspberry Pi OS Bullseye | **5940** | 1738 | 77670 | 2310 | 2690 | - |
| [NanoPC T4 (RK3399)](results/1lkG.txt) | 2000/1500 MHz | 4.4 | Stretch arm64 | **5870** | 1336 | 1124040 | 2810 | 4890 | 8.70 |
| [Raspberry Pi 4 B (BCM2711)](results/3OBF.txt) | 1800 MHz | 5.10 | Raspberry Pi OS Bullseye arm64 | **5790** | 1769 | 36260 | 2330 | 3120 | 8.74 |
| [Tinkerboard (RK3288)](results/3X9q.txt) | 1800 MHz | 5.10 | Buster armhf | **5770** | 1713 | 67060 | 1540 | 4110 | - |
| [ODROID-C4 (S905X3)](results/3TQ2.txt) | 2100 MHz | 5.10 | Buster arm64 | **5770** | 1679 | 981940 | 3540 | 5150 | - |
| [Raspberry Pi 4 B (BCM2711)](results/3F9C.txt) | 1800 MHz | 5.10 | Raspberry Pi OS Buster arm64 | **5760** | 1741 | 36240 | 2240 | 3120 | 9.46 |
| [Raspberry Pi 4 B (BCM2711)](results/3EgS.txt) | 1500 MHz | 5.10 | Raspberry Pi OS Buster | **5750** | 1661 | 64930 | 2550 | 3430 | - |
| [ODROID-HC4 (S905X3)](results/3Na5.txt) | 2100 MHz | 5.10 | Buster arm64 | **5730** | 1672 | 980970 | 3540 | 5150 | - |
| [Macchiatobin (Armada 8040)](results/4zcm.txt) | 1600 MHz | 5.10 | Buster arm64 | **5720** | 1739 | 909420 | 4510 | 12270 | 7.91 |
| [Raspberry Pi 4 B (BCM2711)](results/3InF.txt) | 1800 MHz | 5.15 | Armbian Jammy arm64 | **5640** | 1752 | 36260 | 2580 | 3110 | - |
| [TinkerBoard S (RK3288)](results/4vfU.txt) | 1800 MHz | 6.1 | Jammy armhf | **5560** | 1672 | 65800 | 1540 | 4150 | - |
| [Raspberry Pi 4 B (BCM2711)](results/1MFf.txt) | 1500 MHz | 4.19 | Raspbian Buster | **5500** | 1606 | 64860 | 2460 | 3170 | - |
| [ODROID-C4 (S905X3)](results/2kaS.txt) | 2010 MHz | 4.9 | Focal arm64 | **5450** | 1459 | 941590 | 3310 | 6270 | 7.71 |
| [Khadas VIM2 (Amlogic S912)](results/1iJ7.txt) | 1415/1000 MHz | 4.17 | Bionic arm64 | **5450** | 993 | 659600 | 1920 | 5920 | 8.59 |
| [Tinkerboard (RK3288)](results/3Lir.txt) | 1800 MHz | 4.4 | Buster armhf | **5440** | 1693 | 66300 | 1340 | 3510 | - |
| [ODROID-M1 (RK3568)](results/4ijy.txt) | 2060 MHz | 5.18 | Bullseye arm64 | **5430** | 1567 | 961090 | 3310 | 5960 | 7.76 |
| [Tinkerboard (RK3288)](results/1iSX.txt) | 1730 MHz | 4.14 | Stretch armhf | **5350** | 1563 | 66600 | 1480 | 3900 | - |
| [AMedia X96 Max+ (S905X3)](results/3QOj.txt) | 2100 MHz | 5.15 | Focal arm64 | **5270** | 1330 | 981830 | 2630 | 5150 | - |
| [Lichee Pi 4A (T-Head TH1520)](results/4xYE.txt) | 1990 MHz | 5.10 | Bookworm riscv64 | **5260** | 1592 | 43820 | 4350 | 14760 | - |
| [Jetson Nano](results/4rLX.txt) | 1480 MHz | 4.9 | Bullseye arm64 | **5260** | 1578 | 531940 | 3730 | 8870 | - |
| [Khadas VIM3L (S905D3)](results/26Wy.txt) | 1900 MHz | 4.9 | Bionic arm64 | **5160** | 1399 | 892110 | 3670 | 6360 | 7.29 |
| [Radxa ROCK 3A (RK3568)](results/40TX.txt) | 2000 MHz | 5.18 | Bullseye arm64 | **5110** | 1450 | 935920 | 3150 | 6250 | 7.58 |
| [Khadas VIM3L (S905D3)](results/3Vdt.txt) | 1900 MHz | 5.16 | Bullseye arm64 | **5110** | 1403 | 890730 | 3700 | 5140 | - |
| [RK3568-ROC-PC](results/3Rsg.txt) | 1960 MHz | 4.19 | Bullseye arm64 | **5040** | 1424 | 912800 | 3130 | 6240 | - |
| [NanoPi R5S (RK3568)](results/4jfZ.txt) | 1960 MHz | 6.1 | Bullseye arm64 | **5030** | 1482 | 914340 | 2990 | 5970 | 7.33 |
| [ODROID-M1 (RK3568)](results/3Ug9.txt) | 1930 MHz | 4.19 | Focal arm64 | **5010** | 1450 | 898610 | 3070 | 6220 | 7.14 |
| [i.MX8MPlus EVK](results/4hx0.txt) | 1800 MHz | 5.15 | Focal arm64 | **4990** | 1348 | 837680 | 2740 | 12420 | 7.02 |
| [Quartz64-A (RK3566)](results/4qJF.txt) | 1890 MHz | 6.2 | Jammy arm64 | **4980** | 1457 | 884590 | 3240 | 6100 | 6.98 |
| [Quartz64-A (RK3566)](results/3rUb.txt) | 1810 MHz | 5.13 | Buster arm64 | **4840** | 1353 | 845490 | 2980 | 7650| - |
| [x5-Z8350](results/2Jdb.txt) | 1920/1680 MHz | 5.4 | Focal amd64 | **4790** | 1454 | 237230 | 3170 | 2960 | 9.38 |
| [Athlon II X3 420e](results/4eOo.txt) | 2600 MHz | 4.19 | Buster amd64 | **4780** | 2566 | 98840 | 4120 | 3870 | - |
| [x5-Z8350](results/1HnC.txt) | 1920/1680 MHz | 4.15 | Bionic amd64 | **4710** | 1272 | 207640 | 2740 | 3140 | - |
| [PineH64 (Allwinner H6)](results/26Ph.txt) | 1800 MHz | 5.4 | Buster arm64 | **4710** | 1293 | 839870 | 1420 | 5560 | 7.10 |
| [Hlink H28K (RK3528)](results/4I93.txt) | 2000 Mhz | 5.10 | Jammy arm64 | **4680** | 1388 | 933630 | 2090 | 7650 | 6.48 |
| [Celeron N4020](results/4vNB.txt) | 2800 MHz | 5.15 | Bookworm amd64 | **4680** | 2577 | 780770 | 5480 | 5390 | - |
| [PineH64 (Allwinner H6)](results/1jEr.txt) | 1800 MHz | 4.18 | Stretch arm64 | **4650** | 1274 | 836900 | 1380 | 5530 | 5.62 |
| [Radxa Zero (S905Y2)](results/3wZn.txt) | 1800 MHz | 5.10 | Focal arm64 | **4610** | 1267 | 840080 | 1600 | 5370 | - |
| [Radxa Zero (S905Y2)](results/3JCm.txt) | 1800 MHz | 5.10 | Bullseye arm64 | **4580** | 1353 | 838360 | 1600 | 5360 | 7.13 |
| [Radxa Zero (S905Y2)](results/3PlT.txt) | 1800 MHz | 5.10 | Buster arm64 | **4570** | 1373 | 839080 | 1610 | 5250 | 6.82 |
| [Atom Z3735F](results/4r54.txt) | 1830 MHz | 5.15 | Jammy amd64 | **4510** | 1437 | 227900 | 3020 | 2780 | - |
| [x5-Z8300](results/4j4o.txt) | 1840 MHz | 5.15 | Jammy amd64 | **4430** | 1368 | 227030 | 2270 | 2380 | 8.84 |
| [HummingBoard Pulse i.MX8M Quad](results/27FC.txt) | 1500 MHz | 4.19 | Buster arm64 | **4330** | 1201 | 695540 | 2230 | 9900 | - |
| [VisionFive V2 (JH7110)](results/4xOY.txt) | 1500 MHz | 5.15 | Sid riscv64 | **4180** | 1197 | 25080 | 880 | 770 | - |
| [Milk-V Mars CM (JH7110)](results/4K7E.txt) | 1500 MHz | 5.15 | Bookworm riscv64 | **4110** | 1195 | 25070 | 930 | 830 | - |
| [MangoPi Mcore (Allwinner H616)](results/4bSf.txt) | 1800 MHz | 5.19 | Jammy arm64 | **4100** | 1218 | 840270 | 990 | 2380 | - |
| [ODROID-C2 (Amlogic S905)](results/1ixI.txt) | 1750 MHz | 3.14 | Xenial arm64 | **4070** | 1128 | 48500 | 1750 | 3100 | - |
| [Celeron 5205U](results/4eiM.txt) | 1900 MHz | 5.15 | Jammy amd64 | **4060** | 2171 | 521090 | 7350 | 16020 | 11.20 |
| [Orange Pi Zero 3 (Allwinner H618)](results/4CPF.txt) | 1510 MHz | 6.1 | Jammy arm64 | **4020** | 1165 | 705330 | 1510 | 6010 | 6.02 |
| [Khadas VIM1S (S905Y4)](results/4bbv.txt) | 2000 MHz | 5.4 | Jammy arm64 | **4000** | 1148 | 436540 | 1970 | 7530 | - |
| [Star64 (JH7110)](results/4tjq.txt) | 1500 MHz | 5.15 | Sid riscv64 | **3970** | 1175 | 24990 | 820 | 770 | - |
| [Orange Pi Zero 2W (Allwinner H618)](results/4Hd0.txt) | 1510 MHz | 6.1 | Jammy arm64 | **3920** | 1167 | 705660 | 1510 | 6010 | 6.02 |
| [x5-Z8300](results/1lgD.txt) | 1420 MHz | 4.9 | Stretch amd64 | **3900** | 950 | 178010 | 2380 | 2380 | 7.81 |
| [Tronsmart MXIII Plus (S812)](results/3S5U.txt) | 1560 MHz | 5.10 | Buster armhf | **3880** | 1113 | 42570 | 1470 | 3430 | - |
| [NanoPi K2 (Amlogic S905)](results/3Qve.txt) | 1480 MHz | 5.10 | Bullseye arm64 | **3880** | 1154 | 51490 | 1850 | 3790 | - |
| [Khadas VIM1 (Amlogic S905X)](results/4bee.txt) | 1415 MHz | 5.1 | Buster arm64 | **3860** | 1136 | 660160 | 1940 | 5900 | - |
| [NanoPi K2 (Amlogic S905)](results/1iT1.txt) | 1480 MHz | 4.14 | Stretch arm64 | **3850** | 1095 | 50370 | 1660 | 3870 | 4.61 |
| [Celeron N3350](results/4rJj.txt) | 2400 MHz | 6.0 | Bullseye amd64 | **3810** | 2034 | 446170 | 5190 | 5700 | - |
| [Le Potato (Amlogic S905X)](results/1iSQ.txt) | 1410 MHz | 4.18 | Stretch arm64 | **3780** | 1057 | 657200 | 1810 | 5730 | 3.92 |
| [Renegade (RK3328)](results/1iFx.txt) | 1400 MHz | 4.4 | Stretch arm64 | **3710** | 1069 | 644200 | 1565 | 7435 | 3.92 |
| [Raspberry Pi 3 B+ (BCM2837B0)](results/1isD.txt) | with fan | 4.14 | Raspbian Stretch | **3670** | 1046 | 42600 | 1120 | 1600 | - |
| [Tronsmart S82 (Amlogic S802)](results/41ML.txt) | 1600 MHz | 5.14 | Focal armhf | **3640** | 1114 | 43150 | 500 | 3200 | - |
| [Raspberry Pi Zero 2 (RP3A0)](results/3DeL.txt) | 1200 MHz | 5.10 | Raspberry Pi OS Buster | **3640** | 1007 | 36300 | 1320 | 1790 | - |
| [Rock64 (RK3328)](results/1iwz.txt) | 1400 MHz | 4.4 | Stretch armhf | **3620** | 1006 | 624000 | 1430 | 3620 | - |
| [Rock64 (RK3328)](results/1iFm.txt) | 1400 MHz | 4.4 | Stretch arm64 | **3610** | 1034 | 644250 | 1330 | 5700 | 3.85 |
| [Raspberry Pi 3 B+ (BCM2837B0)](results/1iI5.txt) | original | 4.9 | Raspbian Stretch | **3600** | 1076 | 42700 | 1230 | 1640 | - |
| [Rock64 (RK3328)](results/1iZj.txt) | 1400 MHz | 4.4 | Stretch arm64 | **3590** | 1030 | 643700 | 1320 | 5640 | 4.40 |
| [Orange Pi Prime (Allwinner H5)](results/2kTH.txt) | 1370 MHz | 5.4 | Buster | **3590** | 984 | 637980 | 1180 | 3540 | - |
| [Rock64 (RK3328)](results/1iYK.txt) | 1400 MHz | 4.4 | Stretch arm64 | **3580** | 1032 | 644380 | 1330 | 5680 | 4.63 |
| [Rock64 (RK3328)](results/1iHB.txt) | 1300 MHz | 4.18 | Stretch arm64 | **3560** | 1002 | 603800 | 1340 | 5770 | 3.80 |
| [Orange Pi Zero 2 (Allwinner H616)](results/4knM.txt) | 1510 MHz | 4.9 | Buster arm64 | **3550** | 1067 | 703300 | 1190 | 2820 | 5.01 |
| [Rock64 (RK3328)](results/1iH4.txt) | 1300 MHz | 4.18 | Bionic arm64 | **3530** | 996 | 605250 | 1340 | 5770 | 4.65 |
| [NanoPi K1 Plus (Allwinner H5)](results/3N7H.txt) | 1370 MHz | 5.10 | Focal arm64 | **3520** | 1022 | 638880 | 1070 | 3680 | 5.50 |
| [Orange Pi PC 2 (Allwinner H5)](results/3MQJ.txt) | 1370 MHz | 5.10 | Focal arm64 | **3500** | 1023 | 637410 | 1070 | 3680 | - |
| [BPi M4 (RTD1395)](results/1Dt1.txt) | 1400 MHz | 4.9 | Bionic arm64 | **3500** | - | 651460 | 1010 | 4360 | 5.48 |
| [BeagleBone AI-64 (TI J721E)](results/4DLw.txt) | 2000 MHz | 5.10 | Bookworm arm64 | **3470** | 1872 | 1130390 | 2660 | 8710 | - |
| [Rock64 (RK3328)](results/1iHo.txt) | 1300 MHz | 4.4 | Stretch arm64 | **3430** | 952 | 601000 | 1350 | 5680 | 3.64 |
| [Rock64 (RK3328)](results/1iGW.txt) | 1300 MHz | 4.4 | Bionic arm64 | **3410** | 945 | 601200 | 1310 | 5680 | 4.46 |
| [Ugoos UT2 (RK3188)](results/408h.txt) | 1560 MHz | 5.10 | Jammy armhf | **3320** | 994 | 43250 | 320 | 2020 | - |
| [Raspberry Pi 3 B+ (BCM2837B0)](results/1ism.txt) | normal | 4.14 | Raspbian Stretch | **3240** | 914 | 36600 | 1130 | 1530 | - |
| [RK3318 BOX](results/4kor.txt) | 1390 MHz | 6.0 | Jammy arm64 | **3200** | 867 | 644750 | 700 | 2460 | - |
| [Marvell PXA1908](results/46hs.txt) | 1245 MHz | 3.14 | Bullseye arm64 | **3180** | 951 | 581840 | 740 | 2220 | - |
| [Raspberry Pi 3 B+ (BCM2837B0)](results/1iGz.txt) | OC/normal | 4.14 | Raspbian Stretch | **3130** | 843 | 36620 | 1230 | 1780 | - |
| [TRONFY MXQ (Amlogic S805)](results/3MiR.txt) | 1536 MHz | 5.10 | Focal armhf | **3100** | 897 | 29080 | 980 | 2990 | - |
| [Celeron N2807](results/4z3s.txt) | 2165 MHz | 5.10 | Bullseye) amd64 | **3070** | 1766 | 31250 | 3600 | 3110 | 6.09 |
| [Orange Pi PC+ (Allwinner H3)](results/3MQV.txt) | 1370 MHz | 5.10 | Focal armhf | **3060** | 879 | 26590 | 890 | 3450 | - |
| [Akaso M8S (S812)](results/3R3N.txt) | 1200 MHz | 5.10 | Buster armhf | **3050** | 885 | 32120 | 1160 | 3330 | - |
| [Raspberry Pi 3 B+ (BCM2837B0)](results/1iGM.txt) | normal | 4.14 | Raspbian Stretch | **3040** | 856 | 36600 | 1050 | 1500 | - |
| [Raspberry Pi Zero 2 (RP3A0)](results/3E85.txt) | 1000 MHz | 5.10 | Raspberry Pi OS Buster | **3030** | 838 | 29860 | 1300 | 1570 | - |
| [NanoPi M1 Plus (Allwinner H3)](results/3N2z.txt) | 1370 MHz | 4.19 | Bionic armhf | **3030** | 881 | 26660 | 830 | 3450 | - |
| [ODROID-C1 (Amlogic S805)](results/4eg5.txt) | 1500 MHz | 5.19 | Jammy armhf | **3010** | 878 | 29260 | 390 | 2910 | - |
| [BPi R2 (MT7623)](results/4dO7.txt) | 1300 MHz | 4.19 | Focal armhf | **2990** | 854 | 25260 | 1550 | 3220 | - |
| [Raspberry Pi 3 B (BCM2837)](results/4hOP.txt) | 1200 MHz | 5.15 | Raspbian Sid | **2970** | 977 | 36230 | 1110 | 1700 | 2.89 |
| [Atom N2800](results/4nt8.txt) | 1860 MHz | 5.15 | Bullseye amd64 | **2970** | 1006 | 21780 | 2050 | 1570 | - |
| [MT6580 K9M1](results/466y.txt) | 1300 MHz | 5.19 | Sid armhf | **2930** | 860 | 25300 | 1250 | 3300 | - |
| [Orange Pi Plus 2 (Allwinner H3)](results/1iX4.txt) | 1300 MHz | 4.14 | Stretch armhf | **2890** | 812 | 25250 | 830 | 3240 | - |
| [Teres-I<br />(Allwinner A64)](results/1tJg.txt) | 1050 MHz | 4.19 | Stretch arm64 | **2785** | 780 | 491590 | 1080 | 2820 | - |
| [Celeron N2830](results/4pEc.txt) | 2160 MHz | 5.19 | Jammy amd64 | **2760** | 1664 | 31270 | 3780 | 3520 | 6.10 |
| [BPi M2U (Allwinner R40)](results/4kmM.txt) | 1200 MHz | 6.0 | Bullseye armhf | **2690** | 767 | 23320 | 780 | 3010 | - |
| [Radxa Rock Pi S (RK3308)](results/4sNe.txt) | 1300 MHz | 6.1 | Jammy arm64 | **2540** | 732 | 282030 | 820 | 1870 | - |
| [AMD E-450 APU](results/4hwl.txt) | 1650 MHz | 5.15 | Jammy amd64 | **2430** | 1258 | 27450 | 1710 | 1740 | - |
| [Cubox-i4<br />(NXP i.MX6)](results/4132.txt) | 980 MHz | 5.15 | Jammy armhf | **2360** | 657 | 27000 | 340 | 340 | - |
| [RK3228A TV Box](results/3M9F.txt) | 1200 MHz | 4.4 | Buster armhf | **2310** | 710 | 23070 | 410 | 1230 | - |
| [Clearfog A1<br />(Armada 388)](results/4d1U.txt) | 1600 MHz | 5.15 | Bullseye armhf | **2230** | 1239 | 44080 | 910 | 5060 | - |
| [Helios4<br />(Armada 388)](results/1jCy.txt) | 1600 MHz | 4.14 | Stretch armhf | **2210** | 1215 | 42500 &ast;98560 | 910 | 4840 | - |
| [Raspberry Pi 2 B+ (BCM2836)](results/3MGs.txt) | 900 MHz | 5.10 | Raspberry Pi OS Bullseye | **2150** | 620 | 16500 | 1000 | 1180 | - |
| [Atom E3826](results/44pd.txt) | 1460 MHz | 5.18 | Jammy amd64 | **2140** | 1112 | 182190 | 2840 | 2760 | - |
| [Raspberry Pi 3 B+ (BCM2837B0)](results/1iH0.txt) | UV/normal | 4.14 | Raspbian Stretch | **2100** | 856 | 36400 | 1040 | 1460 | - |
| [Raspberry Pi 2 B+ (BCM2836)](results/1iFf.txt) | 900 MHz | 4.14 | Debian Stretch | **2070** | 592 | 17450 | 615 | 1175 | - |
| [SBC2D70 (SSD202D)](results/3N1U.txt) | 1700 MHz | 5.16 | Sid armhf | **1960** | 1094 | 33120 | 770 | 3190 | - |
| [Atom E3825](results/4kFQ.txt) | 1330 MHz | 5.10 | Bullseye amd64 | **1950** | 1109 | 165840 | 2890 | 2890 | - |
| [Raspberry Pi Zero 2 (RP3A0)](results/3Dfo.txt) | 600 MHz | 5.10 | Raspberry Pi OS Buster | **1900** | 529 | 18150 | 1040 | 1130 | - |
| [T-HEAD C910 RVB-ICE](results/41AB.txt) | 1200 MHz | 5.10 | Sid riscv64 | **1760** | 1007 | 26930 | 3340 | 6470 | - |
| [EspressoBin (Armada 3720)](results/1lCe.txt) | 1200 MHz | 4.18 | Stretch arm64 | **1630** | 869 | 544240 | 1000 | 2400 | 1.82 |
| [Atom N270](results/461n.txt) | 1600 MHz | 4.19 | Buster i386 | **1220** | 824 | 18760 | 1420 | 2840 | - |
| [EspressoBin (Armada 3720)](results/1kt2.txt) | 800 MHz | 4.17 | Stretch arm64 | **1138** | 636 | 368330 | 1040 | 2490 | 1.23 |
| [Olimex A20-Lime2](results/4rRV.txt) | 960 MHz | 5.10 | Bullseye armhf | **1080** | 589 | 18630 | 430 | 2020 | 0.87 |
| [Banana Pi (Allwinner A20)](results/3PLr.txt) | 960 MHz | 5.10 | Bullseye armhf | **1040** | 542 | 18640 | 440 | 2020 | - |
| [Cubietruck (Allwinner A20)](results/3Naw.txt) | 960 MHz | 5.10 | Bullseye armhf | **1030** | 541 | 18640 | 440 | 2010 | - |
| [Kendryte K510](results/41Qa.txt) | 790 MHz | 4.17 | Sid riscv64 | **690** | 402 | 7410 | 280 | 440 | - |
| [Lime A10 (Allwinner A10)](results/1j1L.txt) | 910 MHz | 4.14 | Stretch armhf | **550** | 550 | 28250 | 440 | 1300 | - |
| [Raspberry Pi B (BCM2835)](results/4vVG.txt) | 1000 MHz | 6.1 | Raspberry Pi OS Bullseye | **480** | 481 | 16900 | 490 | 2220 | - |
| [Raspberry Pi Zero (BCM2835)](results/3Njz.txt) | 1000 MHz | 5.10 | Bullseye armv6l/armhf | **460** | 460 | 17060 | 430 | 1670 | - |
| [Raspberry Pi Zero (BCM2835)](results/1niO.txt) | 1000 MHz | 4.14 | Raspbian Stretch | **450** | 450 | 16820 | 400 | 1590 | - |
| [ClockworkPi R-01 (Allwinner D1)](results/40BJ.txt) | 1000 MHz | 5.4 | Focal riscv64 | **450** | 450 | 9040 | 1220 | 2640 | - |
| [Raspberry Pi B (BCM2835)](results/3MGN.txt) | 700 MHz | 5.10 | Raspberry Pi OS Bullseye | **320** | 320 | 11630 | 360 | 1420 | - |

[(back to top of the page)](#sbc-bench-results-sorted)

## 7-zip MIPS single-threaded

| Device / details | Clockspeed | Kernel | Distro | 7-zip multi | *7-zip single* | AES | memcpy | memset | kH/s |
| ----- | :--------: | :----: | :----: | ----: | ------: | ------: | -----: | -----: | ---: |
| [Apple M1 Pro](results/443N.txt) | 3030/2060 MHz | 5.18 | Gentoo 2.8 arm64 | 43800 | **5010** | 1064450 | 27110 | 71910 | 48.28 |
| [Qualcomm Snapdragon 8cx Gen 3 (WSL2)](results/4kEp.txt) | 2980/? MHz | 5.15 | Jammy arm64 | 33600 | **4789** | 1679480 | 21010 | 41540 | 50.65 |
| [Pentium G4600](results/2jVw.txt) | 3600 MHz | 4.19 | Buster amd64 | 11810 | **4448** | 984820 | 15120 | 33380 | 21.88 |
| [Intel i3-N305](results/4qpr.txt) | 3800 MHz | 5.19 | Jammy amd64 | 20000 | **4398** | 1377280 | 9950 | 8990 | 41.43 |
| [Qualcomm Snapdragon 8cx Gen 3](results/4xwT.txt) | 3000/2440 MHz | 6.3 | Lunar arm64 | 35370 | **4312** | 1686160 | 17500 | 41780 | 42.76 |
| [Huaqin P6410<br />(2 x Ampere Altra Max)](results/4kiu.txt) | 3000 MHz | 5.4 | Focal arm64 | 430860 | **4211** | 1710010 | 13310 | 47970 | - |
| [Intel N100](results/4vxM.txt) | 3400 MHz | 6.1 | Lunar amd64 | 14150 | **4073** | 1232790 | 11600 | 12270 | 36.24 |
| [Intel N95](results/4xwq.txt) | 3400 MHz | 5.15 | Jammy amd64 | 13070 | **3993** | 1232880 | 9710 | 8730 | 34.60 |
| [Qualcomm QRB5165](results/49kx.txt) | 2840/2410/1790 MHz | 4.19 | Focal arm64 | 18860 | **3898** | 1598490 | 14470 | 23910 | 25.56 |
| [Ampere Altra M96-28](results/4zGI.txt) | 2800 MHz | 5.15 | Jammy arm64 | 249380 | **3858** | 1596110 | 10130 | 44750 | - |
| [Hetzner CAX11 (Ampere Altra)](results/4HdL.txt) | 3000 MHz | 5.15 | Jammy arm64 | 8060 | **3842** | 1705600 | 11250 | 47670 | 11.44 |
| [Ampere Altra Q80-26](results/4zkJ.txt) | 2600 MHz | 5.15 | Jammy arm64 | 214390 | **3748** | 1482190 | 11685 | 41560 | 316.50 |
| [Raspberry Pi 5 B (BCM2712)](results/4I1w.txt) | 3000 MHz | 6.1 | Bookworm arm64 | 12740 | **3747** | 1710050 | 4940 | 12640 | - |
| [Pentium N6005](results/4BtC.txt) | 3300/2000 MHz | 5.15 | Jammy amd64 | 11510 | **3369** | 923550 | 9650 | 10280 | 22.18 |
| [Ryzen R1505G](results/4HYd.txt) | 3270 MHz | 6.1 | Bookworm amd64 | 9080 | **3327** | 886980 | 10520 | 8160 | 18.14 |
| [MT8395 Genio 1200](results/4Kvg.txt) | 2200/2000 MHz | 5.15 | Jammy arm64 | 18130 | **3298** | 1240850 | 14200 | 19000 | 27.60 |
| [Jetson AGX Orin](results/4ax9.txt) | 2200 MHz | 5.10 | Focal arm64 | 39450 | **3187** | 1242940 | 10600 | 30350 | 59.96 |
| [Raspberry Pi 5 B (BCM2712)](results/4HDw.txt) | 2400 MHz | 6.1 | Bookworm arm64 | 10950 | **3160** | 1367990 | 5260 | 11520 | 15.42 |
| [Radxa ROCK 5B (RK3588)](results/41BH.txt) | 2350/1830 MHz | 5.10 | Focal arm64 | 16450 | **3146** | 1337540 | 10830 | 29220 | 25.31 |
| [Qualcomm Snapdragon 7c](results/4Lyf.txt) | 2550/1800 MHz | 6.6 | Bookworm arm64 | 13040 | **3113** | 1455700 | 6710 | 14880 | - |
| [Khadas Edge2 (RK3588s)](results/4a5U.txt) | 2260/1800 MHz | 5.10 | Jammy arm64 | 16470 | **3096** | 1287490 | 10860 | 29110 | - |
| [Celeron N4500](results/3HUU.txt) | 2800/1100 MHz | 5.13 | Impish amd64 | 6300 | **3091** | 783840 | 8100 | 8350 | - |
| [Celeron N5100](results/3IlQ.txt) | 2800/1100 MHz | 5.13 | Focal amd64 | 10550 | **3088** | 783800 | 7750 | 8090 | 19.22 |
| [Celeron N5105](results/3Qf7.txt) | 2900/2000 MHz | 5.13 | Focal amd64 | 11450 | **3059** | 811760 | 7710 | 9290 | 21.79 |
| [Loongson-3A5000-HV](results/4dzX.txt) | 2500 MHz | 4.19 | Loongnix 20 loongarch64 | 11120 | **2990** | 116900 | 6930 | 19170 | - |
| [Ryzen R1606G](results/2tQQ.txt) | 2600/1400 MHz | 5.4 | Focal amd64 | 7970 | **2854** | 700780 | 8230 | 5970 | 16.45 |
| [Phytium<br />FT-2000/4<br />(1 x SO-DIMM)](results/4ioj.txt) | 2600 MHz | 5.15 | Bullseye arm64 | 10020 | **2755** | 936740 | 3760 | 14540 | - |
| [Jetson Xavier AGX](results/4ebH.txt) | 2250 MHz | 4.9 | Bionic arm64 | 21590 | **2742** | 853250 | 10910 | 22520 | 26.57 |
| [Orange Pi 5 (RK3588)](results/4D0a.txt) | 2400/1800 MHz | 5.10 | Jammy arm64 | 16780 | **2689** | 1366590 | 12800 | 29900 | - |
| [Celeron N4020](results/4vNB.txt) | 2800 MHz | 5.15 | Bookworm amd64 | 4680 | **2577** | 780770 | 5480 | 5390 | - |
| [Athlon II X3 420e](results/4eOo.txt) | 2600 MHz | 4.19 | Buster amd64 | 4780 | **2566** | 98840 | 4120 | 3870 | - |
| [Qualcomm Snapdragon 835](results/4fdD.txt) | 2360/1900 MHz | 6.1 | Jammy arm64 | 9800 | **2474** | 883330 | 9720 | 14070 | 12.58 |
| [Pentium J5005](results/21rE.txt) | 2700/1500 MHz | 5.0 | Bionic amd64 | 9230 | **2455** | 778360 | 5530 | 7130 | 20.74 |
| [Amazon a1.xlarge](results/2iFY.txt) | 2300 MHz | 4.15 | Bionic arm64 | 8610 | **2406** | 1297960 | 4280 | 14220 | - |
| [Khadas VIM3 (Amlogic A311D)](results/4o1A.txt) | 2400/2015 MHz | 6.0 | Bullseye arm64 | 9650 | **2379** | 1366300 | 5080 | 9240 | - |
| [Khadas VIM3 (Amlogic A311D)](results/3R2Z.txt) | 2400/2015 MHz | 5.10 | Bullseye arm64 | 9650 | **2376** | 1366350 | 4850 | 7380 | - |
| [ODROID-N2+ (Amlogic S922X)](results/4rWn.txt) | 2400/2015 MHz | 6.1 | Bullseye arm64 | 9710 | **2373** | 1366180 | 4220 | 7720 | - |
| [ODROID-N2+ (Amlogic S922X)](results/3R1a.txt) | 2400/2015 MHz | 5.10 | Focal arm64 | 9680 | **2372** | 1366730 | 4030 | 7120 | - |
| [Celeron J4125](results/4hau.txt) | 2700/2000 MHz | 5.15 | Jammy amd64 | 7620 | **2367** | 751360 | 5110 | 5960 | 18.30 |
| [Celeron J4105](results/1qal.txt) | 2400/1500 MHz | 4.15 | Bionic amd64 | 9020 | **2290** | 697100 | 5500 | 7410 | 19.07 |
| [Honeycomb LX2 (NXP LX2160A)](results/3Y4f.txt) | 2200 MHz | 5.16 | Fedora 35 aarch64 | 30690 | **2288** | 1251710 | 5050 | 16220 | 46.09 |
| [Celeron J4105](results/1qb0.txt) | 2400/1500 MHz | 4.15 | Bionic amd64 | 8960 | **2274** | 697080 | 5620 | 7650 | 19.13 |
| [ODROID-N2+ (Amlogic S922X)](results/3DtN.txt) | 2400/2015 MHz | 5.14 | Impish arm64 | 9790 | **2253** | 1366930 | 4300 | 7480 | - |
| [Phytium D2000<br />(2 x SO-DIMM)](results/446h.txt) | 2300 MHz | 5.19 | Jammy arm64 | 16670 | **2252** | 828130 | 3480 | 16110 | - |
| [Clearfog CX (NXP LX2160A)](results/4ju5.txt) | 2000 MHz | 5.10 | Focal arm64 | 25260 | **2236** | 1136690 | 4460 | 12500 | - |
| [Celeron N4100](results/1uTS.txt) | 2300/1100 MHz | 4.15 | Bionic amd64 | 8510 | **2222** | 669350 | 4750 | 5240 | 18.33 |
| [Phytium D2000<br />(1 x SO-DIMM)](results/445T.txt) | 2300 MHz | 5.19 | Jammy arm64 | 16390 | **2220** | 827090 | 2820 | 6490 | - |
| [Jetson Xavier NX](results/3YWp.txt) | 1890 MHz | 4.9 | Bionic arm64 | 13230 | **2201** | 706280 | 9190 | 18480 | - |
| [Celeron 5205U](results/4eiM.txt) | 1900 MHz | 5.15 | Jammy amd64 | 4060 | **2171** | 521090 | 7350 | 16020 | 11.20 |
| [Jetson Orin Nano](results/4vy7.txt) | 1510 MHz | 5.10 | Focal arm64 | 13650 | **2153** | 854400 | 6730 | 20240 | 20.68 |
| [Pentium J4205](results/1m5t.txt) | 2560/1500 MHz | 4.17 | Stretch amd64 | 7570 | **2146** | 480640 | 5070 | 5170 | 18.82 |
| [Khadas VIM4 (A311D2)](results/3Wvv.txt) | 2200/1970 MHz | 5.4 | Focal arm64 | 12090 | **2081** | 1253200 | 7810 | 11600 | - |
| [Khadas VIM4 (A311D2)](results/4cHh.txt) | 2200/2010 MHz | 5.4 | Jammy arm64 | 12120 | **2067** | 1254540 | 8180 | 11680 | - |
| [Celeron J3455](results/1m5p.txt) | 2300/1500 MHz | 4.17 | Stretch amd64 | 7000 | **2037** | 429660 | 4090 | 4050 | 17.26 |
| [Celeron N3350](results/4rJj.txt) | 2400 MHz | 6.0 | Bullseye amd64 | 3810 | **2034** | 446170 | 5190 | 5700 | - |
| [Khadas VIM3 (Amlogic A311D)](results/1MFD.txt) | 2200/1800 MHz | 4.9 | Bionic arm64 | 8600 | **2026** | 1256910 | 4980 | 9300 | 13.12 |
| [ODROID-N2 (Amlogic S922X)](results/3MuT.txt) | 2000/1900 MHz | 5.10 | Buster arm64 | 9090 | **2012** | 1085350 | 4260 | 9080 | - |
| [AMD Seattle (Opteron A1100)](results/4Kqn.txt) | 2000 MHz | 4.15 | Bionic arm64 | 14080 | **2006** | 720710 | 3020 | 9530 | - |
| [Jetson Nano](results/3Ufc.txt) | 2000 MHz | 4.9 | Bionic arm64 | 6260 | **1977** | 717500 | 4100 | 11760 | 8.72 |
| [Pentium N4200](results/1ngq.txt) | 2560/1100 MHz | 4.14 | Bionic amd64 | 7469 | **1976** | 468008 | 4682 | 4997 | 18.75 |
| [Hugsun X99 (RK3399)](results/2ICt.txt) | 2088/1800 MHz | 5.9 | Focal arm64 | 7710 | **1927** | 1184306 | 2270 | 5970 | - |
| [NanoPi NEO4 (RK3399)](results/3GmR.txt) | 2016/1512 MHz | 5.10 | Focal arm64 | 6970 | **1906** | 1145030 | 2450 | 6190 | 11.36 |
| [Raspberry Pi 400 (BCM2711)](results/2Cyi.txt) | 1800 MHz | 5.4 | Raspberry Pi OS Buster | 6550 | **1903** | 77890 | 2680 | 3110 | - |
| [Nintendo Switch (Tegra X1)](results/3Di2.txt) | 2060 MHz | 4.9 | Bionic arm64 | 6720 | **1901** | 746680 | 2370 | 3670 | 9.25 |
| [Radxa Rock Pi 4 (RK3399)](results/3Q2q.txt) | 2000/1500 MHz | 5.10 | Focal arm64 | 6900 | **1899** | 1146500 | 3430 | 8260 | - |
| [Raspberry Pi 4 B (BCM2711)](results/3Gia.txt) | 1800 MHz | 5.10 | Raspberry Pi OS Buster | 6550 | **1897** | 77830 | 2780 | 3080 | - |
| [OrangePi 4 (RK3399)](results/4Kau.txt) | 2010/1510 MHz | 6.1 | Bookworm arm64 | 6880 | **1891** | 1145840 | 3490 | 8430 | - |
| [BeagleBone AI-64 (TI J721E)](results/4DLw.txt) | 2000 MHz | 5.10 | Bookworm arm64 | 3470 | **1872** | 1130390 | 2660 | 8710 | - |
| [NanoPi M4v2 (RK3399)](results/3MAK.txt) | 2015/1510 MHz | 5.10 | Bullseye arm64 | 6680 | **1855** | 921980 | 3110 | 7640 | - |
| [Raspberry Pi 4 B (BCM2711)](results/3VME.txt) | 1800 MHz | 5.15 | Jammy armhf | 6300 | **1844** | 82750 | 1190 | 3110 | - |
| [NanoPi M4 (RK3399)](results/1lzP.txt) | 2000/1500 MHz | 4.19 | Stretch arm64 | 6400 | **1835** | 1128330 | 4080 | 8270 | 8.86 |
| [RockPro64 (RK3399)](results/2yIx.txt) | 2010/1510 MHz | 5.8 | Bullseye arm64 | 7000 | **1833** | 1144950 | 3690 | 8360 | 11.08 |
| [RockPro64 (RK3399)](results/2sZH.txt) | 2010/1510 MHz | 5.4 | Focal arm64 | 6920 | **1826** | 1145300 | 3700 | 8430 | 11.55 |
| [H270-T70<br />(2 x ThunderX CN8890)](results/3N5c.txt) | 2000 Mhz | 5.16 | Sid arm64 | 107180 | **1826** | 340750 | 4180 | 17130 | - |
| [Radxa Rock Pi 4 (RK3399)](results/21fX.txt) | 2000/1500 MHz | 5.3 | Bionic arm64 | 6910 | **1817** | 1147370 | 3660 | 8310 | 10.71 |
| [NanoPi NEO4 (RK3399)](results/1p3T.txt) | 2000/1500 MHz | 4.19 | Stretch arm64 | 6750 | **1814** | 1139850 | 2370 | 6110 | 8.84 |
| [RockPro64 (RK3399)](results/1iFZ.txt) | 1800/1400 MHz | 4.4 | Stretch armhf | 6250 | **1809** | 1000150 | 2000 | 4835 | - |
| [NanoPC T4 (RK3399)](results/1iFz.txt) | 1800/1400 MHz | 4.17 | Stretch arm64 | 6250 | **1809** | 1022500 | 4100 | 9000 | 8.24 |
| [Celeron J1900](results/4hKV.txt) | 2415/1333 MHz | 5.4 | Focal amd64 | 6560 | **1806** | 34900 | 3780 | 3390 | - |
| [x7-Z8700](results/4iDX.txt) | 2400 MHz | 5.15 | Bullseye amd64 | 6580 | **1784** | 296680 | 3510 | 3580 | - |
| [Raspberry Pi 4 B (BCM2711)](results/3OBF.txt) | 1800 MHz | 5.10 | Raspberry Pi OS Bullseye arm64 | 5790 | **1769** | 36260 | 2330 | 3120 | 8.74 |
| [Celeron N2807](results/4z3s.txt) | 2165 MHz | 5.10 | Bullseye) amd64 | 3070 | **1766** | 31250 | 3600 | 3110 | 6.09 |
| [NanoPC T4 (RK3399)](results/1iWU.txt) | 1800/1400 MHz | 4.17 | Stretch arm64 | 6230 | **1756** | 1023600 | 4100 | 9060 | 10.30 |
| [RockPro64 (RK3399)](results/1iFp.txt) | 1800/1400 MHz | 4.18 | Stretch arm64 | 6300 | **1755** | 1021500 | 3650 | 8450 | 8.20 |
| [Raspberry Pi 4 B (BCM2711)](results/3InF.txt) | 1800 MHz | 5.15 | Armbian Jammy arm64 | 5640 | **1752** | 36260 | 2580 | 3110 | - |
| [Raspberry Pi 4 B (BCM2711)](results/3F9C.txt) | 1800 MHz | 5.10 | Raspberry Pi OS Buster arm64 | 5760 | **1741** | 36240 | 2240 | 3120 | 9.46 |
| [NanoPC T4 (RK3399)](results/1iZq.txt) | 1800/1400 MHz | 4.17 | Stretch arm64 | 6380 | **1741** | 1022600 | 4160 | 9000 | 9.36 |
| [Macchiatobin (Armada 8040)](results/4zcm.txt) | 1600 MHz | 5.10 | Buster arm64 | 5720 | **1739** | 909420 | 4510 | 12270 | 7.91 |
| [Raspberry Pi 4 B (BCM2711)](results/3N94.txt) | 1800 MHz | 5.10 | Raspberry Pi OS Bullseye | 5940 | **1738** | 77670 | 2310 | 2690 | - |
| [Khadas Edge (RK3399)](results/1rYm.txt) | 2000/1500 MHz | 4.4 | Bionic arm64 | 6550 | **1721** | 1130400 | 2810 | 4860 | 10.50 |
| [Nintendo Switch (Tegra X1)](results/1Rnj.txt) | 1780 MHz | 4.9 | Fedora 30 arm-64 | 6170 | **1719** | 642670 | 2500 | 3570 | - |
| [NanoPi NEO4 (RK3399)](results/1oim.txt) | 2000/1500 MHz | 4.4| Stretch arm64 | 6520 | **1718** | 1123190 | 2280 | 4770 | 8.83 |
| [Tinkerboard (RK3288)](results/3X9q.txt) | 1800 MHz | 5.10 | Buster armhf | 5770 | **1713** | 67060 | 1540 | 4110 | - |
| [NanoPi NEO4 (RK3399)](results/1oho.txt) | 2000/1500 MHz | 4.4| Stretch arm64 | 6510 | **1703** | 1128860 | 2260 | 4770 | 8.71 |
| [Khadas Edge (RK3399)](results/1uar.txt) | 2000/1500 MHz | 4.4 | Stretch arm64 | 6600 | **1703** | 1127780 | 2860 | 4880 | 8.85 |
| [Tinkerboard (RK3288)](results/3Lir.txt) | 1800 MHz | 4.4 | Buster armhf | 5440 | **1693** | 66300 | 1340 | 3510 | - |
| [ODROID-C4 (S905X3)](results/3TQ2.txt) | 2100 MHz | 5.10 | Buster arm64 | 5770 | **1679** | 981940 | 3540 | 5150 | - |
| [RockPro64 (RK3399)](results/1ub9.txt) | 1800/1400 MHz | 4.4 | Stretch arm64 | 6420 | **1673** | 1018480 | 3720 | 8400 | 8.24 |
| [TinkerBoard S (RK3288)](results/4vfU.txt) | 1800 MHz | 6.1 | Jammy armhf | 5560 | **1672** | 65800 | 1540 | 4150 | - |
| [ODROID-HC4 (S905X3)](results/3Na5.txt) | 2100 MHz | 5.10 | Buster arm64 | 5730 | **1672** | 980970 | 3540 | 5150 | - |
| [ODROID-N2 (Amlogic S922X)](results/1BsF.txt) | 1800/1900 MHz | 4.9 | Bionic arm64 | 8140 | **1669** | 1024680 | 4120 | 8610 | 11.39 |
| [Celeron N2830](results/4pEc.txt) | 2160 MHz | 5.19 | Jammy amd64 | 2760 | **1664** | 31270 | 3780 | 3520 | 6.10 |
| [Raspberry Pi 4 B (BCM2711)](results/3EgS.txt) | 1500 MHz | 5.10 | Raspberry Pi OS Buster | 5750 | **1661** | 64930 | 2550 | 3430 | - |
| [Atom E3950](results/4dd5.txt) | 2000 MHz | 5.15 | Jammy amd64 | 6440 | **1636** | 374800 | 4400 | 4840 | - |
| [ODROID-XU4 (Exynos 5422)](results/1iWL.txt) | 2000/1400 MHz | 4.9 | Stretch armhf | 6400 | **1622** | 72075 | 2230 | 4850 | - |
| [Milk-V Pioneer (SG2042)](results/4wYE.txt) | 2000 MHz | 6.1 | Kinetic riscv64 | 59820 | **1622** | 43500 | 3620 | 4760 | - |
| [Raspberry Pi 4 B (BCM2711)](results/1MFf.txt) | 1500 MHz | 4.19 | Raspbian Buster | 5500 | **1606** | 64860 | 2460 | 3170 | - |
| [ODROID-XU4 (Exynos 5422)](results/3GnC.txt) | 2000/1400 MHz | 5.4 | Focal armhf | 8980 | **1604** | 72020 | 2280 | 4910 | - |
| [Lichee Pi 4A (T-Head TH1520)](results/4xYE.txt) | 1990 MHz | 5.10 | Bookworm riscv64 | 5260 | **1592** | 43820 | 4350 | 14760 | - |
| [RockPro64 (RK3399)](results/1lBC.txt) | 1800/1400 MHz | 4.4 | Stretch arm64 | 6140 | **1580** | 1015600 | 2770 | 4850 | 8.14 |
| [Jetson Nano](results/4rLX.txt) | 1480 MHz | 4.9 | Bullseye arm64 | 5260 | **1578** | 531940 | 3730 | 8870 | - |
| [ODROID-M1 (RK3568)](results/4ijy.txt) | 2060 MHz | 5.18 | Bullseye arm64 | 5430 | **1567** | 961090 | 3310 | 5960 | 7.76 |
| [Tinkerboard (RK3288)](results/1iSX.txt) | 1730 MHz | 4.14 | Stretch armhf | 5350 | **1563** | 66600 | 1480 | 3900 | - |
| [NanoPi R5S (RK3568)](results/4jfZ.txt) | 1960 MHz | 6.1 | Bullseye arm64 | 5030 | **1482** | 914340 | 2990 | 5970 | 7.33 |
| [ODROID-C4 (S905X3)](results/2kaS.txt) | 2010 MHz | 4.9 | Focal arm64 | 5450 | **1459** | 941590 | 3310 | 6270 | 7.71 |
| [Quartz64-A (RK3566)](results/4qJF.txt) | 1890 MHz | 6.2 | Jammy arm64 | 4980 | **1457** | 884590 | 3240 | 6100 | 6.98 |
| [x5-Z8350](results/2Jdb.txt) | 1920/1680 MHz | 5.4 | Focal amd64 | 4790 | **1454** | 237230 | 3170 | 2960 | 9.38 |
| [Radxa ROCK 3A (RK3568)](results/40TX.txt) | 2000 MHz | 5.18 | Bullseye arm64 | 5110 | **1450** | 935920 | 3150 | 6250 | 7.58 |
| [ODROID-M1 (RK3568)](results/3Ug9.txt) | 1930 MHz | 4.19 | Focal arm64 | 5010 | **1450** | 898610 | 3070 | 6220 | 7.14 |
| [Atom Z3735F](results/4r54.txt) | 1830 MHz | 5.15 | Jammy amd64 | 4510 | **1437** | 227900 | 3020 | 2780 | - |
| [RK3568-ROC-PC](results/3Rsg.txt) | 1960 MHz | 4.19 | Bullseye arm64 | 5040 | **1424** | 912800 | 3130 | 6240 | - |
| [Khadas VIM3L (S905D3)](results/3Vdt.txt) | 1900 MHz | 5.16 | Bullseye arm64 | 5110 | **1403** | 890730 | 3700 | 5140 | - |
| [Khadas VIM3L (S905D3)](results/26Wy.txt) | 1900 MHz | 4.9 | Bionic arm64 | 5160 | **1399** | 892110 | 3670 | 6360 | 7.29 |
| [Hlink H28K (RK3528)](results/4I93.txt) | 2000 Mhz | 5.10 | Jammy arm64 | 4680 | **1388** | 933630 | 2090 | 7650 | 6.48 |
| [Radxa Zero (S905Y2)](results/3PlT.txt) | 1800 MHz | 5.10 | Buster arm64 | 4570 | **1373** | 839080 | 1610 | 5250 | 6.82 |
| [x5-Z8300](results/4j4o.txt) | 1840 MHz | 5.15 | Jammy amd64 | 4430 | **1368** | 227030 | 2270 | 2380 | 8.84 |
| [Radxa Zero (S905Y2)](results/3JCm.txt) | 1800 MHz | 5.10 | Bullseye arm64 | 4580 | **1353** | 838360 | 1600 | 5360 | 7.13 |
| [Quartz64-A (RK3566)](results/3rUb.txt) | 1810 MHz | 5.13 | Buster arm64 | 4840 | **1353** | 845490 | 2980 | 7650| - |
| [i.MX8MPlus EVK](results/4hx0.txt) | 1800 MHz | 5.15 | Focal arm64 | 4990 | **1348** | 837680 | 2740 | 12420 | 7.02 |
| [NanoPi NEO4 (RK3399)](results/1oib.txt) | 2000/1500 MHz | 4.4| Stretch arm64 | 6030 | **1343** | 1121380 | 2230 | 4770 | 8.57 |
| [NanoPC T4 (RK3399)](results/1lkG.txt) | 2000/1500 MHz | 4.4 | Stretch arm64 | 5870 | **1336** | 1124040 | 2810 | 4890 | 8.70 |
| [AMedia X96 Max+ (S905X3)](results/3QOj.txt) | 2100 MHz | 5.15 | Focal arm64 | 5270 | **1330** | 981830 | 2630 | 5150 | - |
| [PineH64 (Allwinner H6)](results/26Ph.txt) | 1800 MHz | 5.4 | Buster arm64 | 4710 | **1293** | 839870 | 1420 | 5560 | 7.10 |
| [PineH64 (Allwinner H6)](results/1jEr.txt) | 1800 MHz | 4.18 | Stretch arm64 | 4650 | **1274** | 836900 | 1380 | 5530 | 5.62 |
| [x5-Z8350](results/1HnC.txt) | 1920/1680 MHz | 4.15 | Bionic amd64 | 4710 | **1272** | 207640 | 2740 | 3140 | - |
| [Radxa Zero (S905Y2)](results/3wZn.txt) | 1800 MHz | 5.10 | Focal arm64 | 4610 | **1267** | 840080 | 1600 | 5370 | - |
| [AMD E-450 APU](results/4hwl.txt) | 1650 MHz | 5.15 | Jammy amd64 | 2430 | **1258** | 27450 | 1710 | 1740 | - |
| [Clearfog A1<br />(Armada 388)](results/4d1U.txt) | 1600 MHz | 5.15 | Bullseye armhf | 2230 | **1239** | 44080 | 910 | 5060 | - |
| [MangoPi Mcore (Allwinner H616)](results/4bSf.txt) | 1800 MHz | 5.19 | Jammy arm64 | 4100 | **1218** | 840270 | 990 | 2380 | - |
| [Helios4<br />(Armada 388)](results/1jCy.txt) | 1600 MHz | 4.14 | Stretch armhf | 2210 | **1215** | 42500 &ast;98560 | 910 | 4840 | - |
| [HummingBoard Pulse i.MX8M Quad](results/27FC.txt) | 1500 MHz | 4.19 | Buster arm64 | 4330 | **1201** | 695540 | 2230 | 9900 | - |
| [VisionFive V2 (JH7110)](results/4xOY.txt) | 1500 MHz | 5.15 | Sid riscv64 | 4180 | **1197** | 25080 | 880 | 770 | - |
| [Milk-V Mars CM (JH7110)](results/4K7E.txt) | 1500 MHz | 5.15 | Bookworm riscv64 | 4110 | **1195** | 25070 | 930 | 830 | - |
| [Star64 (JH7110)](results/4tjq.txt) | 1500 MHz | 5.15 | Sid riscv64 | 3970 | **1175** | 24990 | 820 | 770 | - |
| [Orange Pi Zero 2W (Allwinner H618)](results/4Hd0.txt) | 1510 MHz | 6.1 | Jammy arm64 | 3920 | **1167** | 705660 | 1510 | 6010 | 6.02 |
| [Orange Pi Zero 3 (Allwinner H618)](results/4CPF.txt) | 1510 MHz | 6.1 | Jammy arm64 | 4020 | **1165** | 705330 | 1510 | 6010 | 6.02 |
| [NanoPi K2 (Amlogic S905)](results/3Qve.txt) | 1480 MHz | 5.10 | Bullseye arm64 | 3880 | **1154** | 51490 | 1850 | 3790 | - |
| [Khadas VIM1S (S905Y4)](results/4bbv.txt) | 2000 MHz | 5.4 | Jammy arm64 | 4000 | **1148** | 436540 | 1970 | 7530 | - |
| [Khadas VIM1 (Amlogic S905X)](results/4bee.txt) | 1415 MHz | 5.1 | Buster arm64 | 3860 | **1136** | 660160 | 1940 | 5900 | - |
| [ODROID-C2 (Amlogic S905)](results/1ixI.txt) | 1750 MHz | 3.14 | Xenial arm64 | 4070 | **1128** | 48500 | 1750 | 3100 | - |
| [Tronsmart S82 (Amlogic S802)](results/41ML.txt) | 1600 MHz | 5.14 | Focal armhf | 3640 | **1114** | 43150 | 500 | 3200 | - |
| [Tronsmart MXIII Plus (S812)](results/3S5U.txt) | 1560 MHz | 5.10 | Buster armhf | 3880 | **1113** | 42570 | 1470 | 3430 | - |
| [Atom E3826](results/44pd.txt) | 1460 MHz | 5.18 | Jammy amd64 | 2140 | **1112** | 182190 | 2840 | 2760 | - |
| [Atom E3825](results/4kFQ.txt) | 1330 MHz | 5.10 | Bullseye amd64 | 1950 | **1109** | 165840 | 2890 | 2890 | - |
| [NanoPi K2 (Amlogic S905)](results/1iT1.txt) | 1480 MHz | 4.14 | Stretch arm64 | 3850 | **1095** | 50370 | 1660 | 3870 | 4.61 |
| [SBC2D70 (SSD202D)](results/3N1U.txt) | 1700 MHz | 5.16 | Sid armhf | 1960 | **1094** | 33120 | 770 | 3190 | - |
| [NanoPi Fire3 (Nexell S5P6818)](results/3ZxU.txt) | 1400 MHz | 4.14 | Focal arm64 | 7350 | **1093** | 652640 | 1530 | 4590 | 11.18 |
| [Raspberry Pi 3 B+ (BCM2837B0)](results/1iI5.txt) | original | 4.9 | Raspbian Stretch | 3600 | **1076** | 42700 | 1230 | 1640 | - |
| [Renegade (RK3328)](results/1iFx.txt) | 1400 MHz | 4.4 | Stretch arm64 | 3710 | **1069** | 644200 | 1565 | 7435 | 3.92 |
| [Orange Pi Zero 2 (Allwinner H616)](results/4knM.txt) | 1510 MHz | 4.9 | Buster arm64 | 3550 | **1067** | 703300 | 1190 | 2820 | 5.01 |
| [Le Potato (Amlogic S905X)](results/1iSQ.txt) | 1410 MHz | 4.18 | Stretch arm64 | 3780 | **1057** | 657200 | 1810 | 5730 | 3.92 |
| [NanoPC T3+ (Nexell S5P6818)](results/1iRJ.txt) | 1400 MHz | 4.14 | Bionic arm64 | 7480 | **1053** | 652600 | 1440 | 4540 | 10.99 |
| [NanoPi Fire3 (Nexell S5P6818)](results/1jjm.txt) | 1400 MHz | 4.14 | Bionic arm64 | 7440 | **1052** | 653000 | 1560 | 4600 | 10.96 |
| [Raspberry Pi 3 B+ (BCM2837B0)](results/1isD.txt) | with fan | 4.14 | Raspbian Stretch | 3670 | **1046** | 42600 | 1120 | 1600 | - |
| [NanoPi Fire3 (Nexell S5P6818)](results/1jiU.txt) | 1380 MHz | 4.14 | Stretch arm64 | 7420 | **1038** | 645400 | 1520 | 4570 | 8.53 |
| [Rock64 (RK3328)](results/1iFm.txt) | 1400 MHz | 4.4 | Stretch arm64 | 3610 | **1034** | 644250 | 1330 | 5700 | 3.85 |
| [Rock64 (RK3328)](results/1iYK.txt) | 1400 MHz | 4.4 | Stretch arm64 | 3580 | **1032** | 644380 | 1330 | 5680 | 4.63 |
| [Rock64 (RK3328)](results/1iZj.txt) | 1400 MHz | 4.4 | Stretch arm64 | 3590 | **1030** | 643700 | 1320 | 5640 | 4.40 |
| [Orange Pi PC 2 (Allwinner H5)](results/3MQJ.txt) | 1370 MHz | 5.10 | Focal arm64 | 3500 | **1023** | 637410 | 1070 | 3680 | - |
| [NanoPi K1 Plus (Allwinner H5)](results/3N7H.txt) | 1370 MHz | 5.10 | Focal arm64 | 3520 | **1022** | 638880 | 1070 | 3680 | 5.50 |
| [Libre Computer AML-S912-PC](results/40cj.txt) | 1415/1000 MHz | 5.15 | Bullseye arm64 | 5980 | **1012** | 659290 | 1650 | 5170 | - |
| [T-HEAD C910 RVB-ICE](results/41AB.txt) | 1200 MHz | 5.10 | Sid riscv64 | 1760 | **1007** | 26930 | 3340 | 6470 | - |
| [Raspberry Pi Zero 2 (RP3A0)](results/3DeL.txt) | 1200 MHz | 5.10 | Raspberry Pi OS Buster | 3640 | **1007** | 36300 | 1320 | 1790 | - |
| [Rock64 (RK3328)](results/1iwz.txt) | 1400 MHz | 4.4 | Stretch armhf | 3620 | **1006** | 624000 | 1430 | 3620 | - |
| [Atom N2800](results/4nt8.txt) | 1860 MHz | 5.15 | Bullseye amd64 | 2970 | **1006** | 21780 | 2050 | 1570 | - |
| [Rock64 (RK3328)](results/1iHB.txt) | 1300 MHz | 4.18 | Stretch arm64 | 3560 | **1002** | 603800 | 1340 | 5770 | 3.80 |
| [Rock64 (RK3328)](results/1iH4.txt) | 1300 MHz | 4.18 | Bionic arm64 | 3530 | **996** | 605250 | 1340 | 5770 | 4.65 |
| [Ugoos UT2 (RK3188)](results/408h.txt) | 1560 MHz | 5.10 | Jammy armhf | 3320 | **994** | 43250 | 320 | 2020 | - |
| [Khadas VIM2 (Amlogic S912)](results/1iJ7.txt) | 1415/1000 MHz | 4.17 | Bionic arm64 | 5450 | **993** | 659600 | 1920 | 5920 | 8.59 |
| [Orange Pi Prime (Allwinner H5)](results/2kTH.txt) | 1370 MHz | 5.4 | Buster | 3590 | **984** | 637980 | 1180 | 3540 | - |
| [Raspberry Pi 3 B (BCM2837)](results/4hOP.txt) | 1200 MHz | 5.15 | Raspbian Sid | 2970 | **977** | 36230 | 1110 | 1700 | 2.89 |
| [Rock64 (RK3328)](results/1iHo.txt) | 1300 MHz | 4.4 | Stretch arm64 | 3430 | **952** | 601000 | 1350 | 5680 | 3.64 |
| [Marvell PXA1908](results/46hs.txt) | 1245 MHz | 3.14 | Bullseye arm64 | 3180 | **951** | 581840 | 740 | 2220 | - |
| [x5-Z8300](results/1lgD.txt) | 1420 MHz | 4.9 | Stretch amd64 | 3900 | **950** | 178010 | 2380 | 2380 | 7.81 |
| [Rock64 (RK3328)](results/1iGW.txt) | 1300 MHz | 4.4 | Bionic arm64 | 3410 | **945** | 601200 | 1310 | 5680 | 4.46 |
| [NanoPC T3+ (Nexell S5P6818)](results/1iyp.txt) | 1400 MHz | 4.4 | Xenial armhf | 6400 | **943** | 651000 | 1650 | 3700 | - |
| [Raspberry Pi 3 B+ (BCM2837B0)](results/1ism.txt) | normal | 4.14 | Raspbian Stretch | 3240 | **914** | 36600 | 1130 | 1530 | - |
| [TRONFY MXQ (Amlogic S805)](results/3MiR.txt) | 1536 MHz | 5.10 | Focal armhf | 3100 | **897** | 29080 | 980 | 2990 | - |
| [Akaso M8S (S812)](results/3R3N.txt) | 1200 MHz | 5.10 | Buster armhf | 3050 | **885** | 32120 | 1160 | 3330 | - |
| [NanoPi M1 Plus (Allwinner H3)](results/3N2z.txt) | 1370 MHz | 4.19 | Bionic armhf | 3030 | **881** | 26660 | 830 | 3450 | - |
| [Orange Pi PC+ (Allwinner H3)](results/3MQV.txt) | 1370 MHz | 5.10 | Focal armhf | 3060 | **879** | 26590 | 890 | 3450 | - |
| [ODROID-C1 (Amlogic S805)](results/4eg5.txt) | 1500 MHz | 5.19 | Jammy armhf | 3010 | **878** | 29260 | 390 | 2910 | - |
| [EspressoBin (Armada 3720)](results/1lCe.txt) | 1200 MHz | 4.18 | Stretch arm64 | 1630 | **869** | 544240 | 1000 | 2400 | 1.82 |
| [RK3318 BOX](results/4kor.txt) | 1390 MHz | 6.0 | Jammy arm64 | 3200 | **867** | 644750 | 700 | 2460 | - |
| [MT6580 K9M1](results/466y.txt) | 1300 MHz | 5.19 | Sid armhf | 2930 | **860** | 25300 | 1250 | 3300 | - |
| [Raspberry Pi 3 B+ (BCM2837B0)](results/1iH0.txt) | UV/normal | 4.14 | Raspbian Stretch | 2100 | **856** | 36400 | 1040 | 1460 | - |
| [Raspberry Pi 3 B+ (BCM2837B0)](results/1iGM.txt) | normal | 4.14 | Raspbian Stretch | 3040 | **856** | 36600 | 1050 | 1500 | - |
| [BPi R2 (MT7623)](results/4dO7.txt) | 1300 MHz | 4.19 | Focal armhf | 2990 | **854** | 25260 | 1550 | 3220 | - |
| [Raspberry Pi 3 B+ (BCM2837B0)](results/1iGz.txt) | OC/normal | 4.14 | Raspbian Stretch | 3130 | **843** | 36620 | 1230 | 1780 | - |
| [Raspberry Pi Zero 2 (RP3A0)](results/3E85.txt) | 1000 MHz | 5.10 | Raspberry Pi OS Buster | 3030 | **838** | 29860 | 1300 | 1570 | - |
| [Atom N270](results/461n.txt) | 1600 MHz | 4.19 | Buster i386 | 1220 | **824** | 18760 | 1420 | 2840 | - |
| [Orange Pi Plus 2 (Allwinner H3)](results/1iX4.txt) | 1300 MHz | 4.14 | Stretch armhf | 2890 | **812** | 25250 | 830 | 3240 | - |
| [Teres-I<br />(Allwinner A64)](results/1tJg.txt) | 1050 MHz | 4.19 | Stretch arm64 | 2785 | **780** | 491590 | 1080 | 2820 | - |
| [BPi M2U (Allwinner R40)](results/4kmM.txt) | 1200 MHz | 6.0 | Bullseye armhf | 2690 | **767** | 23320 | 780 | 3010 | - |
| [Radxa Rock Pi S (RK3308)](results/4sNe.txt) | 1300 MHz | 6.1 | Jammy arm64 | 2540 | **732** | 282030 | 820 | 1870 | - |
| [RK3228A TV Box](results/3M9F.txt) | 1200 MHz | 4.4 | Buster armhf | 2310 | **710** | 23070 | 410 | 1230 | - |
| [Cubox-i4<br />(NXP i.MX6)](results/4132.txt) | 980 MHz | 5.15 | Jammy armhf | 2360 | **657** | 27000 | 340 | 340 | - |
| [EspressoBin (Armada 3720)](results/1kt2.txt) | 800 MHz | 4.17 | Stretch arm64 | 1138 | **636** | 368330 | 1040 | 2490 | 1.23 |
| [Raspberry Pi 2 B+ (BCM2836)](results/3MGs.txt) | 900 MHz | 5.10 | Raspberry Pi OS Bullseye | 2150 | **620** | 16500 | 1000 | 1180 | - |
| [Raspberry Pi 2 B+ (BCM2836)](results/1iFf.txt) | 900 MHz | 4.14 | Debian Stretch | 2070 | **592** | 17450 | 615 | 1175 | - |
| [Olimex A20-Lime2](results/4rRV.txt) | 960 MHz | 5.10 | Bullseye armhf | 1080 | **589** | 18630 | 430 | 2020 | 0.87 |
| [Lime A10 (Allwinner A10)](results/1j1L.txt) | 910 MHz | 4.14 | Stretch armhf | 550 | **550** | 28250 | 440 | 1300 | - |
| [Banana Pi (Allwinner A20)](results/3PLr.txt) | 960 MHz | 5.10 | Bullseye armhf | 1040 | **542** | 18640 | 440 | 2020 | - |
| [Cubietruck (Allwinner A20)](results/3Naw.txt) | 960 MHz | 5.10 | Bullseye armhf | 1030 | **541** | 18640 | 440 | 2010 | - |
| [Raspberry Pi Zero 2 (RP3A0)](results/3Dfo.txt) | 600 MHz | 5.10 | Raspberry Pi OS Buster | 1900 | **529** | 18150 | 1040 | 1130 | - |
| [Raspberry Pi B (BCM2835)](results/4vVG.txt) | 1000 MHz | 6.1 | Raspberry Pi OS Bullseye | 480 | **481** | 16900 | 490 | 2220 | - |
| [Raspberry Pi Zero (BCM2835)](results/3Njz.txt) | 1000 MHz | 5.10 | Bullseye armv6l/armhf | 460 | **460** | 17060 | 430 | 1670 | - |
| [Raspberry Pi Zero (BCM2835)](results/1niO.txt) | 1000 MHz | 4.14 | Raspbian Stretch | 450 | **450** | 16820 | 400 | 1590 | - |
| [ClockworkPi R-01 (Allwinner D1)](results/40BJ.txt) | 1000 MHz | 5.4 | Focal riscv64 | 450 | **450** | 9040 | 1220 | 2640 | - |
| [Kendryte K510](results/41Qa.txt) | 790 MHz | 4.17 | Sid riscv64 | 690 | **402** | 7410 | 280 | 440 | - |
| [Raspberry Pi B (BCM2835)](results/3MGN.txt) | 700 MHz | 5.10 | Raspberry Pi OS Bullseye | 320 | **320** | 11630 | 360 | 1420 | - |
| [ODROID-XU4 (Exynos 5422)](results/1ixL.txt) | 1900/1400 MHz | 3.10 | Jessie armhf | 6750 | **-** | 68200 | 2200 | 4800 | - |
| [BPi M4 (RTD1395)](results/1Dt1.txt) | 1400 MHz | 4.9 | Bionic arm64 | 3500 | **-** | 651460 | 1010 | 4360 | 5.48 |

[(back to top of the page)](#sbc-bench-results-sorted)

## openssl speed -elapsed -evp aes-256-cbc

(For an in-depth explanation of ARMv8 AES scores see [here](ARMv8-Crypto-Extensions.md))

| Device / details | Clockspeed | Kernel | Distro | 7-zip multi | 7-zip single | *AES* | memcpy | memset | kH/s |
| ----- | :--------: | :----: | :----: | ----: | ------: | ------: | -----: | -----: | ---: |
| [Raspberry Pi 5 B (BCM2712)](results/4I1w.txt) | 3000 MHz | 6.1 | Bookworm arm64 | 12740 | 3747 | **1710050** | 4940 | 12640 | - |
| [Huaqin P6410<br />(2 x Ampere Altra Max)](results/4kiu.txt) | 3000 MHz | 5.4 | Focal arm64 | 430860 | 4211 | **1710010** | 13310 | 47970 | - |
| [Hetzner CAX11 (Ampere Altra)](results/4HdL.txt) | 3000 MHz | 5.15 | Jammy arm64 | 8060 | 3842 | **1705600** | 11250 | 47670 | 11.44 |
| [Qualcomm Snapdragon 8cx Gen 3](results/4xwT.txt) | 3000/2440 MHz | 6.3 | Lunar arm64 | 35370 | 4312 | **1686160** | 17500 | 41780 | 42.76 |
| [Qualcomm Snapdragon 8cx Gen 3 (WSL2)](results/4kEp.txt) | 2980/? MHz | 5.15 | Jammy arm64 | 33600 | 4789 | **1679480** | 21010 | 41540 | 50.65 |
| [Qualcomm QRB5165](results/49kx.txt) | 2840/2410/1790 MHz | 4.19 | Focal arm64 | 18860 | 3898 | **1598490** | 14470 | 23910 | 25.56 |
| [Ampere Altra M96-28](results/4zGI.txt) | 2800 MHz | 5.15 | Jammy arm64 | 249380 | 3858 | **1596110** | 10130 | 44750 | - |
| [Ampere Altra Q80-26](results/4zkJ.txt) | 2600 MHz | 5.15 | Jammy arm64 | 214390 | 3748 | **1482190** | 11685 | 41560 | 316.50 |
| [Qualcomm Snapdragon 7c](results/4Lyf.txt) | 2550/1800 MHz | 6.6 | Bookworm arm64 | 13040 | 3113 | **1455700** | 6710 | 14880 | - |
| [Intel i3-N305](results/4qpr.txt) | 3800 MHz | 5.19 | Jammy amd64 | 20000 | 4398 | **1377280** | 9950 | 8990 | 41.43 |
| [Raspberry Pi 5 B (BCM2712)](results/4HDw.txt) | 2400 MHz | 6.1 | Bookworm arm64 | 10950 | 3160 | **1367990** | 5260 | 11520 | 15.42 |
| [ODROID-N2+ (Amlogic S922X)](results/3DtN.txt) | 2400/2015 MHz | 5.14 | Impish arm64 | 9790 | 2253 | **1366930** | 4300 | 7480 | - |
| [ODROID-N2+ (Amlogic S922X)](results/3R1a.txt) | 2400/2015 MHz | 5.10 | Focal arm64 | 9680 | 2372 | **1366730** | 4030 | 7120 | - |
| [Orange Pi 5 (RK3588)](results/4D0a.txt) | 2400/1800 MHz | 5.10 | Jammy arm64 | 16780 | 2689 | **1366590** | 12800 | 29900 | - |
| [Khadas VIM3 (Amlogic A311D)](results/3R2Z.txt) | 2400/2015 MHz | 5.10 | Bullseye arm64 | 9650 | 2376 | **1366350** | 4850 | 7380 | - |
| [Khadas VIM3 (Amlogic A311D)](results/4o1A.txt) | 2400/2015 MHz | 6.0 | Bullseye arm64 | 9650 | 2379 | **1366300** | 5080 | 9240 | - |
| [ODROID-N2+ (Amlogic S922X)](results/4rWn.txt) | 2400/2015 MHz | 6.1 | Bullseye arm64 | 9710 | 2373 | **1366180** | 4220 | 7720 | - |
| [Radxa ROCK 5B (RK3588)](results/41BH.txt) | 2350/1830 MHz | 5.10 | Focal arm64 | 16450 | 3146 | **1337540** | 10830 | 29220 | 25.31 |
| [Amazon a1.xlarge](results/2iFY.txt) | 2300 MHz | 4.15 | Bionic arm64 | 8610 | 2406 | **1297960** | 4280 | 14220 | - |
| [Khadas Edge2 (RK3588s)](results/4a5U.txt) | 2260/1800 MHz | 5.10 | Jammy arm64 | 16470 | 3096 | **1287490** | 10860 | 29110 | - |
| [Khadas VIM3 (Amlogic A311D)](results/1MFD.txt) | 2200/1800 MHz | 4.9 | Bionic arm64 | 8600 | 2026 | **1256910** | 4980 | 9300 | 13.12 |
| [Khadas VIM4 (A311D2)](results/4cHh.txt) | 2200/2010 MHz | 5.4 | Jammy arm64 | 12120 | 2067 | **1254540** | 8180 | 11680 | - |
| [Khadas VIM4 (A311D2)](results/3Wvv.txt) | 2200/1970 MHz | 5.4 | Focal arm64 | 12090 | 2081 | **1253200** | 7810 | 11600 | - |
| [Honeycomb LX2 (NXP LX2160A)](results/3Y4f.txt) | 2200 MHz | 5.16 | Fedora 35 aarch64 | 30690 | 2288 | **1251710** | 5050 | 16220 | 46.09 |
| [Jetson AGX Orin](results/4ax9.txt) | 2200 MHz | 5.10 | Focal arm64 | 39450 | 3187 | **1242940** | 10600 | 30350 | 59.96 |
| [MT8395 Genio 1200](results/4Kvg.txt) | 2200/2000 MHz | 5.15 | Jammy arm64 | 18130 | 3298 | **1240850** | 14200 | 19000 | 27.60 |
| [Intel N95](results/4xwq.txt) | 3400 MHz | 5.15 | Jammy amd64 | 13070 | 3993 | **1232880** | 9710 | 8730 | 34.60 |
| [Intel N100](results/4vxM.txt) | 3400 MHz | 6.1 | Lunar amd64 | 14150 | 4073 | **1232790** | 11600 | 12270 | 36.24 |
| [Hugsun X99 (RK3399)](results/2ICt.txt) | 2088/1800 MHz | 5.9 | Focal arm64 | 7710 | 1927 | **1184306** | 2270 | 5970 | - |
| [Radxa Rock Pi 4 (RK3399)](results/21fX.txt) | 2000/1500 MHz | 5.3 | Bionic arm64 | 6910 | 1817 | **1147370** | 3660 | 8310 | 10.71 |
| [Radxa Rock Pi 4 (RK3399)](results/3Q2q.txt) | 2000/1500 MHz | 5.10 | Focal arm64 | 6900 | 1899 | **1146500** | 3430 | 8260 | - |
| [OrangePi 4 (RK3399)](results/4Kau.txt) | 2010/1510 MHz | 6.1 | Bookworm arm64 | 6880 | 1891 | **1145840** | 3490 | 8430 | - |
| [RockPro64 (RK3399)](results/2sZH.txt) | 2010/1510 MHz | 5.4 | Focal arm64 | 6920 | 1826 | **1145300** | 3700 | 8430 | 11.55 |
| [NanoPi NEO4 (RK3399)](results/3GmR.txt) | 2016/1512 MHz | 5.10 | Focal arm64 | 6970 | 1906 | **1145030** | 2450 | 6190 | 11.36 |
| [RockPro64 (RK3399)](results/2yIx.txt) | 2010/1510 MHz | 5.8 | Bullseye arm64 | 7000 | 1833 | **1144950** | 3690 | 8360 | 11.08 |
| [NanoPi NEO4 (RK3399)](results/1p3T.txt) | 2000/1500 MHz | 4.19 | Stretch arm64 | 6750 | 1814 | **1139850** | 2370 | 6110 | 8.84 |
| [Clearfog CX (NXP LX2160A)](results/4ju5.txt) | 2000 MHz | 5.10 | Focal arm64 | 25260 | 2236 | **1136690** | 4460 | 12500 | - |
| [Khadas Edge (RK3399)](results/1rYm.txt) | 2000/1500 MHz | 4.4 | Bionic arm64 | 6550 | 1721 | **1130400** | 2810 | 4860 | 10.50 |
| [BeagleBone AI-64 (TI J721E)](results/4DLw.txt) | 2000 MHz | 5.10 | Bookworm arm64 | 3470 | 1872 | **1130390** | 2660 | 8710 | - |
| [NanoPi NEO4 (RK3399)](results/1oho.txt) | 2000/1500 MHz | 4.4| Stretch arm64 | 6510 | 1703 | **1128860** | 2260 | 4770 | 8.71 |
| [NanoPi M4 (RK3399)](results/1lzP.txt) | 2000/1500 MHz | 4.19 | Stretch arm64 | 6400 | 1835 | **1128330** | 4080 | 8270 | 8.86 |
| [Khadas Edge (RK3399)](results/1uar.txt) | 2000/1500 MHz | 4.4 | Stretch arm64 | 6600 | 1703 | **1127780** | 2860 | 4880 | 8.85 |
| [NanoPC T4 (RK3399)](results/1lkG.txt) | 2000/1500 MHz | 4.4 | Stretch arm64 | 5870 | 1336 | **1124040** | 2810 | 4890 | 8.70 |
| [NanoPi NEO4 (RK3399)](results/1oim.txt) | 2000/1500 MHz | 4.4| Stretch arm64 | 6520 | 1718 | **1123190** | 2280 | 4770 | 8.83 |
| [NanoPi NEO4 (RK3399)](results/1oib.txt) | 2000/1500 MHz | 4.4| Stretch arm64 | 6030 | 1343 | **1121380** | 2230 | 4770 | 8.57 |
| [ODROID-N2 (Amlogic S922X)](results/3MuT.txt) | 2000/1900 MHz | 5.10 | Buster arm64 | 9090 | 2012 | **1085350** | 4260 | 9080 | - |
| [Apple M1 Pro](results/443N.txt) | 3030/2060 MHz | 5.18 | Gentoo 2.8 arm64 | 43800 | 5010 | **1064450** | 27110 | 71910 | 48.28 |
| [ODROID-N2 (Amlogic S922X)](results/1BsF.txt) | 1800/1900 MHz | 4.9 | Bionic arm64 | 8140 | 1669 | **1024680** | 4120 | 8610 | 11.39 |
| [NanoPC T4 (RK3399)](results/1iWU.txt) | 1800/1400 MHz | 4.17 | Stretch arm64 | 6230 | 1756 | **1023600** | 4100 | 9060 | 10.30 |
| [NanoPC T4 (RK3399)](results/1iZq.txt) | 1800/1400 MHz | 4.17 | Stretch arm64 | 6380 | 1741 | **1022600** | 4160 | 9000 | 9.36 |
| [NanoPC T4 (RK3399)](results/1iFz.txt) | 1800/1400 MHz | 4.17 | Stretch arm64 | 6250 | 1809 | **1022500** | 4100 | 9000 | 8.24 |
| [RockPro64 (RK3399)](results/1iFp.txt) | 1800/1400 MHz | 4.18 | Stretch arm64 | 6300 | 1755 | **1021500** | 3650 | 8450 | 8.20 |
| [RockPro64 (RK3399)](results/1ub9.txt) | 1800/1400 MHz | 4.4 | Stretch arm64 | 6420 | 1673 | **1018480** | 3720 | 8400 | 8.24 |
| [RockPro64 (RK3399)](results/1lBC.txt) | 1800/1400 MHz | 4.4 | Stretch arm64 | 6140 | 1580 | **1015600** | 2770 | 4850 | 8.14 |
| [RockPro64 (RK3399)](results/1iFZ.txt) | 1800/1400 MHz | 4.4 | Stretch armhf | 6250 | 1809 | **1000150** | 2000 | 4835 | - |
| [Pentium G4600](results/2jVw.txt) | 3600 MHz | 4.19 | Buster amd64 | 11810 | 4448 | **984820** | 15120 | 33380 | 21.88 |
| [ODROID-C4 (S905X3)](results/3TQ2.txt) | 2100 MHz | 5.10 | Buster arm64 | 5770 | 1679 | **981940** | 3540 | 5150 | - |
| [AMedia X96 Max+ (S905X3)](results/3QOj.txt) | 2100 MHz | 5.15 | Focal arm64 | 5270 | 1330 | **981830** | 2630 | 5150 | - |
| [ODROID-HC4 (S905X3)](results/3Na5.txt) | 2100 MHz | 5.10 | Buster arm64 | 5730 | 1672 | **980970** | 3540 | 5150 | - |
| [ODROID-M1 (RK3568)](results/4ijy.txt) | 2060 MHz | 5.18 | Bullseye arm64 | 5430 | 1567 | **961090** | 3310 | 5960 | 7.76 |
| [ODROID-C4 (S905X3)](results/2kaS.txt) | 2010 MHz | 4.9 | Focal arm64 | 5450 | 1459 | **941590** | 3310 | 6270 | 7.71 |
| [Phytium<br />FT-2000/4<br />(1 x SO-DIMM)](results/4ioj.txt) | 2600 MHz | 5.15 | Bullseye arm64 | 10020 | 2755 | **936740** | 3760 | 14540 | - |
| [Radxa ROCK 3A (RK3568)](results/40TX.txt) | 2000 MHz | 5.18 | Bullseye arm64 | 5110 | 1450 | **935920** | 3150 | 6250 | 7.58 |
| [Hlink H28K (RK3528)](results/4I93.txt) | 2000 Mhz | 5.10 | Jammy arm64 | 4680 | 1388 | **933630** | 2090 | 7650 | 6.48 |
| [Pentium N6005](results/4BtC.txt) | 3300/2000 MHz | 5.15 | Jammy amd64 | 11510 | 3369 | **923550** | 9650 | 10280 | 22.18 |
| [NanoPi M4v2 (RK3399)](results/3MAK.txt) | 2015/1510 MHz | 5.10 | Bullseye arm64 | 6680 | 1855 | **921980** | 3110 | 7640 | - |
| [NanoPi R5S (RK3568)](results/4jfZ.txt) | 1960 MHz | 6.1 | Bullseye arm64 | 5030 | 1482 | **914340** | 2990 | 5970 | 7.33 |
| [RK3568-ROC-PC](results/3Rsg.txt) | 1960 MHz | 4.19 | Bullseye arm64 | 5040 | 1424 | **912800** | 3130 | 6240 | - |
| [Macchiatobin (Armada 8040)](results/4zcm.txt) | 1600 MHz | 5.10 | Buster arm64 | 5720 | 1739 | **909420** | 4510 | 12270 | 7.91 |
| [ODROID-M1 (RK3568)](results/3Ug9.txt) | 1930 MHz | 4.19 | Focal arm64 | 5010 | 1450 | **898610** | 3070 | 6220 | 7.14 |
| [Khadas VIM3L (S905D3)](results/26Wy.txt) | 1900 MHz | 4.9 | Bionic arm64 | 5160 | 1399 | **892110** | 3670 | 6360 | 7.29 |
| [Khadas VIM3L (S905D3)](results/3Vdt.txt) | 1900 MHz | 5.16 | Bullseye arm64 | 5110 | 1403 | **890730** | 3700 | 5140 | - |
| [Ryzen R1505G](results/4HYd.txt) | 3270 MHz | 6.1 | Bookworm amd64 | 9080 | 3327 | **886980** | 10520 | 8160 | 18.14 |
| [Quartz64-A (RK3566)](results/4qJF.txt) | 1890 MHz | 6.2 | Jammy arm64 | 4980 | 1457 | **884590** | 3240 | 6100 | 6.98 |
| [Qualcomm Snapdragon 835](results/4fdD.txt) | 2360/1900 MHz | 6.1 | Jammy arm64 | 9800 | 2474 | **883330** | 9720 | 14070 | 12.58 |
| [Jetson Orin Nano](results/4vy7.txt) | 1510 MHz | 5.10 | Focal arm64 | 13650 | 2153 | **854400** | 6730 | 20240 | 20.68 |
| [Jetson Xavier AGX](results/4ebH.txt) | 2250 MHz | 4.9 | Bionic arm64 | 21590 | 2742 | **853250** | 10910 | 22520 | 26.57 |
| [Quartz64-A (RK3566)](results/3rUb.txt) | 1810 MHz | 5.13 | Buster arm64 | 4840 | 1353 | **845490** | 2980 | 7650| - |
| [MangoPi Mcore (Allwinner H616)](results/4bSf.txt) | 1800 MHz | 5.19 | Jammy arm64 | 4100 | 1218 | **840270** | 990 | 2380 | - |
| [Radxa Zero (S905Y2)](results/3wZn.txt) | 1800 MHz | 5.10 | Focal arm64 | 4610 | 1267 | **840080** | 1600 | 5370 | - |
| [PineH64 (Allwinner H6)](results/26Ph.txt) | 1800 MHz | 5.4 | Buster arm64 | 4710 | 1293 | **839870** | 1420 | 5560 | 7.10 |
| [Radxa Zero (S905Y2)](results/3PlT.txt) | 1800 MHz | 5.10 | Buster arm64 | 4570 | 1373 | **839080** | 1610 | 5250 | 6.82 |
| [Radxa Zero (S905Y2)](results/3JCm.txt) | 1800 MHz | 5.10 | Bullseye arm64 | 4580 | 1353 | **838360** | 1600 | 5360 | 7.13 |
| [i.MX8MPlus EVK](results/4hx0.txt) | 1800 MHz | 5.15 | Focal arm64 | 4990 | 1348 | **837680** | 2740 | 12420 | 7.02 |
| [PineH64 (Allwinner H6)](results/1jEr.txt) | 1800 MHz | 4.18 | Stretch arm64 | 4650 | 1274 | **836900** | 1380 | 5530 | 5.62 |
| [Phytium D2000<br />(2 x SO-DIMM)](results/446h.txt) | 2300 MHz | 5.19 | Jammy arm64 | 16670 | 2252 | **828130** | 3480 | 16110 | - |
| [Phytium D2000<br />(1 x SO-DIMM)](results/445T.txt) | 2300 MHz | 5.19 | Jammy arm64 | 16390 | 2220 | **827090** | 2820 | 6490 | - |
| [Celeron N5105](results/3Qf7.txt) | 2900/2000 MHz | 5.13 | Focal amd64 | 11450 | 3059 | **811760** | 7710 | 9290 | 21.79 |
| [Celeron N4500](results/3HUU.txt) | 2800/1100 MHz | 5.13 | Impish amd64 | 6300 | 3091 | **783840** | 8100 | 8350 | - |
| [Celeron N5100](results/3IlQ.txt) | 2800/1100 MHz | 5.13 | Focal amd64 | 10550 | 3088 | **783800** | 7750 | 8090 | 19.22 |
| [Celeron N4020](results/4vNB.txt) | 2800 MHz | 5.15 | Bookworm amd64 | 4680 | 2577 | **780770** | 5480 | 5390 | - |
| [Pentium J5005](results/21rE.txt) | 2700/1500 MHz | 5.0 | Bionic amd64 | 9230 | 2455 | **778360** | 5530 | 7130 | 20.74 |
| [Celeron J4125](results/4hau.txt) | 2700/2000 MHz | 5.15 | Jammy amd64 | 7620 | 2367 | **751360** | 5110 | 5960 | 18.30 |
| [Nintendo Switch (Tegra X1)](results/3Di2.txt) | 2060 MHz | 4.9 | Bionic arm64 | 6720 | 1901 | **746680** | 2370 | 3670 | 9.25 |
| [AMD Seattle (Opteron A1100)](results/4Kqn.txt) | 2000 MHz | 4.15 | Bionic arm64 | 14080 | 2006 | **720710** | 3020 | 9530 | - |
| [Jetson Nano](results/3Ufc.txt) | 2000 MHz | 4.9 | Bionic arm64 | 6260 | 1977 | **717500** | 4100 | 11760 | 8.72 |
| [Jetson Xavier NX](results/3YWp.txt) | 1890 MHz | 4.9 | Bionic arm64 | 13230 | 2201 | **706280** | 9190 | 18480 | - |
| [Orange Pi Zero 2W (Allwinner H618)](results/4Hd0.txt) | 1510 MHz | 6.1 | Jammy arm64 | 3920 | 1167 | **705660** | 1510 | 6010 | 6.02 |
| [Orange Pi Zero 3 (Allwinner H618)](results/4CPF.txt) | 1510 MHz | 6.1 | Jammy arm64 | 4020 | 1165 | **705330** | 1510 | 6010 | 6.02 |
| [Orange Pi Zero 2 (Allwinner H616)](results/4knM.txt) | 1510 MHz | 4.9 | Buster arm64 | 3550 | 1067 | **703300** | 1190 | 2820 | 5.01 |
| [Ryzen R1606G](results/2tQQ.txt) | 2600/1400 MHz | 5.4 | Focal amd64 | 7970 | 2854 | **700780** | 8230 | 5970 | 16.45 |
| [Celeron J4105](results/1qal.txt) | 2400/1500 MHz | 4.15 | Bionic amd64 | 9020 | 2290 | **697100** | 5500 | 7410 | 19.07 |
| [Celeron J4105](results/1qb0.txt) | 2400/1500 MHz | 4.15 | Bionic amd64 | 8960 | 2274 | **697080** | 5620 | 7650 | 19.13 |
| [HummingBoard Pulse i.MX8M Quad](results/27FC.txt) | 1500 MHz | 4.19 | Buster arm64 | 4330 | 1201 | **695540** | 2230 | 9900 | - |
| [Celeron N4100](results/1uTS.txt) | 2300/1100 MHz | 4.15 | Bionic amd64 | 8510 | 2222 | **669350** | 4750 | 5240 | 18.33 |
| [Khadas VIM1 (Amlogic S905X)](results/4bee.txt) | 1415 MHz | 5.1 | Buster arm64 | 3860 | 1136 | **660160** | 1940 | 5900 | - |
| [Khadas VIM2 (Amlogic S912)](results/1iJ7.txt) | 1415/1000 MHz | 4.17 | Bionic arm64 | 5450 | 993 | **659600** | 1920 | 5920 | 8.59 |
| [Libre Computer AML-S912-PC](results/40cj.txt) | 1415/1000 MHz | 5.15 | Bullseye arm64 | 5980 | 1012 | **659290** | 1650 | 5170 | - |
| [Le Potato (Amlogic S905X)](results/1iSQ.txt) | 1410 MHz | 4.18 | Stretch arm64 | 3780 | 1057 | **657200** | 1810 | 5730 | 3.92 |
| [NanoPi Fire3 (Nexell S5P6818)](results/1jjm.txt) | 1400 MHz | 4.14 | Bionic arm64 | 7440 | 1052 | **653000** | 1560 | 4600 | 10.96 |
| [NanoPi Fire3 (Nexell S5P6818)](results/3ZxU.txt) | 1400 MHz | 4.14 | Focal arm64 | 7350 | 1093 | **652640** | 1530 | 4590 | 11.18 |
| [NanoPC T3+ (Nexell S5P6818)](results/1iRJ.txt) | 1400 MHz | 4.14 | Bionic arm64 | 7480 | 1053 | **652600** | 1440 | 4540 | 10.99 |
| [BPi M4 (RTD1395)](results/1Dt1.txt) | 1400 MHz | 4.9 | Bionic arm64 | 3500 | - | **651460** | 1010 | 4360 | 5.48 |
| [NanoPC T3+ (Nexell S5P6818)](results/1iyp.txt) | 1400 MHz | 4.4 | Xenial armhf | 6400 | 943 | **651000** | 1650 | 3700 | - |
| [NanoPi Fire3 (Nexell S5P6818)](results/1jiU.txt) | 1380 MHz | 4.14 | Stretch arm64 | 7420 | 1038 | **645400** | 1520 | 4570 | 8.53 |
| [RK3318 BOX](results/4kor.txt) | 1390 MHz | 6.0 | Jammy arm64 | 3200 | 867 | **644750** | 700 | 2460 | - |
| [Rock64 (RK3328)](results/1iYK.txt) | 1400 MHz | 4.4 | Stretch arm64 | 3580 | 1032 | **644380** | 1330 | 5680 | 4.63 |
| [Rock64 (RK3328)](results/1iFm.txt) | 1400 MHz | 4.4 | Stretch arm64 | 3610 | 1034 | **644250** | 1330 | 5700 | 3.85 |
| [Renegade (RK3328)](results/1iFx.txt) | 1400 MHz | 4.4 | Stretch arm64 | 3710 | 1069 | **644200** | 1565 | 7435 | 3.92 |
| [Rock64 (RK3328)](results/1iZj.txt) | 1400 MHz | 4.4 | Stretch arm64 | 3590 | 1030 | **643700** | 1320 | 5640 | 4.40 |
| [Nintendo Switch (Tegra X1)](results/1Rnj.txt) | 1780 MHz | 4.9 | Fedora 30 arm-64 | 6170 | 1719 | **642670** | 2500 | 3570 | - |
| [NanoPi K1 Plus (Allwinner H5)](results/3N7H.txt) | 1370 MHz | 5.10 | Focal arm64 | 3520 | 1022 | **638880** | 1070 | 3680 | 5.50 |
| [Orange Pi Prime (Allwinner H5)](results/2kTH.txt) | 1370 MHz | 5.4 | Buster | 3590 | 984 | **637980** | 1180 | 3540 | - |
| [Orange Pi PC 2 (Allwinner H5)](results/3MQJ.txt) | 1370 MHz | 5.10 | Focal arm64 | 3500 | 1023 | **637410** | 1070 | 3680 | - |
| [Rock64 (RK3328)](results/1iwz.txt) | 1400 MHz | 4.4 | Stretch armhf | 3620 | 1006 | **624000** | 1430 | 3620 | - |
| [Rock64 (RK3328)](results/1iH4.txt) | 1300 MHz | 4.18 | Bionic arm64 | 3530 | 996 | **605250** | 1340 | 5770 | 4.65 |
| [Rock64 (RK3328)](results/1iHB.txt) | 1300 MHz | 4.18 | Stretch arm64 | 3560 | 1002 | **603800** | 1340 | 5770 | 3.80 |
| [Rock64 (RK3328)](results/1iGW.txt) | 1300 MHz | 4.4 | Bionic arm64 | 3410 | 945 | **601200** | 1310 | 5680 | 4.46 |
| [Rock64 (RK3328)](results/1iHo.txt) | 1300 MHz | 4.4 | Stretch arm64 | 3430 | 952 | **601000** | 1350 | 5680 | 3.64 |
| [Marvell PXA1908](results/46hs.txt) | 1245 MHz | 3.14 | Bullseye arm64 | 3180 | 951 | **581840** | 740 | 2220 | - |
| [EspressoBin (Armada 3720)](results/1lCe.txt) | 1200 MHz | 4.18 | Stretch arm64 | 1630 | 869 | **544240** | 1000 | 2400 | 1.82 |
| [Jetson Nano](results/4rLX.txt) | 1480 MHz | 4.9 | Bullseye arm64 | 5260 | 1578 | **531940** | 3730 | 8870 | - |
| [Celeron 5205U](results/4eiM.txt) | 1900 MHz | 5.15 | Jammy amd64 | 4060 | 2171 | **521090** | 7350 | 16020 | 11.20 |
| [Teres-I<br />(Allwinner A64)](results/1tJg.txt) | 1050 MHz | 4.19 | Stretch arm64 | 2785 | 780 | **491590** | 1080 | 2820 | - |
| [Pentium J4205](results/1m5t.txt) | 2560/1500 MHz | 4.17 | Stretch amd64 | 7570 | 2146 | **480640** | 5070 | 5170 | 18.82 |
| [Pentium N4200](results/1ngq.txt) | 2560/1100 MHz | 4.14 | Bionic amd64 | 7469 | 1976 | **468008** | 4682 | 4997 | 18.75 |
| [Celeron N3350](results/4rJj.txt) | 2400 MHz | 6.0 | Bullseye amd64 | 3810 | 2034 | **446170** | 5190 | 5700 | - |
| [Khadas VIM1S (S905Y4)](results/4bbv.txt) | 2000 MHz | 5.4 | Jammy arm64 | 4000 | 1148 | **436540** | 1970 | 7530 | - |
| [Celeron J3455](results/1m5p.txt) | 2300/1500 MHz | 4.17 | Stretch amd64 | 7000 | 2037 | **429660** | 4090 | 4050 | 17.26 |
| [Atom E3950](results/4dd5.txt) | 2000 MHz | 5.15 | Jammy amd64 | 6440 | 1636 | **374800** | 4400 | 4840 | - |
| [EspressoBin (Armada 3720)](results/1kt2.txt) | 800 MHz | 4.17 | Stretch arm64 | 1138 | 636 | **368330** | 1040 | 2490 | 1.23 |
| [H270-T70<br />(2 x ThunderX CN8890)](results/3N5c.txt) | 2000 Mhz | 5.16 | Sid arm64 | 107180 | 1826 | **340750** | 4180 | 17130 | - |
| [x7-Z8700](results/4iDX.txt) | 2400 MHz | 5.15 | Bullseye amd64 | 6580 | 1784 | **296680** | 3510 | 3580 | - |
| [Radxa Rock Pi S (RK3308)](results/4sNe.txt) | 1300 MHz | 6.1 | Jammy arm64 | 2540 | 732 | **282030** | 820 | 1870 | - |
| [x5-Z8350](results/2Jdb.txt) | 1920/1680 MHz | 5.4 | Focal amd64 | 4790 | 1454 | **237230** | 3170 | 2960 | 9.38 |
| [Atom Z3735F](results/4r54.txt) | 1830 MHz | 5.15 | Jammy amd64 | 4510 | 1437 | **227900** | 3020 | 2780 | - |
| [x5-Z8300](results/4j4o.txt) | 1840 MHz | 5.15 | Jammy amd64 | 4430 | 1368 | **227030** | 2270 | 2380 | 8.84 |
| [x5-Z8350](results/1HnC.txt) | 1920/1680 MHz | 4.15 | Bionic amd64 | 4710 | 1272 | **207640** | 2740 | 3140 | - |
| [Atom E3826](results/44pd.txt) | 1460 MHz | 5.18 | Jammy amd64 | 2140 | 1112 | **182190** | 2840 | 2760 | - |
| [x5-Z8300](results/1lgD.txt) | 1420 MHz | 4.9 | Stretch amd64 | 3900 | 950 | **178010** | 2380 | 2380 | 7.81 |
| [Atom E3825](results/4kFQ.txt) | 1330 MHz | 5.10 | Bullseye amd64 | 1950 | 1109 | **165840** | 2890 | 2890 | - |
| [Loongson-3A5000-HV](results/4dzX.txt) | 2500 MHz | 4.19 | Loongnix 20 loongarch64 | 11120 | 2990 | **116900** | 6930 | 19170 | - |
| [Athlon II X3 420e](results/4eOo.txt) | 2600 MHz | 4.19 | Buster amd64 | 4780 | 2566 | **98840** | 4120 | 3870 | - |
| [Raspberry Pi 4 B (BCM2711)](results/3VME.txt) | 1800 MHz | 5.15 | Jammy armhf | 6300 | 1844 | **82750** | 1190 | 3110 | - |
| [Raspberry Pi 400 (BCM2711)](results/2Cyi.txt) | 1800 MHz | 5.4 | Raspberry Pi OS Buster | 6550 | 1903 | **77890** | 2680 | 3110 | - |
| [Raspberry Pi 4 B (BCM2711)](results/3Gia.txt) | 1800 MHz | 5.10 | Raspberry Pi OS Buster | 6550 | 1897 | **77830** | 2780 | 3080 | - |
| [Raspberry Pi 4 B (BCM2711)](results/3N94.txt) | 1800 MHz | 5.10 | Raspberry Pi OS Bullseye | 5940 | 1738 | **77670** | 2310 | 2690 | - |
| [ODROID-XU4 (Exynos 5422)](results/1iWL.txt) | 2000/1400 MHz | 4.9 | Stretch armhf | 6400 | 1622 | **72075** | 2230 | 4850 | - |
| [ODROID-XU4 (Exynos 5422)](results/3GnC.txt) | 2000/1400 MHz | 5.4 | Focal armhf | 8980 | 1604 | **72020** | 2280 | 4910 | - |
| [ODROID-XU4 (Exynos 5422)](results/1ixL.txt) | 1900/1400 MHz | 3.10 | Jessie armhf | 6750 | - | **68200** | 2200 | 4800 | - |
| [Tinkerboard (RK3288)](results/3X9q.txt) | 1800 MHz | 5.10 | Buster armhf | 5770 | 1713 | **67060** | 1540 | 4110 | - |
| [Tinkerboard (RK3288)](results/1iSX.txt) | 1730 MHz | 4.14 | Stretch armhf | 5350 | 1563 | **66600** | 1480 | 3900 | - |
| [Tinkerboard (RK3288)](results/3Lir.txt) | 1800 MHz | 4.4 | Buster armhf | 5440 | 1693 | **66300** | 1340 | 3510 | - |
| [TinkerBoard S (RK3288)](results/4vfU.txt) | 1800 MHz | 6.1 | Jammy armhf | 5560 | 1672 | **65800** | 1540 | 4150 | - |
| [Raspberry Pi 4 B (BCM2711)](results/3EgS.txt) | 1500 MHz | 5.10 | Raspberry Pi OS Buster | 5750 | 1661 | **64930** | 2550 | 3430 | - |
| [Raspberry Pi 4 B (BCM2711)](results/1MFf.txt) | 1500 MHz | 4.19 | Raspbian Buster | 5500 | 1606 | **64860** | 2460 | 3170 | - |
| [NanoPi K2 (Amlogic S905)](results/3Qve.txt) | 1480 MHz | 5.10 | Bullseye arm64 | 3880 | 1154 | **51490** | 1850 | 3790 | - |
| [NanoPi K2 (Amlogic S905)](results/1iT1.txt) | 1480 MHz | 4.14 | Stretch arm64 | 3850 | 1095 | **50370** | 1660 | 3870 | 4.61 |
| [ODROID-C2 (Amlogic S905)](results/1ixI.txt) | 1750 MHz | 3.14 | Xenial arm64 | 4070 | 1128 | **48500** | 1750 | 3100 | - |
| [Clearfog A1<br />(Armada 388)](results/4d1U.txt) | 1600 MHz | 5.15 | Bullseye armhf | 2230 | 1239 | **44080** | 910 | 5060 | - |
| [Lichee Pi 4A (T-Head TH1520)](results/4xYE.txt) | 1990 MHz | 5.10 | Bookworm riscv64 | 5260 | 1592 | **43820** | 4350 | 14760 | - |
| [Milk-V Pioneer (SG2042)](results/4wYE.txt) | 2000 MHz | 6.1 | Kinetic riscv64 | 59820 | 1622 | **43500** | 3620 | 4760 | - |
| [Ugoos UT2 (RK3188)](results/408h.txt) | 1560 MHz | 5.10 | Jammy armhf | 3320 | 994 | **43250** | 320 | 2020 | - |
| [Tronsmart S82 (Amlogic S802)](results/41ML.txt) | 1600 MHz | 5.14 | Focal armhf | 3640 | 1114 | **43150** | 500 | 3200 | - |
| [Raspberry Pi 3 B+ (BCM2837B0)](results/1iI5.txt) | original | 4.9 | Raspbian Stretch | 3600 | 1076 | **42700** | 1230 | 1640 | - |
| [Raspberry Pi 3 B+ (BCM2837B0)](results/1isD.txt) | with fan | 4.14 | Raspbian Stretch | 3670 | 1046 | **42600** | 1120 | 1600 | - |
| [Tronsmart MXIII Plus (S812)](results/3S5U.txt) | 1560 MHz | 5.10 | Buster armhf | 3880 | 1113 | **42570** | 1470 | 3430 | - |
| [Helios4<br />(Armada 388)](results/1jCy.txt) | 1600 MHz | 4.14 | Stretch armhf | 2210 | 1215 | **42500 &ast;98560** | 910 | 4840 | - |
| [Raspberry Pi 3 B+ (BCM2837B0)](results/1iGz.txt) | OC/normal | 4.14 | Raspbian Stretch | 3130 | 843 | **36620** | 1230 | 1780 | - |
| [Raspberry Pi 3 B+ (BCM2837B0)](results/1ism.txt) | normal | 4.14 | Raspbian Stretch | 3240 | 914 | **36600** | 1130 | 1530 | - |
| [Raspberry Pi 3 B+ (BCM2837B0)](results/1iGM.txt) | normal | 4.14 | Raspbian Stretch | 3040 | 856 | **36600** | 1050 | 1500 | - |
| [Raspberry Pi 3 B+ (BCM2837B0)](results/1iH0.txt) | UV/normal | 4.14 | Raspbian Stretch | 2100 | 856 | **36400** | 1040 | 1460 | - |
| [Raspberry Pi Zero 2 (RP3A0)](results/3DeL.txt) | 1200 MHz | 5.10 | Raspberry Pi OS Buster | 3640 | 1007 | **36300** | 1320 | 1790 | - |
| [Raspberry Pi 4 B (BCM2711)](results/3OBF.txt) | 1800 MHz | 5.10 | Raspberry Pi OS Bullseye arm64 | 5790 | 1769 | **36260** | 2330 | 3120 | 8.74 |
| [Raspberry Pi 4 B (BCM2711)](results/3InF.txt) | 1800 MHz | 5.15 | Armbian Jammy arm64 | 5640 | 1752 | **36260** | 2580 | 3110 | - |
| [Raspberry Pi 4 B (BCM2711)](results/3F9C.txt) | 1800 MHz | 5.10 | Raspberry Pi OS Buster arm64 | 5760 | 1741 | **36240** | 2240 | 3120 | 9.46 |
| [Raspberry Pi 3 B (BCM2837)](results/4hOP.txt) | 1200 MHz | 5.15 | Raspbian Sid | 2970 | 977 | **36230** | 1110 | 1700 | 2.89 |
| [Celeron J1900](results/4hKV.txt) | 2415/1333 MHz | 5.4 | Focal amd64 | 6560 | 1806 | **34900** | 3780 | 3390 | - |
| [SBC2D70 (SSD202D)](results/3N1U.txt) | 1700 MHz | 5.16 | Sid armhf | 1960 | 1094 | **33120** | 770 | 3190 | - |
| [Akaso M8S (S812)](results/3R3N.txt) | 1200 MHz | 5.10 | Buster armhf | 3050 | 885 | **32120** | 1160 | 3330 | - |
| [Celeron N2830](results/4pEc.txt) | 2160 MHz | 5.19 | Jammy amd64 | 2760 | 1664 | **31270** | 3780 | 3520 | 6.10 |
| [Celeron N2807](results/4z3s.txt) | 2165 MHz | 5.10 | Bullseye) amd64 | 3070 | 1766 | **31250** | 3600 | 3110 | 6.09 |
| [Raspberry Pi Zero 2 (RP3A0)](results/3E85.txt) | 1000 MHz | 5.10 | Raspberry Pi OS Buster | 3030 | 838 | **29860** | 1300 | 1570 | - |
| [ODROID-C1 (Amlogic S805)](results/4eg5.txt) | 1500 MHz | 5.19 | Jammy armhf | 3010 | 878 | **29260** | 390 | 2910 | - |
| [TRONFY MXQ (Amlogic S805)](results/3MiR.txt) | 1536 MHz | 5.10 | Focal armhf | 3100 | 897 | **29080** | 980 | 2990 | - |
| [Lime A10 (Allwinner A10)](results/1j1L.txt) | 910 MHz | 4.14 | Stretch armhf | 550 | 550 | **28250** | 440 | 1300 | - |
| [AMD E-450 APU](results/4hwl.txt) | 1650 MHz | 5.15 | Jammy amd64 | 2430 | 1258 | **27450** | 1710 | 1740 | - |
| [Cubox-i4<br />(NXP i.MX6)](results/4132.txt) | 980 MHz | 5.15 | Jammy armhf | 2360 | 657 | **27000** | 340 | 340 | - |
| [T-HEAD C910 RVB-ICE](results/41AB.txt) | 1200 MHz | 5.10 | Sid riscv64 | 1760 | 1007 | **26930** | 3340 | 6470 | - |
| [NanoPi M1 Plus (Allwinner H3)](results/3N2z.txt) | 1370 MHz | 4.19 | Bionic armhf | 3030 | 881 | **26660** | 830 | 3450 | - |
| [Orange Pi PC+ (Allwinner H3)](results/3MQV.txt) | 1370 MHz | 5.10 | Focal armhf | 3060 | 879 | **26590** | 890 | 3450 | - |
| [MT6580 K9M1](results/466y.txt) | 1300 MHz | 5.19 | Sid armhf | 2930 | 860 | **25300** | 1250 | 3300 | - |
| [BPi R2 (MT7623)](results/4dO7.txt) | 1300 MHz | 4.19 | Focal armhf | 2990 | 854 | **25260** | 1550 | 3220 | - |
| [Orange Pi Plus 2 (Allwinner H3)](results/1iX4.txt) | 1300 MHz | 4.14 | Stretch armhf | 2890 | 812 | **25250** | 830 | 3240 | - |
| [VisionFive V2 (JH7110)](results/4xOY.txt) | 1500 MHz | 5.15 | Sid riscv64 | 4180 | 1197 | **25080** | 880 | 770 | - |
| [Milk-V Mars CM (JH7110)](results/4K7E.txt) | 1500 MHz | 5.15 | Bookworm riscv64 | 4110 | 1195 | **25070** | 930 | 830 | - |
| [Star64 (JH7110)](results/4tjq.txt) | 1500 MHz | 5.15 | Sid riscv64 | 3970 | 1175 | **24990** | 820 | 770 | - |
| [BPi M2U (Allwinner R40)](results/4kmM.txt) | 1200 MHz | 6.0 | Bullseye armhf | 2690 | 767 | **23320** | 780 | 3010 | - |
| [RK3228A TV Box](results/3M9F.txt) | 1200 MHz | 4.4 | Buster armhf | 2310 | 710 | **23070** | 410 | 1230 | - |
| [Atom N2800](results/4nt8.txt) | 1860 MHz | 5.15 | Bullseye amd64 | 2970 | 1006 | **21780** | 2050 | 1570 | - |
| [Atom N270](results/461n.txt) | 1600 MHz | 4.19 | Buster i386 | 1220 | 824 | **18760** | 1420 | 2840 | - |
| [Cubietruck (Allwinner A20)](results/3Naw.txt) | 960 MHz | 5.10 | Bullseye armhf | 1030 | 541 | **18640** | 440 | 2010 | - |
| [Banana Pi (Allwinner A20)](results/3PLr.txt) | 960 MHz | 5.10 | Bullseye armhf | 1040 | 542 | **18640** | 440 | 2020 | - |
| [Olimex A20-Lime2](results/4rRV.txt) | 960 MHz | 5.10 | Bullseye armhf | 1080 | 589 | **18630** | 430 | 2020 | 0.87 |
| [Raspberry Pi Zero 2 (RP3A0)](results/3Dfo.txt) | 600 MHz | 5.10 | Raspberry Pi OS Buster | 1900 | 529 | **18150** | 1040 | 1130 | - |
| [Raspberry Pi 2 B+ (BCM2836)](results/1iFf.txt) | 900 MHz | 4.14 | Debian Stretch | 2070 | 592 | **17450** | 615 | 1175 | - |
| [Raspberry Pi Zero (BCM2835)](results/3Njz.txt) | 1000 MHz | 5.10 | Bullseye armv6l/armhf | 460 | 460 | **17060** | 430 | 1670 | - |
| [Raspberry Pi B (BCM2835)](results/4vVG.txt) | 1000 MHz | 6.1 | Raspberry Pi OS Bullseye | 480 | 481 | **16900** | 490 | 2220 | - |
| [Raspberry Pi Zero (BCM2835)](results/1niO.txt) | 1000 MHz | 4.14 | Raspbian Stretch | 450 | 450 | **16820** | 400 | 1590 | - |
| [Raspberry Pi 2 B+ (BCM2836)](results/3MGs.txt) | 900 MHz | 5.10 | Raspberry Pi OS Bullseye | 2150 | 620 | **16500** | 1000 | 1180 | - |
| [Raspberry Pi B (BCM2835)](results/3MGN.txt) | 700 MHz | 5.10 | Raspberry Pi OS Bullseye | 320 | 320 | **11630** | 360 | 1420 | - |
| [ClockworkPi R-01 (Allwinner D1)](results/40BJ.txt) | 1000 MHz | 5.4 | Focal riscv64 | 450 | 450 | **9040** | 1220 | 2640 | - |
| [Kendryte K510](results/41Qa.txt) | 790 MHz | 4.17 | Sid riscv64 | 690 | 402 | **7410** | 280 | 440 | - |

[(back to top of the page)](#sbc-bench-results-sorted)

## memcpy

| Device / details | Clockspeed | Kernel | Distro | 7-zip multi | 7-zip single | AES | *memcpy* | memset | kH/s |
| ----- | :--------: | :----: | :----: | ----: | ------: | ------: | -----: | -----: | ---: |
| [Apple M1 Pro](results/443N.txt) | 3030/2060 MHz | 5.18 | Gentoo 2.8 arm64 | 43800 | 5010 | 1064450 | **27110** | 71910 | 48.28 |
| [Qualcomm Snapdragon 8cx Gen 3 (WSL2)](results/4kEp.txt) | 2980/? MHz | 5.15 | Jammy arm64 | 33600 | 4789 | 1679480 | **21010** | 41540 | 50.65 |
| [Qualcomm Snapdragon 8cx Gen 3](results/4xwT.txt) | 3000/2440 MHz | 6.3 | Lunar arm64 | 35370 | 4312 | 1686160 | **17500** | 41780 | 42.76 |
| [Pentium G4600](results/2jVw.txt) | 3600 MHz | 4.19 | Buster amd64 | 11810 | 4448 | 984820 | **15120** | 33380 | 21.88 |
| [Qualcomm QRB5165](results/49kx.txt) | 2840/2410/1790 MHz | 4.19 | Focal arm64 | 18860 | 3898 | 1598490 | **14470** | 23910 | 25.56 |
| [MT8395 Genio 1200](results/4Kvg.txt) | 2200/2000 MHz | 5.15 | Jammy arm64 | 18130 | 3298 | 1240850 | **14200** | 19000 | 27.60 |
| [Huaqin P6410<br />(2 x Ampere Altra Max)](results/4kiu.txt) | 3000 MHz | 5.4 | Focal arm64 | 430860 | 4211 | 1710010 | **13310** | 47970 | - |
| [Orange Pi 5 (RK3588)](results/4D0a.txt) | 2400/1800 MHz | 5.10 | Jammy arm64 | 16780 | 2689 | 1366590 | **12800** | 29900 | - |
| [Ampere Altra Q80-26](results/4zkJ.txt) | 2600 MHz | 5.15 | Jammy arm64 | 214390 | 3748 | 1482190 | **11685** | 41560 | 316.50 |
| [Intel N100](results/4vxM.txt) | 3400 MHz | 6.1 | Lunar amd64 | 14150 | 4073 | 1232790 | **11600** | 12270 | 36.24 |
| [Hetzner CAX11 (Ampere Altra)](results/4HdL.txt) | 3000 MHz | 5.15 | Jammy arm64 | 8060 | 3842 | 1705600 | **11250** | 47670 | 11.44 |
| [Jetson Xavier AGX](results/4ebH.txt) | 2250 MHz | 4.9 | Bionic arm64 | 21590 | 2742 | 853250 | **10910** | 22520 | 26.57 |
| [Khadas Edge2 (RK3588s)](results/4a5U.txt) | 2260/1800 MHz | 5.10 | Jammy arm64 | 16470 | 3096 | 1287490 | **10860** | 29110 | - |
| [Radxa ROCK 5B (RK3588)](results/41BH.txt) | 2350/1830 MHz | 5.10 | Focal arm64 | 16450 | 3146 | 1337540 | **10830** | 29220 | 25.31 |
| [Jetson AGX Orin](results/4ax9.txt) | 2200 MHz | 5.10 | Focal arm64 | 39450 | 3187 | 1242940 | **10600** | 30350 | 59.96 |
| [Ryzen R1505G](results/4HYd.txt) | 3270 MHz | 6.1 | Bookworm amd64 | 9080 | 3327 | 886980 | **10520** | 8160 | 18.14 |
| [Ampere Altra M96-28](results/4zGI.txt) | 2800 MHz | 5.15 | Jammy arm64 | 249380 | 3858 | 1596110 | **10130** | 44750 | - |
| [Intel i3-N305](results/4qpr.txt) | 3800 MHz | 5.19 | Jammy amd64 | 20000 | 4398 | 1377280 | **9950** | 8990 | 41.43 |
| [Qualcomm Snapdragon 835](results/4fdD.txt) | 2360/1900 MHz | 6.1 | Jammy arm64 | 9800 | 2474 | 883330 | **9720** | 14070 | 12.58 |
| [Intel N95](results/4xwq.txt) | 3400 MHz | 5.15 | Jammy amd64 | 13070 | 3993 | 1232880 | **9710** | 8730 | 34.60 |
| [Pentium N6005](results/4BtC.txt) | 3300/2000 MHz | 5.15 | Jammy amd64 | 11510 | 3369 | 923550 | **9650** | 10280 | 22.18 |
| [Jetson Xavier NX](results/3YWp.txt) | 1890 MHz | 4.9 | Bionic arm64 | 13230 | 2201 | 706280 | **9190** | 18480 | - |
| [Ryzen R1606G](results/2tQQ.txt) | 2600/1400 MHz | 5.4 | Focal amd64 | 7970 | 2854 | 700780 | **8230** | 5970 | 16.45 |
| [Khadas VIM4 (A311D2)](results/4cHh.txt) | 2200/2010 MHz | 5.4 | Jammy arm64 | 12120 | 2067 | 1254540 | **8180** | 11680 | - |
| [Celeron N4500](results/3HUU.txt) | 2800/1100 MHz | 5.13 | Impish amd64 | 6300 | 3091 | 783840 | **8100** | 8350 | - |
| [Khadas VIM4 (A311D2)](results/3Wvv.txt) | 2200/1970 MHz | 5.4 | Focal arm64 | 12090 | 2081 | 1253200 | **7810** | 11600 | - |
| [Celeron N5100](results/3IlQ.txt) | 2800/1100 MHz | 5.13 | Focal amd64 | 10550 | 3088 | 783800 | **7750** | 8090 | 19.22 |
| [Celeron N5105](results/3Qf7.txt) | 2900/2000 MHz | 5.13 | Focal amd64 | 11450 | 3059 | 811760 | **7710** | 9290 | 21.79 |
| [Celeron 5205U](results/4eiM.txt) | 1900 MHz | 5.15 | Jammy amd64 | 4060 | 2171 | 521090 | **7350** | 16020 | 11.20 |
| [Loongson-3A5000-HV](results/4dzX.txt) | 2500 MHz | 4.19 | Loongnix 20 loongarch64 | 11120 | 2990 | 116900 | **6930** | 19170 | - |
| [Jetson Orin Nano](results/4vy7.txt) | 1510 MHz | 5.10 | Focal arm64 | 13650 | 2153 | 854400 | **6730** | 20240 | 20.68 |
| [Qualcomm Snapdragon 7c](results/4Lyf.txt) | 2550/1800 MHz | 6.6 | Bookworm arm64 | 13040 | 3113 | 1455700 | **6710** | 14880 | - |
| [Celeron J4105](results/1qb0.txt) | 2400/1500 MHz | 4.15 | Bionic amd64 | 8960 | 2274 | 697080 | **5620** | 7650 | 19.13 |
| [Pentium J5005](results/21rE.txt) | 2700/1500 MHz | 5.0 | Bionic amd64 | 9230 | 2455 | 778360 | **5530** | 7130 | 20.74 |
| [Celeron J4105](results/1qal.txt) | 2400/1500 MHz | 4.15 | Bionic amd64 | 9020 | 2290 | 697100 | **5500** | 7410 | 19.07 |
| [Celeron N4020](results/4vNB.txt) | 2800 MHz | 5.15 | Bookworm amd64 | 4680 | 2577 | 780770 | **5480** | 5390 | - |
| [Raspberry Pi 5 B (BCM2712)](results/4HDw.txt) | 2400 MHz | 6.1 | Bookworm arm64 | 10950 | 3160 | 1367990 | **5260** | 11520 | 15.42 |
| [Celeron N3350](results/4rJj.txt) | 2400 MHz | 6.0 | Bullseye amd64 | 3810 | 2034 | 446170 | **5190** | 5700 | - |
| [Celeron J4125](results/4hau.txt) | 2700/2000 MHz | 5.15 | Jammy amd64 | 7620 | 2367 | 751360 | **5110** | 5960 | 18.30 |
| [Khadas VIM3 (Amlogic A311D)](results/4o1A.txt) | 2400/2015 MHz | 6.0 | Bullseye arm64 | 9650 | 2379 | 1366300 | **5080** | 9240 | - |
| [Pentium J4205](results/1m5t.txt) | 2560/1500 MHz | 4.17 | Stretch amd64 | 7570 | 2146 | 480640 | **5070** | 5170 | 18.82 |
| [Honeycomb LX2 (NXP LX2160A)](results/3Y4f.txt) | 2200 MHz | 5.16 | Fedora 35 aarch64 | 30690 | 2288 | 1251710 | **5050** | 16220 | 46.09 |
| [Khadas VIM3 (Amlogic A311D)](results/1MFD.txt) | 2200/1800 MHz | 4.9 | Bionic arm64 | 8600 | 2026 | 1256910 | **4980** | 9300 | 13.12 |
| [Raspberry Pi 5 B (BCM2712)](results/4I1w.txt) | 3000 MHz | 6.1 | Bookworm arm64 | 12740 | 3747 | 1710050 | **4940** | 12640 | - |
| [Khadas VIM3 (Amlogic A311D)](results/3R2Z.txt) | 2400/2015 MHz | 5.10 | Bullseye arm64 | 9650 | 2376 | 1366350 | **4850** | 7380 | - |
| [Celeron N4100](results/1uTS.txt) | 2300/1100 MHz | 4.15 | Bionic amd64 | 8510 | 2222 | 669350 | **4750** | 5240 | 18.33 |
| [Pentium N4200](results/1ngq.txt) | 2560/1100 MHz | 4.14 | Bionic amd64 | 7469 | 1976 | 468008 | **4682** | 4997 | 18.75 |
| [Macchiatobin (Armada 8040)](results/4zcm.txt) | 1600 MHz | 5.10 | Buster arm64 | 5720 | 1739 | 909420 | **4510** | 12270 | 7.91 |
| [Clearfog CX (NXP LX2160A)](results/4ju5.txt) | 2000 MHz | 5.10 | Focal arm64 | 25260 | 2236 | 1136690 | **4460** | 12500 | - |
| [Atom E3950](results/4dd5.txt) | 2000 MHz | 5.15 | Jammy amd64 | 6440 | 1636 | 374800 | **4400** | 4840 | - |
| [Lichee Pi 4A (T-Head TH1520)](results/4xYE.txt) | 1990 MHz | 5.10 | Bookworm riscv64 | 5260 | 1592 | 43820 | **4350** | 14760 | - |
| [ODROID-N2+ (Amlogic S922X)](results/3DtN.txt) | 2400/2015 MHz | 5.14 | Impish arm64 | 9790 | 2253 | 1366930 | **4300** | 7480 | - |
| [Amazon a1.xlarge](results/2iFY.txt) | 2300 MHz | 4.15 | Bionic arm64 | 8610 | 2406 | 1297960 | **4280** | 14220 | - |
| [ODROID-N2 (Amlogic S922X)](results/3MuT.txt) | 2000/1900 MHz | 5.10 | Buster arm64 | 9090 | 2012 | 1085350 | **4260** | 9080 | - |
| [ODROID-N2+ (Amlogic S922X)](results/4rWn.txt) | 2400/2015 MHz | 6.1 | Bullseye arm64 | 9710 | 2373 | 1366180 | **4220** | 7720 | - |
| [H270-T70<br />(2 x ThunderX CN8890)](results/3N5c.txt) | 2000 Mhz | 5.16 | Sid arm64 | 107180 | 1826 | 340750 | **4180** | 17130 | - |
| [NanoPC T4 (RK3399)](results/1iZq.txt) | 1800/1400 MHz | 4.17 | Stretch arm64 | 6380 | 1741 | 1022600 | **4160** | 9000 | 9.36 |
| [ODROID-N2 (Amlogic S922X)](results/1BsF.txt) | 1800/1900 MHz | 4.9 | Bionic arm64 | 8140 | 1669 | 1024680 | **4120** | 8610 | 11.39 |
| [Athlon II X3 420e](results/4eOo.txt) | 2600 MHz | 4.19 | Buster amd64 | 4780 | 2566 | 98840 | **4120** | 3870 | - |
| [NanoPC T4 (RK3399)](results/1iWU.txt) | 1800/1400 MHz | 4.17 | Stretch arm64 | 6230 | 1756 | 1023600 | **4100** | 9060 | 10.30 |
| [NanoPC T4 (RK3399)](results/1iFz.txt) | 1800/1400 MHz | 4.17 | Stretch arm64 | 6250 | 1809 | 1022500 | **4100** | 9000 | 8.24 |
| [Jetson Nano](results/3Ufc.txt) | 2000 MHz | 4.9 | Bionic arm64 | 6260 | 1977 | 717500 | **4100** | 11760 | 8.72 |
| [Celeron J3455](results/1m5p.txt) | 2300/1500 MHz | 4.17 | Stretch amd64 | 7000 | 2037 | 429660 | **4090** | 4050 | 17.26 |
| [NanoPi M4 (RK3399)](results/1lzP.txt) | 2000/1500 MHz | 4.19 | Stretch arm64 | 6400 | 1835 | 1128330 | **4080** | 8270 | 8.86 |
| [ODROID-N2+ (Amlogic S922X)](results/3R1a.txt) | 2400/2015 MHz | 5.10 | Focal arm64 | 9680 | 2372 | 1366730 | **4030** | 7120 | - |
| [Celeron N2830](results/4pEc.txt) | 2160 MHz | 5.19 | Jammy amd64 | 2760 | 1664 | 31270 | **3780** | 3520 | 6.10 |
| [Celeron J1900](results/4hKV.txt) | 2415/1333 MHz | 5.4 | Focal amd64 | 6560 | 1806 | 34900 | **3780** | 3390 | - |
| [Phytium<br />FT-2000/4<br />(1 x SO-DIMM)](results/4ioj.txt) | 2600 MHz | 5.15 | Bullseye arm64 | 10020 | 2755 | 936740 | **3760** | 14540 | - |
| [Jetson Nano](results/4rLX.txt) | 1480 MHz | 4.9 | Bullseye arm64 | 5260 | 1578 | 531940 | **3730** | 8870 | - |
| [RockPro64 (RK3399)](results/1ub9.txt) | 1800/1400 MHz | 4.4 | Stretch arm64 | 6420 | 1673 | 1018480 | **3720** | 8400 | 8.24 |
| [RockPro64 (RK3399)](results/2sZH.txt) | 2010/1510 MHz | 5.4 | Focal arm64 | 6920 | 1826 | 1145300 | **3700** | 8430 | 11.55 |
| [Khadas VIM3L (S905D3)](results/3Vdt.txt) | 1900 MHz | 5.16 | Bullseye arm64 | 5110 | 1403 | 890730 | **3700** | 5140 | - |
| [RockPro64 (RK3399)](results/2yIx.txt) | 2010/1510 MHz | 5.8 | Bullseye arm64 | 7000 | 1833 | 1144950 | **3690** | 8360 | 11.08 |
| [Khadas VIM3L (S905D3)](results/26Wy.txt) | 1900 MHz | 4.9 | Bionic arm64 | 5160 | 1399 | 892110 | **3670** | 6360 | 7.29 |
| [Radxa Rock Pi 4 (RK3399)](results/21fX.txt) | 2000/1500 MHz | 5.3 | Bionic arm64 | 6910 | 1817 | 1147370 | **3660** | 8310 | 10.71 |
| [RockPro64 (RK3399)](results/1iFp.txt) | 1800/1400 MHz | 4.18 | Stretch arm64 | 6300 | 1755 | 1021500 | **3650** | 8450 | 8.20 |
| [Milk-V Pioneer (SG2042)](results/4wYE.txt) | 2000 MHz | 6.1 | Kinetic riscv64 | 59820 | 1622 | 43500 | **3620** | 4760 | - |
| [Celeron N2807](results/4z3s.txt) | 2165 MHz | 5.10 | Bullseye) amd64 | 3070 | 1766 | 31250 | **3600** | 3110 | 6.09 |
| [ODROID-HC4 (S905X3)](results/3Na5.txt) | 2100 MHz | 5.10 | Buster arm64 | 5730 | 1672 | 980970 | **3540** | 5150 | - |
| [ODROID-C4 (S905X3)](results/3TQ2.txt) | 2100 MHz | 5.10 | Buster arm64 | 5770 | 1679 | 981940 | **3540** | 5150 | - |
| [x7-Z8700](results/4iDX.txt) | 2400 MHz | 5.15 | Bullseye amd64 | 6580 | 1784 | 296680 | **3510** | 3580 | - |
| [OrangePi 4 (RK3399)](results/4Kau.txt) | 2010/1510 MHz | 6.1 | Bookworm arm64 | 6880 | 1891 | 1145840 | **3490** | 8430 | - |
| [Phytium D2000<br />(2 x SO-DIMM)](results/446h.txt) | 2300 MHz | 5.19 | Jammy arm64 | 16670 | 2252 | 828130 | **3480** | 16110 | - |
| [Radxa Rock Pi 4 (RK3399)](results/3Q2q.txt) | 2000/1500 MHz | 5.10 | Focal arm64 | 6900 | 1899 | 1146500 | **3430** | 8260 | - |
| [T-HEAD C910 RVB-ICE](results/41AB.txt) | 1200 MHz | 5.10 | Sid riscv64 | 1760 | 1007 | 26930 | **3340** | 6470 | - |
| [ODROID-M1 (RK3568)](results/4ijy.txt) | 2060 MHz | 5.18 | Bullseye arm64 | 5430 | 1567 | 961090 | **3310** | 5960 | 7.76 |
| [ODROID-C4 (S905X3)](results/2kaS.txt) | 2010 MHz | 4.9 | Focal arm64 | 5450 | 1459 | 941590 | **3310** | 6270 | 7.71 |
| [Quartz64-A (RK3566)](results/4qJF.txt) | 1890 MHz | 6.2 | Jammy arm64 | 4980 | 1457 | 884590 | **3240** | 6100 | 6.98 |
| [x5-Z8350](results/2Jdb.txt) | 1920/1680 MHz | 5.4 | Focal amd64 | 4790 | 1454 | 237230 | **3170** | 2960 | 9.38 |
| [Radxa ROCK 3A (RK3568)](results/40TX.txt) | 2000 MHz | 5.18 | Bullseye arm64 | 5110 | 1450 | 935920 | **3150** | 6250 | 7.58 |
| [RK3568-ROC-PC](results/3Rsg.txt) | 1960 MHz | 4.19 | Bullseye arm64 | 5040 | 1424 | 912800 | **3130** | 6240 | - |
| [NanoPi M4v2 (RK3399)](results/3MAK.txt) | 2015/1510 MHz | 5.10 | Bullseye arm64 | 6680 | 1855 | 921980 | **3110** | 7640 | - |
| [ODROID-M1 (RK3568)](results/3Ug9.txt) | 1930 MHz | 4.19 | Focal arm64 | 5010 | 1450 | 898610 | **3070** | 6220 | 7.14 |
| [Atom Z3735F](results/4r54.txt) | 1830 MHz | 5.15 | Jammy amd64 | 4510 | 1437 | 227900 | **3020** | 2780 | - |
| [AMD Seattle (Opteron A1100)](results/4Kqn.txt) | 2000 MHz | 4.15 | Bionic arm64 | 14080 | 2006 | 720710 | **3020** | 9530 | - |
| [NanoPi R5S (RK3568)](results/4jfZ.txt) | 1960 MHz | 6.1 | Bullseye arm64 | 5030 | 1482 | 914340 | **2990** | 5970 | 7.33 |
| [Quartz64-A (RK3566)](results/3rUb.txt) | 1810 MHz | 5.13 | Buster arm64 | 4840 | 1353 | 845490 | **2980** | 7650| - |
| [Atom E3825](results/4kFQ.txt) | 1330 MHz | 5.10 | Bullseye amd64 | 1950 | 1109 | 165840 | **2890** | 2890 | - |
| [Khadas Edge (RK3399)](results/1uar.txt) | 2000/1500 MHz | 4.4 | Stretch arm64 | 6600 | 1703 | 1127780 | **2860** | 4880 | 8.85 |
| [Atom E3826](results/44pd.txt) | 1460 MHz | 5.18 | Jammy amd64 | 2140 | 1112 | 182190 | **2840** | 2760 | - |
| [Phytium D2000<br />(1 x SO-DIMM)](results/445T.txt) | 2300 MHz | 5.19 | Jammy arm64 | 16390 | 2220 | 827090 | **2820** | 6490 | - |
| [NanoPC T4 (RK3399)](results/1lkG.txt) | 2000/1500 MHz | 4.4 | Stretch arm64 | 5870 | 1336 | 1124040 | **2810** | 4890 | 8.70 |
| [Khadas Edge (RK3399)](results/1rYm.txt) | 2000/1500 MHz | 4.4 | Bionic arm64 | 6550 | 1721 | 1130400 | **2810** | 4860 | 10.50 |
| [Raspberry Pi 4 B (BCM2711)](results/3Gia.txt) | 1800 MHz | 5.10 | Raspberry Pi OS Buster | 6550 | 1897 | 77830 | **2780** | 3080 | - |
| [RockPro64 (RK3399)](results/1lBC.txt) | 1800/1400 MHz | 4.4 | Stretch arm64 | 6140 | 1580 | 1015600 | **2770** | 4850 | 8.14 |
| [x5-Z8350](results/1HnC.txt) | 1920/1680 MHz | 4.15 | Bionic amd64 | 4710 | 1272 | 207640 | **2740** | 3140 | - |
| [i.MX8MPlus EVK](results/4hx0.txt) | 1800 MHz | 5.15 | Focal arm64 | 4990 | 1348 | 837680 | **2740** | 12420 | 7.02 |
| [Raspberry Pi 400 (BCM2711)](results/2Cyi.txt) | 1800 MHz | 5.4 | Raspberry Pi OS Buster | 6550 | 1903 | 77890 | **2680** | 3110 | - |
| [BeagleBone AI-64 (TI J721E)](results/4DLw.txt) | 2000 MHz | 5.10 | Bookworm arm64 | 3470 | 1872 | 1130390 | **2660** | 8710 | - |
| [AMedia X96 Max+ (S905X3)](results/3QOj.txt) | 2100 MHz | 5.15 | Focal arm64 | 5270 | 1330 | 981830 | **2630** | 5150 | - |
| [Raspberry Pi 4 B (BCM2711)](results/3InF.txt) | 1800 MHz | 5.15 | Armbian Jammy arm64 | 5640 | 1752 | 36260 | **2580** | 3110 | - |
| [Raspberry Pi 4 B (BCM2711)](results/3EgS.txt) | 1500 MHz | 5.10 | Raspberry Pi OS Buster | 5750 | 1661 | 64930 | **2550** | 3430 | - |
| [Nintendo Switch (Tegra X1)](results/1Rnj.txt) | 1780 MHz | 4.9 | Fedora 30 arm-64 | 6170 | 1719 | 642670 | **2500** | 3570 | - |
| [Raspberry Pi 4 B (BCM2711)](results/1MFf.txt) | 1500 MHz | 4.19 | Raspbian Buster | 5500 | 1606 | 64860 | **2460** | 3170 | - |
| [NanoPi NEO4 (RK3399)](results/3GmR.txt) | 2016/1512 MHz | 5.10 | Focal arm64 | 6970 | 1906 | 1145030 | **2450** | 6190 | 11.36 |
| [x5-Z8300](results/1lgD.txt) | 1420 MHz | 4.9 | Stretch amd64 | 3900 | 950 | 178010 | **2380** | 2380 | 7.81 |
| [Nintendo Switch (Tegra X1)](results/3Di2.txt) | 2060 MHz | 4.9 | Bionic arm64 | 6720 | 1901 | 746680 | **2370** | 3670 | 9.25 |
| [NanoPi NEO4 (RK3399)](results/1p3T.txt) | 2000/1500 MHz | 4.19 | Stretch arm64 | 6750 | 1814 | 1139850 | **2370** | 6110 | 8.84 |
| [Raspberry Pi 4 B (BCM2711)](results/3OBF.txt) | 1800 MHz | 5.10 | Raspberry Pi OS Bullseye arm64 | 5790 | 1769 | 36260 | **2330** | 3120 | 8.74 |
| [Raspberry Pi 4 B (BCM2711)](results/3N94.txt) | 1800 MHz | 5.10 | Raspberry Pi OS Bullseye | 5940 | 1738 | 77670 | **2310** | 2690 | - |
| [ODROID-XU4 (Exynos 5422)](results/3GnC.txt) | 2000/1400 MHz | 5.4 | Focal armhf | 8980 | 1604 | 72020 | **2280** | 4910 | - |
| [NanoPi NEO4 (RK3399)](results/1oim.txt) | 2000/1500 MHz | 4.4| Stretch arm64 | 6520 | 1718 | 1123190 | **2280** | 4770 | 8.83 |
| [x5-Z8300](results/4j4o.txt) | 1840 MHz | 5.15 | Jammy amd64 | 4430 | 1368 | 227030 | **2270** | 2380 | 8.84 |
| [Hugsun X99 (RK3399)](results/2ICt.txt) | 2088/1800 MHz | 5.9 | Focal arm64 | 7710 | 1927 | 1184306 | **2270** | 5970 | - |
| [NanoPi NEO4 (RK3399)](results/1oho.txt) | 2000/1500 MHz | 4.4| Stretch arm64 | 6510 | 1703 | 1128860 | **2260** | 4770 | 8.71 |
| [Raspberry Pi 4 B (BCM2711)](results/3F9C.txt) | 1800 MHz | 5.10 | Raspberry Pi OS Buster arm64 | 5760 | 1741 | 36240 | **2240** | 3120 | 9.46 |
| [ODROID-XU4 (Exynos 5422)](results/1iWL.txt) | 2000/1400 MHz | 4.9 | Stretch armhf | 6400 | 1622 | 72075 | **2230** | 4850 | - |
| [NanoPi NEO4 (RK3399)](results/1oib.txt) | 2000/1500 MHz | 4.4| Stretch arm64 | 6030 | 1343 | 1121380 | **2230** | 4770 | 8.57 |
| [HummingBoard Pulse i.MX8M Quad](results/27FC.txt) | 1500 MHz | 4.19 | Buster arm64 | 4330 | 1201 | 695540 | **2230** | 9900 | - |
| [ODROID-XU4 (Exynos 5422)](results/1ixL.txt) | 1900/1400 MHz | 3.10 | Jessie armhf | 6750 | - | 68200 | **2200** | 4800 | - |
| [Hlink H28K (RK3528)](results/4I93.txt) | 2000 Mhz | 5.10 | Jammy arm64 | 4680 | 1388 | 933630 | **2090** | 7650 | 6.48 |
| [Atom N2800](results/4nt8.txt) | 1860 MHz | 5.15 | Bullseye amd64 | 2970 | 1006 | 21780 | **2050** | 1570 | - |
| [RockPro64 (RK3399)](results/1iFZ.txt) | 1800/1400 MHz | 4.4 | Stretch armhf | 6250 | 1809 | 1000150 | **2000** | 4835 | - |
| [Khadas VIM1S (S905Y4)](results/4bbv.txt) | 2000 MHz | 5.4 | Jammy arm64 | 4000 | 1148 | 436540 | **1970** | 7530 | - |
| [Khadas VIM1 (Amlogic S905X)](results/4bee.txt) | 1415 MHz | 5.1 | Buster arm64 | 3860 | 1136 | 660160 | **1940** | 5900 | - |
| [Khadas VIM2 (Amlogic S912)](results/1iJ7.txt) | 1415/1000 MHz | 4.17 | Bionic arm64 | 5450 | 993 | 659600 | **1920** | 5920 | 8.59 |
| [NanoPi K2 (Amlogic S905)](results/3Qve.txt) | 1480 MHz | 5.10 | Bullseye arm64 | 3880 | 1154 | 51490 | **1850** | 3790 | - |
| [Le Potato (Amlogic S905X)](results/1iSQ.txt) | 1410 MHz | 4.18 | Stretch arm64 | 3780 | 1057 | 657200 | **1810** | 5730 | 3.92 |
| [ODROID-C2 (Amlogic S905)](results/1ixI.txt) | 1750 MHz | 3.14 | Xenial arm64 | 4070 | 1128 | 48500 | **1750** | 3100 | - |
| [AMD E-450 APU](results/4hwl.txt) | 1650 MHz | 5.15 | Jammy amd64 | 2430 | 1258 | 27450 | **1710** | 1740 | - |
| [NanoPi K2 (Amlogic S905)](results/1iT1.txt) | 1480 MHz | 4.14 | Stretch arm64 | 3850 | 1095 | 50370 | **1660** | 3870 | 4.61 |
| [NanoPC T3+ (Nexell S5P6818)](results/1iyp.txt) | 1400 MHz | 4.4 | Xenial armhf | 6400 | 943 | 651000 | **1650** | 3700 | - |
| [Libre Computer AML-S912-PC](results/40cj.txt) | 1415/1000 MHz | 5.15 | Bullseye arm64 | 5980 | 1012 | 659290 | **1650** | 5170 | - |
| [Radxa Zero (S905Y2)](results/3PlT.txt) | 1800 MHz | 5.10 | Buster arm64 | 4570 | 1373 | 839080 | **1610** | 5250 | 6.82 |
| [Radxa Zero (S905Y2)](results/3wZn.txt) | 1800 MHz | 5.10 | Focal arm64 | 4610 | 1267 | 840080 | **1600** | 5370 | - |
| [Radxa Zero (S905Y2)](results/3JCm.txt) | 1800 MHz | 5.10 | Bullseye arm64 | 4580 | 1353 | 838360 | **1600** | 5360 | 7.13 |
| [Renegade (RK3328)](results/1iFx.txt) | 1400 MHz | 4.4 | Stretch arm64 | 3710 | 1069 | 644200 | **1565** | 7435 | 3.92 |
| [NanoPi Fire3 (Nexell S5P6818)](results/1jjm.txt) | 1400 MHz | 4.14 | Bionic arm64 | 7440 | 1052 | 653000 | **1560** | 4600 | 10.96 |
| [BPi R2 (MT7623)](results/4dO7.txt) | 1300 MHz | 4.19 | Focal armhf | 2990 | 854 | 25260 | **1550** | 3220 | - |
| [Tinkerboard (RK3288)](results/3X9q.txt) | 1800 MHz | 5.10 | Buster armhf | 5770 | 1713 | 67060 | **1540** | 4110 | - |
| [TinkerBoard S (RK3288)](results/4vfU.txt) | 1800 MHz | 6.1 | Jammy armhf | 5560 | 1672 | 65800 | **1540** | 4150 | - |
| [NanoPi Fire3 (Nexell S5P6818)](results/3ZxU.txt) | 1400 MHz | 4.14 | Focal arm64 | 7350 | 1093 | 652640 | **1530** | 4590 | 11.18 |
| [NanoPi Fire3 (Nexell S5P6818)](results/1jiU.txt) | 1380 MHz | 4.14 | Stretch arm64 | 7420 | 1038 | 645400 | **1520** | 4570 | 8.53 |
| [Orange Pi Zero 3 (Allwinner H618)](results/4CPF.txt) | 1510 MHz | 6.1 | Jammy arm64 | 4020 | 1165 | 705330 | **1510** | 6010 | 6.02 |
| [Orange Pi Zero 2W (Allwinner H618)](results/4Hd0.txt) | 1510 MHz | 6.1 | Jammy arm64 | 3920 | 1167 | 705660 | **1510** | 6010 | 6.02 |
| [Tinkerboard (RK3288)](results/1iSX.txt) | 1730 MHz | 4.14 | Stretch armhf | 5350 | 1563 | 66600 | **1480** | 3900 | - |
| [Tronsmart MXIII Plus (S812)](results/3S5U.txt) | 1560 MHz | 5.10 | Buster armhf | 3880 | 1113 | 42570 | **1470** | 3430 | - |
| [NanoPC T3+ (Nexell S5P6818)](results/1iRJ.txt) | 1400 MHz | 4.14 | Bionic arm64 | 7480 | 1053 | 652600 | **1440** | 4540 | 10.99 |
| [Rock64 (RK3328)](results/1iwz.txt) | 1400 MHz | 4.4 | Stretch armhf | 3620 | 1006 | 624000 | **1430** | 3620 | - |
| [PineH64 (Allwinner H6)](results/26Ph.txt) | 1800 MHz | 5.4 | Buster arm64 | 4710 | 1293 | 839870 | **1420** | 5560 | 7.10 |
| [Atom N270](results/461n.txt) | 1600 MHz | 4.19 | Buster i386 | 1220 | 824 | 18760 | **1420** | 2840 | - |
| [PineH64 (Allwinner H6)](results/1jEr.txt) | 1800 MHz | 4.18 | Stretch arm64 | 4650 | 1274 | 836900 | **1380** | 5530 | 5.62 |
| [Rock64 (RK3328)](results/1iHo.txt) | 1300 MHz | 4.4 | Stretch arm64 | 3430 | 952 | 601000 | **1350** | 5680 | 3.64 |
| [Tinkerboard (RK3288)](results/3Lir.txt) | 1800 MHz | 4.4 | Buster armhf | 5440 | 1693 | 66300 | **1340** | 3510 | - |
| [Rock64 (RK3328)](results/1iHB.txt) | 1300 MHz | 4.18 | Stretch arm64 | 3560 | 1002 | 603800 | **1340** | 5770 | 3.80 |
| [Rock64 (RK3328)](results/1iH4.txt) | 1300 MHz | 4.18 | Bionic arm64 | 3530 | 996 | 605250 | **1340** | 5770 | 4.65 |
| [Rock64 (RK3328)](results/1iYK.txt) | 1400 MHz | 4.4 | Stretch arm64 | 3580 | 1032 | 644380 | **1330** | 5680 | 4.63 |
| [Rock64 (RK3328)](results/1iFm.txt) | 1400 MHz | 4.4 | Stretch arm64 | 3610 | 1034 | 644250 | **1330** | 5700 | 3.85 |
| [Rock64 (RK3328)](results/1iZj.txt) | 1400 MHz | 4.4 | Stretch arm64 | 3590 | 1030 | 643700 | **1320** | 5640 | 4.40 |
| [Raspberry Pi Zero 2 (RP3A0)](results/3DeL.txt) | 1200 MHz | 5.10 | Raspberry Pi OS Buster | 3640 | 1007 | 36300 | **1320** | 1790 | - |
| [Rock64 (RK3328)](results/1iGW.txt) | 1300 MHz | 4.4 | Bionic arm64 | 3410 | 945 | 601200 | **1310** | 5680 | 4.46 |
| [Raspberry Pi Zero 2 (RP3A0)](results/3E85.txt) | 1000 MHz | 5.10 | Raspberry Pi OS Buster | 3030 | 838 | 29860 | **1300** | 1570 | - |
| [MT6580 K9M1](results/466y.txt) | 1300 MHz | 5.19 | Sid armhf | 2930 | 860 | 25300 | **1250** | 3300 | - |
| [Raspberry Pi 3 B+ (BCM2837B0)](results/1iI5.txt) | original | 4.9 | Raspbian Stretch | 3600 | 1076 | 42700 | **1230** | 1640 | - |
| [Raspberry Pi 3 B+ (BCM2837B0)](results/1iGz.txt) | OC/normal | 4.14 | Raspbian Stretch | 3130 | 843 | 36620 | **1230** | 1780 | - |
| [ClockworkPi R-01 (Allwinner D1)](results/40BJ.txt) | 1000 MHz | 5.4 | Focal riscv64 | 450 | 450 | 9040 | **1220** | 2640 | - |
| [Raspberry Pi 4 B (BCM2711)](results/3VME.txt) | 1800 MHz | 5.15 | Jammy armhf | 6300 | 1844 | 82750 | **1190** | 3110 | - |
| [Orange Pi Zero 2 (Allwinner H616)](results/4knM.txt) | 1510 MHz | 4.9 | Buster arm64 | 3550 | 1067 | 703300 | **1190** | 2820 | 5.01 |
| [Orange Pi Prime (Allwinner H5)](results/2kTH.txt) | 1370 MHz | 5.4 | Buster | 3590 | 984 | 637980 | **1180** | 3540 | - |
| [Akaso M8S (S812)](results/3R3N.txt) | 1200 MHz | 5.10 | Buster armhf | 3050 | 885 | 32120 | **1160** | 3330 | - |
| [Raspberry Pi 3 B+ (BCM2837B0)](results/1ism.txt) | normal | 4.14 | Raspbian Stretch | 3240 | 914 | 36600 | **1130** | 1530 | - |
| [Raspberry Pi 3 B+ (BCM2837B0)](results/1isD.txt) | with fan | 4.14 | Raspbian Stretch | 3670 | 1046 | 42600 | **1120** | 1600 | - |
| [Raspberry Pi 3 B (BCM2837)](results/4hOP.txt) | 1200 MHz | 5.15 | Raspbian Sid | 2970 | 977 | 36230 | **1110** | 1700 | 2.89 |
| [Teres-I<br />(Allwinner A64)](results/1tJg.txt) | 1050 MHz | 4.19 | Stretch arm64 | 2785 | 780 | 491590 | **1080** | 2820 | - |
| [Orange Pi PC 2 (Allwinner H5)](results/3MQJ.txt) | 1370 MHz | 5.10 | Focal arm64 | 3500 | 1023 | 637410 | **1070** | 3680 | - |
| [NanoPi K1 Plus (Allwinner H5)](results/3N7H.txt) | 1370 MHz | 5.10 | Focal arm64 | 3520 | 1022 | 638880 | **1070** | 3680 | 5.50 |
| [Raspberry Pi 3 B+ (BCM2837B0)](results/1iGM.txt) | normal | 4.14 | Raspbian Stretch | 3040 | 856 | 36600 | **1050** | 1500 | - |
| [Raspberry Pi Zero 2 (RP3A0)](results/3Dfo.txt) | 600 MHz | 5.10 | Raspberry Pi OS Buster | 1900 | 529 | 18150 | **1040** | 1130 | - |
| [Raspberry Pi 3 B+ (BCM2837B0)](results/1iH0.txt) | UV/normal | 4.14 | Raspbian Stretch | 2100 | 856 | 36400 | **1040** | 1460 | - |
| [EspressoBin (Armada 3720)](results/1kt2.txt) | 800 MHz | 4.17 | Stretch arm64 | 1138 | 636 | 368330 | **1040** | 2490 | 1.23 |
| [BPi M4 (RTD1395)](results/1Dt1.txt) | 1400 MHz | 4.9 | Bionic arm64 | 3500 | - | 651460 | **1010** | 4360 | 5.48 |
| [Raspberry Pi 2 B+ (BCM2836)](results/3MGs.txt) | 900 MHz | 5.10 | Raspberry Pi OS Bullseye | 2150 | 620 | 16500 | **1000** | 1180 | - |
| [EspressoBin (Armada 3720)](results/1lCe.txt) | 1200 MHz | 4.18 | Stretch arm64 | 1630 | 869 | 544240 | **1000** | 2400 | 1.82 |
| [MangoPi Mcore (Allwinner H616)](results/4bSf.txt) | 1800 MHz | 5.19 | Jammy arm64 | 4100 | 1218 | 840270 | **990** | 2380 | - |
| [TRONFY MXQ (Amlogic S805)](results/3MiR.txt) | 1536 MHz | 5.10 | Focal armhf | 3100 | 897 | 29080 | **980** | 2990 | - |
| [Milk-V Mars CM (JH7110)](results/4K7E.txt) | 1500 MHz | 5.15 | Bookworm riscv64 | 4110 | 1195 | 25070 | **930** | 830 | - |
| [Helios4<br />(Armada 388)](results/1jCy.txt) | 1600 MHz | 4.14 | Stretch armhf | 2210 | 1215 | 42500 &ast;98560 | **910** | 4840 | - |
| [Clearfog A1<br />(Armada 388)](results/4d1U.txt) | 1600 MHz | 5.15 | Bullseye armhf | 2230 | 1239 | 44080 | **910** | 5060 | - |
| [Orange Pi PC+ (Allwinner H3)](results/3MQV.txt) | 1370 MHz | 5.10 | Focal armhf | 3060 | 879 | 26590 | **890** | 3450 | - |
| [VisionFive V2 (JH7110)](results/4xOY.txt) | 1500 MHz | 5.15 | Sid riscv64 | 4180 | 1197 | 25080 | **880** | 770 | - |
| [Orange Pi Plus 2 (Allwinner H3)](results/1iX4.txt) | 1300 MHz | 4.14 | Stretch armhf | 2890 | 812 | 25250 | **830** | 3240 | - |
| [NanoPi M1 Plus (Allwinner H3)](results/3N2z.txt) | 1370 MHz | 4.19 | Bionic armhf | 3030 | 881 | 26660 | **830** | 3450 | - |
| [Star64 (JH7110)](results/4tjq.txt) | 1500 MHz | 5.15 | Sid riscv64 | 3970 | 1175 | 24990 | **820** | 770 | - |
| [Radxa Rock Pi S (RK3308)](results/4sNe.txt) | 1300 MHz | 6.1 | Jammy arm64 | 2540 | 732 | 282030 | **820** | 1870 | - |
| [BPi M2U (Allwinner R40)](results/4kmM.txt) | 1200 MHz | 6.0 | Bullseye armhf | 2690 | 767 | 23320 | **780** | 3010 | - |
| [SBC2D70 (SSD202D)](results/3N1U.txt) | 1700 MHz | 5.16 | Sid armhf | 1960 | 1094 | 33120 | **770** | 3190 | - |
| [Marvell PXA1908](results/46hs.txt) | 1245 MHz | 3.14 | Bullseye arm64 | 3180 | 951 | 581840 | **740** | 2220 | - |
| [RK3318 BOX](results/4kor.txt) | 1390 MHz | 6.0 | Jammy arm64 | 3200 | 867 | 644750 | **700** | 2460 | - |
| [Raspberry Pi 2 B+ (BCM2836)](results/1iFf.txt) | 900 MHz | 4.14 | Debian Stretch | 2070 | 592 | 17450 | **615** | 1175 | - |
| [Tronsmart S82 (Amlogic S802)](results/41ML.txt) | 1600 MHz | 5.14 | Focal armhf | 3640 | 1114 | 43150 | **500** | 3200 | - |
| [Raspberry Pi B (BCM2835)](results/4vVG.txt) | 1000 MHz | 6.1 | Raspberry Pi OS Bullseye | 480 | 481 | 16900 | **490** | 2220 | - |
| [Lime A10 (Allwinner A10)](results/1j1L.txt) | 910 MHz | 4.14 | Stretch armhf | 550 | 550 | 28250 | **440** | 1300 | - |
| [Cubietruck (Allwinner A20)](results/3Naw.txt) | 960 MHz | 5.10 | Bullseye armhf | 1030 | 541 | 18640 | **440** | 2010 | - |
| [Banana Pi (Allwinner A20)](results/3PLr.txt) | 960 MHz | 5.10 | Bullseye armhf | 1040 | 542 | 18640 | **440** | 2020 | - |
| [Raspberry Pi Zero (BCM2835)](results/3Njz.txt) | 1000 MHz | 5.10 | Bullseye armv6l/armhf | 460 | 460 | 17060 | **430** | 1670 | - |
| [Olimex A20-Lime2](results/4rRV.txt) | 960 MHz | 5.10 | Bullseye armhf | 1080 | 589 | 18630 | **430** | 2020 | 0.87 |
| [RK3228A TV Box](results/3M9F.txt) | 1200 MHz | 4.4 | Buster armhf | 2310 | 710 | 23070 | **410** | 1230 | - |
| [Raspberry Pi Zero (BCM2835)](results/1niO.txt) | 1000 MHz | 4.14 | Raspbian Stretch | 450 | 450 | 16820 | **400** | 1590 | - |
| [ODROID-C1 (Amlogic S805)](results/4eg5.txt) | 1500 MHz | 5.19 | Jammy armhf | 3010 | 878 | 29260 | **390** | 2910 | - |
| [Raspberry Pi B (BCM2835)](results/3MGN.txt) | 700 MHz | 5.10 | Raspberry Pi OS Bullseye | 320 | 320 | 11630 | **360** | 1420 | - |
| [Cubox-i4<br />(NXP i.MX6)](results/4132.txt) | 980 MHz | 5.15 | Jammy armhf | 2360 | 657 | 27000 | **340** | 340 | - |
| [Ugoos UT2 (RK3188)](results/408h.txt) | 1560 MHz | 5.10 | Jammy armhf | 3320 | 994 | 43250 | **320** | 2020 | - |
| [Kendryte K510](results/41Qa.txt) | 790 MHz | 4.17 | Sid riscv64 | 690 | 402 | 7410 | **280** | 440 | - |

[(back to top of the page)](#sbc-bench-results-sorted)

## memset

| Device / details | Clockspeed | Kernel | Distro | 7-zip multi | 7-zip single | AES | memcpy | *memset* | kH/s |
| ----- | :--------: | :----: | :----: | ----: | ------: | ------: | -----: | -----: | ---: |
| [Apple M1 Pro](results/443N.txt) | 3030/2060 MHz | 5.18 | Gentoo 2.8 arm64 | 43800 | 5010 | 1064450 | 27110 | **71910** | 48.28 |
| [Huaqin P6410<br />(2 x Ampere Altra Max)](results/4kiu.txt) | 3000 MHz | 5.4 | Focal arm64 | 430860 | 4211 | 1710010 | 13310 | **47970** | - |
| [Hetzner CAX11 (Ampere Altra)](results/4HdL.txt) | 3000 MHz | 5.15 | Jammy arm64 | 8060 | 3842 | 1705600 | 11250 | **47670** | 11.44 |
| [Ampere Altra M96-28](results/4zGI.txt) | 2800 MHz | 5.15 | Jammy arm64 | 249380 | 3858 | 1596110 | 10130 | **44750** | - |
| [Qualcomm Snapdragon 8cx Gen 3](results/4xwT.txt) | 3000/2440 MHz | 6.3 | Lunar arm64 | 35370 | 4312 | 1686160 | 17500 | **41780** | 42.76 |
| [Ampere Altra Q80-26](results/4zkJ.txt) | 2600 MHz | 5.15 | Jammy arm64 | 214390 | 3748 | 1482190 | 11685 | **41560** | 316.50 |
| [Qualcomm Snapdragon 8cx Gen 3 (WSL2)](results/4kEp.txt) | 2980/? MHz | 5.15 | Jammy arm64 | 33600 | 4789 | 1679480 | 21010 | **41540** | 50.65 |
| [Pentium G4600](results/2jVw.txt) | 3600 MHz | 4.19 | Buster amd64 | 11810 | 4448 | 984820 | 15120 | **33380** | 21.88 |
| [Jetson AGX Orin](results/4ax9.txt) | 2200 MHz | 5.10 | Focal arm64 | 39450 | 3187 | 1242940 | 10600 | **30350** | 59.96 |
| [Orange Pi 5 (RK3588)](results/4D0a.txt) | 2400/1800 MHz | 5.10 | Jammy arm64 | 16780 | 2689 | 1366590 | 12800 | **29900** | - |
| [Radxa ROCK 5B (RK3588)](results/41BH.txt) | 2350/1830 MHz | 5.10 | Focal arm64 | 16450 | 3146 | 1337540 | 10830 | **29220** | 25.31 |
| [Khadas Edge2 (RK3588s)](results/4a5U.txt) | 2260/1800 MHz | 5.10 | Jammy arm64 | 16470 | 3096 | 1287490 | 10860 | **29110** | - |
| [Qualcomm QRB5165](results/49kx.txt) | 2840/2410/1790 MHz | 4.19 | Focal arm64 | 18860 | 3898 | 1598490 | 14470 | **23910** | 25.56 |
| [Jetson Xavier AGX](results/4ebH.txt) | 2250 MHz | 4.9 | Bionic arm64 | 21590 | 2742 | 853250 | 10910 | **22520** | 26.57 |
| [Jetson Orin Nano](results/4vy7.txt) | 1510 MHz | 5.10 | Focal arm64 | 13650 | 2153 | 854400 | 6730 | **20240** | 20.68 |
| [Loongson-3A5000-HV](results/4dzX.txt) | 2500 MHz | 4.19 | Loongnix 20 loongarch64 | 11120 | 2990 | 116900 | 6930 | **19170** | - |
| [MT8395 Genio 1200](results/4Kvg.txt) | 2200/2000 MHz | 5.15 | Jammy arm64 | 18130 | 3298 | 1240850 | 14200 | **19000** | 27.60 |
| [Jetson Xavier NX](results/3YWp.txt) | 1890 MHz | 4.9 | Bionic arm64 | 13230 | 2201 | 706280 | 9190 | **18480** | - |
| [H270-T70<br />(2 x ThunderX CN8890)](results/3N5c.txt) | 2000 Mhz | 5.16 | Sid arm64 | 107180 | 1826 | 340750 | 4180 | **17130** | - |
| [Honeycomb LX2 (NXP LX2160A)](results/3Y4f.txt) | 2200 MHz | 5.16 | Fedora 35 aarch64 | 30690 | 2288 | 1251710 | 5050 | **16220** | 46.09 |
| [Phytium D2000<br />(2 x SO-DIMM)](results/446h.txt) | 2300 MHz | 5.19 | Jammy arm64 | 16670 | 2252 | 828130 | 3480 | **16110** | - |
| [Celeron 5205U](results/4eiM.txt) | 1900 MHz | 5.15 | Jammy amd64 | 4060 | 2171 | 521090 | 7350 | **16020** | 11.20 |
| [Qualcomm Snapdragon 7c](results/4Lyf.txt) | 2550/1800 MHz | 6.6 | Bookworm arm64 | 13040 | 3113 | 1455700 | 6710 | **14880** | - |
| [Lichee Pi 4A (T-Head TH1520)](results/4xYE.txt) | 1990 MHz | 5.10 | Bookworm riscv64 | 5260 | 1592 | 43820 | 4350 | **14760** | - |
| [Phytium<br />FT-2000/4<br />(1 x SO-DIMM)](results/4ioj.txt) | 2600 MHz | 5.15 | Bullseye arm64 | 10020 | 2755 | 936740 | 3760 | **14540** | - |
| [Amazon a1.xlarge](results/2iFY.txt) | 2300 MHz | 4.15 | Bionic arm64 | 8610 | 2406 | 1297960 | 4280 | **14220** | - |
| [Qualcomm Snapdragon 835](results/4fdD.txt) | 2360/1900 MHz | 6.1 | Jammy arm64 | 9800 | 2474 | 883330 | 9720 | **14070** | 12.58 |
| [Raspberry Pi 5 B (BCM2712)](results/4I1w.txt) | 3000 MHz | 6.1 | Bookworm arm64 | 12740 | 3747 | 1710050 | 4940 | **12640** | - |
| [Clearfog CX (NXP LX2160A)](results/4ju5.txt) | 2000 MHz | 5.10 | Focal arm64 | 25260 | 2236 | 1136690 | 4460 | **12500** | - |
| [i.MX8MPlus EVK](results/4hx0.txt) | 1800 MHz | 5.15 | Focal arm64 | 4990 | 1348 | 837680 | 2740 | **12420** | 7.02 |
| [Macchiatobin (Armada 8040)](results/4zcm.txt) | 1600 MHz | 5.10 | Buster arm64 | 5720 | 1739 | 909420 | 4510 | **12270** | 7.91 |
| [Intel N100](results/4vxM.txt) | 3400 MHz | 6.1 | Lunar amd64 | 14150 | 4073 | 1232790 | 11600 | **12270** | 36.24 |
| [Jetson Nano](results/3Ufc.txt) | 2000 MHz | 4.9 | Bionic arm64 | 6260 | 1977 | 717500 | 4100 | **11760** | 8.72 |
| [Khadas VIM4 (A311D2)](results/4cHh.txt) | 2200/2010 MHz | 5.4 | Jammy arm64 | 12120 | 2067 | 1254540 | 8180 | **11680** | - |
| [Khadas VIM4 (A311D2)](results/3Wvv.txt) | 2200/1970 MHz | 5.4 | Focal arm64 | 12090 | 2081 | 1253200 | 7810 | **11600** | - |
| [Raspberry Pi 5 B (BCM2712)](results/4HDw.txt) | 2400 MHz | 6.1 | Bookworm arm64 | 10950 | 3160 | 1367990 | 5260 | **11520** | 15.42 |
| [Pentium N6005](results/4BtC.txt) | 3300/2000 MHz | 5.15 | Jammy amd64 | 11510 | 3369 | 923550 | 9650 | **10280** | 22.18 |
| [HummingBoard Pulse i.MX8M Quad](results/27FC.txt) | 1500 MHz | 4.19 | Buster arm64 | 4330 | 1201 | 695540 | 2230 | **9900** | - |
| [AMD Seattle (Opteron A1100)](results/4Kqn.txt) | 2000 MHz | 4.15 | Bionic arm64 | 14080 | 2006 | 720710 | 3020 | **9530** | - |
| [Khadas VIM3 (Amlogic A311D)](results/1MFD.txt) | 2200/1800 MHz | 4.9 | Bionic arm64 | 8600 | 2026 | 1256910 | 4980 | **9300** | 13.12 |
| [Celeron N5105](results/3Qf7.txt) | 2900/2000 MHz | 5.13 | Focal amd64 | 11450 | 3059 | 811760 | 7710 | **9290** | 21.79 |
| [Khadas VIM3 (Amlogic A311D)](results/4o1A.txt) | 2400/2015 MHz | 6.0 | Bullseye arm64 | 9650 | 2379 | 1366300 | 5080 | **9240** | - |
| [ODROID-N2 (Amlogic S922X)](results/3MuT.txt) | 2000/1900 MHz | 5.10 | Buster arm64 | 9090 | 2012 | 1085350 | 4260 | **9080** | - |
| [NanoPC T4 (RK3399)](results/1iWU.txt) | 1800/1400 MHz | 4.17 | Stretch arm64 | 6230 | 1756 | 1023600 | 4100 | **9060** | 10.30 |
| [NanoPC T4 (RK3399)](results/1iZq.txt) | 1800/1400 MHz | 4.17 | Stretch arm64 | 6380 | 1741 | 1022600 | 4160 | **9000** | 9.36 |
| [NanoPC T4 (RK3399)](results/1iFz.txt) | 1800/1400 MHz | 4.17 | Stretch arm64 | 6250 | 1809 | 1022500 | 4100 | **9000** | 8.24 |
| [Intel i3-N305](results/4qpr.txt) | 3800 MHz | 5.19 | Jammy amd64 | 20000 | 4398 | 1377280 | 9950 | **8990** | 41.43 |
| [Jetson Nano](results/4rLX.txt) | 1480 MHz | 4.9 | Bullseye arm64 | 5260 | 1578 | 531940 | 3730 | **8870** | - |
| [Intel N95](results/4xwq.txt) | 3400 MHz | 5.15 | Jammy amd64 | 13070 | 3993 | 1232880 | 9710 | **8730** | 34.60 |
| [BeagleBone AI-64 (TI J721E)](results/4DLw.txt) | 2000 MHz | 5.10 | Bookworm arm64 | 3470 | 1872 | 1130390 | 2660 | **8710** | - |
| [ODROID-N2 (Amlogic S922X)](results/1BsF.txt) | 1800/1900 MHz | 4.9 | Bionic arm64 | 8140 | 1669 | 1024680 | 4120 | **8610** | 11.39 |
| [RockPro64 (RK3399)](results/1iFp.txt) | 1800/1400 MHz | 4.18 | Stretch arm64 | 6300 | 1755 | 1021500 | 3650 | **8450** | 8.20 |
| [RockPro64 (RK3399)](results/2sZH.txt) | 2010/1510 MHz | 5.4 | Focal arm64 | 6920 | 1826 | 1145300 | 3700 | **8430** | 11.55 |
| [OrangePi 4 (RK3399)](results/4Kau.txt) | 2010/1510 MHz | 6.1 | Bookworm arm64 | 6880 | 1891 | 1145840 | 3490 | **8430** | - |
| [RockPro64 (RK3399)](results/1ub9.txt) | 1800/1400 MHz | 4.4 | Stretch arm64 | 6420 | 1673 | 1018480 | 3720 | **8400** | 8.24 |
| [RockPro64 (RK3399)](results/2yIx.txt) | 2010/1510 MHz | 5.8 | Bullseye arm64 | 7000 | 1833 | 1144950 | 3690 | **8360** | 11.08 |
| [Celeron N4500](results/3HUU.txt) | 2800/1100 MHz | 5.13 | Impish amd64 | 6300 | 3091 | 783840 | 8100 | **8350** | - |
| [Radxa Rock Pi 4 (RK3399)](results/21fX.txt) | 2000/1500 MHz | 5.3 | Bionic arm64 | 6910 | 1817 | 1147370 | 3660 | **8310** | 10.71 |
| [NanoPi M4 (RK3399)](results/1lzP.txt) | 2000/1500 MHz | 4.19 | Stretch arm64 | 6400 | 1835 | 1128330 | 4080 | **8270** | 8.86 |
| [Radxa Rock Pi 4 (RK3399)](results/3Q2q.txt) | 2000/1500 MHz | 5.10 | Focal arm64 | 6900 | 1899 | 1146500 | 3430 | **8260** | - |
| [Ryzen R1505G](results/4HYd.txt) | 3270 MHz | 6.1 | Bookworm amd64 | 9080 | 3327 | 886980 | 10520 | **8160** | 18.14 |
| [Celeron N5100](results/3IlQ.txt) | 2800/1100 MHz | 5.13 | Focal amd64 | 10550 | 3088 | 783800 | 7750 | **8090** | 19.22 |
| [ODROID-N2+ (Amlogic S922X)](results/4rWn.txt) | 2400/2015 MHz | 6.1 | Bullseye arm64 | 9710 | 2373 | 1366180 | 4220 | **7720** | - |
| [Quartz64-A (RK3566)](results/3rUb.txt) | 1810 MHz | 5.13 | Buster arm64 | 4840 | 1353 | 845490 | 2980 | **7650**| - |
| [Hlink H28K (RK3528)](results/4I93.txt) | 2000 Mhz | 5.10 | Jammy arm64 | 4680 | 1388 | 933630 | 2090 | **7650** | 6.48 |
| [Celeron J4105](results/1qb0.txt) | 2400/1500 MHz | 4.15 | Bionic amd64 | 8960 | 2274 | 697080 | 5620 | **7650** | 19.13 |
| [NanoPi M4v2 (RK3399)](results/3MAK.txt) | 2015/1510 MHz | 5.10 | Bullseye arm64 | 6680 | 1855 | 921980 | 3110 | **7640** | - |
| [Khadas VIM1S (S905Y4)](results/4bbv.txt) | 2000 MHz | 5.4 | Jammy arm64 | 4000 | 1148 | 436540 | 1970 | **7530** | - |
| [ODROID-N2+ (Amlogic S922X)](results/3DtN.txt) | 2400/2015 MHz | 5.14 | Impish arm64 | 9790 | 2253 | 1366930 | 4300 | **7480** | - |
| [Renegade (RK3328)](results/1iFx.txt) | 1400 MHz | 4.4 | Stretch arm64 | 3710 | 1069 | 644200 | 1565 | **7435** | 3.92 |
| [Celeron J4105](results/1qal.txt) | 2400/1500 MHz | 4.15 | Bionic amd64 | 9020 | 2290 | 697100 | 5500 | **7410** | 19.07 |
| [Khadas VIM3 (Amlogic A311D)](results/3R2Z.txt) | 2400/2015 MHz | 5.10 | Bullseye arm64 | 9650 | 2376 | 1366350 | 4850 | **7380** | - |
| [Pentium J5005](results/21rE.txt) | 2700/1500 MHz | 5.0 | Bionic amd64 | 9230 | 2455 | 778360 | 5530 | **7130** | 20.74 |
| [ODROID-N2+ (Amlogic S922X)](results/3R1a.txt) | 2400/2015 MHz | 5.10 | Focal arm64 | 9680 | 2372 | 1366730 | 4030 | **7120** | - |
| [Phytium D2000<br />(1 x SO-DIMM)](results/445T.txt) | 2300 MHz | 5.19 | Jammy arm64 | 16390 | 2220 | 827090 | 2820 | **6490** | - |
| [T-HEAD C910 RVB-ICE](results/41AB.txt) | 1200 MHz | 5.10 | Sid riscv64 | 1760 | 1007 | 26930 | 3340 | **6470** | - |
| [Khadas VIM3L (S905D3)](results/26Wy.txt) | 1900 MHz | 4.9 | Bionic arm64 | 5160 | 1399 | 892110 | 3670 | **6360** | 7.29 |
| [ODROID-C4 (S905X3)](results/2kaS.txt) | 2010 MHz | 4.9 | Focal arm64 | 5450 | 1459 | 941590 | 3310 | **6270** | 7.71 |
| [Radxa ROCK 3A (RK3568)](results/40TX.txt) | 2000 MHz | 5.18 | Bullseye arm64 | 5110 | 1450 | 935920 | 3150 | **6250** | 7.58 |
| [RK3568-ROC-PC](results/3Rsg.txt) | 1960 MHz | 4.19 | Bullseye arm64 | 5040 | 1424 | 912800 | 3130 | **6240** | - |
| [ODROID-M1 (RK3568)](results/3Ug9.txt) | 1930 MHz | 4.19 | Focal arm64 | 5010 | 1450 | 898610 | 3070 | **6220** | 7.14 |
| [NanoPi NEO4 (RK3399)](results/3GmR.txt) | 2016/1512 MHz | 5.10 | Focal arm64 | 6970 | 1906 | 1145030 | 2450 | **6190** | 11.36 |
| [NanoPi NEO4 (RK3399)](results/1p3T.txt) | 2000/1500 MHz | 4.19 | Stretch arm64 | 6750 | 1814 | 1139850 | 2370 | **6110** | 8.84 |
| [Quartz64-A (RK3566)](results/4qJF.txt) | 1890 MHz | 6.2 | Jammy arm64 | 4980 | 1457 | 884590 | 3240 | **6100** | 6.98 |
| [Orange Pi Zero 3 (Allwinner H618)](results/4CPF.txt) | 1510 MHz | 6.1 | Jammy arm64 | 4020 | 1165 | 705330 | 1510 | **6010** | 6.02 |
| [Orange Pi Zero 2W (Allwinner H618)](results/4Hd0.txt) | 1510 MHz | 6.1 | Jammy arm64 | 3920 | 1167 | 705660 | 1510 | **6010** | 6.02 |
| [Ryzen R1606G](results/2tQQ.txt) | 2600/1400 MHz | 5.4 | Focal amd64 | 7970 | 2854 | 700780 | 8230 | **5970** | 16.45 |
| [NanoPi R5S (RK3568)](results/4jfZ.txt) | 1960 MHz | 6.1 | Bullseye arm64 | 5030 | 1482 | 914340 | 2990 | **5970** | 7.33 |
| [Hugsun X99 (RK3399)](results/2ICt.txt) | 2088/1800 MHz | 5.9 | Focal arm64 | 7710 | 1927 | 1184306 | 2270 | **5970** | - |
| [ODROID-M1 (RK3568)](results/4ijy.txt) | 2060 MHz | 5.18 | Bullseye arm64 | 5430 | 1567 | 961090 | 3310 | **5960** | 7.76 |
| [Celeron J4125](results/4hau.txt) | 2700/2000 MHz | 5.15 | Jammy amd64 | 7620 | 2367 | 751360 | 5110 | **5960** | 18.30 |
| [Khadas VIM2 (Amlogic S912)](results/1iJ7.txt) | 1415/1000 MHz | 4.17 | Bionic arm64 | 5450 | 993 | 659600 | 1920 | **5920** | 8.59 |
| [Khadas VIM1 (Amlogic S905X)](results/4bee.txt) | 1415 MHz | 5.1 | Buster arm64 | 3860 | 1136 | 660160 | 1940 | **5900** | - |
| [Rock64 (RK3328)](results/1iHB.txt) | 1300 MHz | 4.18 | Stretch arm64 | 3560 | 1002 | 603800 | 1340 | **5770** | 3.80 |
| [Rock64 (RK3328)](results/1iH4.txt) | 1300 MHz | 4.18 | Bionic arm64 | 3530 | 996 | 605250 | 1340 | **5770** | 4.65 |
| [Le Potato (Amlogic S905X)](results/1iSQ.txt) | 1410 MHz | 4.18 | Stretch arm64 | 3780 | 1057 | 657200 | 1810 | **5730** | 3.92 |
| [Rock64 (RK3328)](results/1iFm.txt) | 1400 MHz | 4.4 | Stretch arm64 | 3610 | 1034 | 644250 | 1330 | **5700** | 3.85 |
| [Celeron N3350](results/4rJj.txt) | 2400 MHz | 6.0 | Bullseye amd64 | 3810 | 2034 | 446170 | 5190 | **5700** | - |
| [Rock64 (RK3328)](results/1iYK.txt) | 1400 MHz | 4.4 | Stretch arm64 | 3580 | 1032 | 644380 | 1330 | **5680** | 4.63 |
| [Rock64 (RK3328)](results/1iHo.txt) | 1300 MHz | 4.4 | Stretch arm64 | 3430 | 952 | 601000 | 1350 | **5680** | 3.64 |
| [Rock64 (RK3328)](results/1iGW.txt) | 1300 MHz | 4.4 | Bionic arm64 | 3410 | 945 | 601200 | 1310 | **5680** | 4.46 |
| [Rock64 (RK3328)](results/1iZj.txt) | 1400 MHz | 4.4 | Stretch arm64 | 3590 | 1030 | 643700 | 1320 | **5640** | 4.40 |
| [PineH64 (Allwinner H6)](results/26Ph.txt) | 1800 MHz | 5.4 | Buster arm64 | 4710 | 1293 | 839870 | 1420 | **5560** | 7.10 |
| [PineH64 (Allwinner H6)](results/1jEr.txt) | 1800 MHz | 4.18 | Stretch arm64 | 4650 | 1274 | 836900 | 1380 | **5530** | 5.62 |
| [Celeron N4020](results/4vNB.txt) | 2800 MHz | 5.15 | Bookworm amd64 | 4680 | 2577 | 780770 | 5480 | **5390** | - |
| [Radxa Zero (S905Y2)](results/3wZn.txt) | 1800 MHz | 5.10 | Focal arm64 | 4610 | 1267 | 840080 | 1600 | **5370** | - |
| [Radxa Zero (S905Y2)](results/3JCm.txt) | 1800 MHz | 5.10 | Bullseye arm64 | 4580 | 1353 | 838360 | 1600 | **5360** | 7.13 |
| [Radxa Zero (S905Y2)](results/3PlT.txt) | 1800 MHz | 5.10 | Buster arm64 | 4570 | 1373 | 839080 | 1610 | **5250** | 6.82 |
| [Celeron N4100](results/1uTS.txt) | 2300/1100 MHz | 4.15 | Bionic amd64 | 8510 | 2222 | 669350 | 4750 | **5240** | 18.33 |
| [Pentium J4205](results/1m5t.txt) | 2560/1500 MHz | 4.17 | Stretch amd64 | 7570 | 2146 | 480640 | 5070 | **5170** | 18.82 |
| [Libre Computer AML-S912-PC](results/40cj.txt) | 1415/1000 MHz | 5.15 | Bullseye arm64 | 5980 | 1012 | 659290 | 1650 | **5170** | - |
| [ODROID-HC4 (S905X3)](results/3Na5.txt) | 2100 MHz | 5.10 | Buster arm64 | 5730 | 1672 | 980970 | 3540 | **5150** | - |
| [ODROID-C4 (S905X3)](results/3TQ2.txt) | 2100 MHz | 5.10 | Buster arm64 | 5770 | 1679 | 981940 | 3540 | **5150** | - |
| [AMedia X96 Max+ (S905X3)](results/3QOj.txt) | 2100 MHz | 5.15 | Focal arm64 | 5270 | 1330 | 981830 | 2630 | **5150** | - |
| [Khadas VIM3L (S905D3)](results/3Vdt.txt) | 1900 MHz | 5.16 | Bullseye arm64 | 5110 | 1403 | 890730 | 3700 | **5140** | - |
| [Clearfog A1<br />(Armada 388)](results/4d1U.txt) | 1600 MHz | 5.15 | Bullseye armhf | 2230 | 1239 | 44080 | 910 | **5060** | - |
| [Pentium N4200](results/1ngq.txt) | 2560/1100 MHz | 4.14 | Bionic amd64 | 7469 | 1976 | 468008 | 4682 | **4997** | 18.75 |
| [ODROID-XU4 (Exynos 5422)](results/3GnC.txt) | 2000/1400 MHz | 5.4 | Focal armhf | 8980 | 1604 | 72020 | 2280 | **4910** | - |
| [NanoPC T4 (RK3399)](results/1lkG.txt) | 2000/1500 MHz | 4.4 | Stretch arm64 | 5870 | 1336 | 1124040 | 2810 | **4890** | 8.70 |
| [Khadas Edge (RK3399)](results/1uar.txt) | 2000/1500 MHz | 4.4 | Stretch arm64 | 6600 | 1703 | 1127780 | 2860 | **4880** | 8.85 |
| [Khadas Edge (RK3399)](results/1rYm.txt) | 2000/1500 MHz | 4.4 | Bionic arm64 | 6550 | 1721 | 1130400 | 2810 | **4860** | 10.50 |
| [RockPro64 (RK3399)](results/1lBC.txt) | 1800/1400 MHz | 4.4 | Stretch arm64 | 6140 | 1580 | 1015600 | 2770 | **4850** | 8.14 |
| [ODROID-XU4 (Exynos 5422)](results/1iWL.txt) | 2000/1400 MHz | 4.9 | Stretch armhf | 6400 | 1622 | 72075 | 2230 | **4850** | - |
| [Helios4<br />(Armada 388)](results/1jCy.txt) | 1600 MHz | 4.14 | Stretch armhf | 2210 | 1215 | 42500 &ast;98560 | 910 | **4840** | - |
| [Atom E3950](results/4dd5.txt) | 2000 MHz | 5.15 | Jammy amd64 | 6440 | 1636 | 374800 | 4400 | **4840** | - |
| [RockPro64 (RK3399)](results/1iFZ.txt) | 1800/1400 MHz | 4.4 | Stretch armhf | 6250 | 1809 | 1000150 | 2000 | **4835** | - |
| [ODROID-XU4 (Exynos 5422)](results/1ixL.txt) | 1900/1400 MHz | 3.10 | Jessie armhf | 6750 | - | 68200 | 2200 | **4800** | - |
| [NanoPi NEO4 (RK3399)](results/1oim.txt) | 2000/1500 MHz | 4.4| Stretch arm64 | 6520 | 1718 | 1123190 | 2280 | **4770** | 8.83 |
| [NanoPi NEO4 (RK3399)](results/1oib.txt) | 2000/1500 MHz | 4.4| Stretch arm64 | 6030 | 1343 | 1121380 | 2230 | **4770** | 8.57 |
| [NanoPi NEO4 (RK3399)](results/1oho.txt) | 2000/1500 MHz | 4.4| Stretch arm64 | 6510 | 1703 | 1128860 | 2260 | **4770** | 8.71 |
| [Milk-V Pioneer (SG2042)](results/4wYE.txt) | 2000 MHz | 6.1 | Kinetic riscv64 | 59820 | 1622 | 43500 | 3620 | **4760** | - |
| [NanoPi Fire3 (Nexell S5P6818)](results/1jjm.txt) | 1400 MHz | 4.14 | Bionic arm64 | 7440 | 1052 | 653000 | 1560 | **4600** | 10.96 |
| [NanoPi Fire3 (Nexell S5P6818)](results/3ZxU.txt) | 1400 MHz | 4.14 | Focal arm64 | 7350 | 1093 | 652640 | 1530 | **4590** | 11.18 |
| [NanoPi Fire3 (Nexell S5P6818)](results/1jiU.txt) | 1380 MHz | 4.14 | Stretch arm64 | 7420 | 1038 | 645400 | 1520 | **4570** | 8.53 |
| [NanoPC T3+ (Nexell S5P6818)](results/1iRJ.txt) | 1400 MHz | 4.14 | Bionic arm64 | 7480 | 1053 | 652600 | 1440 | **4540** | 10.99 |
| [BPi M4 (RTD1395)](results/1Dt1.txt) | 1400 MHz | 4.9 | Bionic arm64 | 3500 | - | 651460 | 1010 | **4360** | 5.48 |
| [TinkerBoard S (RK3288)](results/4vfU.txt) | 1800 MHz | 6.1 | Jammy armhf | 5560 | 1672 | 65800 | 1540 | **4150** | - |
| [Tinkerboard (RK3288)](results/3X9q.txt) | 1800 MHz | 5.10 | Buster armhf | 5770 | 1713 | 67060 | 1540 | **4110** | - |
| [Celeron J3455](results/1m5p.txt) | 2300/1500 MHz | 4.17 | Stretch amd64 | 7000 | 2037 | 429660 | 4090 | **4050** | 17.26 |
| [Tinkerboard (RK3288)](results/1iSX.txt) | 1730 MHz | 4.14 | Stretch armhf | 5350 | 1563 | 66600 | 1480 | **3900** | - |
| [NanoPi K2 (Amlogic S905)](results/1iT1.txt) | 1480 MHz | 4.14 | Stretch arm64 | 3850 | 1095 | 50370 | 1660 | **3870** | 4.61 |
| [Athlon II X3 420e](results/4eOo.txt) | 2600 MHz | 4.19 | Buster amd64 | 4780 | 2566 | 98840 | 4120 | **3870** | - |
| [NanoPi K2 (Amlogic S905)](results/3Qve.txt) | 1480 MHz | 5.10 | Bullseye arm64 | 3880 | 1154 | 51490 | 1850 | **3790** | - |
| [NanoPC T3+ (Nexell S5P6818)](results/1iyp.txt) | 1400 MHz | 4.4 | Xenial armhf | 6400 | 943 | 651000 | 1650 | **3700** | - |
| [Orange Pi PC 2 (Allwinner H5)](results/3MQJ.txt) | 1370 MHz | 5.10 | Focal arm64 | 3500 | 1023 | 637410 | 1070 | **3680** | - |
| [NanoPi K1 Plus (Allwinner H5)](results/3N7H.txt) | 1370 MHz | 5.10 | Focal arm64 | 3520 | 1022 | 638880 | 1070 | **3680** | 5.50 |
| [Nintendo Switch (Tegra X1)](results/3Di2.txt) | 2060 MHz | 4.9 | Bionic arm64 | 6720 | 1901 | 746680 | 2370 | **3670** | 9.25 |
| [Rock64 (RK3328)](results/1iwz.txt) | 1400 MHz | 4.4 | Stretch armhf | 3620 | 1006 | 624000 | 1430 | **3620** | - |
| [x7-Z8700](results/4iDX.txt) | 2400 MHz | 5.15 | Bullseye amd64 | 6580 | 1784 | 296680 | 3510 | **3580** | - |
| [Nintendo Switch (Tegra X1)](results/1Rnj.txt) | 1780 MHz | 4.9 | Fedora 30 arm-64 | 6170 | 1719 | 642670 | 2500 | **3570** | - |
| [Orange Pi Prime (Allwinner H5)](results/2kTH.txt) | 1370 MHz | 5.4 | Buster | 3590 | 984 | 637980 | 1180 | **3540** | - |
| [Celeron N2830](results/4pEc.txt) | 2160 MHz | 5.19 | Jammy amd64 | 2760 | 1664 | 31270 | 3780 | **3520** | 6.10 |
| [Tinkerboard (RK3288)](results/3Lir.txt) | 1800 MHz | 4.4 | Buster armhf | 5440 | 1693 | 66300 | 1340 | **3510** | - |
| [Orange Pi PC+ (Allwinner H3)](results/3MQV.txt) | 1370 MHz | 5.10 | Focal armhf | 3060 | 879 | 26590 | 890 | **3450** | - |
| [NanoPi M1 Plus (Allwinner H3)](results/3N2z.txt) | 1370 MHz | 4.19 | Bionic armhf | 3030 | 881 | 26660 | 830 | **3450** | - |
| [Tronsmart MXIII Plus (S812)](results/3S5U.txt) | 1560 MHz | 5.10 | Buster armhf | 3880 | 1113 | 42570 | 1470 | **3430** | - |
| [Raspberry Pi 4 B (BCM2711)](results/3EgS.txt) | 1500 MHz | 5.10 | Raspberry Pi OS Buster | 5750 | 1661 | 64930 | 2550 | **3430** | - |
| [Celeron J1900](results/4hKV.txt) | 2415/1333 MHz | 5.4 | Focal amd64 | 6560 | 1806 | 34900 | 3780 | **3390** | - |
| [Akaso M8S (S812)](results/3R3N.txt) | 1200 MHz | 5.10 | Buster armhf | 3050 | 885 | 32120 | 1160 | **3330** | - |
| [MT6580 K9M1](results/466y.txt) | 1300 MHz | 5.19 | Sid armhf | 2930 | 860 | 25300 | 1250 | **3300** | - |
| [Orange Pi Plus 2 (Allwinner H3)](results/1iX4.txt) | 1300 MHz | 4.14 | Stretch armhf | 2890 | 812 | 25250 | 830 | **3240** | - |
| [BPi R2 (MT7623)](results/4dO7.txt) | 1300 MHz | 4.19 | Focal armhf | 2990 | 854 | 25260 | 1550 | **3220** | - |
| [Tronsmart S82 (Amlogic S802)](results/41ML.txt) | 1600 MHz | 5.14 | Focal armhf | 3640 | 1114 | 43150 | 500 | **3200** | - |
| [SBC2D70 (SSD202D)](results/3N1U.txt) | 1700 MHz | 5.16 | Sid armhf | 1960 | 1094 | 33120 | 770 | **3190** | - |
| [Raspberry Pi 4 B (BCM2711)](results/1MFf.txt) | 1500 MHz | 4.19 | Raspbian Buster | 5500 | 1606 | 64860 | 2460 | **3170** | - |
| [x5-Z8350](results/1HnC.txt) | 1920/1680 MHz | 4.15 | Bionic amd64 | 4710 | 1272 | 207640 | 2740 | **3140** | - |
| [Raspberry Pi 4 B (BCM2711)](results/3OBF.txt) | 1800 MHz | 5.10 | Raspberry Pi OS Bullseye arm64 | 5790 | 1769 | 36260 | 2330 | **3120** | 8.74 |
| [Raspberry Pi 4 B (BCM2711)](results/3F9C.txt) | 1800 MHz | 5.10 | Raspberry Pi OS Buster arm64 | 5760 | 1741 | 36240 | 2240 | **3120** | 9.46 |
| [Raspberry Pi 400 (BCM2711)](results/2Cyi.txt) | 1800 MHz | 5.4 | Raspberry Pi OS Buster | 6550 | 1903 | 77890 | 2680 | **3110** | - |
| [Raspberry Pi 4 B (BCM2711)](results/3VME.txt) | 1800 MHz | 5.15 | Jammy armhf | 6300 | 1844 | 82750 | 1190 | **3110** | - |
| [Raspberry Pi 4 B (BCM2711)](results/3InF.txt) | 1800 MHz | 5.15 | Armbian Jammy arm64 | 5640 | 1752 | 36260 | 2580 | **3110** | - |
| [Celeron N2807](results/4z3s.txt) | 2165 MHz | 5.10 | Bullseye) amd64 | 3070 | 1766 | 31250 | 3600 | **3110** | 6.09 |
| [ODROID-C2 (Amlogic S905)](results/1ixI.txt) | 1750 MHz | 3.14 | Xenial arm64 | 4070 | 1128 | 48500 | 1750 | **3100** | - |
| [Raspberry Pi 4 B (BCM2711)](results/3Gia.txt) | 1800 MHz | 5.10 | Raspberry Pi OS Buster | 6550 | 1897 | 77830 | 2780 | **3080** | - |
| [BPi M2U (Allwinner R40)](results/4kmM.txt) | 1200 MHz | 6.0 | Bullseye armhf | 2690 | 767 | 23320 | 780 | **3010** | - |
| [TRONFY MXQ (Amlogic S805)](results/3MiR.txt) | 1536 MHz | 5.10 | Focal armhf | 3100 | 897 | 29080 | 980 | **2990** | - |
| [x5-Z8350](results/2Jdb.txt) | 1920/1680 MHz | 5.4 | Focal amd64 | 4790 | 1454 | 237230 | 3170 | **2960** | 9.38 |
| [ODROID-C1 (Amlogic S805)](results/4eg5.txt) | 1500 MHz | 5.19 | Jammy armhf | 3010 | 878 | 29260 | 390 | **2910** | - |
| [Atom E3825](results/4kFQ.txt) | 1330 MHz | 5.10 | Bullseye amd64 | 1950 | 1109 | 165840 | 2890 | **2890** | - |
| [Atom N270](results/461n.txt) | 1600 MHz | 4.19 | Buster i386 | 1220 | 824 | 18760 | 1420 | **2840** | - |
| [Teres-I<br />(Allwinner A64)](results/1tJg.txt) | 1050 MHz | 4.19 | Stretch arm64 | 2785 | 780 | 491590 | 1080 | **2820** | - |
| [Orange Pi Zero 2 (Allwinner H616)](results/4knM.txt) | 1510 MHz | 4.9 | Buster arm64 | 3550 | 1067 | 703300 | 1190 | **2820** | 5.01 |
| [Atom Z3735F](results/4r54.txt) | 1830 MHz | 5.15 | Jammy amd64 | 4510 | 1437 | 227900 | 3020 | **2780** | - |
| [Atom E3826](results/44pd.txt) | 1460 MHz | 5.18 | Jammy amd64 | 2140 | 1112 | 182190 | 2840 | **2760** | - |
| [Raspberry Pi 4 B (BCM2711)](results/3N94.txt) | 1800 MHz | 5.10 | Raspberry Pi OS Bullseye | 5940 | 1738 | 77670 | 2310 | **2690** | - |
| [ClockworkPi R-01 (Allwinner D1)](results/40BJ.txt) | 1000 MHz | 5.4 | Focal riscv64 | 450 | 450 | 9040 | 1220 | **2640** | - |
| [EspressoBin (Armada 3720)](results/1kt2.txt) | 800 MHz | 4.17 | Stretch arm64 | 1138 | 636 | 368330 | 1040 | **2490** | 1.23 |
| [RK3318 BOX](results/4kor.txt) | 1390 MHz | 6.0 | Jammy arm64 | 3200 | 867 | 644750 | 700 | **2460** | - |
| [EspressoBin (Armada 3720)](results/1lCe.txt) | 1200 MHz | 4.18 | Stretch arm64 | 1630 | 869 | 544240 | 1000 | **2400** | 1.82 |
| [x5-Z8300](results/4j4o.txt) | 1840 MHz | 5.15 | Jammy amd64 | 4430 | 1368 | 227030 | 2270 | **2380** | 8.84 |
| [x5-Z8300](results/1lgD.txt) | 1420 MHz | 4.9 | Stretch amd64 | 3900 | 950 | 178010 | 2380 | **2380** | 7.81 |
| [MangoPi Mcore (Allwinner H616)](results/4bSf.txt) | 1800 MHz | 5.19 | Jammy arm64 | 4100 | 1218 | 840270 | 990 | **2380** | - |
| [Raspberry Pi B (BCM2835)](results/4vVG.txt) | 1000 MHz | 6.1 | Raspberry Pi OS Bullseye | 480 | 481 | 16900 | 490 | **2220** | - |
| [Marvell PXA1908](results/46hs.txt) | 1245 MHz | 3.14 | Bullseye arm64 | 3180 | 951 | 581840 | 740 | **2220** | - |
| [Ugoos UT2 (RK3188)](results/408h.txt) | 1560 MHz | 5.10 | Jammy armhf | 3320 | 994 | 43250 | 320 | **2020** | - |
| [Olimex A20-Lime2](results/4rRV.txt) | 960 MHz | 5.10 | Bullseye armhf | 1080 | 589 | 18630 | 430 | **2020** | 0.87 |
| [Banana Pi (Allwinner A20)](results/3PLr.txt) | 960 MHz | 5.10 | Bullseye armhf | 1040 | 542 | 18640 | 440 | **2020** | - |
| [Cubietruck (Allwinner A20)](results/3Naw.txt) | 960 MHz | 5.10 | Bullseye armhf | 1030 | 541 | 18640 | 440 | **2010** | - |
| [Radxa Rock Pi S (RK3308)](results/4sNe.txt) | 1300 MHz | 6.1 | Jammy arm64 | 2540 | 732 | 282030 | 820 | **1870** | - |
| [Raspberry Pi Zero 2 (RP3A0)](results/3DeL.txt) | 1200 MHz | 5.10 | Raspberry Pi OS Buster | 3640 | 1007 | 36300 | 1320 | **1790** | - |
| [Raspberry Pi 3 B+ (BCM2837B0)](results/1iGz.txt) | OC/normal | 4.14 | Raspbian Stretch | 3130 | 843 | 36620 | 1230 | **1780** | - |
| [AMD E-450 APU](results/4hwl.txt) | 1650 MHz | 5.15 | Jammy amd64 | 2430 | 1258 | 27450 | 1710 | **1740** | - |
| [Raspberry Pi 3 B (BCM2837)](results/4hOP.txt) | 1200 MHz | 5.15 | Raspbian Sid | 2970 | 977 | 36230 | 1110 | **1700** | 2.89 |
| [Raspberry Pi Zero (BCM2835)](results/3Njz.txt) | 1000 MHz | 5.10 | Bullseye armv6l/armhf | 460 | 460 | 17060 | 430 | **1670** | - |
| [Raspberry Pi 3 B+ (BCM2837B0)](results/1iI5.txt) | original | 4.9 | Raspbian Stretch | 3600 | 1076 | 42700 | 1230 | **1640** | - |
| [Raspberry Pi 3 B+ (BCM2837B0)](results/1isD.txt) | with fan | 4.14 | Raspbian Stretch | 3670 | 1046 | 42600 | 1120 | **1600** | - |
| [Raspberry Pi Zero (BCM2835)](results/1niO.txt) | 1000 MHz | 4.14 | Raspbian Stretch | 450 | 450 | 16820 | 400 | **1590** | - |
| [Raspberry Pi Zero 2 (RP3A0)](results/3E85.txt) | 1000 MHz | 5.10 | Raspberry Pi OS Buster | 3030 | 838 | 29860 | 1300 | **1570** | - |
| [Atom N2800](results/4nt8.txt) | 1860 MHz | 5.15 | Bullseye amd64 | 2970 | 1006 | 21780 | 2050 | **1570** | - |
| [Raspberry Pi 3 B+ (BCM2837B0)](results/1ism.txt) | normal | 4.14 | Raspbian Stretch | 3240 | 914 | 36600 | 1130 | **1530** | - |
| [Raspberry Pi 3 B+ (BCM2837B0)](results/1iGM.txt) | normal | 4.14 | Raspbian Stretch | 3040 | 856 | 36600 | 1050 | **1500** | - |
| [Raspberry Pi 3 B+ (BCM2837B0)](results/1iH0.txt) | UV/normal | 4.14 | Raspbian Stretch | 2100 | 856 | 36400 | 1040 | **1460** | - |
| [Raspberry Pi B (BCM2835)](results/3MGN.txt) | 700 MHz | 5.10 | Raspberry Pi OS Bullseye | 320 | 320 | 11630 | 360 | **1420** | - |
| [Lime A10 (Allwinner A10)](results/1j1L.txt) | 910 MHz | 4.14 | Stretch armhf | 550 | 550 | 28250 | 440 | **1300** | - |
| [RK3228A TV Box](results/3M9F.txt) | 1200 MHz | 4.4 | Buster armhf | 2310 | 710 | 23070 | 410 | **1230** | - |
| [Raspberry Pi 2 B+ (BCM2836)](results/3MGs.txt) | 900 MHz | 5.10 | Raspberry Pi OS Bullseye | 2150 | 620 | 16500 | 1000 | **1180** | - |
| [Raspberry Pi 2 B+ (BCM2836)](results/1iFf.txt) | 900 MHz | 4.14 | Debian Stretch | 2070 | 592 | 17450 | 615 | **1175** | - |
| [Raspberry Pi Zero 2 (RP3A0)](results/3Dfo.txt) | 600 MHz | 5.10 | Raspberry Pi OS Buster | 1900 | 529 | 18150 | 1040 | **1130** | - |
| [Milk-V Mars CM (JH7110)](results/4K7E.txt) | 1500 MHz | 5.15 | Bookworm riscv64 | 4110 | 1195 | 25070 | 930 | **830** | - |
| [VisionFive V2 (JH7110)](results/4xOY.txt) | 1500 MHz | 5.15 | Sid riscv64 | 4180 | 1197 | 25080 | 880 | **770** | - |
| [Star64 (JH7110)](results/4tjq.txt) | 1500 MHz | 5.15 | Sid riscv64 | 3970 | 1175 | 24990 | 820 | **770** | - |
| [Kendryte K510](results/41Qa.txt) | 790 MHz | 4.17 | Sid riscv64 | 690 | 402 | 7410 | 280 | **440** | - |
| [Cubox-i4<br />(NXP i.MX6)](results/4132.txt) | 980 MHz | 5.15 | Jammy armhf | 2360 | 657 | 27000 | 340 | **340** | - |

[(back to top of the page)](#sbc-bench-results-sorted)

## clockspeed

| Device / details | *Clockspeed* | Kernel | Distro | 7-zip multi | 7-zip single | AES | memcpy | memset | kH/s |
| ----- | :--------: | :----: | :----: | ----: | ------: | ------: | -----: | -----: | ---: |
| [Intel i3-N305](results/4qpr.txt) | **3800** MHz| 5.19 | Jammy amd64 | 20000 | 4398 | 1377280 | 9950 | 8990 | 41.43 |
| [Pentium G4600](results/2jVw.txt) | **3600** MHz| 4.19 | Buster amd64 | 11810 | 4448 | 984820 | 15120 | 33380 | 21.88 |
| [Intel N95](results/4xwq.txt) | **3400** MHz| 5.15 | Jammy amd64 | 13070 | 3993 | 1232880 | 9710 | 8730 | 34.60 |
| [Intel N100](results/4vxM.txt) | **3400** MHz| 6.1 | Lunar amd64 | 14150 | 4073 | 1232790 | 11600 | 12270 | 36.24 |
| [Pentium N6005](results/4BtC.txt) | **3300/2000** MHz| 5.15 | Jammy amd64 | 11510 | 3369 | 923550 | 9650 | 10280 | 22.18 |
| [Ryzen R1505G](results/4HYd.txt) | **3270** MHz| 6.1 | Bookworm amd64 | 9080 | 3327 | 886980 | 10520 | 8160 | 18.14 |
| [Apple M1 Pro](results/443N.txt) | **3030/2060** MHz| 5.18 | Gentoo 2.8 arm64 | 43800 | 5010 | 1064450 | 27110 | 71910 | 48.28 |
| [Raspberry Pi 5 B (BCM2712)](results/4I1w.txt) | **3000** MHz| 6.1 | Bookworm arm64 | 12740 | 3747 | 1710050 | 4940 | 12640 | - |
| [Qualcomm Snapdragon 8cx Gen 3](results/4xwT.txt) | **3000/2440** MHz| 6.3 | Lunar arm64 | 35370 | 4312 | 1686160 | 17500 | 41780 | 42.76 |
| [Huaqin P6410<br />(2 x Ampere Altra Max)](results/4kiu.txt) | **3000** MHz| 5.4 | Focal arm64 | 430860 | 4211 | 1710010 | 13310 | 47970 | - |
| [Hetzner CAX11 (Ampere Altra)](results/4HdL.txt) | **3000** MHz| 5.15 | Jammy arm64 | 8060 | 3842 | 1705600 | 11250 | 47670 | 11.44 |
| [Qualcomm Snapdragon 8cx Gen 3 (WSL2)](results/4kEp.txt) | **2980/?** MHz| 5.15 | Jammy arm64 | 33600 | 4789 | 1679480 | 21010 | 41540 | 50.65 |
| [Celeron N5105](results/3Qf7.txt) | **2900/2000** MHz| 5.13 | Focal amd64 | 11450 | 3059 | 811760 | 7710 | 9290 | 21.79 |
| [Qualcomm QRB5165](results/49kx.txt) | **2840/2410/1790** MHz| 4.19 | Focal arm64 | 18860 | 3898 | 1598490 | 14470 | 23910 | 25.56 |
| [Celeron N5100](results/3IlQ.txt) | **2800/1100** MHz| 5.13 | Focal amd64 | 10550 | 3088 | 783800 | 7750 | 8090 | 19.22 |
| [Celeron N4500](results/3HUU.txt) | **2800/1100** MHz| 5.13 | Impish amd64 | 6300 | 3091 | 783840 | 8100 | 8350 | - |
| [Celeron N4020](results/4vNB.txt) | **2800** MHz| 5.15 | Bookworm amd64 | 4680 | 2577 | 780770 | 5480 | 5390 | - |
| [Ampere Altra M96-28](results/4zGI.txt) | **2800** MHz| 5.15 | Jammy arm64 | 249380 | 3858 | 1596110 | 10130 | 44750 | - |
| [Pentium J5005](results/21rE.txt) | **2700/1500** MHz| 5.0 | Bionic amd64 | 9230 | 2455 | 778360 | 5530 | 7130 | 20.74 |
| [Celeron J4125](results/4hau.txt) | **2700/2000** MHz| 5.15 | Jammy amd64 | 7620 | 2367 | 751360 | 5110 | 5960 | 18.30 |
| [Ryzen R1606G](results/2tQQ.txt) | **2600/1400** MHz| 5.4 | Focal amd64 | 7970 | 2854 | 700780 | 8230 | 5970 | 16.45 |
| [Phytium<br />FT-2000/4<br />(1 x SO-DIMM)](results/4ioj.txt) | **2600** MHz| 5.15 | Bullseye arm64 | 10020 | 2755 | 936740 | 3760 | 14540 | - |
| [Athlon II X3 420e](results/4eOo.txt) | **2600** MHz| 4.19 | Buster amd64 | 4780 | 2566 | 98840 | 4120 | 3870 | - |
| [Ampere Altra Q80-26](results/4zkJ.txt) | **2600** MHz| 5.15 | Jammy arm64 | 214390 | 3748 | 1482190 | 11685 | 41560 | 316.50 |
| [Pentium N4200](results/1ngq.txt) | **2560/1100** MHz| 4.14 | Bionic amd64 | 7469 | 1976 | 468008 | 4682 | 4997 | 18.75 |
| [Pentium J4205](results/1m5t.txt) | **2560/1500** MHz| 4.17 | Stretch amd64 | 7570 | 2146 | 480640 | 5070 | 5170 | 18.82 |
| [Qualcomm Snapdragon 7c](results/4Lyf.txt) | **2550/1800** MHz| 6.6 | Bookworm arm64 | 13040 | 3113 | 1455700 | 6710 | 14880 | - |
| [Loongson-3A5000-HV](results/4dzX.txt) | **2500** MHz| 4.19 | Loongnix 20 loongarch64 | 11120 | 2990 | 116900 | 6930 | 19170 | - |
| [Celeron J1900](results/4hKV.txt) | **2415/1333** MHz| 5.4 | Focal amd64 | 6560 | 1806 | 34900 | 3780 | 3390 | - |
| [x7-Z8700](results/4iDX.txt) | **2400** MHz| 5.15 | Bullseye amd64 | 6580 | 1784 | 296680 | 3510 | 3580 | - |
| [Raspberry Pi 5 B (BCM2712)](results/4HDw.txt) | **2400** MHz| 6.1 | Bookworm arm64 | 10950 | 3160 | 1367990 | 5260 | 11520 | 15.42 |
| [Orange Pi 5 (RK3588)](results/4D0a.txt) | **2400/1800** MHz| 5.10 | Jammy arm64 | 16780 | 2689 | 1366590 | 12800 | 29900 | - |
| [ODROID-N2+ (Amlogic S922X)](results/4rWn.txt) | **2400/2015** MHz| 6.1 | Bullseye arm64 | 9710 | 2373 | 1366180 | 4220 | 7720 | - |
| [ODROID-N2+ (Amlogic S922X)](results/3R1a.txt) | **2400/2015** MHz| 5.10 | Focal arm64 | 9680 | 2372 | 1366730 | 4030 | 7120 | - |
| [ODROID-N2+ (Amlogic S922X)](results/3DtN.txt) | **2400/2015** MHz| 5.14 | Impish arm64 | 9790 | 2253 | 1366930 | 4300 | 7480 | - |
| [Khadas VIM3 (Amlogic A311D)](results/4o1A.txt) | **2400/2015** MHz| 6.0 | Bullseye arm64 | 9650 | 2379 | 1366300 | 5080 | 9240 | - |
| [Khadas VIM3 (Amlogic A311D)](results/3R2Z.txt) | **2400/2015** MHz| 5.10 | Bullseye arm64 | 9650 | 2376 | 1366350 | 4850 | 7380 | - |
| [Celeron N3350](results/4rJj.txt) | **2400** MHz| 6.0 | Bullseye amd64 | 3810 | 2034 | 446170 | 5190 | 5700 | - |
| [Celeron J4105](results/1qb0.txt) | **2400/1500** MHz| 4.15 | Bionic amd64 | 8960 | 2274 | 697080 | 5620 | 7650 | 19.13 |
| [Celeron J4105](results/1qal.txt) | **2400/1500** MHz| 4.15 | Bionic amd64 | 9020 | 2290 | 697100 | 5500 | 7410 | 19.07 |
| [Qualcomm Snapdragon 835](results/4fdD.txt) | **2360/1900** MHz| 6.1 | Jammy arm64 | 9800 | 2474 | 883330 | 9720 | 14070 | 12.58 |
| [Radxa ROCK 5B (RK3588)](results/41BH.txt) | **2350/1830** MHz| 5.10 | Focal arm64 | 16450 | 3146 | 1337540 | 10830 | 29220 | 25.31 |
| [Phytium D2000<br />(2 x SO-DIMM)](results/446h.txt) | **2300** MHz| 5.19 | Jammy arm64 | 16670 | 2252 | 828130 | 3480 | 16110 | - |
| [Phytium D2000<br />(1 x SO-DIMM)](results/445T.txt) | **2300** MHz| 5.19 | Jammy arm64 | 16390 | 2220 | 827090 | 2820 | 6490 | - |
| [Celeron N4100](results/1uTS.txt) | **2300/1100** MHz| 4.15 | Bionic amd64 | 8510 | 2222 | 669350 | 4750 | 5240 | 18.33 |
| [Celeron J3455](results/1m5p.txt) | **2300/1500** MHz| 4.17 | Stretch amd64 | 7000 | 2037 | 429660 | 4090 | 4050 | 17.26 |
| [Amazon a1.xlarge](results/2iFY.txt) | **2300** MHz| 4.15 | Bionic arm64 | 8610 | 2406 | 1297960 | 4280 | 14220 | - |
| [Khadas Edge2 (RK3588s)](results/4a5U.txt) | **2260/1800** MHz| 5.10 | Jammy arm64 | 16470 | 3096 | 1287490 | 10860 | 29110 | - |
| [Jetson Xavier AGX](results/4ebH.txt) | **2250** MHz| 4.9 | Bionic arm64 | 21590 | 2742 | 853250 | 10910 | 22520 | 26.57 |
| [MT8395 Genio 1200](results/4Kvg.txt) | **2200/2000** MHz| 5.15 | Jammy arm64 | 18130 | 3298 | 1240850 | 14200 | 19000 | 27.60 |
| [Khadas VIM4 (A311D2)](results/4cHh.txt) | **2200/2010** MHz| 5.4 | Jammy arm64 | 12120 | 2067 | 1254540 | 8180 | 11680 | - |
| [Khadas VIM4 (A311D2)](results/3Wvv.txt) | **2200/1970** MHz| 5.4 | Focal arm64 | 12090 | 2081 | 1253200 | 7810 | 11600 | - |
| [Khadas VIM3 (Amlogic A311D)](results/1MFD.txt) | **2200/1800** MHz| 4.9 | Bionic arm64 | 8600 | 2026 | 1256910 | 4980 | 9300 | 13.12 |
| [Jetson AGX Orin](results/4ax9.txt) | **2200** MHz| 5.10 | Focal arm64 | 39450 | 3187 | 1242940 | 10600 | 30350 | 59.96 |
| [Honeycomb LX2 (NXP LX2160A)](results/3Y4f.txt) | **2200** MHz| 5.16 | Fedora 35 aarch64 | 30690 | 2288 | 1251710 | 5050 | 16220 | 46.09 |
| [Celeron N2807](results/4z3s.txt) | **2165** MHz| 5.10 | Bullseye) amd64 | 3070 | 1766 | 31250 | 3600 | 3110 | 6.09 |
| [Celeron N2830](results/4pEc.txt) | **2160** MHz| 5.19 | Jammy amd64 | 2760 | 1664 | 31270 | 3780 | 3520 | 6.10 |
| [ODROID-HC4 (S905X3)](results/3Na5.txt) | **2100** MHz| 5.10 | Buster arm64 | 5730 | 1672 | 980970 | 3540 | 5150 | - |
| [ODROID-C4 (S905X3)](results/3TQ2.txt) | **2100** MHz| 5.10 | Buster arm64 | 5770 | 1679 | 981940 | 3540 | 5150 | - |
| [AMedia X96 Max+ (S905X3)](results/3QOj.txt) | **2100** MHz| 5.15 | Focal arm64 | 5270 | 1330 | 981830 | 2630 | 5150 | - |
| [Hugsun X99 (RK3399)](results/2ICt.txt) | **2088/1800** MHz| 5.9 | Focal arm64 | 7710 | 1927 | 1184306 | 2270 | 5970 | - |
| [ODROID-M1 (RK3568)](results/4ijy.txt) | **2060** MHz| 5.18 | Bullseye arm64 | 5430 | 1567 | 961090 | 3310 | 5960 | 7.76 |
| [Nintendo Switch (Tegra X1)](results/3Di2.txt) | **2060** MHz| 4.9 | Bionic arm64 | 6720 | 1901 | 746680 | 2370 | 3670 | 9.25 |
| [NanoPi NEO4 (RK3399)](results/3GmR.txt) | **2016/1512** MHz| 5.10 | Focal arm64 | 6970 | 1906 | 1145030 | 2450 | 6190 | 11.36 |
| [NanoPi M4v2 (RK3399)](results/3MAK.txt) | **2015/1510** MHz| 5.10 | Bullseye arm64 | 6680 | 1855 | 921980 | 3110 | 7640 | - |
| [RockPro64 (RK3399)](results/2yIx.txt) | **2010/1510** MHz| 5.8 | Bullseye arm64 | 7000 | 1833 | 1144950 | 3690 | 8360 | 11.08 |
| [RockPro64 (RK3399)](results/2sZH.txt) | **2010/1510** MHz| 5.4 | Focal arm64 | 6920 | 1826 | 1145300 | 3700 | 8430 | 11.55 |
| [OrangePi 4 (RK3399)](results/4Kau.txt) | **2010/1510** MHz| 6.1 | Bookworm arm64 | 6880 | 1891 | 1145840 | 3490 | 8430 | - |
| [ODROID-C4 (S905X3)](results/2kaS.txt) | **2010** MHz| 4.9 | Focal arm64 | 5450 | 1459 | 941590 | 3310 | 6270 | 7.71 |
| [Radxa Rock Pi 4 (RK3399)](results/3Q2q.txt) | **2000/1500** MHz| 5.10 | Focal arm64 | 6900 | 1899 | 1146500 | 3430 | 8260 | - |
| [Radxa Rock Pi 4 (RK3399)](results/21fX.txt) | **2000/1500** MHz| 5.3 | Bionic arm64 | 6910 | 1817 | 1147370 | 3660 | 8310 | 10.71 |
| [Radxa ROCK 3A (RK3568)](results/40TX.txt) | **2000** MHz| 5.18 | Bullseye arm64 | 5110 | 1450 | 935920 | 3150 | 6250 | 7.58 |
| [ODROID-XU4 (Exynos 5422)](results/3GnC.txt) | **2000/1400** MHz| 5.4 | Focal armhf | 8980 | 1604 | 72020 | 2280 | 4910 | - |
| [ODROID-XU4 (Exynos 5422)](results/1iWL.txt) | **2000/1400** MHz| 4.9 | Stretch armhf | 6400 | 1622 | 72075 | 2230 | 4850 | - |
| [ODROID-N2 (Amlogic S922X)](results/3MuT.txt) | **2000/1900** MHz| 5.10 | Buster arm64 | 9090 | 2012 | 1085350 | 4260 | 9080 | - |
| [NanoPi NEO4 (RK3399)](results/1p3T.txt) | **2000/1500** MHz| 4.19 | Stretch arm64 | 6750 | 1814 | 1139850 | 2370 | 6110 | 8.84 |
| [NanoPi NEO4 (RK3399)](results/1oim.txt) | **2000/1500** MHz| 4.4| Stretch arm64 | 6520 | 1718 | 1123190 | 2280 | 4770 | 8.83 |
| [NanoPi NEO4 (RK3399)](results/1oib.txt) | **2000/1500** MHz| 4.4| Stretch arm64 | 6030 | 1343 | 1121380 | 2230 | 4770 | 8.57 |
| [NanoPi NEO4 (RK3399)](results/1oho.txt) | **2000/1500** MHz| 4.4| Stretch arm64 | 6510 | 1703 | 1128860 | 2260 | 4770 | 8.71 |
| [NanoPi M4 (RK3399)](results/1lzP.txt) | **2000/1500** MHz| 4.19 | Stretch arm64 | 6400 | 1835 | 1128330 | 4080 | 8270 | 8.86 |
| [NanoPC T4 (RK3399)](results/1lkG.txt) | **2000/1500** MHz| 4.4 | Stretch arm64 | 5870 | 1336 | 1124040 | 2810 | 4890 | 8.70 |
| [Milk-V Pioneer (SG2042)](results/4wYE.txt) | **2000** MHz| 6.1 | Kinetic riscv64 | 59820 | 1622 | 43500 | 3620 | 4760 | - |
| [Khadas VIM1S (S905Y4)](results/4bbv.txt) | **2000** MHz| 5.4 | Jammy arm64 | 4000 | 1148 | 436540 | 1970 | 7530 | - |
| [Khadas Edge (RK3399)](results/1uar.txt) | **2000/1500** MHz| 4.4 | Stretch arm64 | 6600 | 1703 | 1127780 | 2860 | 4880 | 8.85 |
| [Khadas Edge (RK3399)](results/1rYm.txt) | **2000/1500** MHz| 4.4 | Bionic arm64 | 6550 | 1721 | 1130400 | 2810 | 4860 | 10.50 |
| [Jetson Nano](results/3Ufc.txt) | **2000** MHz| 4.9 | Bionic arm64 | 6260 | 1977 | 717500 | 4100 | 11760 | 8.72 |
| [Clearfog CX (NXP LX2160A)](results/4ju5.txt) | **2000** MHz| 5.10 | Focal arm64 | 25260 | 2236 | 1136690 | 4460 | 12500 | - |
| [BeagleBone AI-64 (TI J721E)](results/4DLw.txt) | **2000** MHz| 5.10 | Bookworm arm64 | 3470 | 1872 | 1130390 | 2660 | 8710 | - |
| [Atom E3950](results/4dd5.txt) | **2000** MHz| 5.15 | Jammy amd64 | 6440 | 1636 | 374800 | 4400 | 4840 | - |
| [AMD Seattle (Opteron A1100)](results/4Kqn.txt) | **2000** MHz| 4.15 | Bionic arm64 | 14080 | 2006 | 720710 | 3020 | 9530 | - |
| [Lichee Pi 4A (T-Head TH1520)](results/4xYE.txt) | **1990** MHz| 5.10 | Bookworm riscv64 | 5260 | 1592 | 43820 | 4350 | 14760 | - |
| [RK3568-ROC-PC](results/3Rsg.txt) | **1960** MHz| 4.19 | Bullseye arm64 | 5040 | 1424 | 912800 | 3130 | 6240 | - |
| [NanoPi R5S (RK3568)](results/4jfZ.txt) | **1960** MHz| 6.1 | Bullseye arm64 | 5030 | 1482 | 914340 | 2990 | 5970 | 7.33 |
| [ODROID-M1 (RK3568)](results/3Ug9.txt) | **1930** MHz| 4.19 | Focal arm64 | 5010 | 1450 | 898610 | 3070 | 6220 | 7.14 |
| [x5-Z8350](results/2Jdb.txt) | **1920/1680** MHz| 5.4 | Focal amd64 | 4790 | 1454 | 237230 | 3170 | 2960 | 9.38 |
| [x5-Z8350](results/1HnC.txt) | **1920/1680** MHz| 4.15 | Bionic amd64 | 4710 | 1272 | 207640 | 2740 | 3140 | - |
| [ODROID-XU4 (Exynos 5422)](results/1ixL.txt) | **1900/1400** MHz| 3.10 | Jessie armhf | 6750 | - | 68200 | 2200 | 4800 | - |
| [Khadas VIM3L (S905D3)](results/3Vdt.txt) | **1900** MHz| 5.16 | Bullseye arm64 | 5110 | 1403 | 890730 | 3700 | 5140 | - |
| [Khadas VIM3L (S905D3)](results/26Wy.txt) | **1900** MHz| 4.9 | Bionic arm64 | 5160 | 1399 | 892110 | 3670 | 6360 | 7.29 |
| [Celeron 5205U](results/4eiM.txt) | **1900** MHz| 5.15 | Jammy amd64 | 4060 | 2171 | 521090 | 7350 | 16020 | 11.20 |
| [Quartz64-A (RK3566)](results/4qJF.txt) | **1890** MHz| 6.2 | Jammy arm64 | 4980 | 1457 | 884590 | 3240 | 6100 | 6.98 |
| [Jetson Xavier NX](results/3YWp.txt) | **1890** MHz| 4.9 | Bionic arm64 | 13230 | 2201 | 706280 | 9190 | 18480 | - |
| [Atom N2800](results/4nt8.txt) | **1860** MHz| 5.15 | Bullseye amd64 | 2970 | 1006 | 21780 | 2050 | 1570 | - |
| [x5-Z8300](results/4j4o.txt) | **1840** MHz| 5.15 | Jammy amd64 | 4430 | 1368 | 227030 | 2270 | 2380 | 8.84 |
| [Atom Z3735F](results/4r54.txt) | **1830** MHz| 5.15 | Jammy amd64 | 4510 | 1437 | 227900 | 3020 | 2780 | - |
| [Quartz64-A (RK3566)](results/3rUb.txt) | **1810** MHz| 5.13 | Buster arm64 | 4840 | 1353 | 845490 | 2980 | 7650| - |
| [i.MX8MPlus EVK](results/4hx0.txt) | **1800** MHz| 5.15 | Focal arm64 | 4990 | 1348 | 837680 | 2740 | 12420 | 7.02 |
| [Tinkerboard (RK3288)](results/3X9q.txt) | **1800** MHz| 5.10 | Buster armhf | 5770 | 1713 | 67060 | 1540 | 4110 | - |
| [Tinkerboard (RK3288)](results/3Lir.txt) | **1800** MHz| 4.4 | Buster armhf | 5440 | 1693 | 66300 | 1340 | 3510 | - |
| [TinkerBoard S (RK3288)](results/4vfU.txt) | **1800** MHz| 6.1 | Jammy armhf | 5560 | 1672 | 65800 | 1540 | 4150 | - |
| [RockPro64 (RK3399)](results/1ub9.txt) | **1800/1400** MHz| 4.4 | Stretch arm64 | 6420 | 1673 | 1018480 | 3720 | 8400 | 8.24 |
| [RockPro64 (RK3399)](results/1lBC.txt) | **1800/1400** MHz| 4.4 | Stretch arm64 | 6140 | 1580 | 1015600 | 2770 | 4850 | 8.14 |
| [RockPro64 (RK3399)](results/1iFp.txt) | **1800/1400** MHz| 4.18 | Stretch arm64 | 6300 | 1755 | 1021500 | 3650 | 8450 | 8.20 |
| [RockPro64 (RK3399)](results/1iFZ.txt) | **1800/1400** MHz| 4.4 | Stretch armhf | 6250 | 1809 | 1000150 | 2000 | 4835 | - |
| [Raspberry Pi 400 (BCM2711)](results/2Cyi.txt) | **1800** MHz| 5.4 | Raspberry Pi OS Buster | 6550 | 1903 | 77890 | 2680 | 3110 | - |
| [Raspberry Pi 4 B (BCM2711)](results/3VME.txt) | **1800** MHz| 5.15 | Jammy armhf | 6300 | 1844 | 82750 | 1190 | 3110 | - |
| [Raspberry Pi 4 B (BCM2711)](results/3OBF.txt) | **1800** MHz| 5.10 | Raspberry Pi OS Bullseye arm64 | 5790 | 1769 | 36260 | 2330 | 3120 | 8.74 |
| [Raspberry Pi 4 B (BCM2711)](results/3N94.txt) | **1800** MHz| 5.10 | Raspberry Pi OS Bullseye | 5940 | 1738 | 77670 | 2310 | 2690 | - |
| [Raspberry Pi 4 B (BCM2711)](results/3InF.txt) | **1800** MHz| 5.15 | Armbian Jammy arm64 | 5640 | 1752 | 36260 | 2580 | 3110 | - |
| [Raspberry Pi 4 B (BCM2711)](results/3Gia.txt) | **1800** MHz| 5.10 | Raspberry Pi OS Buster | 6550 | 1897 | 77830 | 2780 | 3080 | - |
| [Raspberry Pi 4 B (BCM2711)](results/3F9C.txt) | **1800** MHz| 5.10 | Raspberry Pi OS Buster arm64 | 5760 | 1741 | 36240 | 2240 | 3120 | 9.46 |
| [Radxa Zero (S905Y2)](results/3wZn.txt) | **1800** MHz| 5.10 | Focal arm64 | 4610 | 1267 | 840080 | 1600 | 5370 | - |
| [Radxa Zero (S905Y2)](results/3PlT.txt) | **1800** MHz| 5.10 | Buster arm64 | 4570 | 1373 | 839080 | 1610 | 5250 | 6.82 |
| [Radxa Zero (S905Y2)](results/3JCm.txt) | **1800** MHz| 5.10 | Bullseye arm64 | 4580 | 1353 | 838360 | 1600 | 5360 | 7.13 |
| [PineH64 (Allwinner H6)](results/26Ph.txt) | **1800** MHz| 5.4 | Buster arm64 | 4710 | 1293 | 839870 | 1420 | 5560 | 7.10 |
| [PineH64 (Allwinner H6)](results/1jEr.txt) | **1800** MHz| 4.18 | Stretch arm64 | 4650 | 1274 | 836900 | 1380 | 5530 | 5.62 |
| [ODROID-N2 (Amlogic S922X)](results/1BsF.txt) | **1800/1900** MHz| 4.9 | Bionic arm64 | 8140 | 1669 | 1024680 | 4120 | 8610 | 11.39 |
| [NanoPC T4 (RK3399)](results/1iZq.txt) | **1800/1400** MHz| 4.17 | Stretch arm64 | 6380 | 1741 | 1022600 | 4160 | 9000 | 9.36 |
| [NanoPC T4 (RK3399)](results/1iWU.txt) | **1800/1400** MHz| 4.17 | Stretch arm64 | 6230 | 1756 | 1023600 | 4100 | 9060 | 10.30 |
| [NanoPC T4 (RK3399)](results/1iFz.txt) | **1800/1400** MHz| 4.17 | Stretch arm64 | 6250 | 1809 | 1022500 | 4100 | 9000 | 8.24 |
| [MangoPi Mcore (Allwinner H616)](results/4bSf.txt) | **1800** MHz| 5.19 | Jammy arm64 | 4100 | 1218 | 840270 | 990 | 2380 | - |
| [Nintendo Switch (Tegra X1)](results/1Rnj.txt) | **1780** MHz| 4.9 | Fedora 30 arm-64 | 6170 | 1719 | 642670 | 2500 | 3570 | - |
| [ODROID-C2 (Amlogic S905)](results/1ixI.txt) | **1750** MHz| 3.14 | Xenial arm64 | 4070 | 1128 | 48500 | 1750 | 3100 | - |
| [Tinkerboard (RK3288)](results/1iSX.txt) | **1730** MHz| 4.14 | Stretch armhf | 5350 | 1563 | 66600 | 1480 | 3900 | - |
| [SBC2D70 (SSD202D)](results/3N1U.txt) | **1700** MHz| 5.16 | Sid armhf | 1960 | 1094 | 33120 | 770 | 3190 | - |
| [AMD E-450 APU](results/4hwl.txt) | **1650** MHz| 5.15 | Jammy amd64 | 2430 | 1258 | 27450 | 1710 | 1740 | - |
| [Tronsmart S82 (Amlogic S802)](results/41ML.txt) | **1600** MHz| 5.14 | Focal armhf | 3640 | 1114 | 43150 | 500 | 3200 | - |
| [Macchiatobin (Armada 8040)](results/4zcm.txt) | **1600** MHz| 5.10 | Buster arm64 | 5720 | 1739 | 909420 | 4510 | 12270 | 7.91 |
| [Helios4<br />(Armada 388)](results/1jCy.txt) | **1600** MHz| 4.14 | Stretch armhf | 2210 | 1215 | 42500 &ast;98560 | 910 | 4840 | - |
| [Clearfog A1<br />(Armada 388)](results/4d1U.txt) | **1600** MHz| 5.15 | Bullseye armhf | 2230 | 1239 | 44080 | 910 | 5060 | - |
| [Atom N270](results/461n.txt) | **1600** MHz| 4.19 | Buster i386 | 1220 | 824 | 18760 | 1420 | 2840 | - |
| [Ugoos UT2 (RK3188)](results/408h.txt) | **1560** MHz| 5.10 | Jammy armhf | 3320 | 994 | 43250 | 320 | 2020 | - |
| [Tronsmart MXIII Plus (S812)](results/3S5U.txt) | **1560** MHz| 5.10 | Buster armhf | 3880 | 1113 | 42570 | 1470 | 3430 | - |
| [TRONFY MXQ (Amlogic S805)](results/3MiR.txt) | **1536** MHz| 5.10 | Focal armhf | 3100 | 897 | 29080 | 980 | 2990 | - |
| [Orange Pi Zero 3 (Allwinner H618)](results/4CPF.txt) | **1510** MHz| 6.1 | Jammy arm64 | 4020 | 1165 | 705330 | 1510 | 6010 | 6.02 |
| [Orange Pi Zero 2W (Allwinner H618)](results/4Hd0.txt) | **1510** MHz| 6.1 | Jammy arm64 | 3920 | 1167 | 705660 | 1510 | 6010 | 6.02 |
| [Orange Pi Zero 2 (Allwinner H616)](results/4knM.txt) | **1510** MHz| 4.9 | Buster arm64 | 3550 | 1067 | 703300 | 1190 | 2820 | 5.01 |
| [Jetson Orin Nano](results/4vy7.txt) | **1510** MHz| 5.10 | Focal arm64 | 13650 | 2153 | 854400 | 6730 | 20240 | 20.68 |
| [VisionFive V2 (JH7110)](results/4xOY.txt) | **1500** MHz| 5.15 | Sid riscv64 | 4180 | 1197 | 25080 | 880 | 770 | - |
| [Star64 (JH7110)](results/4tjq.txt) | **1500** MHz| 5.15 | Sid riscv64 | 3970 | 1175 | 24990 | 820 | 770 | - |
| [Raspberry Pi 4 B (BCM2711)](results/3EgS.txt) | **1500** MHz| 5.10 | Raspberry Pi OS Buster | 5750 | 1661 | 64930 | 2550 | 3430 | - |
| [Raspberry Pi 4 B (BCM2711)](results/1MFf.txt) | **1500** MHz| 4.19 | Raspbian Buster | 5500 | 1606 | 64860 | 2460 | 3170 | - |
| [ODROID-C1 (Amlogic S805)](results/4eg5.txt) | **1500** MHz| 5.19 | Jammy armhf | 3010 | 878 | 29260 | 390 | 2910 | - |
| [Milk-V Mars CM (JH7110)](results/4K7E.txt) | **1500** MHz| 5.15 | Bookworm riscv64 | 4110 | 1195 | 25070 | 930 | 830 | - |
| [HummingBoard Pulse i.MX8M Quad](results/27FC.txt) | **1500** MHz| 4.19 | Buster arm64 | 4330 | 1201 | 695540 | 2230 | 9900 | - |
| [NanoPi K2 (Amlogic S905)](results/3Qve.txt) | **1480** MHz| 5.10 | Bullseye arm64 | 3880 | 1154 | 51490 | 1850 | 3790 | - |
| [NanoPi K2 (Amlogic S905)](results/1iT1.txt) | **1480** MHz| 4.14 | Stretch arm64 | 3850 | 1095 | 50370 | 1660 | 3870 | 4.61 |
| [Jetson Nano](results/4rLX.txt) | **1480** MHz| 4.9 | Bullseye arm64 | 5260 | 1578 | 531940 | 3730 | 8870 | - |
| [Atom E3826](results/44pd.txt) | **1460** MHz| 5.18 | Jammy amd64 | 2140 | 1112 | 182190 | 2840 | 2760 | - |
| [x5-Z8300](results/1lgD.txt) | **1420** MHz| 4.9 | Stretch amd64 | 3900 | 950 | 178010 | 2380 | 2380 | 7.81 |
| [Libre Computer AML-S912-PC](results/40cj.txt) | **1415/1000** MHz| 5.15 | Bullseye arm64 | 5980 | 1012 | 659290 | 1650 | 5170 | - |
| [Khadas VIM2 (Amlogic S912)](results/1iJ7.txt) | **1415/1000** MHz| 4.17 | Bionic arm64 | 5450 | 993 | 659600 | 1920 | 5920 | 8.59 |
| [Khadas VIM1 (Amlogic S905X)](results/4bee.txt) | **1415** MHz| 5.1 | Buster arm64 | 3860 | 1136 | 660160 | 1940 | 5900 | - |
| [Le Potato (Amlogic S905X)](results/1iSQ.txt) | **1410** MHz| 4.18 | Stretch arm64 | 3780 | 1057 | 657200 | 1810 | 5730 | 3.92 |
| [Rock64 (RK3328)](results/1iwz.txt) | **1400** MHz| 4.4 | Stretch armhf | 3620 | 1006 | 624000 | 1430 | 3620 | - |
| [Rock64 (RK3328)](results/1iZj.txt) | **1400** MHz| 4.4 | Stretch arm64 | 3590 | 1030 | 643700 | 1320 | 5640 | 4.40 |
| [Rock64 (RK3328)](results/1iYK.txt) | **1400** MHz| 4.4 | Stretch arm64 | 3580 | 1032 | 644380 | 1330 | 5680 | 4.63 |
| [Rock64 (RK3328)](results/1iFm.txt) | **1400** MHz| 4.4 | Stretch arm64 | 3610 | 1034 | 644250 | 1330 | 5700 | 3.85 |
| [Renegade (RK3328)](results/1iFx.txt) | **1400** MHz| 4.4 | Stretch arm64 | 3710 | 1069 | 644200 | 1565 | 7435 | 3.92 |
| [NanoPi Fire3 (Nexell S5P6818)](results/3ZxU.txt) | **1400** MHz| 4.14 | Focal arm64 | 7350 | 1093 | 652640 | 1530 | 4590 | 11.18 |
| [NanoPi Fire3 (Nexell S5P6818)](results/1jjm.txt) | **1400** MHz| 4.14 | Bionic arm64 | 7440 | 1052 | 653000 | 1560 | 4600 | 10.96 |
| [NanoPC T3+ (Nexell S5P6818)](results/1iyp.txt) | **1400** MHz| 4.4 | Xenial armhf | 6400 | 943 | 651000 | 1650 | 3700 | - |
| [NanoPC T3+ (Nexell S5P6818)](results/1iRJ.txt) | **1400** MHz| 4.14 | Bionic arm64 | 7480 | 1053 | 652600 | 1440 | 4540 | 10.99 |
| [BPi M4 (RTD1395)](results/1Dt1.txt) | **1400** MHz| 4.9 | Bionic arm64 | 3500 | - | 651460 | 1010 | 4360 | 5.48 |
| [RK3318 BOX](results/4kor.txt) | **1390** MHz| 6.0 | Jammy arm64 | 3200 | 867 | 644750 | 700 | 2460 | - |
| [NanoPi Fire3 (Nexell S5P6818)](results/1jiU.txt) | **1380** MHz| 4.14 | Stretch arm64 | 7420 | 1038 | 645400 | 1520 | 4570 | 8.53 |
| [Orange Pi Prime (Allwinner H5)](results/2kTH.txt) | **1370** MHz| 5.4 | Buster | 3590 | 984 | 637980 | 1180 | 3540 | - |
| [Orange Pi PC+ (Allwinner H3)](results/3MQV.txt) | **1370** MHz| 5.10 | Focal armhf | 3060 | 879 | 26590 | 890 | 3450 | - |
| [Orange Pi PC 2 (Allwinner H5)](results/3MQJ.txt) | **1370** MHz| 5.10 | Focal arm64 | 3500 | 1023 | 637410 | 1070 | 3680 | - |
| [NanoPi M1 Plus (Allwinner H3)](results/3N2z.txt) | **1370** MHz| 4.19 | Bionic armhf | 3030 | 881 | 26660 | 830 | 3450 | - |
| [NanoPi K1 Plus (Allwinner H5)](results/3N7H.txt) | **1370** MHz| 5.10 | Focal arm64 | 3520 | 1022 | 638880 | 1070 | 3680 | 5.50 |
| [Atom E3825](results/4kFQ.txt) | **1330** MHz| 5.10 | Bullseye amd64 | 1950 | 1109 | 165840 | 2890 | 2890 | - |
| [Rock64 (RK3328)](results/1iHo.txt) | **1300** MHz| 4.4 | Stretch arm64 | 3430 | 952 | 601000 | 1350 | 5680 | 3.64 |
| [Rock64 (RK3328)](results/1iHB.txt) | **1300** MHz| 4.18 | Stretch arm64 | 3560 | 1002 | 603800 | 1340 | 5770 | 3.80 |
| [Rock64 (RK3328)](results/1iH4.txt) | **1300** MHz| 4.18 | Bionic arm64 | 3530 | 996 | 605250 | 1340 | 5770 | 4.65 |
| [Rock64 (RK3328)](results/1iGW.txt) | **1300** MHz| 4.4 | Bionic arm64 | 3410 | 945 | 601200 | 1310 | 5680 | 4.46 |
| [Radxa Rock Pi S (RK3308)](results/4sNe.txt) | **1300** MHz| 6.1 | Jammy arm64 | 2540 | 732 | 282030 | 820 | 1870 | - |
| [Orange Pi Plus 2 (Allwinner H3)](results/1iX4.txt) | **1300** MHz| 4.14 | Stretch armhf | 2890 | 812 | 25250 | 830 | 3240 | - |
| [MT6580 K9M1](results/466y.txt) | **1300** MHz| 5.19 | Sid armhf | 2930 | 860 | 25300 | 1250 | 3300 | - |
| [BPi R2 (MT7623)](results/4dO7.txt) | **1300** MHz| 4.19 | Focal armhf | 2990 | 854 | 25260 | 1550 | 3220 | - |
| [Marvell PXA1908](results/46hs.txt) | **1245** MHz| 3.14 | Bullseye arm64 | 3180 | 951 | 581840 | 740 | 2220 | - |
| [T-HEAD C910 RVB-ICE](results/41AB.txt) | **1200** MHz| 5.10 | Sid riscv64 | 1760 | 1007 | 26930 | 3340 | 6470 | - |
| [Raspberry Pi Zero 2 (RP3A0)](results/3DeL.txt) | **1200** MHz| 5.10 | Raspberry Pi OS Buster | 3640 | 1007 | 36300 | 1320 | 1790 | - |
| [Raspberry Pi 3 B (BCM2837)](results/4hOP.txt) | **1200** MHz| 5.15 | Raspbian Sid | 2970 | 977 | 36230 | 1110 | 1700 | 2.89 |
| [RK3228A TV Box](results/3M9F.txt) | **1200** MHz| 4.4 | Buster armhf | 2310 | 710 | 23070 | 410 | 1230 | - |
| [EspressoBin (Armada 3720)](results/1lCe.txt) | **1200** MHz| 4.18 | Stretch arm64 | 1630 | 869 | 544240 | 1000 | 2400 | 1.82 |
| [BPi M2U (Allwinner R40)](results/4kmM.txt) | **1200** MHz| 6.0 | Bullseye armhf | 2690 | 767 | 23320 | 780 | 3010 | - |
| [Akaso M8S (S812)](results/3R3N.txt) | **1200** MHz| 5.10 | Buster armhf | 3050 | 885 | 32120 | 1160 | 3330 | - |
| [Teres-I<br />(Allwinner A64)](results/1tJg.txt) | **1050** MHz| 4.19 | Stretch arm64 | 2785 | 780 | 491590 | 1080 | 2820 | - |
| [Raspberry Pi Zero 2 (RP3A0)](results/3E85.txt) | **1000** MHz| 5.10 | Raspberry Pi OS Buster | 3030 | 838 | 29860 | 1300 | 1570 | - |
| [Raspberry Pi Zero (BCM2835)](results/3Njz.txt) | **1000** MHz| 5.10 | Bullseye armv6l/armhf | 460 | 460 | 17060 | 430 | 1670 | - |
| [Raspberry Pi Zero (BCM2835)](results/1niO.txt) | **1000** MHz| 4.14 | Raspbian Stretch | 450 | 450 | 16820 | 400 | 1590 | - |
| [Raspberry Pi B (BCM2835)](results/4vVG.txt) | **1000** MHz| 6.1 | Raspberry Pi OS Bullseye | 480 | 481 | 16900 | 490 | 2220 | - |
| [ClockworkPi R-01 (Allwinner D1)](results/40BJ.txt) | **1000** MHz| 5.4 | Focal riscv64 | 450 | 450 | 9040 | 1220 | 2640 | - |
| [Cubox-i4<br />(NXP i.MX6)](results/4132.txt) | **980** MHz| 5.15 | Jammy armhf | 2360 | 657 | 27000 | 340 | 340 | - |
| [Olimex A20-Lime2](results/4rRV.txt) | **960** MHz| 5.10 | Bullseye armhf | 1080 | 589 | 18630 | 430 | 2020 | 0.87 |
| [Cubietruck (Allwinner A20)](results/3Naw.txt) | **960** MHz| 5.10 | Bullseye armhf | 1030 | 541 | 18640 | 440 | 2010 | - |
| [Banana Pi (Allwinner A20)](results/3PLr.txt) | **960** MHz| 5.10 | Bullseye armhf | 1040 | 542 | 18640 | 440 | 2020 | - |
| [Lime A10 (Allwinner A10)](results/1j1L.txt) | **910** MHz| 4.14 | Stretch armhf | 550 | 550 | 28250 | 440 | 1300 | - |
| [Raspberry Pi 2 B+ (BCM2836)](results/3MGs.txt) | **900** MHz| 5.10 | Raspberry Pi OS Bullseye | 2150 | 620 | 16500 | 1000 | 1180 | - |
| [Raspberry Pi 2 B+ (BCM2836)](results/1iFf.txt) | **900** MHz| 4.14 | Debian Stretch | 2070 | 592 | 17450 | 615 | 1175 | - |
| [EspressoBin (Armada 3720)](results/1kt2.txt) | **800** MHz| 4.17 | Stretch arm64 | 1138 | 636 | 368330 | 1040 | 2490 | 1.23 |
| [Kendryte K510](results/41Qa.txt) | **790** MHz| 4.17 | Sid riscv64 | 690 | 402 | 7410 | 280 | 440 | - |
| [Raspberry Pi B (BCM2835)](results/3MGN.txt) | **700** MHz| 5.10 | Raspberry Pi OS Bullseye | 320 | 320 | 11630 | 360 | 1420 | - |
| [Raspberry Pi Zero 2 (RP3A0)](results/3Dfo.txt) | **600** MHz| 5.10 | Raspberry Pi OS Buster | 1900 | 529 | 18150 | 1040 | 1130 | - |

[(back to top of the page)](#sbc-bench-results-sorted)
