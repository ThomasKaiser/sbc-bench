# Benchmarking some benchmarks

["Casual benchmarking: you benchmark A, but actually measure B, and conclude you've measured C."](https://www.brendangregg.com/activebenchmarking.html)

Let's look a bit closer at some popular passive benchmarks...

## Dhrystone / DMIPS / DMIPS/MHz

DMIPS are 'Dhrystone MIPS', the single-threaded score of the Dhrystone benchmark developed 1984 (over four decades ago!) as an improvement over the older MIPS metric ('million instructions per second' which became kinda pointless back then with the 'RISC vs. CISC' battle).

Written in the programming languages popular back then (FORTRAN, PL/1, SAL, ALGOL 68 and Pascal) and suited for the single-core CPUs of that time (almost every modern MCU is outperforming now) Dhrystone results do not represent **anything** that runs on today's computers. DMIPS since decades are misleading for the following reasons ([quoted from Wikipedia](https://en.wikipedia.org/wiki/Dhrystone#Shortcomings) and an [ARM White Paper](https://wiki.cdot.senecacollege.ca/wiki/Dhrystone_howto)):

  * Dhrystone features unusual code that is not usually representative of modern real-life programs.
  * Dhrystone is susceptible to compiler optimizations. For example, it does a lot of string copying in an attempt to measure string copying performance. However, the strings in Dhrystone are of known constant length and their starts are aligned on natural boundaries, two characteristics usually absent from real programs. Therefore, an optimizer can replace a string copy with a sequence of word moves without any loops, which will be much faster. This optimization consequently overstates system performance, sometimes by more than 30%.
  * Dhrystone's small code size may fit in the instruction cache of a modern CPU, so that instruction fetch performance is not rigorously tested. Similarly, Dhrystone may also fit completely in the data cache, thus not exercising data cache miss performance. To counter fits-in-the-cache problem, the SPECint benchmark was created *in 1988* to include a suite of (initially 8) much larger programs (including a compiler) which could not fit into L1 or L2 caches *of that era*.
  * Dhrystone numbers actually reflect the performance of the C compiler and libraries, probably more so than the performance of the processor itself
  * Dhrystone’s execution is largely spent in standard C library functions, such as strcmp(),strcpy(), and memcpy(). Compiler vendors generally provide these libraries that are typically optimized and hand-written in assembly language. While you may think you are benchmarking a processor, you are really benchmarking are the compiler writer’s optimizations of the C library functions for a particular platform

Maybe even more concerning is [the completely flawed way those scores are generated in the wild](https://www.brendangregg.com/blog/2014-05-02/compilers-love-messing-with-benchmarks.html). And of course the results you find somewhere on the net usually lack all the important info (like which OS, which libs and which compiler with which flags has been used).

Using the `dhrystonePi64` binary (Dhrystone Benchmark, Version 2.1, Language: C or C++)' from [http://www.roylongbottom.org.uk/dhrystone%20results.htm](http://www.roylongbottom.org.uk/dhrystone%20results.htm) on a RK3588 device with four A76 CPU cores combined with four A55 while switching the memory clockspeed between 2112 (`performance` DMC governor) and 528 MHz (`powersave` DMC governor) we get these results:

| Dhrystone 2.1 result | A76 / 2112 MHz | A76 / 528 MHz | A55 / 2112 MHz | A55 / 528 MHz |
| ----: | :----: | :----: | :----: | :----: |
| Nanoseconds one Dhrystone run | 30.43 | 30.85 | 90.96 | 90.84 |
| Dhrystones per Second | 32860262 | 32415115 | 10994401 | 11008762 |
| VAX MIPS rating | 18702.48 | 18449.13 | 6257.49 | 6265.66 |

As can be seen memory clock doesn't matter at all since Dhrystone was already critized decades ago for its small working set fitting completely into CPU caches of *that* era.

When limiting the A76 CPU cores to the same 1.8 GHz the A55 are clocked with we get this result and as such a DMIPS/MHz comparison ratio:

    Nanoseconds one Dhrystone run:        39.15
    Dhrystones per Second:             25542413
    VAX MIPS rating =                  14537.51

The VAX MIPS ratings generated with same `dhrystone` binary suggest the A76 being 2.32 faster than an A55 at same clockspeed (14540 / 6260 = 2.32). Interesting since places like Wikipedia tell us A76 would be 3.5 – 4.1 times faster than the A55 of this popular [DynamIQ](https://en.wikipedia.org/wiki/ARM_big.LITTLE#DynamIQ) pairing (see table below). What went wrong at Wikipedia? Maybe ignoring Dhrystone being more a compiler than a hardware benchmark in the 'fire and forget' mode it's always used? 

One of the few examples of using Dhrystone in a non flawed way ([same Dhrystone binary as such same compiler version and same compiler flags and on the same OS image as such same libraries](https://www.cnx-software.com/2021/12/10/starfive-dubhe-64-bit-risc-v-core-12nm-2-ghz-processors/#comment-588823)) it looks like this with few different ARMv8 Cortex cores:

  * A35 – 1.7 DMIPS/MHz
  * A53 – 2.2 DMIPS/MHz
  * A57 – 4.1 DMIPS/MHz
  * A72 – 4.5 DMIPS/MHz
  * A73 – 4.8 DMIPS/MHz
  * A75 – 6.1 DMIPS/MHz
  * A77 – 7.3 DMIPS/MHz

But of course you also find totally different numbers all over the web, for example at [Wikipedia](https://www.wikiwand.com/en/List_of_ARM_processors),  [Baselabs](https://www.baselabs.de/sensor-fusion/a-sensor-fusion-benchmark-of-arm-cpus/) and even two differing DMIPS/MHz listings at [bluelucky](https://www.cnblogs.com/cjchang/p/12187518.html).

| ARM Core | [Measured](https://www.cnx-software.com/2021/12/10/starfive-dubhe-64-bit-risc-v-core-12nm-2-ghz-processors/#comment-588823) | [Wikipedia](https://www.wikiwand.com/en/List_of_ARM_processors) | [Baselabs](https://www.baselabs.de/sensor-fusion/a-sensor-fusion-benchmark-of-arm-cpus/) | [bluelucky 1](https://www.cnblogs.com/cjchang/p/12187518.html) | [bluelucky 2](https://www.cnblogs.com/cjchang/p/12187518.html) |
| ----: | :----:  | :----: | :----: | :----: | :----: |
| A5  |     | 1.57 |    |     |     |
| A7  |     | 1.9 |     | 1.9 | 1.9 |
| A8  |     | 2.0 |     | 2.0 | 2.0 |
| A9  |     | 2.5 |     | 2.0 | 2.5 |
| A15  |     | 3.5 |     | 4.0 | 3.4 |
| A17  |     | 2.8 |     | 4.0 | 3.2 |
| A32  |     |     |     | 2.3 | 2.3 |
| A35 | **1.7** | 1.78 |     | 2.5 | 2.5 | 
| A53 | **2.2** | 2.3  | 2.3 | 2.3 | 2.3 |
| A55 |     |  3   |  3  | 2.3 | 2.7 |
| A57 | **4.1** | 4.1 – 4.8 |    | 4.6 | 4.1 |
| A72 | **4.5** | 6.3 – 7.3 | 7.4 | 5.4 | 4.7 | 
| A73 | **4.8** | 7.4 – 8.5 |     | 7.0 | 4.8 |
| A75 | **6.1** | 8.2 – 9.5 |    | 7.0 | 5.2 |
| A76 |     | 10.7 – 12.4 | 12  |     |     |
| A77 | **7.3** | 13 – 16 |     |     |     |     |

The correctly measured Dhrystone MIPS/MHz score suggests [Cortex-A72](https://en.wikipedia.org/wiki/ARM_Cortex-A72) (an [out-of-order](https://en.wikipedia.org/wiki/Out-of-order_execution) 
*big* core) being more than twice as fast as the corresponding [Cortex-A53](https://en.wikipedia.org/wiki/ARM_Cortex-A53) (an in-order *little* core meant to be combined with A72/A73 for [big.LITTLE](https://en.wikipedia.org/wiki/ARM_big.LITTLE) hybrid CPU designs). But when trusting into Wikipedia A72 is almost 3 times faster. And with the Cortex-A77 for example it gets even more weird since Wikipedia numbers and correctly determined differ even more.

## Blender

Blender is a popular open source render engine/tool that got an own benchmark mode/tool [few years ago](https://www.blender.org/news/introducing-blender-benchmark/). Since I was interested in Apple's raytracing functionality introduced with their M3 SoCs ([this little patch does the magic from version 4.0.0 on](https://projects.blender.org/blender/blender/commit/705c0733c67b2a707affaa3faa9289210167ba8e)) I compared 4.0.0 with 3.6.0 scores:

| GPU | 4.0.0 score | 3.6.0 score | difference |
| ----: | ----: | ----: | ----: |
| Apple M3 Max (GPU - 40 cores) | 3417.29 | 3014.83 | 113.3% |
| Apple M3 Pro (GPU - 18 cores) | 1510.37 | 1314.46 | 114.9% |

So 'hardware raytracing' makes up for a less than 15% performance improvement? Let's have a closer look whether benchmark scores done with different versions can be compared in the first place...

Grabbing data from [https://opendata.blender.org/](https://opendata.blender.org/) on 22th Nov 2023 and filtering out all devices with less than 4 scores (52 GPU models remaining) we see a 'drop in performance' with 46 of them compared to the older 3.6.0 version. Especially Nvidia GPUs are affected (RTX 4060 Ti being the 'worst') and Apple's SoCs as such we can assume that the benefit of having HW accelerated raytracing on the M3 SoCs accounts for a performance improvement in Blender more close to 20%.

<details>
  <summary>Comparing 4.0.0 with 3.6.0 in detail</summary>

    grep "^\"" Blender-4.0.0.csv | while read ; do
    Device="$(awk -F'"' '{print $2}' <<<"${REPLY}")"
    Score4="$(awk -F'"' '{print $4}' <<<"${REPLY}")"
    Score3="$(grep "\"${Device}\"" Blender-3.6.0.csv | awk -F'"' '{print $4}')"
    Diff="$(awk '{printf ("%0.1f",100*$1/$2); }' <<<"${Score4} ${Score3}")"
    echo -e "| ${Device} | ${Score4} | ${Score3} | ${Diff}% |"
    done | sort -t '|' -k 5 -n

| GPU | 4.0.0 score | 3.6.0 score | difference |
| ----: | ----: | ----: | ----: |
| NVIDIA GeForce RTX 4060 Ti | 3451.59 | 4306.28 | 80.2% |
| NVIDIA GeForce RTX 2060 | 1541.86 | 1851.51 | 83.3% |
| NVIDIA GeForce RTX 2070 | 2074.64 | 2441.76 | 85.0% |
| NVIDIA GeForce RTX 4090 | 11337.02 | 13093.11 | 86.6% |
| NVIDIA GeForce RTX 3080 Ti | 5253.9 | 6055.71 | 86.8% |
| NVIDIA GeForce RTX 3070 Ti | 3557.07 | 4092.95 | 86.9% |
| NVIDIA GeForce RTX 4060 | 3056.69 | 3482.13 | 87.8% |
| NVIDIA GeForce RTX 3080 | 4605.96 | 5227.13 | 88.1% |
| NVIDIA GeForce RTX 3070 | 3268.63 | 3704.15 | 88.2% |
| NVIDIA GeForce GTX 1660 Ti | 753.36 | 851.8 | 88.4% |
| NVIDIA GeForce RTX 2060 SUPER | 2167.41 | 2449.2 | 88.5% |
| NVIDIA GeForce RTX 3060 Ti | 2835.63 | 3195.27 | 88.7% |
| NVIDIA GeForce RTX 4080 Laptop GPU | 5650.66 | 6371.23 | 88.7% |
| NVIDIA GeForce RTX 3060 | 2246.81 | 2531.17 | 88.8% |
| NVIDIA GeForce RTX 4070 Ti | 6514.48 | 7290.21 | 89.4% |
| NVIDIA GeForce RTX 4080 | 8558.09 | 9575.48 | 89.4% |
| NVIDIA GeForce RTX 3090 | 5651.84 | 6289.07 | 89.9% |
| NVIDIA GeForce RTX 2080 SUPER | 2357.52 | 2617.67 | 90.1% |
| NVIDIA GeForce RTX 4090 Laptop GPU | 7388.08 | 8203.46 | 90.1% |
| NVIDIA GeForce GTX 1660 SUPER | 749.46 | 830.35 | 90.3% |
| NVIDIA GeForce RTX 4050 Laptop GPU | 2610.53 | 2889.12 | 90.4% |
| NVIDIA GeForce RTX 3050 Laptop GPU | 1212.3 | 1340.07 | 90.5% |
| NVIDIA GeForce RTX 3060 Laptop GPU | 2390.45 | 2617.27 | 91.3% |
| NVIDIA GeForce RTX 4060 Laptop GPU | 3351.88 | 3645.67 | 91.9% |
| NVIDIA GeForce RTX 4070 Laptop GPU | 3674.3 | 3999.65 | 91.9% |
| Apple M2 Max (GPU - 38 cores) | 1765.03 | 1914.88 | 92.2% |
| NVIDIA GeForce GTX 1070 | 528.56 | 573.36 | 92.2% |
| NVIDIA GeForce RTX 2070 SUPER | 2398.9 | 2602.16 | 92.2% |
| NVIDIA GeForce RTX 2080 Ti | 3075.79 | 3333.86 | 92.3% |
| NVIDIA GeForce RTX 4070 | 5581.39 | 6028.95 | 92.6% |
| Apple M1 Max (GPU - 32 cores) | 933.21 | 1006.63 | 92.7% |
| NVIDIA GeForce GTX 1080 Ti | 829.75 | 894.47 | 92.8% |
| AMD Radeon RX 6800 | 1793.94 | 1929.72 | 93.0% |
| NVIDIA GeForce RTX 3070 Ti Laptop GPU | 3071.26 | 3287.45 | 93.4% |
| AMD Radeon RX 7800 XT | 2270 | 2427.85 | 93.5% |
| Apple M2 Max (GPU - 30 cores) | 1451.12 | 1550.73 | 93.6% |
| Apple M1 (GPU - 8 cores) | 249.92 | 265.98 | 94.0% |
| Apple M2 Ultra (GPU - 76 cores) | 3214.87 | 3420.98 | 94.0% |
| Intel Arc A770 Graphics | 1980.98 | 2106.39 | 94.0% |
| AMD Radeon RX 6700 XT | 1490.09 | 1566.79 | 95.1% |
| Apple M1 Pro (GPU - 16 cores) | 469.32 | 487.02 | 96.4% |
| Apple M1 Max (GPU - 24 cores) | 774.97 | 796.77 | 97.3% |
| AMD Radeon RX 7900 XTX | 3958.38 | 3980.96 | 99.4% |
| AMD Radeon RX 6900 XT | 2597.21 | 2611.39 | 99.5% |
| NVIDIA RTX A4000 | 3397.06 | 3408.64 | 99.7% |
| AMD Radeon RX 6800 XT | 2432.05 | 2437.77 | 99.8% |
| Intel Arc A750 Graphics | 2058.68 | 2054.02 | 100.2% |
| NVIDIA GeForce RTX 3070 Laptop GPU | 3171.62 | 3161.06 | 100.3% |
| AMD Radeon RX 6950 XT | 2776.02 | 2751.71 | 100.9% |
| AMD Radeon RX 6700 | 1404.47 | 1347.65 | 104.2% |
| Apple M3 Max (GPU - 40 cores) | 3417.29 | 3014.83 | 113.3% |
| Apple M3 Pro (GPU - 18 cores) | 1510.37 | 1314.46 | 114.9% |
</details>

Does this only affect 3.6.0 vs. 4.0.0 so that we at least can rely on Blender 3.x scores to be comparable? Nope, there it's even worse. 3.6.0 vs. 3.0.1 ends up with some GPUs becoming 'three to four times faster'.

<details>
  <summary>Comparing 3.6.0 with 3.0.1 in detail</summary>

    grep "^\"" Blender-3.6.0.csv | while read ; do
    Device="$(awk -F'"' '{print $2}' <<<"${REPLY}")"
    Score4="$(awk -F'"' '{print $4}' <<<"${REPLY}")"
    Score3="$(grep "\"${Device}\"" Blender-3.0.1.csv | awk -F'"' '{print $4}')"
    Diff="$(awk '{printf ("%0.1f",100*$1/$2); }' <<<"${Score4} ${Score3}")"
    echo -e "| ${Device} | ${Score4} | ${Score3} | ${Diff}% |"
    done | sort -t '|' -k 5 -n

| GPU | 3.6.0 score | 3.0.1 score | difference |
| ----: | ----: | ----: | ----: |
| NVIDIA GeForce GTX 660 | 124.11 | 150.92 | 82.2% |
| NVIDIA GeForce GTX 1060 6GB | 390.68 | 443.65 | 88.1% |
| NVIDIA GeForce GTX 1050 | 185.12 | 208.68 | 88.7% |
| NVIDIA GeForce GTX 1070 | 573.36 | 624.6 | 91.8% |
| NVIDIA GeForce RTX 3070 Ti Laptop GPU | 3287.45 | 3495.73 | 94.0% |
| NVIDIA Quadro RTX 4000 | 2342.57 | 2485.81 | 94.2% |
| NVIDIA GeForce GTX 1650 | 480.56 | 505.67 | 95.0% |
| NVIDIA GeForce GTX 1050 Ti | 231.88 | 242.73 | 95.5% |
| NVIDIA GeForce GTX 1080 Ti | 894.47 | 935.9 | 95.6% |
| NVIDIA Quadro RTX 6000 | 3370.77 | 3521.78 | 95.7% |
| NVIDIA GeForce GTX 1080 | 621.83 | 643.01 | 96.7% |
| NVIDIA GeForce GTX 1660 Ti | 851.8 | 879.17 | 96.9% |
| NVIDIA GeForce GTX 1650 Ti | 518.39 | 533.94 | 97.1% |
| NVIDIA GeForce GTX 970 | 323.6 | 333.36 | 97.1% |
| NVIDIA GeForce GTX 1660 | 777.73 | 799.05 | 97.3% |
| NVIDIA GeForce RTX 3080 Laptop GPU | 3300.05 | 3378.88 | 97.7% |
| NVIDIA GeForce GTX 1660 SUPER | 830.35 | 849.14 | 97.8% |
| NVIDIA GeForce RTX 2060 SUPER | 2449.2 | 2487.79 | 98.4% |
| NVIDIA GeForce RTX 2070 with Max-Q Design | 2026.81 | 2055.26 | 98.6% |
| NVIDIA GeForce GTX 1060 | 380.67 | 385.74 | 98.7% |
| NVIDIA GeForce RTX 2080 Ti | 3333.86 | 3373.16 | 98.8% |
| NVIDIA GeForce RTX 3060 | 2531.17 | 2513.31 | 100.7% |
| NVIDIA GeForce RTX 3050 | 1659.88 | 1629.28 | 101.9% |
| NVIDIA GeForce RTX 2060 | 1851.51 | 1809.77 | 102.3% |
| NVIDIA GeForce RTX 2080 | 2549.7 | 2490.22 | 102.4% |
| NVIDIA GeForce RTX 3060 Ti | 3195.27 | 3120.36 | 102.4% |
| AMD Radeon RX 5700 XT | 955.06 | 932.15 | 102.5% |
| NVIDIA GeForce RTX 2080 SUPER | 2617.67 | 2535.25 | 103.3% |
| NVIDIA GeForce RTX 2070 SUPER | 2602.16 | 2505.17 | 103.9% |
| NVIDIA GeForce RTX 3080 | 5227.13 | 5029.25 | 103.9% |
| NVIDIA GeForce RTX 3070 Laptop GPU | 3161.06 | 3023.2 | 104.6% |
| NVIDIA GeForce RTX 3070 | 3704.15 | 3506.28 | 105.6% |
| NVIDIA RTX A6000 | 5785.7 | 5472.1 | 105.7% |
| NVIDIA GeForce RTX 3080 Ti | 6055.71 | 5711.42 | 106.0% |
| NVIDIA GeForce RTX 3070 Ti | 4092.95 | 3849.24 | 106.3% |
| NVIDIA GeForce RTX 2070 | 2441.76 | 2252.86 | 108.4% |
| NVIDIA GeForce RTX 3090 | 6289.07 | 5764.34 | 109.1% |
| NVIDIA GeForce RTX 3060 Laptop GPU | 2617.27 | 2372.01 | 110.3% |
| NVIDIA GeForce RTX 3050 Laptop GPU | 1340.07 | 1207.17 | 111.0% |
| AMD Radeon RX 6700 XT | 1566.79 | 1359.52 | 115.2% |
| AMD Radeon RX 6900 XT | 2611.39 | 2262.86 | 115.4% |
| AMD Radeon RX 6700S | 918.46 | 789.23 | 116.4% |
| NVIDIA GeForce RTX 3080 Ti Laptop GPU | 3978.32 | 3385.31 | 117.5% |
| AMD Radeon RX 5500 XT | 506.08 | 428.89 | 118.0% |
| AMD Radeon RX 6800 XT | 2437.77 | 2061.51 | 118.3% |
| AMD Radeon PRO W6800 | 1880.56 | 1584.62 | 118.7% |
| AMD Radeon RX 6600 XT | 1103.97 | 928.68 | 118.9% |
| AMD Radeon RX 6600 | 1011.36 | 850.45 | 118.9% |
| NVIDIA GeForce RTX 3050 Ti Laptop GPU | 1514.43 | 1253.98 | 120.8% |
| NVIDIA Tesla T4 | 1727.73 | 445.36 | 387.9% |
| NVIDIA RTX A2000 8GB Laptop GPU | 1473.89 | 375.63 | 392.4% |
</details>

As usual: scores generated with different software versions can't be compared!

## Geekbench 6

TBC

Multi score is a joke: https://github.com/geerlingguy/sbc-reviews/issues/52#issuecomment-2452250408

Cross-platform is a joke: https://github.com/geerlingguy/sbc-reviews/issues/47#issuecomment-2249701607