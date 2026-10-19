import shutil
import vitis
from pathlib import Path

APP_NAME = "Board_Test"
DOMAIN_NAME   = "standalone_domain"
PLATFORM_NAME = "anzvp1202_platform"

SCRIPT_DIR = Path(__file__).resolve().parent
ROOT_DIR   = SCRIPT_DIR.parent
APP_SRC_DIR = ROOT_DIR / "apps" / "board_test" / "src"
WORKSPACE_DIR = ROOT_DIR / "workspace"
APP_DIR = WORKSPACE_DIR / APP_NAME

if APP_DIR.exists():
    print(f"Removing {APP_DIR}")
    shutil.rmtree(APP_DIR)

client = vitis.create_client(
    workspace=str(WORKSPACE_DIR)
)

print("=== Components ===")

#for item in dir(client):
#    if not item.startswith("_"):
#        print(item)

platform = client.get_component(
            PLATFORM_NAME
)

print(platform)

###############################################################################
# Locate XPFM
###############################################################################

XPFM = (
    WORKSPACE_DIR /
    PLATFORM_NAME /
    "export" /
    PLATFORM_NAME /
    f"{PLATFORM_NAME}.xpfm"
)

print("Creating application...")

app = client.create_app_component(
    name=APP_NAME,
    platform=str(XPFM),
    domain=DOMAIN_NAME,
    template="empty_application"
)

print("Application created")

APP_DST_DIR = WORKSPACE_DIR / APP_NAME / "src"

APP_DST_DIR.mkdir(parents=True, exist_ok=True)

for item in APP_SRC_DIR.iterdir():

    dst = APP_DST_DIR / item.name

    if item.is_dir():
        shutil.copytree(
            item,
            dst,
            dirs_exist_ok=True
        )
    else:
        shutil.copy2(
            item,
            dst
        )

print("Application sources copied")

app.build()


###############################################################################
# Summary
###############################################################################

print()
print("============================================================")
print("App Build Complete")
print("============================================================")
print(f"Platform : {PLATFORM_NAME}")
print(f"Domain   : {DOMAIN_NAME}")
print(f"XPFM     : {XPFM}")
print(f"App      : {DOMAIN_NAME}")
print("============================================================")
print()

client.close()