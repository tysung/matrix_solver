#
#
set repo_dir {/import/home/tsung/IFT_QA/today/cift-internal}
set workdir $repo_dir/temp/all-slices-xc7z045ffg900-2-2021-05-18T15-55-02/1-luts1/build-00001
#
cd $workdir 
#
create_project -force -part xc7z045ffg900-2 dbg_prj  dbg_prj 
#
#set_param messaging.disableStorage 1
#link_design -part xc7s25csga324-1
#set prj_obj [get_projects dbg_prj]
#set_property XPM_LIBRARIES XPM_MEMORY [current_project] 
#
read_vhdl -library work $workdir/constants_pkg.vhd
#read_vhdl -library work $repo_dir/builders_repo/architectures/xilinx/spartan6/hdl/slice_ff-4.vhd
#read_vhdl -library work $workdir/plb.vhd
read_vhdl -library work $workdir/gold.vhd
read_vhdl -library work $repo_dir/builders_repo/architectures/xilinx/hdl/lut_test_tpg_8_3-1.vhd
read_vhdl -library work $repo_dir/code/main/ift/builders/plbs/hdl/ora.vhd
read_vhdl -library work $workdir/test_gen.vhd
read_vhdl -library work $repo_dir/code/main/ift/builders/plbs/hdl/capture_small.vhd
read_vhdl -library work $repo_dir/code/main/ift/builders/plbs/hdl/harness.vhd
#read_edif [glob $workdir/slice/*.edf]
add_file [glob $workdir/slice/*ngc]
add_file $repo_dir/interfaces/bscan_series7/io_wrapper.ucf 
read_vhdl -library work $repo_dir/interfaces/bscan_series7/io_wrapper_50MHz.vhd
#set_property XPM_LIBRARIES {XPM_MEMORY XPM_FIFO XPM_CDC} [current_project] 
#
#create_run -flow {XST 14} -name synth_1
#create_run -name synth_1 -part xc6slx45tfgg484-3 -flow {XST 14} first_pass
#create_run -flow {XST 14} -parent_run first_pass impl_1
# 
launch_runs synth_1 -jobs 4
wait_on_run synth_1
#synth_design -top top_level -part xc6slx45tfgg484-3
#
#create_run -name impl_1 -flow {ISE 14} -parent_run synth_1
launch_runs impl_1 -to_step bitgen -jobs 20
#launch_runs impl_1 -jobs 20
wait_on_run impl_1
#
#place_design
#
#route_design
#
#write_bitstream vivado_luts1.bit -mask_file -force
#
# save_project_as -force dbg_prj
#
#start_gui 
#
