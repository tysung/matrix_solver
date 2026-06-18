#
#
set repo_dir {/import/home/tsung/CODE/sp7_cift-internal}
set workdir $repo_dir/temp/all-slices-xc7s25csga324-1-2021-04-19T13-17-22/1-srl16/build-00000
cd $workdir 
#
set_param messaging.disableStorage 1
cd $workdir
link_design -part xc7s25csga324-1
set_property XPM_LIBRARIES XPM_MEMORY [current_project]
read_vhdl -library work $workdir/constants_pkg.vhd
read_vhdl -library work $workdir/gold.vhd
read_vhdl -library work $repo_dir/code/main/ift/builders/plbs/hdl/srl_tpg.vhd
read_vhdl -library work $repo_dir/code/main/ift/builders/plbs/hdl/ora.vhd
read_vhdl -library work $workdir/test_gen.vhd
read_vhdl -library work $repo_dir/code/main/ift/builders/plbs/hdl/capture_small.vhd
read_vhdl -library work $repo_dir/code/main/ift/builders/plbs/hdl/harness.vhd
read_edif [glob $workdir/slice/*.edf]
read_vhdl -library work $repo_dir/interfaces/bscan_series7/io_wrapper_50MHz.vhd
set_property XPM_LIBRARIES {XPM_MEMORY XPM_FIFO XPM_CDC} [current_project]
synth_design -top top_level -part xc7s25csga324-1
#
write_checkpoint -force $workdir/_SYNTH.dcp
#
get_cells -hier test_i
current_instance harness/test_region_i/SLICE_X2Y0
set_property LOC "SLICE_X2Y0" [get_cells -hier -filter {REF_NAME!=GND && REF_NAME!=VCC && IS_PRIMITIVE && (PRIMITIVE_GROUP==CLB || PRIMITIVE_GROUP==DMEM || PRIMITIVE_GROUP==REGISTER || PRIMITIVE_GROUP==OTHERS || PRIMITIVE_GROUP==LUT || PRIMITIVE_GROUP==MUXFX || PRIMITIVE_GROUP==CARRY || PRIMITIVE_GROUP==FLOP_LATCH)}]
if {[catch {current_design} result]} {open_checkpoint $workdir/_SYNTHESIS.dcp}
place_design
if {[catch {current_design} result]} {open_checkpoint $workdir/_ROUTED.dcp}
route_design
write_checkpoint -force $workdir/_ROUTED_NEW.dcp
