# Benchmarking some benchmarks

["Casual benchmarking: you benchmark A, but actually measure B, and conclude you've measured C."](https://www.brendangregg.com/activebenchmarking.html)

Let's look a bit closer at some popular passive benchmarks...

## Dhrystone / DMIPS / DMIPS/MHz

DMIPS are 'Dhrystone MIPS', the single-threaded score of the Dhrystone benchmark developed 1984 (four decades ago!) as an improvement over the older MIPS metric ('million instructions per second' which became kinda pointless back then with the 'RISC vs. CISC' battle).

Written in the programming languages popular back then (FORTRAN, PL/1, SAL, ALGOL 68, and Pascal) and suited for the single-core CPUs of that time (almost every modern MCU is outperforming now) Dhrystone results do not represent **anything** that runs on today's computers. DMIPS since decades are misleading for the following reasons ([quoted from Wikipedia](https://en.wikipedia.org/wiki/Dhrystone#Shortcomings) and an [ARM White Paper](https://wiki.cdot.senecacollege.ca/wiki/Dhrystone_howto)):

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