# ANZVP1202SOM

ANZVP1202SOM is a System-on-Module (SOM) platform based on the AMD Versal Premium XCVP1202 device.

## Overview

- AMD Versal Premium XCVP1202-1MSEVSVA2785
- 3 × LPDDR4 memory subsystems
- 2 × QSPI Flash devices
- eMMC storage
- USB interface
- RGMII Ethernet
- TPM security device
- Multiple I2C peripherals
- PL GPIO interfaces
- GTY transceivers (QSFP interfaces)

## Repository Structure

```text
ANZVP1202SOM
│
├── apps
│   └── Board_test
│
├── constrains
│   ├── top.xdc
│   └── timing.xdc
│
├── hdl
│
├── scripts
│   ├── build_it.tcl
│   ├── create_bd.tcl
│   ├── create_vitis.py
│   └── program_flash.tcl
│
├── release
│   ├── hardware
│   ├── software
│   ├── boot
│   └── logs
│
├── workspace
│
└── README.md
```

## Tool Versions

| Tool | Version |
|--------|--------|
| Vivado | 2024.2 |
| Vitis | 2024.2 |
| XSCT | 2024.2 |

## Build FPGA Design

```bash
vivado -mode batch -source ./scripts/build_it.tcl
```

## Create Vitis Platform
The platform is generated automatically from:

release/hardware/ANZVP1202SOM_top.xsa

```python
vitis -s scripts\create_vitis_platform.py > build.log

platform generate
```

```check log
Get-Content build.log -Tail -Wait

## Build Self-Test Application

```tcl
setws ./vitis/workspace

app create \
   -name selftest_app \
   -platform ANZVP1202SOM_platform \
   -domain standalone_domain \
   -template {Empty Application}

app build -name selftest_app

vitis -s scripts\create_vitis_app.py > vitis_app.log
Get-Content vitis_app.log -Tail 10 -Wait

```

## Program FPGA

Program the generated bitstream using Vivado Hardware Manager.

## Run Self-Test

Tests include:

- Power
- Clocks
- LPDDR4
- QSPI
- eMMC
- TPM
- Ethernet
- USB
- PL IO
- GTY

Expected result:

```text
RESULT: PASS
```
