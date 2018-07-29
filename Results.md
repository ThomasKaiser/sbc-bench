# Results

Below some results collected. Please keep in mind that these are **not** hardware performance numbers but partially depend on software/settings (see the differences kernel version makes for RockPro64 for example). The purpose of `sbc-bench` is to generate insights and not numbers or graphs.

## Table with results

| Board | Clockspeed | Kernel | Distro | 7-zip | AES-128 (16 byte) | AES-256 (16 KB) | memcpy | memset | kH/s | URL |
| ----- | :--------: | :----: | :----: | ----: | ------: | ------: | -----: | -----: | ---: | --- |
| BPi R2 | 1300 MHz | 4.4 | **Xenial** armhf | 2600 | 27550 | 25350 | 1500 | 3800 | - | [http://ix.io/1iGV](http://ix.io/1iGV) |
| [Clearfog Pro](https://www.armbian.com/clearfog/) | 1600 MHz | 4.14 | Stretch armhf | 2185 | 44500 | 43900 | 935 | 4940 | - | [http://ix.io/1iFa](http://ix.io/1iFa) |
| [NanoPi Fire3](https://www.armbian.com/nanopi-fire3/) | 1400 MHz | 4.14 | Bionic arm64 | 7400 | 95900 | 647500 | 1540 | 4575 | - | [http://ix.io/1ivC](http://ix.io/1ivC) |
| [NanoPC T3+](https://www.armbian.com/nanopc-t3-plus/) | 1400 MHz | 4.4 | **Xenial armhf** | 6400 | 143800 | 651000 | 1650 | 3700 | - | [http://ix.io/1iyp](http://ix.io/1iyp) |
| [NanoPC T4](http://wiki.friendlyarm.com/wiki/index.php/NanoPC-T4) | 1800/1400 MHz | 4.17 | Stretch arm64 | 6250 | 307200 | 1022500 | 4100 | 9000 | 8.24 | [http://ix.io/1iFz](http://ix.io/1iFz) |
| [ODROID-C2](https://www.armbian.com/odroid-c2/) | 1750 MHz | 3.14 | **Xenial** arm64 | 4070 | 50500 | 48500 | 1750 | 3100 | - | [http://ix.io/1ixI](http://ix.io/1ixI) |
| [ODROID-XU4](https://www.armbian.com/odroid-xu4/) | 1900/1400 MHz | 3.10 | **Jessie** armhf | 6750 | 74100 | 68200 | 2200 | 4800 | - | [http://ix.io/1ixL](http://ix.io/1ixL) |
| [PineH64](https://www.armbian.com/pine-h64/) | 900 **(!)** MHz | 4.17 | Stretch arm64 | 2550 | 62200 | 421000 | 1600 | 4840 | 2.84 | [http://ix.io/1iFT](http://ix.io/1iFT) |
| [Renegade](https://www.armbian.com/renegade/) | 1400 MHz | 4.4 | Stretch arm64 | 3710 | 95030 | 644200 | 1565 | 7435 | 3.92 | [http://ix.io/1iFx](http://ix.io/1iFx) |
| Raspberry Pi 2 B+ | 900 MHz | 4.14 | **Debian** Stretch | 2070 | 14350 | 17450 | 615 | 1175 | - | [http://ix.io/1iFf](http://ix.io/1iFf) |
| Raspberry Pi 2 B+ | 900 MHz | 4.14 | Raspbian Stretch | 2130 | 14000 | 16300 | 1010 | 1170 | - | [http://ix.io/1ivw](http://ix.io/1ivw) |
| Raspberry Pi 3 B+ | normal | 4.14 | Raspbian Stretch | 3240 | 30500 | 36600 | 1130 | 1530 | - | [http://ix.io/1ism](http://ix.io/1ism) |
| Raspberry Pi 3 B+ | normal | 4.14 | Raspbian Stretch | 3040 | 29500 | 36600 | 1050 | 1500 | - | [http://ix.io/1iGM](http://ix.io/1iGM) |
| Raspberry Pi 3 B+ | UV/normal | 4.14 | Raspbian Stretch | 2100 | 29500 | 36400 | 1040 | 1460 | - | [http://ix.io/1iH0](http://ix.io/1iH0) |
| Raspberry Pi 3 B+ | OC/normal | 4.14 | Raspbian Stretch | 3130 | 30500 | 36620 | 1230 | 1780 | - | [http://ix.io/1iGz](http://ix.io/1iGz) |
| Raspberry Pi 3 B+ | with fan | 4.14 | Raspbian Stretch | 3670 | 35800 | 42600 | 1120 | 1600 | - | [http://ix.io/1isD](http://ix.io/1isD) |
| [Rock64](https://www.armbian.com/rock64/) | 1300 MHz | 4.4 | Bionic arm64 | 3410 | 89060 | 601200 | 1310 | 5680 | 4.46 | [http://ix.io/1iGW](http://ix.io/1iGW) |
| [Rock64](https://www.armbian.com/rock64/) | 1300 MHz | 4.18 | Bionic arm64 | 3530 | 116100 | 605250 | 1340 | 5770 | 4.65 | [http://ix.io/1iH4](http://ix.io/1iH4) |
| [Rock64](https://www.armbian.com/rock64/) | 1300 MHz | 4.4 | Stretch arm64 | 3430 | 88600 | 601000 | 1350 | 5680 | 3.64 | [http://ix.io/1iHo](http://ix.io/1iHo) |
| [Rock64](https://www.armbian.com/rock64/) | 1300 MHz | 4.18 | Stretch arm64 | 3560 | 89070 | 603800 | 1340 | 5770 | 3.80 | [http://ix.io/1iHB](http://ix.io/1iHB) |
| [Rock64](https://www.armbian.com/rock64/) | 1400 MHz | 4.4 | Stretch arm64 | 3610 | 95000 | 644250 | 1330 | 5700 | 3.85 | [http://ix.io/1iFm](http://ix.io/1iFm) |
| [Rock64](https://www.armbian.com/rock64/) | 1400 MHz | 4.4 | Stretch **armhf** | 3620 | 99400 | 624000 | 1430 | 3620 | - | [http://ix.io/1iwz](http://ix.io/1iwz) |
| [RockPro64](http://wiki.pine64.org/index.php/ROCKPro64_Main_Page) | 1800/1400 MHz | 4.4 | Stretch arm64 | 6140 | 236800 | 1016050 | 2790 | 4850 | - | [http://ix.io/1ivR](http://ix.io/1ivR) |
| [RockPro64](http://wiki.pine64.org/index.php/ROCKPro64_Main_Page) | 1800/1400 MHz | 4.4 | Stretch **armhf** | 6250 | 275000 | 1000150 | 2000 | 4835 | - | [http://ix.io/1iFZ](http://ix.io/1iFZ) |
| [RockPro64](http://wiki.pine64.org/index.php/ROCKPro64_Main_Page) | 1800/1400 MHz | 4.18 | Stretch arm64 | 6300 | 237700 | 1021500 | 3650 | 8450 | 8.20 | [http://ix.io/1iFp](http://ix.io/1iFp) |

## Explanations

* *7-zip* number is an averaged **multi threaded** score from 3 consecutive `7z b` runs. Only relevant for server workloads where stuff happens in parallel. Check the links for single threaded results (on big.LITTLE SoCs individually) to get an idea how most typical (single threaded) workloads perform
* *AES-128 (16 byte)* is a **single threaded** encryption score with very small chunks of data (useful to get an idea how initialization overhead influences crypto performance with small packets). On big.LITTLE SoCs numbers show big core performance
* *AES-256 (16 KB)* is a **single threaded** encryption score with rather huge chunks of data. On big.LITTLE SoCs numbers show big core performance
* *memcpy* and *memset* are tinymembench measurements for memory bandwidth. On big.LITTLE SoCs numbers show big core performance
* *kH/s* is a **multi threaded** cpuminer score showing the board's performance when executing NEON optimized code. To get the performance difference between big and little cores check the links in the right column
* RPi 3 B+ performance numbers are shown as *normal* (no or just a heatsink) vs. *with fan*. RPi Trading people decided to trash performance on every RPi 3 B+ to masquerade instability issues on a fraction of boards ([details](https://www.raspberrypi.org/forums/viewtopic.php?f=63&t=217056#p1334921))
* RPi 3 B+ marked as 'UV/normal' means: normal settings and average Micro USB cable resulting in **UV** (undervoltage). Once the demanding 7-zip benchmark started voltage dropped below 4.63V and 'frequency capping' (downclocking to 600 MHz) happened destroying performance. See the [detailed log](http://ix.io/1iH0): 1400 MHz are reported by the kernel while it's 600 MHz in reality. Cheating as usual.
* RPi 3 B+ marked as 'OC/normal' means: **OC** (overclocked) settings, stable voltage but no fan used. Since SoC temperature exceeds 60°C the 'firmware' starts to cheat and downclocks to 1200 MHz while the kernel reports running at 1570 MHz. At least memory overclocking is somewhat effective.

## Insights

