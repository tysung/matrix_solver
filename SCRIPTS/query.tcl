link_design -part xc7s100fgga676-1
set part [get_property PART [current_design]]
set pdev [get_property DEVICE $part]
set pfam [get_property FAMILY $part]
set ppkg [get_property PACKAGE $part]
set pspd [get_property SPEED $part]
set prow [get_property ROWS $part]
set pcol [get_property COLS $part]
puts "QUERY::$pdev,$pfam,$ppkg,$pspd,$prow,$pcol"
set tiles [get_tiles]
set tnames [get_property NAME $tiles]
set ttypes [get_property TYPE $tiles]
set trows [get_property ROW $tiles]
set tcols [get_property COLUMN $tiles]
set outfile [open "store_resources_xc7s100fgga676-1.tmp" w+]
puts $outfile "header: $pdev,$pfam,$ppkg,$pspd,$prow,$pcol"
puts $outfile "tnames: $tnames"
puts $outfile "ttypes: $ttypes"
puts $outfile "trows: $trows"
puts $outfile "tcols: $tcols"
puts -nonewline $outfile "sites: "
foreach site [get_sites] {
   if {[get_property IS_BONDED $site]} {
      set sname [join [get_package_pins -of $site] "/"]
   } else {
      set sname [get_property NAME $site]
   }
   set stile [get_tile -of $site]
   set stype [get_property SITE_TYPE $site]
   if {$stype == "TIEOFF"} {continue}
   puts -nonewline $outfile "$sname $stile $stype "
}
close $outfile
close_design