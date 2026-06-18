#
# US+ mux1 apply rip up and re-route script
#
write_checkpoint _ROUTED_ORIG.dcp -force
set nets_to_route [list]
set net_constraints [list]
foreach cell [get_cells harness/test_region_i/* -filter {REF_NAME=="plb"}] {
    set cell_slice [get_sites -of $cell]
    foreach bus_index {0 1 2 3 4 5 6 7} {
        set target_net [get_nets $cell/O[$bus_index]]
        set new_route_start [get_nodes -downhill -of [get_site_pins $cell_slice/[lindex "AMUX BMUX CMUX DMUX EMUX FMUX GMUX HMUX" $bus_index]]]
        set slice_wrapper_pin [get_pins -of_objects $target_net -filter {REF_NAME=="plb"}]
        set slice_wrapper_net [get_nets -of_objects $slice_wrapper_pin]
        set next_pin [get_pins -of_objects $slice_wrapper_net -filter {REF_NAME!="plb"}]
        if {[get_property REF_NAME $next_pin] == "test_region"} {
            set test_to_tpg_net [get_nets -of_objects $next_pin]
            set tpg_pin [get_pins -of_objects $test_to_tpg_net -filter {REF_NAME=="tpg"}]
            set IMUX_net [get_nets $tpg_pin]
        } else {
            set IMUX_net [get_nets $next_pin]
        }
        set imux_nodes [get_nodes -of $IMUX_net */IMUX*]
        if {[llength $imux_nodes] > 1} {error "Too many IMUX nodes in original design"}
        set new_route_end [lindex $imux_nodes 0] 
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
write_checkpoint _ROUTED.dcp -force

