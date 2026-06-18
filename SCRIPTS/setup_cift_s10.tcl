project_new work_dual_port_ram -overwrite
#
set_global_assignment -name TOP_LEVEL_ENTITY top_level
set_global_assignment -name ORIGINAL_QUARTUS_VERSION 21.4.0
set_global_assignment -name PROJECT_CREATION_TIME_DATE "16:31:51  MAY 08, 2022"
set_global_assignment -name LAST_QUARTUS_VERSION "21.4.0 Pro Edition"
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
set_global_assignment -name MAX_CORE_JUNCTION_TEMP 100
set_global_assignment -name DEVICE 1SG280LU2F50E2LG
set_global_assignment -name FAMILY "Stratix 10"
#
#set_global_assignment -name IP_FILE dual_port_ram.ip -library work
#
set_global_assignment -name VERILOG_FILE /nas/home/tsung/ALTERA_STRATIX/dual_port_ram/ram_2port_2021/synth/dual_port_ram_ram_2port_2021_fdsi24q.v -library ram_2port_2021
#
set_global_assignment -name VHDL_FILE /nas/home/tsung/ALTERA_STRATIX/TPG_BRAM/dual_port_ram_intel.vhd -library work
set_global_assignment -name VHDL_FILE /nas/home/tsung/ALTERA_STRATIX/TPG_BRAM/dual_port_ram.vhd -library work
#set_global_assignment -name VHDL_FILE /nas/home/tsung/ALTERA_STRATIX/dual_port_ram/synth/dual_port_ram.vhd -library work
#
set_global_assignment -name VHDL_FILE /nas/home/tsung/ALTERA_STRATIX/TPG_BRAM/bram_constants.vhd -library work
#set_global_assignment -name VHDL_FILE "/nas/home/tsung/CODE/stratix_cift-internal/installations/cift/python/lib/python3.9/site-packages/cift_builders/bram/single_port/hdl/march_lr.vhd" -library work
set_global_assignment -name VHDL_FILE "/nas/home/tsung/CODE/stratix_cift-internal/installations/cift/python/lib/python3.9/site-packages/cift_builders/bram/single_port/hdl/march_x.vhd" -library work
set_global_assignment -name VHDL_FILE /nas/home/tsung/ALTERA_STRATIX/TPG_BRAM/sp2dp_converter.vhd -library work
set_global_assignment -name VHDL_FILE /nas/home/tsung/ALTERA_STRATIX/TPG_BRAM/test_arch.vhd -library work
set_global_assignment -name VHDL_FILE "/nas/home/tsung/CODE/stratix_cift-internal/installations/cift/python/lib/python3.9/site-packages/cift_builders/bram/hdl/ora.vhd" -library work
set_global_assignment -name VHDL_FILE "/nas/home/tsung/CODE/stratix_cift-internal/installations/cift/python/lib/python3.9/site-packages/cift_builders/bram/hdl/capture.vhd" -library work
set_global_assignment -name VHDL_FILE "/nas/home/tsung/CODE/stratix_cift-internal/installations/cift/python/lib/python3.9/site-packages/cift_builders/bram/hdl/harness.vhd" -library work
set_global_assignment -name VHDL_FILE "/nas/home/tsung/CODE/stratix_cift-internal/installations/cift/interfaces/vjtag_stratix10/io_wrapper.vhd" -library work
#
set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 256
set_global_assignment -name EDA_DESIGN_ENTRY_SYNTHESIS_TOOL "Synplify Pro"
set_global_assignment -name EDA_LMF_FILE synplcty.lmf -section_id eda_design_synthesis
set_global_assignment -name EDA_INPUT_DATA_FORMAT VQM -section_id eda_design_synthesis
set_global_assignment -name EDA_SIMULATION_TOOL "VCS MX (VHDL)"
set_global_assignment -name EDA_OUTPUT_DATA_FORMAT VHDL -section_id eda_simulation
set_global_assignment -name POWER_APPLY_THERMAL_MARGIN ADDITIONAL
#
project_close


