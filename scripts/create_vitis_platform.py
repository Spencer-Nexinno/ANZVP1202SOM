import subprocess
from pathlib import Path

import vitis

###############################################################################
# Configuration
###############################################################################

PLATFORM_NAME = "anzvp1202_platform"
DOMAIN_NAME   = "standalone_domain"

CPU = "psv_cortexa72_0"
OS  = "standalone"

###############################################################################
# Vitis Installation
###############################################################################

VITIS_ROOT = Path(r"C:\Xilinx\Vitis\2024.2")

CONFIG_BSP = (
    VITIS_ROOT /
    "data" /
    "embeddedsw" /
    "scripts" /
    "pyesw" /
    "config_bsp.py"
)

LOPPER_PYTHON = (
    VITIS_ROOT /
    "tps" /
    "win64" /
    "lopper-1.1.0" /
    "env" /
    "Scripts" /
    "python.exe"
)

###############################################################################
# Paths
###############################################################################

SCRIPT_DIR = Path(__file__).resolve().parent
ROOT_DIR   = SCRIPT_DIR.parent

WORKSPACE_DIR = ROOT_DIR / "workspace"
RELEASE_DIR   = ROOT_DIR / "release"
HARDWARE_DIR  = RELEASE_DIR / "hardware"

WORKSPACE_DIR.mkdir(exist_ok=True)
RELEASE_DIR.mkdir(exist_ok=True)
HARDWARE_DIR.mkdir(exist_ok=True)

###############################################################################
# Find XSA
###############################################################################

xsa_files = list(HARDWARE_DIR.glob("*.xsa"))

if not xsa_files:
    raise RuntimeError(
        f"No XSA found in {HARDWARE_DIR}"
    )

XSA = xsa_files[0].as_posix()

###############################################################################
# Banner
###############################################################################

print()
print("============================================================")
print("            ANZVP1202 Vitis Platform Builder")
print("============================================================")
print(f"Workspace : {WORKSPACE_DIR}")
print(f"XSA       : {XSA}")
print("============================================================")
print()

###############################################################################
# Create Client
###############################################################################

print("------------------------------------------------------------")
print("Creating Vitis Client")
print("------------------------------------------------------------")

client = vitis.create_client(
    workspace=str(WORKSPACE_DIR)
)

###############################################################################
# Create/Open Platform
###############################################################################

print()
print("------------------------------------------------------------")
print("Creating Platform")
print("------------------------------------------------------------")

try:

    platform = client.create_platform_component(
        name=PLATFORM_NAME,
        hw_design=XSA,
        cpu=CPU,
        os=OS,
        domain_name=DOMAIN_NAME
    )

    print("Platform Created")

except Exception as e:

    if "ALREADY_EXISTS" in str(e):

        print("Platform Already Exists")

        platform = client.get_component(
            PLATFORM_NAME
        )

    else:
        raise
        
#platform.build()
###############################################################################
# BSP Configuration
###############################################################################

domain = platform.get_domain(DOMAIN_NAME)
print(type(domain))

# add lwip
domain.set_lib("lwip220")

platform.build()

print()
print("------------------------------------------------------------")
print("Configuring BSP")
print("------------------------------------------------------------")

BSP_DIR = (
    WORKSPACE_DIR /
    PLATFORM_NAME /
    CPU /
    DOMAIN_NAME /
    "bsp"
)

REPO_YAML = (
    WORKSPACE_DIR /
    "_ide" /
    ".wsdata" /
    ".repo.yaml"
)

LWIP_SETTINGS = [

    # Enable DHCP
    "lwip220_dhcp:true",

]

for setting in LWIP_SETTINGS:

    print(f"Apply BSP Setting : {setting}")

    subprocess.run(
        [
            str(LOPPER_PYTHON),
            str(CONFIG_BSP),
            "-d",
            str(BSP_DIR),
            "-st",
            "lwip220",
            setting,
            "-r",
            str(REPO_YAML)
        ],
        check=True
    )

###############################################################################
# Rebuild Platform
###############################################################################

print()
print("------------------------------------------------------------")
print("Rebuilding Platform")
print("------------------------------------------------------------")

platform.build()

###############################################################################
# Locate XPFM
###############################################################################

xpfm = (
    WORKSPACE_DIR /
    PLATFORM_NAME /
    "export" /
    PLATFORM_NAME /
    f"{PLATFORM_NAME}.xpfm"
)

###############################################################################
# Summary
###############################################################################

print()
print("============================================================")
print("Platform Build Complete")
print("============================================================")
print(f"Platform : {PLATFORM_NAME}")
print(f"Domain   : {DOMAIN_NAME}")
print(f"XPFM     : {xpfm}")
print("============================================================")
print()

client.close()