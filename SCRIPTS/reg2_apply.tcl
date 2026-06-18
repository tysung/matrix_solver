#
#link_design -part xc7s25csga324-1
cd /import/home/tsung/CODE/sp7_cift-internal/temp/all-slices-xc7s25csga324-1-2021-05-03T00-23-27/2-regtest2/build-00000
#
open_checkpoint _ROUTED_ORIG.dcp
#
#set file1 _ROUTED_ORIG
#
#write_checkpoint $file1 -force
#
#set clk_net [get_nets "iclk50MHz"]
#route_design -unroute -nets $clk_net
#
set bels_to_place [list]
foreach cell [get_cells harness/test_region_i/* -filter {REF_NAME=="plb"}] {
    set cell_slice [get_sites -of $cell]
    #
    set bel_cell [get_cells -of $cell_slice -filter {PRIMITIVE_GROUP==LUT}]
    if {[llength $bel_cell]  > 0} {unplace_cell $bel_cell}
    #
    set_property MANUAL_ROUTING [get_property SITE_TYPE $cell_slice] $cell_slice
    set bel_cell [get_cells -of $cell_slice -filter {PRIMITIVE_GROUP==FLOP_LATCH}]
    for {set i 0} {$i<[llength $bel_cell]} {incr i} {
        lappend bels_to_place [get_property BEL [lindex $bel_cell $i]] 
    }
    if {[llength $bel_cell]  > 0} {unplace_cell $bel_cell}
    # OK: first
    #set_property SITE_PIPS { CLKINV:CLK_B SRUSEDMUX:IN CEUSEDMUX:IN AFFMUX:AX BFFMUX:BX CFFMUX:CX DFFMUX:DX AOUTMUX:O5 BOUTMUX:O5 COUTMUX:O5 DOUTMUX:O5 } $cell_slice
    set_property SITE_PIPS { CLKINV:CLK_B SRUSEDMUX:IN CEUSEDMUX:IN A5FFMUX:IN_B B5FFMUX:IN_B C5FFMUX:IN_B D5FFMUX:IN_B AOUTMUX:A5Q BOUTMUX:B5Q COUTMUX:C5Q DOUTMUX:D5Q } $cell_slice
    # put it back to avoid failure in manual routing
    for {set i 0} {$i<[llength $bel_cell]} {incr i} {
        #place_cell [lindex $bel_cell $i] $cell_slice
        set_property BEL [lindex $bels_to_place $i] [lindex $bel_cell $i]
        set_property LOC $cell_slice [lindex $bel_cell $i] 
    }
}
place_design
route_design
write_checkpoint _ROUTED_END.dcp -force
start_gui

