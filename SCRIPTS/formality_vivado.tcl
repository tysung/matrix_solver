#
#set_app_var synopsys_auto_setup true
#
set workdir /nas/home/tsung/FORMALITY/VIVADO_TEST 
set repo_dir $workdir/../REPO_DIR 
#set workdir $repo_dir/temp/all-slices-xc7k70tfbg484-3-2021-09-10T18-38-14/1-luts1/build-00000
# VIVADO sim setting
set vivado_unisim /export/tools/xilinx/Vivado/2018.3/data/vhdl/src/unisims
set vivado_simprim /export/tools/xilinx/Vivado/2018.3/data/verilog/src/xeclib

set vivado_unisim_vlg /export/tools/xilinx/Vivado/2018.3/data/verilog/src/unisims
set search_path "$vivado_simprim $vivado_unisim $vivado_unisim/primitive $vivado_unisim_vlg $workdir"
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
#set search_path "$ise_unisim $ise_unisim/primitive $ise_simprim $workdir"
#set search_path "./RTL ./GATE ./LIB"
#
#read_verilog -container r -libname WORK $workdir/glbl.v
read_vhdl -container r -libname unisim {unisim_VCOMP.vhd unisim_VPKG.vhd}
read_vhdl -container r -libname unisim { MMCME2_ADV.vhd BUFG.vhd LUT6_2.vhd }
read_verilog -container r -tech -libname simprim { STARTUPE2.v BSCANE2.v FDCE.v }
#
read_vhdl -container r -libname WORK $workdir/constants_pkg.vhd 
read_vhdl -container r -libname WORK $repo_dir/series7_slicel.vhd
read_vhdl -container r -libname WORK $workdir/plb.vhd
read_vhdl -container r -libname WORK $workdir/gold.vhd 
read_vhdl -container r -libname WORK $repo_dir/lut_test_tpg_8_3-1.vhd 
read_vhdl -container r -libname WORK $repo_dir/ora.vhd 
read_vhdl -container r -libname WORK $workdir/test_gen.vhd 
read_vhdl -container r -libname WORK $repo_dir/capture_small.vhd 
read_vhdl -container r -libname WORK $repo_dir/harness.vhd
read_vhdl -container r -libname WORK $repo_dir/io_wrapper_50MHz.vhd
#
#read_db -container r { /nas/home/tsung/FORMALITY/tutorial/LIB/lsi_10k.db }
set_top r:/WORK/top_level
#set_constant -type port r:/WORK/fifo/test_se 0
#
# 1. Formality parser didn't support simprims VHDL because VITAL is not supported.
# 2. From Xilinx's Netgen, create Verilog netlist and use verilog/xeclib/simprims
#
#read_verilog -container i -tech -libname simprim { sffsrce.v ffsrce.v sffsrce_prim.v } 
#
set prim_list "STARTUPE2.v MMCME2_ADV.v BSCANE2.v BUFG.v SRL16E.v LUT6_2.v LUT6.v LUT5.v LUT4.v LUT3.v LUT2.v LUT1.v FDSE.v FDRE.v"
for {set j 0} {$j<[llength $prim_list]} {incr j} {
    set prim_file [lindex $prim_list $j]
    read_verilog -container i -libname WORK $prim_file
}
#read_verilog -container i -libname WORK $workdir/glbl.v
read_verilog -container i -libname WORK $workdir/post_layout.v 
#
set_top i:/WORK/top_level
#set_constant -type port i:/WORK/top_level/clk 0
#set_constant -type port i:/WORK/fifo/jtag_tms 0
#set_constant -type port i:/WORK/fifo/test_se 0
#
#set_dont_verify {i:/WORK/top_level/N1_11.C5LUT/ADR0\*unread\*/IN}
#
match
report_hdlin_mismatches
#
verify
#
start_gui
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
 
