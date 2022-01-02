# Memory latency / bandwidth comparison:

Ian Morrison tested an AMD Mini PC ([Beelink SER3 equipped with Zen+ Ryzen 7 3750H](https://www.cnx-software.com/2021/10/21/beelink-ser3-review-a-good-amd-ryzen-7-mini-pc-after-tweaks/)) with a bunch of different memory configurations but otherwise exactly identical environment (Ubuntu 20.04.3 with 5.11.0-43-generic kernel).

Initial test focus was on [gaming performance](https://www.cnx-software.com/2021/12/29/os-and-memory-impact-on-mini-pc-gaming-performance/) where frame rates increased with higher memory bandwidth. 

### Testing as follows:

The following combinations of SO-DIMMs have been tested. To make results more comparable UEFI was configured to run all sticks with DDR4-2400/PC4-19200 timings and not the maximum they could do. Asides that no further dealing with subtimings happened, as such RAS/CAS delays should be module defaults:

  * 1 x 16GB CT16G4SFD8266.M16FRS: single channel, dual rank, 18-18-18-39
  * 2 x 8GB CT8G4SFS6266: dual channel, single rank, 18-18-18-39
  * 2 x 8GB F4-2400C16D-16GRS: dual channel, dual rank, 16-16-16-39
  * 2 x 32GB F4-3200C22D-64GRS: dual channel, dual rank, 17-17-17-39

| DIMM configuration | memcpy | memset | srr nhp | drr nhp | srr hp | drr hp | tinymembench | 
| ----- | ----: | ------: | ------: | -----: | -----: | ---: | --- |
| 16GB [single channel, dual rank](http://ix.io/3Kh8) | 8158.2 | 7734.0 | 106.2 | 120.3 | 98.3 | 110.9 | [details](http://ix.io/3Kwa) |
| 16GB [dual channel, single rank](http://ix.io/3Kh9) | 12444.5 | 8768.9 | 115.9 | 126.1 | 110.3 | 120.5 | [details](http://ix.io/3Kwb) |
| 16GB [dual channel, dual rank](http://ix.io/3Kha) | 13860.1 | 11844.9 | 115.9 | 126.1 | 107.4 | 117.8 | [details](http://ix.io/3Kwc) |
| 64GB [dual channel, dual rank](http://ix.io/3Khb) | 13707.2 | 11927.7 | 117.9 | 129.2 | 109.6 | 120.8 | [details](http://ix.io/3Kwd) |

Meaning of column titles as follows:

  * memcpy: standard memcopy bandwidth in MB/s
  * memset: standard memset bandwidth in MB/s
  * srr nhp: single random read [MADV_NOHUGEPAGE] in ns
  * drr nhp: dual random read [MADV_NOHUGEPAGE] in ns
  * srr hp: single random read [MADV_HUGEPAGE] in ns
  * drr hp: dual random read [MADV_HUGEPAGE] in ns

### Interpreting results

Wrt memory bandwidth (not so) surprisingly dual channel outperforms single channel and the same is true for dual rank vs. single rank. If it's about low latency that's a totally different story since the single DIMM (though dual-ranked) wins.

Unfortunately no single channel / single rank setup has been tested. And even more unfortunately no data points exist that show how memory latency might influence performance of different use cases than 'gaming'.

In other words: it would be great if additional testing using e.g. 7-zip's own benchmark could be done since this somehow represents 'server loads in general' and benefits more from lower latency than higher bandwidth. Ideally testing through these 3 scenarios again in DDR4-2400/PC4-19200 mode:

  * 1 x 8GB CT8G4SFS6266: single channel, single rank
  * 1 x 16GB CT16G4SFD8266.M16FRS: single channel, dual rank
  * 2 x 8GB F4-2400C16D-16GRS: dual channel, dual rank
