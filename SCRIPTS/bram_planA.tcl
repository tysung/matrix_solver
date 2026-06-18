#
#
set repo_dir {/nas/home/tsung/CODE/sp6_cift-internal}
set workdir $repo_dir/temp/all-brams-xc6slx45tfgg484-3-2021-06-24T18-40-07/1-marchx_1kx18_dp/build-00000
#
cd $workdir 
#
create_project -force -part xc6slx45tfgg484-3 dbg_prj  dbg_prj 
#
#set_param messaging.disableStorage 1
#link_design -part xc7s25csga324-1
#set prj_obj [get_projects dbg_prj]
#set_property XPM_LIBRARIES XPM_MEMORY [current_project] 
#
read_vhdl -library work $workdir/bram_constants.vhd
read_vhdl -library work $repo_dir/builders_repo/architectures/xilinx/hdl/shared_clock_tdp_ram.vhd
read_vhdl -library work $repo_dir/code/main/ift/builders/bram/single_port/hdl/march_lr.vhd
read_vhdl -library work $workdir/sp2dp_converter.vhd
read_vhdl -library work $workdir/test_arch.vhd
#
#read_vhdl -library work $workdir/plb.vhd
#read_vhdl -library work $workdir/gold.vhd
#read_vhdl -library work $workdir/test_gen.vhd
read_vhdl -library work $repo_dir/code/main/ift/builders/bram/hdl/ora.vhd
read_vhdl -library work $repo_dir/code/main/ift/builders/bram/hdl/capture.vhd
read_vhdl -library work $repo_dir/code/main/ift/builders/bram/hdl/harness.vhd
#read_edif [glob $workdir/slice/*.edf]
#add_file [glob $workdir/slice/*ngc]
read_vhdl -library work $repo_dir/../sp6_cift-internal/interfaces/bscan_spartan6/io_wrapper_50MHz.vhd
#read_vhdl -library work $repo_dir/interfaces/bscan_series7/io_wrapper_50MHz.vhd
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
launch_runs impl_1 -jobs 20
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
start_gui 
#
