#
set repo_dir {/import/home/tsung/CODE/sp7_cift-internal}
set workdir $repo_dir/temp/all-slices-xc7k70tfbg484-3-2021-05-06T17-14-55/1-vcarry/build-00000
cd $workdir 
#
set_param messaging.disableStorage 1
cd $workdir
link_design -part xc7k70tfbg484-3 
set_property XPM_LIBRARIES XPM_MEMORY [current_project]
read_vhdl -library work $workdir/constants_pkg.vhd
read_vhdl -library work $workdir/gold.vhd
read_vhdl -library work $workdir/plb.vhd
#read_vhdl -library work $repo_dir/builders_repo/architectures/xilinx/spartan7/hdl/slice_vcarry.vhd
#read_vhdl -library work $repo_dir/builders_repo/architectures/xilinx/spartan7/hdl/vcarry.vhd
read_vhdl -library work $repo_dir/builders_repo/architectures/xilinx/series7/hdl/series7_carry.vhd
read_vhdl -library work $repo_dir/code/main/ift/builders/plbs/hdl/toggle_tpg.vhd
read_vhdl -library work $repo_dir/code/main/ift/builders/plbs/hdl/ora.vhd
read_vhdl -library work $workdir/test_gen.vhd
read_vhdl -library work $repo_dir/code/main/ift/builders/plbs/hdl/capture_small.vhd
read_vhdl -library work $repo_dir/code/main/ift/builders/plbs/hdl/harness.vhd
#read_edif [glob $workdir/slice/*.edf]
read_vhdl -library work $repo_dir/interfaces/bscan_series7/io_wrapper_50MHz.vhd
set_property XPM_LIBRARIES {XPM_MEMORY XPM_FIFO XPM_CDC} [current_project]
synth_design -top top_level -part xc7k70tfbg484-3 
#
write_checkpoint -force $workdir/_SYNTH.dcp
#
get_cells -hier test_i
#set_property RLOC_ORIGIN "X1Y0" [get_cells harness/test_region_i/SLICE_X1Y0]
set dict_plb {}
#set site_list [ list {SLICE_X1Y0} {SLICE_X1Y2} {SLICE_X1Y4} ]
set site_list "SLICE_X1Y0 SLICE_X1Y2 SLICE_X1Y4"
for {set j 0} {$j<[llength $site_list]} {incr j} {
    set site_name [lindex $site_list $j]
    #puts $site_name
    set plb_cell [get_cells harness/test_region_i/$site_name]
    #puts $plb_cell
    set cell_site [get_sites $site_name]
    #puts $cell_site
    dict lappend dict_plb [get_tiles -of $cell_site] $plb_cell
    #puts $dict_plb
}
puts $dict_plb
foreach pbk_tile [dict keys $dict_plb] {
    set pbk_cells [dict get $dict_plb $pbk_tile]    
    create_pblock pbk_$pbk_tile
    resize_pblock [get_pblocks pbk_$pbk_tile] -add [get_sites -of $pbk_tile]
    add_cells_to_pblock [get_pblocks pbk_$pbk_tile] $pbk_cells
}
#
write_checkpoint -force $workdir/_LOC_CONSTR.dcp
#
place_design
write_checkpoint -force $workdir/_PLACE.dcp
route_design
write_checkpoint -force $workdir/_ROUTED_START.dcp
#
save_project_as project_1 $workdir/project_1 -force
##
start_gui
#
