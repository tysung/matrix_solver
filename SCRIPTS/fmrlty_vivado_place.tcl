#
set workdir /nas/home/tsung/DESIGN_COMPILER/optimizations/bram
#
set vivado_simprim /export/tools/xilinx/Vivado/2020.2/data/verilog/src/xeclib
set vivado_unisim_vlg /export/tools/xilinx/Vivado/2020.2/data/verilog/src/unisims
set search_path "$vivado_simprim $vivado_unisim_vlg $workdir"
#
set svf_ignore_unqualified_fsm_information false
# Set the guide file if one is provided.
guide
#set_svf /home/tsung/CODE/GG_08_04/RESULT/BRAM/synth/gopher_prj.runs/synth_1/gopher/synth_guide.svf
setup
# Read tech library verilog files if provided.
#
set_mismatch_message_filter -warn
#
# Setup for the reference (gold) design.
#
# read_verilog -container r -libname WORK $workdir/sram.v
#
read_verilog -container r -libname WORK $workdir/bram_synth_gate.v
#
set prim_list "IBUF.v BUF.v GND.v VCC.v OBUF.v BUFG.v RAMB36E1.v"
for {set j 0} {$j<[llength $prim_list]} {incr j} {
    set prim_file [lindex $prim_list $j]
    read_verilog -container r -libname WORK $prim_file
}
#
set_top r:/WORK/top 
#
# Setup for the implementation (gate) design
#
read_verilog -container i -libname WORK $workdir/bram_place_gate.v
#
set prim_list "IBUF.v BUF.v GND.v VCC.v OBUF.v BUFG.v RAMB36E1.v"
for {set j 0} {$j<[llength $prim_list]} {incr j} {
    set prim_file [lindex $prim_list $j]
    read_verilog -container i -libname WORK $prim_file
}
#
set_top i:/WORK/top 
#
match
report_unmatched_points
report_matched_points
#
set verify_result [verify]
if { $verify_result == 0 } { analyze_points -all }
#
save_session -replace session_vivado_place
#
start_gui
#
#exit
quit
