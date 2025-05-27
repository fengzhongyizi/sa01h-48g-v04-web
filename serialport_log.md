
正在打开串口...
鳧DR 2d653b3476 typ 24/01/20-15:04:19,fwver: v1.21
In
LP4/4x derate en, other dram:1x trefi
ddrconfig:0
LPDDR4, 324MHz
BW=32 Col=10 Bk=8 CS0 Row=15 CS=1 Die BW=16 Size=1024MB
tdqss: cs0 dqs0: 24ps, dqs1: -72ps, dqs2: -72ps, dqs3: -144ps, 

change to: 324MHz
PHY drv:clk:38,ca:38,DQ:30,odt:0
vrefinner:41%, vrefout:41%
dram drv:40,odt:0
clk skew:0x62
rx vref: 35.9%
tx vref: 38.0%

change to: 528MHz
PHY drv:clk:38,ca:38,DQ:30,odt:0
vrefinner:41%, vrefout:41%
dram drv:40,odt:0
clk skew:0x58
rx vref: 33.9%
tx vref: 38.0%

change to: 780MHz
PHY drv:clk:38,ca:38,DQ:30,odt:60
vrefinner:16%, vrefout:41%
dram drv:40,odt:0
clk skew:0x58
rx vref: 17.4%
tx vref: 38.0%

change to: 1560MHz(final freq)
PHY drv:clk:38,ca:38,DQ:30,odt:60
vrefinner:16%, vrefout:29%
dram drv:40,odt:80
vref_ca:00000068
clk skew:0x2b
rx vref: 17.4%
tx vref: 30.0%
cs 0:
the read training result:
DQS0:0x33, DQS1:0x2e, DQS2:0x33, DQS3:0x27, 
min  :0x13 0x15 0x18 0x14  0x1  0x8  0xb  0x7 , 0xb  0xb  0x4  0x2  0xb  0xa  0xb  0x9 ,
      0x18 0x16  0xe  0xb  0x5  0x2  0x2  0x7 , 0x9  0x7  0x5  0x2  0x9  0xb  0x5  0xe ,
mid  :0x2d 0x2d 0x31 0x2c 0x1c 0x22 0x25 0x21 ,0x24 0x24 0x1c 0x1a 0x24 0x22 0x23 0x22 ,
      0x32 0x31 0x28 0x26 0x1e 0x1a 0x1b 0x20 ,0x23 0x1f 0x1d 0x1a 0x23 0x24 0x1e 0x25 ,
max  :0x48 0x46 0x4a 0x45 0x37 0x3c 0x3f 0x3b ,0x3d 0x3d 0x34 0x33 0x3d 0x3a 0x3b 0x3b ,
      0x4c 0x4c 0x42 0x41 0x37 0x33 0x34 0x39 ,0x3d 0x38 0x36 0x33 0x3d 0x3e 0x37 0x3d ,
range:0x35 0x31 0x32 0x31 0x36 0x34 0x34 0x34 ,0x32 0x32 0x30 0x31 0x32 0x30 0x30 0x32 ,
      0x34 0x36 0x34 0x36 0x32 0x31 0x32 0x32 ,0x34 0x31 0x31 0x31 0x34 0x33 0x32 0x2f ,
the write training result:
DQS0:0x2f, DQS1:0x1d, DQS2:0x1d, DQS3:0xf, 
min  :0x6b 0x6e 0x70 0x6d 0x5e 0x61 0x65 0x63 0x60 ,0x58 0x56 0x4f 0x4e 0x5a 0x56 0x56 0x54 0x4f ,
      0x5c 0x5d 0x58 0x55 0x4d 0x4b 0x4c 0x4f 0x4f ,0x4f 0x4d 0x4b 0x45 0x50 0x50 0x4a 0x54 0x44 ,
mid  :0x86 0x88 0x8b 0x87 0x76 0x7a 0x7e 0x7c 0x78 ,0x6f 0x6d 0x66 0x65 0x71 0x6d 0x6d 0x6c 0x68 ,
      0x76 0x77 0x70 0x6d 0x65 0x61 0x62 0x67 0x67 ,0x68 0x64 0x63 0x5e 0x69 0x69 0x63 0x6d 0x5d ,
max  :0xa2 0xa2 0xa6 0xa2 0x8f 0x94 0x98 0x95 0x90 ,0x87 0x84 0x7d 0x7c 0x88 0x84 0x84 0x84 0x81 ,
      0x91 0x91 0x88 0x86 0x7d 0x78 0x79 0x80 0x7f ,0x82 0x7c 0x7b 0x78 0x83 0x83 0x7d 0x87 0x77 ,
range:0x37 0x34 0x36 0x35 0x31 0x33 0x33 0x32 0x30 ,0x2f 0x2e 0x2e 0x2e 0x2e 0x2e 0x2e 0x30 0x32 ,
      0x35 0x34 0x30 0x31 0x30 0x2d 0x2d 0x31 0x30 ,0x33 0x2f 0x30 0x33 0x33 0x33 0x33 0x33 0x33 ,
CA Training result:
cs:0 min  :0x59 0x4d 0x4b 0x3d 0x4b 0x39 0x50 ,0x5b 0x47 0x4c 0x3a 0x4b 0x38 0x50 ,
cs:0 mid  :0x8f 0x90 0x82 0x7f 0x81 0x7c 0x76 ,0x90 0x8a 0x81 0x7e 0x80 0x7e 0x75 ,
cs:0 max  :0xc5 0xd3 0xb9 0xc2 0xb8 0xc0 0x9d ,0xc5 0xce 0xb7 0xc2 0xb5 0xc4 0x9b ,
cs:0 range:0x6c 0x86 0x6e 0x85 0x6d 0x87 0x4d ,0x6a 0x87 0x6b 0x88 0x6a 0x8c 0x4b ,
out
U-Boot SPL board init
U-Boot SPL 2017.09-g606f72bd97a-240527 #lxh (May 30 2024 - 16:08:15), fwver: v1.14
unknown raw ID 0 0 0
unrecognized JEDEC id bytes: 00, 00, 00
Trying to boot from MMC2
MMC: no card present
mmc_init: -123, time 2
spl: mmc init failed with error: -123
Trying to boot from MMC1
No misc partition
Trying fit image at 0x2800 sector
## Verified-boot: 0
## Checking atf-1 0x00040000 (gzip @0x00240000) ... sha256(e0265af54b...) + sha256(b5946ac63d...) + OK
## Checking uboot 0x00a00000 (gzip @0x00c00000) ... sha256(f4a88a80a9...) + sha256(4296438453...) + OK
## Checking fdt 0x00b50cf0 ... sha256(a474c6bb61...) + OK
## Checking atf-2 0xfdcc1000 ... sha256(b8dca786b4...) + OK
## Checking atf-3 0x0006b000 ... sha256(2f91089eb7...) + OK
## Checking atf-4 0xfdcce000 ... sha256(86ef885748...) + OK
## Checking atf-5 0xfdcd0000 ... sha256(0b2b146c60...) + OK
## Checking atf-6 0x00069000 ... sha256(a9a1e63bef...) + OK
## Checking optee 0x08400000 (gzip @0x08600000) ... sha256(2974a95b61...) + sha256(28fba8b7d7...) + OK
Jumping to U-Boot(0x00a00000) via ARM Trusted Firmware(0x00040000)
Total: 270.935/609.381 ms

INFO:    Preloader serial: 2
NOTICE:  BL31: v2.3():v2.3-645-g8cea6ab0b:cl, fwver: v1.44
NOTICE:  BL31: Built : 16:36:43, Sep 19 2023
INFO:    GICv3 without legacy support detected.
INFO:    ARM GICv3 driver initialized in EL3
INFO:    pmu v1 is valid 220114
INFO:    l3 cache partition cfg-0
INFO:    dfs DDR fsp_param[0].freq_mhz= 1560MHz
INFO:    dfs DDR fsp_param[1].freq_mhz= 324MHz
INFO:    dfs DDR fsp_param[2].freq_mhz= 528MHz
INFO:    dfs DDR fsp_param[3].freq_mhz= 780MHz
INFO:    Using opteed sec cpu_context!
INFO:    boot cpu mask: 0
INFO:    BL31: Initializing runtime services
INFO:    BL31: Initializing BL32
I/TC: 
I/TC: OP-TEE version: 3.13.0-791-g185dc3c92 #hisping.lin (gcc version 10.2.1 20201103 (GNU Toolchain for the A-profile Architecture 10.2-2020.11 (arm-10.16))) #2 Tue Apr 16 10:47:32 CST 2024 aarch64, fwver: v2.12 
I/TC: OP-TEE memory: TEEOS 0x200000 TA 0xc00000 SHM 0x200000
I/TC: Primary CPU initializing
I/TC: CRYPTO_CRYPTO_VERSION_NEW no support. Skip all algo mode check.
I/TC: Primary CPU switching to normal world boot
INFO:    BL31: Preparing for EL3 exit to normal world
INFO:    Entry point address = 0xa00000
INFO:    SPSR = 0x3c9
usb dr_mode not found
usb dr_mode not found


U-Boot 2017.09 (May 19 2025 - 20:04:31 +0800)

Model: Rockchip RK3568 Evaluation Board
MPIDR: 0x0
PreSerial: 2, raw, 0xfe660000
DRAM:  1006 MiB
Sysmem: init
Relocation Offset: 3d20e000
Relocation fdt: 3b9f89c8 - 3b9fecd8
CR: M/C/I
usb dr_mode not found
usb dr_mode not found
Using default environment

optee api revision: 2.0
dwmmc@fe2b0000: 1, dwmmc@fe2c0000: 2, sdhci@fe310000: 0
MMC: no card present
mmc_init: -123, time 2
switch to partitions #0, OK
mmc0(part 0) is current device
Bootdev(scan): mmc 0
MMC0: HS200, 200Mhz
PartType: EFI
TEEC: Waring: Could not find security partition
DM: v1
No misc partition
boot mode: None
RESC: 'boot', blk@0x000162db
resource: sha256+
FIT: no signed, no conf required
DTB: rk-kernel.dtb
HASH(c): OK
usb dr_mode not found
I2c0 speed: 100000Hz
PMIC:  RK8090 (on=0x40, off=0x00)
vdd_logic init 900000 uV
vdd_gpu init 900000 uV
vdd_npu init 900000 uV
io-domain: OK
INFO:    ddr dmc_fsp already initialized in loader.
Could not find baseparameter partition
Model: SG01H-48G-V04
Rockchip UBOOT DRM driver version: v1.0.1
Assign plane mask automatically
VOP have 2 active VP
vp0 have layer nr:0[], primary plane: 0
vp1 have layer nr:3[0 2 4 ], primary plane: 4
vp2 have layer nr:3[1 3 5 ], primary plane: 5
Using display timing dts
dsi@fe070000:  detailed mode clock 140000 kHz, flags[a]
    H: 1200 1225 1235 1260
    V: 1920 1934 1936 1946
bus_format: 100e
VOP update mode to: 1200x1920p57, type: MIPI1 for VP1
VP1 set crtc_clock to 140000KHz
Unsupported bt709f at 10bit csc depth, use bt601f instead
VOP VP1 enable Smart0[270x654->270x654@465x633] fmt[0] addr[0x3df00000]
final DSI-Link bandwidth: 930 Mbps x 4
CLK: (sync kernel. arm: enter 816000 KHz, init 816000 KHz, kernel 0N/A)
  apll 1104000 KHz
  dpll 780000 KHz
  gpll 1188000 KHz
  cpll 1000000 KHz
  npll 1200000 KHz
  vpll 840000 KHz
  hpll 24000 KHz
  ppll 200000 KHz
  armclk 1104000 KHz
  aclk_bus 150000 KHz
  pclk_bus 100000 KHz
  aclk_top_high 500000 KHz
  aclk_top_low 400000 KHz
  hclk_top 150000 KHz
  pclk_top 100000 KHz
  aclk_perimid 300000 KHz
  hclk_perimid 150000 KHz
  pclk_pmu 100000 KHz
Net:   eth0: ethernet@fe2a0000
Hit key to stop autoboot('CTRL+C'):  0 
Could not find misc partition
ANDROID: reboot reason: "(none)"
Not AVB images, AVB skip
No valid android hdr
Android image load failed
Android boot failed, error -1.
## Booting FIT Image at 0x3949c380 with size 0x0235b600
Fdt Ramdisk skip relocation
No misc partition
## Loading kernel from FIT Image at 3949c380 ...
   Using 'conf' configuration
## Verified-boot: 0
   Trying 'kernel' kernel subimage
     Description:  unavailable
     Type:         Kernel Image
     Compression:  uncompressed
     Data Start:   0x394c5f80
     Data Size:    36903424 Bytes = 35.2 MiB
     Architecture: AArch64
     OS:           Linux
     Load Address: 0x00280000
     Entry Point:  0x00280000
     Hash algo:    sha256
     Hash value:   5b8c96616bece0393a31b3a4dd8444af23e7705c45af858b3b77b339e9c692d5
   Verifying Hash Integrity ... sha256+ OK
## Loading fdt from FIT Image at 3949c380 ...
   Using 'conf' configuration
   Trying 'fdt' fdt subimage
     Description:  unavailable
     Type:         Flat Device Tree
     Compression:  uncompressed
     Data Start:   0x3949cb80
     Data Size:    168625 Bytes = 164.7 KiB
     Architecture: AArch64
     Load Address: 0x08300000
     Hash algo:    sha256
     Hash value:   079bd1ee6cd3e81b4bb35f1f9780c7e1125ec4a950a8c447c90e391e9ebd8fb4
   Verifying Hash Integrity ... sha256+ OK
   Loading fdt from 0x08300000 to 0x08300000
   Booting using the fdt blob at 0x08300000
   Loading Kernel Image from 0x394c5f80 to 0x00280000 ... OK
   kernel loaded at 0x00280000, end = 0x025b1a00
   Using Device Tree in place at 0000000008300000, end 000000000832c2b0
vp0, plane_mask:0x0, primary-id:0, curser-id:-1
vp1, plane_mask:0x15, primary-id:4, curser-id:-1
vp2, plane_mask:0x2a, primary-id:5, curser-id:-1
## reserved-memory:
  drm-logo@00000000: addr=3df00000 size=15a000
  drm-cubic-lut@00000000: addr=3ff00000 size=8000
  ramoops@110000: addr=110000 size=f0000
Adding bank: 0x00200000 - 0x08400000 (size: 0x08200000)
Adding bank: 0x09400000 - 0x40000000 (size: 0x36c00000)
board seed: Pseudo
No RNG device, ret=-12
No RNG device, ret=-12
No RNG device, ret=-12
No RNG device, ret=-12
No RNG device, ret=-12
No RNG device, ret=-12
No RNG device, ret=-12
No RNG device, ret=-12
No RNG device, ret=-12
No RNG device, ret=-12
No RNG device, ret=-12
No RNG device, ret=-12
No RNG device, ret=-12
No RNG device, ret=-12
No RNG device, ret=-12
No RNG device, ret=-12
No RNG device, ret=-12
No RNG device, ret=-12
No RNG device, ret=-12
No RNG device, ret=-12
No RNG device, ret=-12
No RNG device, ret=-12
No RNG device, ret=-12
No RNG device, ret=-12
No RNG device, ret=-12
No RNG device, ret=-12
No RNG device, ret=-12
No RNG device, ret=-12
No RNG device, ret=-12
No RNG device, ret=-12
No RNG device, ret=-12
No RNG device, ret=-12
== DO RELOCATE == Kernel from 0x00280000 to 0x00200000
Total: 1959.421/2093.201 ms

Starting kernel ...

[    2.102754] Booting Linux on physical CPU 0x0000000000 [0x412fd050]
[    2.102779] Linux version 5.10.209 (root@LAPTOP-2R8LSL8J) (aarch64-none-linux-gnu-gcc (GNU Toolchain for the A-profile Architecture 10.3-2021.07 (arm-10.29)) 10.3.1 20210621, GNU ld (GNU Toolchain for the A-profile Architecture 10.3-2021.07 (arm-10.29)) 2.36.1.20210621) #3 SMP Thu Apr 17 15:20:19 CST 2025
[    2.105009] random: crng init done
[    2.109923] Machine model: SG01H-48G-V04
[    2.151605] earlycon: uart8250 at MMIO32 0x00000000fe660000 (options '')
[    2.203497] printk: bootconsole [uart8250] enabled
[    2.210173] efi: UEFI not found.
[    2.242001] Zone ranges:
[    2.244785]   DMA      [mem 0x0000000000200000-0x000000003fffffff]
[    2.251565]   DMA32    empty
[    2.254718]   Normal   empty
[    2.257870] Movable zone start for each node
[    2.262546] Early memory node ranges
[    2.266459]   node   0: [mem 0x0000000000200000-0x00000000083fffff]
[    2.273330]   node   0: [mem 0x0000000009400000-0x000000003fffffff]
[    2.280201] Initmem setup node 0 [mem 0x0000000000200000-0x000000003fffffff]
[    2.293891] cma: Reserved 16 MiB at 0x000000003cc00000
[    2.299604] psci: probing for conduit method from DT.
[    2.305148] psci: PSCIv1.1 detected in firmware.
[    2.310206] psci: Using standard PSCI v0.2 function IDs
[    2.315936] psci: Trusted OS migration not required
[    2.321281] psci: SMC Calling Convention v1.2
[    2.326417] percpu: Embedded 30 pages/cpu s83800 r8192 d30888 u122880
[    2.333611] Detected VIPT I-cache on CPU0
[    2.338044] CPU features: detected: GIC system register CPU interface
[    2.345104] CPU features: detected: Virtualization Host Extensions
[    2.351884] CPU features: detected: ARM errata 1165522, 1319367, or 1530923
[    2.359539] alternatives: patching kernel code
[    2.366320] Built 1 zonelists, mobility grouping on.  Total pages: 253448
[    2.373767] Kernel command line: storagemedia=emmc androidboot.storagemedia=emmc androidboot.mode=normal  androidboot.verifiedbootstate=orange rw rootwait earlycon=uart8250,mmio32,0xfe660000 console=ttyFIQ0 root=PARTUUID=614e0000-0000 androidboot.fwver=ddr-v1.21-2d653b3476,spl-v1.14,bl31-v1.44,bl32-v2.12,uboot-05/19/2025
[    2.405470] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes, linear)
[    2.414185] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes, linear)
[    2.422487] mem auto-init: stack:off, heap alloc:off, heap free:off
[    2.442103] Memory: 954296K/1030144K available (18752K kernel code, 3526K rwdata, 6928K rodata, 6720K init, 592K bss, 59464K reserved, 16384K cma-reserved)
[    2.457496] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    2.464688] ftrace: allocating 57302 entries in 224 pages
[    2.553903] ftrace: allocated 224 pages with 3 groups
[    2.559767] rcu: Hierarchical RCU implementation.
[    2.564928] rcu: 	RCU event tracing is enabled.
[    2.569891] rcu: 	RCU dyntick-idle grace-period acceleration is enabled.
[    2.577237] rcu: 	RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=4.
[    2.584393] 	Rude variant of Tasks RCU enabled.
[    2.589356] rcu: RCU calculated value of scheduler-enlistment delay is 30 jiffies.
[    2.597655] rcu: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    2.609681] NR_IRQS: 64, nr_irqs: 64, preallocated irqs: 0
[    2.617530] GICv3: GIC: Using split EOI/Deactivate mode
[    2.623265] GICv3: 320 SPIs implemented
[    2.627466] GICv3: 0 Extended SPIs implemented
[    2.632365] GICv3: Distributor has no Range Selector support
[    2.638575] GICv3: 16 PPIs implemented
[    2.643080] GICv3: CPU0: found redistributor 0 region 0:0x00000000fd460000
[    2.650741] ITS [mem 0xfd440000-0xfd45ffff]
[    2.655386] ITS@0x00000000fd440000: allocated 8192 Devices @29d0000 (indirect, esz 8, psz 64K, shr 0)
[    2.665531] ITS@0x00000000fd440000: allocated 32768 Interrupt Collections @29e0000 (flat, esz 2, psz 64K, shr 0)
[    2.676694] ITS: using cache flushing for cmd queue
[    2.682378] GICv3: using LPI property table @0x00000000029f0000
[    2.688979] GIC: using cache flushing for LPI property table
[    2.695186] GICv3: CPU0: using allocated LPI pending table @0x0000000002a00000
[    2.703174] rcu: 	Offload RCU callbacks from CPUs: (none).
[    2.741089] arch_timer: cp15 timer(s) running at 24.00MHz (phys).
[    2.747784] clocksource: arch_sys_counter: mask: 0xffffffffffffff max_cycles: 0x588fe9dc0, max_idle_ns: 440795202592 ns
[    2.759619] sched_clock: 56 bits at 24MHz, resolution 41ns, wraps every 4398046511097ns
[    2.769551] Console: colour dummy device 80x25
[    2.774469] Calibrating delay loop (skipped), value calculated using timer frequency.. 48.00 BogoMIPS (lpj=80000)
[    2.785747] pid_max: default: 32768 minimum: 301
[    2.790941] Mount-cache hash table entries: 2048 (order: 2, 16384 bytes, linear)
[    2.799072] Mountpoint-cache hash table entries: 2048 (order: 2, 16384 bytes, linear)
[    2.809059] rcu: Hierarchical SRCU implementation.
[    2.815059] Platform MSI: interrupt-controller@fd440000 domain created
[    2.822653] PCI/MSI: /interrupt-controller@fd400000/interrupt-controller@fd440000 domain created
[    2.832640] EFI services will not be available.
[    2.837920] smp: Bringing up secondary CPUs ...
I/TC: Secondary CPU 1 initializing
I/TC: Secondary CPU 1 switching to normal world boot
I/TC: Secondary CPU 2 initializing
I/TC: Secondary CPU 2 switching to normal world boot
I/TC: Secondary CPU 3 initializing
I/TC: Secondary CPU 3 switching to normal world boot
[    2.851236] Detected VIPT I-cache on CPU1
[    2.851270] GICv3: CPU1: found redistributor 100 region 0:0x00000000fd480000
[    2.851288] GICv3: CPU1: using allocated LPI pending table @0x0000000002a10000
[    2.851341] CPU1: Booted secondary processor 0x0000000100 [0x412fd050]
[    2.859722] Detected VIPT I-cache on CPU2
[    2.859749] GICv3: CPU2: found redistributor 200 region 0:0x00000000fd4a0000
[    2.859764] GICv3: CPU2: using allocated LPI pending table @0x0000000002a20000
[    2.859804] CPU2: Booted secondary processor 0x0000000200 [0x412fd050]
[    2.868150] Detected VIPT I-cache on CPU3
[    2.868175] GICv3: CPU3: found redistributor 300 region 0:0x00000000fd4c0000
[    2.868191] GICv3: CPU3: using allocated LPI pending table @0x0000000002a30000
[    2.868227] CPU3: Booted secondary processor 0x0000000300 [0x412fd050]
[    2.868328] smp: Brought up 1 node, 4 CPUs
[    2.954448] SMP: Total of 4 processors activated.
[    2.959611] CPU features: detected: Privileged Access Never
[    2.965725] CPU features: detected: LSE atomic instructions
[    2.971840] CPU features: detected: User Access Override
[    2.977669] CPU features: detected: 32-bit EL0 Support
[    2.983307] CPU features: detected: Common not Private translations
[    2.990185] CPU features: detected: RAS Extension Support
[    2.996109] CPU features: detected: Data cache clean to the PoU not required for I/D coherence
[    3.005561] CPU features: detected: CRC32 instructions
[    3.011198] CPU features: detected: Speculative Store Bypassing Safe (SSBS)
[    3.018839] CPU features: detected: RCpc load-acquire (LDAPR)
[    3.054548] CPU: All CPU(s) started at EL2
[    3.060476] devtmpfs: initialized
[    3.086394] Registered cp15_barrier emulation handler
[    3.091974] Registered setend emulation handler
[    3.097138] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 6370867519511994 ns
[    3.107847] futex hash table entries: 1024 (order: 4, 65536 bytes, linear)
[    3.115934] pinctrl core: initialized pinctrl subsystem
[    3.122257] DMI not present or invalid.
[    3.126756] NET: Registered protocol family 16
[    3.133308] DMA: preallocated 128 KiB GFP_KERNEL pool for atomic allocations
[    3.141184] DMA: preallocated 128 KiB GFP_KERNEL|GFP_DMA pool for atomic allocations
[    3.152146] Registered FIQ tty driver
[    3.156574] thermal_sys: Registered thermal governor 'fair_share'
[    3.156580] thermal_sys: Registered thermal governor 'step_wise'
[    3.163275] thermal_sys: Registered thermal governor 'user_space'
[    3.169868] thermal_sys: Registered thermal governor 'power_allocator'
[    3.176820] thermal thermal_zone1: power_allocator: sustainable_power will be estimated
[    3.192842] cpuidle: using governor menu
[    3.197416] hw-breakpoint: found 6 breakpoint and 4 watchpoint registers.
[    3.204992] ASID allocator initialised with 65536 entries
[    3.213285] ramoops: dmesg-0	0x20000@0x0000000000110000
[    3.219060] ramoops: console	0x80000@0x0000000000130000
[    3.224812] ramoops: pmsg	0x50000@0x00000000001b0000
[    3.230648] printk: console [ramoops-1] enabled
[    3.235623] pstore: Registered ramoops as persistent store backend
[    3.242408] ramoops: using 0xf0000@0x110000, ecc: 0
[    3.279857] rockchip-gpio fdd60000.gpio0: probed /pinctrl/gpio0@fdd60000
[    3.287760] rockchip-gpio fe740000.gpio1: probed /pinctrl/gpio1@fe740000
[    3.295653] rockchip-gpio fe750000.gpio2: probed /pinctrl/gpio2@fe750000
[    3.303542] rockchip-gpio fe760000.gpio3: probed /pinctrl/gpio3@fe760000
[    3.311513] rockchip-gpio fe770000.gpio4: probed /pinctrl/gpio4@fe770000
[    3.318999] rockchip-pinctrl pinctrl: probed pinctrl
[    3.345312] fiq_debugger fiq_debugger.0: IRQ fiq not found
[    3.351406] fiq_debugger fiq_debugger.0: IRQ wakeup not found
[    3.357725] fiq_debugger_probe: could not install nmi irq handler
[[    3.364505] printk: console [ttyFIQ0] enabled
    3.364505] printk: console [ttyFIQ0] enabled
[    3.373635] printk: bootconsole [uart8250] disable[    3.373635] printk: bootconsole [uart8250] disabled
d
[    3.384017] Registered fiq debugger ttyFIQ0
[    3.384675] vcc3v3_sys: supplied by dc_12v
[    3.384975] vcc5v0_sys: supplied by dc_12v
[    3.385939] vcc3v3_pcie: supplied by dc_12v
[    3.386578] iommu: Default domain type: Translated 
[    3.387564] SCSI subsystem initialized
[    3.387800] usbcore: registered new interface driver usbfs
[    3.387853] usbcore: registered new interface driver hub
[    3.387892] usbcore: registered new device driver usb
[    3.387986] mc: Linux media interface: v0.10
[    3.388026] videodev: Linux video capture interface: v2.00
[    3.388111] pps_core: LinuxPPS API ver. 1 registered
[    3.388121] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    3.388140] PTP clock support registered
[    3.388187] EDAC MC: Ver: 3.0.0
[    3.388938] arm-scmi firmware:scmi: SCMI Notifications - Core Enabled.
[    3.389006] arm-scmi firmware:scmi: SCMI Protocol v2.0 'rockchip:' Firmware version 0x0
[    3.390687] Advanced Linux Sound Architecture Driver Initialized.
[    3.391121] Bluetooth: Core ver 2.22
[    3.391159] NET: Registered protocol family 31
[    3.391169] Bluetooth: HCI device and connection manager initialized
[    3.391184] Bluetooth: HCI socket layer initialized
[    3.391196] Bluetooth: L2CAP socket layer initialized
[    3.391216] Bluetooth: SCO socket layer initialized
[    3.391651] rockchip-cpuinfo cpuinfo: SoC		: 35682000
[    3.391665] rockchip-cpuinfo cpuinfo: Serial		: eab003f1cf6aacb4
[    3.392311] clocksource: Switched to clocksource arch_sys_counter
[    3.908300] NET: Registered protocol family 2
[    3.908451] IP idents hash table entries: 16384 (order: 5, 131072 bytes, linear)
[    3.909302] tcp_listen_portaddr_hash hash table entries: 512 (order: 1, 8192 bytes, linear)
[    3.909376] TCP established hash table entries: 8192 (order: 4, 65536 bytes, linear)
[    3.909437] TCP bind hash table entries: 8192 (order: 5, 131072 bytes, linear)
[    3.909540] TCP: Hash tables configured (established 8192 bind 8192)
[    3.909665] UDP hash table entries: 512 (order: 2, 16384 bytes, linear)
[    3.909692] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes, linear)
[    3.909828] NET: Registered protocol family 1
[    3.910281] RPC: Registered named UNIX socket transport module.
[    3.910293] RPC: Registered udp transport module.
[    3.910301] RPC: Registered tcp transport module.
[    3.910307] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    3.911206] PCI: CLS 0 bytes, default 64
[    3.913581] rockchip-thermal fe710000.tsadc: tsadc is probed successfully!
[    3.914565] hw perfevents: enabled with armv8_cortex_a55 PMU driver, 7 counters available
[    3.918668] Initialise system trusted keyrings
[    3.918826] workingset: timestamp_bits=62 max_order=18 bucket_order=0
[    3.923480] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    3.924060] NFS: Registering the id_resolver key type
[    3.924092] Key type id_resolver registered
[    3.924101] Key type id_legacy registered
[    3.924142] ntfs: driver 2.1.32 [Flags: R/O].
[    3.924364] jffs2: version 2.2. (NAND) 漏 2001-2006 Red Hat, Inc.
[    3.924646] fuse: init (API version 7.32)
[    3.924936] SGI XFS with security attributes, no debug enabled
[    3.964650] NET: Registered protocol family 38
[    3.964675] Key type asymmetric registered
[    3.964685] Asymmetric key parser 'x509' registered
[    3.964742] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 242)
[    3.964754] io scheduler mq-deadline registered
[    3.964762] io scheduler kyber registered
[    3.970097] rockchip-snps-pcie3-phy fe8c0000.phy: failed to find rockchip,pipe_grf regmap
[    3.972565] rk-pcie 3c0800000.pcie: invalid prsnt-gpios property in node
[    3.973044] pwm-backlight backlight1: supply power not found, using dummy regulator
[    3.973610] iep: Module initialized.
[    3.977758] dma-pl330 fe530000.dmac: Loaded driver for PL330 DMAC-241330
[    3.977781] dma-pl330 fe530000.dmac: 	DBUFF-128x8bytes Num_Chans-8 Num_Peri-32 Num_Events-16
[    3.979705] dma-pl330 fe550000.dmac: Loaded driver for PL330 DMAC-241330
[    3.979724] dma-pl330 fe550000.dmac: 	DBUFF-128x8bytes Num_Chans-8 Num_Peri-32 Num_Events-16
[    3.980360] rockchip-pvtm fde00000.pvtm: pvtm@0 probed
[    3.980489] rockchip-pvtm fde80000.pvtm: pvtm@1 probed
[    3.980607] rockchip-pvtm fde90000.pvtm: pvtm@2 probed
[    3.981083] rockchip-system-monitor rockchip-system-monitor: system monitor probe
[    3.981591] arm-scmi firmware:scmi: Failed. SCMI protocol 22 not active.
[    3.981742] snps pcie3phy FW update! size 8192
[    3.981875] Serial: 8250/16550 driver, 10 ports, IRQ sharing disabled
[    3.982814] fe670000.serial: ttyS3 at MMIO 0xfe670000 (irq = 44, base_baud = 1500000) is a 16550A
[    3.983582] fe680000.serial: ttyS4 at MMIO 0xfe680000 (irq = 45, base_baud = 1500000) is a 16550A
[    3.984254] fe690000.serial: ttyS5 at MMIO 0xfe690000 (irq = 46, base_baud = 1500000) is a 16550A
[    3.984906] fe6a0000.serial: ttyS6 at MMIO 0xfe6a0000 (irq = 47, base_baud = 1500000) is a 16550A
[    3.987437] rockchip-vop2 fe040000.vop: Adding to iommu group 0
[    3.993890] rockchip-vop2 fe040000.vop: [drm:vop2_bind] vp0 assign plane mask: 0x0, primary plane phy id: -1
[    3.993921] rockchip-vop2 fe040000.vop: [drm:vop2_bind] vp1 assign plane mask: 0x15, primary plane phy id: 4
[    3.993934] rockchip-vop2 fe040000.vop: [drm:vop2_bind] vp2 assign plane mask: 0x2a, primary plane phy id: 5
[    3.993967] rockchip-vop2 fe040000.vop: [drm:vop2_bind] VP0 plane_mask is zero, so ignore register crtc
[    3.994226] [drm] failed to init overlay plane Cluster0-win1
[    3.994279] [drm] failed to init overlay plane Cluster1-win1
[    3.994431] rockchip-drm display-subsystem: bound fe040000.vop (ops 0xffffffc00935f980)
[    3.994524] dw-mipi-dsi-rockchip fe070000.dsi: failed to find panel or bridge: -517
[    3.996367] rk-pcie 3c0800000.pcie: IRQ msi not found
[    3.996384] rk-pcie 3c0800000.pcie: use outband MSI support
[    3.996394] rk-pcie 3c0800000.pcie: Missing *config* reg space
[    3.996442] rk-pcie 3c0800000.pcie: host bridge /pcie@fe280000 ranges:
[    3.996662] rk-pcie 3c0800000.pcie:      err 0x00f0000000..0x00f00fffff -> 0x00f0000000
[    3.996725] rk-pcie 3c0800000.pcie:       IO 0x00f0100000..0x00f01fffff -> 0x00f0100000
[    3.996814] rk-pcie 3c0800000.pcie:      MEM 0x00f0200000..0x00f1ffffff -> 0x00f0200000
[    3.996899] rk-pcie 3c0800000.pcie:      MEM 0x0380000000..0x03bfffffff -> 0x0380000000
[    3.996977] rk-pcie 3c0800000.pcie: Missing *config* reg space
[    3.997051] rk-pcie 3c0800000.pcie: invalid resource
[    3.999718] cacheinfo: Unable to detect cache hierarchy for CPU 0
[    4.000427] brd: module loaded
[    4.005538] loop: module loaded
[    4.005993] zram: Added device: zram0
[    4.006257] lkdtm: No crash points registered, enable through debugfs
[    4.010225] rockchip-spi fe620000.spi: no high_speed pinctrl state
[    4.010993] rockchip-spi fe620000.spi: probed, poll=0, rsd=0, cs-inactive=0, ready=0
[    4.013466] rk_gmac-dwmac fe2a0000.ethernet: IRQ eth_lpi not found
[    4.013766] rk_gmac-dwmac fe2a0000.ethernet: supply phy not found, using dummy regulator
[    4.013903] rk_gmac-dwmac fe2a0000.ethernet: clock input or output? (output).
[    4.013918] rk_gmac-dwmac fe2a0000.ethernet: TX delay(0x3c).
[    4.013929] rk_gmac-dwmac fe2a0000.ethernet: RX delay(0x2f).
[    4.013945] rk_gmac-dwmac fe2a0000.ethernet: integrated PHY? (no).
[    4.014224] rk_gmac-dwmac fe2a0000.ethernet: init for RGMII
[    4.014438] rk_gmac-dwmac fe2a0000.ethernet: User ID: 0x30, Synopsys ID: 0x51
[    4.014454] rk_gmac-dwmac fe2a0000.ethernet: 	DWMAC4/5
[    4.014467] rk_gmac-dwmac fe2a0000.ethernet: DMA HW capability register supported
[    4.014477] rk_gmac-dwmac fe2a0000.ethernet: RX Checksum Offload Engine supported
[    4.014485] rk_gmac-dwmac fe2a0000.ethernet: TX Checksum insertion supported
[    4.014493] rk_gmac-dwmac fe2a0000.ethernet: Wake-Up On Lan supported
[    4.014555] rk_gmac-dwmac fe2a0000.ethernet: TSO supported
[    4.014566] rk_gmac-dwmac fe2a0000.ethernet: Enable RX Mitigation via HW Watchdog Timer
[    4.014576] rk_gmac-dwmac fe2a0000.ethernet: TSO feature enabled
[    4.014585] rk_gmac-dwmac fe2a0000.ethernet: Using 32 bits DMA width
[    4.148138] usbcore: registered new interface driver rtl8150
[    4.148194] usbcore: registered new interface driver r8152
[    4.154030] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.154071] ehci-pci: EHCI PCI platform driver
[    4.154150] ehci-platform: EHCI generic platform driver
[    4.154413] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    4.154434] ohci-platform: OHCI generic platform driver
[    4.154965] usbcore: registered new interface driver cdc_acm
[    4.154976] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
[    4.155208] usbcore: registered new interface driver uas
[    4.155266] usbcore: registered new interface driver usb-storage
[    4.155348] usbcore: registered new interface driver usbserial_generic
[    4.155376] usbserial: USB Serial support registered for generic
[    4.155414] usbcore: registered new interface driver cp210x
[    4.155442] usbserial: USB Serial support registered for cp210x
[    4.155481] usbcore: registered new interface driver ftdi_sio
[    4.155505] usbserial: USB Serial support registered for FTDI USB Serial Device
[    4.155542] usbcore: registered new interface driver keyspan
[    4.155566] usbserial: USB Serial support registered for Keyspan - (without firmware)
[    4.155589] usbserial: USB Serial support registered for Keyspan 1 port adapter
[    4.155612] usbserial: USB Serial support registered for Keyspan 2 port adapter
[    4.155667] usbserial: USB Serial support registered for Keyspan 4 port adapter
[    4.155709] usbcore: registered new interface driver option
[    4.155739] usbserial: USB Serial support registered for GSM modem (1-port)
[    4.155783] usbcore: registered new interface driver oti6858
[    4.155808] usbserial: USB Serial support registered for oti6858
[    4.155846] usbcore: registered new interface driver pl2303
[    4.155871] usbserial: USB Serial support registered for pl2303
[    4.155912] usbcore: registered new interface driver qcserial
[    4.155937] usbserial: USB Serial support registered for Qualcomm USB modem
[    4.155974] usbcore: registered new interface driver sierra
[    4.155998] usbserial: USB Serial support registered for Sierra USB modem
[    4.156901] usbcore: registered new interface driver usbtouchscreen
[    4.157389] i2c /dev entries driver
[    4.159414] fan53555-regulator 0-001c: FAN53555 Option[12] Rev[15] Detected!
[    4.161035] vdd_cpu: supplied by vcc5v0_sys
[    4.167275] rk808 0-0020: chip id: 0x8090
[    4.167338] rk808 0-0020: No cache defaults, reading back from HW
[    4.191049] rk808 0-0020: source: on=0x40, off=0x00
[    4.191068] rk808 0-0020: support dcdc3 fb mode:-22, 1
[    4.191080] rk808 0-0020: support pmic reset mode:0,0
[    4.196428] rk808-regulator rk808-regulator: there is no dvs0 gpio
[    4.196463] rk808-regulator rk808-regulator: there is no dvs1 gpio
mount: /oem: can't find PARTLABEL=oem.
[    4.196891] vdd_logic: supplied by vcc3v3_sys
[    4.197892] vdd_gpu: supplied by vcc3v3_sys
[    4.198516] vcc_ddr: supplied by vcc3v3_sys
[    4.199162] vdd_npu: supplied by vcc3v3_sys
[    4.200108] vcc_1v8: supplied by vcc3v3_sys
[    4.200702] vdda0v9_image: supplied by vcc3v3_sys
[    4.202151] vdda_0v9: supplied by vcc3v3_sys
[    4.203253] vdda0v9_pmu: supplied by vcc3v3_sys
[    4.203469] rk-pcie 3c0800000.pcie: PCIe Linking... LTSSM is 0x1
[    4.204368] vccio_acodec: supplied by vcc3v3_sys
[    4.205832] vccio_sd: supplied by vcc3v3_sys
[    4.206940] vcc3v3_pmu: supplied by vcc3v3_sys
[    4.208400] vcca_1v8: supplied by vcc3v3_sys
[    4.209522] vcca1v8_pmu: supplied by vcc3v3_sys
[    4.210639] vcca1v8_image: supplied by vcc3v3_sys
[    4.212104] vcc_3v3: supplied by vcc3v3_sys
[    4.213018] vcc3v3_sd: supplied by vcc3v3_sys
[    4.213605] rk817-battery: Failed to locate of_node [id: -1]
[    4.213747] rk817-battery rk817-battery: Failed to find matching dt id
[    4.213872] rk817-charger: Failed to locate of_node [id: -1]
[    4.213990] rk817-charger rk817-charger: Failed to find matching dt id
[    4.217132] input: rk805 pwrkey as /devices/platform/fdd40000.i2c/i2c-0/0-0020/rk805-pwrkey/input/input0
[    4.220563] goodix_ts_probe() start
[    4.229023] rk-pcie 3c0800000.pcie: PCIe Linking... LTSSM is 0x0
[    4.255666] rk-pcie 3c0800000.pcie: PCIe Linking... LTSSM is 0x0
Start mounting all internal partitions in /etc/fstab
[    4.282333] rk-pcie 3c0800000.pcie: PCIe Linking... LTSSM is 0x0
Log saved to /var/log/mount-all.log
[    4.309000] rk-pcie 3c0800000.pcie: PCIe Linking... LTSSM is 0x0
[    4.335663] rk-pcie 3c0800000.pcie: PCIe Linking... LTSSM is 0x0
Note: Will skip fsck, remove /.skip_fsck to enable
[    4.362329] rk-pcie 3c0800000.pcie: PCIe Linking... LTSSM is 0x0
[    4.371417] input: goodix-ts as /devices/platform/fe5b0000.i2c/i2c-2/2-005d/input/input1
[    4.375821] rtc-hym8563 5-0051: rtc information is valid
[    4.381423] rtc-hym8563 5-0051: registered as rtc0
[    4.382471] rtc-hym8563 5-0051: setting system clock to 2025-05-12T16:17:10 UTC (1747066630)
[    4.385559] rockchip-mipi-csi2-hw fdfb0000.mipi-csi2-hw: enter mipi csi2 hw probe!
[    4.385752] rockchip-mipi-csi2-hw fdfb0000.mipi-csi2-hw: probe success, v4l2_dev:mipi-csi2-hw!
[    4.387473] usbcore: registered new interface driver uvcvideo
[    4.387485] USB Video Class driver (1.1.1)
[0]: Handling /dev/mmcblk0p4 / ext4 ro,noauto 1
[    4.388938] Bluetooth: HCI UART driver ver 2.3
[    4.388956] Bluetooth: HCI UART protocol H4 registered
[2]: Handling /dev/mmcblk0p5 /userdata ext4 defaults 2
[    4.388988] Bluetooth: HCI UART protocol ATH3K registered
[    4.389005] rk-pcie 3c0800000.pcie: PCIe Linking... LTSSM is 0x0
[    4.389048] usbcore: registered new interface driver bfusb
[    4.389098] usbcore: registered new interface driver btusb
[    4.389876] cpu cpu0: bin=0
[0]: Already resized /dev/mmcblk0p4(ext4)
[    4.389943] cpu cpu0: leakage=27
[2]: Already resized /dev/mmcblk0p5(ext4)
[    4.389989] cpu cpu0: pvtm = 88920, from nvmem
[    4.390006] cpu cpu0: pvtm-volt-sel=2
[    4.390061] cpu cpu0: soc version=0, speed=2
[    4.391782] cpu cpu0: avs=0
[    4.392109] cpu cpu0: EM: created perf domain
[    4.392175] cpu cpu0: l=0 h=2147483647 hyst=5000 l_limit=0 h_limit=0 h_table=0
[    4.394326] sdhci: Secure Digital Host Controller Interface driver
[    4.394345] sdhci: Copyright(c) Pierre Ossman
Starting syslogd: [    4.394353] Synopsys Designware Multimedia Card Interface Driver
OK
[    4.394705] sdhci-pltfm: SDHCI platform and OF driver helper
log-guardian: [WARN] Not a dir: "/var/log/,/tmp/"
[    4.395812] arm-scmi firmware:scmi: Failed. SCMI protocol 17 not active.
Starting klogd: log-guardian: Guarding logs in: "/var/log/,/tmp/"...
[    4.395949] SMCCC: SOC_ID: ARCH_SOC_ID not implemented, skipping ....
OK
[    4.397204] cryptodev: driver 1.12 loaded.
Running sysctl: OK
[    4.397326] hid: raw HID events driver (C) Jiri Kosina
Populating /dev using udev: [    4.397852] usbcore: registered new interface driver usbhid
[    4.397872] usbhid: USB HID core driver
[    4.405036] usbcore: registered new interface driver snd-usb-audio
[    4.407977] rk817-codec rk817-codec: DMA mask not set
[    4.412244] Initializing XFRM netlink socket
[    4.412653] NET: Registered protocol family 10
[    4.413432] Segment Routing with IPv6
[    4.413486] NET: Registered protocol family 17
[    4.413506] NET: Registered protocol family 15
[    4.413722] Bluetooth: RFCOMM socket layer initialized
[    4.413758] Bluetooth: RFCOMM ver 1.11
[    4.413772] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    4.413785] Bluetooth: HIDP socket layer initialized
[    4.413819] [BT_RFKILL]: Enter rfkill_rk_init
[    4.413826] [WLAN_RFKILL]: Enter rfkill_wlan_init
[    4.414294] Key type dns_resolver registered
[    4.415511] Loading compiled-in X.509 certificates
[    4.415756] rk-pcie 3c0800000.pcie: PCIe Linking... LTSSM is 0x0
[    4.417209] pstore: Using crash dump compression: deflate
[    4.417902] rga_iommu: rga_iommu_bind, binding map scheduler failed!
[    4.417913] rga: rga iommu bind failed!
[    4.428481] mmc0: SDHCI controller on fe310000.sdhci [fe310000.sdhci] using ADMA
[    4.435657] mali fde60000.gpu: Kernel DDK version g21p0-01eac0
[    4.435731] mali fde60000.gpu: GPU metrics tracepoint support enabled
[    4.435877] rockchip-dmc dmc: bin=0
[    4.435913] rockchip-dmc dmc: leakage=56
[    4.435928] rockchip-dmc dmc: leakage-volt-sel=0
[    4.435958] rockchip-dmc dmc: pvtm = 88920, from nvmem
[    4.435989] rockchip-dmc dmc: pvtm-volt-sel=1
[    4.436000] rockchip-dmc dmc: soc version=0, speed=1
[    4.436033] mali fde60000.gpu: bin=0
[    4.436072] mali fde60000.gpu: leakage=8
[    4.436102] mali fde60000.gpu: pvtm = 88920, from nvmem
[    4.436114] mali fde60000.gpu: pvtm-volt-sel=2
[    4.436123] mali fde60000.gpu: soc version=0, speed=2
[    4.436152] rockchip-dmc dmc: avs=0
[    4.436166] rockchip-dmc dmc: current ATF version 0x102
[    4.436508] mali fde60000.gpu: avs=0
[    4.436525] W : [File] : drivers/gpu/arm/bifrost/platform/rk/mali_kbase_config_rk.c; [Line] : 143; [Func] : kbase_platform_rk_init(); power-off-delay-ms not available.
[    4.436630] rockchip-dmc dmc: normal_rate = 780000000
[    4.436639] rockchip-dmc dmc: reboot_rate = 1560000000
[    4.436645] rockchip-dmc dmc: suspend_rate = 324000000
[    4.436651] rockchip-dmc dmc: video_4k_rate = 780000000
[    4.436657] rockchip-dmc dmc: video_4k_10b_rate = 780000000
[    4.436662] rockchip-dmc dmc: boost_rate = 1560000000
[    4.436668] rockchip-dmc dmc: fixed_rate(isp|cif0|cif1|dualview) = 1560000000
[    4.436673] rockchip-dmc dmc: performance_rate = 1560000000
[    4.436690] rockchip-dmc dmc: failed to get vop pn to msch rl
[    4.436789] mali fde60000.gpu: Register LUT 00070200 initialized for GPU arch 0x00070400
[    4.436816] mali fde60000.gpu: GPU identified as 0x2 arch 7.4.0 r1p0 status 0
[    4.436832] rockchip-dmc dmc: l=0 h=2147483647 hyst=5000 l_limit=0 h_limit=0 h_table=0
[    4.436933] mali fde60000.gpu: No priority control manager is configured
[    4.436941] mali fde60000.gpu: Large page allocation set to false after hardware feature check
[    4.437110] mali fde60000.gpu: No memory group manager is configured
[    4.437376] rockchip-dmc dmc: could not find power_model node
[    4.438488] mali fde60000.gpu: l=0 h=2147483647 hyst=5000 l_limit=0 h_limit=0 h_table=0
[    4.439548] mali fde60000.gpu: Probed as mali0
[    4.442337] rk-pcie 3c0800000.pcie: PCIe Linking... LTSSM is 0x0
[    4.448338] rockchip-iodomain fdc20000.syscon:io-domains: pmuio2(3300000 uV) supplied by vcc_3v3
done
[    4.448399] rockchip-iodomain fdc20000.syscon:io-domains: vccio1(3300000 uV) supplied by vcc_3v3
Starting irqbalance: [    4.448527] rockchip-iodomain fdc20000.syscon:io-domains: vccio2(1800000 uV) supplied by vcc_1v8
[    4.448602] rockchip-iodomain fdc20000.syscon:io-domains: vccio3(3300000 uV) supplied by vcc_3v3
[    4.448645] rockchip-iodomain fdc20000.syscon:io-domains: vccio4(1800000 uV) supplied by vcc_1v8
OK
[    4.448685] rockchip-iodomain fdc20000.syscon:io-domains: vccio5(3300000 uV) supplied by vcc_3v3
[    4.448740] rockchip-iodomain fdc20000.syscon:io-domains: vccio6(1800000 uV) supplied by vcc_1v8
[    4.448782] rockchip-iodomain fdc20000.syscon:io-domains: vccio7(3300000 uV) supplied by vcc_3v3
[    4.451336] rockchip-vop2 fe040000.vop: [drm:vop2_bind] vp0 assign plane mask: 0x0, primary plane phy id: -1
Saving random seed: [    4.451360] rockchip-vop2 fe040000.vop: [drm:vop2_bind] vp1 assign plane mask: 0x15, primary plane phy id: 4
SKIP (read-only file system detected)
[    4.451368] rockchip-vop2 fe040000.vop: [drm:vop2_bind] vp2 assign plane mask: 0x2a, primary plane phy id: 5
[    4.451396] rockchip-vop2 fe040000.vop: [drm:vop2_bind] VP0 plane_mask is zero, so ignore register crtc
[    4.451586] [drm] failed to init overlay plane Cluster0-win1
[    4.451618] [drm] failed to init overlay plane Cluster1-win1
[    4.451720] rockchip-drm display-subsystem: bound fe040000.vop (ops 0xffffffc00935f980)
Starting system message bus: [    4.451852] rockchip-drm display-subsystem: bound fe070000.dsi (ops 0xffffffc00936fee0)
[    4.478942] mmc0: Host Software Queue enabled
[    4.479026] mmc0: new HS200 MMC card at address 0001
[    4.479983] mmcblk0: mmc0:0001 Biwin  115 GiB 
[    4.480314] mmcblk0boot0: mmc0:0001 Biwin  partition 1 4.00 MiB
done
[    4.480622] mmcblk0boot1: mmc0:0001 Biwin  partition 2 4.00 MiB
[    4.481094] mmcblk0rpmb: mmc0:0001 Biwin  partition 3 4.00 MiB, chardev (237:0)
[    4.486041]  mmcblk0: p1 p2 p3 p4 p5
[    4.498643] rockchip-drm display-subsystem: [drm] fb0: rockchipdrmfb frame buffer device
[    4.499497] [drm] Initialized rockchip 3.0.0 20140818 for display-subsystem on minor 0
Starting bluetoothd: OK
[    4.503365] cfg80211: Loading compiled-in X.509 certificates for regulatory database
[    4.505931] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
Starting network: [    4.506499] cfg80211: Loaded X.509 cert 'wens: 61c038651aabdcf94bd0ac7ff06c7248db18c600'
[    4.507443] platform regulatory.0: Direct firmware load for regulatory.db failed with error -2
[    4.507459] cfg80211: failed to load regulatory.db
[    4.508879] rockchip-pm rockchip-suspend: not set pwm-regulator-config
[    4.509933] rockchip-suspend not set sleep-mode-config for mem-lite
[    4.509944] rockchip-suspend not set wakeup-config for mem-lite
Failed to detect Wi-Fi/BT chip!
[    4.509953] rockchip-suspend not set sleep-mode-config for mem-ultra
[    4.509960] rockchip-suspend not set wakeup-config for mem-ultra
[    4.511051] I : [File] : drivers/gpu/arm/mali400/mali/linux/mali_kernel_linux.c; [Line] : 406; [Func] : mali_module_init(); svn_rev_string_from_arm of this mali_ko is '', rk_ko_ver is '5', built at '15:16:40', on 'Apr 17 2025'.
OK
[    4.511442] Mali: 
[    4.511446] Mali device driver loaded
[    4.511466] ALSA device list:
[    4.511477]   No soundcards found.
Starting dhcpcd...
[    4.518702] EXT4-fs (mmcblk0p4): mounted filesystem with ordered data mode. Opts: (null)
[    4.518826] VFS: Mounted root (ext4 filesystem) on device 179:4.
dhcpcd-9.4.1 starting
[    4.521234] vendor storage:20190527 ret = 0
dev: loaded udev
[    4.521398] devtmpfs: mounted
[    4.532659] Freeing unused kernel memory: 6720K
[    4.553187] Run /sbin/init as init process
[    4.616792] EXT4-fs (mmcblk0p4): re-mounted. Opts: (null)
[    4.778741] EXT4-fs (mmcblk0p5): recovery complete
[    4.778811] EXT4-fs (mmcblk0p5): mounted filesystem with ordered data mode. Opts: (null)
[    5.050453] EXT4-fs (mmcblk0p4): re-mounted. Opts: (null)
[    5.130304] udevd[295]: starting version 3.2.10
[    5.149775] udevd[302]: starting eudev-3.2.10
forked to background, child pid 428
Starting chrony: OK
[    5.865780] rk_gmac-dwmac fe2a0000.ethernet eth0: PHY [stmmac-0:00] driver [RTL8211F Gigabit Ethernet] (irq=POLL)
[    5.867863] dwmac4: Master AXI performs any burst length
starting weston... [    5.867907] rk_gmac-dwmac fe2a0000.ethernet eth0: No Safety Features support found
[    5.867937] rk_gmac-dwmac fe2a0000.ethernet eth0: IEEE 1588-2008 Advanced Timestamp supported
[    5.868450] rk_gmac-dwmac fe2a0000.ethernet eth0: registered PTP clock
[    5.868885] rk_gmac-dwmac fe2a0000.ethernet eth0: configuring for phy/rgmii link mode
Date: 2025-05-12 UTC
[16:17:12.217] weston 13.0.1
               https://wayland.freedesktop.org
               Bug reports to: https://gitlab.freedesktop.org/wayland/weston/issues/
               Build: 13.0.1
[16:17:12.219] Command line: /usr/bin/weston
[16:17:12.219] OS: Linux, 5.10.209, #3 SMP Thu Apr 17 15:20:19 CST 2025, aarch64
[16:17:12.219] Flight recorder: enabled
[16:17:12.220] warning: XDG_RUNTIME_DIR "/var/run" is not configured
correctly.  Unix access mode must be 0700 (current mode is 0755),
and must be owned by the user UID 0 (current owner is UID 0).
Refer to your distribution on how to get it, or
http://www.freedesktop.org/wiki/Specifications/basedir-spec
on how to implement it.
[16:17:12.222] Using config file '/etc/xdg/weston/weston.ini'
[16:17:12.223] Output repaint window is -1 ms maximum.
[16:17:12.225] Loading module '/usr/lib/libweston-13/drm-backend.so'
[16:17:12.228] initializing drm backend
[16:17:12.228] Entering mirror mode.
[16:17:1\0