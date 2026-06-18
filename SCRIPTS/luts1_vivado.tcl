#
#
set workdir /nas/home/tsung/FORMALITY/VIVADO_TEST 
set repo_dir $workdir/../REPO_DIR 
#
cd $workdir 
#
create_project -force -part xc7k70tfbg676-2 dbg_prj  dbg_prj 
#
link_design -part xc7k70tfbg676-2 
#set prj_obj [get_projects dbg_prj]
set_property XPM_LIBRARIES XPM_MEMORY [current_project] 
#
read_vhdl -library work $workdir/constants_pkg.vhd
read_vhdl -library work $workdir/gold.vhd
read_vhdl -library work $repo_dir/lut_test_tpg_8_3-1.vhd
read_vhdl -library work $repo_dir/series7_slicel.vhd
read_vhdl -library work $workdir/plb.vhd
read_vhdl -library work $workdir/test_gen.vhd
#
read_vhdl -library work $repo_dir/ora.vhd
read_vhdl -library work $repo_dir/capture_small.vhd
read_vhdl -library work $repo_dir/harness.vhd
read_vhdl -library work $repo_dir/io_wrapper_50MHz.vhd
#set_property XPM_LIBRARIES {XPM_MEMORY XPM_FIFO XPM_CDC} [current_project] 
#
#set_property TARGET_SIMULATOR XSim [current_project]
#set_property top top_level [get_filesets sim_1]
#launch_simulation -mode behavioral 
#
synth_design -top top_level
#
#write_vhdl post_layout.vhd -write_all_overrides -include_xilinx_libs
write_verilog post_layout.v -write_all_overrides -mode funcsim -force
#
#place_design
#route_design
#write_checkpoint -force $workdir/_ROUTED.dcp
#
#write_bitstream vivado_luts1.bit -mask_file -force
#
save_project_as -force dbg_prj
#
#start_gui 

