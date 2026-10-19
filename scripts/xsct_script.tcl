#
# Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#
# Author: Stephen MacMahon

proc generate_apps {args} {
	set app "hello_world"
	set repo ""
	set xsa "NULL"
	set hw_dtb ""
	set list_apps 0
	set multi 0
	set external_elf 0
	set proc "NULL"
	set force_plm 0
	set src_dir "NULL"
	for {set i 0} {$i < [llength $args]} {incr i} {
		if {[lindex $args $i] == "-app"} {
			set app [lindex $args [expr {$i + 1}]]
			if {[file extension $app] == ".elf"} {
				puts "Info: External ELF is used"
				set external_elf 1 
			}
		}
		if {[lindex $args $i] == "-repo"} {
			set repo [lindex $args [expr {$i + 1}]]
		}
		if {[lindex $args $i] == "-xsa"} {
			set xsa [lindex $args [expr {$i + 1}]]
			if {[file extension $xsa] != ".xsa" && $xsa != "NULL"} {
				puts "Error: $xsa is not a valid XSA file"
				set xsa "NULL" 
			}
		}
		if {[lindex $args $i] == "-hw_dtb"} {
			set hw_dtb [lindex $args [expr {$i + 1}]]
		}
		if {[lindex $args $i] == "-multi"} {
			set multi [lindex $args [expr {$i + 1}]]
		}
		if {[lindex $args $i] == "-list_apps"} {
			set list_apps 1
		}
		if {[lindex $args $i] == "-proc"} {
			set proc [lindex $args [expr {$i + 1}]]
		}
		if {[lindex $args $i] == "-force_plm"} {
			set force_plm [lindex $args [expr {$i + 1}]]
		}
		if {[lindex $args $i] == "-src_dir"} {
			set src_dir [lindex $args [expr {$i + 1}]] 
		}		
	}
    
	if {$xsa == "NULL"} {
		puts "Warning: No XSA passed. Looking in [pwd]"
		set xsa [glob -nocomplain -directory [pwd] -type f *.xsa]
		if {![llength $xsa]} {
			puts "Error: No XSA passed. Use -xsa to pass a Valid XSA file"
			return ""
		} 
		if {[llength $xsa] > 1} {
			puts "Error: More than one XSA found in [pwd]. Use -xsa to pass a Valid XSA file"
			return ""
		}
		
	}

	puts "Info: Using XSA file: $xsa"
    hsi::open_hw_design $xsa
	
	set arch [get_arch]
	puts "Info: Arch detected as $arch"
	
	if {$src_dir != "NULL"} {
		if {![file isdirectory $src_dir]} {
			puts "Error: $src_dir is not a directory."
			return ""
		} else {
			set files [glob -nocomplain -directory $src_dir -type f *.c *.h]
			if {[llength $files] == 0} {
				puts "Error: $src_dir is empty"
				return ""
			}
		}
	}
	
	if {$app == "empty_application" && $src_dir == ""} {
		puts "Error: empty_application used, but no -src_dir is passed."
		return ""
	}
	
	if {$multi == 1 && $arch == "versal"} {
		puts "Info: Multi versal Arch config. Extracting PDI file from XSA"
		exec unzip -j $xsa *.pdi -d plm_files
		set pdi [glob -nocomplain -directory plm_files -type f *.pdi]
		if {$pdi == ""} {
			puts "Error: No PDI file found in XSA. Exitting..."
			return ""
		}
		exec bootgen -arch versal -dump $pdi -dump_dir ./plm_files
		set pmc_cdo [glob -nocomplain -directory plm_files -type f pmc_cdo_*.bin]
		if {$pdi == ""} {
			puts "Error: No PMC CDO file found in PDI. Exitting..."
			return ""
		}
	}
	
	if {$proc != "NULL"} {
		set proc_found 0
		foreach sup_proc [get_supported_procs -open_xsa 0] {
			if {$proc == $sup_proc} {
				set proc $sup_proc
				set proc_found 1
				break;
			}
		}
		if {$proc_found  == 0} {
			puts "Error: $proc is not a valid processor in your XSA. Please use one of the following:"
			foreach sup_proc [get_supported_procs -open_xsa 0] {
				puts "\t * $sup_procs"
			}
			return ""
		}		
	} else {
		set sup_proc [get_supported_procs -open_xsa 0]
		if {[llength $sup_proc] != 0} {
			set proc [lindex $sup_proc 0]
			puts "Info: Using default processor ${proc}. Users can specify a processor using -proc"
		} else {
			puts "Error: No Valid processors found in XSA."
			return ""
		}

	}
	
	if {$repo != ""} {
		if {[file isdirectory $repo]} {
			puts "Using custom SW repo at $repo"
			hsi::set_repo_path $repo
		} else {
			puts "Warning: $repo is not a directory."
		}
	} else {
		puts "Info: No custom SW repository found. Users can pass this using the -repo option"
	}
	
	if {$app != "NULL"} {
		proc_app_exists -proc $proc -app $app
	}

	if {$app != "NULL"} {
		if {$external_elf == 0} {
			if {$list_apps == 1} {
				puts "Info: The list of supported app for your processor is:"
				foreach sapp [hsi::generate_app -proc $proc -sapp] {
					puts " * $sapp"
				}
				hsi::close_hw_design [hsi::current_hw_design]
				return ""
			}
			
			set supported 0
			foreach sapp [hsi::generate_app -proc $proc -sapp] {
				if {$app == $sapp} {
					set supported 1
					puts "Info $app is a supported app for your platform"
				}
			}
			
			if {$supported == 0} {
				puts "Error: Unsupported application $app. The list of supported app for your processor is:"
				foreach sapp [hsi::generate_app -proc $proc -sapp] {
					puts " * $sapp"
				}
				return ""
			}
			set app_name [create_app_name -app $app -proc $proc]
			set proc_type [lindex [split $app_name "_"] end-1]
			puts "Info: Creating $app template for $proc with name $app_name"
			if {$proc_type == "a72"} {
				set fileId [open a72.txt "a+"]
				set cpu_num [string range $proc end end]
				puts $fileId "-device loader,file=${app_name}/executable.elf,cpu-num=${cpu_num} "
				close $fileId
			} 
			if {$proc_type == "a53"} {
				set fileId [open a53.txt "a+"]
				set cpu_num [string range $proc end end]
				puts $fileId "-device loader,file=${app_name}/executable.elf,cpu-num=${cpu_num} "
				close $fileId
			}
			if {$proc_type == "a9"} {
				set fileId [open a9.txt "a+"]
				set cpu_num [string range $proc end end]
				puts $fileId "-device loader,file=${app_name}/executable.elf,cpu-num=${cpu_num} "
				close $fileId
			}
			
			if {$proc_type == "r5"} {
				set fileId [open r5.txt "a+"]
				set cpu_num [string range $proc end end]
				if {$arch == "versal"} {
					set cpu_num [expr {$cpu_num + 2}]
				} elseif {$arch == "zynquplus" || $arch == "zynquplusRFSOC"} {
					set cpu_num [expr {$cpu_num + 4}]
				} else {
					puts "Error: unexpected arch : $arch"
				}
				puts $fileId "-device loader,file=${app_name}/executable.elf,cpu-num=${cpu_num} "
				close $fileId
			}
			
			set app_design [hsi::create_sw_design $app_name -proc $proc -app $app]
			
			if {$proc_type == "r5"} {
				common::set_property -name APP_COMPILER_FLAGS -value "-g -mcpu=cortex-r5 -mfloat-abi=hard -mfpu=vfpv3-d16" -objects $app_design
			} else {
				common::set_property -name APP_COMPILER_FLAGS -value "-g" -objects $app_design
			}
			
			set stdio [get_stdio -open_xsa 0]
			if {$stdio == "0 0"} {
				puts "Info: No UART enabled in XSA. Trying coresight"
				foreach ip [hsi::get_mem_ranges -of_objects [hsi::get_cells -hier $proc]] {
					if {[common::get_property IP_NAME [hsi::get_cells -hier $ip]] == "psv_coresight" || [common::get_property IP_NAME [hsi::get_cells -hier $ip]] == "psu_coresight"} {
						puts "Info: Setting STDIN/OUT to $ip"
						common::set_property CONFIG.stdin $ip [hsi::get_os]
						common::set_property CONFIG.stdout $ip [hsi::get_os]
						break;
					}
				}
			}
			

			if {$app != "empty_application"} {
				hsi::generate_app -dir $app_name -compile
			} else {
				hsi::generate_app -dir $app_name
				foreach file [glob -nocomplain -directory $src_dir -type f *.c *.h *.ld] {
					file copy -force $file $app_name
				}
				exec make -C $app_name clean
				exec make -C $app_name
			}
			
		} else {
			puts "Info: Using external generated ELF: $app"
			set app_name [create_app_name -app $app -proc $proc]
			set proc_type [lindex [split $app_name "_"] end-1]
			if {[file exists $app_name]} {
				file delete -force $app_name
			}
			file mkdir $app_name
			file copy -force $app ${app_name}/executable.elf
			if {$proc_type == "a72"} {
				set fileId [open a72.txt "a+"]
				set cpu_num [string range $proc end end]
				puts $fileId "-device loader,file=${app_name}/executable.elf,cpu-num=${cpu_num} "
				close $fileId
			} 
			if {$proc_type == "a53"} {
				set fileId [open a53.txt "a+"]
				set cpu_num [string range $proc end end]
				puts $fileId "-device loader,file=${app_name}/executable.elf,cpu-num=${cpu_num} "
				close $fileId
			}

			if {$proc_type == "a9"} {
				set fileId [open a9.txt "a+"]
				set cpu_num [string range $proc end end]
				puts $fileId "-device loader,file=${app_name}/executable.elf,cpu-num=${cpu_num} "
				close $fileId
			}
			
			if {$proc_type == "r5"} {
				set fileId [open r5.txt "a+"]
				set cpu_num [string range $proc end end]
				if {$arch == "versal"} {
					set cpu_num [expr {$cpu_num + 2}]
				} elseif {$arch == "zynquplus" || $arch == "zynquplusRFSOC"} {
					set cpu_num [expr {$cpu_num + 4}]
				} elseif {$arch == "zynq"} {
					set cpu_num [expr {$cpu_num + 2}]
				} else {
					puts "Error: unexpected arch : $arch"
				}
				puts $fileId "-device loader,file=${app_name}/executable.elf,cpu-num=${cpu_num} "
				close $fileId
			}
		}
	} else {
		puts "Info: This script will not generate an application. User should use Vitis to generate the application."
		foreach txt_file [glob -nocomplain -directory [pwd] -type f *a72*.txt *a53*.txt *r5*.txt] {
			puts "Info: deleting old app metadata $txt_file"
			file delete $txt_file
		}
		foreach app_folder [glob -nocomplain -directory [pwd] -type d *a72* *a53* *r5*] {
			if {[file extension $app_folder] != ".xsa"} {
				puts "Info: deleting old app $app_folder"
				file delete -force $app_folder
			}
		}
	}
	

	if {$multi == 1 && $arch == "versal"} {
		puts "Info: Creating PLM. Searching for PSV_PMC processor"
		foreach procs [hsi::get_cells -hier -filter {IP_TYPE==PROCESSOR}] {
			if {[common::get_property IP_NAME [hsi::get_cells -hier $procs]] == "psv_pmc"} {
				set proc $procs
				break;
			}
		}
		if {[file isdirectory versal_plm] } {
			if {$force_plm == 1} {
				file delete -force versal_plm
			} else {
				puts "Info: versal_plm already exists. Use -force_plm to force the creation of the PLM"
				file copy versal_plm/executable.elf plm_files/plm.elf
			}
		}
		
		if {![file isdirectory versal_plm] } {
			puts "Info: Using proc $proc for versal_plm application template"
			set app_design [hsi::create_sw_design versal_plm -proc $proc -app versal_plm]
			hsi::generate_app -dir versal_plm -compile
			file copy versal_plm/executable.elf plm_files/plm.elf
		}
	}

	if {$multi == 1} {
		if {$arch == "zynquplus" || $arch == "zynquplusRFSOC"} {
			puts "Info: Creating PLMFW. Searching for PSU_PMU processor"
			foreach procs [hsi::get_cells -hier -filter {IP_TYPE==PROCESSOR}] {
				if {[common::get_property IP_NAME [hsi::get_cells -hier $procs]] == "psu_pmu"} {
					set proc $procs
					break;
				}
			}
			if {[file isdirectory zynqmp_pmufw] } {
				if {$force_plm == 1} {
					file delete -force zynqmp_pmufw
				} else {
					puts "Info: zynqmp_pmufw already exists. Use -force_plm to force the creation of the PLM"
					file copy zynqmp_pmufw/executable.elf plm_files/plm.elf
				}
			}
			if {![file isdirectory zynqmp_pmufw] } {
				puts "Info: Using proc $proc for zynqmp_pmufw application template"
				set app_design [hsi::create_sw_design zynqmp_pmufw -proc $proc -app zynqmp_pmufw]
				hsi::generate_app -dir zynqmp_pmufw -compile
				file copy zynqmp_pmufw/executable.elf plm_files/plm.elf
			}
		}
	}	
	
    hsi::close_hw_design [hsi::current_hw_design]
}

proc build_qemu_dts {args} {
	set install ""
	for {set i 0} {$i < [llength $args]} {incr i} {
		if {[lindex $args $i] == "-install"} {
			set install [lindex $args [expr {$i + 1}]]
		}
	}
	if {$install == ""} {
		puts "Error: Install Path not set. Use the -install to pass this"
		return ""
	}
	
	puts "Info: Copying DTS files from ${install}/data/emulation/qemu/comp/dts to qemu-devicetrees"
	file copy -force ${install}/data/emulation/qemu/comp/dts qemu-devicetrees
}

proc remove_app {args} {
	set app_name ""
	for {set i 0} {$i < [llength $args]} {incr i} {
		if {[lindex $args $i] == "-app_name"} {
			set app_name [lindex $args [expr {$i + 1}]]
		}
	}
	
	if {$app_name == ""} {
		puts "Error: No application passed to remove_app"
		return ""
	}
	
	set proc [lindex [split $app_name "_"] end-1]
	
	set cpu_num [lindex [split $app_name "_"] end]
	
	if {[file isdirectory $app_name]} {
		puts "Warning: Application for ${proc}_${cpu_num} already exists. Deleting $app_name and its QEMU metadata "
		file delete -force $app_name
		if {[file exists ${proc}.txt]} {
			set fp [open ${proc}.txt r]
			set file_data [read $fp]
			close $fp

			set data [split $file_data "\n"]
		
			set fileId [open ${proc}.txt "w"]
		
			foreach line $data {
				if {![regexp "cpu-num=${cpu_num}" $line] && [string length $line] != 0} {
					puts $fileId $line
				}
			}
			close $fileId
		} else {
			puts "Error: ${proc}.txt doesnt exist"
		}
	} else {
		puts "Warning: $app_name does not exist in [PWD]"
	}
}

proc proc_app_exists {args} {
	set proc ""
	set app ""
	for {set i 0} {$i < [llength $args]} {incr i} {
		if {[lindex $args $i] == "-proc"} {
			set proc [lindex $args [expr {$i + 1}]]
		}
		if {[lindex $args $i] == "-app"} {
			set app [lindex $args [expr {$i + 1}]]
		}
	}
	
	
	if {$proc == ""} {
		puts "Error: No processor passed to proc_app_exists"
		return ""
	}
	
	if {$app == ""} {
		puts "Error: No application passed to proc_app_exists"
		return ""
	}
	
	set ip_name [common::get_property IP_NAME [hsi::get_cells -hier $proc]]
	
	if {$ip_name == "psv_cortexa72" || $ip_name == "psu_cortexa53"} {
		set proc_type [string range $proc end-4 end]
	}
	
	if {$ip_name == "psv_cortexr5" || $ip_name == "psu_cortexr5"} {
		set proc_type [string range $proc end-3 end]
	}
	
	if {$ip_name == "ps7_cortexa9" || $ip_name == "ps7_cortexr5"} {
		set proc_type [string range $proc end-3 end]
	}
	
	if {[file isdirectory ${app}_${proc_type}]} {
		remove_app -app_name ${app}_${proc_type}
	}
	
	set apps [glob -nocomplain -directory [pwd] -type d *${proc_type}*]
	if {$apps != ""} {
		foreach app $apps {
			remove_app -app_name [file rootname $apps]
		}
	}
}

proc generate_proc_string {} {
	set proc_string ""
	set arch [get_arch]
	
	if {$arch == "versal"} {
		set procs "a72 r5"
	} elseif {$arch == "zynquplus" || $arch == "zynquplusRFSOC"} {
		set procs "a53 r5"
	} elseif {$arch == "zynq"} {
		set procs "a9 r5"
	} else {
		puts "Error: Unsupported arch $arch"
	}
	

	foreach proc [split $procs] {
		if {[file exists ${proc}.txt]} {
			puts "Info: Configuring QEMU for $proc"
			set fp [open ${proc}.txt r]
			set file_data [read $fp]
			close $fp

			set data [split $file_data "\n"]
			
			#remove blank lines
			set cpu_num 0
			foreach line $data {
				if {$line != ""} {
					set cpu_num [expr {$cpu_num + 1}]
				}
			}
			set mask [string tolower [format %X [expr {0xF - [expr {$cpu_num + 0}]}]]]
			foreach line $data {
				set proc_string " ${proc_string}${line} "
			}
			
			if {$proc == "a72"} {
				set proc_string "${proc_string}-device loader,addr=0xfd1a0300,data=0x8000000${mask},data-len=4 "
			}
			
			if {$proc == "a53"} {
				set proc_string "${proc_string}-device loader,addr=0xfd1a0104,data=0x8000000${mask},data-len=4 "
			}

			if {$proc == "a9"} {
				set proc_string "${proc_string}-device loader,addr=0xf8000008,data=0xDF0D,data-len=4 -device loader,addr=0xf8000140,data=0x00500801,data-len=4 -device loader,addr=0xf800012c,data=0x1ed044d,data-len=4 -device loader,addr=0xf8000108,data=0x0001e008,data-len=4 -device loader,addr=0xF8000910,data=0xF,data-len=0x4 "
			}
			
			if {$proc == "r5"} {
				if {$arch == "versal"} {
					if {$cpu_num == 1} {
						puts "Info: Setting RPU to lockstep mode. Combine R5_0 and R5_1 TCM together, 256KB TCM is visible on R5_0"
						set proc_string "${proc_string}--device loader,addr=0xff5e0300,data=0x14,data-len=4 -device loader,addr=0xff9a0100,data=0x1,data-len=4 -device loader,addr=0xff9a0000,data=0x50,data-len=4 "
					} elseif {$cpu_num == 2} {
						puts "Info: Setting RPU to split mode. Use 128KB TCM with R5_0 and 128KB TCM with R5_1"
						set proc_string "${proc_string}--device loader,addr=0xff5e0300,data=0x14,data-len=4 -device loader,addr=0xff9a0100,data=0x1,data-len=4 -device loader,addr=0xff9a0200,data=0x1,data-len=4 -device loader,addr=0xff9a0000,data=0x8,data-len=4 "
					} else {
						puts "Error: Unexpected number of R5 processor apps. $cpu_num"
					}
				} elseif {$arch == "zynquplus" || $arch == "zynquplusRFSOC"} {
					if {$cpu_num == 1} {
						puts "Info: Setting RPU to lockstep mode."
						set proc_string "${proc_string}-device loader,addr=0xFF5E023C,data=0x80088fde,data-len=4 set mask [string tolower [format %X [expr {0xF - [expr {$cpu_num + 0}]}]]] "
					} elseif {$cpu_num == 2} {
						puts "Info: Setting RPU to split mode."
						set proc_string "${proc_string}-device loader,addr=0xFF5E023C,data=0x80088fdC,data-len=4 -device loader,addr=0xff9a0100,data=0x1,data-len=4 -device loader,addr=0xff9a0200,data=0x1,data-len=4 -device loader,addr=0xff9a0000,data=0x8,data-len=4 "
					} else {
						puts "Error: Unexpected number of R5 processor apps. $cpu_num"
					}
				} else {
					puts "Error: Unknown arch $arch"
				}
			}
		} else {
			puts "Info: No applications found for ${proc}"
			if {$proc == "a53"} {
				set cpu_num 1
				set mask [string tolower [format %X [expr {0xF - [expr {$cpu_num + 0}]}]]]
				set proc_string "${proc_string}-device loader,addr=0xfd1a0104,data=0x8000000${mask},data-len=4 -device loader,addr=0xffff0000,data=0x14000000,data-len=4 "
				puts "Info: Bringing a53 #0 out of reset, and placing a bootloop at OCM"
			}
			if {$proc == "a72"} {
				set cpu_num 1
				set mask [string tolower [format %X [expr {0xF - [expr {$cpu_num + 0}]}]]]
				set proc_string "${proc_string}-device loader,addr=0xfd1a0300,data=0x8000000${mask},data-len=4 -device loader,addr=0xffff0000,data=0x14000000,data-len=4 "
				puts "Info: Bringing a72 #0 out of reset, and placing a bootloop at OCM"
			}
			if {$proc == "a9"} {
				set cpu_num 1
				set mask [string tolower [format %X [expr {0xF - [expr {$cpu_num + 0}]}]]]
				set proc_string "${proc_string}-device loader,addr=0xf8000008,data=0xDF0D,data-len=4 -device loader,addr=0xf8000140,data=0x00500801,data-len=4 -device loader,addr=0xf800012c,data=0x1ed044d,data-len=4 -device loader,addr=0xf8000108,data=0x0001e008,data-len=4 -device loader,addr=0xF8000910,data=0xF,data-len=0x4 "
				puts "Info: Bringing a9 #0 out of reset, and placing a bootloop at OCM"
			}
		}
	}
	
	return $proc_string
}

proc create_app_name {args} {
	set app 0
	set proc 0
	for {set i 0} {$i < [llength $args]} {incr i} {
		if {[lindex $args $i] == "-app"} {
			set app [lindex $args [expr {$i + 1}]]
		}
		if {[lindex $args $i] == "-proc"} {
			set proc [lindex $args [expr {$i + 1}]]
		}
	}
	
	if {$proc == 0} {
		puts "Error: pass the proc using -proc"
		return ""
	}
	if {$app == 0} {
		puts "Error: pass the app using -app"
		return ""
	}
	
	
	if {[file extension $app] == ".elf"} {
		set app [file tail [file rootname $app]]
	} else {
		if {$app == "empty_application"} {
			set app "cust_app"
		}
	}
	
	set ip_name [common::get_property IP_NAME [hsi::get_cells -hier $proc]]
	
	if {$ip_name == "psv_cortexa72" || $ip_name == "psu_cortexa53"} {
		return "${app}_[string range $proc end-4 end]"
	}
	
	if {$ip_name == "psv_cortexr5" || $ip_name == "psu_cortexr5" } {
		return "${app}_[string range $proc end-3 end]"
	}
	
	if {$ip_name == "ps7_cortexa9" || $ip_name == "ps7_cortexr5" } {
		return "${app}_[string range $proc end-3 end]"
	}
	
	return $app
}



proc get_supported_procs {args} {
	set open_xsa 0
	set xsa "NULL"
	set sup_procs ""
	for {set i 0} {$i < [llength $args]} {incr i} {
		if {[lindex $args $i] == "-open_xsa"} {
			set open_xsa [lindex $args [expr {$i + 1}]]
		}
		if {[file extension $xsa] != ".xsa" && $xsa != "NULL"} {
			set xsa [lindex $args [expr {$i + 1}]]
			if {[file extension $xsa] != ".xsa"} {
				puts "Error: $xsa is not a valid XSA file"
				set xsa "NULL" 
			}
		}
	}
	
	if {$open_xsa == 1} {
		if {$xsa == "NULL"} {
			puts "Warning: No XSA passed. Looking in [pwd]"
			set xsa [glob -nocomplain -directory [pwd] -type f *.xsa]
			if {![llength $xsa]} {
				puts "Error: No XSA passed. Use -xsa to pass a Valid XSA file"
				return ""
			} 
		}
		hsi::open_hw_design $xsa
	}
	foreach procs [hsi::get_cells -hier -filter {IP_TYPE==PROCESSOR}] {
		set ip_name [common::get_property IP_NAME [hsi::get_cells -hier $procs]]
		if {$ip_name == "psv_cortexa72" || $ip_name == "psu_cortexa53" || $ip_name == "psv_cortexr5" || $ip_name == "psu_cortexr5" || $ip_name == "ps7_cortexa9"} {
			lappend sup_procs $procs
		}
	}

	if {$open_xsa == 1} {
		puts "Info: list of supported processors in your XSA are:"
		foreach procs $sup_procs {
			puts "\t * $procs"
		}
		hsi::close_hw_design [hsi::current_hw_design]
	} else {
		return $sup_procs
	}
}

proc get_arch {args} {
	set open_xsa 0
	for {set i 0} {$i < [llength $args]} {incr i} {
		if {[lindex $args $i] == "-open_xsa"} {
			set open_xsa 1
		}
	}
	
	if {$open_xsa == 1} {
		set xsa [glob -nocomplain -directory [pwd] -type f *.xsa *.hdf]
		hsi::open_hw_design $xsa
	}
	
	set arch [common::get_property FAMILY [hsi::current_hw_design]]
	
	if {$open_xsa == 1} {
		hsi::close_hw_design [hsi::current_hw_design]
	}
	
	return $arch
}

proc get_board {args} {
	set open_xsa 0
	for {set i 0} {$i < [llength $args]} {incr i} {
		if {[lindex $args $i] == "-open_xsa"} {
			set open_xsa 1
		}
	}
	
	if {$open_xsa == 1} {
		set xsa [glob -nocomplain -directory [pwd] -type f *.xsa *.hdf]
		hsi::open_hw_design $xsa
	}
	
	set board [common::get_property BOARD [hsi::current_hw_design]]
	set board [lindex [split $board ":"] 1]
	
	if {$open_xsa == 1} {
		hsi::close_hw_design [hsi::current_hw_design]
	}
	
	return $board
}

proc get_port {} {
	for {set port 9000} {$port <= 9100} {incr port} {
		if {![catch {
				set sock [socket -server localhost $port]
			}]} then {
				break
		}
	}
	# If we failed...
	if {![info exist sock]} {
		error "No ports free in range 9000-9100"
		return ""
	} else {
		return $port
	}
}

proc get_stdio {args} {
	set open_xsa 0
	set xsa "NULL"
	set uarts ""
	set stdio ""
	for {set i 0} {$i < [llength $args]} {incr i} {
		if {[lindex $args $i] == "-open_xsa"} {
			set open_xsa [lindex $args [expr {$i + 1}]]
		}
		if {[file extension $xsa] != ".xsa" && $xsa != "NULL"} {
			set xsa [lindex $args [expr {$i + 1}]]
			if {[file extension $xsa] != ".xsa"} {
				puts "Error: $xsa is not a valid XSA file"
				set xsa "NULL" 
			}
		}
	}
	
	if {$open_xsa == 1} {
		if {$xsa == "NULL"} {
			puts "Warning: No XSA passed. Looking in [pwd]"
			set xsa [glob -nocomplain -directory [pwd] -type f *.xsa]
			if {![llength $xsa]} {
				puts "Error: No XSA passed. Use -xsa to pass a Valid XSA file"
				return ""
			} 
		}
		hsi::open_hw_design $xsa
	}
		
	foreach ip [hsi::get_cells -hier *] {
		set ip_name [common::get_property IP_NAME [hsi::get_cells -hier $ip]]
		if {$ip_name == "psv_sbsauart" || $ip_name == "psu_uart" || $ip_name == "ps7_uart"} {
			lappend uarts $ip
		}
	}
	
	if {[llength $uarts] > 1} {
		puts "Info: More than 1 uart are enabled in XSA. This script will use the first uart detected"
		set uarts [lsort $uarts]
	}
	 
	set uart [string range [lindex $uarts 0] end end]
	set arch [get_arch]
	
	if {$uart == 0} {
		if {$arch == "versal"} {
			set stdio "0 0 1 0"
		} else {
			set stdio "1 0"
		}
	} elseif {$uart == 1} {
		if {$arch == "versal"} {
			set stdio "0 0 0 1"
		} else {
			set stdio "0 1"
		}
	} else {
		if {$arch == "versal"} {
			set stdio "0 0 0 0"
		} else {
			set stdio "0 0"
		}
	}
	
	if {$open_xsa == 1} {
		hsi::close_hw_design [hsi::current_hw_design]
	}
	return $stdio
}

proc generate_qemu_scripts {args} {
	set xsa "NULL"
	set tmp_dir "./tmp_dir"
	set install ""
	set aarch64_cmd ""
	set microblazeel_cmd ""
	set cosim 0
	set external_elf 0
	set os linux
	set multi 0
	set version ""
	set board "NULL"
	set repo ""
	for {set i 0} {$i < [llength $args]} {incr i} {
		if {[lindex $args $i] == "-xsa"} {
			set xsa [lindex $args [expr {$i + 1}]]
			if {[file extension $xsa] != ".xsa" && $xsa != "NULL"} {
				puts "Error: $xsa is not a valid XSA file"
				set xsa "NULL" 
			}
		}
		if {[lindex $args $i] == "-install"} {
			set install [lindex $args [expr {$i + 1}]]
		}
		if {[lindex $args $i] == "-multi"} {
			set multi [lindex $args [expr {$i + 1}]]
		}
		if {[lindex $args $i] == "-cosim"} {
			set cosim [lindex $args [expr {$i + 1}]]
		}
		if {[lindex $args $i] == "-tmp_dir"} {
			set tmp_dir [lindex $args [expr {$i + 1}]]
		}
		if {[lindex $args $i] == "-os"} {
			set os [lindex $args [expr {$i + 1}]]
		}
		if {[lindex $args $i] == "-version"} {
			set version [lindex $args [expr {$i + 1}]]
		}
		if {[lindex $args $i] == "-repo"} {
			set repo [lindex $args [expr {$i + 1}]]
		}
		if {[lindex $args $i] == "-board"} {
			set board [lindex $args [expr {$i + 1}]]
		}
	}

	if {$xsa == "NULL"} {
		puts "Warning: No XSA passed. Looking in [pwd]"
		set xsa [glob -nocomplain -directory [pwd] -type f *.xsa]
		if {![llength $xsa]} {
			puts "Error: No XSA passed. Use -xsa to pass a Valid XSA file"
			return ""
		} 
	}
	

	if {$os == "linux"} {
		if {$install == ""} {
			puts "Error: Install Path not set. Use the -install to pass this"
			return ""
		} else {
			if {$version < 2022.2} {
				set qemu ${install}/data/emulation/qemu/qemu/sysroots/x86_64-petalinux-linux/usr/bin/qemu-system
			} else {
				set qemu ${install}/data/emulation/qemu/comp/qemu/sysroots/x86_64-petalinux-linux/usr/bin/qemu-system
			}
			set qemu_append ""
		}
	} elseif {$os == "windows"} {
		if {$install == ""} {
			puts "Error: Install Path not set. Use the -install to pass this"
			return ""
		} else {
			set qemu ${install}/data/emulation/qemu_win/qemu/qemu-system
			set qemu_append ".exe"
		}
	} else {
		puts "Error: Unsupported OS: $os. Please pass a supported -os linux or windows"
		return ""
	}
	
	puts "Info: Using XSA file: $xsa"
    hsi::open_hw_design $xsa
	
	set arch [get_arch]
	puts "Info: Arch detected as $arch"
	
	if {$arch == ""} {
		puts "Error: No arch detected"
		return ""
	}
	
	if {$board != "NULL"} {
		set xsa_board [get_board]
		if {![regexp $board $xsa_board]} {
			puts "Info: $board has been selected. However, this XSA is targeting a $xsa_board"
			set board "NULL"
		}
	}
	
	set stdio [get_stdio -open_xsa 0]
	set stdio_string ""
	for {set i 0} {$i < [llength $stdio]} {incr i} {
		if {[lindex $stdio $i] == 1} {
			set stdio_string "$stdio_string -serial mon:stdio"
		} else {
			set stdio_string "$stdio_string -serial null"
		}
	}
	puts "Info: sdtio $stdio_string"
	
	if {$arch == "zynq"} {
		puts "Info: Generating the hw-dtb manually from XSA"
		generate_dtb -hw_file $xsa -version $version -repo $repo
	}
	
	if {$arch == "versal" || $arch == "zynquplus" || $arch == "zynquplusRFSOC"} {
		if {[file exists "my_dts"]} {
			file delete -force "my_dts"
		}		
	}
	
	if {$arch == "zynq" && $cosim == 1} {
		puts "Error: CoSim not supported on $arch"
		puts "No QEMU script will be generated."
		return ""
	}
	
	if {$arch == "zynq"} {
		set multi 0
	}
	
	set available_port [get_port]
	if {$available_port != ""} {
			set gdb_port "-gdb tcp::${available_port}"
	} else {
		set gdb_port ""
	}
	
	if {$multi == 1} {
		puts "Info: -machine-path set $tmp_dir"
		set machine_path "-machine-path $tmp_dir"
		if {$arch == "versal"} {
			set hw_dtb qemu-devicetrees/LATEST/MULTI_ARCH/board-versal-ps-vck190.dtb
		} elseif {$arch == "zynquplus" || $arch == "zynquplusRFSOC"} {
			set hw_dtb qemu-devicetrees/LATEST/MULTI_ARCH/board-zynqmp-zcu102.dtb
		} else {
			puts "Error: Unsupported arch $arch"
		}
		if {$board != "NULL"} {
			puts "Info: searching for $board hw_dtb"
			set board_dtb [lindex [glob -nocomplain -directory qemu-devicetrees/LATEST/MULTI_ARCH -type f *${board}*.dtb] 0]
			if {$board_dtb != ""} {
				puts "Info: Found board dtb $board_dtb"
				set hw_dtb $board_dtb
			} else {
				puts "Info: $board dtb not found. Using default dtb"
			}
		}
	} else {
		puts "Info: -machine-path set NULL"
		set machine_path ""
		if {$arch == "versal"} {
			set hw_dtb qemu-devicetrees/LATEST/SINGLE_ARCH/board-versal-ps-vck190.dtb
		} elseif {$arch == "zynquplus" || $arch == "zynquplusRFSOC"} {
			set hw_dtb qemu-devicetrees/LATEST/SINGLE_ARCH/board-zynqmp-zcu102.dtb
		} elseif {$arch == "zynq"} {
			set hw_dtb ./system.dtb
		} else {
			puts "Error: Unsupported arch $arch"
		}
		if {$board != "NULL"} {
			puts "Info: searching for $board hw_dtb"
			set board_dtb [lindex [glob -nocomplain -directory qemu-devicetrees/LATEST/SINGLE_ARCH -type f *${board}*.dtb] 0]
			if {$board_dtb != ""} {
				puts "Info: Found board dtb $board_dtb"
				set hw_dtb $board_dtb
			} else {
				puts "Info: $board dtb not found. Using default dtb"
			}
		}
	}

	if {$cosim == 1} {
		puts "Info: Co-Simulation Enabled."
		set machine_path "-machine-path $tmp_dir -sync-quantum 1000000"
		if {$multi == 1} {
			if {$arch == "versal"} {
				set hw_dtb qemu-devicetrees/LATEST/MULTI_ARCH/board-versal-ps-cosim-vitis-vck190.dtb
			} elseif {$arch == "zynquplus" || $arch == "zynquplusRFSOC"} {
				set hw_dtb qemu-devicetrees/LATEST/MULTI_ARCH/zcu102-arm.cosim.dtb
			} else {
				puts "Error: Unsupported arch $arch"
			}
		} else {
			if {$arch == "versal"} {
				set hw_dtb qemu-devicetrees/LATEST/SINGLE_ARCH/board-versal-ps-cosim-vck190.dtb
			} elseif {$arch == "zynquplus" || $arch == "zynquplusRFSOC"} {
				set hw_dtb qemu-devicetrees/LATEST/SINGLE_ARCH/zcu102-arm.cosim.dtb
			} else {
				puts "Error: Unsupported arch $arch"
			}
		}
			
	} 
	
	puts "Info: Using hw-dtb set to $hw_dtb"

		
	if {$arch == "versal"} {
		set proc_string [generate_proc_string]
		if {$multi == 1} {
			set pmc_cdo [glob -nocomplain -directory plm_files -type f pmc_cdo*.bin]
			if {$pmc_cdo == ""} {
				puts "Error: No pmc_cdo binary found in plm_files"
				return ""
			}
			set microblazeel_cmd "${qemu}-microblazeel${qemu_append} -M microblaze-fdt  \
			-serial mon:stdio -display none \
			-device loader,addr=0xf0000000,data=0xba020004,data-len=4 \
			-device loader,addr=0xf0000004,data=0xb800fffc,data-len=4 \
			-device loader,file=${pmc_cdo},addr=0xf2000000 \
			-device loader,file=plm_files/plm.elf \
			-hw-dtb qemu-devicetrees/LATEST/MULTI_ARCH/board-versal-pmc-virt.dtb \
			-machine-path $tmp_dir \
			-device loader,addr=0xF1110624,data=0x0,data-len=4 \
			-device loader,addr=0xF1110620,data=0x1,data-len=4"
			set aarch64_cmd "${qemu}-aarch64${qemu_append} -nographic -M arm-generic-fdt \
			$stdio_string -display none \
			$proc_string \
			$machine_path \
			-hw-dtb $hw_dtb -m 8G -display none $gdb_port\
			-net nic,netdev=eth0 -netdev user,id=eth0,tftp=/tftpboot -net nic"
		} else {
			set aarch64_cmd "${qemu}-aarch64${qemu_append} -nographic -M arm-generic-fdt \
			-serial null -serial null -serial mon:stdio -serial null -display none \
			$proc_string \
			$machine_path \
			-hw-dtb $hw_dtb -m 8G -display none $gdb_port \
			-net nic,netdev=eth0 -netdev user,id=eth0,tftp=/tftpboot -net nic"
		}
	} elseif {$arch == "zynquplus"} {
		set proc_string [generate_proc_string]
		if {$multi == 1} {
			set microblazeel_cmd "${qemu}-microblazeel${qemu_append} -M microblaze-fdt \
			-serial mon:stdio -serial /dev/null -display none \
			-kernel pmu_rom_qemu_sha3.elf \
			-device loader,file=plm_files/plm.elf \
			-hw-dtb qemu-devicetrees/LATEST/MULTI_ARCH/zynqmp-pmu.dtb \
			$machine_path \
			-device loader,addr=0xfd1a0074,data=0x1011003,data-len=4 \
			-device loader,addr=0xfd1a007C,data=0x1010f03,data-len=4"
			set aarch64_cmd "${qemu}-aarch64${qemu_append} -nographic -M arm-generic-fdt \
			$stdio_string -display none \
			$proc_string \
			$machine_path \
			-global xlnx,zynqmp-boot.use-pmufw=true \
			-hw-dtb $hw_dtb -m 8G -display none $gdb_port \
			-net nic -net nic -net nic -net nic,netdev=gem3 -netdev user,id=gem3,hostfwd=tcp:127.0.0.1:1540-10.0.2.15:1534"
		} else {
			set aarch64_cmd "${qemu}-aarch64${qemu_append} -nographic -M arm-generic-fdt \
			-serial mon:stdio -serial null -display none \
			$proc_string \
			$machine_path \
			-hw-dtb $hw_dtb -m 8G -display none $gdb_port \
			-net nic -net nic -net nic -net nic,netdev=gem3 -netdev user,id=gem3,hostfwd=tcp:127.0.0.1:1540-10.0.2.15:1534"
		}
	# Im not sure if this is the correct hw-dtb to use for zcu111
	} elseif {$arch == "zynquplusRFSOC"} {
		set proc_string [generate_proc_string]
		if {$multi == 1} {
			set microblazeel_cmd "${qemu}-microblazeel${qemu_append} -M microblaze-fdt \
			-serial mon:stdio -serial /dev/null -display none \
			-kernel pmu_rom_qemu_sha3.elf \
			-device loader,file=plm_files/plm.elf \
			-hw-dtb qemu-devicetrees/LATEST/MULTI_ARCH/zynqmp-pmu.dtb \
			-machine-path $tmp_dir \
			-device loader,addr=0xfd1a0074,data=0x1011003,data-len=4 \
			-device loader,addr=0xfd1a007C,data=0x1010f03,data-len=4"
			set aarch64_cmd "${qemu}-aarch64${qemu_append} -nographic -M arm-generic-fdt \
			$stdio_string -display none \
			$proc_string \
			$machine_path \
			-global xlnx,zynqmp-boot.use-pmufw=true \
			-hw-dtb $hw_dtb -m 8G -display none $gdb_port \
			-net nic -net nic -net nic -net nic,netdev=gem3 -netdev user,id=gem3,hostfwd=tcp:127.0.0.1:1540-10.0.2.15:1534"
		} else {
			set aarch64_cmd "${qemu}-aarch64${qemu_append} -nographic -M arm-generic-fdt \
			$stdio_string -display none \
			$proc_string \
			$machine_path \
			-hw-dtb $hw_dtb -m 8G -display none $gdb_port \
			-net nic -net nic -net nic -net nic,netdev=gem3 -netdev user,id=gem3,hostfwd=tcp:127.0.0.1:1540-10.0.2.15:1534"
		}
	} elseif {$arch == "zynq"} {
		set proc_string [generate_proc_string]
		set aarch64_cmd "${qemu}-aarch64${qemu_append} -nographic -M arm-generic-fdt-7series \
		-serial null -serial mon:stdio -display none \
		$proc_string \
		-hw-dtb $hw_dtb -m 8G -display none $gdb_port \
		-net nic,netdev=gem0 -netdev user,id=gem0,hostfwd=tcp:127.0.0.1:1540-10.0.2.15:1534"
	} else {
		puts "Error: Unsupported arch $arch"
	}
	if {$os == "linux"} {
		set script_type ".sh"
	} else {
		set script_type ".bat"
	}
	if {$multi == 1} {
		set fileId [open run_qemu_microblazeel${script_type} "w"]
		puts $fileId "echo 'INFO: Starting microblaze QEMU'"
		puts $fileId "echo 'INFO: $microblazeel_cmd'"
		puts $fileId $microblazeel_cmd
		close $fileId
	}
	set fileId [open run_qemu_aarch64${script_type}  "w"]
	puts $fileId "echo 'INFO: Starting aarch64 QEMU'"
	puts $fileId "echo 'INFO: TCP PORT is free $available_port'"
	puts $fileId "echo 'INFO: $aarch64_cmd'"
	puts $fileId $aarch64_cmd
	close $fileId
	set fileId [open run_qemu${script_type}  "w"]
	if {$multi == 1} {
		puts $fileId "source run_qemu_microblazeel${script_type}  &"
	}
	if {$os == "linux"} {
		puts $fileId "source run_qemu_aarch64${script_type} "
	}
	if {$os == "windows"} {
		puts $fileId "run_qemu_aarch64${script_type} "
		puts $fileId "pause"
	}
	close $fileId
	puts "Info: run_qemu script generated. Use the make run_qemu command to test the app on QEMU"
}

proc generate_dtb {args} {
    set version 2023.2
	set hw_file "NULL"
	set dtg_options ""
	set repo ""
	set open_xsa 0
    for {set i 0} {$i < [llength $args]} {incr i} {
        if {[lindex $args $i] == "-version"} {
            set version [string toupper [lindex $args [expr {$i + 1}]]]
        }
        if {[lindex $args $i] == "-dtg_options"} {
            set dtg_options [lindex $args [expr {$i + 1}]]
        }
        if {[lindex $args $i] == "-repo"} {
            set repo [lindex $args [expr {$i + 1}]]
        }
		if {[lindex $args $i] == "-open_xsa"} {
			set open_xsa [lindex $args [expr {$i + 1}]]
		}
    }
	
	if {$open_xsa == 1} {
		set xsa [glob -nocomplain -directory [pwd] -type f *.xsa *.hdf]
		hsi::open_hw_design $xsa
	}
	
	set vivado_version [common::get_property VIVADO_VERSION [hsi::current_hw_design]]
	if {$version != $vivado_version} {
		puts "Warning: Vivado Version : $vivado_version is out of sync with DTG version : $version"
	}
	set proc [lindex [get_supported_procs -open_xsa 0] 0]
	puts "Info: Using processor $proc"
	set board [get_board -open_xsa 0]
	if {$board != ""} {
		puts "Info: Board detected as $board"
	}
	if {$repo == ""} {
		puts "Error: No repo passed". Use -repo to pass a repo path
	}
	hsi::set_repo_path $repo
	hsi::create_sw_design device-tree -os device_tree -proc $proc
	if {$dtg_options != ""} {
		foreach options_arr [split $dtg_options] {
			hsi set_property CONFIG.${options_arr} true [hsi get_os]
		}
	}

	hsi::generate_target -dir my_dts
	if {![file exists my_dts/include/dt-bindings/]} {
		file mkdir my_dts/include/dt-bindings
	}
	foreach lib [glob -nocomplain -directory repo/my_dtg/device-tree-xlnx/device_tree/data/kernel_dtsi/${version}/include/dt-bindings -type d *] {
		if {![file exists my_dts/include/dt-bindings/[file tail $lib]]} {
			file copy -force $lib my_dts/include/dt-bindings
		}
	}
	if {$board != ""} {
		set fp [open my_dts/system-top.dts "r"] 
		set file_data [read $fp]
		close $fp
		set data [split $file_data "\n"]
		set fp [open my_dts/system-top.dts "w"]
		foreach line $data {
			if {[regexp {zynqmp-clk-ccf.dtsi} $line]} {
				puts $fp "#include \"zynqmp-clk-ccf.dtsi\""
				puts $fp "#include \"${board}.dtsi\""
			} elseif {[regexp {versal-clk.dtsi} $line]} {
				puts $fp "#include \"versal-clk.dtsi\""
				puts $fp "#include \"${board}.dtsi\""
			} elseif {[regexp {zynq-7000.dtsi} $line]} {
				puts $fp "#include \"zynq-7000.dtsi\""
				puts $fp "#include \"${board}.dtsi\""
			} else {
				puts $fp $line
			}
		}
		puts $fp "#include \"system-user.dtsi\""
		close $fp
	}
	set fileId [open my_dts/system-conf.dtsi "w"]
	close $fileId
	set fileId [open my_dts/system-user.dtsi "w"]
	puts $fileId "/include/ \"system-conf.dtsi\""
	puts $fileId "/ {"
	puts $fileId "};"
	close $fileId
	if {$open_xsa == 1} {
		hsi::close_hw_design [hsi::current_hw_design]
	}
}

proc get_board {args} {
	set open_xsa 0
	set board ""
	for {set i 0} {$i < [llength $args]} {incr i} {
		if {[lindex $args $i] == "-open_xsa"} {
			set open_xsa [lindex $args [expr {$i + 1}]]
		}
	}
	
	if {$open_xsa == 1} {
		set xsa [glob -nocomplain -directory [pwd] -type f *.xsa *.hdf]
		hsi::open_hw_design $xsa
	}
	
	
	set xsa_board [common::get_property BOARD [hsi::current_hw_design]]
	set xsa_board [lindex [split $xsa_board ":"] 1]
	if {$xsa_board != ""} {
		set board [lindex [split $xsa_board "_"] 0]
	} else {
		set board ""
	}
	
	if {$open_xsa == 1} {
		hsi::close_hw_design [hsi::current_hw_design]
	}
	
	return $board
}
