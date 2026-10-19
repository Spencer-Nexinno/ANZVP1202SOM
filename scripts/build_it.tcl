###############################################################################
# ANZVP1202 SOM Project Build Script
# Vivado 2025.2
###############################################################################

###############################################################################
# Version Control
###############################################################################

set VERSION "01"

set BASE_PROJECT_NAME "ANZVP1202SOM"
set PROJECT_NAME "${BASE_PROJECT_NAME}_${VERSION}"

###############################################################################
# Device
###############################################################################

set FPGA_PART "xcvp1202-vsva2785-1MP-e-S"

###############################################################################
# Directory Structure
###############################################################################

set SCRIPT_DIR [file normalize [file dirname [info script]]]
set ROOT_DIR   [file normalize "$SCRIPT_DIR/.."]

set PROJECT_DIR    [file normalize "$ROOT_DIR/build/$PROJECT_NAME"]
set HDL_DIR        [file normalize "$ROOT_DIR/hdl"]
set CONSTRAINT_DIR [file normalize "$ROOT_DIR/constrains"]
set RELEASE_DIR    [file normalize "$ROOT_DIR/release/hardware"]

set BD_SCRIPT      [file normalize "$SCRIPT_DIR/bd_system.tcl"]

###############################################################################
# Create Project
###############################################################################

puts "================================================="
puts "Creating Project : $PROJECT_NAME"
puts "Location         : $PROJECT_DIR"
puts "Device           : $FPGA_PART"
puts "================================================="

file mkdir $PROJECT_DIR

create_project \
    $PROJECT_NAME \
    $PROJECT_DIR \
    -part $FPGA_PART \
    -force

set_property target_language Verilog [current_project]

###############################################################################
# Generate Block Design
###############################################################################

puts "Generating Block Design..."

source $BD_SCRIPT

###############################################################################
# Validate / Save BD
###############################################################################

validate_bd_design
save_bd_design

set bd_file [get_files bd_system.bd]

generate_target all $bd_file

###############################################################################
# Add RTL Sources
###############################################################################

puts "Adding RTL Sources..."
	
add_files -norecurse \
    [glob $HDL_DIR/ANZVP1202SOM_top.sv]

###############################################################################
# Add Constraints
###############################################################################

puts "Adding Constraints..."

set xdc_files [concat \
    [glob -nocomplain "$CONSTRAINT_DIR/lpddr4.xdc"] \
    [glob -nocomplain "$CONSTRAINT_DIR/ANZVP1202SOM_interfaces.xdc"]]


if {[llength $xdc_files] > 0} {

    add_files -fileset constrs_1 $xdc_files

}

###############################################################################
# Set Top Module
###############################################################################

#make_wrapper -files [get_files bd_system.bd] -top
#add_files -norecurse \
#    ${PROJECT_DIR}/${PROJECT_NAME}.srcs/sources_1/bd/bd_system/hdl/bd_system_wrapper.v
#	
#set_property top bd_system_wrapper [current_fileset]


set_property top ANZVP1202SOM_top [current_fileset]

update_compile_order -fileset sources_1
###############################################################################
# Update Compile Order
###############################################################################
update_compile_order -fileset sources_1

###############################################################################
# Run Synthesis
###############################################################################
puts "================================================="
puts "Starting Synthesis"
puts "================================================="

launch_runs synth_1 -jobs 6
wait_on_run synth_1

###############################################################################
# Run Implementation
###############################################################################
puts "================================================="
puts "Starting Implementation"
puts "================================================="

launch_runs impl_1 -to_step write_bitstream -jobs 6
wait_on_run impl_1

###############################################################################
# Report Status
###############################################################################
set pdifile [glob -nocomplain \
    "$PROJECT_DIR/$PROJECT_NAME.runs/impl_1/*.pdi"]

puts ""
puts "================================================="
puts "Build Complete"
puts "================================================="

if {[llength $pdifile] > 0} {
    puts "Bitstream Generated:"
    puts [lindex $pdifile 0]
	file copy -force $pdifile $RELEASE_DIR
} else {
    puts "ERROR: Bitstream not generated!"
}

###############################################################################
# Generate XSA
###############################################################################

write_hw_platform \
    -fixed \
    -include_bit \
    -force \
    "$RELEASE_DIR/${PROJECT_NAME}.xsa"

puts "XSA Exported:"
puts "$RELEASE_DIR/${PROJECT_NAME}.xsa"
