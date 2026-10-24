
################################################################
# This is a generated script based on design: bd_system
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2025.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   if { [string compare $scripts_vivado_version $current_vivado_version] > 0 } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2042 -severity "ERROR" " This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Sourcing the script failed since it was created with a future version of Vivado."}

   } else {
     catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   }

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source bd_system_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcvp1202-vsva2785-1MP-i-S
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name bd_system

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:versal_cips:3.4\
xilinx.com:ip:axi_intc:4.1\
xilinx.com:ip:clk_wizard:1.0\
xilinx.com:ip:axi_noc:1.1\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:axi_uartlite:2.0\
xilinx.com:ip:gt_quad_base:1.1\
xilinx.com:ip:bufg_gt:1.0\
xilinx.com:ip:util_ds_buf:2.2\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: Serdes2
proc create_hier_cell_Serdes2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_Serdes2() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 AXI_LITE

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gt_rtl:1.0 bank106_GT_Serial

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 Bank106_GT_REFCLK


  # Create pins
  create_bd_pin -dir I -type clk s_axi_lite_clk

  # Create instance: gt_quad_base_0, and set properties
  set gt_quad_base_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:gt_quad_base:1.1 gt_quad_base_0 ]
  set_property -dict [list \
    CONFIG.APB3_CLK_FREQUENCY {156.248437} \
    CONFIG.CHANNEL_ORDERING {} \
    CONFIG.PORTS_INFO_DICT {LANE_SEL_DICT {PROT0 {RX0 RX1 RX2 RX3 TX0 TX1 TX2 TX3}} GT_TYPE GTYP REG_CONF_INTF AXI_LITE BOARD_PARAMETER { }} \
    CONFIG.PROT0_PRESET {GTYP-Ethernet_25G_RAW} \
    CONFIG.REFCLK_LIST {{/Bank200_GT_REFCLK_clk_p[0]}} \
    CONFIG.REFCLK_STRING {HSCLK0_LCPLLGTREFCLK0 refclk_PROT0_R0_156.25_MHz_unique1 HSCLK1_LCPLLGTREFCLK0 refclk_PROT0_R0_156.25_MHz_unique1} \
    CONFIG.REG_CONF_INTF {AXI_LITE} \
  ] $gt_quad_base_0

  set_property -dict [list \
    CONFIG.APB3_CLK_FREQUENCY.VALUE_MODE {auto} \
    CONFIG.CHANNEL_ORDERING.VALUE_MODE {auto} \
    CONFIG.REFCLK_LIST.VALUE_MODE {auto} \
  ] $gt_quad_base_0


  # Create instance: bank106_tx_bufg_gt, and set properties
  set bank106_tx_bufg_gt [ create_bd_cell -type ip -vlnv xilinx.com:ip:bufg_gt:1.0 bank106_tx_bufg_gt ]

  # Create instance: bank106_rx_bufg_gt, and set properties
  set bank106_rx_bufg_gt [ create_bd_cell -type ip -vlnv xilinx.com:ip:bufg_gt:1.0 bank106_rx_bufg_gt ]

  # Create instance: util_ds_buf_0, and set properties
  set util_ds_buf_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 util_ds_buf_0 ]
  set_property CONFIG.C_BUF_TYPE {IBUFDSGTE} $util_ds_buf_0


  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins gt_quad_base_0/AXI_LITE] [get_bd_intf_pins AXI_LITE]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins gt_quad_base_0/GT_Serial] [get_bd_intf_pins bank106_GT_Serial]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins util_ds_buf_0/CLK_IN_D] [get_bd_intf_pins Bank106_GT_REFCLK]

  # Create port connections
  connect_bd_net -net bufg_gt_0_usrclk  [get_bd_pins bank106_tx_bufg_gt/usrclk] \
  [get_bd_pins gt_quad_base_0/ch0_txusrclk] \
  [get_bd_pins gt_quad_base_0/ch1_txusrclk] \
  [get_bd_pins gt_quad_base_0/ch2_txusrclk] \
  [get_bd_pins gt_quad_base_0/ch3_txusrclk]
  connect_bd_net -net bufg_gt_0_usrclk1  [get_bd_pins bank106_rx_bufg_gt/usrclk] \
  [get_bd_pins gt_quad_base_0/ch0_rxusrclk] \
  [get_bd_pins gt_quad_base_0/ch1_rxusrclk] \
  [get_bd_pins gt_quad_base_0/ch2_rxusrclk] \
  [get_bd_pins gt_quad_base_0/ch3_rxusrclk]
  connect_bd_net -net gt_quad_base_0_ch0_rxoutclk  [get_bd_pins gt_quad_base_0/ch0_rxoutclk] \
  [get_bd_pins bank106_rx_bufg_gt/outclk]
  connect_bd_net -net gt_quad_base_0_ch0_txoutclk  [get_bd_pins gt_quad_base_0/ch0_txoutclk] \
  [get_bd_pins bank106_tx_bufg_gt/outclk]
  connect_bd_net -net s_axi_lite_clk_1  [get_bd_pins s_axi_lite_clk] \
  [get_bd_pins gt_quad_base_0/s_axi_lite_clk]
  connect_bd_net -net util_ds_buf_0_IBUF_OUT  [get_bd_pins util_ds_buf_0/IBUF_OUT] \
  [get_bd_pins gt_quad_base_0/GT_REFCLK0]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: Serdes1
proc create_hier_cell_Serdes1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_Serdes1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 AXI_LITE

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gt_rtl:1.0 bank_GTY_Serial

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 Bank_GTY_REFCLK


  # Create pins
  create_bd_pin -dir I -type clk s_axi_lite_clk

  # Create instance: gt_quad_base_0, and set properties
  set gt_quad_base_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:gt_quad_base:1.1 gt_quad_base_0 ]
  set_property -dict [list \
    CONFIG.APB3_CLK_FREQUENCY {156.248437} \
    CONFIG.CHANNEL_ORDERING {} \
    CONFIG.PORTS_INFO_DICT {LANE_SEL_DICT {PROT0 {RX0 RX1 RX2 RX3 TX0 TX1 TX2 TX3}} GT_TYPE GTYP REG_CONF_INTF AXI_LITE BOARD_PARAMETER { }} \
    CONFIG.PROT0_PRESET {GTYP-Ethernet_25G_RAW} \
    CONFIG.REFCLK_LIST {{/Bank106_GT_REFCLK_clk_p[0]}} \
    CONFIG.REFCLK_STRING {HSCLK0_LCPLLGTREFCLK0 refclk_PROT0_R0_156.25_MHz_unique1 HSCLK1_LCPLLGTREFCLK0 refclk_PROT0_R0_156.25_MHz_unique1} \
    CONFIG.REG_CONF_INTF {AXI_LITE} \
  ] $gt_quad_base_0

  set_property -dict [list \
    CONFIG.APB3_CLK_FREQUENCY.VALUE_MODE {auto} \
    CONFIG.CHANNEL_ORDERING.VALUE_MODE {auto} \
    CONFIG.REFCLK_LIST.VALUE_MODE {auto} \
  ] $gt_quad_base_0


  # Create instance: bank106_tx_bufg_gt, and set properties
  set bank106_tx_bufg_gt [ create_bd_cell -type ip -vlnv xilinx.com:ip:bufg_gt:1.0 bank106_tx_bufg_gt ]

  # Create instance: bank106_rx_bufg_gt, and set properties
  set bank106_rx_bufg_gt [ create_bd_cell -type ip -vlnv xilinx.com:ip:bufg_gt:1.0 bank106_rx_bufg_gt ]

  # Create instance: util_ds_buf_0, and set properties
  set util_ds_buf_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 util_ds_buf_0 ]
  set_property CONFIG.C_BUF_TYPE {IBUFDSGTE} $util_ds_buf_0


  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins gt_quad_base_0/AXI_LITE] [get_bd_intf_pins AXI_LITE]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins gt_quad_base_0/GT_Serial] [get_bd_intf_pins bank_GTY_Serial]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins util_ds_buf_0/CLK_IN_D] [get_bd_intf_pins Bank_GTY_REFCLK]

  # Create port connections
  connect_bd_net -net bufg_gt_0_usrclk  [get_bd_pins bank106_tx_bufg_gt/usrclk] \
  [get_bd_pins gt_quad_base_0/ch0_txusrclk] \
  [get_bd_pins gt_quad_base_0/ch1_txusrclk] \
  [get_bd_pins gt_quad_base_0/ch2_txusrclk] \
  [get_bd_pins gt_quad_base_0/ch3_txusrclk]
  connect_bd_net -net bufg_gt_0_usrclk1  [get_bd_pins bank106_rx_bufg_gt/usrclk] \
  [get_bd_pins gt_quad_base_0/ch0_rxusrclk] \
  [get_bd_pins gt_quad_base_0/ch1_rxusrclk] \
  [get_bd_pins gt_quad_base_0/ch2_rxusrclk] \
  [get_bd_pins gt_quad_base_0/ch3_rxusrclk]
  connect_bd_net -net gt_quad_base_0_ch0_rxoutclk  [get_bd_pins gt_quad_base_0/ch0_rxoutclk] \
  [get_bd_pins bank106_rx_bufg_gt/outclk]
  connect_bd_net -net gt_quad_base_0_ch0_txoutclk  [get_bd_pins gt_quad_base_0/ch0_txoutclk] \
  [get_bd_pins bank106_tx_bufg_gt/outclk]
  connect_bd_net -net s_axi_lite_clk_1  [get_bd_pins s_axi_lite_clk] \
  [get_bd_pins gt_quad_base_0/s_axi_lite_clk]
  connect_bd_net -net util_ds_buf_0_IBUF_OUT  [get_bd_pins util_ds_buf_0/IBUF_OUT] \
  [get_bd_pins gt_quad_base_0/GT_REFCLK0]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set LPDDR4_CLK1 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 LPDDR4_CLK1 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {200000000} \
   ] $LPDDR4_CLK1

  set TRIP2_CH0_LPDDR4 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:lpddr4_rtl:1.0 TRIP2_CH0_LPDDR4 ]

  set LPDDR4_CLK2 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 LPDDR4_CLK2 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {200000000} \
   ] $LPDDR4_CLK2

  set TRIP2_CH1_LPDDR4 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:lpddr4_rtl:1.0 TRIP2_CH1_LPDDR4 ]

  set TRIP1_CH0_LPDDR4 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:lpddr4_rtl:1.0 TRIP1_CH0_LPDDR4 ]

  set TRIP1_CH1_LPDDR4 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:lpddr4_rtl:1.0 TRIP1_CH1_LPDDR4 ]

  set TRIP3_CH0_LPDDR4 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:lpddr4_rtl:1.0 TRIP3_CH0_LPDDR4 ]

  set TRIP3_CH1_LPDDR4 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:lpddr4_rtl:1.0 TRIP3_CH1_LPDDR4 ]

  set LPDDR4_CLK3 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 LPDDR4_CLK3 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {200200000} \
   ] $LPDDR4_CLK3

  set bank106_GT_Serial [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gt_rtl:1.0 bank106_GT_Serial ]

  set PL_GPIO [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 PL_GPIO ]

  set PL_UART [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 PL_UART ]

  set Bank106_GT_REFCLK [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 Bank106_GT_REFCLK ]

  set bank200_GT_Serial [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gt_rtl:1.0 bank200_GT_Serial ]

  set Bank200_GT_REFCLK [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 Bank200_GT_REFCLK ]


  # Create ports

  # Create instance: CIPS_0, and set properties
  set CIPS_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:versal_cips:3.4 CIPS_0 ]
  set_property -dict [list \
    CONFIG.BOOT_MODE {Custom} \
    CONFIG.CLOCK_MODE {Custom} \
    CONFIG.DDR_MEMORY_MODE {Custom} \
    CONFIG.DEBUG_MODE {JTAG} \
    CONFIG.DESIGN_MODE {1} \
    CONFIG.IO_CONFIG_MODE {Custom} \
    CONFIG.PS_PL_CONNECTIVITY_MODE {Custom} \
    CONFIG.PS_PMC_CONFIG { \
      AURORA_LINE_RATE_GPBS {12.5} \
      BOOT_MODE {Custom} \
      BOOT_SECONDARY_PCIE_ENABLE {0} \
      CLOCK_MODE {Custom} \
      COHERENCY_MODE {Custom} \
      CPM_PCIE0_MODES {None} \
      CPM_PCIE0_PL_LINK_CAP_MAX_LINK_WIDTH {X4} \
      CPM_PCIE0_TANDEM {None} \
      CPM_PCIE1_MODES {None} \
      CPM_PCIE1_PL_LINK_CAP_MAX_LINK_WIDTH {X4} \
      DDR_MEMORY_MODE {Connectivity to DDR via NOC} \
      DEBUG_MODE {JTAG} \
      DESIGN_MODE {1} \
      DEVICE_INTEGRITY_MODE {Custom} \
      DIS_AUTO_POL_CHECK {0} \
      GT_REFCLK_MHZ {156.25} \
      INIT_CLK_MHZ {125} \
      INV_POLARITY {0} \
      IO_CONFIG_MODE {Custom} \
      JTAG_USERCODE {0x0} \
      OT_EAM_RESP {SRST} \
      PCIE_APERTURES_DUAL_ENABLE {0} \
      PCIE_APERTURES_SINGLE_ENABLE {0} \
      PERFORMANCE_MODE {Custom} \
      PL_SEM_GPIO_ENABLE {0} \
      PMC_ALT_REF_CLK_FREQMHZ {33.333} \
      PMC_BANK_0_IO_STANDARD {LVCMOS1.8} \
      PMC_BANK_1_IO_STANDARD {LVCMOS1.8} \
      PMC_CIPS_MODE {ADVANCE} \
      PMC_CLKMON0_CONFIG {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON0_CONFIG_1 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON0_CONFIG_2 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON0_CONFIG_3 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON1_CONFIG {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON1_CONFIG_1 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON1_CONFIG_2 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON1_CONFIG_3 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON2_CONFIG {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON2_CONFIG_1 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON2_CONFIG_2 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON2_CONFIG_3 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON3_CONFIG {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON3_CONFIG_1 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON3_CONFIG_2 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON3_CONFIG_3 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON4_CONFIG {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON4_CONFIG_1 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON4_CONFIG_2 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON4_CONFIG_3 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON5_CONFIG {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON5_CONFIG_1 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON5_CONFIG_2 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON5_CONFIG_3 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON6_CONFIG {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON6_CONFIG_1 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON6_CONFIG_2 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON6_CONFIG_3 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON7_CONFIG {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON7_CONFIG_1 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON7_CONFIG_2 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON7_CONFIG_3 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CORE_SUBSYSTEM_LOAD {10} \
      PMC_CRP_CFU_REF_CTRL_ACT_FREQMHZ {399.996002} \
      PMC_CRP_CFU_REF_CTRL_DIVISOR0 {3} \
      PMC_CRP_CFU_REF_CTRL_FREQMHZ {400} \
      PMC_CRP_CFU_REF_CTRL_SRCSEL {PPLL} \
      PMC_CRP_DFT_OSC_REF_CTRL_ACT_FREQMHZ {400} \
      PMC_CRP_DFT_OSC_REF_CTRL_DIVISOR0 {3} \
      PMC_CRP_DFT_OSC_REF_CTRL_FREQMHZ {400} \
      PMC_CRP_DFT_OSC_REF_CTRL_SRCSEL {PPLL} \
      PMC_CRP_EFUSE_REF_CTRL_ACT_FREQMHZ {100.000000} \
      PMC_CRP_EFUSE_REF_CTRL_FREQMHZ {100.000000} \
      PMC_CRP_EFUSE_REF_CTRL_SRCSEL {IRO_CLK/4} \
      PMC_CRP_HSM0_REF_CTRL_ACT_FREQMHZ {33.333000} \
      PMC_CRP_HSM0_REF_CTRL_DIVISOR0 {36} \
      PMC_CRP_HSM0_REF_CTRL_FREQMHZ {33.333} \
      PMC_CRP_HSM0_REF_CTRL_SRCSEL {PPLL} \
      PMC_CRP_HSM1_REF_CTRL_ACT_FREQMHZ {133.332001} \
      PMC_CRP_HSM1_REF_CTRL_DIVISOR0 {9} \
      PMC_CRP_HSM1_REF_CTRL_FREQMHZ {133.333} \
      PMC_CRP_HSM1_REF_CTRL_SRCSEL {PPLL} \
      PMC_CRP_I2C_REF_CTRL_ACT_FREQMHZ {100} \
      PMC_CRP_I2C_REF_CTRL_DIVISOR0 {12} \
      PMC_CRP_I2C_REF_CTRL_FREQMHZ {100} \
      PMC_CRP_I2C_REF_CTRL_SRCSEL {PPLL} \
      PMC_CRP_LSBUS_REF_CTRL_ACT_FREQMHZ {149.998505} \
      PMC_CRP_LSBUS_REF_CTRL_DIVISOR0 {8} \
      PMC_CRP_LSBUS_REF_CTRL_FREQMHZ {150} \
      PMC_CRP_LSBUS_REF_CTRL_SRCSEL {PPLL} \
      PMC_CRP_NOC_REF_CTRL_ACT_FREQMHZ {958.323730} \
      PMC_CRP_NOC_REF_CTRL_DIVISOR0 {1} \
      PMC_CRP_NOC_REF_CTRL_FREQMHZ {960} \
      PMC_CRP_NOC_REF_CTRL_SRCSEL {NPLL} \
      PMC_CRP_NPI_REF_CTRL_ACT_FREQMHZ {299.997009} \
      PMC_CRP_NPI_REF_CTRL_DIVISOR0 {4} \
      PMC_CRP_NPI_REF_CTRL_FREQMHZ {300} \
      PMC_CRP_NPI_REF_CTRL_SRCSEL {PPLL} \
      PMC_CRP_NPLL_CTRL_CLKOUTDIV {4} \
      PMC_CRP_NPLL_CTRL_FBDIV {115} \
      PMC_CRP_NPLL_CTRL_SRCSEL {REF_CLK} \
      PMC_CRP_NPLL_TO_XPD_CTRL_DIVISOR0 {4} \
      PMC_CRP_OSPI_REF_CTRL_ACT_FREQMHZ {200} \
      PMC_CRP_OSPI_REF_CTRL_DIVISOR0 {4} \
      PMC_CRP_OSPI_REF_CTRL_FREQMHZ {200} \
      PMC_CRP_OSPI_REF_CTRL_SRCSEL {PPLL} \
      PMC_CRP_PL0_REF_CTRL_ACT_FREQMHZ {99.999001} \
      PMC_CRP_PL0_REF_CTRL_DIVISOR0 {12} \
      PMC_CRP_PL0_REF_CTRL_FREQMHZ {99.999992} \
      PMC_CRP_PL0_REF_CTRL_SRCSEL {PPLL} \
      PMC_CRP_PL1_REF_CTRL_ACT_FREQMHZ {100} \
      PMC_CRP_PL1_REF_CTRL_DIVISOR0 {3} \
      PMC_CRP_PL1_REF_CTRL_FREQMHZ {320} \
      PMC_CRP_PL1_REF_CTRL_SRCSEL {NPLL} \
      PMC_CRP_PL2_REF_CTRL_ACT_FREQMHZ {100} \
      PMC_CRP_PL2_REF_CTRL_DIVISOR0 {3} \
      PMC_CRP_PL2_REF_CTRL_FREQMHZ {320} \
      PMC_CRP_PL2_REF_CTRL_SRCSEL {NPLL} \
      PMC_CRP_PL3_REF_CTRL_ACT_FREQMHZ {100} \
      PMC_CRP_PL3_REF_CTRL_DIVISOR0 {3} \
      PMC_CRP_PL3_REF_CTRL_FREQMHZ {320} \
      PMC_CRP_PL3_REF_CTRL_SRCSEL {NPLL} \
      PMC_CRP_PL5_REF_CTRL_FREQMHZ {400} \
      PMC_CRP_PPLL_CTRL_CLKOUTDIV {2} \
      PMC_CRP_PPLL_CTRL_FBDIV {72} \
      PMC_CRP_PPLL_CTRL_SRCSEL {REF_CLK} \
      PMC_CRP_PPLL_TO_XPD_CTRL_DIVISOR0 {1} \
      PMC_CRP_QSPI_REF_CTRL_ACT_FREQMHZ {299.997009} \
      PMC_CRP_QSPI_REF_CTRL_DIVISOR0 {4} \
      PMC_CRP_QSPI_REF_CTRL_FREQMHZ {300} \
      PMC_CRP_QSPI_REF_CTRL_SRCSEL {PPLL} \
      PMC_CRP_SDIO0_REF_CTRL_ACT_FREQMHZ {200} \
      PMC_CRP_SDIO0_REF_CTRL_DIVISOR0 {6} \
      PMC_CRP_SDIO0_REF_CTRL_FREQMHZ {200} \
      PMC_CRP_SDIO0_REF_CTRL_SRCSEL {PPLL} \
      PMC_CRP_SDIO1_REF_CTRL_ACT_FREQMHZ {199.998001} \
      PMC_CRP_SDIO1_REF_CTRL_DIVISOR0 {6} \
      PMC_CRP_SDIO1_REF_CTRL_FREQMHZ {200} \
      PMC_CRP_SDIO1_REF_CTRL_SRCSEL {PPLL} \
      PMC_CRP_SD_DLL_REF_CTRL_ACT_FREQMHZ {1199.988037} \
      PMC_CRP_SD_DLL_REF_CTRL_DIVISOR0 {1} \
      PMC_CRP_SD_DLL_REF_CTRL_FREQMHZ {1200} \
      PMC_CRP_SD_DLL_REF_CTRL_SRCSEL {PPLL} \
      PMC_CRP_SWITCH_TIMEOUT_CTRL_ACT_FREQMHZ {1.000000} \
      PMC_CRP_SWITCH_TIMEOUT_CTRL_DIVISOR0 {100} \
      PMC_CRP_SWITCH_TIMEOUT_CTRL_FREQMHZ {1} \
      PMC_CRP_SWITCH_TIMEOUT_CTRL_SRCSEL {IRO_CLK/4} \
      PMC_CRP_SYSMON_REF_CTRL_ACT_FREQMHZ {299.997009} \
      PMC_CRP_SYSMON_REF_CTRL_FREQMHZ {299.997009} \
      PMC_CRP_SYSMON_REF_CTRL_SRCSEL {NPI_REF_CLK} \
      PMC_CRP_TEST_PATTERN_REF_CTRL_ACT_FREQMHZ {200} \
      PMC_CRP_TEST_PATTERN_REF_CTRL_DIVISOR0 {6} \
      PMC_CRP_TEST_PATTERN_REF_CTRL_FREQMHZ {200} \
      PMC_CRP_TEST_PATTERN_REF_CTRL_SRCSEL {PPLL} \
      PMC_CRP_USB_SUSPEND_CTRL_ACT_FREQMHZ {0.200000} \
      PMC_CRP_USB_SUSPEND_CTRL_DIVISOR0 {500} \
      PMC_CRP_USB_SUSPEND_CTRL_FREQMHZ {0.2} \
      PMC_CRP_USB_SUSPEND_CTRL_SRCSEL {IRO_CLK/4} \
      PMC_EXTERNAL_TAMPER {{ENABLE 0} {IO {PMC_MIO 12}}} \
      PMC_EXTERNAL_TAMPER_1 {{ENABLE 0} {IO None}} \
      PMC_EXTERNAL_TAMPER_2 {{ENABLE 0} {IO None}} \
      PMC_EXTERNAL_TAMPER_3 {{ENABLE 0} {IO None}} \
      PMC_GLITCH_CONFIG {{DEPTH_SENSITIVITY 1} {MIN_PULSE_WIDTH 0.5} {TYPE EFUSE} {VCC_PMC_VALUE 0.80}} \
      PMC_GLITCH_CONFIG_1 {{DEPTH_SENSITIVITY 1} {MIN_PULSE_WIDTH 0.5} {TYPE EFUSE} {VCC_PMC_VALUE 0.80}} \
      PMC_GLITCH_CONFIG_2 {{DEPTH_SENSITIVITY 1} {MIN_PULSE_WIDTH 0.5} {TYPE EFUSE} {VCC_PMC_VALUE 0.80}} \
      PMC_GLITCH_CONFIG_3 {{DEPTH_SENSITIVITY 1} {MIN_PULSE_WIDTH 0.5} {TYPE EFUSE} {VCC_PMC_VALUE 0.80}} \
      PMC_GPIO0_MIO_PERIPHERAL {{ENABLE 0} {IO {PMC_MIO 0 .. 25}}} \
      PMC_GPIO1_MIO_PERIPHERAL {{ENABLE 0} {IO {PMC_MIO 26 .. 51}}} \
      PMC_GPIO_EMIO_PERIPHERAL_ENABLE {0} \
      PMC_GPIO_EMIO_WIDTH {64} \
      PMC_GPIO_EMIO_WIDTH_HDL {64} \
      PMC_GPI_ENABLE {0} \
      PMC_GPI_WIDTH {32} \
      PMC_GPO_ENABLE {0} \
      PMC_GPO_WIDTH {32} \
      PMC_HSM0_CLK_ENABLE {1} \
      PMC_HSM0_CLK_OUT_ENABLE {0} \
      PMC_HSM1_CLK_ENABLE {1} \
      PMC_HSM1_CLK_OUT_ENABLE {0} \
      PMC_I2CPMC_PERIPHERAL {{ENABLE 0} {IO {PMC_MIO 2 .. 3}}} \
      PMC_MIO0 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 12mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO1 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 12mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO10 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 12mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO11 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 12mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO12 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 12mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO13 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO14 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO15 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO16 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO17 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO18 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO19 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO2 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 12mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO20 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO21 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO22 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO23 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO24 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO25 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO26 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO27 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO28 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Unassigned}} \
      PMC_MIO29 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO3 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 12mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO30 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO31 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO32 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO33 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO34 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO35 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO36 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO37 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Unassigned}} \
      PMC_MIO38 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Unassigned}} \
      PMC_MIO39 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Unassigned}} \
      PMC_MIO4 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 12mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO40 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Unassigned}} \
      PMC_MIO41 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Unassigned}} \
      PMC_MIO42 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO43 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO44 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Unassigned}} \
      PMC_MIO45 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Unassigned}} \
      PMC_MIO46 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO47 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO48 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Unassigned}} \
      PMC_MIO49 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Unassigned}} \
      PMC_MIO5 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 12mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO50 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Unassigned}} \
      PMC_MIO51 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO6 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Unassigned}} \
      PMC_MIO7 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 12mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO8 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 12mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO9 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 12mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO_EN_FOR_PL_PCIE {0} \
      PMC_MIO_TREE_PERIPHERALS {QSPI#QSPI#QSPI#QSPI#QSPI#QSPI##QSPI#QSPI#QSPI#QSPI#QSPI#QSPI#USB 2.0#USB 2.0#USB 2.0#USB 2.0#USB 2.0#USB 2.0#USB 2.0#USB 2.0#USB 2.0#USB 2.0#USB 2.0#USB 2.0#USB 2.0#SD1/eMMC1#SD1/eMMC1##SD1/eMMC1#SD1/eMMC1#SD1/eMMC1#SD1/eMMC1#SD1/eMMC1#SD1/eMMC1#SD1/eMMC1#SD1/eMMC1######UART\
0#UART 0###LPD_I2C0#LPD_I2C0####SD1/eMMC1#Gem0#Gem0#Gem0#Gem0#Gem0#Gem0#Gem0#Gem0#Gem0#Gem0#Gem0#Gem0#SPI 0#SPI 0#SPI 0#SPI 0#SPI 0#SPI 0#######Gem0#Gem0} \
      PMC_MIO_TREE_SIGNALS {qspi0_clk#qspi0_io[1]#qspi0_io[2]#qspi0_io[3]#qspi0_io[0]#qspi0_cs_b##qspi1_cs_b#qspi1_io[0]#qspi1_io[1]#qspi1_io[2]#qspi1_io[3]#qspi1_clk#usb2phy_reset#ulpi_tx_data[0]#ulpi_tx_data[1]#ulpi_tx_data[2]#ulpi_tx_data[3]#ulpi_clk#ulpi_tx_data[4]#ulpi_tx_data[5]#ulpi_tx_data[6]#ulpi_tx_data[7]#ulpi_dir#ulpi_stp#ulpi_nxt#clk#dir1/data[7]##cmd#data[0]#data[1]#data[2]#data[3]#sel/data[4]#dir_cmd/data[5]#dir0/data[6]######rxd#txd###scl#sda####buspwr/rst#rgmii_tx_clk#rgmii_txd[0]#rgmii_txd[1]#rgmii_txd[2]#rgmii_txd[3]#rgmii_tx_ctl#rgmii_rx_clk#rgmii_rxd[0]#rgmii_rxd[1]#rgmii_rxd[2]#rgmii_rxd[3]#rgmii_rx_ctl#sclk#n_ss[2]#n_ss[1]#n_ss[0]#miso#mosi#######gem0_mdc#gem0_mdio}\
\
      PMC_NOC_PMC_ADDR_WIDTH {64} \
      PMC_NOC_PMC_DATA_WIDTH {128} \
      PMC_OSPI_COHERENCY {0} \
      PMC_OSPI_PERIPHERAL {{ENABLE 0} {IO {PMC_MIO 0 .. 11}} {MODE Single}} \
      PMC_OSPI_ROUTE_THROUGH_FPD {0} \
      PMC_OT_CHECK {{DELAY 0} {ENABLE 1}} \
      PMC_PL_ALT_REF_CLK_FREQMHZ {33.333} \
      PMC_PMC_NOC_ADDR_WIDTH {64} \
      PMC_PMC_NOC_DATA_WIDTH {128} \
      PMC_QSPI_BAUD_RATE_DIV {8} \
      PMC_QSPI_COHERENCY {0} \
      PMC_QSPI_FBCLK {{ENABLE 0} {IO {PMC_MIO 6}}} \
      PMC_QSPI_PERIPHERAL_DATA_MODE {x4} \
      PMC_QSPI_PERIPHERAL_ENABLE {1} \
      PMC_QSPI_PERIPHERAL_MODE {Dual Parallel} \
      PMC_QSPI_ROUTE_THROUGH_FPD {0} \
      PMC_RAM_CFU_REF_CTRL_CSCAN_ACT_FREQMHZ {100} \
      PMC_RAM_CFU_REF_CTRL_CSCAN_DIVISOR0 {3} \
      PMC_RAM_CFU_REF_CTRL_CSCAN_FREQMHZ {300} \
      PMC_RAM_CFU_REF_CTRL_CSCAN_SRCSEL {PPLL} \
      PMC_REF_CLK_FREQMHZ {33.333} \
      PMC_SD0 {{CD_ENABLE 0} {CD_IO {PMC_MIO 24}} {POW_ENABLE 0} {POW_IO {PMC_MIO 17}} {RESET_ENABLE 0} {RESET_IO {PMC_MIO 17}} {WP_ENABLE 0} {WP_IO {PMC_MIO 25}}} \
      PMC_SD0_COHERENCY {0} \
      PMC_SD0_DATA_TRANSFER_MODE {4Bit} \
      PMC_SD0_PERIPHERAL {{CLK_100_SDR_OTAP_DLY 0x00} {CLK_200_SDR_OTAP_DLY 0x00} {CLK_50_DDR_ITAP_DLY 0x00} {CLK_50_DDR_OTAP_DLY 0x00} {CLK_50_SDR_ITAP_DLY 0x00} {CLK_50_SDR_OTAP_DLY 0x00} {ENABLE 0}\
{IO {PMC_MIO 13 .. 25}}} \
      PMC_SD0_ROUTE_THROUGH_FPD {0} \
      PMC_SD0_SLOT_TYPE {SD 2.0} \
      PMC_SD0_SPEED_MODE {default speed} \
      PMC_SD1 {{CD_ENABLE 0} {CD_IO {PMC_MIO 2}} {POW_ENABLE 0} {POW_IO {PMC_MIO 12}} {RESET_ENABLE 1} {RESET_IO {PMC_MIO 51}} {WP_ENABLE 0} {WP_IO {PMC_MIO 1}}} \
      PMC_SD1_COHERENCY {0} \
      PMC_SD1_DATA_TRANSFER_MODE {8Bit} \
      PMC_SD1_PERIPHERAL {{CLK_100_SDR_OTAP_DLY 0x00} {CLK_200_SDR_OTAP_DLY 0x2} {CLK_50_DDR_ITAP_DLY 0x1E} {CLK_50_DDR_OTAP_DLY 0x5} {CLK_50_SDR_ITAP_DLY 0x2C} {CLK_50_SDR_OTAP_DLY 0x5} {ENABLE 1} {IO\
{PMC_MIO 26 .. 36}}} \
      PMC_SD1_ROUTE_THROUGH_FPD {0} \
      PMC_SD1_SLOT_TYPE {eMMC} \
      PMC_SD1_SPEED_MODE {high speed} \
      PMC_SHOW_CCI_SMMU_SETTINGS {0} \
      PMC_SMAP_PERIPHERAL {{ENABLE 0} {IO {32 Bit}}} \
      PMC_TAMPER_EXTMIO_ENABLE {0} \
      PMC_TAMPER_EXTMIO_ERASE_BBRAM {0} \
      PMC_TAMPER_EXTMIO_RESPONSE {SYS INTERRUPT} \
      PMC_TAMPER_GLITCHDETECT_ENABLE {0} \
      PMC_TAMPER_GLITCHDETECT_ENABLE_1 {0} \
      PMC_TAMPER_GLITCHDETECT_ENABLE_2 {0} \
      PMC_TAMPER_GLITCHDETECT_ENABLE_3 {0} \
      PMC_TAMPER_GLITCHDETECT_ERASE_BBRAM {0} \
      PMC_TAMPER_GLITCHDETECT_ERASE_BBRAM_1 {0} \
      PMC_TAMPER_GLITCHDETECT_ERASE_BBRAM_2 {0} \
      PMC_TAMPER_GLITCHDETECT_ERASE_BBRAM_3 {0} \
      PMC_TAMPER_GLITCHDETECT_RESPONSE {SYS INTERRUPT} \
      PMC_TAMPER_GLITCHDETECT_RESPONSE_1 {SYS INTERRUPT} \
      PMC_TAMPER_GLITCHDETECT_RESPONSE_2 {SYS INTERRUPT} \
      PMC_TAMPER_GLITCHDETECT_RESPONSE_3 {SYS INTERRUPT} \
      PMC_TAMPER_JTAGDETECT_ENABLE {0} \
      PMC_TAMPER_JTAGDETECT_ENABLE_1 {0} \
      PMC_TAMPER_JTAGDETECT_ENABLE_2 {0} \
      PMC_TAMPER_JTAGDETECT_ENABLE_3 {0} \
      PMC_TAMPER_JTAGDETECT_ERASE_BBRAM {0} \
      PMC_TAMPER_JTAGDETECT_ERASE_BBRAM_1 {0} \
      PMC_TAMPER_JTAGDETECT_ERASE_BBRAM_2 {0} \
      PMC_TAMPER_JTAGDETECT_ERASE_BBRAM_3 {0} \
      PMC_TAMPER_JTAGDETECT_RESPONSE {SYS INTERRUPT} \
      PMC_TAMPER_JTAGDETECT_RESPONSE_1 {SYS INTERRUPT} \
      PMC_TAMPER_JTAGDETECT_RESPONSE_2 {SYS INTERRUPT} \
      PMC_TAMPER_JTAGDETECT_RESPONSE_3 {SYS INTERRUPT} \
      PMC_TAMPER_SUP0 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 0} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP0_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 0} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP0_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 0} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP0_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 0} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 1} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP10 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 10} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP10_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 10} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP10_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 10} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP10_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 10} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP11 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 11} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP11_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 11} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP11_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 11} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP11_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 11} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP12 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 12} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP12_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 12} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP12_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 12} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP12_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 12} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP13 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 13} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP13_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 13} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP13_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 13} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP13_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 13} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP14 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 14} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP14_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 14} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP14_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 14} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP14_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 14} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP15 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 15} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP15_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 15} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP15_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 15} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP15_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 15} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP16 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 16} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP16_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 16} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP16_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 16} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP16_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 16} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP17 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 17} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP17_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 17} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP17_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 17} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP17_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 17} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP18 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 18} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP18_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 18} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP18_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 18} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP18_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 18} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP19 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 19} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP19_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 19} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP19_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 19} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP19_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 19} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP1_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 1} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP1_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 1} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP1_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 1} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 2} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP20 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 20} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP20_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 20} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP20_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 20} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP20_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 20} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP21 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 21} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP21_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 21} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP21_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 21} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP21_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 21} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP22 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 22} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP22_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 22} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP22_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 22} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP22_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 22} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP23 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 23} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP23_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 23} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP23_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 23} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP23_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 23} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP24 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 24} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP24_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 24} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP24_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 24} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP24_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 24} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP25 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 25} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP25_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 25} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP25_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 25} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP25_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 25} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP26 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 26} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP26_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 26} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP26_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 26} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP26_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 26} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP27 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 27} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP27_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 27} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP27_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 27} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP27_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 27} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP28 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 28} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP28_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 28} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP28_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 28} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP28_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 28} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP29 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 29} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP29_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 29} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP29_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 29} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP29_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 29} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP2_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 2} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP2_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 2} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP2_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 2} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 3} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP30 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 30} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP30_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 30} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP30_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 30} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP30_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 30} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP31 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 31} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP31_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 31} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP31_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 31} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP31_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 31} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP3_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 3} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP3_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 3} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP3_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 3} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP4 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 4} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP4_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 4} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP4_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 4} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP4_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 4} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP5 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 5} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP5_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 5} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP5_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 5} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP5_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 5} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP6 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 6} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP6_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 6} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP6_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 6} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP6_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 6} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP7 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 7} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP7_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 7} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP7_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 7} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP7_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 7} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP8 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 8} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP8_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 8} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP8_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 8} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP8_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 8} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP9 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 9} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP9_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 9} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP9_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 9} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP9_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 9} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP_0_31_ENABLE {0} \
      PMC_TAMPER_SUP_0_31_ENABLE_1 {0} \
      PMC_TAMPER_SUP_0_31_ENABLE_2 {0} \
      PMC_TAMPER_SUP_0_31_ENABLE_3 {0} \
      PMC_TAMPER_SUP_0_31_ERASE_BBRAM {0} \
      PMC_TAMPER_SUP_0_31_ERASE_BBRAM_1 {0} \
      PMC_TAMPER_SUP_0_31_ERASE_BBRAM_2 {0} \
      PMC_TAMPER_SUP_0_31_ERASE_BBRAM_3 {0} \
      PMC_TAMPER_SUP_0_31_RESPONSE {SYS INTERRUPT} \
      PMC_TAMPER_SUP_0_31_RESPONSE_1 {SYS INTERRUPT} \
      PMC_TAMPER_SUP_0_31_RESPONSE_2 {SYS INTERRUPT} \
      PMC_TAMPER_SUP_0_31_RESPONSE_3 {SYS INTERRUPT} \
      PMC_TAMPER_TEMPERATURE_ENABLE {0} \
      PMC_TAMPER_TEMPERATURE_ENABLE_1 {0} \
      PMC_TAMPER_TEMPERATURE_ENABLE_2 {0} \
      PMC_TAMPER_TEMPERATURE_ENABLE_3 {0} \
      PMC_TAMPER_TEMPERATURE_ERASE_BBRAM {0} \
      PMC_TAMPER_TEMPERATURE_ERASE_BBRAM_1 {0} \
      PMC_TAMPER_TEMPERATURE_ERASE_BBRAM_2 {0} \
      PMC_TAMPER_TEMPERATURE_ERASE_BBRAM_3 {0} \
      PMC_TAMPER_TEMPERATURE_RESPONSE {SYS INTERRUPT} \
      PMC_TAMPER_TEMPERATURE_RESPONSE_1 {SYS INTERRUPT} \
      PMC_TAMPER_TEMPERATURE_RESPONSE_2 {SYS INTERRUPT} \
      PMC_TAMPER_TEMPERATURE_RESPONSE_3 {SYS INTERRUPT} \
      PMC_USE_CFU_SEU {0} \
      PMC_USE_NOC_PMC_AXI0 {0} \
      PMC_USE_NOC_PMC_AXI1 {0} \
      PMC_USE_NOC_PMC_AXI2 {0} \
      PMC_USE_NOC_PMC_AXI3 {0} \
      PMC_USE_PL_PMC_AUX_REF_CLK {0} \
      PMC_USE_PMC_NOC_AXI0 {1} \
      PMC_USE_PMC_NOC_AXI1 {0} \
      PMC_USE_PMC_NOC_AXI2 {0} \
      PMC_USE_PMC_NOC_AXI3 {0} \
      PMC_WDT_PERIOD {100} \
      PMC_WDT_PERIPHERAL {{ENABLE 0} {IO {PMC_MIO 0}}} \
      POWER_REPORTING_MODE {Custom} \
      PSPMC_MANUAL_CLK_ENABLE {0} \
      PS_A72_ACTIVE_BLOCKS {2} \
      PS_A72_LOAD {90} \
      PS_BANK_2_IO_STANDARD {LVCMOS1.8} \
      PS_BANK_3_IO_STANDARD {LVCMOS1.8} \
      PS_BOARD_INTERFACE {Custom} \
      PS_CAN0_CLK {{ENABLE 0} {IO {PMC_MIO 0}}} \
      PS_CAN0_PERIPHERAL {{ENABLE 0} {IO {PMC_MIO 8 .. 9}}} \
      PS_CAN1_CLK {{ENABLE 0} {IO {PMC_MIO 0}}} \
      PS_CAN1_PERIPHERAL {{ENABLE 0} {IO {PS_MIO 16 .. 17}}} \
      PS_CRF_ACPU_CTRL_ACT_FREQMHZ {1299.987061} \
      PS_CRF_ACPU_CTRL_DIVISOR0 {1} \
      PS_CRF_ACPU_CTRL_FREQMHZ {1300} \
      PS_CRF_ACPU_CTRL_SRCSEL {APLL} \
      PS_CRF_APLL_CTRL_CLKOUTDIV {2} \
      PS_CRF_APLL_CTRL_FBDIV {78} \
      PS_CRF_APLL_CTRL_SRCSEL {REF_CLK} \
      PS_CRF_APLL_TO_XPD_CTRL_DIVISOR0 {4} \
      PS_CRF_DBG_FPD_CTRL_ACT_FREQMHZ {399.996002} \
      PS_CRF_DBG_FPD_CTRL_DIVISOR0 {3} \
      PS_CRF_DBG_FPD_CTRL_FREQMHZ {400} \
      PS_CRF_DBG_FPD_CTRL_SRCSEL {PPLL} \
      PS_CRF_DBG_TRACE_CTRL_ACT_FREQMHZ {300} \
      PS_CRF_DBG_TRACE_CTRL_DIVISOR0 {4} \
      PS_CRF_DBG_TRACE_CTRL_FREQMHZ {300} \
      PS_CRF_DBG_TRACE_CTRL_SRCSEL {PPLL} \
      PS_CRF_FPD_LSBUS_CTRL_ACT_FREQMHZ {149.998505} \
      PS_CRF_FPD_LSBUS_CTRL_DIVISOR0 {8} \
      PS_CRF_FPD_LSBUS_CTRL_FREQMHZ {150} \
      PS_CRF_FPD_LSBUS_CTRL_SRCSEL {PPLL} \
      PS_CRF_FPD_TOP_SWITCH_CTRL_ACT_FREQMHZ {749.992493} \
      PS_CRF_FPD_TOP_SWITCH_CTRL_DIVISOR0 {1} \
      PS_CRF_FPD_TOP_SWITCH_CTRL_FREQMHZ {800} \
      PS_CRF_FPD_TOP_SWITCH_CTRL_SRCSEL {RPLL} \
      PS_CRL_CAN0_REF_CTRL_ACT_FREQMHZ {100} \
      PS_CRL_CAN0_REF_CTRL_DIVISOR0 {6} \
      PS_CRL_CAN0_REF_CTRL_FREQMHZ {160} \
      PS_CRL_CAN0_REF_CTRL_SRCSEL {NPLL} \
      PS_CRL_CAN1_REF_CTRL_ACT_FREQMHZ {100} \
      PS_CRL_CAN1_REF_CTRL_DIVISOR0 {6} \
      PS_CRL_CAN1_REF_CTRL_FREQMHZ {160} \
      PS_CRL_CAN1_REF_CTRL_SRCSEL {NPLL} \
      PS_CRL_CPM_TOPSW_REF_CTRL_ACT_FREQMHZ {749.992493} \
      PS_CRL_CPM_TOPSW_REF_CTRL_DIVISOR0 {1} \
      PS_CRL_CPM_TOPSW_REF_CTRL_FREQMHZ {750} \
      PS_CRL_CPM_TOPSW_REF_CTRL_SRCSEL {RPLL} \
      PS_CRL_CPU_R5_CTRL_ACT_FREQMHZ {599.994019} \
      PS_CRL_CPU_R5_CTRL_DIVISOR0 {2} \
      PS_CRL_CPU_R5_CTRL_FREQMHZ {600} \
      PS_CRL_CPU_R5_CTRL_SRCSEL {PPLL} \
      PS_CRL_DBG_LPD_CTRL_ACT_FREQMHZ {399.996002} \
      PS_CRL_DBG_LPD_CTRL_DIVISOR0 {3} \
      PS_CRL_DBG_LPD_CTRL_FREQMHZ {400} \
      PS_CRL_DBG_LPD_CTRL_SRCSEL {PPLL} \
      PS_CRL_DBG_TSTMP_CTRL_ACT_FREQMHZ {399.996002} \
      PS_CRL_DBG_TSTMP_CTRL_DIVISOR0 {3} \
      PS_CRL_DBG_TSTMP_CTRL_FREQMHZ {400} \
      PS_CRL_DBG_TSTMP_CTRL_SRCSEL {PPLL} \
      PS_CRL_GEM0_REF_CTRL_ACT_FREQMHZ {124.998749} \
      PS_CRL_GEM0_REF_CTRL_DIVISOR0 {6} \
      PS_CRL_GEM0_REF_CTRL_FREQMHZ {125} \
      PS_CRL_GEM0_REF_CTRL_SRCSEL {RPLL} \
      PS_CRL_GEM1_REF_CTRL_ACT_FREQMHZ {125} \
      PS_CRL_GEM1_REF_CTRL_DIVISOR0 {12} \
      PS_CRL_GEM1_REF_CTRL_FREQMHZ {125} \
      PS_CRL_GEM1_REF_CTRL_SRCSEL {RPLL} \
      PS_CRL_GEM_TSU_REF_CTRL_ACT_FREQMHZ {249.997498} \
      PS_CRL_GEM_TSU_REF_CTRL_DIVISOR0 {3} \
      PS_CRL_GEM_TSU_REF_CTRL_FREQMHZ {250} \
      PS_CRL_GEM_TSU_REF_CTRL_SRCSEL {RPLL} \
      PS_CRL_I2C0_REF_CTRL_ACT_FREQMHZ {99.999001} \
      PS_CRL_I2C0_REF_CTRL_DIVISOR0 {12} \
      PS_CRL_I2C0_REF_CTRL_FREQMHZ {100} \
      PS_CRL_I2C0_REF_CTRL_SRCSEL {PPLL} \
      PS_CRL_I2C1_REF_CTRL_ACT_FREQMHZ {100} \
      PS_CRL_I2C1_REF_CTRL_DIVISOR0 {12} \
      PS_CRL_I2C1_REF_CTRL_FREQMHZ {100} \
      PS_CRL_I2C1_REF_CTRL_SRCSEL {PPLL} \
      PS_CRL_IOU_SWITCH_CTRL_ACT_FREQMHZ {249.997498} \
      PS_CRL_IOU_SWITCH_CTRL_DIVISOR0 {3} \
      PS_CRL_IOU_SWITCH_CTRL_FREQMHZ {250} \
      PS_CRL_IOU_SWITCH_CTRL_SRCSEL {RPLL} \
      PS_CRL_LPD_LSBUS_CTRL_ACT_FREQMHZ {149.998505} \
      PS_CRL_LPD_LSBUS_CTRL_DIVISOR0 {8} \
      PS_CRL_LPD_LSBUS_CTRL_FREQMHZ {150} \
      PS_CRL_LPD_LSBUS_CTRL_SRCSEL {PPLL} \
      PS_CRL_LPD_TOP_SWITCH_CTRL_ACT_FREQMHZ {599.994019} \
      PS_CRL_LPD_TOP_SWITCH_CTRL_DIVISOR0 {2} \
      PS_CRL_LPD_TOP_SWITCH_CTRL_FREQMHZ {600} \
      PS_CRL_LPD_TOP_SWITCH_CTRL_SRCSEL {PPLL} \
      PS_CRL_PSM_REF_CTRL_ACT_FREQMHZ {399.996002} \
      PS_CRL_PSM_REF_CTRL_DIVISOR0 {3} \
      PS_CRL_PSM_REF_CTRL_FREQMHZ {400} \
      PS_CRL_PSM_REF_CTRL_SRCSEL {PPLL} \
      PS_CRL_RPLL_CTRL_CLKOUTDIV {4} \
      PS_CRL_RPLL_CTRL_FBDIV {90} \
      PS_CRL_RPLL_CTRL_SRCSEL {REF_CLK} \
      PS_CRL_RPLL_TO_XPD_CTRL_DIVISOR0 {1} \
      PS_CRL_SPI0_REF_CTRL_ACT_FREQMHZ {199.998001} \
      PS_CRL_SPI0_REF_CTRL_DIVISOR0 {6} \
      PS_CRL_SPI0_REF_CTRL_FREQMHZ {200} \
      PS_CRL_SPI0_REF_CTRL_SRCSEL {PPLL} \
      PS_CRL_SPI1_REF_CTRL_ACT_FREQMHZ {200} \
      PS_CRL_SPI1_REF_CTRL_DIVISOR0 {6} \
      PS_CRL_SPI1_REF_CTRL_FREQMHZ {200} \
      PS_CRL_SPI1_REF_CTRL_SRCSEL {PPLL} \
      PS_CRL_TIMESTAMP_REF_CTRL_ACT_FREQMHZ {99.999001} \
      PS_CRL_TIMESTAMP_REF_CTRL_DIVISOR0 {12} \
      PS_CRL_TIMESTAMP_REF_CTRL_FREQMHZ {100} \
      PS_CRL_TIMESTAMP_REF_CTRL_SRCSEL {PPLL} \
      PS_CRL_UART0_REF_CTRL_ACT_FREQMHZ {99.999001} \
      PS_CRL_UART0_REF_CTRL_DIVISOR0 {12} \
      PS_CRL_UART0_REF_CTRL_FREQMHZ {100} \
      PS_CRL_UART0_REF_CTRL_SRCSEL {PPLL} \
      PS_CRL_UART1_REF_CTRL_ACT_FREQMHZ {100} \
      PS_CRL_UART1_REF_CTRL_DIVISOR0 {12} \
      PS_CRL_UART1_REF_CTRL_FREQMHZ {100} \
      PS_CRL_UART1_REF_CTRL_SRCSEL {PPLL} \
      PS_CRL_USB0_BUS_REF_CTRL_ACT_FREQMHZ {19.999800} \
      PS_CRL_USB0_BUS_REF_CTRL_DIVISOR0 {60} \
      PS_CRL_USB0_BUS_REF_CTRL_FREQMHZ {20} \
      PS_CRL_USB0_BUS_REF_CTRL_SRCSEL {PPLL} \
      PS_CRL_USB3_DUAL_REF_CTRL_ACT_FREQMHZ {20} \
      PS_CRL_USB3_DUAL_REF_CTRL_DIVISOR0 {60} \
      PS_CRL_USB3_DUAL_REF_CTRL_FREQMHZ {10} \
      PS_CRL_USB3_DUAL_REF_CTRL_SRCSEL {PPLL} \
      PS_DDRC_ENABLE {1} \
      PS_DDR_RAM_HIGHADDR_OFFSET {0x800000000} \
      PS_DDR_RAM_LOWADDR_OFFSET {0x80000000} \
      PS_ENET0_MDIO {{ENABLE 1} {IO {PS_MIO 24 .. 25}}} \
      PS_ENET0_PERIPHERAL {{ENABLE 1} {IO {PS_MIO 0 .. 11}}} \
      PS_ENET1_MDIO {{ENABLE 0} {IO {PMC_MIO 50 .. 51}}} \
      PS_ENET1_PERIPHERAL {{ENABLE 0} {IO {PMC_MIO 38 .. 49}}} \
      PS_EN_AXI_STATUS_PORTS {0} \
      PS_EN_PORTS_CONTROLLER_BASED {0} \
      PS_EXPAND_CORESIGHT {0} \
      PS_EXPAND_FPD_SLAVES {0} \
      PS_EXPAND_GIC {0} \
      PS_EXPAND_LPD_SLAVES {0} \
      PS_FPD_INTERCONNECT_LOAD {90} \
      PS_FTM_CTI_IN0 {0} \
      PS_FTM_CTI_IN1 {0} \
      PS_FTM_CTI_IN2 {0} \
      PS_FTM_CTI_IN3 {0} \
      PS_FTM_CTI_OUT0 {0} \
      PS_FTM_CTI_OUT1 {0} \
      PS_FTM_CTI_OUT2 {0} \
      PS_FTM_CTI_OUT3 {0} \
      PS_GEM0_COHERENCY {0} \
      PS_GEM0_ROUTE_THROUGH_FPD {0} \
      PS_GEM0_TSU_INC_CTRL {3} \
      PS_GEM1_COHERENCY {0} \
      PS_GEM1_ROUTE_THROUGH_FPD {0} \
      PS_GEM_TSU {{ENABLE 0} {IO {PS_MIO 24}}} \
      PS_GEM_TSU_CLK_PORT_PAIR {0} \
      PS_GEN_IPI0_ENABLE {1} \
      PS_GEN_IPI0_MASTER {A72} \
      PS_GEN_IPI1_ENABLE {1} \
      PS_GEN_IPI1_MASTER {A72} \
      PS_GEN_IPI2_ENABLE {1} \
      PS_GEN_IPI2_MASTER {A72} \
      PS_GEN_IPI3_ENABLE {1} \
      PS_GEN_IPI3_MASTER {A72} \
      PS_GEN_IPI4_ENABLE {1} \
      PS_GEN_IPI4_MASTER {A72} \
      PS_GEN_IPI5_ENABLE {1} \
      PS_GEN_IPI5_MASTER {A72} \
      PS_GEN_IPI6_ENABLE {1} \
      PS_GEN_IPI6_MASTER {A72} \
      PS_GEN_IPI_PMCNOBUF_ENABLE {1} \
      PS_GEN_IPI_PMCNOBUF_MASTER {PMC} \
      PS_GEN_IPI_PMC_ENABLE {1} \
      PS_GEN_IPI_PMC_MASTER {PMC} \
      PS_GEN_IPI_PSM_ENABLE {1} \
      PS_GEN_IPI_PSM_MASTER {PSM} \
      PS_GPIO2_MIO_PERIPHERAL {{ENABLE 0} {IO {PS_MIO 0 .. 25}}} \
      PS_GPIO_EMIO_PERIPHERAL_ENABLE {0} \
      PS_GPIO_EMIO_WIDTH {32} \
      PS_HSDP0_REFCLK {0} \
      PS_HSDP1_REFCLK {0} \
      PS_HSDP_EGRESS_TRAFFIC {JTAG} \
      PS_HSDP_INGRESS_TRAFFIC {JTAG} \
      PS_HSDP_MODE {NONE} \
      PS_HSDP_SAME_EGRESS_AS_INGRESS_TRAFFIC {1} \
      PS_I2C0_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 46 .. 47}}} \
      PS_I2C1_PERIPHERAL {{ENABLE 0} {IO {PS_MIO 0 .. 1}}} \
      PS_I2CSYSMON_PERIPHERAL {{ENABLE 0} {IO {PS_MIO 23 .. 24}}} \
      PS_IRQ_USAGE {{CH0 1} {CH1 0} {CH10 0} {CH11 0} {CH12 0} {CH13 0} {CH14 0} {CH15 0} {CH2 0} {CH3 0} {CH4 0} {CH5 0} {CH6 0} {CH7 0} {CH8 0} {CH9 0}} \
      PS_KAT_ENABLE {1} \
      PS_KAT_ENABLE_1 {1} \
      PS_KAT_ENABLE_2 {1} \
      PS_KAT_ENABLE_3 {1} \
      PS_LPDMA0_COHERENCY {0} \
      PS_LPDMA0_ROUTE_THROUGH_FPD {0} \
      PS_LPDMA1_COHERENCY {0} \
      PS_LPDMA1_ROUTE_THROUGH_FPD {0} \
      PS_LPDMA2_COHERENCY {0} \
      PS_LPDMA2_ROUTE_THROUGH_FPD {0} \
      PS_LPDMA3_COHERENCY {0} \
      PS_LPDMA3_ROUTE_THROUGH_FPD {0} \
      PS_LPDMA4_COHERENCY {0} \
      PS_LPDMA4_ROUTE_THROUGH_FPD {0} \
      PS_LPDMA5_COHERENCY {0} \
      PS_LPDMA5_ROUTE_THROUGH_FPD {0} \
      PS_LPDMA6_COHERENCY {0} \
      PS_LPDMA6_ROUTE_THROUGH_FPD {0} \
      PS_LPDMA7_COHERENCY {0} \
      PS_LPDMA7_ROUTE_THROUGH_FPD {0} \
      PS_LPD_DMA_CHANNEL_ENABLE {{CH0 0} {CH1 0} {CH2 0} {CH3 0} {CH4 0} {CH5 0} {CH6 0} {CH7 0}} \
      PS_LPD_DMA_CH_TZ {{CH0 NonSecure} {CH1 NonSecure} {CH2 NonSecure} {CH3 NonSecure} {CH4 NonSecure} {CH5 NonSecure} {CH6 NonSecure} {CH7 NonSecure}} \
      PS_LPD_DMA_ENABLE {0} \
      PS_LPD_INTERCONNECT_LOAD {90} \
      PS_MIO0 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PS_MIO1 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PS_MIO10 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO11 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO12 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO13 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PS_MIO14 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PS_MIO15 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO16 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO17 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO18 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Unassigned}} \
      PS_MIO19 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Unassigned}} \
      PS_MIO2 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PS_MIO20 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Unassigned}} \
      PS_MIO21 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Unassigned}} \
      PS_MIO22 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Unassigned}} \
      PS_MIO23 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Unassigned}} \
      PS_MIO24 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PS_MIO25 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO3 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PS_MIO4 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PS_MIO5 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PS_MIO6 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO7 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO8 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO9 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_M_AXI_FPD_DATA_WIDTH {128} \
      PS_M_AXI_GP4_DATA_WIDTH {128} \
      PS_M_AXI_LPD_DATA_WIDTH {128} \
      PS_NOC_PS_CCI_DATA_WIDTH {128} \
      PS_NOC_PS_NCI_DATA_WIDTH {128} \
      PS_NOC_PS_PCI_DATA_WIDTH {128} \
      PS_NOC_PS_PMC_DATA_WIDTH {128} \
      PS_NUM_F2P0_INTR_INPUTS {1} \
      PS_NUM_F2P1_INTR_INPUTS {1} \
      PS_NUM_FABRIC_RESETS {1} \
      PS_OCM_ACTIVE_BLOCKS {1} \
      PS_PCIE1_PERIPHERAL_ENABLE {0} \
      PS_PCIE2_PERIPHERAL_ENABLE {0} \
      PS_PCIE_EP_RESET1_IO {None} \
      PS_PCIE_EP_RESET2_IO {None} \
      PS_PCIE_PERIPHERAL_ENABLE {0} \
      PS_PCIE_RESET {ENABLE 0} \
      PS_PCIE_ROOT_RESET1_IO {None} \
      PS_PCIE_ROOT_RESET1_IO_DIR {output} \
      PS_PCIE_ROOT_RESET1_POLARITY {Active Low} \
      PS_PCIE_ROOT_RESET2_IO {None} \
      PS_PCIE_ROOT_RESET2_IO_DIR {output} \
      PS_PCIE_ROOT_RESET2_POLARITY {Active Low} \
      PS_PL_CONNECTIVITY_MODE {Custom} \
      PS_PL_DONE {0} \
      PS_PL_PASS_AXPROT_VALUE {0} \
      PS_PMCPL_CLK0_BUF {1} \
      PS_PMCPL_CLK1_BUF {1} \
      PS_PMCPL_CLK2_BUF {1} \
      PS_PMCPL_CLK3_BUF {1} \
      PS_PMCPL_IRO_CLK_BUF {1} \
      PS_PMU_PERIPHERAL_ENABLE {0} \
      PS_PS_ENABLE {0} \
      PS_PS_NOC_CCI_DATA_WIDTH {128} \
      PS_PS_NOC_NCI_DATA_WIDTH {128} \
      PS_PS_NOC_PCI_DATA_WIDTH {128} \
      PS_PS_NOC_PMC_DATA_WIDTH {128} \
      PS_PS_NOC_RPU_DATA_WIDTH {128} \
      PS_R5_ACTIVE_BLOCKS {2} \
      PS_R5_LOAD {90} \
      PS_RED_KEY_CLEAR_ENABLE {0} \
      PS_RED_KEY_CLEAR_ENABLE_1 {0} \
      PS_RED_KEY_CLEAR_ENABLE_2 {0} \
      PS_RED_KEY_CLEAR_ENABLE_3 {0} \
      PS_RPU_COHERENCY {0} \
      PS_SLR_TYPE {master} \
      PS_SMON_PL_PORTS_ENABLE {0} \
      PS_SPI0 {{GRP_SS0_ENABLE 1} {GRP_SS0_IO {PS_MIO 15}} {GRP_SS1_ENABLE 1} {GRP_SS1_IO {PS_MIO 14}} {GRP_SS2_ENABLE 1} {GRP_SS2_IO {PS_MIO 13}} {PERIPHERAL_ENABLE 1} {PERIPHERAL_IO {PS_MIO 12 .. 17}}}\
\
      PS_SPI1 {{GRP_SS0_ENABLE 0} {GRP_SS0_IO {PS_MIO 9}} {GRP_SS1_ENABLE 0} {GRP_SS1_IO {PS_MIO 8}} {GRP_SS2_ENABLE 0} {GRP_SS2_IO {PS_MIO 7}} {PERIPHERAL_ENABLE 0} {PERIPHERAL_IO {PS_MIO 6 .. 11}}} \
      PS_S_AXI_ACE_DATA_WIDTH {128} \
      PS_S_AXI_ACP_DATA_WIDTH {128} \
      PS_S_AXI_FPD_DATA_WIDTH {128} \
      PS_S_AXI_GP2_DATA_WIDTH {128} \
      PS_S_AXI_LPD_DATA_WIDTH {128} \
      PS_TCM_ACTIVE_BLOCKS {2} \
      PS_TIE_MJTAG_TCK_TO_GND {1} \
      PS_TRACE_PERIPHERAL {{ENABLE 0} {IO {PMC_MIO 30 .. 47}}} \
      PS_TRACE_WIDTH {2Bit} \
      PS_TRISTATE_INVERTED {1} \
      PS_TTC0_CLK {{ENABLE 0} {IO {PS_MIO 6}}} \
      PS_TTC0_PERIPHERAL_ENABLE {1} \
      PS_TTC0_REF_CTRL_ACT_FREQMHZ {149.998505} \
      PS_TTC0_REF_CTRL_FREQMHZ {149.998505} \
      PS_TTC0_WAVEOUT {{ENABLE 0} {IO {PS_MIO 7}}} \
      PS_TTC1_CLK {{ENABLE 0} {IO {PS_MIO 12}}} \
      PS_TTC1_PERIPHERAL_ENABLE {0} \
      PS_TTC1_REF_CTRL_ACT_FREQMHZ {50} \
      PS_TTC1_REF_CTRL_FREQMHZ {50} \
      PS_TTC1_WAVEOUT {{ENABLE 0} {IO {PS_MIO 13}}} \
      PS_TTC2_CLK {{ENABLE 0} {IO {PS_MIO 2}}} \
      PS_TTC2_PERIPHERAL_ENABLE {0} \
      PS_TTC2_REF_CTRL_ACT_FREQMHZ {50} \
      PS_TTC2_REF_CTRL_FREQMHZ {50} \
      PS_TTC2_WAVEOUT {{ENABLE 0} {IO {PS_MIO 3}}} \
      PS_TTC3_CLK {{ENABLE 0} {IO {PS_MIO 16}}} \
      PS_TTC3_PERIPHERAL_ENABLE {0} \
      PS_TTC3_REF_CTRL_ACT_FREQMHZ {50} \
      PS_TTC3_REF_CTRL_FREQMHZ {50} \
      PS_TTC3_WAVEOUT {{ENABLE 0} {IO {PS_MIO 17}}} \
      PS_TTC_APB_CLK_TTC0_SEL {APB} \
      PS_TTC_APB_CLK_TTC1_SEL {APB} \
      PS_TTC_APB_CLK_TTC2_SEL {APB} \
      PS_TTC_APB_CLK_TTC3_SEL {APB} \
      PS_UART0_BAUD_RATE {115200} \
      PS_UART0_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 42 .. 43}}} \
      PS_UART0_RTS_CTS {{ENABLE 0} {IO {PS_MIO 2 .. 3}}} \
      PS_UART1_BAUD_RATE {115200} \
      PS_UART1_PERIPHERAL {{ENABLE 0} {IO {PMC_MIO 4 .. 5}}} \
      PS_UART1_RTS_CTS {{ENABLE 0} {IO {PMC_MIO 6 .. 7}}} \
      PS_UNITS_MODE {Custom} \
      PS_USB3_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 13 .. 25}}} \
      PS_USB_COHERENCY {0} \
      PS_USB_ROUTE_THROUGH_FPD {0} \
      PS_USE_ACE_LITE {0} \
      PS_USE_APU_EVENT_BUS {0} \
      PS_USE_APU_INTERRUPT {0} \
      PS_USE_AXI4_EXT_USER_BITS {0} \
      PS_USE_BSCAN_USER1 {0} \
      PS_USE_BSCAN_USER2 {0} \
      PS_USE_BSCAN_USER3 {0} \
      PS_USE_BSCAN_USER4 {0} \
      PS_USE_CAPTURE {0} \
      PS_USE_CLK {0} \
      PS_USE_DEBUG_TEST {0} \
      PS_USE_DIFF_RW_CLK_S_AXI_FPD {0} \
      PS_USE_DIFF_RW_CLK_S_AXI_GP2 {0} \
      PS_USE_DIFF_RW_CLK_S_AXI_LPD {0} \
      PS_USE_ENET0_PTP {0} \
      PS_USE_ENET1_PTP {0} \
      PS_USE_FIFO_ENET0 {0} \
      PS_USE_FIFO_ENET1 {0} \
      PS_USE_FIXED_IO {0} \
      PS_USE_FPD_AXI_NOC0 {1} \
      PS_USE_FPD_AXI_NOC1 {1} \
      PS_USE_FPD_CCI_NOC {1} \
      PS_USE_FPD_CCI_NOC0 {1} \
      PS_USE_FPD_CCI_NOC1 {0} \
      PS_USE_FPD_CCI_NOC2 {0} \
      PS_USE_FPD_CCI_NOC3 {0} \
      PS_USE_FTM_GPI {0} \
      PS_USE_FTM_GPO {0} \
      PS_USE_HSDP_PL {0} \
      PS_USE_MJTAG_TCK_TIE_OFF {0} \
      PS_USE_M_AXI_FPD {1} \
      PS_USE_M_AXI_LPD {0} \
      PS_USE_NOC_FPD_AXI0 {0} \
      PS_USE_NOC_FPD_AXI1 {0} \
      PS_USE_NOC_FPD_CCI0 {0} \
      PS_USE_NOC_FPD_CCI1 {0} \
      PS_USE_NOC_LPD_AXI0 {1} \
      PS_USE_NOC_PS_PCI_0 {0} \
      PS_USE_NOC_PS_PMC_0 {0} \
      PS_USE_NPI_CLK {0} \
      PS_USE_NPI_RST {0} \
      PS_USE_PL_FPD_AUX_REF_CLK {0} \
      PS_USE_PL_LPD_AUX_REF_CLK {0} \
      PS_USE_PMC {0} \
      PS_USE_PMCPL_CLK0 {1} \
      PS_USE_PMCPL_CLK1 {0} \
      PS_USE_PMCPL_CLK2 {0} \
      PS_USE_PMCPL_CLK3 {0} \
      PS_USE_PMCPL_IRO_CLK {0} \
      PS_USE_PSPL_IRQ_FPD {0} \
      PS_USE_PSPL_IRQ_LPD {0} \
      PS_USE_PSPL_IRQ_PMC {0} \
      PS_USE_PS_NOC_PCI_0 {0} \
      PS_USE_PS_NOC_PCI_1 {0} \
      PS_USE_PS_NOC_PMC_0 {0} \
      PS_USE_PS_NOC_PMC_1 {0} \
      PS_USE_RPU_EVENT {0} \
      PS_USE_RPU_INTERRUPT {0} \
      PS_USE_RTC {0} \
      PS_USE_SMMU {0} \
      PS_USE_STARTUP {0} \
      PS_USE_STM {0} \
      PS_USE_S_ACP_FPD {0} \
      PS_USE_S_AXI_ACE {0} \
      PS_USE_S_AXI_FPD {0} \
      PS_USE_S_AXI_GP2 {0} \
      PS_USE_S_AXI_LPD {0} \
      PS_USE_TRACE_ATB {0} \
      PS_WDT0_REF_CTRL_ACT_FREQMHZ {100} \
      PS_WDT0_REF_CTRL_FREQMHZ {100} \
      PS_WDT0_REF_CTRL_SEL {NONE} \
      PS_WDT1_REF_CTRL_ACT_FREQMHZ {100} \
      PS_WDT1_REF_CTRL_FREQMHZ {100} \
      PS_WDT1_REF_CTRL_SEL {NONE} \
      PS_WWDT0_CLK {{ENABLE 0} {IO {PMC_MIO 0}}} \
      PS_WWDT0_PERIPHERAL {{ENABLE 0} {IO {PMC_MIO 0 .. 5}}} \
      PS_WWDT1_CLK {{ENABLE 0} {IO {PMC_MIO 6}}} \
      PS_WWDT1_PERIPHERAL {{ENABLE 0} {IO {PMC_MIO 6 .. 11}}} \
      SEM_ERROR_HANDLE_OPTIONS {Detect & Correct} \
      SEM_EVENT_LOG_OPTIONS {Log & Notify} \
      SEM_MEM_BUILT_IN_SELF_TEST {0} \
      SEM_MEM_ENABLE_ALL_TEST_FEATURE {0} \
      SEM_MEM_ENABLE_SCAN_AFTER {Immediate Start} \
      SEM_MEM_GOLDEN_ECC {0} \
      SEM_MEM_GOLDEN_ECC_SW {0} \
      SEM_MEM_SCAN {0} \
      SEM_NPI_BUILT_IN_SELF_TEST {0} \
      SEM_NPI_ENABLE_ALL_TEST_FEATURE {0} \
      SEM_NPI_ENABLE_SCAN_AFTER {Immediate Start} \
      SEM_NPI_GOLDEN_CHECKSUM_SW {0} \
      SEM_NPI_SCAN {0} \
      SEM_TIME_INTERVAL_BETWEEN_SCANS {80} \
      SLR1_PMC_CRP_HSM0_REF_CTRL_ACT_FREQMHZ {99.999} \
      SLR1_PMC_CRP_HSM0_REF_CTRL_DIVISOR0 {12} \
      SLR1_PMC_CRP_HSM0_REF_CTRL_FREQMHZ {100} \
      SLR1_PMC_CRP_HSM0_REF_CTRL_SRCSEL {PPLL} \
      SLR1_PMC_CRP_HSM1_REF_CTRL_ACT_FREQMHZ {33.33} \
      SLR1_PMC_CRP_HSM1_REF_CTRL_DIVISOR0 {36} \
      SLR1_PMC_CRP_HSM1_REF_CTRL_FREQMHZ {33.333} \
      SLR1_PMC_CRP_HSM1_REF_CTRL_SRCSEL {PPLL} \
      SLR1_PMC_HSM0_CLK_ENABLE {1} \
      SLR1_PMC_HSM0_CLK_OUT_ENABLE {0} \
      SLR1_PMC_HSM1_CLK_ENABLE {1} \
      SLR1_PMC_HSM1_CLK_OUT_ENABLE {0} \
      SLR1_PS_USE_CAPTURE {0} \
      SLR2_PMC_CRP_HSM0_REF_CTRL_ACT_FREQMHZ {99.999} \
      SLR2_PMC_CRP_HSM0_REF_CTRL_DIVISOR0 {12} \
      SLR2_PMC_CRP_HSM0_REF_CTRL_FREQMHZ {100} \
      SLR2_PMC_CRP_HSM0_REF_CTRL_SRCSEL {PPLL} \
      SLR2_PMC_CRP_HSM1_REF_CTRL_ACT_FREQMHZ {33.33} \
      SLR2_PMC_CRP_HSM1_REF_CTRL_DIVISOR0 {36} \
      SLR2_PMC_CRP_HSM1_REF_CTRL_FREQMHZ {33.333} \
      SLR2_PMC_CRP_HSM1_REF_CTRL_SRCSEL {PPLL} \
      SLR2_PMC_HSM0_CLK_ENABLE {1} \
      SLR2_PMC_HSM0_CLK_OUT_ENABLE {0} \
      SLR2_PMC_HSM1_CLK_ENABLE {1} \
      SLR2_PMC_HSM1_CLK_OUT_ENABLE {0} \
      SLR2_PS_USE_CAPTURE {0} \
      SLR3_PMC_CRP_HSM0_REF_CTRL_ACT_FREQMHZ {99.999} \
      SLR3_PMC_CRP_HSM0_REF_CTRL_DIVISOR0 {12} \
      SLR3_PMC_CRP_HSM0_REF_CTRL_FREQMHZ {100} \
      SLR3_PMC_CRP_HSM0_REF_CTRL_SRCSEL {PPLL} \
      SLR3_PMC_CRP_HSM1_REF_CTRL_ACT_FREQMHZ {33.33} \
      SLR3_PMC_CRP_HSM1_REF_CTRL_DIVISOR0 {36} \
      SLR3_PMC_CRP_HSM1_REF_CTRL_FREQMHZ {33.333} \
      SLR3_PMC_CRP_HSM1_REF_CTRL_SRCSEL {PPLL} \
      SLR3_PMC_HSM0_CLK_ENABLE {1} \
      SLR3_PMC_HSM0_CLK_OUT_ENABLE {0} \
      SLR3_PMC_HSM1_CLK_ENABLE {1} \
      SLR3_PMC_HSM1_CLK_OUT_ENABLE {0} \
      SLR3_PS_USE_CAPTURE {0} \
      SMON_ALARMS {Set_Alarms_On} \
      SMON_ENABLE_INT_VOLTAGE_MONITORING {0} \
      SMON_ENABLE_TEMP_AVERAGING {0} \
      SMON_HI_PERF_MODE {1} \
      SMON_INTERFACE_TO_USE {None} \
      SMON_INT_MEASUREMENT_ALARM_ENABLE {0} \
      SMON_INT_MEASUREMENT_AVG_ENABLE {0} \
      SMON_INT_MEASUREMENT_ENABLE {0} \
      SMON_INT_MEASUREMENT_MODE {0} \
      SMON_INT_MEASUREMENT_TH_HIGH {0} \
      SMON_INT_MEASUREMENT_TH_LOW {0} \
      SMON_MEAS0 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTM_AVCCAUX_202} {SUPPLY_NUM 0}} \
      SMON_MEAS1 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTM_AVCCAUX_203} {SUPPLY_NUM 0}} \
      SMON_MEAS10 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTM_AVTT_202} {SUPPLY_NUM 0}} \
      SMON_MEAS100 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS101 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS102 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS103 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS104 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS105 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS106 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS107 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS108 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS109 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS11 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTM_AVTT_203} {SUPPLY_NUM 0}} \
      SMON_MEAS110 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS111 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS112 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS113 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS114 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS115 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS116 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS117 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS118 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS119 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS12 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTM_AVTT_204} {SUPPLY_NUM 0}} \
      SMON_MEAS120 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS121 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS122 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS123 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS124 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS125 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS126 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS127 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS128 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS129 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS13 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTM_AVTT_205} {SUPPLY_NUM 0}} \
      SMON_MEAS130 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS131 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS132 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS133 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS134 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS135 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS136 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS137 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS138 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS139 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS14 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTM_AVTT_206} {SUPPLY_NUM 0}} \
      SMON_MEAS140 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS141 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS142 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS143 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS144 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS145 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS146 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS147 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS148 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS149 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS15 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTYP_AVCCAUX_102} {SUPPLY_NUM 0}} \
      SMON_MEAS150 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS151 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS152 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS153 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS154 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS155 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS156 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS157 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS158 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS159 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS16 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTYP_AVCCAUX_103} {SUPPLY_NUM 0}} \
      SMON_MEAS160 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103}} \
      SMON_MEAS161 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103}} \
      SMON_MEAS162 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCINT}} \
      SMON_MEAS163 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCAUX}} \
      SMON_MEAS164 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCC_RAM}} \
      SMON_MEAS165 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCC_SOC}} \
      SMON_MEAS166 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCC_PSFP}} \
      SMON_MEAS167 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCC_PSLP}} \
      SMON_MEAS168 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCAUX_PMC}} \
      SMON_MEAS169 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCC_PMC}} \
      SMON_MEAS17 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTYP_AVCCAUX_104} {SUPPLY_NUM 0}} \
      SMON_MEAS170 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103}} \
      SMON_MEAS171 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103}} \
      SMON_MEAS172 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103}} \
      SMON_MEAS173 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103}} \
      SMON_MEAS174 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103}} \
      SMON_MEAS175 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103}} \
      SMON_MEAS18 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTYP_AVCCAUX_105} {SUPPLY_NUM 0}} \
      SMON_MEAS19 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTYP_AVCCAUX_106} {SUPPLY_NUM 0}} \
      SMON_MEAS2 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTM_AVCCAUX_204} {SUPPLY_NUM 0}} \
      SMON_MEAS20 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTYP_AVCCAUX_200} {SUPPLY_NUM 0}} \
      SMON_MEAS21 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTYP_AVCCAUX_201} {SUPPLY_NUM 0}} \
      SMON_MEAS22 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTYP_AVCC_102} {SUPPLY_NUM 0}} \
      SMON_MEAS23 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTYP_AVCC_103} {SUPPLY_NUM 0}} \
      SMON_MEAS24 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTYP_AVCC_104} {SUPPLY_NUM 0}} \
      SMON_MEAS25 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTYP_AVCC_105} {SUPPLY_NUM 0}} \
      SMON_MEAS26 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTYP_AVCC_106} {SUPPLY_NUM 0}} \
      SMON_MEAS27 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTYP_AVCC_200} {SUPPLY_NUM 0}} \
      SMON_MEAS28 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTYP_AVCC_201} {SUPPLY_NUM 0}} \
      SMON_MEAS29 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTYP_AVTT_102} {SUPPLY_NUM 0}} \
      SMON_MEAS3 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTM_AVCCAUX_205} {SUPPLY_NUM 0}} \
      SMON_MEAS30 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTYP_AVTT_103} {SUPPLY_NUM 0}} \
      SMON_MEAS31 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTYP_AVTT_104} {SUPPLY_NUM 0}} \
      SMON_MEAS32 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTYP_AVTT_105} {SUPPLY_NUM 0}} \
      SMON_MEAS33 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTYP_AVTT_106} {SUPPLY_NUM 0}} \
      SMON_MEAS34 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTYP_AVTT_200} {SUPPLY_NUM 0}} \
      SMON_MEAS35 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTYP_AVTT_201} {SUPPLY_NUM 0}} \
      SMON_MEAS36 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCAUX} {SUPPLY_NUM 0}} \
      SMON_MEAS37 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCAUX_PMC} {SUPPLY_NUM 0}} \
      SMON_MEAS38 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCAUX_SMON} {SUPPLY_NUM 0}} \
      SMON_MEAS39 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCINT} {SUPPLY_NUM 0}} \
      SMON_MEAS4 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTM_AVCCAUX_206} {SUPPLY_NUM 0}} \
      SMON_MEAS40 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 4.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {4 V unipolar}} {NAME VCCO_500} {SUPPLY_NUM 0}} \
      SMON_MEAS41 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 4.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {4 V unipolar}} {NAME VCCO_501} {SUPPLY_NUM 0}} \
      SMON_MEAS42 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 4.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {4 V unipolar}} {NAME VCCO_502} {SUPPLY_NUM 0}} \
      SMON_MEAS43 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 4.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {4 V unipolar}} {NAME VCCO_503} {SUPPLY_NUM 0}} \
      SMON_MEAS44 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCO_700} {SUPPLY_NUM 0}} \
      SMON_MEAS45 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCO_701} {SUPPLY_NUM 0}} \
      SMON_MEAS46 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCO_702} {SUPPLY_NUM 0}} \
      SMON_MEAS47 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCO_703} {SUPPLY_NUM 0}} \
      SMON_MEAS48 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCO_704} {SUPPLY_NUM 0}} \
      SMON_MEAS49 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCO_705} {SUPPLY_NUM 0}} \
      SMON_MEAS5 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTM_AVCC_202} {SUPPLY_NUM 0}} \
      SMON_MEAS50 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCO_706} {SUPPLY_NUM 0}} \
      SMON_MEAS51 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCO_707} {SUPPLY_NUM 0}} \
      SMON_MEAS52 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCO_708} {SUPPLY_NUM 0}} \
      SMON_MEAS53 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCO_709} {SUPPLY_NUM 0}} \
      SMON_MEAS54 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCO_710} {SUPPLY_NUM 0}} \
      SMON_MEAS55 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCO_711} {SUPPLY_NUM 0}} \
      SMON_MEAS56 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCO_712} {SUPPLY_NUM 0}} \
      SMON_MEAS57 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCC_BATT} {SUPPLY_NUM 0}} \
      SMON_MEAS58 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCC_PMC} {SUPPLY_NUM 0}} \
      SMON_MEAS59 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCC_PSFP} {SUPPLY_NUM 0}} \
      SMON_MEAS6 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTM_AVCC_203} {SUPPLY_NUM 0}} \
      SMON_MEAS60 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCC_PSLP} {SUPPLY_NUM 0}} \
      SMON_MEAS61 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 1.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCC_RAM} {SUPPLY_NUM 0}} \
      SMON_MEAS62 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCC_SOC} {SUPPLY_NUM 0}} \
      SMON_MEAS63 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VP_VN} {SUPPLY_NUM 0}} \
      SMON_MEAS64 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS65 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS66 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS67 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS68 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS69 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS7 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTM_AVCC_204} {SUPPLY_NUM 0}} \
      SMON_MEAS70 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS71 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS72 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS73 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS74 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS75 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS76 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS77 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS78 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS79 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS8 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTM_AVCC_205} {SUPPLY_NUM 0}} \
      SMON_MEAS80 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS81 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS82 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS83 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS84 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS85 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS86 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS87 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS88 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS89 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS9 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTM_AVCC_206} {SUPPLY_NUM 0}} \
      SMON_MEAS90 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS91 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS92 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS93 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS94 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS95 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS96 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS97 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS98 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS99 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEASUREMENT_COUNT {64} \
      SMON_MEASUREMENT_LIST {BANK_VOLTAGE:GTM_AVTT-GTM_AVTT_202,GTM_AVTT_203,GTM_AVTT_204,GTM_AVTT_205,GTM_AVTT_206#GTYP_AVTT-GTYP_AVTT_102,GTYP_AVTT_103,GTYP_AVTT_104,GTYP_AVTT_105,GTYP_AVTT_106,GTYP_AVTT_200,GTYP_AVTT_201#VCC-GTM_AVCC_202,GTM_AVCC_203,GTM_AVCC_204,GTM_AVCC_205,GTM_AVCC_206,GTYP_AVCC_102,GTYP_AVCC_103,GTYP_AVCC_104,GTYP_AVCC_105,GTYP_AVCC_106,GTYP_AVCC_200,GTYP_AVCC_201#VCCAUX-GTM_AVCCAUX_202,GTM_AVCCAUX_203,GTM_AVCCAUX_204,GTM_AVCCAUX_205,GTM_AVCCAUX_206,GTYP_AVCCAUX_102,GTYP_AVCCAUX_103,GTYP_AVCCAUX_104,GTYP_AVCCAUX_105,GTYP_AVCCAUX_106,GTYP_AVCCAUX_200,GTYP_AVCCAUX_201#VCCO-VCCO_500,VCCO_501,VCCO_502,VCCO_503,VCCO_700,VCCO_701,VCCO_702,VCCO_703,VCCO_704,VCCO_705,VCCO_706,VCCO_707,VCCO_708,VCCO_709,VCCO_710,VCCO_711,VCCO_712|DEDICATED_PAD:VP-VP_VN|SUPPLY_VOLTAGE:VCC-VCC_BATT,VCC_PMC,VCC_PSFP,VCC_PSLP,VCC_RAM,VCC_SOC#VCCAUX-VCCAUX,VCCAUX_PMC,VCCAUX_SMON#VCCINT-VCCINT}\
\
      SMON_MUX_ADDR_ENABLE {0} \
      SMON_OT {{THRESHOLD_LOWER 70} {THRESHOLD_UPPER 125}} \
      SMON_PMBUS_ADDRESS {0x0} \
      SMON_PMBUS_UNRESTRICTED {0} \
      SMON_REFERENCE_SOURCE {Internal} \
      SMON_TEMP_AVERAGING_SAMPLES {0} \
      SMON_TEMP_THRESHOLD {0} \
      SMON_USER_TEMP {{THRESHOLD_LOWER 70} {THRESHOLD_UPPER 125} {USER_ALARM_TYPE hysteresis}} \
      SMON_VAUX_CH0 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH0} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH1 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH1} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH10 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH10} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH11 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH11} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH12 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH12} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH13 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH13} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH14 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH14} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH15 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH15} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH2 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH2} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH3 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH3} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH4 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH4} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH5 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH5} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH6 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH6} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH7 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH7} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH8 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH8} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH9 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH9} {SUPPLY_NUM 0}} \
      SMON_VAUX_IO_BANK {MIO_BANK0} \
      SMON_VOLTAGE_AVERAGING_SAMPLES {None} \
      SPP_PSPMC_FROM_CORE_WIDTH {12000} \
      SPP_PSPMC_TO_CORE_WIDTH {12000} \
      SUBPRESET1 {Custom} \
      USE_UART0_IN_DEVICE_BOOT {0} \
      preset {None} \
    } \
    CONFIG.PS_PMC_CONFIG_APPLIED {1} \
  ] $CIPS_0


  set_property SELECTED_SIM_MODEL tlm  $CIPS_0

  # Create instance: axi_intc_0, and set properties
  set axi_intc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 axi_intc_0 ]
  set_property -dict [list \
    CONFIG.C_ASYNC_INTR {0xFFFFFFFF} \
    CONFIG.C_IRQ_CONNECTION {1} \
  ] $axi_intc_0


  # Create instance: clk_wizard_0, and set properties
  set clk_wizard_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wizard:1.0 clk_wizard_0 ]
  set_property -dict [list \
    CONFIG.CLKOUT_DRIVES {BUFG,BUFG,BUFG,BUFG,BUFG,BUFG,BUFG} \
    CONFIG.CLKOUT_DYN_PS {None,None,None,None,None,None,None} \
    CONFIG.CLKOUT_MATCHED_ROUTING {false,false,false,false,false,false,false} \
    CONFIG.CLKOUT_PORT {clk_out1,clk_out2,clk_out3,clk_out4,clk_out5,clk_out6,clk_out7} \
    CONFIG.CLKOUT_REQUESTED_DUTY_CYCLE {50.000,50.000,50.000,50.000,50.000,50.000,50.000} \
    CONFIG.CLKOUT_REQUESTED_OUT_FREQUENCY {156.250000,104.166666,312.500000,100.000,100.000,100.000,100.000} \
    CONFIG.CLKOUT_REQUESTED_PHASE {0.000,0.000,0.000,0.000,0.000,0.000,0.000} \
    CONFIG.CLKOUT_USED {true,false,false,false,false,false,false} \
    CONFIG.JITTER_SEL {Min_O_Jitter} \
    CONFIG.PRIM_SOURCE {No_buffer} \
    CONFIG.RESET_TYPE {ACTIVE_LOW} \
    CONFIG.USE_LOCKED {true} \
    CONFIG.USE_PHASE_ALIGNMENT {true} \
    CONFIG.USE_RESET {true} \
  ] $clk_wizard_0


  # Create instance: cips_noc, and set properties
  set cips_noc [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.1 cips_noc ]
  set_property -dict [list \
    CONFIG.NUM_CLKS {9} \
    CONFIG.NUM_MI {0} \
    CONFIG.NUM_NMI {2} \
    CONFIG.NUM_NSI {0} \
    CONFIG.NUM_SI {8} \
  ] $cips_noc


  set_property SELECTED_SIM_MODEL tlm  $cips_noc

  set_property -dict [ list \
   CONFIG.CONNECTIONS {M01_INI {read_bw {128} write_bw {128}} M00_INI {read_bw {128} write_bw {128}}} \
   CONFIG.DEST_IDS {} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins $cips_noc/S00_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {M01_INI {read_bw {128} write_bw {128}} M00_INI {read_bw {128} write_bw {128}}} \
   CONFIG.DEST_IDS {} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins $cips_noc/S01_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {M01_INI {read_bw {128} write_bw {128}} M00_INI {read_bw {128} write_bw {128}}} \
   CONFIG.DEST_IDS {} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins $cips_noc/S02_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {M01_INI {read_bw {128} write_bw {128}} M00_INI {read_bw {128} write_bw {128}}} \
   CONFIG.DEST_IDS {} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins $cips_noc/S03_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {M01_INI {read_bw {128} write_bw {128}} M00_INI {read_bw {128} write_bw {128}}} \
   CONFIG.DEST_IDS {} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_nci} \
 ] [get_bd_intf_pins $cips_noc/S04_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {M01_INI {read_bw {128} write_bw {128}} M00_INI {read_bw {128} write_bw {128}}} \
   CONFIG.DEST_IDS {} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_nci} \
 ] [get_bd_intf_pins $cips_noc/S05_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {M01_INI {read_bw {128} write_bw {128}} M00_INI {read_bw {128} write_bw {128}}} \
   CONFIG.DEST_IDS {} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_rpu} \
 ] [get_bd_intf_pins $cips_noc/S06_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {M01_INI {read_bw {128} write_bw {128}} M00_INI {read_bw {128} write_bw {128}}} \
   CONFIG.DEST_IDS {} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_pmc} \
 ] [get_bd_intf_pins $cips_noc/S07_AXI]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {} \
 ] [get_bd_pins $cips_noc/aclk0]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S00_AXI} \
 ] [get_bd_pins $cips_noc/aclk1]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S01_AXI} \
 ] [get_bd_pins $cips_noc/aclk2]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S02_AXI} \
 ] [get_bd_pins $cips_noc/aclk3]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S03_AXI} \
 ] [get_bd_pins $cips_noc/aclk4]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S04_AXI} \
 ] [get_bd_pins $cips_noc/aclk5]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S05_AXI} \
 ] [get_bd_pins $cips_noc/aclk6]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S06_AXI} \
 ] [get_bd_pins $cips_noc/aclk7]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S07_AXI} \
 ] [get_bd_pins $cips_noc/aclk8]

  # Create instance: sys_noc_lpddr4, and set properties
  set sys_noc_lpddr4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.1 sys_noc_lpddr4 ]
  set_property -dict [list \
    CONFIG.CONTROLLERTYPE {LPDDR4_SDRAM} \
    CONFIG.MC0_CONFIG_NUM {config26} \
    CONFIG.MC0_FLIPPED_PINOUT {true} \
    CONFIG.MC1_CONFIG_NUM {config26} \
    CONFIG.MC2_CONFIG_NUM {config26} \
    CONFIG.MC3_CONFIG_NUM {config26} \
    CONFIG.MC_ADDR_WIDTH {6} \
    CONFIG.MC_BURST_LENGTH {16} \
    CONFIG.MC_CASLATENCY {32} \
    CONFIG.MC_CH0_LP4_CHA_ENABLE {true} \
    CONFIG.MC_CH0_LP4_CHB_ENABLE {true} \
    CONFIG.MC_CH1_LP4_CHA_ENABLE {true} \
    CONFIG.MC_CH1_LP4_CHB_ENABLE {true} \
    CONFIG.MC_CHAN_REGION0 {DDR_LOW1} \
    CONFIG.MC_CHAN_REGION1 {NONE} \
    CONFIG.MC_CKE_WIDTH {0} \
    CONFIG.MC_CK_WIDTH {0} \
    CONFIG.MC_COMPONENT_DENSITY {16Gb} \
    CONFIG.MC_COMPONENT_WIDTH {x32} \
    CONFIG.MC_CONFIG_NUM {config26} \
    CONFIG.MC_CS_WIDTH {2} \
    CONFIG.MC_DATAWIDTH {32} \
    CONFIG.MC_DM_WIDTH {4} \
    CONFIG.MC_DQS_WIDTH {4} \
    CONFIG.MC_DQ_WIDTH {32} \
    CONFIG.MC_ECC_SCRUB_SIZE {8192} \
    CONFIG.MC_F1_CASLATENCY {32} \
    CONFIG.MC_F1_CASWRITELATENCY {16} \
    CONFIG.MC_F1_LPDDR4_MR13 {0x00C0} \
    CONFIG.MC_F1_TCCD_L {0} \
    CONFIG.MC_F1_TCCD_L_MIN {0} \
    CONFIG.MC_F1_TFAW {40000} \
    CONFIG.MC_F1_TFAWMIN {40000} \
    CONFIG.MC_F1_TMOD {0} \
    CONFIG.MC_F1_TMOD_MIN {0} \
    CONFIG.MC_F1_TMRD {14000} \
    CONFIG.MC_F1_TMRDMIN {14000} \
    CONFIG.MC_F1_TMRW {10000} \
    CONFIG.MC_F1_TMRWMIN {10000} \
    CONFIG.MC_F1_TRAS {42000} \
    CONFIG.MC_F1_TRASMIN {42000} \
    CONFIG.MC_F1_TRCD {18000} \
    CONFIG.MC_F1_TRCDMIN {18000} \
    CONFIG.MC_F1_TRPAB {21000} \
    CONFIG.MC_F1_TRPABMIN {21000} \
    CONFIG.MC_F1_TRPPB {18000} \
    CONFIG.MC_F1_TRPPBMIN {18000} \
    CONFIG.MC_F1_TRRD {10000} \
    CONFIG.MC_F1_TRRDMIN {10000} \
    CONFIG.MC_F1_TRRD_L {0} \
    CONFIG.MC_F1_TRRD_L_MIN {0} \
    CONFIG.MC_F1_TRRD_S {0} \
    CONFIG.MC_F1_TRRD_S_MIN {0} \
    CONFIG.MC_F1_TWR {18000} \
    CONFIG.MC_F1_TWRMIN {18000} \
    CONFIG.MC_F1_TWTR {10000} \
    CONFIG.MC_F1_TWTRMIN {10000} \
    CONFIG.MC_F1_TWTR_L {0} \
    CONFIG.MC_F1_TWTR_L_MIN {0} \
    CONFIG.MC_F1_TWTR_S {0} \
    CONFIG.MC_F1_TWTR_S_MIN {0} \
    CONFIG.MC_F1_TZQLAT {30000} \
    CONFIG.MC_F1_TZQLATMIN {30000} \
    CONFIG.MC_INPUTCLK0_PERIOD {4995} \
    CONFIG.MC_IP_TIMEPERIOD1 {540} \
    CONFIG.MC_LP4_CA_A_WIDTH {6} \
    CONFIG.MC_LP4_CA_B_WIDTH {6} \
    CONFIG.MC_LP4_CKE_A_WIDTH {2} \
    CONFIG.MC_LP4_CKE_B_WIDTH {2} \
    CONFIG.MC_LP4_CKT_A_WIDTH {1} \
    CONFIG.MC_LP4_CKT_B_WIDTH {1} \
    CONFIG.MC_LP4_CS_A_WIDTH {2} \
    CONFIG.MC_LP4_CS_B_WIDTH {2} \
    CONFIG.MC_LP4_DMI_A_WIDTH {2} \
    CONFIG.MC_LP4_DMI_B_WIDTH {2} \
    CONFIG.MC_LP4_DQS_A_WIDTH {2} \
    CONFIG.MC_LP4_DQS_B_WIDTH {2} \
    CONFIG.MC_LP4_DQ_A_WIDTH {16} \
    CONFIG.MC_LP4_DQ_B_WIDTH {16} \
    CONFIG.MC_LP4_RESETN_WIDTH {1} \
    CONFIG.MC_MEMORY_SPEEDGRADE {LPDDR4-3733} \
    CONFIG.MC_MEMORY_TIMEPERIOD0 {540} \
    CONFIG.MC_NO_CHANNELS {Dual} \
    CONFIG.MC_ODTLon {6} \
    CONFIG.MC_ODT_WIDTH {0} \
    CONFIG.MC_PER_RD_INTVL {0} \
    CONFIG.MC_PRE_DEF_ADDR_MAP_SEL {ROW_BANK_COLUMN} \
    CONFIG.MC_RANK {2} \
    CONFIG.MC_TCCD {8} \
    CONFIG.MC_TCCD_L {0} \
    CONFIG.MC_TCCD_L_MIN {0} \
    CONFIG.MC_TCKE {14} \
    CONFIG.MC_TCKEMIN {14} \
    CONFIG.MC_TDQS2DQ_MAX {800} \
    CONFIG.MC_TDQS2DQ_MIN {200} \
    CONFIG.MC_TDQSCK_MAX {3500} \
    CONFIG.MC_TFAW {40000} \
    CONFIG.MC_TFAWMIN {40000} \
    CONFIG.MC_TMOD {0} \
    CONFIG.MC_TMOD_MIN {0} \
    CONFIG.MC_TMRD {14000} \
    CONFIG.MC_TMRDMIN {14000} \
    CONFIG.MC_TMRD_div4 {10} \
    CONFIG.MC_TMRD_nCK {26} \
    CONFIG.MC_TMRW {10000} \
    CONFIG.MC_TMRWMIN {10000} \
    CONFIG.MC_TMRW_div4 {10} \
    CONFIG.MC_TMRW_nCK {19} \
    CONFIG.MC_TODTon_MIN {3} \
    CONFIG.MC_TOSCO {40000} \
    CONFIG.MC_TOSCOMIN {40000} \
    CONFIG.MC_TOSCO_nCK {75} \
    CONFIG.MC_TPBR2PBR {90000} \
    CONFIG.MC_TPBR2PBRMIN {90000} \
    CONFIG.MC_TRAS {42000} \
    CONFIG.MC_TRASMIN {42000} \
    CONFIG.MC_TRAS_nCK {78} \
    CONFIG.MC_TRC {63000} \
    CONFIG.MC_TRCD {18000} \
    CONFIG.MC_TRCDMIN {18000} \
    CONFIG.MC_TRCD_nCK {34} \
    CONFIG.MC_TRCMIN {0} \
    CONFIG.MC_TREFI {3904000} \
    CONFIG.MC_TREFIPB {488000} \
    CONFIG.MC_TRFC {0} \
    CONFIG.MC_TRFCAB {280000} \
    CONFIG.MC_TRFCABMIN {280000} \
    CONFIG.MC_TRFCMIN {0} \
    CONFIG.MC_TRFCPB {140000} \
    CONFIG.MC_TRFCPBMIN {140000} \
    CONFIG.MC_TRP {0} \
    CONFIG.MC_TRPAB {21000} \
    CONFIG.MC_TRPABMIN {21000} \
    CONFIG.MC_TRPAB_nCK {39} \
    CONFIG.MC_TRPMIN {0} \
    CONFIG.MC_TRPPB {18000} \
    CONFIG.MC_TRPPBMIN {18000} \
    CONFIG.MC_TRPPB_nCK {34} \
    CONFIG.MC_TRPRE {1.8} \
    CONFIG.MC_TRRD {10000} \
    CONFIG.MC_TRRDMIN {10000} \
    CONFIG.MC_TRRD_L {0} \
    CONFIG.MC_TRRD_L_MIN {0} \
    CONFIG.MC_TRRD_S {0} \
    CONFIG.MC_TRRD_S_MIN {0} \
    CONFIG.MC_TRRD_nCK {19} \
    CONFIG.MC_TWPRE {1.8} \
    CONFIG.MC_TWPST {0.4} \
    CONFIG.MC_TWR {18000} \
    CONFIG.MC_TWRMIN {18000} \
    CONFIG.MC_TWR_nCK {34} \
    CONFIG.MC_TWTR {10000} \
    CONFIG.MC_TWTRMIN {10000} \
    CONFIG.MC_TWTR_L {0} \
    CONFIG.MC_TWTR_S {0} \
    CONFIG.MC_TWTR_S_MIN {0} \
    CONFIG.MC_TWTR_nCK {19} \
    CONFIG.MC_TXP {14} \
    CONFIG.MC_TXPMIN {14} \
    CONFIG.MC_TXPR {0} \
    CONFIG.MC_TZQCAL {1000000} \
    CONFIG.MC_TZQCAL_div4 {463} \
    CONFIG.MC_TZQCS_ITVL {0} \
    CONFIG.MC_TZQLAT {30000} \
    CONFIG.MC_TZQLATMIN {30000} \
    CONFIG.MC_TZQLAT_div4 {14} \
    CONFIG.MC_TZQLAT_nCK {56} \
    CONFIG.MC_TZQ_START_ITVL {1000000000} \
    CONFIG.MC_USER_DEFINED_ADDRESS_MAP {1CS-16RA-3BA-10CA} \
    CONFIG.MC_XPLL_CLKOUT1_PERIOD {1080} \
    CONFIG.NUM_CLKS {0} \
    CONFIG.NUM_MC {1} \
    CONFIG.NUM_MCP {4} \
    CONFIG.NUM_MI {0} \
    CONFIG.NUM_NSI {1} \
    CONFIG.NUM_SI {0} \
  ] $sys_noc_lpddr4


  set_property SELECTED_SIM_MODEL tlm  $sys_noc_lpddr4

  set_property -dict [ list \
   CONFIG.CONNECTIONS {MC_0 {read_bw {128} write_bw {128} read_avg_burst {4} write_avg_burst {4}}} \
 ] [get_bd_intf_pins $sys_noc_lpddr4/S00_INI]

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: noc_lpddr4, and set properties
  set noc_lpddr4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.1 noc_lpddr4 ]
  set_property -dict [list \
    CONFIG.CONTROLLERTYPE {LPDDR4_SDRAM} \
    CONFIG.MC0_CONFIG_NUM {config26} \
    CONFIG.MC0_FLIPPED_PINOUT {true} \
    CONFIG.MC1_CONFIG_NUM {config26} \
    CONFIG.MC1_FLIPPED_PINOUT {true} \
    CONFIG.MC2_CONFIG_NUM {config26} \
    CONFIG.MC3_CONFIG_NUM {config26} \
    CONFIG.MC_ADDR_WIDTH {6} \
    CONFIG.MC_BURST_LENGTH {16} \
    CONFIG.MC_CASLATENCY {32} \
    CONFIG.MC_CH0_LP4_CHA_ENABLE {true} \
    CONFIG.MC_CH0_LP4_CHB_ENABLE {true} \
    CONFIG.MC_CH1_LP4_CHA_ENABLE {true} \
    CONFIG.MC_CH1_LP4_CHB_ENABLE {true} \
    CONFIG.MC_CHAN_REGION0 {DDR_CH1} \
    CONFIG.MC_CHAN_REGION1 {DDR_CH2} \
    CONFIG.MC_CKE_WIDTH {0} \
    CONFIG.MC_CK_WIDTH {0} \
    CONFIG.MC_COMPONENT_DENSITY {16Gb} \
    CONFIG.MC_COMPONENT_WIDTH {x32} \
    CONFIG.MC_CONFIG_NUM {config26} \
    CONFIG.MC_CS_WIDTH {2} \
    CONFIG.MC_DATAWIDTH {32} \
    CONFIG.MC_DM_WIDTH {4} \
    CONFIG.MC_DQS_WIDTH {4} \
    CONFIG.MC_DQ_WIDTH {32} \
    CONFIG.MC_ECC_SCRUB_SIZE {8192} \
    CONFIG.MC_F1_CASLATENCY {32} \
    CONFIG.MC_F1_CASWRITELATENCY {16} \
    CONFIG.MC_F1_LPDDR4_MR13 {0x00C0} \
    CONFIG.MC_F1_TCCD_L {0} \
    CONFIG.MC_F1_TCCD_L_MIN {0} \
    CONFIG.MC_F1_TFAW {40000} \
    CONFIG.MC_F1_TFAWMIN {40000} \
    CONFIG.MC_F1_TMOD {0} \
    CONFIG.MC_F1_TMOD_MIN {0} \
    CONFIG.MC_F1_TMRD {14000} \
    CONFIG.MC_F1_TMRDMIN {14000} \
    CONFIG.MC_F1_TMRW {10000} \
    CONFIG.MC_F1_TMRWMIN {10000} \
    CONFIG.MC_F1_TRAS {42000} \
    CONFIG.MC_F1_TRASMIN {42000} \
    CONFIG.MC_F1_TRCD {18000} \
    CONFIG.MC_F1_TRCDMIN {18000} \
    CONFIG.MC_F1_TRPAB {21000} \
    CONFIG.MC_F1_TRPABMIN {21000} \
    CONFIG.MC_F1_TRPPB {18000} \
    CONFIG.MC_F1_TRPPBMIN {18000} \
    CONFIG.MC_F1_TRRD {10000} \
    CONFIG.MC_F1_TRRDMIN {10000} \
    CONFIG.MC_F1_TRRD_L {0} \
    CONFIG.MC_F1_TRRD_L_MIN {0} \
    CONFIG.MC_F1_TRRD_S {0} \
    CONFIG.MC_F1_TRRD_S_MIN {0} \
    CONFIG.MC_F1_TWR {18000} \
    CONFIG.MC_F1_TWRMIN {18000} \
    CONFIG.MC_F1_TWTR {10000} \
    CONFIG.MC_F1_TWTRMIN {10000} \
    CONFIG.MC_F1_TWTR_L {0} \
    CONFIG.MC_F1_TWTR_L_MIN {0} \
    CONFIG.MC_F1_TWTR_S {0} \
    CONFIG.MC_F1_TWTR_S_MIN {0} \
    CONFIG.MC_F1_TZQLAT {30000} \
    CONFIG.MC_F1_TZQLATMIN {30000} \
    CONFIG.MC_INPUTCLK0_PERIOD {4995} \
    CONFIG.MC_INTERLEAVE_SIZE {256} \
    CONFIG.MC_IP_TIMEPERIOD1 {540} \
    CONFIG.MC_LP4_CA_A_WIDTH {6} \
    CONFIG.MC_LP4_CA_B_WIDTH {6} \
    CONFIG.MC_LP4_CKE_A_WIDTH {2} \
    CONFIG.MC_LP4_CKE_B_WIDTH {2} \
    CONFIG.MC_LP4_CKT_A_WIDTH {1} \
    CONFIG.MC_LP4_CKT_B_WIDTH {1} \
    CONFIG.MC_LP4_CS_A_WIDTH {2} \
    CONFIG.MC_LP4_CS_B_WIDTH {2} \
    CONFIG.MC_LP4_DMI_A_WIDTH {2} \
    CONFIG.MC_LP4_DMI_B_WIDTH {2} \
    CONFIG.MC_LP4_DQS_A_WIDTH {2} \
    CONFIG.MC_LP4_DQS_B_WIDTH {2} \
    CONFIG.MC_LP4_DQ_A_WIDTH {16} \
    CONFIG.MC_LP4_DQ_B_WIDTH {16} \
    CONFIG.MC_LP4_RESETN_WIDTH {1} \
    CONFIG.MC_MEMORY_SPEEDGRADE {LPDDR4-3733} \
    CONFIG.MC_MEMORY_TIMEPERIOD0 {540} \
    CONFIG.MC_NO_CHANNELS {Dual} \
    CONFIG.MC_ODTLon {6} \
    CONFIG.MC_ODT_WIDTH {0} \
    CONFIG.MC_PER_RD_INTVL {0} \
    CONFIG.MC_PRE_DEF_ADDR_MAP_SEL {ROW_BANK_COLUMN} \
    CONFIG.MC_RANK {2} \
    CONFIG.MC_TCCD {8} \
    CONFIG.MC_TCCD_L {0} \
    CONFIG.MC_TCCD_L_MIN {0} \
    CONFIG.MC_TCKE {14} \
    CONFIG.MC_TCKEMIN {14} \
    CONFIG.MC_TDQS2DQ_MAX {800} \
    CONFIG.MC_TDQS2DQ_MIN {200} \
    CONFIG.MC_TDQSCK_MAX {3500} \
    CONFIG.MC_TFAW {40000} \
    CONFIG.MC_TFAWMIN {40000} \
    CONFIG.MC_TMOD {0} \
    CONFIG.MC_TMOD_MIN {0} \
    CONFIG.MC_TMRD {14000} \
    CONFIG.MC_TMRDMIN {14000} \
    CONFIG.MC_TMRD_div4 {10} \
    CONFIG.MC_TMRD_nCK {26} \
    CONFIG.MC_TMRW {10000} \
    CONFIG.MC_TMRWMIN {10000} \
    CONFIG.MC_TMRW_div4 {10} \
    CONFIG.MC_TMRW_nCK {19} \
    CONFIG.MC_TODTon_MIN {3} \
    CONFIG.MC_TOSCO {40000} \
    CONFIG.MC_TOSCOMIN {40000} \
    CONFIG.MC_TOSCO_nCK {75} \
    CONFIG.MC_TPBR2PBR {90000} \
    CONFIG.MC_TPBR2PBRMIN {90000} \
    CONFIG.MC_TRAS {42000} \
    CONFIG.MC_TRASMIN {42000} \
    CONFIG.MC_TRAS_nCK {78} \
    CONFIG.MC_TRC {63000} \
    CONFIG.MC_TRCD {18000} \
    CONFIG.MC_TRCDMIN {18000} \
    CONFIG.MC_TRCD_nCK {34} \
    CONFIG.MC_TRCMIN {0} \
    CONFIG.MC_TREFI {3904000} \
    CONFIG.MC_TREFIPB {488000} \
    CONFIG.MC_TRFC {0} \
    CONFIG.MC_TRFCAB {280000} \
    CONFIG.MC_TRFCABMIN {280000} \
    CONFIG.MC_TRFCMIN {0} \
    CONFIG.MC_TRFCPB {140000} \
    CONFIG.MC_TRFCPBMIN {140000} \
    CONFIG.MC_TRP {0} \
    CONFIG.MC_TRPAB {21000} \
    CONFIG.MC_TRPABMIN {21000} \
    CONFIG.MC_TRPAB_nCK {39} \
    CONFIG.MC_TRPMIN {0} \
    CONFIG.MC_TRPPB {18000} \
    CONFIG.MC_TRPPBMIN {18000} \
    CONFIG.MC_TRPPB_nCK {34} \
    CONFIG.MC_TRPRE {1.8} \
    CONFIG.MC_TRRD {10000} \
    CONFIG.MC_TRRDMIN {10000} \
    CONFIG.MC_TRRD_L {0} \
    CONFIG.MC_TRRD_L_MIN {0} \
    CONFIG.MC_TRRD_S {0} \
    CONFIG.MC_TRRD_S_MIN {0} \
    CONFIG.MC_TRRD_nCK {19} \
    CONFIG.MC_TWPRE {1.8} \
    CONFIG.MC_TWPST {0.4} \
    CONFIG.MC_TWR {18000} \
    CONFIG.MC_TWRMIN {18000} \
    CONFIG.MC_TWR_nCK {34} \
    CONFIG.MC_TWTR {10000} \
    CONFIG.MC_TWTRMIN {10000} \
    CONFIG.MC_TWTR_L {0} \
    CONFIG.MC_TWTR_S {0} \
    CONFIG.MC_TWTR_S_MIN {0} \
    CONFIG.MC_TWTR_nCK {19} \
    CONFIG.MC_TXP {14} \
    CONFIG.MC_TXPMIN {14} \
    CONFIG.MC_TXPR {0} \
    CONFIG.MC_TZQCAL {1000000} \
    CONFIG.MC_TZQCAL_div4 {463} \
    CONFIG.MC_TZQCS_ITVL {0} \
    CONFIG.MC_TZQLAT {30000} \
    CONFIG.MC_TZQLATMIN {30000} \
    CONFIG.MC_TZQLAT_div4 {14} \
    CONFIG.MC_TZQLAT_nCK {56} \
    CONFIG.MC_TZQ_START_ITVL {1000000000} \
    CONFIG.MC_USER_DEFINED_ADDRESS_MAP {1CS-16RA-3BA-10CA} \
    CONFIG.MC_XPLL_CLKOUT1_PERIOD {1080} \
    CONFIG.NUM_CLKS {0} \
    CONFIG.NUM_MC {2} \
    CONFIG.NUM_MCP {4} \
    CONFIG.NUM_MI {0} \
    CONFIG.NUM_NSI {1} \
    CONFIG.NUM_SI {0} \
  ] $noc_lpddr4


  set_property SELECTED_SIM_MODEL tlm  $noc_lpddr4

  set_property -dict [ list \
   CONFIG.CONNECTIONS {MC_0 {read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}}} \
 ] [get_bd_intf_pins $noc_lpddr4/S00_INI]

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [list \
    CONFIG.NUM_MI {5} \
    CONFIG.NUM_SI {1} \
  ] $smartconnect_0


  # Create instance: Serdes1
  create_hier_cell_Serdes1 [current_bd_instance .] Serdes1

  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]
  set_property CONFIG.C_GPIO_WIDTH {4} $axi_gpio_0


  # Create instance: axi_uartlite_0, and set properties
  set axi_uartlite_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_0 ]
  set_property -dict [list \
    CONFIG.C_BAUDRATE {115200} \
    CONFIG.C_S_AXI_ACLK_FREQ_HZ {156248437} \
  ] $axi_uartlite_0


  # Create instance: Serdes2
  create_hier_cell_Serdes2 [current_bd_instance .] Serdes2

  # Create interface connections
  connect_bd_intf_net -intf_net Bank106_GT_REFCLK_0_1 [get_bd_intf_ports Bank200_GT_REFCLK] [get_bd_intf_pins Serdes2/Bank106_GT_REFCLK]
  connect_bd_intf_net -intf_net CIPS_0_FPD_AXI_NOC_0 [get_bd_intf_pins CIPS_0/FPD_AXI_NOC_0] [get_bd_intf_pins cips_noc/S04_AXI]
  connect_bd_intf_net -intf_net CIPS_0_FPD_AXI_NOC_1 [get_bd_intf_pins CIPS_0/FPD_AXI_NOC_1] [get_bd_intf_pins cips_noc/S05_AXI]
  connect_bd_intf_net -intf_net CIPS_0_FPD_CCI_NOC_0 [get_bd_intf_pins CIPS_0/FPD_CCI_NOC_0] [get_bd_intf_pins cips_noc/S00_AXI]
  connect_bd_intf_net -intf_net CIPS_0_FPD_CCI_NOC_1 [get_bd_intf_pins CIPS_0/FPD_CCI_NOC_1] [get_bd_intf_pins cips_noc/S01_AXI]
  connect_bd_intf_net -intf_net CIPS_0_FPD_CCI_NOC_2 [get_bd_intf_pins CIPS_0/FPD_CCI_NOC_2] [get_bd_intf_pins cips_noc/S02_AXI]
  connect_bd_intf_net -intf_net CIPS_0_FPD_CCI_NOC_3 [get_bd_intf_pins CIPS_0/FPD_CCI_NOC_3] [get_bd_intf_pins cips_noc/S03_AXI]
  connect_bd_intf_net -intf_net CIPS_0_LPD_AXI_NOC_0 [get_bd_intf_pins CIPS_0/LPD_AXI_NOC_0] [get_bd_intf_pins cips_noc/S06_AXI]
  connect_bd_intf_net -intf_net CIPS_0_M_AXI_FPD [get_bd_intf_pins CIPS_0/M_AXI_FPD] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net CIPS_0_PMC_NOC_AXI_0 [get_bd_intf_pins CIPS_0/PMC_NOC_AXI_0] [get_bd_intf_pins cips_noc/S07_AXI]
  connect_bd_intf_net -intf_net CLK_IN_D_0_1 [get_bd_intf_ports Bank106_GT_REFCLK] [get_bd_intf_pins Serdes1/Bank_GTY_REFCLK]
  connect_bd_intf_net -intf_net Serdes2_bank106_GT_Serial [get_bd_intf_ports bank200_GT_Serial] [get_bd_intf_pins Serdes2/bank106_GT_Serial]
  connect_bd_intf_net -intf_net Serdes_GT_Serial_0 [get_bd_intf_ports bank106_GT_Serial] [get_bd_intf_pins Serdes1/bank_GTY_Serial]
  connect_bd_intf_net -intf_net axi_gpio_0_GPIO [get_bd_intf_ports PL_GPIO] [get_bd_intf_pins axi_gpio_0/GPIO]
  connect_bd_intf_net -intf_net axi_uartlite_0_UART [get_bd_intf_ports PL_UART] [get_bd_intf_pins axi_uartlite_0/UART]
  connect_bd_intf_net -intf_net cips_noc_M00_INI [get_bd_intf_pins cips_noc/M00_INI] [get_bd_intf_pins sys_noc_lpddr4/S00_INI]
  connect_bd_intf_net -intf_net cips_noc_M01_INI [get_bd_intf_pins cips_noc/M01_INI] [get_bd_intf_pins noc_lpddr4/S00_INI]
  connect_bd_intf_net -intf_net noc_ddr4_CH0_LPDDR4_0 [get_bd_intf_ports TRIP1_CH0_LPDDR4] [get_bd_intf_pins sys_noc_lpddr4/CH0_LPDDR4_0]
  connect_bd_intf_net -intf_net noc_ddr4_CH1_LPDDR4_0 [get_bd_intf_ports TRIP1_CH1_LPDDR4] [get_bd_intf_pins sys_noc_lpddr4/CH1_LPDDR4_0]
  connect_bd_intf_net -intf_net noc_lpddr4_CH0_LPDDR4_0 [get_bd_intf_ports TRIP2_CH0_LPDDR4] [get_bd_intf_pins noc_lpddr4/CH0_LPDDR4_0]
  connect_bd_intf_net -intf_net noc_lpddr4_CH0_LPDDR4_1 [get_bd_intf_ports TRIP3_CH0_LPDDR4] [get_bd_intf_pins noc_lpddr4/CH0_LPDDR4_1]
  connect_bd_intf_net -intf_net noc_lpddr4_CH1_LPDDR4_0 [get_bd_intf_ports TRIP2_CH1_LPDDR4] [get_bd_intf_pins noc_lpddr4/CH1_LPDDR4_0]
  connect_bd_intf_net -intf_net noc_lpddr4_CH1_LPDDR4_1 [get_bd_intf_ports TRIP3_CH1_LPDDR4] [get_bd_intf_pins noc_lpddr4/CH1_LPDDR4_1]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins smartconnect_0/M00_AXI] [get_bd_intf_pins axi_intc_0/s_axi]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins smartconnect_0/M01_AXI] [get_bd_intf_pins Serdes1/AXI_LITE]
  connect_bd_intf_net -intf_net smartconnect_0_M02_AXI [get_bd_intf_pins smartconnect_0/M02_AXI] [get_bd_intf_pins axi_gpio_0/S_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M03_AXI [get_bd_intf_pins smartconnect_0/M03_AXI] [get_bd_intf_pins axi_uartlite_0/S_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M04_AXI [get_bd_intf_pins smartconnect_0/M04_AXI] [get_bd_intf_pins Serdes2/AXI_LITE]
  connect_bd_intf_net -intf_net sys_clk0_0_1 [get_bd_intf_ports LPDDR4_CLK1] [get_bd_intf_pins sys_noc_lpddr4/sys_clk0]
  connect_bd_intf_net -intf_net sys_clk0_1_1 [get_bd_intf_ports LPDDR4_CLK2] [get_bd_intf_pins noc_lpddr4/sys_clk0]
  connect_bd_intf_net -intf_net sys_clk1_0_1 [get_bd_intf_ports LPDDR4_CLK3] [get_bd_intf_pins noc_lpddr4/sys_clk1]

  # Create port connections
  connect_bd_net -net CIPS_0_fpd_axi_noc_axi0_clk  [get_bd_pins CIPS_0/fpd_axi_noc_axi0_clk] \
  [get_bd_pins cips_noc/aclk5]
  connect_bd_net -net CIPS_0_fpd_axi_noc_axi1_clk  [get_bd_pins CIPS_0/fpd_axi_noc_axi1_clk] \
  [get_bd_pins cips_noc/aclk6]
  connect_bd_net -net CIPS_0_fpd_cci_noc_axi0_clk  [get_bd_pins CIPS_0/fpd_cci_noc_axi0_clk] \
  [get_bd_pins cips_noc/aclk1]
  connect_bd_net -net CIPS_0_fpd_cci_noc_axi1_clk  [get_bd_pins CIPS_0/fpd_cci_noc_axi1_clk] \
  [get_bd_pins cips_noc/aclk2]
  connect_bd_net -net CIPS_0_fpd_cci_noc_axi2_clk  [get_bd_pins CIPS_0/fpd_cci_noc_axi2_clk] \
  [get_bd_pins cips_noc/aclk3]
  connect_bd_net -net CIPS_0_fpd_cci_noc_axi3_clk  [get_bd_pins CIPS_0/fpd_cci_noc_axi3_clk] \
  [get_bd_pins cips_noc/aclk4]
  connect_bd_net -net CIPS_0_lpd_axi_noc_clk  [get_bd_pins CIPS_0/lpd_axi_noc_clk] \
  [get_bd_pins cips_noc/aclk7]
  connect_bd_net -net CIPS_0_pl_clk0  [get_bd_pins CIPS_0/pl0_ref_clk] \
  [get_bd_pins clk_wizard_0/clk_in1]
  connect_bd_net -net CIPS_0_pl_resetn1  [get_bd_pins CIPS_0/pl0_resetn] \
  [get_bd_pins clk_wizard_0/resetn] \
  [get_bd_pins proc_sys_reset_0/ext_reset_in]
  connect_bd_net -net CIPS_0_pmc_axi_noc_axi0_clk  [get_bd_pins CIPS_0/pmc_axi_noc_axi0_clk] \
  [get_bd_pins cips_noc/aclk8]
  connect_bd_net -net axi_intc_0_irq  [get_bd_pins axi_intc_0/irq] \
  [get_bd_pins CIPS_0/pl_ps_irq0]
  connect_bd_net -net axi_uartlite_0_interrupt  [get_bd_pins axi_uartlite_0/interrupt] \
  [get_bd_pins axi_intc_0/intr]
  connect_bd_net -net clk_wizard_0_clk_out1  [get_bd_pins clk_wizard_0/clk_out1] \
  [get_bd_pins Serdes1/s_axi_lite_clk] \
  [get_bd_pins CIPS_0/m_axi_fpd_aclk] \
  [get_bd_pins axi_gpio_0/s_axi_aclk] \
  [get_bd_pins axi_intc_0/s_axi_aclk] \
  [get_bd_pins axi_uartlite_0/s_axi_aclk] \
  [get_bd_pins cips_noc/aclk0] \
  [get_bd_pins proc_sys_reset_0/slowest_sync_clk] \
  [get_bd_pins smartconnect_0/aclk] \
  [get_bd_pins Serdes2/s_axi_lite_clk]
  connect_bd_net -net clk_wizard_0_locked  [get_bd_pins clk_wizard_0/locked] \
  [get_bd_pins proc_sys_reset_0/dcm_locked]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn  [get_bd_pins proc_sys_reset_0/peripheral_aresetn] \
  [get_bd_pins axi_gpio_0/s_axi_aresetn] \
  [get_bd_pins axi_intc_0/s_axi_aresetn] \
  [get_bd_pins axi_uartlite_0/s_axi_aresetn] \
  [get_bd_pins smartconnect_0/aresetn]

  # Create address segments
  assign_bd_address -offset 0x050000000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CIPS_0/FPD_AXI_NOC_0] [get_bd_addr_segs noc_lpddr4/S00_INI/C0_DDR_CH1x2] -force
  assign_bd_address -offset 0x060100000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CIPS_0/FPD_AXI_NOC_0] [get_bd_addr_segs noc_lpddr4/S00_INI/C0_DDR_CH2x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CIPS_0/FPD_AXI_NOC_0] [get_bd_addr_segs sys_noc_lpddr4/S00_INI/C0_DDR_LOW1] -force
  assign_bd_address -offset 0x050000000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CIPS_0/FPD_AXI_NOC_1] [get_bd_addr_segs noc_lpddr4/S00_INI/C0_DDR_CH1x2] -force
  assign_bd_address -offset 0x060100000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CIPS_0/FPD_AXI_NOC_1] [get_bd_addr_segs noc_lpddr4/S00_INI/C0_DDR_CH2x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CIPS_0/FPD_AXI_NOC_1] [get_bd_addr_segs sys_noc_lpddr4/S00_INI/C0_DDR_LOW1] -force
  assign_bd_address -offset 0x050000000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CIPS_0/FPD_CCI_NOC_0] [get_bd_addr_segs noc_lpddr4/S00_INI/C0_DDR_CH1x2] -force
  assign_bd_address -offset 0x060100000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CIPS_0/FPD_CCI_NOC_0] [get_bd_addr_segs noc_lpddr4/S00_INI/C0_DDR_CH2x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CIPS_0/FPD_CCI_NOC_0] [get_bd_addr_segs sys_noc_lpddr4/S00_INI/C0_DDR_LOW1] -force
  assign_bd_address -offset 0x050000000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CIPS_0/FPD_CCI_NOC_1] [get_bd_addr_segs noc_lpddr4/S00_INI/C0_DDR_CH1x2] -force
  assign_bd_address -offset 0x060100000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CIPS_0/FPD_CCI_NOC_1] [get_bd_addr_segs noc_lpddr4/S00_INI/C0_DDR_CH2x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CIPS_0/FPD_CCI_NOC_1] [get_bd_addr_segs sys_noc_lpddr4/S00_INI/C0_DDR_LOW1] -force
  assign_bd_address -offset 0x050000000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CIPS_0/FPD_CCI_NOC_2] [get_bd_addr_segs noc_lpddr4/S00_INI/C0_DDR_CH1x2] -force
  assign_bd_address -offset 0x060100000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CIPS_0/FPD_CCI_NOC_2] [get_bd_addr_segs noc_lpddr4/S00_INI/C0_DDR_CH2x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CIPS_0/FPD_CCI_NOC_2] [get_bd_addr_segs sys_noc_lpddr4/S00_INI/C0_DDR_LOW1] -force
  assign_bd_address -offset 0x050000000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CIPS_0/FPD_CCI_NOC_3] [get_bd_addr_segs noc_lpddr4/S00_INI/C0_DDR_CH1x2] -force
  assign_bd_address -offset 0x060100000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CIPS_0/FPD_CCI_NOC_3] [get_bd_addr_segs noc_lpddr4/S00_INI/C0_DDR_CH2x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CIPS_0/FPD_CCI_NOC_3] [get_bd_addr_segs sys_noc_lpddr4/S00_INI/C0_DDR_LOW1] -force
  assign_bd_address -offset 0x050000000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CIPS_0/LPD_AXI_NOC_0] [get_bd_addr_segs noc_lpddr4/S00_INI/C0_DDR_CH1x2] -force
  assign_bd_address -offset 0x060100000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CIPS_0/LPD_AXI_NOC_0] [get_bd_addr_segs noc_lpddr4/S00_INI/C0_DDR_CH2x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CIPS_0/LPD_AXI_NOC_0] [get_bd_addr_segs sys_noc_lpddr4/S00_INI/C0_DDR_LOW1] -force
  assign_bd_address -offset 0xA4010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces CIPS_0/M_AXI_FPD] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] -force
  assign_bd_address -offset 0xA4000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces CIPS_0/M_AXI_FPD] [get_bd_addr_segs axi_intc_0/S_AXI/Reg] -force
  assign_bd_address -offset 0xA4020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces CIPS_0/M_AXI_FPD] [get_bd_addr_segs axi_uartlite_0/S_AXI/Reg] -force
  assign_bd_address -offset 0xA4040000 -range 0x00040000 -target_address_space [get_bd_addr_spaces CIPS_0/M_AXI_FPD] [get_bd_addr_segs Serdes1/gt_quad_base_0/AXI_LITE/Reg] -force
  assign_bd_address -offset 0xA4080000 -range 0x00040000 -with_name SEG_gt_quad_base_0_Reg_1 -target_address_space [get_bd_addr_spaces CIPS_0/M_AXI_FPD] [get_bd_addr_segs Serdes2/gt_quad_base_0/AXI_LITE/Reg] -force
  assign_bd_address -offset 0x050000000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CIPS_0/PMC_NOC_AXI_0] [get_bd_addr_segs noc_lpddr4/S00_INI/C0_DDR_CH1x2] -force
  assign_bd_address -offset 0x060100000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CIPS_0/PMC_NOC_AXI_0] [get_bd_addr_segs noc_lpddr4/S00_INI/C0_DDR_CH2x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CIPS_0/PMC_NOC_AXI_0] [get_bd_addr_segs sys_noc_lpddr4/S00_INI/C0_DDR_LOW1] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  # Create PFM attributes
  set_property PFM_NAME {xilinx.com:xcvp1202-vsva2785-2MP-e-S:extensible_platform_base:1.0} [get_files [current_bd_design].bd]
  set_property PFM.CLOCK {clk_out1 {id "0" is_default "true" proc_sys_reset "/proc_sys_reset_0" status "fixed"}} [get_bd_cells /clk_wizard_0]
  set_property PFM.AXI_PORT {S00_AXI {memport "S_AXI_NOC" sptag "DDR"} S01_AXI {memport "S_AXI_NOC" sptag "DDR"} S02_AXI {memport "S_AXI_NOC" sptag "DDR"} S03_AXI {memport "S_AXI_NOC" sptag "DDR"} S04_AXI {memport "S_AXI_NOC" sptag "DDR"} S05_AXI {memport "S_AXI_NOC" sptag "DDR"} S06_AXI {memport "S_AXI_NOC" sptag "DDR"} S07_AXI {memport "S_AXI_NOC" sptag "DDR"} S08_AXI {memport "S_AXI_NOC" sptag "DDR"} S09_AXI {memport "S_AXI_NOC" sptag "DDR"} S10_AXI {memport "S_AXI_NOC" sptag "DDR"} S11_AXI {memport "S_AXI_NOC" sptag "DDR"} S12_AXI {memport "S_AXI_NOC" sptag "DDR"} S13_AXI {memport "S_AXI_NOC" sptag "DDR"}} [get_bd_cells /sys_noc_lpddr4]
  set_property PFM.AXI_PORT {S00_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S01_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S02_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S03_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S04_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S05_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S06_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S07_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S08_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S09_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S10_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S11_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S12_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S13_AXI {memport "S_AXI_NOC" sptag "LPDDR"}} [get_bd_cells /noc_lpddr4]


  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


