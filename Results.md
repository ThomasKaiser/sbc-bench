# Results

Below some results collected. Please keep in mind that these are **not** hardware performance numbers but partially depend on software/settings (see the differences kernel version makes for RockPro64 for example). The purpose of `sbc-bench` is to generate insights and not numbers or graphs.

## Table with results

| Board | Clockspeed | Kernel | Distro | 7-zip | AES-128 (16 byte) | AES-256 (16 KB) | memcpy | memset | kH/s | URL |
| ----- | :--------: | :----: | :----: | ----: | ------: | ------: | -----: | -----: | ---: | --- |
| BPi R2 | 1300 MHz | 4.4 | **Xenial** armhf | 2600 | 27550 | 25350 | 1500 | 3800 | - | [http://ix.io/1iGV](http://ix.io/1iGV) |
| [Clearfog Pro](https://www.armbian.com/clearfog/) | 1600 MHz | 4.14 | Stretch armhf | 2185 | 44500 | 43900 | 935 | 4940 | - | [http://ix.io/1iFa](http://ix.io/1iFa) |
| [Le Potato](https://www.armbian.com/lepotato/) | 1410 MHz | 4.18 | Stretch arm64 | 3780 | 96680 | 657200 | 1810 | 5730 | 3.92 | [http://ix.io/1iSQ](http://ix.io/1iSQ) |
| [NanoPC T3+](https://www.armbian.com/nanopc-t3-plus/) | 1400 MHz | 4.4 | **Xenial armhf** | 6400 | 143800 | 651000 | 1650 | 3700 | - | [http://ix.io/1iyp](http://ix.io/1iyp) |
| [NanoPC T3+](https://www.armbian.com/nanopc-t3-plus/) | 1400 MHz | 4.14 | Bionic arm64 | 7480 | 126000 | 652600 | 1440 | 4540 | 10.99 | [http://ix.io/1iRJ](http://ix.io/1iRJ) |
| [NanoPC T4](http://wiki.friendlyarm.com/wiki/index.php/NanoPC-T4) | 1800/1400 MHz | 4.17 | Stretch arm64 | 6250 | 307200 | 1022500 | 4100 | 9000 | 8.24 | [http://ix.io/1iFz](http://ix.io/1iFz) |
| [NanoPi Fire3](https://www.armbian.com/nanopi-fire3/) | 1400 MHz | 4.14 | Bionic arm64 | 7400 | 95900 | 647500 | 1540 | 4575 | - | [http://ix.io/1ivC](http://ix.io/1ivC) |
| [NanoPi K2](https://www.armbian.com/nanopi-k2/) | 1480 MHz | 4.14 | Stretch arm64 | 3850 | 43020 | 50370 | 1660 | 3870 | 4.61 | [http://ix.io/1iT1](http://ix.io/1iT1) |
| [ODROID-C2](https://www.armbian.com/odroid-c2/) | 1750 MHz | 3.14 | **Xenial** arm64 | 4070 | 50500 | 48500 | 1750 | 3100 | - | [http://ix.io/1ixI](http://ix.io/1ixI) |
| [ODROID-C2](https://www.armbian.com/odroid-c2/) | 1530 MHz | 4.17 | Stretch arm64 | 3870 | 43800 | 51280 | 1420 | 2600 | 4.63 | [http://ix.io/1iSh](http://ix.io/1iSh) |
| [ODROID-XU4](https://www.armbian.com/odroid-xu4/) | 1900/1400 MHz | 3.10 | **Jessie** armhf | 6750 | 74100 | 68200 | 2200 | 4800 | - | [http://ix.io/1ixL](http://ix.io/1ixL) |
| [ODROID-XU4](https://www.armbian.com/odroid-xu4/) | 2000/1500 MHz | 4.14 | Bionic armhf | 7100 | 74700 | 71500 | 2240 | 4880 | - | [http://ix.io/1iLy](http://ix.io/1iLy) |
| [PineH64](https://www.armbian.com/pine-h64/) | 900 **(!)** MHz | 4.17 | Stretch arm64 | 2550 | 62200 | 421000 | 1600 | 4840 | 2.84 | [http://ix.io/1iFT](http://ix.io/1iFT) |
| [Renegade](https://www.armbian.com/renegade/) | 1400 MHz | 4.4 | Stretch arm64 | 3710 | 95030 | 644200 | 1565 | 7435 | 3.92 | [http://ix.io/1iFx](http://ix.io/1iFx) |
| Raspberry Pi 2 B+ | 900 MHz | 4.14 | **Debian** Stretch | 2070 | 14350 | 17450 | 615 | 1175 | - | [http://ix.io/1iFf](http://ix.io/1iFf) |
| Raspberry Pi 2 B+ | 900 MHz | 4.14 | Raspbian Stretch | 2130 | 14000 | 16300 | 1010 | 1170 | - | [http://ix.io/1ivw](http://ix.io/1ivw) |
| Raspberry Pi 3 B+ | original | 4.9 | Raspbian Stretch | 3600 | 35500 | 42700 | 1230 | 1640 | - | [http://ix.io/1iI5](http://ix.io/1iI5) |
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
| [Tinkerboard](https://www.armbian.com/tinkerboard/) | 1730 MHz | 4.14 | Stretch armhf | 5350 | 63150 | 66600 | 1480 | 3900 | - | [http://ix.io/1iSX](http://ix.io/1iSX) |
| [Vim2](https://www.khadas.com/vim) | 1400/1000 MHz | 4.9 | **Xenial** arm64 | 4800 | 177600 | 659000 | 1690 | 5610 | - | [http://ix.io/1ixi](http://ix.io/1ixi) |
| [Vim2](https://www.khadas.com/vim) | 1400/1000 MHz | 4.17 | Bionic arm64 | 5450 | 126770 | 659600 | 1920 | 5920 | 8.59 | [http://ix.io/1iJ7](http://ix.io/1iJ7) |

## Explanations

* *7-zip* number is an averaged **multi threaded** score from 3 consecutive `7z b` runs. Only relevant for server workloads where stuff happens in parallel. Check the links for single threaded results (on big.LITTLE SoCs individually) to get an idea how most typical (single threaded) workloads perform
* *AES-128 (16 byte)* is a **single threaded** encryption score with very small chunks of data (useful to get an idea how initialization overhead influences crypto performance with small packets). On big.LITTLE SoCs numbers show big core performance
* *AES-256 (16 KB)* is a **single threaded** encryption score with rather huge chunks of data. On big.LITTLE SoCs numbers show big core performance
* *memcpy* and *memset* are tinymembench measurements for memory bandwidth. On big.LITTLE SoCs numbers show big core performance
* *kH/s* is a **multi threaded** cpuminer score showing the board's performance when executing NEON optimized code. To get the performance difference between big and little cores check the links in the right column
* RPi 3 B+ performance shown as *original* was measured with an older ThreadX release (6e08617e7767b09ef97b3d6cee8b75eba6d7ee0b from Mar 13 2018). Back then the 3B+ was faster than the 3B. This changed with a newer ThreadX release (4800f08a139d6ca1c5ecbee345ea6682e2160881 from Jun 7 2018) since RPi Trading people decided to trash performance on every RPi 3 B+ to masquerade instability issues on a fraction of boards ([details](https://www.raspberrypi.org/forums/viewtopic.php?f=63&t=217056#p1334921))
* RPi 3 B+ performance numbers shown as *normal* were made with no or just a heatsink (in contrast to *with fan*)
* RPi 3 B+ marked as 'UV/normal' means: normal settings and average Micro USB cable resulting in **UV** (undervoltage). Once the demanding 7-zip benchmark started voltage dropped below 4.63V and 'frequency capping' (downclocking to 600 MHz) happened destroying performance. See the [detailed log](http://ix.io/1iH0): 1400 MHz are reported by the kernel while it's 600 MHz in reality. Is this just highly misleading or already cheating?
* RPi 3 B+ marked as 'OC/normal' means: **OC** (overclocked) settings, stable voltage but no fan used. Since SoC temperature exceeds 60°C the 'firmware' starts to cheat and downclocks to 1200 MHz while the kernel reports running at 1570 MHz. At least memory overclocking is somewhat effective.
* Vim2 is somewhat special: not a real big.LITTLE design but 2 A53 clusters controlled by a firmware BLOB that allows cluster 0 to clock up to 1414 MHz (reported falsely as 1512 MHz) and cluster 1 able to reach 1 GHz ([details](https://forum.khadas.com/t/cpu-frequency-up-to-2ghz/2010/23?u=tkaiser))

## Insights

* Benchmarking the Raspberry Pi is useless when not taking into account that there always is a primary operating system running on the primary CPU (VideoCore) that fully controls the hardware. ARM cores are just guests here. That's why `sbc-bench` starting with v0.2 also logs ThreadX version and configuration (/boot/config.txt)
* Looking at RPi 2 B+ numbers this is 2 times the same hardware, one time running latest Raspbian Stretch Lite and one time [OMV/Armbian](https://sourceforge.net/projects/openmediavault/files/Raspberry%20Pi%20images/). Userland is both times Debian Stretch but Raspbian packages are built for ARMv6 while upstream Debian builds for ARMv7 ([though with less effective compiler switches](https://forum.armbian.com/topic/1748-sbc-consumptionperformance-comparisons/?page=2)). Overall performance looks more or less the same except a very low `memcopy` bandwidth value with OMV. What's the reason since same ditro and kernel is used and same GCC to compile `tinymembench`? Is it firmware 'af8084725947aa2c7314172068f79dad9be1c8b4 from Apr 16 2018' vs. '47b05c853342eb6e4ea5b017d981e0ef247fb8be from Jul 3 2018'?
* Looking at RPi 3 B+ numbers it's obvious that 'firmware' version is the most important factor. With original firmware (6e08617e7767b09ef97b3d6cee8b75eba6d7ee0b from Mar 13 2018) performance is ok just to get trashed after applying firmware 4800f08a139d6ca1c5ecbee345ea6682e2160881 from Jun 7 2018 which totally changes throttling behaviour. From then on you either need a fan for good performance or add a `temp_soft_limit=` entry to the firmware config file (we can't have a look what all those partially undocumented settings really do since RPi's main operating system is closed source)
* `tinymembench` when executed on an A53 in an *armhf* userland compared to *arm64* seems to generate lower `memset` numbers (78% on RK3399 -- see [RockPro64 arm64](http://ix.io/1ivR) vs. [RockPro64 armhf](http://ix.io/1iFZ) -- and 64% on RK3328 -- see [Rock64 arm64](http://ix.io/1iFm) vs. [Rock64 armhf](http://ix.io/1iwz)). Status: needs further investigation and confirmation
* Bionic vs. Stretch doesn't seem to make a difference with `7-zip` scores. Applies to both *armhf* and *arm64* too -- see Rock64 numbers above
* `7-zip` scores benefit slightly from memory performance. See RK3328 equipped Renegade at 1.4 GHz with 4.4 kernel and Rock64 with same setup
* `openssl` numbers are not affected by memory performance and are the same with same CPU cores and same clockspeeds. At least with Cortex-A53 running at 1.4 GHz with a Debian Stretch arm64 binary: NanoPi Fire3, Renegade, Rock64 and [RockPro64 with openssl pinned to an A53 core](http://ix.io/1ivR): ~96000k with AES-128/16bit and ~648000k with AES-256/16KB
* It seems the combination arm64 Bionic with very recent kernel improves AES encryption results with small data chunks (less than 1KB -- see [Rock64 with 4.18 at 1.3GHz](http://ix.io/1iH4) and [Vim2 with 4.17 at 1.4GHz](http://ix.io/1iJ7) vs. [Rock64 with 4.4 at 1.3GHz](http://ix.io/1iGW)). Status: Needs further investigations (most probably related to GCC version)
* It seems running an *armhf* userland on 64-bit SoCs also improves AES encryption results with small data chunks (see *armhf* entries for NanoPC T3+, Rock64, RockPro64 and Vim2). Status: very interesting, needs further investigations
* It seems running Xenial binaries even further improves AES/SSL performance when ARMv8 Crypto Extensions are available. Status: while interesting irrelevant, we should get rid of Xenial and Jessie numbers.
* It makes a huge difference whether ARMv8 Crypto Extensions can be used or not. See the many 64-bit SBC results above and compare with RPi 3B+ or ODROID-C2 (both 64-bit ARMv8 but no crypto engine licensed/available)
* Bionic vs. Stretch makes a big difference with `cpuminer`. GCC version might matter (7.3 on Bionic vs. 6.3 on Stretch -- [some benchmarks heavily depend on compiler versions](https://forum.armbian.com/topic/7763-benchmarking-cpus/?do=findComment&comment=58530)). Status: needs further investigation and confirmation
* *(more to come soon)*