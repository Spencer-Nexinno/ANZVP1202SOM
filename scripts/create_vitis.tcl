
###############################################################################
# Workspace
###############################################################################

setws "C:\FPGA_Proj\ANZVP1202SOM\workspace"

###############################################################################
# Platform
###############################################################################

if { [file exists "C:\FPGA_Proj\ANZVP1202SOM\workspace/anzvp1202_platform"] } {
    puts "Platform already exists"
} else {

    platform create \
        -name anzvp1202_platform \
        -hw "C:\FPGA_Proj\ANZVP1202SOM\release\ANZVP1202SOM_01.xsa"

    platform active anzvp1202_platform

    domain create \
        -name standalone_domain \
        -os standalone \
        -proc psv_cortexa72_0

    platform generate
}

###############################################################################
# Application
###############################################################################

if { [file exists "C:\FPGA_Proj\ANZVP1202SOM\workspace/board_test"] } {
    puts "Application already exists"
} else {

    app create \
        -name board_test \
        -platform anzvp1202_platform \
        -domain standalone_domain \
        -template "Empty Application"
}

###############################################################################
# Build
###############################################################################

app build -name board_test

exit
