#-----------------------------------------------------------
# Vivado v2018.3 (64-bit)
# SW Build 2405991 on Thu Dec  6 23:36:41 MST 2018
# IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
# Start of session at: Thu Apr  8 14:29:41 2021
# Process ID: 31760
# Current directory: /import/home/tsung/CODE/sp7_cift-internal
# Command line: vivado -mode tcl -nojournal -notrace
# Log file: /import/home/tsung/CODE/sp7_cift-internal/vivado.log
# Journal file: 
#-----------------------------------------------------------
#lappend auto_path /import/home/tsung/CODE/sp7_cift-internal/code/main/ift/utils/PyVivado
#package require ::cift
#set_param messaging.disableStorage 1
open_hw
connect_hw_server
open_hw_target [get_hw_targets localhost:3121/xilinx_tcf/Digilent/210352A89637A]
#open_hw_target [lindex [get_hw_targets */xilinx_tcf/Digilent/210352A89637A] 0]
#open_hw_target
close_hw_target
disconnect_hw_server
close_hw
#
#set_param xicom.use_bitstream_version_check false
#set_property PROGRAM.FILE {/import/home/tsung/CODE/sp7_cift-internal/tests/ff5-b53b966d98de/ff5-0.bit} [get_hw_devices xc7s25_0]
#set_property PROGRAM.FILE {/import/home/tsung/CODE/sp7_cift-internal/tests/regtest1-8817d7068467/regtest1-0.bit} [get_hw_devices xc7s25_0]
#set_property PROGRAM.FILE {/import/home/tsung/CODE/sp7_cift-internal/tests/regtest2-97035dfb985f/regtest2-0.bit} [get_hw_devices xc7s25_0]
#program_hw_devices [get_hw_devices xc7s25_0]
#open_hw_target -jtag_mode on localhost:3121/xilinx_tcf/Digitlent/210352A89637A
#run_state_hw_jtag reset
#run_state_hw_jtag idle
#scan_ir_hw_jtag 6 -tdi 0x2
#scan_dr_hw_jtag 16 -tdi 0
#close_hw_target

