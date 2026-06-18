remove_design -all
set power_preserve_rtl_hier_names "true"
set base_dir /nas/home/tsung/DESIGN_COMPILER/optimizations/bram
define_design_lib work -path "work"
set topname "top"

set link_library /nas/home/tsung/DESIGN_COMPILER/DB/lsi_10k.db  
set target_library /nas/home/tsung/DESIGN_COMPILER/DB/lsi_10k.db 

analyze -library WORK -format verilog $base_dir/sram.v

elaborate $topname -lib work -update


current_design $topname


#remove_constraint -all
#remove_clock -all
#set_max_area 0
compile
#compile_ultra -area_effort
#compile_ultra -timing_high_effort_script 

set sdfout_time_scale 0.001000

                 
redirect change_names \
{ change_names -rules verilog -hierarchy -verbose }
write -format verilog -hierarchy -output $base_dir/bram_dc_result.v

write -format ddc -hierarchy -output "$base_dir/bram.ddc"
#write -hier -format verilog -out "$base_dir/bram_op_out.v"


exit

