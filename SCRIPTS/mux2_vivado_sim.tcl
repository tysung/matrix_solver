#
#
set workdir /nas/home/tsung/CODE/cift-internal_052026/ise_workspace/work/2026-05-08T17-37-29-c824a844/mux2_simulation 
set plb_dir $workdir/slice/files/work
set test_dir $workdir/files/work
#
cd $workdir 
#
create_project -force -part xc7k70tfbg676-2 dbg_prj  dbg_prj 
#
set_property target_language VHDL [current_project]
#
#create_fileset -srcset source_1
#
add_files -fileset sources_1 -norecurse -scan_for_includes $plb_dir/constants_pkg.vhd
add_files -fileset sources_1 -norecurse -scan_for_includes $plb_dir/slice_mux2.vhd
add_files -fileset sources_1 -norecurse -scan_for_includes $plb_dir/plb.vhd
#
add_files -fileset sources_1 -norecurse -scan_for_includes $test_dir/gold.vhd
add_files -fileset sources_1 -norecurse -scan_for_includes $test_dir/toggle_tpg.vhd
add_files -fileset sources_1 -norecurse -scan_for_includes $test_dir/ora.vhd
add_files -fileset sources_1 -norecurse -scan_for_includes $test_dir/test_gen.vhd
add_files -fileset sources_1 -norecurse -scan_for_includes $test_dir/capture_small.vhd
add_files -fileset sources_1 -norecurse -scan_for_includes $test_dir/harness.vhd
#
update_compile_order -fileset sources_1
#set_property SOURCE_SET sim_1 [get_filesets source_1]
add_files -fileset sim_1 -norecurse -scan_for_includes $workdir/testbench.vhd
#
set_property TARGET_SIMULATOR XSim [current_project]
set_property top testbench [get_filesets sim_1]
launch_simulation -mode behavioral 
#
close_project
#save_project_as -force dbg_prj
#
#start_gui 

