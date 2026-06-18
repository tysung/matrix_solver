#
set repo_dir {/nas/home/tsung/CODE/sp6_cift-internal}
set workdir $repo_dir/work/2021-08-23T21-13-35/1-xc6slx45csg484-3-slice-luts4-region_area/build-00000
set cift_xilinx $repo_dir/installations/full/python/lib/python3.9/site-packages/cift_xilinx 
set cift_builders $repo_dir/installations/full/python/lib/python3.9/site-packages/cift_builders
#
cd $workdir 
#
create_project -force -part xc6slx45csg484-3 dbg_prj  dbg_prj 
#
read_vhdl -library work $workdir/constants_pkg.vhd
read_vhdl -library work $cift_xilinx/spartan6/hdl/slice2.vhd
read_vhdl -library work $cift_xilinx/spartan6/hdl/luts4_tpg_6_4.vhd
read_vhdl -library work $workdir/plb.vhd
read_vhdl -library work $workdir/gold.vhd
read_vhdl -library work $workdir/test_gen.vhd
read_vhdl -library work $cift_builders/plb/hdl/capture_small.vhd
read_vhdl -library work $cift_builders/plb/hdl/ora.vhd
read_vhdl -library work $cift_builders/plb/hdl/harness.vhd
add_file $repo_dir/interfaces/bscan_spartan6/io_wrapper.ucf 
read_vhdl -library work $repo_dir/interfaces/bscan_spartan6/io_wrapper_50MHz.vhd
#
launch_runs synth_1 -jobs 4
wait_on_run synth_1
#
launch_runs impl_1 -to_step bitgen -jobs 20
#
wait_on_run impl_1
#
# save_project_as -force dbg_prj
#
start_gui 
#
