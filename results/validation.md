# Result validation

  * Standard deviation reported by tinymembench when repeating the individual tests multiple times
  * RAM total/avail according to `free -h`
  * 22/23/24/25 are dictionary sizes 7-zip's internal benchmark is testing through. On systems low on memory the larger ones will be skipped (2^22 = 4 MB, 2^23 = 8 MB, 2^24 = 16 MB, 2^25 = 32 MB)
  * high `%system` values while benchmarking are an indication of background activity that might render benchmark results useless
  * high `%iowait` values while benchmarking are an indication of something going wrong, most probaly swapping happening which will render benchmark results partially useless
  * if mentioned throttling needs to be checked in the log

| Result | Version / device | Standard deviation | RAM total/avail | 22 | 23 | 24 | 25 | %system | %iowait | throttling |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | ----: | ----: | :---: |
| [1BrG](1BrG.txt) | v0.6.3 Hardkernel ODROID-N2 | 0%/0% | 3.6G/3.4G | X | X | X | X | 1% | 0% | |
| [1BsF](1BsF.txt) | v0.6.2 Hardkernel ODROID-N2 | 0%/0.1% | 3.6G/3.5G | X | X | X | X | 2% | 0% | |
| [1Dt1](1Dt1.txt) | v0.6.6 Realtek\_Lion\_Skin\_1GB | 0%/0% | 570M/313M | X | X | X | | 3% | 2% | |
| <del>[1ET3](1ET3.txt)</del> | <del>v0.6.6 SolidRun LX2160A COM express typ</del> | <del>0%/0%</del> | <del>60G/57G</del> | <del>X</del> | <del>X</del> | <del>X</del> | <del>X</del> | <del> 0%</del> | <del> 2%</del> | |
| [1HnC](1HnC.txt) | v0.6.6 x5-Z8350 | 0%/0% | 1.9G/1.6G | X | X | X | X | 2% | 0% | |
| [1I4j](1I4j.txt) | v0.6.7 jetson-nano | 0%/0% | 3.9G/3.0G | X | X | X | X | 1% | 0% | |
| [1MFD](1MFD.txt) | v0.6.7 Khadas VIM3 | 0%/0.7% | 1.9G/1.6G | X | X | X | X | 2% | 0% | |
| [1MFf](1MFf.txt) | v0.6.7 Raspberry Pi 4 Model B Rev 1.1 | 0.1%/0.2% | 3.8Gi/3.6Gi | X | X | X | X | 3% | 0% | [check log](1MFf.txt) |
| [1Rnj](1Rnj.txt) | v0.6.8 icosa | 0.1%/0% | 3.4Gi/2.6Gi | X | X | X | X | 4% | <span style=color:red> 6%</span> | |
| [1XKY](1XKY.txt) | v0.6.9 Radxa ROCK Pi S | 0%/0% | 425Mi/364Mi | X | X | | | 1% | 0% | |
| [1iFa](1iFa.txt) | v0.4 Clearfog Pro | 0%/0.2% | 1.0G/913M | X | X | X | X | 2% | 0% | |
| [1iFf](1iFf.txt) | v0.4 Raspberry Pi 2 B+ | 0%/0.7% | 976M/872M | X | X | X | X | 2% | 0% | |
| [1iFm](1iFm.txt) | v0.4 Rock64 | 0%/1.5% | 1.9G/1.6G | X | X | X | X | 2% | 0% | |
| [1iFp](1iFp.txt) | v0.4 RockPro64 | 0%/0.7% | 3.8G/3.6G | X | X | X | X | 0% | 1% | |
| [1iFx](1iFx.txt) | v0.4 Renegade | 0.5%/0% | 3.8G/3.5G | X | X | X | X | 2% | 0% | |
| [1iFz](1iFz.txt) | v0.4 NanoPC T4 | 0.2%/0.6% | 3.8G/3.5G | X | X | X | X | 0% | 0% | |
| [1iGM](1iGM.txt) | v0.4 Raspberry Pi 3 B+ | 0%/0.2% | 927M/814M | X | X | X | X | 1% | <span style=color:red>**33%**</span> | |
| [1iGV](1iGV.txt) | v0.4 BPi R2 | 0%/0% | 2.0G/1.8G | X | X | X | X | 1% | 0% | |
| [1iGW](1iGW.txt) | v0.4 Rock64 | 0%/0% | 1.9G/1.8G | X | X | X | X | 1% | <span style=color:red> 7%</span> | |
| [1iGz](1iGz.txt) | v0.4 Raspberry Pi 3 B+ | 0.1%/0% | 927M/813M | X | X | X | X | 2% | <span style=color:red>**25%**</span> | |
| [1iH0](1iH0.txt) | v0.4 Raspberry Pi 3 B+ | 0%/0% | 927M/819M | X | X | X | X | 2% | <span style=color:red>**30%**</span> | [check log](1iH0.txt) |
| [1iH4](1iH4.txt) | v0.4 Rock64 | 0.5%/0% | 1.9G/1.8G | X | X | X | X | 0% | <span style=color:red> 4%</span> | |
| [1iHB](1iHB.txt) | v0.4 Rock64 | 0.3%/0% | 1.9G/1.8G | X | X | X | X | 0% | <span style=color:red> 5%</span> | |
| [1iHo](1iHo.txt) | v0.4 Rock64 | 0%/0% | 1.9G/1.8G | X | X | X | X | 1% | <span style=color:red> 6%</span> | |
| [1iI5](1iI5.txt) | v0.4 Raspberry Pi 3 B+ | 0%/0.2% | 927M/822M | X | X | X | X | 1% | <span style=color:red>**22%**</span> | |
| [1iJ7](1iJ7.txt) | v0.4 Khadas VIM2 | 0.9%/0% | 1.8G/1.5G | X | X | X | X | <span style=color:red>**27%**</span> | <span style=color:red>**16%**</span> | |
| <del>[1iLy](1iLy.txt)</del> | <del>v0.4.3 Hardkernel Odroid XU4 </del> | <del>0%/1.1%</del> | <del>/</del> | <del>X</del> | <del>X</del> | <del>X</del> | <del>X</del> | <del> 2%</del> | <del> 0%</del> | |
| [1iRJ](1iRJ.txt) | v0.4.6 NanoPi Fire3 | 0%/0% | 2.0G/1.8G | X | X | X | X | 0% | 0% | |
| [1iSQ](1iSQ.txt) | v0.4.6 Libre Technology CC | 0.2%/0% | 1.9G/1.6G | X | X | X | X | 0% | 0% | |
| [1iSX](1iSX.txt) | v0.4.6 Rockchip RK3288 Tinker Board | 0.2%/5.1% | 2.0G/1.7G | X | X | X | X | 2% | 0% | |
| <del>[1iSh](1iSh.txt)</del> | <del>v0.4.6 Hardkernel ODROID-C2 </del> | <del>0.2%/0%</del> | <del>1.9G/1.8G</del> | <del>X</del> | <del>X</del> | <del>X</del> | <del>X</del> | <del> 0%</del> | <del> 0%</del> | |
| [1iT1](1iT1.txt) | v0.4.6 NanoPi K2 | 0.3%/0% | 1.9G/1.8G | X | X | X | X | 1% | 0% | |
| [1iWL](1iWL.txt) | v0.5 Hardkernel Odroid XU4 | 3.2%/0.8% | 1.9G/1.8G | X | X | X | X | 2% | 0% | [check log](1iWL.txt) |
| [1iWU](1iWU.txt) | v0.5 FriendlyElec NanoPC-T4 | 0%/0.8% | 3.8G/3.5G | X | X | X | X | 2% | 0% | |
| [1iX4](1iX4.txt) | v0.5 Xunlong Orange Pi Plus / Plus 2 | 0.1%/0% | 2.0G/1.8G | X | X | X | X | 3% | 0% | |
| [1iYK](1iYK.txt) | v0.5 Pine64 Rock64 | 0%/0% | 1.9G/1.7G | X | X | X | X | <span style=color:red> 8%</span> | 2% | |
| [1iZj](1iZj.txt) | v0.5 Pine64 Rock64 | 0.3%/0% | 1.9G/1.7G | X | X | X | X | 2% | 0% | |
| [1iZq](1iZq.txt) | v0.5 FriendlyElec NanoPC-T4 | 0%/0.6% | 3.8G/3.5G | X | X | X | X | 1% | 0% | |
| [1isD](1isD.txt) | Raspberry Pi 3 B+ | 0.8%/0.2% | 927M/810M | X | X | X | X | 1% | 0% | |
| [1ism](1ism.txt) | Raspberry Pi 3 B+ | 0.1%/0.2% | 927M/816M | X | X | X | X | 1% | 0% | |
| [1ivR](1ivR.txt) | RockPro64 arm64 | 0%/0.4% | 3.8G/3.7G | X | X | X | X | 1% | 1% | |
| <del>[1ivw](1ivw.txt)</del> | <del></del> | <del>0%/0%</del> | <del>927M/834M</del> | <del>X</del> | <del>X</del> | <del>X</del> | <del>X</del> | <del> 2%</del> | <del> 0%</del> | |
| [1iwz](1iwz.txt) | Rock64 | 0%/0.3% | 1.9G/1.7G | X | X | X | X | 2% | 0% | |
| [1ixL](1ixL.txt) | ODROID-XU4 | 0%/3.5% | 1.9G/513M | X | X | X | X | <span style=color:red>**12%**</span> | <span style=color:red>**39%**</span> | |
| [1ixi](1ixi.txt) | Khadas VIM2 | 0.4%/0% | 1.7G/1.3G | X | X | X | X | 1% | 0% | |
| [1iyp](1iyp.txt) | NanoPC T3+ | 0.5%/0% | 1.9G/1.6G | X | X | X | X | 1% | 0% | |
| [1j1L](1j1L.txt) | v0.5 Olimex A10-OLinuXino-LIME | 8.3%/5.3% | 493M/430M | X | X | X | X | <span style=color:red> 9%</span> | 0% | |
| <del>[1j1d](1j1d.txt)</del> | <del>v0.5 Xunlong Orange Pi PC Plus </del> | <del>0.4%/0%</del> | <del>1.0G/868M</del> | <del>X</del> | <del>X</del> | <del>X</del> | <del>X</del> | <del> 3%</del> | <del> 0%</del> | |
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
| [1ngq](1ngq.txt) | v0.6.1 Pentium N4200 | 0%/0% | 3.7G/3.3G | X | X | X | X | 1% | 0% | |
| [1niO](1niO.txt) | v0.6.1 Raspberry Pi Zero W Rev 1.1 | 0%/0% | 433M/345M | X | X | X | | 3% | 1% | |
| [1oho](1oho.txt) | v0.6.1 FriendlyElec NanoPi M4 | 0%/0.3% | 919M/770M | X | X | X | | 1% | 0% | [check log](1oho.txt) |
| [1oib](1oib.txt) | v0.6.1 FriendlyElec NanoPi NEO4 | 0%/0.3% | 919M/769M | X | X | X | | 1% | 0% | |
| [1oim](1oim.txt) | v0.6.1 FriendlyElec NanoPi M4 | 0%/0.4% | 919M/769M | X | X | X | | 1% | 0% | |
| [1p3T](1p3T.txt) | v0.6.1 FriendlyElec NanoPi NEO4 | 0%/0.5% | 992M/825M | X | X | X | | 1% | 0% | |
| <del>[1pJi](1pJi.txt)</del> | <del>v0.6.1 ROCK PI 4B </del> | <del>0.2%/0.4%</del> | <del>1.9G/1.8G</del> | <del>X</del> | <del>X</del> | <del>X</del> | <del>X</del> | <del> 2%</del> | <del> 0%</del> | <del>[check log](1pJi.txt)</del> |
| [1qal](1qal.txt) | v0.6.2 Celeron J4105 | 0%/0.3% | 7.6G/7.2G | X | X | X | X | 1% | 0% | |
| [1qb0](1qb0.txt) | v0.6.2 Celeron J4105 | 0%/0% | 31G/30G | X | X | X | X | 1% | 0% | |
| [1rYm](1rYm.txt) | v0.6.2 Khadas Captain | 0.2%/0.2% | 3.7G/3.6G | X | X | X | X | 1% | 0% | [check log](1rYm.txt) |
| [1rrO](1rrO.txt) | v0.6.2 ROCK PI 4B | 0.4%/0.3% | 1.9G/1.7G | X | X | X | X | 1% | 0% | [check log](1rrO.txt) |
| [1tJg](1tJg.txt) | v0.6.2 Olimex A64 Teres-I | 0.6%/0.6% | 1.9G/1.6G | X | X | X | X | 2% | 0% | |
| <del>[1u3W](1u3W.txt)</del> | <del>v0.6.2 Cubietech Cubietruck </del> | <del>0%/0%</del> | <del>2.0G/1.7G</del> | <del>X</del> | <del>X</del> | <del>X</del> | <del>X</del> | <del><span style=color:red> 9%</span></del> | <del> 0%</del> | |
| [1uTS](1uTS.txt) | v0.6.2 Celeron N4100 | 0%/2.1% | 3.7G/2.1G | X | X | X | X | 2% | 2% | |
| [1uar](1uar.txt) | v0.6.2 Khadas Captain | 0.3%/0.6% | 3.7G/3.6G | X | X | X | X | 1% | 0% | [check log](1uar.txt) |
| [1ub9](1ub9.txt) | v0.6.2 Pine64 RockPro64 | 0%/0.5% | 3.8G/3.7G | X | X | X | X | 1% | 0% | |
| [21fX](21fX.txt) | v0.6.9 Radxa ROCK Pi 4 | 0%/0.6% | 3.8G/3.5G | X | X | X | X | 2% | 0% | |
| [21rE](21rE.txt) | v0.6.9 Pentium J5005 | 0%/0% | 7.6G/6.1G | X | X | X | X | 3% | 0% | |
| [26Ph](26Ph.txt) | v0.6.9 Pine H64 | 0%/0.8% | 1.9Gi/1.7Gi | X | X | X | X | 1% | 0% | |
| [26Wy](26Wy.txt) | v0.6.9 Khadas VIM3L | 0%/0% | 1.8G/1.6G | X | X | X | X | 2% | 0% | |
| [27FC](27FC.txt) | v0.6.9 SolidRun i.MX8MQ HummingBoard Pu | 1.3%/0.3% | 2.9Gi/2.7Gi | X | X | X | X | 0% | 0% | |
| [2Cyi](2Cyi.txt) | v0.7.4 Raspberry Pi 400 Rev 1.0 | 0%/0.9% | 3.7Gi/3.4Gi | X | X | X | X | 3% | 0% | |
| <del>[2FrG](2FrG.txt)</del> | <del>v0.7.4 </del> | <del>0%/0%</del> | <del>123Gi/121Gi</del> | <del>X</del> | <del>X</del> | <del>X</del> | <del>X</del> | <del> 0%</del> | <del> 0%</del> | |
| [2Gjg](2Gjg.txt) | v0.7.5 Apple M1 power core | 0.3%/13.2% | 1.9Gi/1.5Gi | X | X | X | X | 0% | 2% | |
| [2Gtf](2Gtf.txt) | v0.7.5 Apple M1 efficiency | 1.1%/1.4% | 1.9Gi/1.5Gi | X | X | X | X | 4% | 1% | |
| [2ICt](2ICt.txt) | v0.7.5 Hugsun X99 TV BOX | 0%/0.7% | 3.7Gi/3.4Gi | X | X | X | X | 0% | 0% | |
| [2Jdb](2Jdb.txt) | v0.7.2 x5-Z8350 | 0%/0% | 3.8Gi/2.6Gi | X | X | X | X | 4% | <span style=color:red>**21%**</span> | |
| [2iFY](2iFY.txt) | v0.7.1 Amazon a1.xlarge | 0%/0% | 7.5G/7.2G | X | X | X | X | 1% | 0% | |
| [2jVw](2jVw.txt) | v0.7.1 Pentium G4600 | 0%/0% | 31Gi/30Gi | X | X | X | X | 0% | 0% | |
| [2kTH](2kTH.txt) | v0.7.2 Xunlong Orange Pi Prime | 0%/0% | 1.9Gi/1.6Gi | X | X | X | X | 2% | 0% | |
| [2kaS](2kaS.txt) | v0.7.1 Hardkernel ODROID-C4 | 0%/0% | 3.6Gi/3.2Gi | X | X | X | X | 1% | 0% | |
| [2sZH](2sZH.txt) | v0.7.2 Pine64 RockPro64 | 0%/0.6% | 3.8Gi/3.5Gi | X | X | X | X | 2% | 0% | [check log](2sZH.txt) |
| [2tQQ](2tQQ.txt) | v0.7.2 AMD Ryzen Embedded R1606G with R | 0.5%/0.2% | 3.3Gi/1.9Gi | X | X | X | X | 1% | 0% | |
| [2yIx](2yIx.txt) | v0.7.2 Pine64 RockPro64 v2.1 | 0%/0.4% | 3.7Gi/3.3Gi | X | X | X | X | 1% | 1% | |
| [3DeL](3DeL.txt) | v0.7.9 Raspberry Pi Zero 2 Rev 1.0 | 0.5%/0.2% | 427Mi/219Mi | X | X | | | 3% | 1% | |
| [3Dfo](3Dfo.txt) | v0.7.9 Raspberry Pi Zero 2 Rev 1.0 | 0.6%/0.3% | 427Mi/277Mi | X | X | | | 2% | 0% | |
| [3Di2](3Di2.txt) | v0.8.1 Nintendo Switch | 0%/0% | 3.9G/3.5G | X | X | X | X | 1% | 0% | |
| [3DtN](3DtN.txt) | v0.8.1 Hardkernel ODROID-N2Plus | 0%/0% | 3.6Gi/2.7Gi | X | X | X | X | 0% | 0% | |
| [3E7U](3E7U.txt) | v0.8.3 Raspberry Pi Model B Rev 2 | 1.2%/1.5% | 430Mi/344Mi | X | X | X | | 3% | 0% | |
| [3E85](3E85.txt) | v0.8.3 Raspberry Pi Zero 2 Rev 1.0 | 2.6%/0.9% | 427Mi/267Mi | X | X | | | 3% | 0% | |
| [3EOw](3EOw.txt) | v0.8.4 Olimex A20-OLinuXino-LIME2-eMMC | 0%/0% | 998Mi/869Mi | X | X | X | X | <span style=color:red> 7%</span> | 0% | |
| [3EgS](3EgS.txt) | v0.8.4 Raspberry Pi 4 Model B Rev 1.1 | 0.5%/0.4% | 857Mi/695Mi | X | X | X | | 2% | 0% | |
| <del>[3EhG](3EhG.txt)</del> | <del>v0.8.4 Raspberry Pi 4 Model B Rev 1.1 </del> | <del>0%/0.6%</del> | <del>909Mi/754Mi</del> | <del>X</del> | <del>X</del> | <del>X</del> | <del>X</del> | <del><span style=color:red> 8%</span></del> | <del><span style=color:red>**54%**</span></del> | |
| [3F9C](3F9C.txt) | v0.8.4 Raspberry Pi 4 Model B Rev 1.1 | 0%/0.6% | 959Mi/815Mi | X | X | X | X | <span style=color:red>**12%**</span> | 0% | |
| <del>[3FlD](3FlD.txt)</del> | <del>v0.8.4 Raspberry Pi 4 Model B Rev 1.1 </del> | <del>0%/0.6%</del> | <del>959Mi/839Mi</del> | <del>X</del> | <del>X</del> | <del>X</del> | <del>X</del> | <del><span style=color:red> 9%</span></del> | <del> 0%</del> | |
| [3Gia](3Gia.txt) | v0.8.5 Raspberry Pi 4 Model B Rev 1.1 | 2.0%/1.0% | 857Mi/696Mi | X | X | X | X | 3% | 0% | |
| [3GmP](3GmP.txt) | v0.8.6 NanoPi Fire3 | 0%/0% | 994Mi/671Mi | X | X | X | X | 4% | 0% | |
| [3GmR](3GmR.txt) | v0.8.6 FriendlyARM NanoPi NEO4 | 0%/0.7% | 977Mi/714Mi | X | X | X | X | 1% | 0% | |
| [3GnC](3GnC.txt) | v0.8.6 Hardkernel Odroid XU4 | 0%/0.9% | 1.9Gi/1.7Gi | X | X | X | X | 4% | 0% | [check log](3GnC.txt) |
| [3GrW](3GrW.txt) | v0.8.6 | 0%/4.0% | 15Gi/14Gi | X | X | X | X | 1% | 0% | |
| [3HUU](3HUU.txt) | v0.8.8 Celeron N4500 | 0.2%/0% | 7,5Gi/6,4Gi | X | X | X | X | 1% | 0% | |
| <del>[3HUd](3HUd.txt)</del> | <del>v0.8.8 Intel Celeron N5100 @ 1.10GHz </del> | <del>0%/0%</del> | <del>7.6Gi/7.1Gi</del> | <del>X</del> | <del>X</del> | <del>X</del> | <del>X</del> | <del> 3%</del> | <del> 0%</del> | |
| [3IlQ](3IlQ.txt) | v0.8.8 Celeron N5100 | 0%/0% | 7.6Gi/7.2Gi | X | X | X | X | 3% | 0% | |
| [3InF](3InF.txt) | v0.8.8 Raspberry Pi 4 Model B Rev 1.1 | 0%/0.5% | 958Mi/747Mi | X | X | X | X | <span style=color:red>**33%**</span> | 0% | |
| [3JCm](3JCm.txt) | v0.8.8 Radxa Zero | 0.3%/0.8% | 3.7Gi/3.4Gi | X | X | X | X | 1% | 0% | |
| [3KVs](3KVs.txt) | v0.9.0 Raspberry Pi 4 Model B Rev 1.4 | 1.9%/0.7% | 3.7Gi/3.4Gi | X | X | X | X | 4% | 0% | |
| [3L37](3L37.txt) | v0.9.0 Raspberry Pi 4 Model B Rev 1.4 | 0.3%/0.6% | 3.7Gi/3.3Gi | X | X | X | X | 4% | 0% | |
| [3Lir](3Lir.txt) | v0.9.1 ASUS Tinker Board | 0.5%/0% | 2.0Gi/1.5Gi | X | X | X | X | 2% | 0% | |
| [3Llk](3Llk.txt) | v0.8.7 Raspberry Pi 4 Model B Rev 1.4 | 1.7%/0.4% | 3.7Gi/2.5Gi | X | X | X | X | <span style=color:red> 8%</span> | 0% | [check log](3Llk.txt) |
| [3LoH](3LoH.txt) | v0.9.1 Hardkernel ODROID-N2Plus | 0%/0% | 3.6Gi/3.1Gi | X | X | X | X | 1% | 0% | |
| [3M9F](3M9F.txt) | v0.9.1 Generic RK322x TV Box board | 1.6%/0.5% | 1.9Gi/1.7Gi | X | X | X | X | <span style=color:red> 5%</span> | 0% | |
| [3MAK](3MAK.txt) | v0.9.1 FriendlyElec NanoPi M4 Ver2.0 | 0.3%/0.3% | 3.8Gi/3.4Gi | X | X | X | X | 2% | 1% | |
| [3MGN](3MGN.txt) | v0.9.1 Raspberry Pi Model B Rev 2 | 1.4%/1.1% | 429Mi/347Mi | X | X | X | | 2% | 0% | [check log](3MGN.txt) |
| [3MGs](3MGs.txt) | v0.9.1 Raspberry Pi 2 Model B Rev 1.1 | 0.8%/0.2% | 922Mi/835Mi | X | X | X | X | 2% | 0% | |
| [3MQJ](3MQJ.txt) | v0.9.1 Xunlong Orange Pi PC 2 | 0%/0% | 985Mi/753Mi | X | X | X | X | <span style=color:red>**13%**</span> | 0% | |
| [3MQV](3MQV.txt) | v0.9.1 Xunlong Orange Pi PC Plus | 0%/0% | 999Mi/779Mi | X | X | X | X | 2% | 0% | |
| <del>[3MX1](3MX1.txt)</del> | <del>v0.9.1 Radxa Zero </del> | <del>0%/0%</del> | <del>1.9Gi/1.6Gi</del> | <del>X</del> | <del>X</del> | <del>X</del> | <del>X</del> | <del> 1%</del> | <del> 0%</del> | |
| <del>[3MhQ](3MhQ.txt)</del> | <del>v0.9.1 Hardkernel ODROID-HC4 </del> | <del>0%/0%</del> | <del>3.7Gi/3.3Gi</del> | <del>X</del> | <del>X</del> | <del>X</del> | <del>X</del> | <del> 1%</del> | <del> 0%</del> | |
| [3MiR](3MiR.txt) | v0.9.1 TRONFY MXQ S805 | 1.1%/0% | 987Mi/794Mi | X | X | X | X | 2% | 0% | |
| [3MuT](3MuT.txt) | v0.9.1 Hardkernel ODROID-N2 | 0%/0.2% | 3.6Gi/3.3Gi | X | X | X | X | 1% | 0% | |
| <del>[3MzQ](3MzQ.txt)</del> | <del>v0.9.1 Khadas VIM </del> | <del>0.5%/0%</del> | <del>1.9Gi/1.5Gi</del> | <del>X</del> | <del>X</del> | <del>X</del> | <del>X</del> | <del> 1%</del> | <del> 0%</del> | |
| [3N1U](3N1U.txt) | v0.9.2 SBC2D70 | 1.1%/0% | 113Mi/32Mi | X | | | | 0% | 0% | |
| [3N2z](3N2z.txt) | v0.9.2 FriendlyArm NanoPi M1 Plus | 0.7%/0% | 999M/836M | X | X | X | X | 2% | 0% | |
| [3N5c](3N5c.txt) | v0.9.2 bigboy | 0%/0% | 31Gi/29Gi | X | X | X | X | 1% | 0% | |
| [3N6Q](3N6Q.txt) | v0.9.2 Hardkernel ODROID-C2 | 0.7%/0.2% | 1.9Gi/1.6Gi | X | X | X | X | 1% | 0% | |
| [3N7H](3N7H.txt) | v0.9.2 FriendlyElec NanoPi K1 Plus | 0%/1.3% | 1.9Gi/1.7Gi | X | X | X | X | 2% | 0% | |
| [3N94](3N94.txt) | v0.9.2 RPi 4 Model B Rev 1.4 / BCM2711 | 0%/0% | 7.7Gi/7.4Gi | X | X | X | X | 4% | <span style=color:red>**12%**</span> | |
| [3Na5](3Na5.txt) | v0.9.2 Hardkernel ODROID-HC4 | 0%/0% | 3.7Gi/3.5Gi | X | X | X | X | 1% | 0% | |
| [3Naw](3Naw.txt) | v0.9.2 Cubietech Cubietruck | 8.3%/8.8% | 2,0Gi/1,8Gi | X | X | X | X | <span style=color:red> 8%</span> | <span style=color:red> 5%</span> | |
| [3Njz](3Njz.txt) | v0.9.2 Raspberry Pi Zero W Rev 1.1 | 0.9%/0.8% | 477Mi/416Mi | X | X | X | X | <span style=color:red> 5%</span> | 0% | |
| <del>[3Ntu](3Ntu.txt)</del> | <del>v0.9.2 Hardkernel ODROID-N2Plus </del> | <del>0%/0%</del> | <del>1.8Gi/1.5Gi</del> | <del>X</del> | <del>X</del> | <del>X</del> | <del>X</del> | <del> 1%</del> | <del> 0%</del> | |
| <del>[3NvH](3NvH.txt)</del> | <del>v0.9.2 Radxa ROCK Pi 4C </del> | <del>0%/0.5%</del> | <del>3.8Gi/3.2Gi</del> | <del>X</del> | <del>X</del> | <del>X</del> | <del>X</del> | <del> 2%</del> | <del> 0%</del> | |
| <del>[3Nzx](3Nzx.txt)</del> | <del>v0.9.2 LeMaker Banana Pi </del> | <del>0%/0.5%</del> | <del>985Mi/813Mi</del> | <del>X</del> | <del>X</del> | <del>X</del> | <del>X</del> | <del><span style=color:red> 9%</span></del> | <del> 1%</del> | |
| [3OBF](3OBF.txt) | v0.9.2 RPi 4 Model B Rev 1.1 / BCM2711 | 0%/0.6% | 909Mi/765Mi | X | X | X | X | 4% | 2% | |
| [3OKN](3OKN.txt) | v0.9.3 NVIDIA Jetson Nano Developer Kit | 0.1%/0% | 3,9G/3,3G | X | X | X | X | <span style=color:red> 7%</span> | 0% | |
| [3Owk](3Owk.txt) | v0.9.2 bigboy | 0%/0% | 127Gi/108Gi | X | X | X | X | 1% | 1% | |
| [3Owv](3Owv.txt) | v0.9.2 bigboy | 0%/0% | 127Gi/108Gi | X | X | X | X | 1% | 0% | |
| [3PLr](3PLr.txt) | v0.9.3 LeMaker Banana Pi | 8.2%/8.6% | 997Mi/862Mi | X | X | X | X | <span style=color:red> 7%</span> | 0% | |
| [3PlT](3PlT.txt) | v0.9.3 Radxa Zero | 0.6%/0.5% | 3.7Gi/3.2Gi | X | X | X | X | 3% | 2% | |
| [3Q2q](3Q2q.txt) | v0.9.3 Radxa ROCK Pi 4B | 0.2%/0.3% | 3.8Gi/3.5Gi | X | X | X | X | 2% | 0% | |
| [3QLN](3QLN.txt) | v0.9.3 Khadas VIM | 0.8%/0% | 1.8Gi/1.5Gi | X | X | X | X | 1% | 0% | |
| [3QOj](3QOj.txt) | v0.9.3 AMedia X96 Max+ | 0%/0.8% | 3.7Gi/3.4Gi | X | X | X | X | 1% | 0% | |
| [3Qf7](3Qf7.txt) | v0.9.3 Celeron N5105 | 0%/0% | 7.5Gi/6.4Gi | X | X | X | X | 2% | 0% | |
| [3Qve](3Qve.txt) | v0.9.3 FriendlyARM NanoPi K2 | 0.9%/0.9% | 1.9Gi/1.6Gi | X | X | X | X | 1% | 1% | |
| [3R1a](3R1a.txt) | v0.9.3 Hardkernel ODROID-N2Plus | 0%/0% | 3,7Gi/3,4Gi | X | X | X | X | 1% | 0% | |
| [3R2Z](3R2Z.txt) | v0.9.3 Khadas VIM3 | 0%/0% | 3.7Gi/3.3Gi | X | X | X | X | 0% | 0% | |
| [3R3N](3R3N.txt) | v0.9.3 Akaso M8S | 0%/0.4% | 986Mi/873Mi | X | X | X | X | 1% | <span style=color:red>**11%**</span> | [check log](3R3N.txt) |
| [3Rsg](3Rsg.txt) | v0.9.3 Firefly RK3568-ROC-PC HDMI | 0%/0% | 3.7Gi/3.4Gi | X | X | X | X | 2% | 0% | |
| [3S5U](3S5U.txt) | v0.9.3 Tronsmart MXIII Plus | 0%/0.4% | 2.0Gi/1.7Gi | X | X | X | X | 2% | 0% | |
| [3Sl9](3Sl9.txt) | v0.9.3 zqykj-K681-F223 | 0%/0.4% | 15Gi/13Gi | X | X | X | X | 3% | 1% | |
| [3rUb](3rUb.txt) | v0.7.7 Pine64 RK3566 Quartz64-A Board | 0%/0% | 3.8Gi/3.5Gi | X | X | X | X | 1% | 0% | |
| [3wZn](3wZn.txt) | v0.7.7 Radxa Zero | 0.3%/0% | 3.7Gi/3.4Gi | X | X | X | X | 1% | 0% | |
