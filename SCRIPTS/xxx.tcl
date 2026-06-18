#-----------------------------------------------------------
# Vivado v2018.3 (64-bit)
# SW Build 2405991 on Thu Dec  6 23:36:41 MST 2018
# IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
# Start of session at: Fri Mar 12 17:50:11 2021
# Process ID: 27400
# Current directory: /import/home/tsung/CODE/sp7_cift-internal/temp/one-slicel-xc7s100fgga676-1-2021-03-12T17-49-36/1-luts1/build-00000
# Command line: vivado -mode tcl -nojournal -notrace
# Log file: /import/home/tsung/CODE/sp7_cift-internal/temp/one-slicel-xc7s100fgga676-1-2021-03-12T17-49-36/1-luts1/build-00000/vivado.log
# Journal file: 
#-----------------------------------------------------------
lappend auto_path /import/home/tsung/CODE/sp7_cift-internal/code/main/ift/utils/PyVivado
#package require ::cift
#set_param messaging.disableStorage 1
cd /import/home/tsung/CODE/sp7_cift-internal/temp/RESULT_DIR/BUILD_TARG/build-00000
link_design -part xc7s100fgga676-1
set_property XPM_LIBRARIES XPM_MEMORY [current_project]
read_vhdl -library work /import/home/tsung/CODE/sp7_cift-internal/temp/RESULT_DIR/BUILD_TARG/build-00000/constants_pkg.vhd
read_vhdl -library work /import/home/tsung/CODE/sp7_cift-internal/temp/RESULT_DIR/BUILD_TARG/build-00000/gold.vhd
read_vhdl -library work /import/home/tsung/CODE/sp7_cift-internal/code/main/ift/builders/plbs/hdl/toggle_tpg.vhd
read_vhdl -library work /import/home/tsung/CODE/sp7_cift-internal/code/main/ift/builders/plbs/hdl/ora.vhd
read_vhdl -library work /import/home/tsung/CODE/sp7_cift-internal/temp/RESULT_DIR/BUILD_TARG/build-00000/test_gen.vhd
read_vhdl -library work /import/home/tsung/CODE/sp7_cift-internal/code/main/ift/builders/plbs/hdl/capture_small.vhd
read_vhdl -library work /import/home/tsung/CODE/sp7_cift-internal/code/main/ift/builders/plbs/hdl/harness.vhd
read_edif [glob /import/home/tsung/CODE/sp7_cift-internal/temp/RESULT_DIR/BUILD_TARG/build-00000/slice/*.edf]
read_vhdl -library work /import/home/tsung/CODE/sp7_cift-internal/interfaces/bscan_series7/io_wrapper_50MHz.vhd
set_property XPM_LIBRARIES {XPM_MEMORY XPM_FIFO XPM_CDC} [current_project]
synth_design -top top_level -part xc7s100fgga676-1
write_checkpoint -force /import/home/tsung/CODE/sp7_cift-internal/temp/RESULT_DIR/BUILD_TARG/build-00000/_SYNTHESIS.dcp
#
#set slice_insts [get_cells -hier -filter {ref_name==plb} *SLICE_X* ]
#foreach slice $slice_insts {
#    puts "current slice instance $slice"
#    set slice_name [ get_property NAME $slice ] 
#    set hier_names [ split $slice_name  "/" ]
#    set slice_name [ lindex $hier_names 2 ] 
#    puts "slice_name $slice_name"
#    current_instance $slice
#    set lut_insts [ get_cells -hier -filter {PRIMITIVE_GROUP==CARRY} ]
#    set_property LOC $slice_name $lut_insts
#    current_instance
#} 
#puts $insts
if {[catch {current_design} result]} {open_checkpoint /import/home/tsung/CODE/sp7_cift-internal/temp/RESULT_DIR/BUILD_TARG/build-00000/_SYNTHESIS.dcp}
place_design
write_checkpoint -force /import/home/tsung/CODE/sp7_cift-internal/temp/RESULT_DIR/BUILD_TARG/build-00000/_PLACED.dcp
if {[catch {current_design} result]} {open_checkpoint /import/home/tsung/CODE/sp7_cift-internal/temp/RESULT_DIR/BUILD_TARG/build-00000/_ROUTED.dcp}
route_design
write_checkpoint -force /import/home/tsung/CODE/sp7_cift-internal/temp/RESULT_DIR/BUILD_TARG/build-00000/_ROUTED.dcp
#
start_gui
#
#exit
