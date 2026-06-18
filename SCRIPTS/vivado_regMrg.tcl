#
#
set workdir /home/tsung/CODE/galactic-gopher/test_designs/optimizations/register_merging
#set repo_dir $workdir/../REPO_DIR 
#
cd $workdir 
#
create_project -force -part xc7k70tfbg676-2 dbg_prj  dbg_prj 
#
#link_design -part xc7k70tfbg676-2 
#set prj_obj [get_projects dbg_prj]
#
read_verilog -library work $workdir/inferred.v
#
#
synth_design -top top
#
write_verilog post_synth.v -write_all_overrides -mode funcsim -force
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

