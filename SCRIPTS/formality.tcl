#
#set_app_var synopsys_auto_setup true
#
set_app_var hdlin_dwroot /export/tools/synopsys/J-2014.09-SP3
set search_path "./RTL ./GATE ./LIB"
read_verilog -r {fifo.v gray2bin.v gray_counter.v pop_ctrl.v push_ctrl.v rs_flop.v}
set_top fifo
#
#define_design_lib -r -path ./work work
#
read_db -i lsi_10k.db
#
read_verilog -i fifo.vg
set_top fifo
#
match
#
verify
#
analyze_points {r:/WORK/fifo/push_logic/full_flag/q_out_reg[0]}
#
start_gui
#
#exit
#
# extra command from tutorial GUI
# set_top r:/WORK/fifo
# set_top i:/WORK/fifo
# set_constant -type port i:/WORK/fifo/test_se 0
# remove_container r
# remove container i
# remove_library -all
 
