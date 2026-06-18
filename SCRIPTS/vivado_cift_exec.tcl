#
#
set workdir /nas/home/tsung/CODE/cift-internal_042026/vivado_workspace/work/artix7_luts1_LOC
#
set_param general.maxThreads 1
create_project project_2 project_2 -part xc7a200tfbg676-1
#link_design -part xc7a200tfbg676-1 
read_edif $workdir/files/work/plb.edf
read_vhdl -library work -vhdl2019 $workdir/files/work/constants_pkg.vhd
read_vhdl -library work -vhdl2019 $workdir/files/work/gold.vhd
read_vhdl -library work -vhdl2019 $workdir/files/work/results_lookup_tpg.vhd
read_vhdl -library work -vhdl2019 $workdir/files/work/delayed_static_tpg_wrapper.vhd
read_vhdl -library work -vhdl2019 $workdir/files/work/ora.vhd
read_vhdl -library work -vhdl2019 $workdir/files/work/test_gen.vhd
read_vhdl -library work -vhdl2019 $workdir/files/work/capture_small.vhd
read_vhdl -library work -vhdl2019 $workdir/files/work/harness.vhd
read_vhdl -library work -vhdl2019 $workdir/files/work/io_wrapper_20MHz.vhd
add_files -fileset constrs_1 $workdir/files/work/io_wrapper.xdc
set_property used_in_synthesis false [get_files -of [get_filesets constrs_1]]
set_property XPM_LIBRARIES {XPM_MEMORY XPM_FIFO XPM_CDC} [current_project]
set_property top top_level [current_fileset]
launch_runs synth_1 -jobs 1
wait_on_runs synth_1
open_run synth_1 -name synth_1
#current_instance harness/test_region_i/SLICE_X82Y246
#set_property LOC "SLICE_X82Y246" [get_cells -hier -filter {REF_NAME!=GND && REF_NAME!=VCC && IS_PRIMITIVE && (PRIMITIVE_GROUP==CLB || PRIMITIVE_GROUP==DMEM || PRIMITIVE_GROUP==REGISTER || PRIMITIVE_GROUP==OTHERS || PRIMITIVE_GROUP==LUT || PRIMITIVE_GROUP==MUXFX || PRIMITIVE_GROUP==CARRY || PRIMITIVE_GROUP==FLOP_LATCH)}]
#current_instance
#current_instance harness/test_region_i/SLICE_X82Y247
#set_property LOC "SLICE_X82Y247" [get_cells -hier -filter {REF_NAME!=GND && REF_NAME!=VCC && IS_PRIMITIVE && (PRIMITIVE_GROUP==CLB || PRIMITIVE_GROUP==DMEM || PRIMITIVE_GROUP==REGISTER || PRIMITIVE_GROUP==OTHERS || PRIMITIVE_GROUP==LUT || PRIMITIVE_GROUP==MUXFX || PRIMITIVE_GROUP==CARRY || PRIMITIVE_GROUP==FLOP_LATCH)}]
#current_instance
#current_instance harness/test_region_i/SLICE_X82Y248
#set_property LOC "SLICE_X82Y248" [get_cells -hier -filter {REF_NAME!=GND && REF_NAME!=VCC && IS_PRIMITIVE && (PRIMITIVE_GROUP==CLB || PRIMITIVE_GROUP==DMEM || PRIMITIVE_GROUP==REGISTER || PRIMITIVE_GROUP==OTHERS || PRIMITIVE_GROUP==LUT || PRIMITIVE_GROUP==MUXFX || PRIMITIVE_GROUP==CARRY || PRIMITIVE_GROUP==FLOP_LATCH)}]
#current_instance
#current_instance harness/test_region_i/SLICE_X82Y249
#set_property LOC "SLICE_X82Y249" [get_cells -hier -filter {REF_NAME!=GND && REF_NAME!=VCC && IS_PRIMITIVE && (PRIMITIVE_GROUP==CLB || PRIMITIVE_GROUP==DMEM || PRIMITIVE_GROUP==REGISTER || PRIMITIVE_GROUP==OTHERS || PRIMITIVE_GROUP==LUT || PRIMITIVE_GROUP==MUXFX || PRIMITIVE_GROUP==CARRY || PRIMITIVE_GROUP==FLOP_LATCH)}]
#current_instance
place_design
route_design
write_checkpoint -force $workdir/_ROUTED.dcp
#
#write_bitstream vivado_bram.bit -mask_file -force
#
save_project_as -force project_2
#
start_gui 
#
