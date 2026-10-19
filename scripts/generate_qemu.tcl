set script_dir [file dirname [info script]]
put "$script_dir"
source [file join $script_dir xsct_script.tcl]
#source xsct_script.tcl

###############################################################################
# Version Control
###############################################################################

set VERSION "01"

set SCRIPT_DIR [file normalize [file dirname [info script]]]
set ROOT_DIR   [file normalize "$SCRIPT_DIR/.."]

set BASE_PROJECT_NAME "ANZVP1202SOM"
set PROJECT_NAME "${BASE_PROJECT_NAME}_${VERSION}"

set WORKSPACE_DIR [file join $ROOT_DIR workspace]
set RELEASE_DIR   [file join $ROOT_DIR release]
set HARDWARE_DIR  [file join $RELEASE_DIR hardware]

generate_apps \
  -xsa "$HARDWARE_DIR/${PROJECT_NAME}.xsa" \
  -app NULL \
  -multi 1

generate_qemu_scripts \
  -install C:/Xilinx/Vitis/2024.2 \
  -xsa ANZVP1202SOM_top.xsa \
  -multi 1 \
  -os windows \
  -version 2024.2