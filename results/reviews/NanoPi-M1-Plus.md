# FriendlyArm NanoPi M1 Plus

Tested on Mon, 13 Feb 2023 15:46:34 +0100. Full info: [http://ix.io/4nWb](http://ix.io/4nWb)

### General information:

    Allwinner H3, Kernel: armv7l, Userland: armhf
    
    CPU sysfs topology (clusters, cpufreq members, clockspeeds)
                     cpufreq   min    max
     CPU    cluster  policy   speed  speed   core type
      0        0        0      120    1368   Cortex-A7 / r0p5
      1        0        0      120    1368   Cortex-A7 / r0p5
      2        0        0      120    1368   Cortex-A7 / r0p5
      3        0        0      120    1368   Cortex-A7 / r0p5

### Governors/policies (performance vs. idle consumption):

Original governor settings:

    cpufreq-policy0: ondemand / 1200 MHz (conservative userspace powersave ondemand performance schedutil)

Tuned governor settings:

    cpufreq-policy0: performance / 1200 MHz

### Clockspeeds (idle vs. heated up):

Before at 43.6°C:

    cpu0 (Cortex-A7): OPP: 1368, Measured: 1365 

After at 74.9°C:

    cpu0 (Cortex-A7): OPP: 1368, Measured: 1365 

### Software versions:

  * Ubuntu 18.04.6 LTS
  * Build scripts: NanoPi M1 Plus, sun8i, sunxi, 5.65
  * Compiler: /usr/bin/gcc (Ubuntu/Linaro 7.5.0-3ubuntu1~18.04) 7.5.0 / arm-linux-gnueabihf
  * OpenSSL 1.1.1, built on 11 Sep 2018
  * Kernel 4.19.62-sunxi / CONFIG_HZ=250

Kernel 4.19.62 is not latest 4.19.271 LTS that was released on 2023-01-24.

Please check https://endoflife.date/linux for details. It is somewhat likely
that a lot of exploitable vulnerabilities exist for this kernel as well as
many unfixed bugs. Better upgrade to a supported version ASAP.