#-----------------------------------------------------------
# Vivado v2018.3 (64-bit)
# SW Build 2405991 on Thu Dec  6 23:36:41 MST 2018
# IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
# Start of session at: Fri Mar 12 17:50:11 2021
# Process ID: 27400
# Current directory: /import/home/tsung/CODE/sp7_cift-internal/temp/one-slicel-xc7s100fgga676-1-2021-03-12T17-49-36/1-luts1/build-00000
# Command line: vivado -mode tcl -nojournal -notrace
# Log file: /import/home/tsung/CODE/sp7_cift-internal/temp/one-slicel-xc7s100fgga676-1-2021-03-12T17-49-36/1-luts1/build-00000/vivado.log
# Journal file: 
#-----------------------------------------------------------
lappend auto_path /import/home/tsung/CODE/sp7_cift-internal/code/main/ift/utils/PyVivado
package require ::cift
::cift::exec_cift_cmd {set_param messaging.disableStorage 1}
::cift::exec_cift_cmd {cd /import/home/tsung/CODE/sp7_cift-internal/temp/one-slicel-xc7s100fgga676-1-2021-03-12T17-49-36/1-luts1/build-00000}
::cift::exec_cift_cmd {link_design -part xc7s100fgga676-1}
::cift::exec_cift_cmd {set_property XPM_LIBRARIES XPM_MEMORY [current_project]}
::cift::exec_cift_cmd {read_hdl vhdl work /import/home/tsung/CODE/sp7_cift-internal/temp/one-slicel-xc7s100fgga676-1-2021-03-12T17-49-36/1-luts1/build-00000/constants_pkg.vhd}
::cift::exec_cift_cmd {read_hdl vhdl work /import/home/tsung/CODE/sp7_cift-internal/temp/one-slicel-xc7s100fgga676-1-2021-03-12T17-49-36/1-luts1/build-00000/gold.vhd}
::cift::exec_cift_cmd {read_hdl vhdl work /import/home/tsung/CODE/sp7_cift-internal/builders_repo/architectures/xilinx/hdl/lut_test_tpg_8_3-1.vhd}
::cift::exec_cift_cmd {read_hdl vhdl work /import/home/tsung/CODE/sp7_cift-internal/code/main/ift/builders/plbs/hdl/ora.vhd}
::cift::exec_cift_cmd {read_hdl vhdl work /import/home/tsung/CODE/sp7_cift-internal/temp/one-slicel-xc7s100fgga676-1-2021-03-12T17-49-36/1-luts1/build-00000/test_gen.vhd}
::cift::exec_cift_cmd {read_hdl vhdl work /import/home/tsung/CODE/sp7_cift-internal/code/main/ift/builders/plbs/hdl/capture_small.vhd}
::cift::exec_cift_cmd {read_hdl vhdl work /import/home/tsung/CODE/sp7_cift-internal/code/main/ift/builders/plbs/hdl/harness.vhd}
::cift::exec_cift_cmd {read_edif [glob /import/home/tsung/CODE/sp7_cift-internal/temp/one-slicel-xc7s100fgga676-1-2021-03-12T17-49-36/1-luts1/build-00000/slice/*.edf]}
::cift::exec_cift_cmd {read_hdl vhdl work /import/home/tsung/CODE/sp7_cift-internal/interfaces/bscan_series7/io_wrapper_50MHz.vhd}
::cift::exec_cift_cmd {set_property XPM_LIBRARIES {XPM_MEMORY XPM_FIFO XPM_CDC} [current_project]}
::cift::exec_cift_cmd {synth_design -top top_level -part xc7s100fgga676-1}
#
::cift::exec_cift_cmd {set_property LOC "SLICE_X1Y0" [get_cells -hier  -filter {REF_NAME!=GND && REF_NAME!=VCC && PARENT=~*/SLICE_X1Y0/* && IS_PRIMITIVE && (PRIMITIVE_GROUP=~CLB || PRIMITIVE_GROUP=~DMEM || PRIMITIVE_GROUP=~REGISTER || PRIMITIVE_GROUP=~OTHERS)}]}
::cift::exec_cift_cmd {set_property LOC "SLICE_X1Y0" [get_cells -hier  -filter {REF_NAME!=GND && REF_NAME!=VCC && PARENT=~*/SLICE_X1Y0 && IS_PRIMITIVE && (PRIMITIVE_GROUP=~CLB || PRIMITIVE_GROUP=~DMEM || PRIMITIVE_GROUP=~REGISTER || PRIMITIVE_GROUP=~OTHERS)}]}
::cift::exec_cift_cmd {if {[catch {current_design} result]} {open_checkpoint /import/home/tsung/CODE/sp7_cift-internal/temp/one-slicel-xc7s100fgga676-1-2021-03-12T17-49-36/1-luts1/build-00000/_SYNTHESIS.dcp}}
::cift::exec_cift_cmd {place_design}
::cift::exec_cift_cmd {if {[catch {current_design} result]} {open_checkpoint /import/home/tsung/CODE/sp7_cift-internal/temp/one-slicel-xc7s100fgga676-1-2021-03-12T17-49-36/1-luts1/build-00000/_ROUTED.dcp}}
::cift::exec_cift_cmd {route_design}
::cift::exec_cift_cmd {write_checkpoint /import/home/tsung/CODE/sp7_cift-internal/temp/one-slicel-xc7s100fgga676-1-2021-03-12T17-49-36/1-luts1/build-00000/_ROUTED.dcp}
exit
