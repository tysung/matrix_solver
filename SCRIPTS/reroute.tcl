#
open_checkpoint /import/home/tsung/CODE/sp7_cift-internal/temp/one-slicel-xczu3eg-sfva625-1-e-2021-04-16T19-36-53/1-mux1/build-00000/_ROUTED_ORIG.dcp
set cell[get_cells harness/test_region_i/SLICE_X0Y0]
set cell [get_cells harness/test_region_i/SLICE_X0Y0]
set cell_slice [get_sites -of $cell]
set target_net [get_nets $cell/O[0]]
route_design -unroute $target_net
#
# un-fixed route of a net
#
startgroup
set_property is_route_fixed 0 [get_nets {harness/test_region_i/SLICE_X0Y0/O[0] }]
set_property is_bel_fixed 0 [get_cells {harness/test_region_i/tpg_i2_0/rising.error_latch_i_2 harness/test_region_i/SLICE_X0Y0/slicel_i/LUT_A }]
set_property is_loc_fixed 1 [get_cells {harness/test_region_i/tpg_i2_0/rising.error_latch_i_2 }]
endgroup
#
route_design -unroute -net $target_net
set_property fixed_route "CLEL_R_X0Y0/CLE_CLE_L_SITE_0_AMUX GAP INT_X1Y0/IMUX_W0" $target_net
route_design -net $target_net
#
# fixed route of a net
#
startgroup
set_property is_route_fixed 1 [get_nets {harness/test_region_i/SLICE_X0Y0/O[0] }]
set_property is_bel_fixed 1 [get_cells {harness/test_region_i/tpg_i2_0/rising.error_latch_i_2 harness/test_region_i/SLICE_X0Y0/slicel_i/LUT_A }]
set_property is_loc_fixed 1 [get_cells {harness/test_region_i/tpg_i2_0/rising.error_latch_i_2 }]
endgroup

