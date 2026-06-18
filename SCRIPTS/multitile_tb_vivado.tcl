#
set workdir ~/Trebuchet/trebuchet-ip/Vivado_Test/vivado 
set repo_dir $workdir/../REPO_DIR 
#set rtl_dir ~/Trebuchet/trebuchet-ip/Vivado_Test/rtl
set rtl_dir ~/Trebuchet/trebuchet-ip/cores/multitile/palladium/duality_trebuchet_multitile/rtl
#set sim_dir ~/Trebuchet/trebuchet-ip/Vivado_Test/sim
set sim_dir ~/Trebuchet/trebuchet-ip/cores/multitile/palladium/duality_trebuchet_multitile/sim
#
cd $workdir 
#
create_project -force -part xc7k480tffv1156-1 prj_sim  prj_sim 
set_property default_lib work [current_project]
#
#link_design -part xc7k70tfbg676-2 
#set prj_obj [get_projects dbg_prj]
#set_property XPM_LIBRARIES XPM_MEMORY [current_project] 
#
#
# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}
# "[file normalize "$origin_dir/project_3/import_xst_summary.txt"]"\
# Set 'sources_1' fileset object
set src1_obj [get_filesets sources_1]
#
#
#set file1 "$rtl_dir/parameters.svh"
#set file11 [file normalize $file1]
#add_files -norecurse -fileset $src1_obj $file11
#set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file11"]]
#set_property -name "file_type" -value "VHDL" -objects $file_obj

set files [list \
 [file normalize "$rtl_dir/parameters.svh"] \
 [file normalize "$rtl_dir/validready_buffers.svh"] \
 [file normalize "$rtl_dir/alu.sv"] \
 [file normalize "$rtl_dir/arbiter.v"] \
 [file normalize "$rtl_dir/automorphism_control.sv"] \
 [file normalize "$rtl_dir/axil_crossbar_addr.v"] \
 [file normalize "$rtl_dir/axil_crossbar_rd.v"] \
 [file normalize "$rtl_dir/axil_crossbar.v"] \
 [file normalize "$rtl_dir/axil_crossbar_wrap_3.v"] \
 [file normalize "$rtl_dir/axil_crossbar_wrap_4.v"] \
 [file normalize "$rtl_dir/axil_crossbar_wrap_8.v"] \
 [file normalize "$rtl_dir/axil_crossbar_wr.v"] \
 [file normalize "$rtl_dir/axil_register_rd.v"] \
 [file normalize "$rtl_dir/axil_register_wr.v"] \
 [file normalize "$rtl_dir/axi_to_data_memory.sv"] \
 [file normalize "$rtl_dir/axi_to_procwrite.sv"] \
 [file normalize "$rtl_dir/axi_to_simple.sv"] \
 [file normalize "$rtl_dir/blake0.sv"] \
 [file normalize "$rtl_dir/blake10.sv"] \
 [file normalize "$rtl_dir/blake11.sv"] \
 [file normalize "$rtl_dir/blake1.sv"] \
 [file normalize "$rtl_dir/blake2.sv"] \
 [file normalize "$rtl_dir/blake2xb_dummy.sv"] \
 [file normalize "$rtl_dir/blake2xb_either.sv"] \
 [file normalize "$rtl_dir/blake2xb.sv"] \
 [file normalize "$rtl_dir/blake2xb_wrapper.sv"] \
 [file normalize "$rtl_dir/blake3.sv"] \
 [file normalize "$rtl_dir/blake4.sv"] \
 [file normalize "$rtl_dir/blake5.sv"] \
 [file normalize "$rtl_dir/blake6.sv"] \
 [file normalize "$rtl_dir/blake7.sv"] \
 [file normalize "$rtl_dir/blake8.sv"] \
 [file normalize "$rtl_dir/blake9.sv"] \
 [file normalize "$rtl_dir/blocker.sv"] \
 [file normalize "$rtl_dir/BMM_MSBx_FW128.v"] \
 [file normalize "$rtl_dir/Brent_Kung_Adder_128_Lower_part.v"] \
 [file normalize "$rtl_dir/Brent_Kung_Adder_128_Upper_part.v"] \
 [file normalize "$rtl_dir/Cells.v"] \
 [file normalize "$rtl_dir/compare_gt_lt.sv"] \
 [file normalize "$rtl_dir/contract.sv"] \
 [file normalize "$rtl_dir/control_alu.sv"] \
 [file normalize "$rtl_dir/control_registers.sv"] \
 [file normalize "$rtl_dir/control.sv"] \
 [file normalize "$rtl_dir/crossbar_data.sv"] \
 [file normalize "$rtl_dir/CSA.v"] \
 [file normalize "$rtl_dir/data_memory.sv"] \
 [file normalize "$rtl_dir/double_frontend.sv"] \
 [file normalize "$rtl_dir/DW01_add.v"] \
 [file normalize "$rtl_dir/DW01_csa.v"] \
 [file normalize "$rtl_dir/DW02_mult.v"] \
 [file normalize "$rtl_dir/DW03_pipe_reg.v"] \
 [file normalize "$rtl_dir/DW_fifoctl_s1_df.v"] \
 [file normalize "$rtl_dir/DW_fifo_s1_df.v"] \
 [file normalize "$rtl_dir/DW_ram_r_w_s_dff.v"] \
 [file normalize "$rtl_dir/errors_mmi.sv"] \
 [file normalize "$rtl_dir/expand.sv"] \
 [file normalize "$rtl_dir/fifo.sv"] \
 [file normalize "$rtl_dir/IN12LP_R1DB_W00008B128M02S1_H.sv"] \
 [file normalize "$rtl_dir/IN12LP_R1DB_W00032B128M02S1_H.sv"] \
 [file normalize "$rtl_dir/IN12LP_R1DB_W00064B128M02S1_H.sv"] \
 [file normalize "$rtl_dir/IN12LP_R1DB_W00128B128M02S1_H.sv"] \
 [file normalize "$rtl_dir/IN12LP_S1DB_W00512B128M04S2_H.sv"] \
 [file normalize "$rtl_dir/IN12LP_S1DB_W01024B032M04S2_H.sv"] \
 [file normalize "$rtl_dir/IN12LP_S1DB_W04096B128M04S4_H.sv"] \
 [file normalize "$rtl_dir/IN12LP_S1DB_W08192B032M04S8_H.sv"] \
 [file normalize "$rtl_dir/IN12LP_S1DB_W08192B128M04S8_H.sv"] \
 [file normalize "$rtl_dir/IN12LP_S1DB_W32768B032M16S8_H.sv"] \
 [file normalize "$rtl_dir/input_queue_wrapper.sv"] \
 [file normalize "$rtl_dir/instruction_memory.sv"] \
 [file normalize "$rtl_dir/lane_chunk.sv"] \
 [file normalize "$rtl_dir/lane.sv"] \
 [file normalize "$rtl_dir/Modular_Addition_Substraction_pipeline_top.v"] \
 [file normalize "$rtl_dir/Modular_Addition_Substraction_pipeline.v"] \
 [file normalize "$rtl_dir/multitile.sv"] \
 [file normalize "$rtl_dir/new_frontend.sv"] \
 [file normalize "$rtl_dir/output_queue_wrapper.sv"] \
 [file normalize "$rtl_dir/pipeline.sv"] \
 [file normalize "$rtl_dir/priority_encoder.v"] \
 [file normalize "$rtl_dir/queue_count_update.sv"] \
 [file normalize "$rtl_dir/queue_get_canconsume.sv"] \
 [file normalize "$rtl_dir/queues_required.sv"] \
 [file normalize "$rtl_dir/register_file.sv"] \
 [file normalize "$rtl_dir/register.sv"] \
 [file normalize "$rtl_dir/register_with_valid.sv"] \
 [file normalize "$rtl_dir/scalar_memory.sv"] \
 [file normalize "$rtl_dir/shift_register.sv"] \
 [file normalize "$rtl_dir/shuffle_control.sv"] \
 [file normalize "$rtl_dir/sram_one_port_instruction_memory1.sv"] \
 [file normalize "$rtl_dir/sram_one_port_instruction_memory2.sv"] \
 [file normalize "$rtl_dir/sram_one_port_mrf.sv"] \
 [file normalize "$rtl_dir/sram_one_port_sdm.sv"] \
 [file normalize "$rtl_dir/sram_one_port_srf.sv"] \
 [file normalize "$rtl_dir/sram_one_port_vdm.sv"] \
 [file normalize "$rtl_dir/sram_one_port_vrf_memory128x32.sv"] \
 [file normalize "$rtl_dir/sram_one_port_vrf_memory128x8.sv"] \
 [file normalize "$rtl_dir/syncer.sv"] \
 [file normalize "$rtl_dir/tile_body.sv"] \
 [file normalize "$rtl_dir/tile.sv"] \
 [file normalize "$rtl_dir/trigger_connection.sv"] \
 [file normalize "$rtl_dir/trigger_control.sv"] \
 [file normalize "$sim_dir/multitile_tb.sv"]
]
#
add_files -norecurse -fileset $src1_obj $files
#
# set the proper compilation order
#
#for {set i 0} {$i < [llength $files]} {incr i} {
#	set file_obj [lindex $files $i]
#	set_property file2.v [get_files file2.v] -index $i	
#}
# update_compile_order
set_property IS_GLOBAL_INCLUDE 1 [get_files $rtl_dir/parameters.svh]
set_property IS_GLOBAL_INCLUDE 1 [get_files $rtl_dir/validready_buffers.svh]
update_compile_order -fileset sources_1
#
foreach rtl_file $files {
	set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$rtl_file"]]
	#set_property -name "file_type" -value "VHDL" -objects $file_obj
	set_property -name "file_type" -value "SystemVerilog" -objects $file_obj
	set_property -name "library" -value "work" -objects $file_obj
}

#
#set_property top multitile_tb [current_project]
#set_property -name "top" -value "multitile" -objects $src1_obj
#set_property -name "top" -value "multitile_tb" -objects $src1_obj
#
#
#set_property XPM_LIBRARIES {XPM_MEMORY XPM_FIFO XPM_CDC} [current_project] 
#
# [file normalize "$sim_dir/multitile_tb.sv"]
set_property SOURCE_SET sources_1 [get_filesets sim_1]
#add_files -fileset sim_1 -norecurse -scan_for_includes $sim_dir/multitile_tb.sv 
#set_property library work [get_files  $sim_dir/multitile_tb.sv]
update_compile_order -fileset sim_1
set_property TARGET_SIMULATOR XSim [current_project]
set_property top multitile_tb [get_filesets sim_1]
set_property -name {xsim.simulate.runtime} -value {10us} -objects [get_filesets sim_1]
launch_simulation -mode behavioral 
#xsim --gui
#
#set_property -name "top" -value "multitile" -objects $src1_obj
#synth_design -top multitile 
#synth_design -top multitile -rtl -rtl_skip_mlo -name rtl_1
#
#write_vhdl post_layout.vhd -write_all_overrides -mode funcsim -include_xilinx_libs -force
#write_verilog post_layout.v -write_all_overrides -mode funcsim -include_xilinx_libs -force
#
#place_design
#route_design
#write_checkpoint -force $workdir/_ROUTED.dcp
#
#write_bitstream vivado_luts1.bit -mask_file -force
#

close_project
#save_project_as -force prj_sim
#
#start_gui 

