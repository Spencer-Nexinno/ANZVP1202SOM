set_property SRC_FILE_INFO {cfile:c:/FPGA_Proj/ANZVP1202SOM/build/ANZVP1202SOM_01/ANZVP1202SOM_01.gen/sources_1/bd/bd_system/ip/bd_system_proc_sys_reset_0_0/bd_system_proc_sys_reset_0_0.xdc rfile:../build/ANZVP1202SOM_01/ANZVP1202SOM_01.gen/sources_1/bd/bd_system/ip/bd_system_proc_sys_reset_0_0/bd_system_proc_sys_reset_0_0.xdc id:1 order:EARLY scoped_inst:bd_system_i/proc_sys_reset_0/U0} [current_design]
set_property SRC_FILE_INFO {cfile:c:/FPGA_Proj/ANZVP1202SOM/build/ANZVP1202SOM_01/ANZVP1202SOM_01.gen/sources_1/bd/bd_system/ip/bd_system_smartconnect_0_0/bd_0/ip/ip_1/bd_b731_psr_aclk_0.xdc rfile:../build/ANZVP1202SOM_01/ANZVP1202SOM_01.gen/sources_1/bd/bd_system/ip/bd_system_smartconnect_0_0/bd_0/ip/ip_1/bd_b731_psr_aclk_0.xdc id:2 order:EARLY scoped_inst:bd_system_i/smartconnect_0/inst/clk_map/psr_aclk/U0} [current_design]
set_property SRC_FILE_INFO {cfile:c:/FPGA_Proj/ANZVP1202SOM/build/ANZVP1202SOM_01/ANZVP1202SOM_01.gen/sources_1/bd/bd_system/ip/bd_system_gt_quad_base_0_0/bd_system_gt_quad_base_0_0.xdc rfile:../build/ANZVP1202SOM_01/ANZVP1202SOM_01.gen/sources_1/bd/bd_system/ip/bd_system_gt_quad_base_0_0/bd_system_gt_quad_base_0_0.xdc id:3 order:EARLY scoped_inst:bd_system_i/Serdes/gt_quad_base_0/inst} [current_design]
current_instance bd_system_i/proc_sys_reset_0/U0
set_property src_info {type:SCOPED_XDC file:1 line:50 export:INPUT save:INPUT read:READ} [current_design]
create_waiver -type CDC -id {CDC-11} -user "proc_sys_reset" -desc "Timing uncritical paths" -tags "1171415" -scope -internal -to [get_pins -quiet -filter REF_PIN_NAME=~*D -of_objects [get_cells -hierarchical -filter {NAME =~ */ACTIVE_LOW_AUX.ACT_LO_AUX/GENERATE_LEVEL_P_S_CDC.SINGLE_BIT.CROSS_PLEVEL_IN2SCNDRY_IN_cdc_to}]]
current_instance
current_instance bd_system_i/smartconnect_0/inst/clk_map/psr_aclk/U0
set_property src_info {type:SCOPED_XDC file:2 line:50 export:INPUT save:INPUT read:READ} [current_design]
create_waiver -type CDC -id {CDC-11} -user "proc_sys_reset" -desc "Timing uncritical paths" -tags "1171415" -scope -internal -to [get_pins -quiet -filter REF_PIN_NAME=~*D -of_objects [get_cells -hierarchical -filter {NAME =~ */ACTIVE_LOW_AUX.ACT_LO_AUX/GENERATE_LEVEL_P_S_CDC.SINGLE_BIT.CROSS_PLEVEL_IN2SCNDRY_IN_cdc_to}]]
current_instance
current_instance bd_system_i/Serdes/gt_quad_base_0/inst
set_property src_info {type:SCOPED_XDC file:3 line:42 export:INPUT save:INPUT read:READ} [current_design]
create_waiver -internal -scope -type CDC -id {CDC-11} -user "gt_quad_base" -tags "1126726" -desc "Synchronizer on the TX rate port to latch on APB3CLK exsist.The CDC-11 warning is waived as it is safe" -to [get_pins -hier -filter {NAME =~ */ch*_*x_function_inst/synch_vec_*xrate[*].*XRATE_xpm_internal_sync/syncstages_ff_reg[*]/D }]
set_property src_info {type:SCOPED_XDC file:3 line:44 export:INPUT save:INPUT read:READ} [current_design]
create_waiver -internal -scope -type CDC -id {CDC-11} -user "gt_quad_base" -desc "CDC-11 waived as it is safe" -to [get_pins -hier -filter {NAME =~ */ch*_*x_function_inst/*XPRERATECHANGE_xpm_internal_sync/syncstages_ff_reg[0]/D}]
set_property src_info {type:SCOPED_XDC file:3 line:45 export:INPUT save:INPUT read:READ} [current_design]
create_waiver -internal -scope -type CDC -id {CDC-11} -user "gt_quad_base" -desc "CDC-11 waived as it is safe" -to [get_pins -hier -filter {NAME =~ */ch*_*x_function_inst/MST*XRESET_xpm_internal_sync/syncstages_ff_reg[0]/D}]
set_property src_info {type:SCOPED_XDC file:3 line:46 export:INPUT save:INPUT read:READ} [current_design]
create_waiver -internal -scope -type CDC -id {CDC-11} -user "gt_quad_base" -desc "CDC-11 waived as it is safe" -to [get_pins -hier -filter {NAME =~ */ch*_*x_function_inst/*XDATAPATHRESET_xpm_internal_sync/syncstages_ff_reg[0]/D}]
set_property src_info {type:SCOPED_XDC file:3 line:47 export:INPUT save:INPUT read:READ} [current_design]
create_waiver -internal -scope -type CDC -id {CDC-11} -user "gt_quad_base" -desc "CDC-11 waived as it is safe" -to [get_pins -hier -filter {NAME =~ */ch*_*x_function_inst/synch_vec_*xprbssel[*].*XPRBS_xpm_internal_sync/syncstages_ff_reg[0]/D}]
