#
#
set repo_dir {/nas/home/tsung/CODE/sp6_cift-internal}
set workdir $repo_dir/temp/interconnect-xc6slx45tfgg484-3-2021-07-13T12-25-52/1-interconnect/init-00000
#
cd $workdir 
#
create_project -force -part xc6slx45tfgg484-3 prj_1  prj_1 
#
#set_param messaging.disableStorage 1
#link_design -part xc7s25csga324-1
#set prj_obj [get_projects dbg_prj]
#set_property XPM_LIBRARIES XPM_MEMORY [current_project] 
#
read_vhdl -library work $workdir/harness.vhd
read_vhdl -library work $repo_dir/interfaces/bscan_spartan6/io_wrapper_50MHz.vhd
#
launch_runs synth_1 -jobs 4
wait_on_run synth_1
#synth_design -top top_level -part xc6slx45tfgg484-3
#
#create_run -name impl_1 -flow {ISE 14} -parent_run synth_1
launch_runs impl_1 -jobs 20
wait_on_run impl_1
#
#write_bitstream vivado_luts1.bit -mask_file -force
#
# save_project_as -force dbg_prj
#
start_gui 
#
