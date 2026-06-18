#-----------------------------------------------------------
# 
# Current directory: /home/tsung/QA/XADC/XADC_Artix7
#
#-----------------------------------------------------------

set ip_xadc_dir "/home/tsung/QA/XADC/XADC_K7/project_1/project_1.srcs/sources_1/ip/xadc_wiz_0"
#
#create_project -force -part xc7a200tffg1156-1 project_1 project_1 
#create_project -force -part xc7k70tfbg676-2 project_1 project_1 
create_project -force -part xc7z010clg400-1 project_1 project_1 
set proj_dir [get_property directory [current_project]]
#
read_verilog -library work design_files/XADC_TEST.v
import_files ${ip_xadc_dir}/xadc_wiz_0.xci
#
synth_design -top XADC_TEST
#
write_verilog post_synth.v -write_all_overrides -mode funcsim -force
#
set_property STEPS.WRITE_BITSTREAM.TCL.PRE ${proj_dir}/../ignore_drc.tcl [get_runs impl_1]
#
launch_runs impl_1 -to_step write_bitstream -jobs 10
wait_on_run impl_1
#
set impl_dir [get_property DIRECTORY [get_runs impl_1]]
file copy -force ${impl_dir}/XADC_TEST.bit ${proj_dir}/../XADC_TEST_z7.bit
#
#exit
#

