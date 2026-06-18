#
#
set workdir /nas/home/tsung/JTAG_BSCANE2_TEST
#
cd $workdir 
#
# Artix-7 board
create_project  prj_bscan_test $workdir/prj_bscan_test -part xc7a200tfbg676-2 
#
set_property board_part xilinx.com:ac701:part0:1.4 [current_project]
#
#link_design -part xc7a200tfbg676-2 
#set prj_obj [get_projects dbg_prj]
#set_property XPM_LIBRARIES XPM_MEMORY [current_project] 
#
set_property target_language Verilog [current_project]
add_files -fileset sim_1 -norecurse -scan_for_includes $workdir/bscane2.v
#
#read_verilog -library xil_defaultlib $workdir/bscane2.v
#set_property XPM_LIBRARIES {XPM_MEMORY XPM_FIFO XPM_CDC} [current_project] 
#
add_files -norecurse -scan_for_includes $workdir/bscane2.v
update_compile_order -fileset sources_1
set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse -scan_for_includes $workdir/tb_jtag_sime2.v
#
set_property TARGET_SIMULATOR XSim [current_project]
set_property top tb_top [get_filesets sim_1]
launch_simulation -mode behavioral 
#
#
save_project_as -force prj_bscan_test
#
start_gui 

