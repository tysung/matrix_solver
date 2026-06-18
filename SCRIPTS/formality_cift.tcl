#
#set_app_var synopsys_auto_setup true
#
set install {/nas/home/tsung/CODE/cift-internal/installation/full}
#set package ${install}/python/lib/python3.9/site-packages 
set repodir /nas/home/tsung/GG_BRAM/REPO_DIR
set workdir /nas/home/tsung/GG_BRAM/bram_test
#
# VIVADO sim setting
set vivado_unisim /export/tools/xilinx/Vivado/2018.3/data/vhdl/src/unisims
set vivado_simprim /export/tools/xilinx/Vivado/2018.3/data/verilog/src/xeclib
set vivado_unisim_vlg /export/tools/xilinx/Vivado/2018.3/data/verilog/src/unisims
set search_path "$vivado_simprim $vivado_unisim $vivado_unisim/primitive $vivado_unisim_vlg $workdir"
#
# ISE sim setting
#set ise_unisim /export/tools/xilinx/14.7/ISE_DS/ISE/vhdl/src/unisims
#set ise_simprim /export/tools/xilinx/14.7/ISE_DS/ISE/verilog/xeclib/simprims
#set ise_unisim /export/tools/xilinx/14.7/ISE_DS/ISE/verilog/xeclib/unisims
#set search_path "$ise_unisim $ise_unisim/primitive $ise_simprim $workdir"
#
#
set hdlin_error_on_mismatch_message false
set hdlin_interface_only "MMCME2_ADV" 
#set hdlin_interface_only "STARTUPE2 BSCANE2 MMCME2_ADV" 
#
#set_app_var hdlin_dwroot /export/tools/synopsys/J-2014.09-SP3
#set hdlin_library_directory  $ise_simprim
set hdlin_vhdl_mixed_language_instantiation true
#
#read_verilog -container r -libname WORK $workdir/glbl.v
#
#read_vhdl -container r -libname unisim {unisim_VCOMP.vhd unisim_VPKG.vhd}
#read_vhdl -container r -libname unisim { MMCME2_ADV.vhd BUFG.vhd LUT6_2.vhd }
#read_verilog -container r -tech -libname simprim { STARTUPE2.v BSCANE2.v FDCE.v }
#
read_vhdl -container r -libname WORK $workdir/bram_constants.vhd
read_vhdl -container r -libname WORK $repodir/shared_clock_tdp_ram-init.vhd
read_vhdl -container r -libname WORK $repodir/xilinx_tpg_constants_pkg.vhd
read_vhdl -container r -libname WORK $workdir/bram_facade.vhd
read_vhdl -container r -libname WORK $workdir/march_constants_pkg.vhd
read_vhdl -container r -libname WORK $repodir/march_generic_pkg.vhd
read_vhdl -container r -libname WORK $repodir/march_read_pkg.vhd
read_vhdl -container r -libname WORK $repodir/march_generic.vhd
read_vhdl -container r -libname WORK $workdir/generic_tpg_converter.vhd
read_vhdl -container r -libname WORK $workdir/sp2dp_converter.vhd
read_vhdl -container r -libname WORK $repodir/ora.vhd
read_vhdl -container r -libname WORK $repodir/capture.vhd
read_vhdl -container r -libname WORK $workdir/test_arch.vhd
read_vhdl -container r -libname WORK $workdir/harness.vhd
#
#read_db -container r { /nas/home/tsung/FORMALITY/tutorial/LIB/lsi_10k.db }
set_top r:/WORK/harness
#set_constant -type port r:/WORK/fifo/test_se 0
#
# 1. Formality parser didn't support simprims VHDL because VITAL is not supported.
# 2. From Xilinx's Netgen, create Verilog netlist and use verilog/xeclib/simprims
#
#read_verilog -container i -tech -libname simprim { sffsrce.v ffsrce.v sffsrce_prim.v } 
#
set prim_list "IBUF.v OBUF.v CARRY4.v BUFG.v SRL16E.v LUT6_2.v LUT6.v LUT5.v LUT4.v LUT3.v LUT2.v LUT1.v FDSE.v FDRE.v"
for {set j 0} {$j<[llength $prim_list]} {incr j} {
    set prim_file [lindex $prim_list $j]
    read_verilog -container i -libname WORK $prim_file
}
#read_verilog -container i -libname WORK $workdir/glbl.v
read_verilog -container i -libname WORK $workdir/post_layout.v 
#
set_top i:/WORK/harness
#set_constant -type port i:/WORK/top_level/clk 0
#set_constant -type port i:/WORK/fifo/jtag_tms 0
#set_constant -type port i:/WORK/fifo/test_se 0
#
#set_dont_verify {i:/WORK/top_level/N1_11.C5LUT/ADR0\*unread\*/IN}
#
match
report_unmatched_points
report_matched_points
report_hdlin_mismatches
#
#verify
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
# analyze_points {r:/WORK/fifo/push_logic/full_flag/q_out_reg[0]}
# remove_container r
# remove container i
# remove_library -all
 
