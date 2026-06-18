#
#link_design -part xc7s25csga324-1
cd /import/home/tsung/CODE/sp7_cift-internal/temp/all-slices-xc7s25csga324-1-2021-04-12T21-32-15/1-mux1/build-00000
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
    puts $cell
    set cell_slice [get_sites -of $cell]
    puts $cell_slice
    foreach bus_index {0} {
        set target_net [get_nets $cell/O[$bus_index]]
        puts "  target_net:   $target_net" 
        set out_site_pin [get_site_pins $cell_slice/[lindex "A B C D" $bus_index]]
        #set out_site_pin [get_site_pins $cell_slice/[lindex "AMUX BMUX CMUX DMUX" $bus_index]]
        puts "  out_site_pin:  $out_site_pin"
        set new_route_start [get_nodes -downhill -of [get_site_pins $cell_slice/[lindex "A B C D" $bus_index]]]
        set new_route_end [get_nodes -uphill -of [get_site_pins $cell_slice/[lindex "A B C D" $bus_index]]]
        puts "  new_route_start:  $new_route_start"
        puts "  new_route_end:  $new_route_end"
        set all_segments [get_nets -segments -of_objects $out_site_pin ]
        puts "  all_segments:  $all_segments"
        set all_pins [get_pins -of_objects $all_segments]
        puts "  all_pins:  $all_pins"
        set all_site_primitives [get_cells -of_objects $all_pins -filter {IS_PRIMITIVE}]
        puts "  all_site_primitives:  $all_site_primitives"
        set all_bel_pins [get_bel_pins -of_objects $target_net]
        puts "  all_bel_pins: $all_bel_pins"
        foreach pin $all_pins {
            puts "  pin property:"
            report_property $pin
            set pin_cell [get_cells -of_object $pin]
            puts "    cell property:"
            report_property $pin_cell
            set pin_site_from_cell [get_sites -of_objects $pin_cell]
            puts "      pin_cell_site: $pin_site_from_cell"
            set pin_net [ get_nets -of_object $pin ]
            puts "    net property:"
            report_property $pin_net
        }
        #set all_pins [get_pins -hierarchical ]
        #set all_pins [get_pins -of_objects $target_net -filter {REF_NAME=="plb"}]
        #puts "  all_pins:  $all_pins"
        #set all_pin_insts [get_cells -of_object $all_pins]
        #puts "  all_pin_insts:  $all_pin_insts"
        #set slice_wrapper_pin [get_pins -of_objects $target_net -filter {REF_NAME=="plb"}]
        #puts "  slice_wrapper_pin:  $slice_wrapper_pin" 
        #set slice_wrapper_net [get_nets -of_objects $slice_wrapper_pin]
        #puts "  slice_wrapper_net:  $slice_wrapper_net" 
        #set next_pin [get_pins -of_objects $slice_wrapper_net -filter {REF_NAME!="plb"}]
        #puts "  next_pin:  $next_pin" 
        #if {[get_property REF_NAME $next_pin] == "test_region"} {
        #    set test_to_tpg_net [get_nets -of_objects $next_pin]
        #    puts "  test_to_tpg_net:  $test_to_tpg_net" 
        #    set tpg_pin [get_pins -of_objects $test_to_tpg_net -filter {REF_NAME=="tpg"}]
        #    puts "  tpg_pin:  $tpg_pin" 
        #    set IMUX_net [get_nets $tpg_pin]
        #} else {
        #    set IMUX_net [get_nets $next_pin]
        #}
        #puts "  IMUX_net:  $IMUX_net" 
        #set target_1 [lindex $target_net 0]
        set imux_nodes [get_nodes -of $target_net */IMUX*]
        #set imux_nodes [get_nodes -of $IMUX_net */IMUX*]
        #puts "  imux_nodes:  $imux_nodes" 
        if {[llength $imux_nodes] > 1} {error "Too many IMUX nodes in original design"}
        set new_route_mid [lindex $imux_nodes 0] 
        puts "  new_route_mid:  $new_route_mid" 
        set new_route "$new_route_start GAP $new_route_mid"
        puts "  new_route:  $new_route" 
        lappend nets_to_route $target_net
        lappend net_constraints $new_route
    }
}
#set num_routes_to_process [llength $nets_to_route]
#route_design -unroute -nets $nets_to_route
#for {set i 0} {$i < $num_routes_to_process} {incr i} {
#    set_property fixed_route [lindex $net_constraints $i] [lindex $nets_to_route $i]
#}
#route_design -nets $nets_to_route
#
#set file _ROUTED_NEW.dcp
#write_checkpoint {file} -force
#start_gui
#exit

