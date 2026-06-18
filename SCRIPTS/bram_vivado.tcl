#
#
set install {/nas/home/tsung/CODE/cift-internal/installation/full}
#set package ${install}/python/lib/python3.9/site-packages 
set repodir /nas/home/tsung/GG_BRAM/REPO_DIR
set workdir /nas/home/tsung/GG_BRAM/bram_test
#
cd $workdir 
#
create_project -force -part xc7k70tfbg676-2 dbg_prj  dbg_prj 
#
link_design -part xc7k70tfbg676-2 
#set prj_obj [get_projects dbg_prj]
set_property XPM_LIBRARIES XPM_MEMORY [current_project] 
#
read_vhdl -library work $workdir/bram_constants.vhd
read_vhdl -library work $repodir/shared_clock_tdp_ram-init.vhd
#read_vhdl -library work $package/cift_xilinx/common/bram/hdl/shared_clock_tdp_ram-init.vhd
read_vhdl -library work $repodir/xilinx_tpg_constants_pkg.vhd
#read_vhdl -library work $package/cift_xilinx/common/bram/hdl/xilinx_tpg_constants_pkg.vhd
read_vhdl -library work $workdir/bram_facade.vhd
read_vhdl -library work $workdir/march_constants_pkg.vhd
read_vhdl -library work $repodir/march_generic_pkg.vhd
#read_vhdl -library work $package/cift_builders/bram/single_port/hdl/march_generic_pkg.vhd
read_vhdl -library work $repodir/march_read_pkg.vhd
#read_vhdl -library work $package/cift_builders/bram/single_port/hdl/march_read_pkg.vhd
read_vhdl -library work $repodir/march_generic.vhd
#read_vhdl -library work $package/cift_builders/bram/single_port/hdl/march_generic.vhd
read_vhdl -library work $workdir/generic_tpg_converter.vhd
read_vhdl -library work $workdir/sp2dp_converter.vhd
read_vhdl -library work $repodir/ora.vhd
#read_vhdl -library work $package/cift_builders/bram/hdl/ora.vhd
read_vhdl -library work $repodir/capture.vhd
#read_vhdl -library work $package/cift_builders/bram/hdl/capture.vhd
read_vhdl -library work $workdir/test_arch.vhd
read_vhdl -library work $repodir/harness.vhd
#
add_file $repodir/io_wrapper.xdc
#
read_vhdl -library work $repodir/io_wrapper_50MHz.vhd
#
#set_property XPM_LIBRARIES {XPM_MEMORY XPM_FIFO XPM_CDC} [current_project] 
#
#set_property STEPS.SYNTH_DESIGN.ARGS.FLATTEN_HIERARCHY full [get_runs synth_1]
synth_design -top top_level -flatten_hierarchy full -debug_log -verbose 
#synth_design -top top_level
#
write_verilog post_layout.v -write_all_overrides -mode funcsim -force
#
place_design
route_design
write_checkpoint -force $workdir/_ROUTED.dcp
#
#write_bitstream vivado_bram.bit -mask_file -force
#
save_project_as -force dbg_prj
#
#start_gui 
#
