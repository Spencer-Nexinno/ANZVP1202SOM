#!/usr/bin/env python3

import csv
import re

CSV_FILE = "FPGA_PIN.csv"
XDC_FILE = "lpddr4_corrected.xdc"

xdc = []

def add(pin, port):
    xdc.append(
        f"set_property PACKAGE_PIN {pin} [get_ports {{{port}}}]"
    )

with open(CSV_FILE, newline='', encoding='utf-8-sig') as f:
    reader = csv.DictReader(f)

    for row in reader:

        pin = row['Pin'].strip()
        net = row['Model'].strip()

        if not net:
            continue

        #
        # LPDDR4 reference clocks
        #
        m = re.match(r'LPDDR4_CLK([123])_(P|N)$', net)
        if m:
            clk = m.group(1)
            pol = m.group(2).lower()

            add(
                pin,
                f"LPDDR4_CLK{clk}_clk_{pol}[0]"
            )
            continue

        #
        # LPDDR4 nets
        #
        m = re.match(
            r'TRIP([123])_CH([01])_LPDDR4_0_0_(.*)',
            net
        )

        if not m:
            continue

        trip = m.group(1)
        ch = m.group(2)
        sig = m.group(3)

        #
        # CA_A5
        #
        mm = re.match(r'CA_([AB])(\d+)', sig)
        if mm:
            byte = mm.group(1).lower()
            idx = mm.group(2)

            add(
                pin,
                f"TRIP{trip}_CH{ch}_LPDDR4_ca_{byte}[{idx}]"
            )
            continue

        #
        # DQ_A14
        #
        mm = re.match(r'DQ_([AB])(\d+)', sig)
        if mm:
            byte = mm.group(1).lower()
            idx = mm.group(2)

            add(
                pin,
                f"TRIP{trip}_CH{ch}_LPDDR4_dq_{byte}[{idx}]"
            )
            continue

        #
        # DMI_B1
        #
        mm = re.match(r'DMI_([AB])(\d+)', sig)
        if mm:
            byte = mm.group(1).lower()
            idx = mm.group(2)

            add(
                pin,
                f"TRIP{trip}_CH{ch}_LPDDR4_dmi_{byte}[{idx}]"
            )
            continue

        #
        # DQS_A1_T
        #
        mm = re.match(
            r'DQS_([AB])(\d+)_(T|C)',
            sig
        )

        if mm:
            byte = mm.group(1).lower()
            idx = mm.group(2)

            tc = "t" if mm.group(3) == "T" else "c"

            add(
                pin,
                f"TRIP{trip}_CH{ch}_LPDDR4_dqs_{tc}_{byte}[{idx}]"
            )
            continue

        #
        # CK_A0_T
        #
        mm = re.match(
            r'CK_([AB])(\d+)_(T|C)',
            sig
        )

        if mm:
            byte = mm.group(1).lower()
            idx = mm.group(2)

            tc = "t" if mm.group(3) == "T" else "c"

            add(
                pin,
                f"TRIP{trip}_CH{ch}_LPDDR4_ck_{tc}_{byte}[{idx}]"
            )
            continue

        #
        # CKE_A0
        #
        mm = re.match(r'CKE_([AB])(\d+)', sig)
        if mm:
            byte = mm.group(1).lower()
            idx = mm.group(2)

            add(
                pin,
                f"TRIP{trip}_CH{ch}_LPDDR4_cke_{byte}[{idx}]"
            )
            continue

        #
        # CS_A0
        #
        mm = re.match(r'CS_([AB])(\d+)', sig)
        if mm:
            byte = mm.group(1).lower()
            idx = mm.group(2)

            add(
                pin,
                f"TRIP{trip}_CH{ch}_LPDDR4_cs_{byte}[{idx}]"
            )
            continue

        #
        # RESET_N0
        #
        mm = re.match(r'RESET_N(\d+)', sig)
        if mm:
            idx = mm.group(1)

            add(
                pin,
                f"TRIP{trip}_CH{ch}_LPDDR4_reset_n[{idx}]"
            )
            continue

with open(XDC_FILE, "w") as f:
    f.write("\n".join(sorted(xdc)))

print(f"Generated {len(xdc)} constraints")