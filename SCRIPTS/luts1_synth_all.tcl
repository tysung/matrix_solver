#
#
set workdir /nas/home/tsung/FORMALITY/VIVADO_TEST 
set repo_dir $workdir/../REPO_DIR 
#
cd $workdir 
#
create_project prj_1 $workdir/prj_1 -force -part xc7k70tfbg676-2 
set_property target_language VHDL [current_project]
#
#link_design -part xc7k70tfbg676-2 
#set prj_obj [get_projects dbg_prj]
#set_property XPM_LIBRARIES XPM_MEMORY [current_project] 
#
read_vhdl -library work $workdir/constants_pkg.vhd
read_vhdl -library work $workdir/gold.vhd
read_vhdl -library work $repo_dir/lut_test_tpg_8_3-1.vhd
read_vhdl -library work $repo_dir/series7_slicel.vhd
read_vhdl -library work $workdir/plb.vhd
read_vhdl -library work $workdir/test_gen.vhd
#
read_vhdl -library work $repo_dir/ora.vhd
read_vhdl -library work $repo_dir/capture_small.vhd
read_vhdl -library work $repo_dir/harness.vhd
read_vhdl -library work $repo_dir/io_wrapper_50MHz.vhd
#set_property XPM_LIBRARIES {XPM_MEMORY XPM_FIFO XPM_CDC} [current_project] 
#
#set_property TARGET_SIMULATOR XSim [current_project]
#set_property top top_level [get_filesets sim_1]
#launch_simulation -mode behavioral 
#
#{ mode [ default out_of_context ] }
#{ rtl_skip_ip [] }
#{ incremental [] }
#{ rtl_skip_constraints [] }
#{ no_timing_driven [] }
#set run_option [ list \
# [ dict create FLATTEN_HIERARCHY {rebuilt full none} ] \
# [ dict create ] \
#] 
set run_options [ list \
 [ list FLATTEN_HIERARCHY  { rebuilt full none  } ] \
 [ list GATED_CLOCK_CONVERSION { off on auto  } ] \
]
#
# [ list DIRECTIVE { default  
#                  RuntimeOptimized  
#                  AreaOptimized_high  
#                  AreaOptimized_medium  
#                  AlternateRoutability  
#                  AreaMapLargeShiftRegToBRAM  
#                  AreaMultThresholdDSP  
#                  FewerCarryChains } ] \
# [ list BUFG { 12 } ] \
# [ list NO_LC { false true } ] \
# [ list FANOUT_LIMIT { 10000 } ] \
# [ list SHREG_MIN_SIZE { 3 } ] \
# [ list FSM_EXTRACTION { auto off one_hot sequential johnson gray } ] \
# [ list KEEP_EQUIVALENT_REGISTERS { false true } ] \
# [ list RESOURCE_SHARING { auto on off } ] \
# [ list CASCADE_DSP { auto tree force } ] \
# [ list CONTROL_SET_OPT_THRESHOLD { auto 0 } ] \
# [ list MAX_BRAM { -1 10 100 } ] \
# [ list MAX_DSP { -1 10 100 } ] \
# [ list MAX_BRAM_CASCADE_HEIGHT { -1 10 20 } ] \
# [ list RETIMING { false true } ] \
# [ list NO_SRLEXTRACT { false true} ] \
#]
#
puts $run_options
puts "size = [llength $run_options] "
#
synth_design -rtl -name rtl_1 -top top_level
current_design rtl_1
#
for {set i 0}  {$i < [llength $run_options]}  {incr i}  {
    set option [lindex $run_options $i]
    puts $option
    set optionName [lindex $option 0]
    set valueArr [lindex $option 1]
    #puts $optionName 
    #puts $valueArr
    #
    for {set j 0}  {$j < [llength $valueArr]}  {incr j}  {
        set optionValue [lindex $valueArr $j]
        puts "**** RUN: optionName = $optionName , optionValue = $optionValue "
        set run_name "${optionName}_${optionValue}"
        puts $run_name
        #
        create_run $run_name -flow {Vivado Synthesis 2018} 
        current_run -synthesis [get_runs $run_name]
        #set obj [get_runs synth_1]
        #set_property -name "part" -value "xc7k70tfbg676-2" -objects $obj
        set_property "STEPS.SYNTH_DESIGN.ARGS.${optionName}" $optionValue [get_runs $run_name] 
        #
        launch_runs $run_name -jobs 20
        wait_on_run $run_name 
        #synth_design -top top_level 
        #
        #write_vhdl post_layout.vhd -write_all_overrides -include_xilinx_libs
        open_run -name top_level [get_runs $run_name]
        write_verilog prj_1/prj_1.runs/${run_name}/post_synth.v -mode funcsim -force
        #
        #place_design
        #route_design
        #write_checkpoint -force $workdir/_ROUTED.dcp
        #
        #write_bitstream vivado_luts1.bit -mask_file -force
        #
    }
}
#
close_project
#save_project_as -force aaa_prj
#
#start_gui 
exit


