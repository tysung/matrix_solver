#
#link_design -part xc7s25csga324-1
cd /import/home/tsung/CODE/sp7_cift-internal/temp/all-slices-xc7s25csga324-1-2021-04-15T16-20-28/1-mux2/build-00000
#
open_checkpoint _ROUTED_ORIG.dcp
#
#set file1 _ROUTED_ORIG
#
#write_checkpoint $file1 -force
#
set nets_to_route [list]
set net_constraints [list]
foreach cell [get_cells harness/test_region_i/* -filter {REF_NAME=="plb"}] {
    set cell_slice [get_sites -of $cell]
    foreach bus_index {0 1 2 3} {
        set target_net [get_nets $cell/O[$bus_index]]
        set new_route_start [get_nodes -downhill -of [get_site_pins $cell_slice/[lindex "AMUX BMUX CMUX DMUX" $bus_index]]]
        set in_bel_pin [get_bel_pins -of_objects $target_net -filter {DIRECTION=="IN"}]
        set in_site_pin [get_site_pins -of_objects $in_bel_pin]
        set in_node [get_nodes -of_object $in_site_pin]
        set new_route_end [lindex $in_node 0]
        set imux_nodes [get_nodes -of $target_net */IMUX*]
        if {[llength $imux_nodes] > 1} {error "Too many IMUX nodes in original design"}
        set new_route_mid [lindex $imux_nodes 0] 
        set new_route "$new_route_start GAP $new_route_end"
        lappend nets_to_route $target_net
        lappend net_constraints $new_route
    }
}
set num_routes_to_process [llength $nets_to_route]
route_design -unroute -nets $nets_to_route
for {set i 0} {$i < $num_routes_to_process} {incr i} {
    set_property fixed_route [lindex $net_constraints $i] [lindex $nets_to_route $i]
}
route_design -nets $nets_to_route
write_checkpoint _ROUTED_END.dcp -force
start_gui

