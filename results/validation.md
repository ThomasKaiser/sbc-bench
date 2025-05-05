# Result validation

  * Standard deviation reported by tinymembench when repeating the individual tests multiple times
  * RAM total/avail according to `free -h`
  * 22/23/24/25 are dictionary sizes 7-zip's internal benchmark is testing through. On systems low on memory the larger ones will be skipped (2^22 = 4 MB, 2^23 = 8 MB, 2^24 = 16 MB, 2^25 = 32 MB)
  * high `%system` values while benchmarking are an indication of background activity that might render benchmark results useless
  * high `%iowait` values while benchmarking are an indication of something going wrong, most probaly swapping happening which will render benchmark results partially useless
  * if mentioned throttling needs to be checked in the log

| Result | Version / device | Standard deviation | RAM total/avail | 22 | 23 | 24 | 25 | %system | %iowait | throttling |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | ----: | ----: | :---: |
| [1BsF](1BsF.txt) | v0.6.2 Hardkernel ODROID-N2 | 0%/0.1% | 3.6G/3.5G | X | X | X | X | 2% | 0% | |
| [1Dt1](1Dt1.txt) | v0.6.6 Realtek\_Lion\_Skin\_1GB | 0%/0% | 570M/313M | X | X | X | | 3% | 2% | |
| [1HnC](1HnC.txt) | v0.6.6 x5-Z8350 | 0%/0% | 1.9G/1.6G | X | X | X | X | 2% | 0% | |
| [1iFf](1iFf.txt) | v0.4 Raspberry Pi 2 B+ (BCM2836) | 0%/0.7% | 976M/872M | X | X | X | X | 2% | 0% | |
| [1iFm](1iFm.txt) | v0.4 Rock64 (RK3328) | 0%/1.5% | 1.9G/1.6G | X | X | X | X | 2% | 0% | |
| [1iFp](1iFp.txt) | v0.4 RockPro64 (RK3399) | 0%/0.7% | 3.8G/3.6G | X | X | X | X | 0% | 1% | |
| [1iFx](1iFx.txt) | v0.4 Renegade (RK3328) | 0.5%/0% | 3.8G/3.5G | X | X | X | X | 2% | 0% | |
| [1iFz](1iFz.txt) | v0.4 NanoPC T4 (RK3399) | 0.2%/0.6% | 3.8G/3.5G | X | X | X | X | 0% | 0% | |
| [1iGM](1iGM.txt) | v0.4 Raspberry Pi 3 B+ (BCM2837B0) | 0%/0.2% | 927M/814M | X | X | X | X | 1% | <span style=color:red>**33%**</span> | |
| [1iGW](1iGW.txt) | v0.4 Rock64 (RK3328) | 0%/0% | 1.9G/1.8G | X | X | X | X | 1% | <span style=color:red> 7%</span> | |
| [1iGz](1iGz.txt) | v0.4 Raspberry Pi 3 B+ (BCM2837B0) | 0.1%/0% | 927M/813M | X | X | X | X | 2% | <span style=color:red>**25%**</span> | |
| [1iH0](1iH0.txt) | v0.4 Raspberry Pi 3 B+ (BCM2837B0) | 0%/0% | 927M/819M | X | X | X | X | 2% | <span style=color:red>**30%**</span> | [check log](1iH0.txt) |
| [1iH4](1iH4.txt) | v0.4 Rock64 (RK3328) | 0.5%/0% | 1.9G/1.8G | X | X | X | X | 0% | <span style=color:red> 4%</span> | |
| [1iHB](1iHB.txt) | v0.4 Rock64 (RK3328) | 0.3%/0% | 1.9G/1.8G | X | X | X | X | 0% | <span style=color:red> 5%</span> | |
| [1iHo](1iHo.txt) | v0.4 Rock64 (RK3328) | 0%/0% | 1.9G/1.8G | X | X | X | X | 1% | <span style=color:red> 6%</span> | |
| [1iI5](1iI5.txt) | v0.4 Raspberry Pi 3 B+ (BCM2837B0) | 0%/0.2% | 927M/822M | X | X | X | X | 1% | <span style=color:red>**22%**</span> | |
| [1iJ7](1iJ7.txt) | v0.4 Khadas VIM2 (Amlogic S912) | 0.9%/0% | 1.8G/1.5G | X | X | X | X | <span style=color:red>**27%**</span> | <span style=color:red>**16%**</span> | |
| [1iRJ](1iRJ.txt) | v0.4.6 NanoPi Fire3 | 0%/0% | 2.0G/1.8G | X | X | X | X | 0% | 0% | |
| [1isD](1isD.txt) | Raspberry Pi 3 B+ (BCM2837B0) | 0.8%/0.2% | 927M/810M | X | X | X | X | 1% | 0% | |
| [1ism](1ism.txt) | Raspberry Pi 3 B+ (BCM2837B0) | 0.1%/0.2% | 927M/816M | X | X | X | X | 1% | 0% | |
| [1iSQ](1iSQ.txt) | v0.4.6 Libre Technology CC | 0.2%/0% | 1.9G/1.6G | X | X | X | X | 0% | 0% | |
| [1iSX](1iSX.txt) | v0.4.6 Rockchip RK3288 Tinker Board | 0.2%/5.1% | 2.0G/1.7G | X | X | X | X | 2% | 0% | |
| [1iT1](1iT1.txt) | v0.4.6 NanoPi K2 (Amlogic S905) | 0.3%/0% | 1.9G/1.8G | X | X | X | X | 1% | 0% | |
| [1ivR](1ivR.txt) | RockPro64 arm64 | 0%/0.4% | 3.8G/3.7G | X | X | X | X | 1% | 1% | |
| [1iWL](1iWL.txt) | v0.5 Hardkernel Odroid XU4 | 3.2%/0.8% | 1.9G/1.8G | X | X | X | X | 2% | 0% | [check log](1iWL.txt) |
| [1iWU](1iWU.txt) | v0.5 FriendlyElec NanoPC-T4 | 0%/0.8% | 3.8G/3.5G | X | X | X | X | 2% | 0% | |
| [1iwz](1iwz.txt) | Rock64 (RK3328) | 0%/0.3% | 1.9G/1.7G | X | X | X | X | 2% | 0% | |
| [1iX4](1iX4.txt) | v0.5 Xunlong Orange Pi Plus / Plus 2 | 0.1%/0% | 2.0G/1.8G | X | X | X | X | 3% | 0% | |
| [1ixL](1ixL.txt) | ODROID-XU4 (Exynos 5422) | 0%/3.5% | 1.9G/513M | X | X | X | X | <span style=color:red>**12%**</span> | <span style=color:red>**39%**</span> | |
| [1iYK](1iYK.txt) | v0.5 Pine64 Rock64 | 0%/0% | 1.9G/1.7G | X | X | X | X | <span style=color:red> 8%</span> | 2% | |
| [1iyp](1iyp.txt) | NanoPC T3+ (Nexell S5P6818) | 0.5%/0% | 1.9G/1.6G | X | X | X | X | 1% | 0% | |
| [1iZj](1iZj.txt) | v0.5 Pine64 Rock64 | 0.3%/0% | 1.9G/1.7G | X | X | X | X | 2% | 0% | |
| [1iZq](1iZq.txt) | v0.5 FriendlyElec NanoPC-T4 | 0%/0.6% | 3.8G/3.5G | X | X | X | X | 1% | 0% | |
| [1j1L](1j1L.txt) | v0.5 Olimex A10-OLinuXino-LIME | 8.3%/5.3% | 493M/430M | X | X | X | X | <span style=color:red> 9%</span> | 0% | |
| [1jCy](1jCy.txt) | v0.5.3 Helios4 | 0.3%/0.3% | 2.0G/1.8G | X | X | X | X | <span style=color:red>**33%**</span> | 0% | |
| [1jEr](1jEr.txt) | v0.5.4 Pine H64 | 0%/0% | 2.0G/1.8G | X | X | X | X | 1% | 0% | [check log](1jEr.txt) |
| [1jiU](1jiU.txt) | v0.5.3 NanoPi Fire3 | 0%/0% | 990M/878M | X | X | X | | 0% | 0% | |
| [1jjm](1jjm.txt) | v0.5.3 NanoPi Fire3 | 0%/0% | 990M/882M | X | X | X | | 0% | 0% | |
| [1kt2](1kt2.txt) | v0.5.4 Globalscale Marvell ESPRESSOBin | 0%/0.1% | 993M/859M | X | X | X | X | 1% | 0% | |
| [1lBC](1lBC.txt) | v0.6.1 Pine64 RockPro64 | 0%/0.3% | 3.8G/3.7G | X | X | X | X | 1% | 0% | |
| [1lCe](1lCe.txt) | v0.6.1 Globalscale Marvell ESPRESSOBin | 0%/0% | 992M/750M | X | X | X | X | <span style=color:red> 7%</span> | <span style=color:red>**34%**</span> | |
| [1lgD](1lgD.txt) | v0.5.4 x5-Z8300 | 0.3%/0.2% | 1.9G/1.6G | X | X | X | X | 2% | 0% | |
| [1lkG](1lkG.txt) | v0.5.4 FriendlyElec NanoPC-T4 | 0%/1.5% | 3.7G/3.6G | X | X | X | X | 1% | 0% | |
| [1lzP](1lzP.txt) | v0.5.6 FriendlyElec NanoPi M4 | 0.6%/0.8% | 2.0G/1.8G | X | X | X | X | 1% | 0% | [check log](1lzP.txt) |
| [1m5p](1m5p.txt) | v0.6.1 Celeron J3455 | 0%/0.1% | 3.5G/2.5G | X | X | X | X | 1% | 1% | |
| [1m5t](1m5t.txt) | v0.6.1 Pentium J4205 | 1.1%/0% | 7.6G/6.0G | X | X | X | X | 4% | 0% | |
| [1MFD](1MFD.txt) | v0.6.7 Khadas VIM3 | 0%/0.7% | 1.9G/1.6G | X | X | X | X | 2% | 0% | |
| [1MFf](1MFf.txt) | v0.6.7 Raspberry Pi 4 Model B Rev 1.1 | 0.1%/0.2% | 3.8Gi/3.6Gi | X | X | X | X | 3% | 0% | [check log](1MFf.txt) |
| [1ngq](1ngq.txt) | v0.6.1 Pentium N4200 | 0%/0% | 3.7G/3.3G | X | X | X | X | 1% | 0% | |
| [1niO](1niO.txt) | v0.6.1 Raspberry Pi Zero W Rev 1.1 | 0%/0% | 433M/345M | X | X | X | | 3% | 1% | |
| [1oho](1oho.txt) | v0.6.1 FriendlyElec NanoPi M4 | 0%/0.3% | 919M/770M | X | X | X | | 1% | 0% | [check log](1oho.txt) |
| [1oib](1oib.txt) | v0.6.1 FriendlyElec NanoPi NEO4 | 0%/0.3% | 919M/769M | X | X | X | | 1% | 0% | |
| [1oim](1oim.txt) | v0.6.1 FriendlyElec NanoPi M4 | 0%/0.4% | 919M/769M | X | X | X | | 1% | 0% | |
| [1p3T](1p3T.txt) | v0.6.1 FriendlyElec NanoPi NEO4 | 0%/0.5% | 992M/825M | X | X | X | | 1% | 0% | |
| [1qal](1qal.txt) | v0.6.2 Celeron J4105 | 0%/0.3% | 7.6G/7.2G | X | X | X | X | 1% | 0% | |
| [1qb0](1qb0.txt) | v0.6.2 Celeron J4105 | 0%/0% | 31G/30G | X | X | X | X | 1% | 0% | |
| [1Rnj](1Rnj.txt) | v0.6.8 icosa | 0.1%/0% | 3.4Gi/2.6Gi | X | X | X | X | 4% | <span style=color:red> 6%</span> | |
| [1rYm](1rYm.txt) | v0.6.2 Khadas Captain | 0.2%/0.2% | 3.7G/3.6G | X | X | X | X | 1% | 0% | [check log](1rYm.txt) |
| [1tJg](1tJg.txt) | v0.6.2 Olimex A64 Teres-I | 0.6%/0.6% | 1.9G/1.6G | X | X | X | X | 2% | 0% | |
| [1uar](1uar.txt) | v0.6.2 Khadas Captain | 0.3%/0.6% | 3.7G/3.6G | X | X | X | X | 1% | 0% | [check log](1uar.txt) |
| [1ub9](1ub9.txt) | v0.6.2 Pine64 RockPro64 | 0%/0.5% | 3.8G/3.7G | X | X | X | X | 1% | 0% | |
| [1uTS](1uTS.txt) | v0.6.2 Celeron N4100 | 0%/2.1% | 3.7G/2.1G | X | X | X | X | 2% | 2% | |
| [21fX](21fX.txt) | v0.6.9 Radxa ROCK Pi 4 | 0%/0.6% | 3.8G/3.5G | X | X | X | X | 2% | 0% | |
| [21rE](21rE.txt) | v0.6.9 Pentium J5005 | 0%/0% | 7.6G/6.1G | X | X | X | X | 3% | 0% | |
| [26Ph](26Ph.txt) | v0.6.9 Pine H64 | 0%/0.8% | 1.9Gi/1.7Gi | X | X | X | X | 1% | 0% | |
| [26Wy](26Wy.txt) | v0.6.9 Khadas VIM3L | 0%/0% | 1.8G/1.6G | X | X | X | X | 2% | 0% | |
| [27FC](27FC.txt) | v0.6.9 SolidRun i.MX8MQ HummingBoard Pu | 1.3%/0.3% | 2.9Gi/2.7Gi | X | X | X | X | 0% | 0% | |
| [2Cyi](2Cyi.txt) | v0.7.4 Raspberry Pi 400 Rev 1.0 | 0%/0.9% | 3.7Gi/3.4Gi | X | X | X | X | 3% | 0% | |
| [2ICt](2ICt.txt) | v0.7.5 Hugsun X99 TV BOX | 0%/0.7% | 3.7Gi/3.4Gi | X | X | X | X | 0% | 0% | |
| [2iFY](2iFY.txt) | v0.7.1 Amazon a1.xlarge | 0%/0% | 7.5G/7.2G | X | X | X | X | 1% | 0% | |
| [2Jdb](2Jdb.txt) | v0.7.2 x5-Z8350 | 0%/0% | 3.8Gi/2.6Gi | X | X | X | X | 4% | <span style=color:red>**21%**</span> | |
| [2jVw](2jVw.txt) | v0.7.1 Pentium G4600 | 0%/0% | 31Gi/30Gi | X | X | X | X | 0% | 0% | |
| [2kaS](2kaS.txt) | v0.7.1 Hardkernel ODROID-C4 | 0%/0% | 3.6Gi/3.2Gi | X | X | X | X | 1% | 0% | |
| [2kTH](2kTH.txt) | v0.7.2 Xunlong Orange Pi Prime | 0%/0% | 1.9Gi/1.6Gi | X | X | X | X | 2% | 0% | |
| [2sZH](2sZH.txt) | v0.7.2 Pine64 RockPro64 | 0%/0.6% | 3.8Gi/3.5Gi | X | X | X | X | 2% | 0% | [check log](2sZH.txt) |
| [2tQQ](2tQQ.txt) | v0.7.2 AMD Ryzen Embedded R1606G with R | 0.5%/0.2% | 3.3Gi/1.9Gi | X | X | X | X | 1% | 0% | |
| [2yIx](2yIx.txt) | v0.7.2 Pine64 RockPro64 v2.1 | 0%/0.4% | 3.7Gi/3.3Gi | X | X | X | X | 1% | 1% | |
| [3DeL](3DeL.txt) | v0.7.9 Raspberry Pi Zero 2 Rev 1.0 | 0.5%/0.2% | 427Mi/219Mi | X | X | | | 3% | 1% | |
| [3Dfo](3Dfo.txt) | v0.7.9 Raspberry Pi Zero 2 Rev 1.0 | 0.6%/0.3% | 427Mi/277Mi | X | X | | | 2% | 0% | |
| [3Di2](3Di2.txt) | v0.8.1 Nintendo Switch | 0%/0% | 3.9G/3.5G | X | X | X | X | 1% | 0% | |
| [3DtN](3DtN.txt) | v0.8.1 Hardkernel ODROID-N2Plus | 0%/0% | 3.6Gi/2.7Gi | X | X | X | X | 0% | 0% | |
| [3E85](3E85.txt) | v0.8.3 Raspberry Pi Zero 2 Rev 1.0 | 2.6%/0.9% | 427Mi/267Mi | X | X | | | 3% | 0% | |
| [3EgS](3EgS.txt) | v0.8.4 Raspberry Pi 4 Model B Rev 1.1 | 0.5%/0.4% | 857Mi/695Mi | X | X | X | | 2% | 0% | |
| [3F9C](3F9C.txt) | v0.8.4 Raspberry Pi 4 Model B Rev 1.1 | 0%/0.6% | 959Mi/815Mi | X | X | X | X | <span style=color:red>**12%**</span> | 0% | |
| [3Gia](3Gia.txt) | v0.8.5 Raspberry Pi 4 Model B Rev 1.1 | 2.0%/1.0% | 857Mi/696Mi | X | X | X | X | 3% | 0% | |
| [3GmR](3GmR.txt) | v0.8.6 FriendlyARM NanoPi NEO4 | 0%/0.7% | 977Mi/714Mi | X | X | X | X | 1% | 0% | |
| [3GnC](3GnC.txt) | v0.8.6 Hardkernel Odroid XU4 | 0%/0.9% | 1.9Gi/1.7Gi | X | X | X | X | 4% | 0% | [check log](3GnC.txt) |
| [3HUU](3HUU.txt) | v0.8.8 Celeron N4500 | 0.2%/0% | 7,5Gi/6,4Gi | X | X | X | X | 1% | 0% | |
| [3IlQ](3IlQ.txt) | v0.8.8 Celeron N5100 | 0%/0% | 7.6Gi/7.2Gi | X | X | X | X | 3% | 0% | |
| [3InF](3InF.txt) | v0.8.8 Raspberry Pi 4 Model B Rev 1.1 | 0%/0.5% | 958Mi/747Mi | X | X | X | X | <span style=color:red>**33%**</span> | 0% | |
| [3JCm](3JCm.txt) | v0.8.8 Radxa Zero | 0.3%/0.8% | 3.7Gi/3.4Gi | X | X | X | X | 1% | 0% | |
| [3KVs](3KVs.txt) | v0.9.0 Raspberry Pi 4 Model B Rev 1.4 | 1.9%/0.7% | 3.7Gi/3.4Gi | X | X | X | X | 4% | 0% | |
| [3L37](3L37.txt) | v0.9.0 Raspberry Pi 4 Model B Rev 1.4 | 0.3%/0.6% | 3.7Gi/3.3Gi | X | X | X | X | 4% | 0% | |
| [3Lir](3Lir.txt) | v0.9.1 ASUS Tinker Board | 0.5%/0% | 2.0Gi/1.5Gi | X | X | X | X | 2% | 0% | |
| [3Llk](3Llk.txt) | v0.8.7 Raspberry Pi 4 Model B Rev 1.4 | 1.7%/0.4% | 3.7Gi/2.5Gi | X | X | X | X | <span style=color:red> 8%</span> | 0% | [check log](3Llk.txt) |
| [3M9F](3M9F.txt) | v0.9.1 Generic RK322x TV Box board | 1.6%/0.5% | 1.9Gi/1.7Gi | X | X | X | X | <span style=color:red> 5%</span> | 0% | |
| [3MAK](3MAK.txt) | v0.9.1 FriendlyElec NanoPi M4 Ver2.0 | 0.3%/0.3% | 3.8Gi/3.4Gi | X | X | X | X | 2% | 1% | |
| [3MGN](3MGN.txt) | v0.9.1 Raspberry Pi Model B Rev 2 | 1.4%/1.1% | 429Mi/347Mi | X | X | X | | 2% | 0% | [check log](3MGN.txt) |
| [3MGs](3MGs.txt) | v0.9.1 Raspberry Pi 2 Model B Rev 1.1 | 0.8%/0.2% | 922Mi/835Mi | X | X | X | X | 2% | 0% | |
| [3MiR](3MiR.txt) | v0.9.1 TRONFY MXQ S805 | 1.1%/0% | 987Mi/794Mi | X | X | X | X | 2% | 0% | |
| [3MQJ](3MQJ.txt) | v0.9.1 Xunlong Orange Pi PC 2 | 0%/0% | 985Mi/753Mi | X | X | X | X | <span style=color:red>**13%**</span> | 0% | |
| [3MQV](3MQV.txt) | v0.9.1 Xunlong Orange Pi PC Plus | 0%/0% | 999Mi/779Mi | X | X | X | X | 2% | 0% | |
| [3MuT](3MuT.txt) | v0.9.1 Hardkernel ODROID-N2 | 0%/0.2% | 3.6Gi/3.3Gi | X | X | X | X | 1% | 0% | |
| [3N1U](3N1U.txt) | v0.9.2 SBC2D70 | 1.1%/0% | 113Mi/32Mi | X | | | | 0% | 0% | |
| [3N2z](3N2z.txt) | v0.9.2 FriendlyArm NanoPi M1 Plus | 0.7%/0% | 999M/836M | X | X | X | X | 2% | 0% | |
| [3N5c](3N5c.txt) | v0.9.2 bigboy | 0%/0% | 31Gi/29Gi | X | X | X | X | 1% | 0% | |
| [3N7H](3N7H.txt) | v0.9.2 FriendlyElec NanoPi K1 Plus | 0%/1.3% | 1.9Gi/1.7Gi | X | X | X | X | 2% | 0% | |
| [3N94](3N94.txt) | v0.9.2 RPi 4 Model B Rev 1.4 / BCM2711 | 0%/0% | 7.7Gi/7.4Gi | X | X | X | X | 4% | <span style=color:red>**12%**</span> | |
| [3Na5](3Na5.txt) | v0.9.2 Hardkernel ODROID-HC4 | 0%/0% | 3.7Gi/3.5Gi | X | X | X | X | 1% | 0% | |
| [3Naw](3Naw.txt) | v0.9.2 Cubietech Cubietruck | 8.3%/8.8% | 2,0Gi/1,8Gi | X | X | X | X | <span style=color:red> 8%</span> | <span style=color:red> 5%</span> | |
| [3Njz](3Njz.txt) | v0.9.2 Raspberry Pi Zero W Rev 1.1 | 0.9%/0.8% | 477Mi/416Mi | X | X | X | X | <span style=color:red> 5%</span> | 0% | |
| [3OBF](3OBF.txt) | v0.9.2 RPi 4 Model B Rev 1.1 / BCM2711 | 0%/0.6% | 909Mi/765Mi | X | X | X | X | 4% | 2% | |
| [3Owk](3Owk.txt) | v0.9.2 bigboy | 0%/0% | 127Gi/108Gi | X | X | X | X | 1% | 1% | |
| [3Owv](3Owv.txt) | v0.9.2 bigboy | 0%/0% | 127Gi/108Gi | X | X | X | X | 1% | 0% | |
| [3PLr](3PLr.txt) | v0.9.3 LeMaker Banana Pi | 8.2%/8.6% | 997Mi/862Mi | X | X | X | X | <span style=color:red> 7%</span> | 0% | |
| [3Q2q](3Q2q.txt) | v0.9.3 Radxa ROCK Pi 4B | 0.2%/0.3% | 3.8Gi/3.5Gi | X | X | X | X | 2% | 0% | |
| [3Qf7](3Qf7.txt) | v0.9.3 Celeron N5105 | 0%/0% | 7.5Gi/6.4Gi | X | X | X | X | 2% | 0% | |
| [3QOj](3QOj.txt) | v0.9.3 AMedia X96 Max+ | 0%/0.8% | 3.7Gi/3.4Gi | X | X | X | X | 1% | 0% | |
| [3Qve](3Qve.txt) | v0.9.3 FriendlyARM NanoPi K2 | 0.9%/0.9% | 1.9Gi/1.6Gi | X | X | X | X | 1% | 1% | |
| [3R1a](3R1a.txt) | v0.9.3 Hardkernel ODROID-N2Plus | 0%/0% | 3,7Gi/3,4Gi | X | X | X | X | 1% | 0% | |
| [3R2Z](3R2Z.txt) | v0.9.3 Khadas VIM3 | 0%/0% | 3.7Gi/3.3Gi | X | X | X | X | 0% | 0% | |
| [3R3N](3R3N.txt) | v0.9.3 Akaso M8S | 0%/0.4% | 986Mi/873Mi | X | X | X | X | 1% | <span style=color:red>**11%**</span> | [check log](3R3N.txt) |
| [3Rsg](3Rsg.txt) | v0.9.3 Firefly RK3568-ROC-PC HDMI | 0%/0% | 3.7Gi/3.4Gi | X | X | X | X | 2% | 0% | |
| [3rUb](3rUb.txt) | v0.7.7 Pine64 RK3566 Quartz64-A Board | 0%/0% | 3.8Gi/3.5Gi | X | X | X | X | 1% | 0% | |
| [3S5U](3S5U.txt) | v0.9.3 Tronsmart MXIII Plus | 0%/0.4% | 2.0Gi/1.7Gi | X | X | X | X | 2% | 0% | |
| [3TQ2](3TQ2.txt) | v0.9.3 Hardkernel ODROID-C4 | 0.3%/0% | 3.7Gi/3.2Gi | X | X | X | X | 4% | 0% | |
| [3Ufc](3Ufc.txt) | v0.9.3 NVIDIA Jetson Nano 2GB Developer | 1.3%/0.3% | 1.9G/1.5G | X | X | X | X | <span style=color:red> 5%</span> | 0% | |
| [3Ug9](3Ug9.txt) | v0.9.3 Hardkernel ODROID-M1 | 0%/0% | 7.3Gi/7.0Gi | X | X | X | X | 2% | 0% | |
| [3Vdt](3Vdt.txt) | v0.9.3 Khadas VIM3L | 0%/0% | 1.8Gi/1.1Gi | X | X | X | X | 4% | 3% | |
| [3VME](3VME.txt) | v0.9.3 RPi 4 Model B Rev 1.1 / BCM2711 | 1.9%/0.2% | 967Mi/807Mi | X | X | X | X | <span style=color:red>**12%**</span> | 0% | |
| [3Wvv](3Wvv.txt) | v0.9.4 Khadas VIM4 | 0%/0.2% | 7.8Gi/6.6Gi | X | X | X | X | 2% | 0% | |
| [3X9q](3X9q.txt) | v0.9.4 Rockchip RK3288 Asus Tinker Boar | 0.3%/0.2% | 2.0Gi/1.8Gi | X | X | X | X | 2% | 0% | |
| [3Y4f](3Y4f.txt) | v0.9.6 keeper.lan | 0.3%/0% | 30Gi/29Gi | X | X | X | X | 2% | 0% | |
| [3YWp](3YWp.txt) | v0.9.7 NVIDIA Jetson Xavier NX Develope | 1.9%/0.8% | 7.6G/5.2G | X | X | X | X | 2% | 0% | |
| [3ZxU](3ZxU.txt) | v0.9.8 NanoPi Fire3 extensive | 0%/0% | 994Mi/853Mi | X | X | X | X | <span style=color:red> 8%</span> | 0% | |
| [408h](408h.txt) | v0.9.8 Ugoos UT2 | 0%/0% | 2.0Gi/1.8Gi | X | X | X | X | 2% | 0% | |
| [40BJ](40BJ.txt) | v0.9.8 Allwinner D1 | 3.0%/1.5% | 960Mi/852Mi | X | X | X | X | 4% | 0% | |
| [40cj](40cj.txt) | v0.9.8 Libre Computer AML-S912-PC | 0%/0% | 1.8Gi/1.6Gi | X | X | X | X | <span style=color:red>**53%**</span> | 3% | |
| [40TX](40TX.txt) | v0.9.8 Radxa ROCK3 Model A | 0.6%/0% | 3.8Gi/3.5Gi | X | X | X | X | 2% | 0% | |
| [4132](4132.txt) | v0.9.8 SolidRun Cubox-i Dual/Quad | 2.3%/0% | 2.0Gi/1.8Gi | X | X | X | X | 3% | <span style=color:red>** 9%**</span> | |
| [41AB](41AB.txt) | v0.9.8 T-HEAD c910 ice | 0%/0.4% | 3.4Gi/3.3Gi | X | X | X | X | 3% | 1% | |
| [41BH](41BH.txt) | v0.9.8 Radxa ROCK 5B extensive | 0%/0% | 15Gi/15Gi | X | X | X | X | 1% | 0% | [check log](41BH.txt) |
| [41ML](41ML.txt) | v0.9.8 Tronsmart S82 | 0.8%/1.0% | 2.0Gi/1.7Gi | X | X | X | X | 2% | <span style=color:red> 7%</span> | |
| [41Qa](41Qa.txt) | v0.9.8 canaan-creative,k510 | 0%/0% | 192Mi/131Mi | | | | | 4% | 1% | |
| [443N](443N.txt) | v0.9.8 Apple MacBook Pro | 0.2%/8.9% | 15Gi/14Gi | X | X | X | X | 1% | 0% | |
| [445T](445T.txt) | v0.9.8 PHYTIUM LTD D2000 | 0%/2.4% | 15Gi/15Gi | X | X | X | X | 2% | 0% | |
| [446h](446h.txt) | v0.9.8 PHYTIUM LTD D2000 | 0%/3.3% | 31Gi/30Gi | X | X | X | X | 2% | 0% | |
| [44pd](44pd.txt) | v0.9.8 Silicom Minnowboard Turbot D0/D1 | 3.1%/0% | 1.8Gi/1.6Gi | X | X | X | X | 2% | 0% | |
| [461n](461n.txt) | v0.9.8 Dell Inc. Inspiron 1011 A06 / At | 2.9%/0.3% | 992Mi/668Mi | X | X | X | X | 2% | 2% | |
| [466y](466y.txt) | v0.9.8 Mediatek MT6580 K9M1-test board | 0%/0% | 878Mi/683Mi | X | X | X | X | 1% | <span style=color:red>**14%**</span> | |
| [46hs](46hs.txt) | v0.9.8 PXA1908 | 0.8%/1.0% | 661Mi/601Mi | X | X | X | X | <span style=color:red>**12%**</span> | 0% | |
| [49kx](49kx.txt) | v0.9.8 Qualcomm Technologies, Inc. qrb5 | 0.9%/4.2% | 7.5G/7.0G | X | X | X | X | 1% | 0% | |
| [4a5U](4a5U.txt) | v0.9.8 Khadas Edge2 | 0%/0% | 15Gi/14Gi | X | X | X | X | 1% | 0% | |
| [4ax9](4ax9.txt) | v0.9.8 NVIDIA Orin Jetson-Small Develop | 0%/0% | 29Gi/29Gi | X | X | X | X | 0% | 0% | |
| [4bbv](4bbv.txt) | v0.9.8 Khadas VIM1S | 0.5%/1.1% | 1.9Gi/1.1Gi | X | X | X | X | 3% | 0% | |
| [4bee](4bee.txt) | v0.9.9 Khadas VIM | 0.6%/0% | 801Mi/622Mi | X | X | X | X | 1% | 0% | |
| [4bSf](4bSf.txt) | v0.9.9 MangoPi Mcore | 0.4%/0% | 984Mi/789Mi | X | X | X | X | <span style=color:red>**63%**</span> | 1% | |
| [4BtC](4BtC.txt) | v0.9.42 GoWin Solution R86S 1.0 / Penti | 0%/0% | 31Gi/29Gi | X | X | X | X | 2% | 0% | [check log](4BtC.txt) |
| [4cHh](4cHh.txt) | v0.9.9 Khadas VIM4 | 0%/0.3% | 7.8Gi/6.9Gi | X | X | X | X | 2% | 0% | |
| [4CPF](4CPF.txt) | v0.9.43 OrangePi Zero3 | 0%/0% | 3.8Gi/3.5Gi | X | X | X | X | 1% | 1% | [check log](4CPF.txt) |
| [4D0a](4D0a.txt) | v0.9.44 Orange Pi 5 | 0%/0% | 7.8Gi/7.4Gi | X | X | X | X | 1% | 0% | [check log](4D0a.txt) |
| [4d1U](4d1U.txt) | v0.9.9 SolidRun Clearfog A1 | 0%/0% | 1.0Gi/873Mi | X | X | X | X | 1% | 0% | |
| [4dd5](4dd5.txt) | v0.9.9 AAEON UP-APL03 V1.0 / Atom | 0%/0% | 3.7Gi/2.6Gi | X | X | X | X | 2% | 1% | |
| [4DLw](4DLw.txt) | v0.9.44 BeagleBoard.org BeagleBone AI-6 | 0%/0% | 2.1Gi/1.9Gi | X | X | X | X | 2% | <span style=color:red> 6%</span> | [check log](4DLw.txt) |
| [4dO7](4dO7.txt) | v0.9.9 Bananapi BPI-R2 | 0%/0% | 2.0Gi/1.8Gi | X | X | X | X | 2% | <span style=color:red>** 8%**</span> | |
| [4dzX](4dzX.txt) | v0.9.9 Katyusha-Loongson | 0.6%/0.4% | 31Gi/29Gi | X | X | X | X | 0% | 0% | |
| [4ebH](4ebH.txt) | v0.9.9 Jetson-AGX | 0.3%/0.6% | 31G/29G | X | X | X | X | 1% | 0% | |
| [4eg5](4eg5.txt) | v0.9.9 Hardkernel ODROID-C1 | 0.2%/2.3% | 990Mi/874Mi | X | X | X | X | 2% | 1% | |
| [4eiM](4eiM.txt) | v0.9.9 / Celeron 5205U @ 1.90GHz | 0%/0% | 7.6Gi/6.4Gi | X | X | X | X | 1% | 0% | |
| [4eOo](4eOo.txt) | v0.9.9 / Athlon | 0%/0.3% | 5.8Gi/4.8Gi | X | X | X | X | 1% | 0% | |
| [4fdD](4fdD.txt) | v0.9.9 OnePlus 5 | 2.7%/0.6% | 5.5Gi/5.2Gi | X | X | X | X | 1% | 1% | |
| [4hau](4hau.txt) | v0.9.9 Fanless Mini PC Quieter2 / Celer | 0.2%/0% | 7.6Gi/6.4Gi | X | X | X | X | 2% | 2% | |
| [4Hd0](4Hd0.txt) | v0.9.45 OrangePi Zero2 W | 0%/0% | 981Mi/775Mi | X | X | X | X | <span style=color:red>**40%**</span> | 2% | [check log](4Hd0.txt) |
| [4HdL](4HdL.txt) | v0.9.46 Hetzner Neoverse-N1 kvm VM | 0%/0% | 3.7Gi/3.4Gi | X | X | X | X | 1% | 0% | |
| [4hKV](4hKV.txt) | v0.9.9 / Celeron J1900 @ 1.99GHz | 0%/0% | 7.7Gi/6.9Gi | X | X | X | X | 3% | 0% | |
| [4hOP](4hOP.txt) | v0.9.9 Raspberry Pi 3 Model B Rev 1.2 | 0%/0% | 909Mi/796Mi | X | X | X | X | 2% | <span style=color:red>** 9%**</span> | [check log](4hOP.txt) |
| [4hwl](4hwl.txt) | v0.9.9 ASUSTeK Computer Inc. U32U 1.0 | 0.4%/0.3% | 5,4Gi/3,2Gi | X | X | X | X | <span style=color:red> 5%</span> | 0% | |
| [4hx0](4hx0.txt) | v0.9.9 NXP i.MX8MPlus EVK board | 1.5%/0.1% | 5.5Gi/4.9Gi | X | X | X | X | 2% | <span style=color:red> 6%</span> | |
| [4HYd](4HYd.txt) | v0.9.47 HP HP t640 Thin Client / Ryzen | 0%/0% | 5.7Gi/4.4Gi | X | X | X | X | 4% | 0% | [check log](4HYd.txt) |
| [4I93](4I93.txt) | v0.9.47 Hlink H28K | 0%/0% | 1.9Gi/1.6Gi | X | X | X | X | 2% | 0% | [check log](4I93.txt) |
| [4iDX](4iDX.txt) | v0.9.9 / Atom | 0%/0% | 3.7Gi/3.3Gi | X | X | X | X | 2% | 0% | |
| [4ijy](4ijy.txt) | v0.9.9 Hardkernel ODROID-M1 | 0%/0% | 3.6Gi/3.3Gi | X | X | X | X | 1% | 0% | |
| [4ioj](4ioj.txt) | v0.9.9 WEIBU F20A V1000 | 0%/1.6% | 15Gi/15Gi | X | X | X | X | 1% | 0% | |
| [4j4o](4j4o.txt) | v0.9.9 Insyde CherryTrail Type1 - TBD b | 0.6%/0.6% | 3.7Gi/3.1Gi | X | X | X | X | 4% | 0% | |
| [4jfZ](4jfZ.txt) | v0.9.9 FriendlyElec NanoPi R5S | 0%/0% | 3.7Gi/3.4Gi | X | X | X | X | 1% | 0% | |
| [4ju5](4ju5.txt) | v0.9.9 SolidRun LX2160A Clearfog CX | 0%/0.7% | 5.7Gi/3.4Gi | X | X | X | X | 1% | 0% | |
| [4K7E](4K7E.txt) | v0.9.49 Milk-V Mars CM eMMC | 0%/0% | 3.8Gi/3.3Gi | X | X | X | X | 2% | 0% | [check log](4K7E.txt) |
| [4Kau](4Kau.txt) | v0.9.49 OrangePi 4 | 0%/0% | 3.8Gi/3.2Gi | X | X | X | X | 2% | 1% | [check log](4Kau.txt) |
| [4kEp](4kEp.txt) | v0.9.9 volterra | 1.1%/0.5% | 15Gi/15Gi | X | X | X | X | 1% | 0% | |
| [4kFQ](4kFQ.txt) | v0.9.9 10ZiG Technology. 44xx Type1 - T | 0%/0.2% | 1.8Gi/1.4Gi | X | X | X | X | 4% | <span style=color:red> 4%</span> | |
| [4kiu](4kiu.txt) | v0.9.9 HUAQIN P6410 HQ3110BR49000 | 0%/0% | 375Gi/370Gi | X | X | X | X | 0% | 0% | |
| [4kmM](4kmM.txt) | v0.9.9 Banana Pi BPI-M2-Ultra | 0%/0.1% | 997Mi/874Mi | X | X | X | X | 2% | 0% | |
| [4knM](4knM.txt) | v0.9.9 Orange Pi Zero 2 | 1.3%/0% | 960Mi/849Mi | X | X | X | X | <span style=color:red>**24%**</span> | <span style=color:red>** 8%**</span> | |
| [4knR](4knR.txt) | v0.9.9 Allwinner D1 Nezha | 8.3%/6.1% | 980Mi/859Mi | X | X | X | X | <span style=color:red> 9%</span> | 2% | [check log](4knR.txt) |
| [4kor](4kor.txt) | v0.9.9 Rockchip RK3318 BOX | 0%/2.1% | 1.9Gi/1.4Gi | X | X | X | X | 2% | 0% | |
| [4Kqn](4Kqn.txt) | v0.9.49 AMD Seattle | 0%/0% | 31G/30G | X | X | X | X | 1% | 0% | |
| [4Kvg](4Kvg.txt) | v0.9.49 MediaTek Genio-1200 EVK | 0%/0% | 7.6Gi/6.4Gi | X | X | X | X | 1% | 0% | [check log](4Kvg.txt) |
| [4L4k](4L4k.txt) | v0.9.50 Radxa ZERO 3 | 0%/0% | 979Mi/781Mi | X | X | X | X | <span style=color:red>**29%**</span> | 0% | [check log](4L4k.txt) |
| [4Lyf](4Lyf.txt) | v0.9.50 Google Homestar | 0%/0% | 3.8Gi/2.5Gi | X | X | X | X | 2% | 0% | [check log](4Lyf.txt) |
| [4nt8](4nt8.txt) | v0.9.13 Beijin Cloud Times S13XS / Atom | 0.2%/0.2% | 3.8Gi/3.5Gi | X | X | X | X | 2% | 0% | |
| [4o1A](4o1A.txt) | v0.9.19 Khadas VIM3 | 0%/0% | 3.7Gi/3.5Gi | X | X | X | X | 1% | 0% | |
| [4pEc](4pEc.txt) | v0.9.36 / Celeron N2830 @ 2.16GHz | 0%/0% | 3.7Gi/3.2Gi | X | X | X | X | <span style=color:red> 6%</span> | <span style=color:red>**32%**</span> | [check log](4pEc.txt) |
| [4qJF](4qJF.txt) | v0.9.39 Pine64 RK3566 Quartz64-A Board | 0%/0% | 7.5Gi/7.2Gi | X | X | X | X | 1% | 0% | [check log](4qJF.txt) |
| [4qpr](4qpr.txt) | v0.9.37 WeiBu ADL-N / i3-N305 extensive | 0%/0% | 7.5Gi/5.9Gi | X | X | X | X | 3% | 0% | [check log](4qpr.txt) |
| [4r54](4r54.txt) | v0.9.39 Insyde W8 CR50W8 / Atom | 0%/0% | 1.9Gi/1.5Gi | X | X | X | X | 3% | 0% | [check log](4r54.txt) |
| [4rJj](4rJj.txt) | v0.9.39 Celeron N3350 | 0%/0% | 5.6Gi/4.7Gi | X | X | X | X | <span style=color:red> 8%</span> | <span style=color:red> 5%</span> | [check log](4rJj.txt) |
| [4rLX](4rLX.txt) | v0.9.39 NVIDIA Jetson Nano Developer Ki | 0%/0% | 3.9Gi/3.4Gi | X | X | X | X | 0% | 0% | [check log](4rLX.txt) |
| [4rRV](4rRV.txt) | v0.9.39 Olimex A20-OLinuXino-LIME2 | 0%/0% | 998Mi/910Mi | X | X | X | X | <span style=color:red> 5%</span> | <span style=color:red>** 9%**</span> | [check log](4rRV.txt) |
| [4rWn](4rWn.txt) | v0.9.39 Hardkernel ODROID-N2Plus | 0%/0% | 3.7Gi/3.4Gi | X | X | X | X | 1% | 0% | [check log](4rWn.txt) |
| [4sNe](4sNe.txt) | v0.9.40 Radxa ROCK Pi S | 0%/0% | 474Mi/330Mi | | | | | <span style=color:red> 5%</span> | 2% | [check log](4sNe.txt) |
| [4tjq](4tjq.txt) | v0.9.40 Pine64 Star64 | 0%/0% | 7.7Gi/7.1Gi | X | X | X | X | 2% | 1% | [check log](4tjq.txt) |
| [4vfU](4vfU.txt) | v0.9.41 Rockchip RK3288 Asus Tinker Boa | 0%/0% | 2.0Gi/1.8Gi | X | X | X | X | 2% | 2% | [check log](4vfU.txt) |
| [4vNB](4vNB.txt) | v0.9.41 ATOPNUC ATOPNUC AG40 / Celeron | 0%/0% | 3.7Gi/3.3Gi | X | X | X | X | 1% | 0% | [check log](4vNB.txt) |
| [4vVG](4vVG.txt) | v0.9.41 Raspberry Pi Model B Rev 2 | 0%/0% | 476Mi/397Mi | X | X | X | X | 4% | 1% | [check log](4vVG.txt) |
| [4vy7](4vy7.txt) | v0.9.41 NVIDIA Orin Nano Developer Kit | 0%/0% | 6.3Gi/5.4Gi | X | X | X | X | 3% | 2% | [check log](4vy7.txt) |
| [4wYE](4wYE.txt) | v0.9.41 Sophgo Mango | 0%/0% | 125Gi/124Gi | X | X | X | X | <span style=color:red>**72%**</span> | 0% | [check log](4wYE.txt) |
| [4xOY](4xOY.txt) | v0.9.41 StarFive VisionFive V2 | 0%/0% | 7.7Gi/7.4Gi | X | X | X | X | 1% | 0% | [check log](4xOY.txt) |
| [4xwq](4xwq.txt) | v0.9.41 / N95 | 0%/0% | 15Gi/14Gi | X | X | X | X | 1% | 0% | [check log](4xwq.txt) |
| [4xwT](4xwT.txt) | v0.9.41 Microsoft Dev Kit 2023 | 0%/0% | 30Gi/29Gi | X | X | X | X | 0% | 0% | [check log](4xwT.txt) |
| [4xYE](4xYE.txt) | v0.9.41 T-HEAD Light Lichee Pi 4A confi | 0%/0% | 7.6Gi/7.4Gi | X | X | X | X | 2% | 0% | [check log](4xYE.txt) |
| [4z3s](4z3s.txt) | v0.9.42 clientron TC120 Type1 - TBD by | 0%/0% | 1.8Gi/1.0Gi | X | X | X | X | 2% | 0% | [check log](4z3s.txt) |
| [4zcm](4zcm.txt) | v0.9.42 Marvell 8040 MACCHIATOBin Doubl | 0%/0% | 3.8Gi/3.3Gi | X | X | X | X | 2% | 0% | [check log](4zcm.txt) |
| [4zGI](4zGI.txt) | v0.9.42 ADLINK Ampere Altra Developer P | 0%/0% | 93Gi/92Gi | X | X | X | X | 0% | 0% | [check log](4zGI.txt) |
| [4zkJ](4zkJ.txt) | v0.9.42 ADLINK AVA Developer Platform E | 0%/0% | 93Gi/91Gi | X | X | X | X | 0% | 0% | [check log](4zkJ.txt) |
| [5pv8oh](5pv8oh.txt) | v0.9.65 Radxa ROCK 5C | 0%/0% | 3.8Gi/3.5Gi | X | X | X | X | 2% | 0% | [check log](5pv8oh.txt) |
| [8-NK](8-NK.txt) | v0.9.68 Raspberry Pi 5 Model B Rev 1.1 | 0%/0% | 15Gi/15Gi | X | X | X | X | 1% | 0% | [check log](8-NK.txt) |
| [84GG](84GG.txt) | v0.9.71 phytium D3000 unattended | 0%/0% | 31Gi/30Gi | X | X | X | X | 1% | 0% | |
| [8acvqG](8acvqG.txt) | v0.9.61 Raspberry Pi 5 Model B Rev 1.0 | 0%/0% | 4.0Gi/3.8Gi | X | X | X | X | 2% | 0% | [check log](8acvqG.txt) |
| [8ctH](8ctH.txt) | v0.9.70 Hardkernel ODROID HC2 | 0%/0% | 1.9Gi/1.7Gi | X | X | X | X | 4% | 0% | [check log](8ctH.txt) |
| [8Qwk](8Qwk.txt) | v0.9.71 Luckfox Omni3576 | 0%/0% | 7.7Gi/7.5Gi | X | X | X | X | 2% | 0% | [check log](8Qwk.txt) |
| [8SWL](8SWL.txt) | v0.9.71 Qualcomm Technologies, Inc. X1E | 0%/0% | 30Gi/26Gi | X | X | X | X | 1% | 0% | [check log](8SWL.txt) |
| [8to7qX](8to7qX.txt) | v0.9.65 spacemit k1-x deb1 board | 0%/0% | 3.7Gi/3.5Gi | X | X | X | X | 3% | 3% | |
| [8WlQ](8WlQ.txt) | v0.9.71 Thundercomm, Inc. Rubik Pi C649 | 0%/0% | 7.2Gi/6.7Gi | X | X | X | X | 2% | 0% | |
| [Au3jaA](Au3jaA.txt) | v0.9.61 Raspberry Pi 5 Model B Rev 1.0 | 0%/0% | 4.0Gi/3.8Gi | X | X | X | X | 2% | 0% | [check log](Au3jaA.txt) |
| [C6zgdP](C6zgdP.txt) | v0.9.65 Radxa ROCK 5A | 0%/0% | 15Gi/15Gi | X | X | X | X | 1% | 0% | [check log](C6zgdP.txt) |
| [c9ZIGh](c9ZIGh.txt) | v0.9.66 Radxa ROCK 5C | 0%/0% | 3.8Gi/3.6Gi | X | X | X | X | 1% | 0% | [check log](c9ZIGh.txt) |
| [frdzAn](frdzAn.txt) | v0.9.65 Raspberry Pi 5 Model B Rev 1.0 | 0%/0% | 4.0Gi/3.8Gi | X | X | X | X | 1% | 0% | [check log](frdzAn.txt) |
| [fUCnrY](fUCnrY.txt) | v0.9.65 T-HEAD Light Lichee Pi 4A confi | 0%/0% | 15Gi/14Gi | X | X | X | X | <span style=color:red> 5%</span> | 0% | [check log](fUCnrY.txt) |
| [uHzXI7](uHzXI7.txt) | v0.9.65 ADL-N / N100 | 0%/0% | 7.5Gi/6.3Gi | X | X | X | X | 1% | 0% | |
| [X904](X904.txt) | v0.9.67 Milk-V | 0%/0% | 15Gi/14Gi | X | X | X | X | 2% | 0% | |
| [XObB](XObB.txt) | v0.9.67 / N100 | 0%/0% | 7.5Gi/6.5Gi | X | X | X | X | 2% | 0% | |
| [XUpQ](XUpQ.txt) | v0.9.68 Supermicro Super Server | 0%/0% | 510Gi/472Gi | X | X | X | X | 3% | 0% | |
| [XUSc](XUSc.txt) | v0.9.68 Radxa AICore BM1684x IO Board | 0%/0% | 3.0Gi/2.7Gi | X | X | X | X | 1% | 0% | |
| [Xv06](Xv06.txt) | v0.9.67 M1-MUSE-BOOK | 0%/0% | 15Gi/14Gi | X | X | X | X | 3% | 0% | |
| [XxZl](XxZl.txt) | v0.9.67 SiPEED LPi3A Board | 0%/0% | 7.6Gi/6.6Gi | X | X | X | X | 2% | 0% | |
| [Xyfg](Xyfg.txt) | v0.9.67 ESWIN EIC7700 | 0%/0% | 9.7Gi/9.1Gi | X | X | X | X | 1% | 0% | [check log](Xyfg.txt) |
| [XyIw](XyIw.txt) | v0.9.67 RK3588 OPi 5 Max | 0%/0% | 7.7Gi/7.1Gi | X | X | X | X | 1% | 0% | [check log](XyIw.txt) |
