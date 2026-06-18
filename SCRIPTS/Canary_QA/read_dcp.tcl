#-----------------------------------------------------------
# Vivado v2019.2 (64-bit)
# SW Build 2708876 on Wed Nov  6 21:39:14 MST 2019
# IP Build 2700528 on Thu Nov  7 00:09:20 MST 2019
# Start of session at: Wed Dec  9 12:01:05 2020
# Process ID: 13757
# Current directory: /home/tsung/CODE/NEW/cosmic-canary/output_old
# Command line: vivado -mode gui
# Log file: /home/tsung/CODE/cosmic-canary/output_old/vivado.log
# Journal file: /home/tsung/CODE/cosmic-canary/output_old/vivado.jou
#-----------------------------------------------------------
set dcps_list [ glob lut_com*.dcp ]
foreach dcp_f $dcps_list { 
  open_checkpoint /home/tsung/CODE/NEW/cosmic-canary/output_old/$dcp_f
  report_utilization -file /home/tsung/CODE/NEW/cosmic-canary/output_old/canary_report.txt
  close_design
}

