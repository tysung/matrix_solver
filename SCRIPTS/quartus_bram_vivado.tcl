#
#
set repodir {/nas/home/tsung/CODE/cift-travis} 
set workdir ${repodir}/workspace/work/marchs2pf_2kx10_tdp/files
set install ${repodir}/installations/full
set package ${install}/python/lib/python3.9/site-packages 
#
cd $workdir 
#
create_project -force -part xc7k480tffv1156-1 prj_sim  prj_sim 
set_property default_lib work [current_project]
#
# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}
set src1_obj [get_filesets sources_1]
#
set files [list \
 [file normal ${workdir}/bram_constants.vhd] \
 [file normal ${workdir}/dual_port_bram.vhd] \
 [file normal ${workdir}/intel_port_constants_pkg.vhd] \
 [file normal ${workdir}/dp_bram_facade.vhd] \
 [file normal ${workdir}/march_constants_pkg.vhd] \
 [file normal ${workdir}/march_generic_pkg.vhd] \
 [file normal ${workdir}/march_s2pf_pkg.vhd] \
 [file normal ${workdir}/march_generic_dp.vhd] \
 [file normal ${workdir}/standard_port_constants_pkg.vhd] \
 [file normal ${workdir}/generic_dp_tpg_converter.vhd] \
 [file normal ${workdir}/ora.vhd] \
 [file normal ${workdir}/capture.vhd] \
 [file normal ${workdir}/test_arch.vhd] \
 [file normal ${workdir}/harness.vhd] \
 [file normal ${workdir}/testbench.vhd] 
]
#
add_files -norecurse -fileset $src1_obj $files
#
foreach rtl_file $files {
	set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$rtl_file"]]
	set_property -name "file_type" -value "VHDL" -objects $file_obj
	#set_property -name "file_type" -value "SystemVerilog" -objects $file_obj
	set_property -name "library" -value "work" -objects $file_obj
}
#set vlg_file [file normal "${workdir}/agfb014r24b-iowrapper-50MHz.v"]
#puts "debug 1"
#add_files -norecurse -fileset $src1_obj [list $vlg_file]
#set_property -name "file_type" -value "Verilog" -objects [get_files -of_objects $src1_obj $vlg_file]
#set_property -name "library" -value "work" -objects [get_files -of_objects $src1_obj $vlg_file] 
# update_compile_order
#set_property IS_GLOBAL_INCLUDE 1 [get_files $rtl_dir/parameters.svh]
#set_property IS_GLOBAL_INCLUDE 1 [get_files $rtl_dir/validready_buffers.svh]
update_compile_order -fileset sources_1
#
#
set_property SOURCE_SET sources_1 [get_filesets sim_1]
#add_files -fileset sim_1 -norecurse -scan_for_includes $sim_dir/multitile_tb.sv 
#set_property library work [get_files  $sim_dir/multitile_tb.sv]
update_compile_order -fileset sim_1
set_property TARGET_SIMULATOR XSim [current_project]
set_property top testbench [get_filesets sim_1]
#synth_design -top harness 
set_property -name {xsim.simulate.runtime} -value {10us} -objects [get_filesets sim_1]
launch_simulation -mode behavioral 
#xsim --gui
#
#write_verilog post_layout.v -write_all_overrides -mode funcsim -force
#
#place_design
#route_design
#write_checkpoint -force $workdir/_ROUTED.dcp
#
#write_bitstream vivado_bram.bit -mask_file -force
#
#close_project
#save_project_as -force prj_sim
#
start_gui 
#
