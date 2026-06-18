#
set workdir /home/tsung/CODE/galactic-gopher/test_designs/optimizations/register_merging
#
set_app_var synopsys_auto_setup true
#
set vivado_simprim /projects/tools/xilinx/Vivado/2021.2/data/verilog/src/xeclib
set vivado_unisim_vlg /projects/tools/xilinx/Vivado/2021.2/data/verilog/src/unisims
set search_path "$vivado_simprim $vivado_unisim_vlg $workdir"
#
# Load Guidance file
#
set_svf test.svf
#
read_verilog -container r -libname WORK $workdir/inferred.v 
set_top r:/WORK/top
#
#
read_verilog -container i -libname WORK $workdir/post_synth.v
#
set prim_list "BUFG.v IBUF.v OBUF.v LUT2.v LUT1.v FDRE.v"
for {set j 0} {$j<[llength $prim_list]} {incr j} {
    set prim_file [lindex $prim_list $j]
    read_verilog -container i -libname WORK $prim_file
}
# 
set_top i:WORK/top 
#
match
report_unmatched_points
report_matched_points
#
verify
#
#analyze_points {i:/WORK/fifo/push_logic/push_counter/bin_count_reg[0]}
#analyze_points {r:/WORK/fifo/push_logic/full_flag/q_out_reg[0]}
#
save_session -replace session_top
#
#start_gui
#
exit
#
# extra command from tutorial GUI
# set_top r:/WORK/fifo
# set_top i:/WORK/fifo
# set_constant -type port i:/WORK/fifo/test_se 0
# remove_container r
# remove container i
# remove_library -all
 
