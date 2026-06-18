#
#start_gui
#
open_checkpoint /import/home/tsung/CODE/sp7_cift-internal/temp/all-slices-xc7s25csga324-1-2021-04-29T13-10-55/1-regtest1/build-00000/_ROUTED_ORIG.dcp
set cell [get_cells harness/test_region_i/SLICE_X1Y1 -filter {REF_NAME=="plb"}]
set cell_slice [get_sites -of $cell]
set_property MANUAL_ROUTING [get_property SITE_TYPE $cell_slice] $cell_slice
set_property SITE_PIPS { CLKINV:CLK_B SRUSEDMUX:IN CEUSEDMUX:IN  }
set_property SITE_PIPS { CLKINV:CLK_B SRUSEDMUX:IN CEUSEDMUX:IN } $cell_slice
set bel_cell [get_cells -of $cell_slice -filter {PRIMITIVE_GROUP==FLOP_LATCH}]
if {[llength $bel_cell]  > 0} {unplace_cell $bel_cell}
set_property SITE_PIPS { CLKINV:CLK_B SRUSEDMUX:IN CEUSEDMUX:IN AOUTMUX:O6 BOUTMUX:O6 COUTMUX:O6 DOUTMUX:O6 } $cell_slice
for {set i 0} {$i<[llength $bel_cell]} {incr i} { place_cell [lindex $bel_cell $i] $cell_slice }
set_property SITE_PIPS { CLKINV:CLK_B SRUSEDMUX:IN CEUSEDMUX:IN AOUTMUX:O6 BOUTMUX:O6 COUTMUX:O6 DOUTMUX:O6 AFFMUX:AX BFFMUX:BX CFFMUX:CX DFFMUX:DX } $cell_slice
for {set i 0} {$i<[llength $bel_cell]} {incr i} { place_cell [lindex $bel_cell $i] $cell_slice }
route_design
