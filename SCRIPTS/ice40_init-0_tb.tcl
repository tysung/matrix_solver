#
#
set repodir {/nas/home/tsung/CODE/cift-internal_feb2024} 
set workdir ${repodir}/workspace/init-0_simulation
set package ${repodir}/venv/lib/python3.9/site-packages 
#
cd $workdir 
#
create_project -force -part xc7k70tfbg676-2 dbg_prj  dbg_prj 
set_property default_lib work [current_project]
# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}
set src1_obj [get_filesets sources_1]
#
set files [list \
 [file normalize "${workdir}/bram_constants.vhd"] \
 [file normalize "${package}/cift_lattice/ice40/hdl/single_port_bram.vhd"] \
 [file normalize "${workdir}/bram_facade.vhd"] \
 [file normalize "${workdir}/march_constants_pkg.vhd"] \
 [file normalize "${workdir}/march_generic_pkg.vhd"] \
 [file normalize "${package}/cift/builders/bram/single_port/hdl/march_read_pkg.vhd"] \
 [file normalize "${workdir}/march_generic.vhd"] \
 [file normalize "${package}/cift_lattice/ice40/hdl/ebr_tpg_constants_pkg.vhd"] \
 [file normalize "${workdir}/generic_tpg_converter.vhd"] \
 [file normalize "${package}/cift/builders/bram/hdl/ora.vhd"] \
 [file normalize "${package}/cift/builders/bram/hdl/capture.vhd"] \
 [file normalize "${workdir}/test_arch.vhd"] \
 [file normalize "${package}/cift/builders/bram/hdl/harness.vhd"] \
 [file normalize "${package}/cift_lattice/ice40/hdl/testbench.vhd"]
]
#
add_files -norecurse -fileset $src1_obj $files
#
update_compile_order -fileset sources_1
#
foreach rtl_file $files {
	set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$rtl_file"]]
	set_property -name "file_type" -value "VHDL" -objects $file_obj
	set_property -name "library" -value "work" -objects $file_obj
}
#
#
# [file normalize "$sim_dir/multitile_tb.sv"]
set_property SOURCE_SET sources_1 [get_filesets sim_1]
#add_files -fileset sim_1 -norecurse -scan_for_includes $sim_dir/multitile_tb.sv 
#set_property library work [get_files  $sim_dir/multitile_tb.sv]
update_compile_order -fileset sim_1
set_property TARGET_SIMULATOR XSim [current_project]
set_property top testbench [get_filesets sim_1]
set_property -name {xsim.simulate.runtime} -value {10us} -objects [get_filesets sim_1]
launch_simulation -mode behavioral 
#xsim --gui
#
#
close_project
#save_project_as -force prj_sim
#
start_gui 
#
#
