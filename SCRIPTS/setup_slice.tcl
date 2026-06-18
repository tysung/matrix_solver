project_new slice -overwrite
# Assign family, device, and top-level file
set_global_assignment -name FAMILY "Stratix 10"  
#set_global_assignment -name DEVICE "1SG10MHN3F74E2LG_U1" 
set_global_assignment -name TOP_LEVEL_ENTITY top_level 
#
set repo_dir {/nas/home/tsung/CODE/stratix_cift-internal}
set workdir $repo_dir/work/2022-04-08T15-41-26/1-slice-luts1/build-00000
set cift_plugins $repo_dir/installations/cift/python/lib/python3.9/site-packages

set_global_assignment -name VHDL_FILE $workdir/constants_pkg.vhd
set_global_assignment -name VHDL_FILE $cift_plugins/cift_intel/stratix10/hdl/lab_luts1.vhd
set_global_assignment -name VHDL_FILE $workdir/plb.vhd
set_global_assignment -name VHDL_FILE $workdir/gold.vhd
set_global_assignment -name VHDL_FILE $cift_plugins/cift_builders/plb/hdl/results_lookup_tpg.vhd
set_global_assignment -name VHDL_FILE $cift_plugins/cift_builders/plb/hdl/ora.vhd
set_global_assignment -name VHDL_FILE $workdir/test_gen.vhd
set_global_assignment -name VHDL_FILE $cift_plugins/cift_builders/plb/hdl/capture_small.vhd
set_global_assignment -name VHDL_FILE $cift_plugins/cift_builders/plb/hdl/harness.vhd
set_global_assignment -name VHDL_FILE $repo_dir/installations/cift/interfaces/vjtag_stratix10/io_wrapper.vhd
#
#set_location_assignment LABCELL_X334_Y120_N9 -to LUT_F1 
#set_location_assignment LABCELL_X334_Y120_N6 -to LUT_F0 
#set_location_assignment FF_X334_Y120_N11 -to FF_1 
#set_location_assignment FF_X334_Y120_N8 -to FF_0 
#
#set_location_assignment MLABCELL_X329_Y120_N9 -to LUT_F1 
#set_location_assignment MLABCELL_X329_Y120_N6 -to LUT_F0 
#set_location_assignment FF_X329_Y120_N11 -to FF_1 
#set_location_assignment FF_X329_Y120_N8 -to FF_0 
#
# Assign pins
#set_location_assignment -to clk Pin_28
#set_location_assignment -to clkx2 Pin_29
#
#set_instance_assignment -name PARTITION_COLOUR 4281925624 -to true_dpram_sclk -entity true_dpram_sclk
#set_instance_assignment -name PLACE_REGION "X328 Y109 X328 Y109" -to ram_rtl_0|auto_generated|altera_syncram_impl1
#set_instance_assignment -name RESERVE_PLACE_REGION OFF -to ram_rtl_0|auto_generated|altera_syncram_impl1
#set_instance_assignment -name CORE_ONLY_PLACE_REGION ON -to ram_rtl_0|auto_generated|altera_syncram_impl1
#set_instance_assignment -name REGION_NAME altera_syncram_impl1 -to ram_rtl_0|auto_generated|altera_syncram_impl1
#set_global_assignment -name EDA_DESIGN_ENTRY_SYNTHESIS_TOOL "Synplify Pro"
#set_global_assignment -name EDA_LMF_FILE synplcty.lmf -section_id eda_design_synthesis
#set_global_assignment -name EDA_INPUT_DATA_FORMAT VQM -section_id eda_design_synthesis
#set_global_assignment -name EDA_SIMULATION_TOOL MODELSIM 
#set_global_assignment -name EDA_TIME_SCALE "1 ps" -section_id eda_simulation
#set_global_assignment -name EDA_OUTPUT_DATA_FORMAT "VHDL" -section_id eda_simulation
#set_global_assignment -name FLOW_ENABLE_EDA_NETLIST_WRITER ON
#
project_close

