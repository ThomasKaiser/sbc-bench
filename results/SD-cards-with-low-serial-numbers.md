# Fight Flash Fraud 

Counterfeit SD cards are (still) a massive problem most users are not aware of. Fraudsters insert faked cards somewhere into the supply chain that fake a higher capacity and often show worse performance compared to genuine flash products from trustworthy vendors.

The only way to really check for flash fraud is to test the card's full capacity using tools like eg. [f3](https://fight-flash-fraud.readthedocs.io/en/latest/).

But since fraudsters often don't care that much about hiding their fakes we can also use the card's metadata available as so called CID and CSD (you can check both [here](https://gurumeditation.org/1342/sd-memory-card-register-decoder/)).

Based on the _assumption_ SD card serial numbers are sequential numbers starting with 1 (which [sometimes is a problem](https://en.wikipedia.org/wiki/German_tank_problem) and should be avoided) low serial numbers look suspicious as in "SD card fraud".

Using the q&d script attached to the bottom of this page I crawled through a few thousand `armbianmonitor -u` outputs to generate some data for all serial numbers between 0x00000000 and 0x0000ffff found with the SD cards of Armbian users all over the world.

The capacity in the 2nd column is reported by the kernel but solely based on a few bits in the card's CSD 'register'. The _name_ (limited to 5 bytes by specification), _Manufacturer ID_, _OEM ID_, _hw revision_ and _sw revision_ values are from the card's CID. At the right is the device the specific card was in when the info got extracted.

Only some _Manufacturer ID's_ are defined (registered at JEDEC today) and usually they go along with a specific _OEM ID_, for example genuine Toshiba cards all use the combination `0x000002/0x544d` where `0x000002` is the _Manufacturer ID_ and `0x544d` in ASCII represents `TM` which isn't surprising when thinking about 'Toshiba Memory'. With AData it's for example `0x00001d/0x4144` (the `0x4144` for `AD`).

Low serial numbers look OK with `0x000027/0x5048` (Phison, most OEM cards are based on these controllers, e.g. AgfaPhoto, Delkin, Intenso, Integral, Lexar, Patriot, PNY, Polaroid, Sony, Verbatim and many more). The names all match capacity (`SD08G` is 7.28/7.44 GiB, `SD16G` is 14.5/14.6 GiB, `SD32G` = 28.8/28.9/29.1 GiB and so on). With AData it seems similar: 18 on the list with the usual device names `SD` and `USD`.

But there are +150 other cards also with the names `SD08G`, `SD16G`, `SD32G` and `SD64G` that mostly look suspicious. 33 identify as Kingston (`0x000041/0x3432`) but capacity almost never matches the name, e.g. `SD16G` claiming 29.5 GiB. Those are probably all fakes.

Then there are another 106 combining the _OEM ID_ used by Kingston (`0x3432 -> "42"`) with bogus _Manufacturer ID's_ like `0x000000`, `0x000012`, `0x00009f`, `0x0000f1`, `0x0000ff` and `0x0000fe` where name and capacity almost never matches. So it's save to assume that the combination of Kingston's _OEM ID_ with a different _Manufacturer ID_ than `0x000041` is counterfeit indication.

Then there are 9 that identify as Transcend (`0x000074` though with a different _OEM ID_ as usual :`0x4a60`). Only one of them shows an inadequate capacity (`SD16G` reporting 7.44 GiB). This one card shows _hw revision_ `0x2` while all the other are `0x6`.

Then there's 23 times cards with `0x000012/0x3456` which is a known counterfeit combination. And another 16 with `0x000012/0x5678`, the majority of them named `ASTC` which is also often the name of other counterfeit products using a bogus _Manufacturer ID_. Checking for `name=ASTC` might be another reliable counterfeit detector. A bunch of those `ASTC` named cards identifies as bogus `0x0000fe/0x3456` and the same goes for cards with name `00000` so let us add this name to the list.

Then there are 13 that identify as SanDisk (`0x000003/0x5344`) all showing the name `AS` which is untypical for real SanDisk devices (all 5 bytes used and names starting with S and ending with G with capacity in between). Similarly suspicious name is `SMI` which appears 21 times on this list all the time with silly serial `0x00000000` combined with bogus ID combinations (`0x00006f/0x0013`, `0x000025/0x1708` or `0x0000df/0x2109` for example).

All of the above checks are now part of `sbc-bench` and are performed in review mode (`-r`).

The details as follows:

| serial n° | capacity | name | manfid/oemid | date | hwrev/fwrev | device |
| :----- | -------: | :----: | :-------: | :----: | ------: | :----- |
| 0x00000000 | 14.6 GiB | SMI | 0x000000/0x0000 | 11/2020 | 0x0/0x0 | Orange Pi Zero |
| 0x00000000 | 14.7 GiB | N/A | 0x000000/0x2020 | 12/2017 | 0x1/0x0 | Orange Pi Plus 2E |
| 0x00000000 | 14.8 GiB | SD16G | 0x000000/0x3432 | 03/2022 | 0x2/0x0600000000000000 |  |
| 0x00000000 | 14.8 GiB | SMI | 0x000000/0x0000 | 10/2020 | 0x0/0x0d00020000000000 | Radxa ROCK Pi 4B |
| 0x00000000 | 14.9 GiB | 00000 | 0x000045/0x2d42 | 01/2021 | 0x2/0x0 | Allwinner D1 Nezha |
| 0x00000000 | 15.0 GiB | SMI | 0x000000/0x0000 | 06/2020 | 0x0/0x0 | Orange Pi PC Plus |
| 0x00000000 | 15.0 GiB | SMI | 0x00006f/0x0013 | 08/2017 | 0x0/0x0 | RPi 3B Rev 1.2 |
| 0x00000000 | 29.1 GiB | 00000 | 0x000000/0x3030 | 09/2020 | 0x0/0x0 | OPI 3 LTS |
| 0x00000000 | 29.1 GiB | SMI | 0x00006f/0x0013 | 06/2019 | 0x0/0x0600000000000000 | OrangePi 3 LTS |
| 0x00000000 | 29.3 GiB | SMI | 0x00006f/0x0013 | 10/2018 | 0x0/0x0 | Orange Pi Lite |
| 0x00000000 | 29.4 GiB | SMI | 0x00006f/0x0013 | 05/2019 | 0x0/0x0 | Orange Pi Zero |
| 0x00000000 | 29.5 GiB | SD | 0x000012/0x3456 | 10/2018 | 0x0/0x4 | Orange Pi PC2 |
| 0x00000000 | 29.5 GiB | SMI | 0x00006f/0x0013 | 07/2018 | 0x0/0x0600000000000000 | P212 Board |
| 0x00000000 | 29.5 GiB | SMI | 0x00006f/0x0013 | 10/2019 | 0x0/0x0 | Odroid XU4 |
| 0x00000000 | 29.5 GiB | SMI | 0x00006f/0x0013 | 10/2019 | 0x0/0x0 | Orange Pi One |
| 0x00000000 | 30.0 GiB | SMI | 0x000025/0x1708 | 03/2021 | 0x0/0x0 | BPI-M2-Zero |
| 0x00000000 | 30.0 GiB | SMI | 0x00006f/0x0013 | 08/2018 | 0x0/0x1403000000000000 | OrangePi 3 |
| 0x00000000 | 3.73 GiB | SD4GB | 0x000036/0x414f | 11/2013 | 0x1/0x0 | Orange Pi Zero |
| 0x00000000 | 3.75 GiB | SMI | 0x000000/0x0000 | 06/2020 | 0x0/0x0 | RPi 4B Rev 1.2 |
| 0x00000000 | 58.6 GiB | SMI | 0x000000/0x0000 | 01/2021 | 0x0/0x0 | NanoPi R1 |
| 0x00000000 | 7.46 GiB | SMI | 0x00006f/0x0013 | 12/2017 | 0x0/0x0 | Orange Pi Prime |
| 0x00000000 | 7.50 GiB | SD | 0x000012/0x3456 | 09/2017 | 0x0/0x0 | Firefly RK3399 |
| 0x00000000 | 7.50 GiB | SMI | 0x000000/0x0000 | 01/2020 | 0x0/0x0 | Orange Pi R1 |
| 0x00000000 | 7.50 GiB | SMI | 0x000000/0x0000 | 04/2021 | 0x0/0x0 | Orange Pi PC Plus |
| 0x00000000 | 7.50 GiB | SMI | 0x00006f/0x0013 | 04/2018 | 0x0/0x0 | Asus Tinker Board S |
| 0x00000000 | 7.50 GiB | SMI | 0x00006f/0x0013 | 04/2022 | 0x0/0x0 | Orange Pi PC |
| 0x00000000 | 7.50 GiB | SMI | 0x00006f/0x0013 | 05/2000 | 0x0/0x0 | Orange Pi PC |
| 0x00000000 | 7.50 GiB | SMI | 0x00006f/0x0013 | 08/2018 | 0x0/0x0600000000000000 | OrangePi 3 LTS |
| 0x00000000 | 7.50 GiB | SMI | 0x00006f/0x0013 | 09/2015 | 0x0/0x0 | Cubieboard2 |
| 0x00000000 | 7.50 GiB | SMI | 0x00006f/0x0013 | 11/2017 | 0x0/0x0 | Orange Pi PC |
| 0x00000000 | 7.50 GiB | SMI | 0x00006f/0x0013 | 11/2018 | 0x0/0x0 | Orange Pi One |
| 0x00000000 | 7.50 GiB | SMI | 0x00006f/0x0013 | 12/2017 | 0x0/0x0 | Orange Pi PC Plus |
| 0x00000000 | 7.50 GiB | SMI | 0x0000df/0x2109 | 11/2021 | 0x0/0x0 | Orange Pi PC |
| 0x00000001 | 14.6 GiB | SD16G | 0x0000fe/0x3432 | 03/2021 | 0x2/0x0 | BPI-M2-Zero |
| 0x00000001 | 7.28 GiB | SD08G | 0x000027/0x5048 | 05/2021 | 0x6/0x0300000000000000 | Orange Pi PC 2 |
| 0x00000001 | 7.28 GiB | SD08G | 0x000027/0x5048 | 05/2021 | 0x6/0x0 | Orange Pi PC 2 |
| 0x00000005 | 28.9 GiB | SD32G | 0x000027/0x5048 | 04/2021 | 0x6/0x0 | Orange Pi Zero 2 |
| 0x00000006 | 14.7 GiB | 00000 | 0x00009f/0x5449 | 09/2018 | 0x0/0x0 | Radxa ROCK Pi 4B |
| 0x00000006 | 29.1 GiB | ASTC | 0x0000fe/0x3456 | 04/2020 | 0x1/0x1 | Radxa ROCK Pi 4B |
| 0x00000009 | 29.5 GiB | SD | 0x0000da/0x3429 | 07/2020 | 0x2/0x0 | Orange Pi PC 2 |
| 0x0000000e | 29.1 GiB | SD16G | 0x000041/0x3432 | 10/2017 | 0x2/0x0 | Orange Pi Zero |
| 0x0000000e |  | ASTC | 0x0000fe/0x3456 | 05/2020 | 0x1/0x2 | Orange Pi Zero |
| 0x0000000f | 7.45 GiB | SD | 0x000012/0x3456 | 07/2017 | 0x0/0x0 | Orange Pi Zero |
| 0x0000000f | 7.50 GiB | SD16G | 0x0000ff/0x3432 | 10/2019 | 0x2/0x0600000000000000 | Orange Pi 3 LTS |
| 0x00000010 | 29.1 GiB | SD | 0x000074/0x4a60 | 12/2017 | 0x0/0x0 | Odroid XU4 |
| 0x00000010 | 7.28 GiB | ASTC | 0x0000fe/0x3456 | 10/2021 | 0x1/0x0600000000000000 | OrangePi 4 LTS |
| 0x00000011 | 29.1 GiB | SD | 0x000012/0x3456 | 06/2020 | 0x2/0x0 | Orange Pi One |
| 0x00000011 | 29.8 GiB | 00000 | 0x00009f/0x5449 | 08/2018 | 0x0/0x0806020000000000 | Radxa ROCK Pi 4C |
| 0x00000011 | 58.3 GiB | MS | 0x000012/0x5678 | 04/2018 | 0x2/0x0 | Orange Pi Zero 2 |
| 0x00000012 | 14.5 GiB | SD16G | 0x000027/0x5048 | 04/2021 | 0x6/0x0 | Radxa ROCK Pi 4B |
| 0x00000012 | 14.8 GiB | SPCC | 0x000031/0x5350 | 01/2017 | 0x3/0x0 | ODROID-C4 |
| 0x00000012 | 7.28 GiB | ASTC | 0x000012/0x3456 | 09/2022 | 0x0/0x0600000000000000 | OrangePi 3 LTS |
| 0x00000013 | 14.6 GiB | ASTC | 0x000041/0x3432 | 08/2018 | 0x2/0x0 | Banana Pro |
| 0x00000013 | 29.1 GiB | SD32G | 0x000027/0x5048 | 07/2021 | 0x6/0x0 | Orange Pi Zero2 |
| 0x00000016 | 29.1 GiB | SD16G | 0x0000fe/0x3432 | 08/2022 | 0x2/0x0600000000000000 | Orange Pi Zero2 |
| 0x00000016 | 29.1 GiB | SD16G | 0x0000fe/0x3432 | 08/2022 | 0x2/0x0 | Orange Pi Zero2 |
| 0x00000018 | 3.75 GiB | SD16G | 0x000041/0x3432 | 11/2017 | 0x2/0x0 | Cubietruck |
| 0x00000019 | 29.8 GiB | SD16G | 0x000041/0x3432 | 06/2018 | 0x2/0x0 | Orange Pi PC Plus |
| 0x0000001b | 29.2 GiB | SD16G | 0x000041/0x3432 | 12/2018 | 0x2/0x0200000000000000 | P200 Board |
| 0x0000001f | 29.1 GiB | ASTC | 0x000012/0x3456 | 10/2022 | 0x0/0x0 | OPI 3 LTS |
| 0x00000020 | 30.0 GiB | SD16G | 0x000041/0x3432 | 05/2018 | 0x2/0x0 | Banana Pi |
| 0x00000022 | 58.2 GiB | SD64G | 0x000027/0x5048 | 01/2021 | 0x1/0x0600000000000000 | OPI 3 LTS |
| 0x00000023 | 57.8 GiB | SD | 0x00001d/0x4144 | 10/2020 | 0x1/0x0 | Orange Pi R1 Plus LTS |
| 0x00000026 | 29.1 GiB | SD16G | 0x0000fe/0x3432 | 10/2021 | 0x2/0x0100000000000000 | Bananapi-R2 Pro |
| 0x00000028 | 7.44 GiB | AS | 0x000003/0x5344 | 04/2020 | 0x3/0x0600000000000000 | Khadas VIM |
| 0x00000028 | 7.45 GiB | ASTC | 0x000041/0x3432 | 01/2021 | 0x2/0x0 | OPI 4 LTS |
| 0x00000029 | 14.9 GiB | SD16G | 0x0000ac/0x5759 | 09/2019 | 0x2/0x0 | uefi-x86 |
| 0x00000029 | 29.2 GiB | SD16G | 0x000041/0x3432 | 06/2019 | 0x2/0x0 | Orange Pi Zero2 |
| 0x0000002a | 14.9 GiB | 00000 | 0x00009f/0x5449 | 10/2017 | 0x0/0x0 | BPI-P2-Zero / M2-Zero |
| 0x00000030 | 28.8 GiB | SD32G | 0x000027/0x5048 | 04/2021 | 0x6/0x0 | Orange Pi+ 2E |
| 0x00000036 | 7.44 GiB | AS | 0x000003/0x5344 | 04/2020 | 0x3/0x0600000000000000 | Khadas VIM |
| 0x00000039 | 29.1 GiB | SD32G | 0x000027/0x5048 | 05/2022 | 0x6/0x0600000000000000 | Orange Pi 3 LTS |
| 0x0000003b | 29.1 GiB | ASTC | 0x0000fe/0x3456 | 06/2020 | 0x1/0x0600000000000000 | Orange Pi 3 LTS |
| 0x0000003c | 14.9 GiB | 00000 | 0x000000/0x0000 | 01/2018 | 0x0/0x0 | Orange Pi PC Plus |
| 0x0000003e | 14.8 GiB | ASTC | 0x0000fe/0x3456 | 11/2020 | 0x1/0x0600000000000000 | OPI 3 LTS |
| 0x00000045 | 14.9 GiB | AS | 0x000003/0x5344 | 02/2021 | 0x3/0x0600000000000000 | P212 Board |
| 0x0000004a | 14.8 GiB | ASTC | 0x0000fe/0x3456 | 11/2020 | 0x1/0x0600000000000000 | OPI 3 LTS |
| 0x0000004e | 28.9 GiB | SD32G | 0x000027/0x5048 | 08/2021 | 0x6/0x4 | OrangePi Zero2 |
| 0x0000004f | 28.9 GiB | SD32G | 0x000027/0x5048 | 04/2021 | 0x6/0x0 | Orange Pi PC |
| 0x00000051 | 29.2 GiB | SD16G | 0x000041/0x3432 | 02/2019 | 0x2/0x0200000000000000 | T95 Max Plus |
| 0x00000059 | 29.8 GiB | SD16G | 0x000000/0x3432 | 12/2019 | 0x2/0x0 | Orange Pi R1 Plus |
| 0x0000005a | 29.6 GiB | SD16G | 0x000041/0x3432 | 12/2018 | 0x2/0x0 | Orange Pi One |
| 0x00000060 | 14.6 GiB | 00000 | 0x0000fe/0x3456 | 11/2021 | 0x1/0x0600000000000000 | OPI 3 LTS |
| 0x00000062 | 29.1 GiB | 00000 | 0x000000/0x0000 | 10/2017 | 0x0/0x0 | Orange Pi Zero |
| 0x00000063 | 29.1 GiB | SD16G | 0x0000fe/0x3432 | 02/2022 | 0x2/0x0000000000000000 | P212 Board |
| 0x00000068 | 7.44 GiB | SD | 0x0000df/0x2012 | 01/2021 | 0x2/0x0 | Odroid XU4 |
| 0x0000006a | 7.37 GiB | 00000 | 0x00009f/0x5449 | 03/2018 | 0x0/0x0 | Orange Pi Zero |
| 0x0000006f | 29.5 GiB | SD16G | 0x000000/0x3432 | 04/2019 | 0x2/0x0 | Orange Pi R1 Plus |
| 0x00000075 | 29.1 GiB | SD16G | 0x000000/0x3432 | 01/2021 | 0x2/0x0 | Orange Pi One |
| 0x00000079 | 29.1 GiB | SD | 0x0000df/0x2011 | 01/2021 | 0x2/0x0 | OrangePi Zero2 |
| 0x00000085 | 29.4 GiB | ASTC | 0x0000ff/0x0000 | 07/2021 | 0x1/0x0202020000000000 | AMedia X96 Max+ |
| 0x0000008c | 58.2 GiB | SD | 0x0000df/0x2009 | 06/2021 | 0x2/0x0 | NanoPi R4S |
| 0x00000092 | 7.45 GiB | AS | 0x000003/0x5344 | 11/2020 | 0x3/0x3733313033353137 | Khadas VIM |
| 0x00000096 | 14.9 GiB | SD16G | 0x000041/0x3432 | 01/2018 | 0x2/0x0 | Orange Pi Plus 2E |
| 0x00000097 | 58.9 GiB | ASTC | 0x0000ff/0x0000 | 04/2022 | 0x1/0x2 | Orange Pi PC |
| 0x0000009a | 14.8 GiB | SPCC | 0x000031/0x5350 | 11/2016 | 0x3/0x4 | Orange Pi Zero |
| 0x0000009c | 28.9 GiB | SD | 0x00001d/0x4144 | 02/2022 | 0x1/0x0 | Orange Pi Zero |
| 0x000000a7 | 28.9 GiB | SD32G | 0x000027/0x5048 | 06/2021 | 0x6/0x0300000000000000 | NanoPi M4 Ver2.0 |
| 0x000000aa | 14.8 GiB | ASTC | 0x0000fe/0x3456 | 01/2020 | 0x1/0x0 | Orange Pi Zero2 |
| 0x000000b4 | 29.1 GiB | ASTC | 0x000000/0x3432 | 05/2021 | 0x2/0x0 | Orange Pi Zero2 |
| 0x000000b5 | 58.2 GiB | ASTC | 0x000012/0x3456 | 07/2022 | 0x0/0x0 | Tanix TX6 |
| 0x000000b7 | 29.1 GiB | ASTC | 0x000012/0x3456 | 06/2021 | 0x2/0xf | Orange Pi Zero2 |
| 0x000000bd | 29.1 GiB | ASTC | 0x0000fe/0x3456 | 11/2019 | 0x1/0x0600000000000000 | Orange Pi 3 |
| 0x000000bd | 29.1 GiB | SD32G | 0x000027/0x5048 | 05/2022 | 0x6/0x0 | Orange Pi PC 2 |
| 0x000000c2 | 28.9 GiB | SD32G | 0x000027/0x5048 | 10/2021 | 0x6/0x0 | OrangePi Zero2 |
| 0x000000d0 | 7.44 GiB | SD16G | 0x000041/0x3432 | 05/2021 | 0x2/0x0 | Oranth Tanix TX3 Mini |
| 0x000000d8 | 29.1 GiB | SD16G | 0x0000df/0x2108 | 08/2021 | 0x2/0x0 | RPi 3B Rev 1.2 |
| 0x000000e2 | 28.9 GiB | SD32G | 0x000027/0x5048 | 04/2021 | 0x6/0x0600000000000000 | ODROID-N2Plus |
| 0x000000ee | 7.37 GiB | ASTC | 0x000041/0x3432 | 07/2019 | 0x2/0x0600000000000000 | OPI 3 LTS |
| 0x000000f0 | 233 GiB | SD256 | 0x000027/0x5048 | 10/2021 | 0x6/0x0500000000000000 | Tanix TX6 |
| 0x000000f3 | 29.1 GiB | SD32G | 0x000027/0x5048 | 04/2021 | 0x6/0x0 | Makerbase mks-pi |
| 0x000000f7 | 14.6 GiB | 00000 | 0x0000fe/0x3456 | 09/2021 | 0x1/0x0100000000000000 | Makerbase mks-pi |
| 0x000000f7 | 14.6 GiB | 00000 | 0x0000fe/0x3456 | 09/2021 | 0x1/0x0500000000000000 | Makerbase mks-pi |
| 0x000000f7 | 14.6 GiB | 00000 | 0x0000fe/0x3456 | 09/2021 | 0x1/0x0600000000000000 | Makerbase mks-pi |
| 0x000000f7 | 14.6 GiB | 00000 | 0x0000fe/0x3456 | 09/2021 | 0x1/0x0 | Makerbase mks-pi |
| 0x000000f7 | 14.6 GiB | 00000 | 0x0000fe/0x3456 | 09/2021 | 0x1/0x3230333130332020 | Makerbase mks-pi |
| 0x000000f7 | 14.6 GiB | 00000 | 0x0000fe/0x3456 | 09/2021 | 0x1/0x4 | Makerbase mks-pi |
| 0x000000f8 | 28.9 GiB | SD32G | 0x000027/0x5048 | 12/2021 | 0x6/0x0 | Orange Pi Zero2 |
| 0x0000010a | 14.6 GiB | SD | 0x0000df/0x2103 | 04/2021 | 0x2/0x0 | Sinovoip BPI-M2 |
| 0x00000110 | 14.8 GiB | SD | 0x0000df/0x3428 | 11/2020 | 0x2/0xa100000000000000 | Makerbase mks-pi |
| 0x00000110 | 14.9 GiB | TO | 0x000045/0x2d42 | 05/2018 | 0x0/0x0 | Orange Pi Zero |
| 0x00000113 | 29.1 GiB | SD32G | 0x000027/0x5048 | 05/2022 | 0x6/0x0 | Orange Pi PC Plus |
| 0x00000124 | 14.4 GiB | SD16G | 0x000000/0x3432 | 03/2021 | 0x2/0x0 | Orange Pi Zero |
| 0x00000128 | 29.1 GiB | ASTC | 0x00009f/0x5449 | 12/2021 | 0x0/0x0 | Orange Pi PC 2 |
| 0x0000012f | 14.8 GiB | SD | 0x0000df/0x3428 | 07/2020 | 0x2/0x0 | Orange Pi Zero2 |
| 0x0000012f | 14.8 GiB | SD | 0x0000df/0x3428 | 07/2020 | 0x2/0x3733313033353137 | OrangePi Zero2 |
| 0x00000130 | 29.1 GiB | ASTC | 0x0000fe/0x3456 | 09/2019 | 0x1/0x2 | Orange Pi One |
| 0x00000132 | 14.4 GiB | SD16G | 0x000000/0x3432 | 03/2021 | 0x2/0x0 | Orange Pi Zero |
| 0x0000013d | 14.4 GiB | SD16G | 0x000000/0x3432 | 03/2021 | 0x2/0x0 | Orange Pi Zero |
| 0x0000013d | 29.5 GiB | SD16G | 0x000041/0x3432 | 12/2018 | 0x2/0x0 | Orange Pi Plus / Plus 2 |
| 0x0000013e | 29.1 GiB | SD32G | 0x000027/0x5048 | 05/2021 | 0x6/0x0 | OrangePi 4 LTS |
| 0x00000141 | 14.4 GiB | SD16G | 0x000000/0x3432 | 03/2021 | 0x2/0x0 | Orange Pi Zero |
| 0x00000143 | 14.4 GiB | SD16G | 0x000000/0x3432 | 03/2021 | 0x2/0x0 | Orange Pi Zero |
| 0x00000145 | 14.4 GiB | SD16G | 0x000000/0x3432 | 03/2021 | 0x2/0x0 | Orange Pi Zero |
| 0x00000145 | 57.8 GiB | SD | 0x00001d/0x4144 | 12/2020 | 0x1/0x0 | BPI-M2-Zero |
| 0x00000148 | 29.8 GiB | SD16G | 0x000000/0x3432 | 09/2019 | 0x2/0x0 | P212 Board |
| 0x0000014a | 29.1 GiB | 00000 | 0x00009f/0x5449 | 01/2020 | 0x0/0x0100000000000000 | Oranth Tanix TX3 Mini |
| 0x0000014d | 14.4 GiB | SD16G | 0x000000/0x3432 | 03/2021 | 0x2/0x0 | Orange Pi Zero |
| 0x00000150 | 29.4 GiB | ASTC | 0x0000ff/0x0000 | 06/2021 | 0x1/0x0600000000000000 | Orange Pi 3 LTS |
| 0x00000152 | 14.4 GiB | SD16G | 0x000000/0x3432 | 03/2021 | 0x2/0x0 | Orange Pi Zero |
| 0x00000157 | 29.8 GiB | SD | 0x000012/0x3456 | 07/2021 | 0x0/0x0 | Orange Pi Zero2 |
| 0x0000015c | 7.44 GiB | SD08G | 0x000027/0x5048 | 06/2021 | 0x6/0x0 | Banana Pro |
| 0x0000015e | 14.6 GiB | SD16G | 0x000027/0x5048 | 01/2022 | 0x6/0x0 | P281 Board |
| 0x0000015f | 28.8 GiB | SD32G | 0x000027/0x5048 | 06/2021 | 0x6/0x0 | Orange Pi PC Plus |
| 0x0000015f | 29.1 GiB | SD | 0x0000df/0x2104 | 04/2021 | 0x2/0x0 | Banana Pi M64 |
| 0x00000162 | 28.9 GiB | SD | 0x00001d/0x4144 | 02/2022 | 0x1/0x0 | Orange Pi Zero |
| 0x00000163 | 120 GiB | SD16G | 0x000041/0x3432 | 11/2018 | 0x2/0x0 | S805 |
| 0x00000169 | 7.52 GiB | SD08G | 0x0000ff/0x3432 | 10/2019 | 0x2/0x0100000000000000 | NEXBOX A95X |
| 0x0000016a | 58.2 GiB | ASTC | 0x000012/0x5678 | 11/2018 | 0x3/0x4 | Orange Pi Zero |
| 0x00000171 | 7.35 GiB | SD | 0x000012/0x3456 | 06/2017 | 0x0/0x0 | Orange Pi PC |
| 0x0000017b | 28.9 GiB | SD32G | 0x000027/0x5048 | 04/2021 | 0x6/0x0 | BPI-M2-Ultra |
| 0x0000017e | 14.9 GiB | SD16G | 0x000041/0x3432 | 03/2018 | 0x2/0x0 | Orange Pi Lite |
| 0x00000185 | 58.2 GiB | 00000 | 0x00009f/0x5449 | 06/2022 | 0x0/0x0600000000000000 | Orange Pi 3 LTS |
| 0x0000018a | 14.8 GiB | ASTC | 0x000003/0x5344 | 01/2021 | 0x3/0x4 | Orange Pi PC |
| 0x00000198 | 7.44 GiB | ASTC | 0x000012/0x5678 | 04/2008 | 0x3/0x0 | Orange Pi Zero Plus 2 |
| 0x0000019a | 7.44 GiB | TO | 0x000045/0x2d42 | 10/2016 | 0x0/0x0 | Orange Pi PC Plus |
| 0x0000019e | 29.1 GiB | ASTC | 0x000000/0x3432 | 05/2021 | 0x2/0x0 | OrangePi Zero2 |
| 0x0000019e | 7.44 GiB | MS | 0x000012/0x5678 | 02/2019 | 0x2/0x0 | Orange Pi Zero |
| 0x000001a0 | 7.28 GiB | SD16G | 0x000041/0x3432 | 09/2017 | 0x2/0x0 | OneCloud |
| 0x000001a3 | 58.2 GiB | ASTC | 0x000012/0x3456 | 10/2021 | 0x0/0x0600000000000000 | NanoPi A64 |
| 0x000001a5 | 14.9 GiB | ASTC | 0x000012/0x5678 | 05/2017 | 0x3/0x0 | Pine64 |
| 0x000001b4 | 14.9 GiB | 00000 | 0x00009f/0x5449 | 02/2020 | 0x0/0x0 | Orange Pi One |
| 0x000001ba | 29.2 GiB | SD16G | 0x000000/0x3432 | 01/2020 | 0x2/0x0 | Olimex A20-OLinuXino-LIME2-eMMC |
| 0x000001bb | 7.52 GiB | SD08G | 0x0000ff/0x0000 | 07/2020 | 0x2/0x0 | OrangePi Zero2 |
| 0x000001c4 | 31.3 GiB | ASTC | 0x000041/0x3432 | 08/2018 | 0x2/0x0 | Orange Pi PC2 |
| 0x000001cd | 7.36 GiB | ASTC | 0x000012/0x5678 | 01/2019 | 0x3/0x4 | Banana Pi |
| 0x000001d4 | 29.1 GiB | SD32G | 0x000027/0x5048 | 12/2020 | 0x1/0x0 | RPi 4B Rev 1.1 |
| 0x000001dd | 29.1 GiB | 00000 | 0x00009f/0x5449 | 11/2021 | 0x2/0x0 | RPi 4B Rev 1.4 |
| 0x000001e1 | 58.2 GiB | SD64G | 0x000027/0x5048 | 02/2021 | 0x1/0x0200000000000000 | Tanix TX6 |
| 0x000001e3 | 14.8 GiB | ASTC | 0x0000fe/0x3456 | 11/2019 | 0x1/0x2 | Orange Pi Zero |
| 0x000001e3 | 58.2 GiB | SD16G | 0x0000fe/0x3432 | 06/2022 | 0x2/0x4353322e32302020 | X96 MAX PLUS Q2, X96 Air Q1000 |
| 0x000001ee | 29.5 GiB | SD16G | 0x000041/0x3432 | 05/2015 | 0x2/0x0600000000000000 | Orange Pi 3 LTS |
| 0x000001f0 | 29.2 GiB | SD16G | 0x0000f1/0x3432 | 12/2011 | 0x2/0x0600000000000000 | Orange Pi 3 |
| 0x000001f1 | 29.1 GiB | ASTC | 0x000074/0x4a60 | 10/2021 | 0x2/0x0 | Orange Pi PC |
| 0x000001f1 | 58.3 GiB | SD16G | 0x000000/0x3432 | 10/2019 | 0x2/0x0 | Orange Pi Zero |
| 0x000001f3 | 7.36 GiB | ASTC | 0x0000fe/0x3456 | 12/2019 | 0x1/0x2 | Orange Pi Zero |
| 0x00000200 | 28.9 GiB | SD32G | 0x000027/0x5048 | 05/2021 | 0x6/0x0 | Orange Pi PC |
| 0x00000204 | 15.0 GiB | ASTC | 0x000012/0x5678 | 07/2017 | 0x3/0xa100000000000000 | Radxa ROCK Pi 4B |
| 0x00000206 | 14.4 GiB | SD16G | 0x000027/0x5048 | 04/2021 | 0x6/0x0 | Orange Pi Zero2 |
| 0x0000020c | 59.5 GiB | 00000 | 0x00009f/0x5449 | 02/2020 | 0x0/0x0600000000000000 | Orange Pi Zero Plus |
| 0x00000213 | 29.5 GiB | SD | 0x0000df/0x3429 | 08/2020 | 0x2/0x4 | Pine64 Rock64 |
| 0x00000224 | 28.9 GiB | SD32G | 0x000027/0x5048 | 05/2021 | 0x6/0x0 | Orange Pi Zero 2 |
| 0x00000226 | 58.2 GiB | SD16G | 0x0000fe/0x3432 | 08/2012 | 0x2/0x4 | Orange Pi 3 |
| 0x00000232 | 14.6 GiB | SD16G | 0x000027/0x5048 | 01/2022 | 0x6/0x0 | Orange Pi PC |
| 0x00000232 | 28.9 GiB | SD32G | 0x000027/0x5048 | 03/2022 | 0x6/0x0 | Orange Pi Zero 2 |
| 0x0000023a | 14.9 GiB | SDMMC | 0x000011/0x534b | 01/2015 | 0x1/0x0 | Cubietruck |
| 0x00000257 | 29.8 GiB | 00000 | 0x00009f/0x5449 | 11/2019 | 0x0/0x0600000000000000 | OPI 3 LTS |
| 0x00000260 | 29.2 GiB | SD16G | 0x000041/0x3432 | 01/2019 | 0x2/0x0600000000000000 | Orange Pi 3 |
| 0x00000268 | 14.4 GiB | SD16G | 0x000000/0x3432 | 03/2021 | 0x2/0x0 | Orange Pi Zero |
| 0x0000026b | 7.44 GiB | ASTC | 0x000012/0x5678 | 12/2016 | 0x3/0xf400000000000000 | SEI Robotics SEI610 |
| 0x0000026e | 28.9 GiB | SD32G | 0x000027/0x5048 | 07/2021 | 0x6/0x0200000000000000 | AML-S905X-CC |
| 0x0000029c | 28.9 GiB | SD32G | 0x000027/0x5048 | 10/2021 | 0x6/0x0600000000000000 | OrangePi 4 LTS |
| 0x0000029c | 29.5 GiB | ASTC | 0x000012/0x5678 | 02/2019 | 0x3/0x0 | RPi 3B Plus Rev 1.3 |
| 0x000002a6 | 29.8 GiB | SD16G | 0x0000fe/0x3432 | 07/2021 | 0x2/0x0600000000000000 | OrangePi Zero2 |
| 0x000002a7 | 58.2 GiB | ASTC | 0x0000fe/0x3456 | 11/2020 | 0x1/0x2 | OPI 3 LTS |
| 0x000002ba | 3.75 GiB | SD16G | 0x0000ff/0x0000 | 06/2020 | 0x2/0x0 | Orange Pi Zero 2 |
| 0x000002c9 | 28.9 GiB | SD32G | 0x000027/0x5048 | 03/2022 | 0x6/0x0 | OrangePi 4 LTS |
| 0x000002cf | 7.44 GiB | SD08G | 0x000027/0x5048 | 03/2021 | 0x1/0x0600000000000000 | Orange Pi 3 LTS |
| 0x000002d8 | 28.9 GiB | SD | 0x00001d/0x4144 | 01/2021 | 0x1/0x0 | Orange Pi PC |
| 0x000002fa | 29.1 GiB | SD32G | 0x000027/0x5048 | 12/2020 | 0x1/0x0600000000000000 | OPI 3 LTS |
| 0x00000317 | 29.1 GiB | SD16G | 0x0000fe/0x3432 | 03/2022 | 0x2/0x0 | Tanix TX6 |
| 0x00000329 | 28.9 GiB | SD32G | 0x000027/0x5048 | 07/2021 | 0x6/0x0 | Orange Pi Zero |
| 0x0000032d | 28.9 GiB | SD32G | 0x000027/0x5048 | 07/2021 | 0x6/0x0 | AML-S905X-CC |
| 0x0000033a | 28.9 GiB | SD32G | 0x000027/0x5048 | 07/2021 | 0x6/0x0 | AML-S905X-CC |
| 0x00000343 | 14.6 GiB | SD16G | 0x0000fe/0x3432 | 01/2021 | 0x2/0x0 | Orange Pi Zero |
| 0x00000343 | 14.9 GiB | ASTC | 0x000074/0x4a60 | 04/2021 | 0x2/0x0 | NanoPi R4S |
| 0x0000034a | 30.0 GiB | USD | 0x00009f/0x5449 | 02/2022 | 0x1/0x0 | Orange Pi One+ |
| 0x0000034d | 7.44 GiB | SD08G | 0x000041/0x3432 | 07/2019 | 0x2/0x0 | Orange Pi Zero |
| 0x00000358 | 29.1 GiB | SD32G | 0x000027/0x5048 | 04/2021 | 0x6/0x0 | Orange Pi Lite |
| 0x00000358 | 7.44 GiB | SD16G | 0x000000/0x3432 | 01/2022 | 0x2/0x0600000000000000 | P212 Board |
| 0x0000035b | 28.9 GiB | SD32G | 0x000027/0x5048 | 04/2021 | 0x6/0xa100000000000000 | Radxa ROCK Pi 4C |
| 0x00000368 | 7.44 GiB | SD16G | 0x0000fe/0x3432 | 01/2021 | 0x2/0x0 | Orange Pi Zero |
| 0x0000036c | 29.1 GiB | SD32G | 0x000027/0x5048 | 01/2022 | 0x6/0x0 | Asus Tinker Board S |
| 0x0000037f | 14.6 GiB | SD16G | 0x0000fe/0x3432 | 01/2021 | 0x2/0x0 | Orange Pi Zero |
| 0x0000037f | 29.2 GiB | AS | 0x000003/0x5344 | 11/2020 | 0x3/0x3733313033353137 | Khadas VIM |
| 0x00000387 | 14.6 GiB | SD16G | 0x000027/0x5048 | 03/2021 | 0x1/0x0600000000000000 | OPI 3 LTS |
| 0x00000392 | 58.2 GiB | ASTC | 0x000012/0x3456 | 03/2021 | 0x2/0x0 | BPI-M2-Zero |
| 0x00000396 | 28.9 GiB | SD32G | 0x000027/0x5048 | 11/2021 | 0x6/0x0600000000000000 | OrangePi 4 LTS |
| 0x0000039f | 7.48 GiB | SD16G | 0x0000fe/0x3432 | 01/2021 | 0x2/0x0 | Orange Pi One |
| 0x000003ab | 7.50 GiB | ASTC | 0x000012/0x5678 | 05/2017 | 0x3/0x0 | NanoPi R2S |
| 0x000003ac | 14.6 GiB | ASTC | 0x0000fe/0x3456 | 09/2021 | 0x1/0x0 | OrangePi Zero2 |
| 0x000003c2 | 7.50 GiB | SD16G | 0x000041/0x3432 | 06/2014 | 0x2/0x0600000000000000 | Orange Pi 3 LTS |
| 0x000003cb | 29.1 GiB | SD32G | 0x000074/0x4a60 | 08/2021 | 0x6/0x1 | Orange Pi PC |
| 0x000003db | 7.44 GiB | SD16G | 0x000000/0x3432 | 11/2021 | 0x2/0x0000000000000000 | Orange Pi Zero2 |
| 0x000003db | 7.44 GiB | SD16G | 0x000000/0x3432 | 11/2021 | 0x2/0x0 | Orange Pi Zero2 |
| 0x00000401 | 58.2 GiB | SD16G | 0x0000fe/0x3432 | 08/2022 | 0x2/0x0 | Orange Pi Zero |
| 0x00000411 | 14.6 GiB | SD16G | 0x0000fe/0x3432 | 01/2021 | 0x2/0x0 | Orange Pi Zero |
| 0x00000417 | 14.6 GiB | ASTC | 0x0000fe/0x3456 | 09/2021 | 0x1/0x2 | Orange Pi Zero |
| 0x0000042a | 14.6 GiB | ASTC | 0x000000/0x8107 | 07/2019 | 0x1/0x2 | BPI-M2-Zero |
| 0x0000042f | 29.8 GiB | SD16G | 0x000000/0x3432 | 04/2020 | 0x2/0x0 | Orange Pi PC |
| 0x00000430 | 7.44 GiB | SD16G | 0x000074/0x4a60 | 11/2021 | 0x2/0x0 | Tritium |
| 0x00000434 | 28.8 GiB | SD32G | 0x000027/0x5048 | 10/2021 | 0x6/0x0 | Orange Pi PC |
| 0x00000441 | 29.1 GiB | SD32G | 0x000027/0x5048 | 01/2021 | 0x1/0x0 | Orange Pi 5 |
| 0x00000455 | 7.44 GiB | SD16G | 0x0000fe/0x3432 | 03/2021 | 0x2/0x0 | Orange Pi One |
| 0x0000045e | 58.9 GiB | ASTC | 0x00009f/0x5449 | 12/2021 | 0x2/0x0 | Asus Tinker Board S |
| 0x0000047f | 28.9 GiB | SD32G | 0x000027/0x5048 | 11/2021 | 0x6/0x0 | Orange Pi Zero2 |
| 0x00000486 | 58.2 GiB | 00000 | 0x00009f/0x5449 | 07/2022 | 0x0/0x0 | AML-S905X-CC |
| 0x00000496 | 14.6 GiB | SD16G | 0x0000fe/0x3432 | 01/2021 | 0x2/0x0 | Orange Pi Zero |
| 0x0000049c | 14.6 GiB | SD16G | 0x0000fe/0x3432 | 01/2021 | 0x2/0x0 | Orange Pi Zero |
| 0x000004b2 | 7.32 GiB | ASTC | 0x000012/0x5678 | 03/2016 | 0x3/0x0100000000000000 | Q201 Board |
| 0x000004cf | 14.6 GiB | SD16G | 0x0000fe/0x3432 | 01/2021 | 0x2/0x0 | Orange Pi Zero |
| 0x000004ed | 14.6 GiB | SD16G | 0x0000fe/0x3432 | 01/2021 | 0x2/0x0 | Orange Pi Zero |
| 0x000004f8 | 7.44 GiB | SD | 0x000012/0x3456 | 11/2015 | 0x0/0xa100000000000000 | P212 Board |
| 0x00000527 | 29.6 GiB | SD16G | 0x0000fe/0x3432 | 07/2021 | 0x2/0x0600000000000000 | OrangePi 3 LTS |
| 0x00000529 | 28.9 GiB | SD32G | 0x000027/0x5048 | 04/2021 | 0x6/0x0 | Orange Pi PC |
| 0x0000052f | 7.44 GiB | SD | 0x000012/0x3456 | 06/2016 | 0x0/0xa100000000000000 | Rureka |
| 0x00000538 | 30.0 GiB | USD | 0x00001d/0x4144 | 02/2020 | 0x1/0x0 | BPI-M2-Ultra |
| 0x0000053b | 14.6 GiB | SD16G | 0x0000fe/0x3432 | 01/2021 | 0x2/0x0 | Orange Pi Zero |
| 0x00000540 | 7.44 GiB | AS | 0x000003/0x5344 | 01/2020 | 0x3/0x4 | Orange Pi One |
| 0x00000543 | 29.1 GiB | SD32G | 0x000074/0x4a60 | 08/2021 | 0x6/0x0600000000000000 | AMedia X96 Max |
| 0x0000054b | 14.9 GiB | ASTC | 0x000012/0x5678 | 11/2015 | 0x3/0x3733313033353137 | Rureka |
| 0x0000054b | 7.26 GiB | 00000 | 0x00009f/0x5449 | 09/2021 | 0x0/0x0 | Orange Pi PC Plus |
| 0x0000054c | 28.9 GiB | SD32G | 0x000027/0x5048 | 04/2022 | 0x6/0x0 | Orange Pi Zero2 |
| 0x00000558 | 29.5 GiB | SD16G | 0x000041/0x3432 | 06/2018 | 0x2/0x0 | Orange Pi One |
| 0x00000567 | 7.45 GiB | SD | 0x0000df/0x2011 | 04/2021 | 0x2/0x0600000000000000 | Orange Pi 3 LTS |
| 0x00000571 | 14.7 GiB | ASTC | 0x000012/0x5678 | 11/2017 | 0x3/0x0600000000000000 | OPI 3 LTS |
| 0x00000574 | 14.6 GiB | SD16G | 0x0000fe/0x3432 | 01/2021 | 0x2/0x0 | Orange Pi Zero |
| 0x000005a4 | 14.6 GiB | SD16G | 0x000027/0x5048 | 05/2021 | 0x6/0x0 | Orange Pi Zero |
| 0x000005ae | 7.52 GiB | SD08G | 0x0000ff/0x0000 | 12/2019 | 0x2/0x0 | Orange Pi Zero 2 |
| 0x000005bc | 15.0 GiB | SD16G | 0x000041/0x3432 | 03/2019 | 0x2/0x0 | Orange Pi Zero |
| 0x000005c8 | 15.0 GiB | SDC | 0x000074/0x4a45 | 12/2011 | 0x0/0x0 | Banana Pi |
| 0x000005cf | 29.1 GiB | SD16G | 0x000000/0x3432 | 12/2019 | 0x2/0x0 | Orange Pi One |
| 0x000005d9 | 29.1 GiB | SD32G | 0x000074/0x4a60 | 08/2021 | 0x6/0x4 | Orange Pi R1 Plus Lts |
| 0x000005db | 28.9 GiB | SD32G | 0x000027/0x5048 | 04/2022 | 0x6/0x0300000000000000 | OrangePi 4 |
| 0x000005e6 | 15.0 GiB | SDC | 0x000074/0x4a45 | 07/2011 | 0x0/0x0 | Banana Pi |
| 0x00000600 | 29.5 GiB | ASTC | 0x000012/0x5678 | 06/2018 | 0x3/0x0 | Orange Pi Zero Plus |
| 0x00000629 | 29.1 GiB | SD16G | 0x0000fe/0x3432 | 01/2007 | 0x2/0x0 | OrangePi Zero2 |
| 0x00000637 | 29.5 GiB | SD16G | 0x000041/0x3432 | 02/2017 | 0x2/0x0 | OrangePi Zero Plus2 H3 |
| 0x00000650 | 7.45 GiB | SD16G | 0x00009f/0x3432 | 03/2019 | 0x1/0x0100000000000000 | Tanix TX6 |
| 0x0000065b | 29.2 GiB | SD16G | 0x000000/0x3432 | 11/2020 | 0x2/0x0 | Orange Pi 5 |
| 0x00000664 | 28.2 GiB | SD32G | 0x000027/0x5048 | 11/2021 | 0x6/0x0 | RPi 3B Rev 1.2 |
| 0x0000067d | 14.6 GiB | SD16G | 0x0000fe/0x3432 | 01/2021 | 0x2/0x0 | Orange Pi Zero |
| 0x0000067e | 29.1 GiB | SD32G | 0x000027/0x5048 | 05/2021 | 0x6/0x0 | Orange Pi PC |
| 0x000006b0 | 29.7 GiB | 00000 | 0x000028/0x4245 | 10/2015 | 0x1/0x0 | Orange Pi Zero2 |
| 0x000006cc | 28.9 GiB | SD32G | 0x000027/0x5048 | 08/2021 | 0x6/0x0 | Orange Pi Zero2 |
| 0x000006d8 | 29.5 GiB | SD16G | 0x000012/0x5678 | 03/2010 | 0x3/0x4 | Orange Pi Lite |
| 0x000006df | 29.1 GiB | SD32G | 0x000074/0x4a60 | 02/2022 | 0x6/0x1 | BPI-M2-Zero |
| 0x000006df | 29.5 GiB | SD16G | 0x000000/0x3432 | 05/2019 | 0x2/0x0 | Makerbase mks-pi |
| 0x000006ec | 7.50 GiB | APPSD | 0x000000/0x3000 | 09/2016 | 0x0/0x0100000000000000 | P281 Board |
| 0x00000740 | 29.5 GiB | SD | 0x0000fe/0x3432 | 12/2020 | 0x2/0x0600000000000000 | OPI 3 LTS |
| 0x00000763 | 29.1 GiB | SD16G | 0x000000/0x3432 | 07/2019 | 0x2/0x0 | Orange Pi Zero |
| 0x0000077f | 29.4 GiB | SMI | 0x00006f/0x0013 | 11/2019 | 0x0/0x0 | Orange Pi Zero |
| 0x00000789 | 29.2 GiB | SD16G | 0x000000/0x3432 | 03/2020 | 0x2/0x0600000000000000 | OrangePi 4 |
| 0x00000794 | 28.9 GiB | SD32G | 0x000027/0x5048 | 05/2021 | 0x6/0x0 | Orange Pi Zero2 |
| 0x00000794 | 28.9 GiB | SD32G | 0x000027/0x5048 | 05/2021 | 0x6/0x0 | OrangePi Zero2 |
| 0x000007ba | 28.9 GiB | SD32G | 0x000027/0x5048 | 04/2022 | 0x6/0x0 | ODROID-C2 |
| 0x000007bb | 29.5 GiB | ASTC | 0x000006/0x524b | 04/2015 | 0x3/0x4 | Cubietruck |
| 0x00000801 | 29.1 GiB | SD32G | 0x000027/0x5048 | 02/2022 | 0x6/0x0 | Cubietruck |
| 0x00000829 | 7.45 GiB | SD | 0x0000df/0x2011 | 06/2021 | 0x2/0x0 | Orange Pi PC Plus |
| 0x0000082b | 7.44 GiB | 00000 | 0x000019/0x4459 | 11/2015 | 0xf/0xf | Orange Pi Zero |
| 0x00000845 | 3.72 GiB | ASTC | 0x000012/0x5678 | 04/2015 | 0x3/0x4 | Orange Pi Lite |
| 0x0000084d | 14.8 GiB | SD16G | 0x0000fe/0x3432 | 07/2021 | 0x2/0x0600000000000000 | Orange Pi 3 LTS |
| 0x00000853 | 7.45 GiB | ASTC | 0x000041/0x3432 | 11/2020 | 0x2/0x0 | rockpi4b |
| 0x00000862 | 29.8 GiB | SD32G | 0x00009f/0x5449 | 12/2021 | 0x2/0x0 | RockPro 64 |
| 0x00000867 | 7.44 GiB | SD16G | 0x000000/0x3432 | 11/2021 | 0x2/0x0 | AML-S905X-CC |
| 0x0000087a | 14.7 GiB | SD | 0x000012/0x3456 | 04/2016 | 0x0/0x0 | P212 Board |
| 0x0000089e | 29.1 GiB | SD16G | 0x000000/0x3432 | 09/2020 | 0x2/0x1 | ODROID-HC4 |
| 0x000008ab | 14.6 GiB | ASTC | 0x000012/0x3456 | 01/2022 | 0x0/0x0 | Orange Pi Zero |
| 0x000008b3 | 29.1 GiB | SD32G | 0x000074/0x4a60 | 08/2021 | 0x6/0x0 |  |
| 0x000008e1 | 28.9 GiB | SD32G | 0x000027/0x5048 | 12/2021 | 0x6/0x0600000000000000 | OrangePi 3 LTS |
| 0x000008e4 | 7.45 GiB | SD16G | 0x000041/0x3432 | 06/2019 | 0x2/0x0 | P281 Board |
| 0x00000977 | 7.45 GiB | SD | 0x000012/0x3456 | 01/2020 | 0x0/0x0 | Orange Pi Zero |
| 0x00000979 | 14.6 GiB | SD16G | 0x0000fe/0x3432 | 10/2020 | 0x2/0x0 | Orange Pi PC |
| 0x0000097a | 7.36 GiB | ASTC | 0x000041/0x3432 | 01/2020 | 0x2/0x0 | Orange Pi One |
| 0x00000997 | 29.5 GiB | 0000 | 0x000000/0x0000 | 09/2015 | 0x0/0x0000000000000000 | NEXBOX A95X (S905X) |
| 0x000009d6 | 14.6 GiB | SD16G | 0x000027/0x5048 | 02/2022 | 0x6/0x0100000000000000 | OrangePi Zero2 |
| 0x000009df | 29.2 GiB | SD16G | 0x000000/0x3432 | 03/2020 | 0x2/0x0000000000000000 | P212 Board |
| 0x000009e9 | 7.44 GiB | AS | 0x000003/0x5344 | 12/2020 | 0x3/0x0600000000000000 | Rureka |
| 0x000009ec | 14.5 GiB | SD16G | 0x000000/0x3432 | 08/2019 | 0x2/0x0 | Orange Pi PC Plus |
| 0x000009f6 | 29.5 GiB | SD16G | 0x000041/0x3432 | 10/2018 | 0x2/0x0 | Orange Pi Zero |
| 0x00000a0c | 14.7 GiB | 00000 | 0x00009f/0x5449 | 01/2019 | 0x0/0x0600000000000000 | OrangePi 4 |
| 0x00000a14 | 14.7 GiB | 00000 | 0x00009f/0x5449 | 01/2019 | 0x0/0x0 | OrangePi 4 LTS |
| 0x00000a2a | 14.6 GiB | SD16G | 0x0000fe/0x3432 | 11/2019 | 0x2/0x0 | Banana Pro |
| 0x00000a7c | 3.71 GiB | SMI | 0x00006f/0x0000 | 05/2013 | 0x1/0x0 | Banana Pi |
| 0x00000a90 | 250 GiB | APPSD | 0x000000/0x0000 | 05/2022 | 0x0/0x0600000000000000 | OrangePi 3 LTS |
| 0x00000ae3 | 28.8 GiB | SD16G | 0x0000fe/0x3432 | 01/2021 | 0x2/0x0 | Cubietruck |
| 0x00000b27 | 7.45 GiB | SD16G | 0x000000/0x3432 | 12/2019 | 0x2/0x0 | Orange Pi Plus 2E |
| 0x00000b73 | 14.6 GiB | SD16G | 0x000027/0x5048 | 02/2022 | 0x6/0x0 | Orange Pi Lite |
| 0x00000ba0 | 28.9 GiB | SD32G | 0x000027/0x5048 | 12/2021 | 0x6/0x0100000000000000 | NEXBOX A95X |
| 0x00000ba8 | 28.9 GiB | SD32G | 0x000027/0x5048 | 12/2021 | 0x6/0x0600000000000000 |  |
| 0x00000bc1 | 58.6 GiB | SD16G | 0x000000/0x3432 | 02/2021 | 0x2/0x0 | Sunvell R69 |
| 0x00000bca | 29.2 GiB | SD16G | 0x000000/0x3432 | 06/2011 | 0x2/0x0 | NanoPi K2 |
| 0x00000bef | 14.7 GiB | SD16G | 0x000041/0x3432 | 07/2019 | 0x2/0x0 | Orange Pi Zero |
| 0x00000c45 | 29.2 GiB | SD16G | 0x000000/0x3432 | 11/2019 | 0x2/0x0 | NanoPi M1 |
| 0x00000c84 | 29.1 GiB | 00000 | 0x00009f/0x5449 | 01/2020 | 0x0/0x0 | Rockchip RK3318 BOX |
| 0x00000cd3 | 58.3 GiB | SD | 0x000012/0x3456 | 08/2019 | 0x0/0x0000000000000000 | OrangePi 4 LTS |
| 0x00000ced | 14.6 GiB | ASTC | 0x0000fe/0x3456 | 07/2020 | 0x1/0x0 | OrangePi Zero2 |
| 0x00000d1b | 7.44 GiB | AS | 0x000003/0x5344 | 12/2020 | 0x3/0xa100000000000000 | P212 Board |
| 0x00000d30 | 7.45 GiB | SD16G | 0x000000/0x3432 | 12/2019 | 0x2/0x0 | NanoPi NEO |
| 0x00000d55 | 7.44 GiB | 00000 | 0x00009f/0x5449 | 06/2022 | 0x0/0x0 | OrangePi Zero2 |
| 0x00000d89 | 29.5 GiB | SD16G | 0x000000/0x3432 | 06/2019 | 0x2/0x0 | Orange Pi Zero |
| 0x00000d98 | 14.6 GiB | ASTC | 0x0000fe/0x3456 | 02/2022 | 0x1/0x2 | Orange Pi Zero2 |
| 0x00000dad | 7.48 GiB | ASTC | 0x0000fe/0x3456 | 09/2020 | 0x1/0x0600000000000000 | OPI 3 LTS |
| 0x00000dc1 | 29.1 GiB | SD16G | 0x000000/0x3432 | 10/2022 | 0x2/0x0 | Orange Pi 5 |
| 0x00000e00 | 15.0 GiB | SD16G | 0x000041/0x3432 | 09/2017 | 0x2/0x0 | Orange Pi Prime |
| 0x00000e52 | 7.45 GiB | SD | 0x000012/0x3456 | 02/2020 | 0x0/0x0600000000000000 | OPI 3 LTS |
| 0x00000e8e | 7.44 GiB | 00000 | 0x000000/0x0000 | 02/2015 | 0x1/0x0000000000000000 | P212 Board |
| 0x00000e95 | 29.8 GiB | 00000 | 0x000000/0x0000 | 02/2019 | 0x1/0x0 | Orange Pi Zero 2 |
| 0x00000eae | 29.2 GiB | SD16G | 0x0000fe/0x3432 | 12/2019 | 0x2/0x0 | Orange Pi Zero |
| 0x00000ebf | 29.1 GiB | SD16G | 0x0000fe/0x3432 | 02/2020 | 0x2/0x0600000000000000 | Orange Pi Zero Plus |
| 0x00000ec6 | 14.8 GiB | SD16G | 0x0000fe/0x3432 | 05/2022 | 0x2/0x0 | Makerbase mks-pi |
| 0x00000ecf | 7.44 GiB | AS | 0x000003/0x5344 | 11/2019 | 0x3/0x0100000000000000 | P212 Board |
| 0x00000ed0 | 29.1 GiB | ASTC | 0x0000fe/0x3456 | 12/2021 | 0x1/0x0806020000000000 | Radxa ROCK Pi 4B |
| 0x00000f45 | 30.0 GiB | USD | 0x000000/0x0000 | 04/2002 | 0x1/0xa100000000000000 | Khadas VIM |
| 0x00000f9c | 7.26 GiB | 00000 | 0x00009f/0x5449 | 04/2022 | 0x0/0x0 | BPI-M2-Zero |
| 0x00000fdb | 30.0 GiB | USD | 0x000000/0x0000 | 10/2020 | 0x1/0x0 |  |
| 0x000011af | 7.44 GiB | SD16G | 0x0000fe/0x3432 | 03/2022 | 0x2/0x1000000000000000 | Tanix TX6 |
| 0x000011b6 | 29.8 GiB | USD | 0x00001d/0x4144 | 10/2021 | 0x1/0x0 | Orange Pi One |
| 0x000011c1 | 7.44 GiB | SD16G | 0x000000/0x3432 | 01/2021 | 0x2/0x0 | OrangePi Zero2 |
| 0x000011df | 14.9 GiB | 00000 | 0x000000/0x0000 | 08/2016 | 0x1/0xa100000000000000 | P212 Board |
| 0x000012a8 | 7.50 GiB | SD16G | 0x000041/0x3432 | 03/2018 | 0x2/0x0 | Orange Pi Zero |
| 0x00001317 | 7.50 GiB | SD16G | 0x0000fe/0x3432 | 07/2021 | 0x2/0x0 | Orange Pi Zero2 |
| 0x000013c3 | 29.1 GiB | SD16G | 0x0000fe/0x3432 | 01/2021 | 0x2/0x0300000000000000 | OrangePi 4 LTS |
| 0x0000140b | 14.5 GiB | 00000 | 0x00009f/0x5449 | 04/2022 | 0x0/0x0 | Orange Pi PC |
| 0x00001585 | 14.7 GiB | SD | 0x00001a/0x5051 | 10/2012 | 0x0/0x0 | Orange Pi Zero 2 |
| 0x000016ec | 29.5 GiB | SD16G | 0x000041/0x3432 | 07/2018 | 0x2/0x0 | Pine64 |
| 0x000016f4 | 117 GiB | SD | 0x000000/0x3432 | 07/2019 | 0x2/0x0600000000000000 | Ltd X96 Max |
| 0x00001771 | 7.45 GiB | SD16G | 0x000041/0x3432 | 02/2019 | 0x2/0x0300200100030000 | Rockchip RK3318 BOX |
| 0x00001798 | 7.45 GiB | 00000 | 0x000000/0x0000 | 05/2019 | 0x1/0x0600000000000000 | P212 Board |
| 0x000017f6 | 29.8 GiB | USD | 0x000000/0x0000 | 08/2020 | 0x1/0x0 | Orange Pi PC Plus |
| 0x00001861 | 7.45 GiB | SD16G | 0x000041/0x3432 | 02/2019 | 0x2/0x0600000000000000 | OrangePi 3 LTS |
| 0x000018b9 | 7.44 GiB | 00000 | 0x000074/0x4a60 | 12/2016 | 0x0/0x0 | Orange Pi PC Plus |
| 0x000018c6 | 29.1 GiB | SD16G | 0x000000/0x3432 | 02/2022 | 0x2/0x0 | Orange Pi One |
| 0x00001925 | 29.2 GiB | SD16G | 0x000000/0x3432 | 10/2019 | 0x2/0x0 | Orange Pi PC |
| 0x00001968 | 29.6 GiB | SD16G | 0x000000/0x3432 | 12/2019 | 0x2/0x0 | NanoPi M1 |
| 0x000019b8 | 7.70 GiB | SD | 0x000074/0x4a45 | 10/2012 | 0x1/0x0 | Orange Pi PC |
| 0x00001b82 | 7.52 GiB | SD08G | 0x0000ff/0x0000 | 05/2020 | 0x2/0x0 | Makerbase mks-pi |
| 0x00001d3f | 29.6 GiB | NCard | 0x000082/0x4a54 | 08/2013 | 0x1/0x0 | BPI-M2-Zero |
| 0x00001d71 | 29.1 GiB | ASTC | 0x000012/0x3456 | 11/2021 | 0x2/0x0 | Orange Pi Zero |
| 0x00001d84 | 15.0 GiB | SD16G | 0x000041/0x3432 | 05/2016 | 0x2/0x0 | Orange Pi Zero |
| 0x00001e34 | 14.5 GiB | 00000 | 0x00009f/0x5449 | 11/2019 | 0x0/0x0 | Orange Pi Zero 2 |
| 0x0000203f | 7.52 GiB | SD08G | 0x0000ff/0x3432 | 09/2019 | 0x2/0x0 | Orange Pi One |
| 0x00002193 | 30.0 GiB | USD | 0x00001d/0x4144 | 01/2002 | 0x1/0x0 | BPI-M2-Zero |
| 0x00002199 | 29.5 GiB | SD16G | 0x000041/0x3432 | 10/2018 | 0x2/0x0600000000000000 | Orange Pi 3 |
| 0x00002438 | 7.44 GiB | SD16G | 0x0000fe/0x3432 | 01/2021 | 0x2/0x0600000000000000 |  |
| 0x00002468 | 14.6 GiB | 00000 | 0x000000/0x0000 | 02/2018 | 0x1/0x0 | Pine64 RockPro64 v2.1 |
| 0x0000254b | 7.44 GiB | SD | 0x000012/0x3456 | 08/2019 | 0x0/0x0 | Orange Pi Zero |
| 0x00002651 | 29.1 GiB | SD32G | 0x000074/0x4a60 | 05/2021 | 0x6/0x0600000000000000 | Orange Pi 3 LTS |
| 0x000027fb | 14.6 GiB | 00000 | 0x000045/0x2d42 | 03/2018 | 0x0/0x0 | Orange Pi PC Plus |
| 0x00002909 | 7.44 GiB | 00000 | 0x000000/0x0000 | 04/2015 | 0x1/0x0600000000000000 | P212 Board |
| 0x0000295b | 29.1 GiB | SD16G | 0x0000fe/0x3432 | 03/2021 | 0x2/0x0 | Orange Pi Zero 2 |
| 0x00002984 | 29.8 GiB | SD16G | 0x0000fe/0x3432 | 04/2022 | 0x2/0x0 | Orange Pi Plus 2E |
| 0x000029c0 | 7.26 GiB | 00000 | 0x00009f/0x5449 | 03/2022 | 0x0/0x0600000000000000 | Orange Pi 3 LTS |
| 0x000029ee | 29.8 GiB | SD32G | 0x000000/0x3432 | 12/2020 | 0x2/0x0 | Tanix TX6 |
| 0x00002c1a | 7.70 GiB | SD | 0x00001a/0x5051 | 11/2012 | 0x1/0x0 | NanoPi NEO |
| 0x00002cc2 | 7.38 GiB | TEAT | 0x000045/0x2d42 | 07/2014 | 0x0/0x0 | Cubieboard2 |
| 0x00002d19 | 14.8 GiB | ASTC | 0x000012/0x5678 | 04/2018 | 0x3/0x4 | Banana Pro |
| 0x00002d88 | 15.0 GiB | F0F0F | 0x000012/0x3456 | 08/2012 | 0x1/0x0 | Banana Pi |
| 0x00002e30 | 29.6 GiB | SD16G | 0x0000fe/0x3432 | 01/2021 | 0x2/0x0600000000000000 | OPI 3 LTS |
| 0x00002ea3 | 14.9 GiB | USD | 0x00001d/0x4144 | 03/2021 | 0x1/0x0 | Orange Pi One |
| 0x000030de | 14.5 GiB | 00000 | 0x00009f/0x5449 | 04/2022 | 0x0/0x0400000000000000 | P212 Board |
| 0x000032fe | 14.8 GiB | SD16G | 0x0000fe/0x3432 | 07/2022 | 0x2/0x0100000000000000 | P231 |
| 0x000035c4 | 7.45 GiB | ASTC | 0x000041/0x3432 | 11/2020 | 0x2/0x0 | Orange Pi PC Plus |
| 0x000035e0 | 14.6 GiB | SD | 0x000012/0x3456 | 09/2018 | 0x0/0x0300000000000000 | P212 Board |
| 0x00003853 | 29.1 GiB | SD16G | 0x0000fe/0x3432 | 03/2021 | 0x2/0x0600000000000000 | OrangePi Zero2 |
| 0x00003861 | 7.41 GiB | 00000 | 0x000000/0x0000 | 07/2016 | 0x1/0x0600000000000000 | P212 Board |
| 0x000038c0 | 58.2 GiB | SD64G | 0x000074/0x4a60 | 03/2022 | 0x6/0x0600000000000000 | OrangePi 3 LTS |
| 0x00003ac5 | 14.6 GiB | SD16G | 0x000041/0x3432 | 11/2018 | 0x2/0x0 | BPI-M2-Ultra |
| 0x00003ec5 | 7.26 GiB | 00000 | 0x00009f/0x5449 | 10/2021 | 0x0/0x0600000000000000 | Orange Pi 3 |
| 0x000041f0 | 30.0 GiB | USD | 0x000000/0x0000 | 04/2002 | 0x1/0x0600000000000000 | Orange Pi 3 |
| 0x000043ff | 29.1 GiB | SD16G | 0x0000fe/0x3432 | 03/2021 | 0x2/0x0600000000000000 |  |
| 0x00004649 | 119 GiB | TO | 0x000045/0x2d42 | 02/2019 | 0x0/0x0 | S805 |
| 0x000046c5 | 58.2 GiB | SD64G | 0x000074/0x4a60 | 04/2021 | 0x6/0x1 | Orange Pi Zero 2 |
| 0x00004cfc | 58.6 GiB | SD16G | 0x000000/0x3432 | 11/2019 | 0x2/0x0600000000000000 | Orange Pi 3 LTS |
| 0x00004d2c | 7.44 GiB | 00000 | 0x000028/0x4245 | 03/2003 | 0x1/0x0 | Orange Pi Zero |
| 0x00004f9c | 14.7 GiB | 00000 | 0x00009f/0x5449 | 07/2019 | 0x0/0x0000000000000000 | P281 Board |
| 0x00004ff8 | 7.44 GiB | SD16G | 0x000000/0x3432 | 09/2021 | 0x2/0x0600000000000000 | P212 Board |
| 0x00004ff8 | 7.44 GiB | SD16G | 0x000000/0x3432 | 09/2021 | 0x2/0x0600000000000000 | Khadas VIM |
| 0x000052c4 | 15.4 GiB | APPSD | 0x000000/0x0000 | 03/2022 | 0x0/0x0 | BPI-M2-Ultra |
| 0x00005597 | 14.5 GiB | 00000 | 0x00009f/0x5449 | 04/2021 | 0x0/0x0 | Orange Pi Zero |
| 0x00005b06 | 7.44 GiB | SD16G | 0x0000fe/0x3432 | 01/2021 | 0x2/0x0 | Orange Pi One |
| 0x00005ba8 | 3.72 GiB | 00000 | 0x000019/0x4459 | 08/2018 | 0xf/0xf | Orange Pi Zero |
| 0x00005d02 | 29.1 GiB | SD16G | 0x0000fe/0x3432 | 03/2021 | 0x2/0x0 | Cubietruck |
| 0x00005e6a | 29.1 GiB | SD16G | 0x000000/0x3432 | 11/2021 | 0x2/0x0 |  |
| 0x00005ee8 | 7.44 GiB | SD16G | 0x000000/0x3432 | 07/2020 | 0x2/0x0 | Orange Pi One |
| 0x00006053 | 15.0 GiB | USD | 0x00001d/0x4144 | 12/2020 | 0x1/0x0 | Orange Pi Zero |
| 0x00006313 | 29.8 GiB | USD | 0x00001d/0x4144 | 01/2022 | 0x1/0x0 | BPI-M3 |
| 0x00006378 | 29.1 GiB | ASTC | 0x0000fe/0x3456 | 02/2022 | 0x1/0x0600000000000000 | OPI 3 LTS |
| 0x000063e4 | 29.5 GiB | SD16G | 0x0000fe/0x3432 | 01/2010 | 0x2/0x0 | Orange Pi One |
| 0x000063e4 | 29.6 GiB | SD16G | 0x0000fe/0x3432 | 01/2010 | 0x2/0x0 | Orange Pi One |
| 0x00006559 | 29.8 GiB | 00000 | 0x000000/0x0000 | 06/2014 | 0x1/0x0 | OrangePi One Plus |
| 0x00006c8e | 7.44 GiB | SD16G | 0x000000/0x3432 | 09/2021 | 0x2/0xa100000000000000 | Rureka |
| 0x00006d54 | 29.1 GiB | SD16G | 0x0000fe/0x3432 | 03/2021 | 0x2/0x0600000000000000 | OPI 3 LTS |
| 0x00006e37 | 29.8 GiB | USD | 0x00001d/0x4144 | 02/2022 | 0x1/0x0600000000000000 | Orange Pi 3 |
| 0x00006e37 | 29.8 GiB | USD | 0x00001d/0x4144 | 02/2022 | 0x1/0x0600000000000000 | Orange Pi 3 LTS |
| 0x00006e41 | 7.44 GiB | AS | 0x000003/0x5344 | 02/2016 | 0xf/0x0300000000000000 | AMedia X96 Max+ |
| 0x00006fd1 | 29.1 GiB | SD16G | 0x0000fe/0x3432 | 03/2021 | 0x2/0x0 | BPI-M2-Zero |
| 0x000071b2 | 30.0 GiB | USD | 0x00001d/0x4144 | 11/2021 | 0x1/0x0 | Oranth Tanix TX3 Mini |
| 0x000071b6 | 7.27 GiB | 00000 | 0x00009f/0x5449 | 01/2020 | 0x0/0x0600000000000000 | B860H V5 (S905x2) |
| 0x00007b50 | 7.44 GiB | AS | 0x000003/0x5344 | 05/2019 | 0x3/0x4 | Orange Pi PC Plus |
| 0x000080ed | 7.44 GiB | SD16G | 0x0000fe/0x3432 | 01/2021 | 0x2/0xa100000000000000 | Orange Pi Zero2 |
| 0x00008c44 | 59.5 GiB | TO | 0x000045/0x2d42 | 02/2019 | 0x0/0x0 | Orange Pi PC |
| 0x00008fcc | 7.26 GiB | 00000 | 0x00009f/0x5449 | 09/2020 | 0x0/0x0300000000000000 | OrangePi 4 LTS |
| 0x00009172 | 30.0 GiB | USD | 0x00001d/0x4144 | 05/2022 | 0x1/0x0 | Orange Pi Zero |
| 0x00009235 | 7.44 GiB | SD16G | 0x000012/0x3432 | 01/2021 | 0x2/0x0 | OPI 3 LTS |
| 0x00009235 | 7.44 GiB | SD16G | 0x000041/0x3432 | 01/2021 | 0x2/0x0 | OPI 3 LTS |
| 0x00009cdf | 14.6 GiB | ASTC | 0x0000fe/0x3456 | 10/2021 | 0x1/0x0100000000000000 | Orange Pi Zero2 |
| 0x0000a6b1 | 30.0 GiB | USD | 0x00001d/0x4144 | 12/2021 | 0x1/0x0 | Orange Pi PC |
| 0x0000b289 | 29.4 GiB | SD16G | 0x000000/0x3432 | 05/2021 | 0x2/0x0 | Oranth Tanix TX3 Mini |
| 0x0000b7c8 | 3.72 GiB | AS | 0x000003/0x5344 | 04/2015 | 0xf/0xf | Orange Pi Zero |
| 0x0000bfed | 14.9 GiB | 00000 | 0x000019/0x4459 | 03/2016 | 0xf/0xf | Orange Pi Lite |
| 0x0000cc56 | 14.9 GiB | USD | 0x00001d/0x4144 | 03/2021 | 0x1/0x0 | Orange Pi One |
| 0x0000d322 | 14.9 GiB | USD | 0x00001d/0x4144 | 02/2022 | 0x1/0x0 | AML-S905X-CC |
| 0x0000d6f9 | 14.5 GiB | 00000 | 0x00009f/0x5449 | 04/2022 | 0x0/0x0 | BPI-M2-Zero |
| 0x0000de40 | 7.32 GiB | 00000 | 0x000019/0x4459 | 08/2016 | 0xf/0xf | Orange Pi Lite |
| 0x0000de9d | 57.0 GiB | SD16G | 0x0000fe/0x3432 | 08/2021 | 0x2/0x0 | Orange Pi Plus / Plus 2 |
| 0x0000de9d | 57.0 GiB | SD16G | 0x0000fe/0x3432 | 08/2021 | 0x2/0x0 | Pine64 |
| 0x0000eab9 | 7.44 GiB | SD16G | 0x000000/0x3432 | 01/2022 | 0x2/0x0 | Orange Pi Zero |

    #!/bin/bash
    
    for serialnumber in 0x0000 ; do
    	for file in *.armhwinfo; do
    		unset name
    		grep -q "### Activated" ${file}
    		if [ $? -eq 0 ]; then
    			eval $(grep -A8 -B13 "serial: ${serialnumber}" ${file} | grep "^     " | grep -v "uevent" | sed 's/: /=/') 2>/dev/null
    			SBC="$(awk -F"Machine model: " '/Machine model:/ {print $2}' <${file} | head -n1 | sed -e 's/Xunlong //')"
    			if [ "X${SBC}" = "X" ]; then
    				SBC="$(head ${file} | awk -F'|' '/ \| / {print $2}' | head -n1 | sed -e 's/^ //' -e 's/ $//')"
    			fi
    			MMCReportedSize="$(grep " ${name} " "${file}" | awk -F" " '/ mmcblk/ {print $6" "$7}' | head -n1)"
    			[ "X${name}" != "X" ] && echo -e "| ${serial} | ${MMCReportedSize} | ${name} | ${manfid}/${oemid} | ${date} | ${hwrev}/${fwrev} | ${SBC} |"
    		fi
    	done # | sort | uniq -c
    done