#
#
set repodir {/nas/home/tsung/CODE/cift-internal_05_2024} 
set workdir ${repodir}/workspace/inter_vcarry_sim/files
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
#set file1 "$rtl_dir/parameters.svh"
set file11 [file normalize "/opt/lscc/iCEcube2/verilog/sb_ice_syn.v"] 
#set file11 [file normalize $file1]
add_files -norecurse -fileset $src1_obj $file11
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file11"]]
set_property -name "file_type" -value "Verilog" -objects $file_obj
set_property -name "library" -value "work" -objects $file_obj
#
set files [list \
 [file normalize "${workdir}/constants_pkg.vhd"] \
 [file normalize "${workdir}/inter_vcarry_src.vhd"] \
 [file normalize "${workdir}/inter_vcarry_dtn.vhd"] \
 [file normalize "${workdir}/inter_vcarry.vhd"] \
 [file normalize "${workdir}/plb.vhd"] \
 [file normalize "${workdir}/gold.vhd"] \
 [file normalize "${workdir}/inter_vcarry_tpg_6_3.vhd"] \
 [file normalize "${workdir}/ora.vhd"] \
 [file normalize "${workdir}/test_gen.vhd"] \
 [file normalize "${workdir}/capture_small.vhd"] \
 [file normalize "${workdir}/harness.vhd"] \
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
