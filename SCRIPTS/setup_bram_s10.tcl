project_new s10_dual_port_ram -overwrite
#
set_global_assignment -name TOP_LEVEL_ENTITY dual_port_ram 
set_global_assignment -name ORIGINAL_QUARTUS_VERSION 21.4.0
set_global_assignment -name PROJECT_CREATION_TIME_DATE "16:31:51  MAY 08, 2022"
set_global_assignment -name LAST_QUARTUS_VERSION "21.4.0 Pro Edition"
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY s10_dual_port_ram 
set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
set_global_assignment -name MAX_CORE_JUNCTION_TEMP 100
set_global_assignment -name DEVICE 1SG280LU2F50E2LG
set_global_assignment -name FAMILY "Stratix 10"
#
set_global_assignment -name IP_FILE dual_port_ram.ip -library work
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


