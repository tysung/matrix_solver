#
#
set repo_dir {/import/home/tsung/CODE/sp7_cift-internal}
set workdir $repo_dir/temp/interconnect-xc7s50csga324-1-2021-04-05T16-53-52/1-interconnect/init-00000
cd $workdir 
#
#set_param messaging.disableStorage 1
#
link_design -part xc7s50csga324-1
set_property XPM_LIBRARIES XPM_MEMORY [current_project]
read_vhdl -library work $workdir/harness.vhd
read_vhdl -library work $repo_dir/interfaces/bscan_series7/io_wrapper_50MHz.vhd
synth_design -top top_level -flatten_hierarchy full
place_design
route_design
set_hierarchy_separator .
get_cells -of_objects [get_sites SLICE_X5Y5]
get_pins -filter "DIRECTION == IN" -of_objects [get_cells harness/uut]
get_nets -top_net_of_hierarchical_group -segments -of_objects [get_pins harness/uut.I0]
route_design -unroute -nets [get_nets harness/I0]
disconnect_net -objects {harness/uut.I0}
rename_net -to driver_net harness/I0
get_pins -filter "DIRECTION == OUT" -of_objects [get_cells harness/uut]
get_nets -top_net_of_hierarchical_group -segments -of_objects [get_pins harness/uut.O]
route_design -unroute -nets [get_nets harness/test_out]
disconnect_net -objects {harness/uut.O}
rename_net -to result_net harness/test_out
remove_cell harness/uut
write_checkpoint $workdir/harness.dcp
write_edif $workdir/harness.edf
close_project

