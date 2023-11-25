# Finding the BCM2712 STB sibling

In a silly attempt categorizing VideoCore SoCs I tried to find the STB sibling of BCM2712, the newest VideoCore SoC in Raspberry Pi 5B revealed in September 2023.

Lists exist (see [here](https://en.wikipedia.org/wiki/VideoCore) and [there](https://wikidevi.wi-cat.ru/Broadcom/SoC#Multimedia_Processors)) but they're missing almost everything recent.

### Procedure

Starting from [this post in RPi forums](https://forums.raspberrypi.com/viewtopic.php?p=1594650#p1594650), then crawling through [https://www.khronos.org/conformance/adopters/conformant-products/opengles](https://www.khronos.org/conformance/adopters/conformant-products/opengles) and checking Geekbench 4 metadata and AES scores I ended up with the list below.

Why Geekbench 4? Since firing up a dedicated AES benchmark we're able to quickly verify existence of [ARMv8 Crypto Extensions](https://github.com/ThomasKaiser/sbc-bench/blob/master/results/ARMv8-Crypto-Extensions.md) (the RPi SoCs BCM2837, BCM2837B0, RP3A0 and BCM2711 are among those few  ARMv8 SoCs lacking AES/SHA acceleration). Geekbench Browser also allows to look up exact VideoCore (GPU) model when doing the `.gbX` 'suffix trick' (you need a free account for). If you have this link for example [https://browser.geekbench.com/v4/cpu/2673155](https://browser.geekbench.com/v4/cpu/2673155) then further information awaits you at [2673155.gb4](https://browser.geekbench.com/v4/cpu/2673155.gb4).

With newer Geekbench 5/6 by checking the `.gb5` and `.gb6` raw data you can also get the clockspeeds measured by Geekbench in the warmup phase (firing up clockspeed measurements for a fraction of a second to give the kernel the chance to ramp up clockspeeds and on hybrid designs to move the process to a performance core).

Checking the VideoCore/GPU version over at khronos.org with hopefully correct BroadCom SoC names it was possible for some of the Geekbench finds to do an exact mapping. BroadCom uses mostly Canada's nature for their SoC platform codenames (e.g. [Banff](https://en.wikipedia.org/wiki/Banff_National_Park), 
[Fundy](https://parks.canada.ca/pn-np/nb/fundy), [Inuvik](https://en.wikipedia.org/wiki/Inuvik), [Logan](https://en.wikipedia.org/wiki/Mount_Logan), [Muskoka](https://en.wikipedia.org/wiki/District_Municipality_of_Muskoka)) and Geekbench's Android version only extracts these names but not the SoC model itself.

### BroadCom's history of ARMv8 Crypto Extensions licensing (obviously based on core type)

Broadcom has/had an ARM architecture license and did two custom cores: ARMv7 "Brahma B15" (based on Cortex-A15) and ARMv8 "Brahma B53" (based on Cortex-A53). The B53 cores appeared on SoCs in 2017 initially without ARMv8 Crypto Extensions but fortunately that changed already in 2019.

But for whatever reasons (licensing costs?) with standard Cortex A cores BroadCom switched to ARMv8 Crypto Extensions only two years later. As such none of the A53 cores in any of the older VideoCore SoCs and the A72/r0p3 appearing in 2019 in Hudson Set-top boxes (BCM7211) and on RPi 4 (the BCM2711 sibling) all lack AES/SHA acceleration. This changed only recently in 2021: both the A72/r1p0 in 'Klondike' and the A76/r4p1 in 'Muskoka' (BCM2712's STB sibling) come with ARMv8 Crypto Extensions.

When first details about BCM2712 went public in Sep 2023 I was surprised to find a more recent A76 stepping than on RK3588 (r4p0) but now we know that random people already benchmarked BroadCom VideoCore VII Set-top boxes with these cores back in 2021. 

### List of SoCs where exact VideoCore version could be determined

The SoCs are listed chronologically (timestamps are either RPi announcements or first listing in Geekbench browser):

#### BCM2835

  * 1 x ARM1176 / r0p7
  * VideoCore IV
  * February 2012

#### [BCM7364](https://www.prnewswire.com/news-releases/broadcom-expands-hevc-portfolio-with-entry-level-satellite-set-top-box-socs-239034641.html)

  * 1 x Brahma B15
  * VideoCore IV (V3D-415)
  * January 2014

#### BCM2836

  * 4 x Cortex-A7 / r0p5
  * VideoCore IV
  * February 2015

#### BCM2837/BCM2837B0/RP3A0

  * 4 x Cortex-A53 / r0p4 w/o Crypto Extensions (1.2 GHz)
  * VideoCore IV
  * February 2016

#### [BCM7268](https://browser.geekbench.com/v4/cpu/search?utf8=✓&q=broadcom+bcm7268*)

  * 4 x Brahma B53 / r0p0 w/o Crypto Extensions (1.66 GHz)
  * VideoCore V (V3D-520)
  * April 2017

#### [BCM7260 (Elfin)](https://browser.geekbench.com/v4/cpu/3779234)

  * 2 x Brahma B53 / r0p0 w/o Crypto Extensions (1.5 GHz)
  * VideoCore V (V3D-510)
  * August 2017

#### [Grouse](https://browser.geekbench.com/v4/cpu/search?utf8=✓&q=broadcom+grouse)

  * 2 x Brahma B53 / r0p0 with Crypto Extensions (1.84 GHz)
  * VideoCore V (V3D-510)
  * January 2019

#### [BCM7271](https://browser.geekbench.com/v4/cpu/12465921)

  * 4 x Brahma B53 / r0p0 with Crypto Extensions (1.66 GHz)
  * VideoCore V (V3D-520)
  * March 2019

#### [BCM7252 (Avko/Banff)](https://browser.geekbench.com/v4/cpu/2113312)

  * 2 x Brahma B15 / r0p3 (1.72 GHz)
  * VideoCore V (V3D-530)
  * March 2017

#### [BCM7218 (Inuvik)](https://nitter.net/androidtv_rumor/status/1110846991427227648)

  * 4 x Brahma B53 / r0p0 with Crypto Extensions (2.62 GHz)
  * VideoCore VI (V3D-620)
  * February 2019

#### [BCM7211 (Hudson)](https://nitter.net/androidtv_rumor/status/1110846991427227648)

  * 4 x Cortex-A72 / r0p3 w/o Crypto Extensions (1.66 GHz)
  * VideoCore VI (V3D-620)
  * May 2019
  * [searching for Hudson](https://browser.geekbench.com/v4/cpu/search?page=1&q=broadcom+hudson&utf8=✓) also shows dual-core variants

#### [BCM2711](https://browser.geekbench.com/v4/cpu/15931221.gb4)

  * 4 x Cortex-A72 / r0p3 w/o Crypto Extensions
  * VideoCore VI
  * June 2019

#### [Logan](https://browser.geekbench.com/v4/cpu/search?utf8=✓&q=broadcom+logan)

  * 4 x Brahma B53 / r0p0 with Crypto Extensions (2.01 GHz)
  * VideoCore VI (V3D-620)
  * January 2021

#### [Klondike](https://browser.geekbench.com/v4/cpu/search?page=1&q=broadcom+klondike&utf8=✓)

  * 2 x Cortex-A72 / r1p0 with Crypto Extensions (1.80 GHz)
  * VideoCore VI (V3D-620)
  * January 2021

#### [BCM7278 (Fundy)](https://browser.geekbench.com/v4/cpu/11587209.gb4)

  * 4 x Brahma B53 / r0p0 with Crypto Extensions (1.87 / 2.01 GHz)
  * VideoCore VI (V3D-630)
  * November 2018

#### [Muskoka](https://browser.geekbench.com/v4/cpu/search?utf8=✓&q=Muskoka)

  * 4 x Cortex-A76 / r4p1 with Crypto Extensions (2.1 - 2.3 GHz)
  * VideoCore VII (V3D-740)
  * December 2021

#### [BCM2712](https://www.khronos.org/conformance/adopters/conformant-products/opengles)

  * 4 x Cortex-A76 / r4p1 with Crypto Extensions (2.4 - 3.0 GHz)
  * VideoCore VII
  * September 2023
