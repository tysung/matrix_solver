--------------------------------------------------------------------------------
-- Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor: Xilinx
-- \   \   \/     Version: P.20131013
--  \   \         Application: netgen
--  /   /         Filename: interconnect-0.vhd
-- /___/   /\     Timestamp: Thu Jul 29 18:30:16 2021
-- \   \  /  \ 
--  \___\/\___\
--             
-- Command	: -w -aka -sim -ofmt vhdl -intstyle ise -mhf -pcf ../init-00000/harness_placed.pcf -tb -mhf interconnect-0.ncd 
-- Device	: 6slx45csg484-3 (PRODUCTION 1.23 2013-10-13)
-- Input file	: interconnect-0.ncd
-- Output file	: interconnect-0.vhd
-- # of Entities	: 1
-- Design Name	: top_level
-- Xilinx	: /nas/projects/FPGA_tools/tools/linux/xilinx/14.7/ISE_DS/ISE/
--             
-- Purpose:    
--     This VHDL netlist is a verification model and uses simulation 
--     primitives which may not represent the true implementation of the 
--     device, however the netlist is functionally correct and should not 
--     be modified. This file cannot be synthesized and should only be used 
--     with supported simulation tools.
--             
-- Reference:  
--     Command Line Tools User Guide, Chapter 23
--     Synthesis and Simulation Design Guide, Chapter 6
--             
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library SIMPRIM;
use SIMPRIM.VCOMPONENTS.ALL;
use SIMPRIM.VPACKAGE.ALL;

-- tysung, add clk port
entity top_level is
  port (
    clk : in STD_LOGIC := 'X'
  );
end top_level;

architecture STRUCTURE of top_level is
-- tysung,  signal clk : STD_LOGIC; 
  signal iclk50MHz : STD_LOGIC; 
  signal pass : STD_LOGIC; 
  signal driver_net : STD_LOGIC; 
  signal result_net : STD_LOGIC; 
  signal ift_int_test_SLICE_X25Y21B_to_SLICE_X41Y22C : STD_LOGIC; 
  signal ift_int_test_SLICE_X27Y20B_to_SLICE_X43Y21C : STD_LOGIC; 
  signal ift_int_test_SLICE_X41Y22C_to_SLICE_X27Y20B : STD_LOGIC; 
  signal ift_int_test_SLICE_X29Y20D_to_SLICE_X37Y20C : STD_LOGIC; 
  signal ift_int_test_SLICE_X43Y21C_to_SLICE_X29Y20D : STD_LOGIC; 
  signal ift_int_test_SLICE_X31Y21C_to_SLICE_X39Y21C : STD_LOGIC; 
  signal ift_int_test_SLICE_X37Y20C_to_SLICE_X31Y21C : STD_LOGIC; 
  signal ift_int_test_SLICE_X29Y21C_to_SLICE_X37Y21C : STD_LOGIC; 
  signal ift_int_test_SLICE_X39Y21C_to_SLICE_X29Y21C : STD_LOGIC; 
  signal ift_int_test_SLICE_X31Y20B_to_SLICE_X47Y21C : STD_LOGIC; 
  signal ift_int_test_SLICE_X37Y21C_to_SLICE_X31Y20B : STD_LOGIC; 
  signal ift_int_test_SLICE_X31Y21B_to_SLICE_X47Y22C : STD_LOGIC; 
  signal ift_int_test_SLICE_X47Y21C_to_SLICE_X31Y21B : STD_LOGIC; 
  signal ift_int_test_SLICE_X33Y20B_to_SLICE_X41Y20C : STD_LOGIC; 
  signal ift_int_test_SLICE_X47Y22C_to_SLICE_X33Y20B : STD_LOGIC; 
  signal ift_int_test_SLICE_X29Y20B_to_SLICE_X45Y21C : STD_LOGIC; 
  signal ift_int_test_SLICE_X41Y20C_to_SLICE_X29Y20B : STD_LOGIC; 
  signal ift_int_test_SLICE_X35Y20B_to_SLICE_X43Y19C : STD_LOGIC; 
  signal ift_int_test_SLICE_X45Y21C_to_SLICE_X35Y20B : STD_LOGIC; 
  signal ift_int_test_SLICE_X31Y20C_to_SLICE_X47Y21D : STD_LOGIC; 
  signal ift_int_test_SLICE_X43Y19C_to_SLICE_X31Y20C : STD_LOGIC; 
  signal ift_int_test_SLICE_X35Y21D_to_SLICE_X43Y22C : STD_LOGIC; 
  signal ift_int_test_SLICE_X47Y21D_to_SLICE_X35Y21D : STD_LOGIC; 
  signal ift_int_test_SLICE_X28Y21A_to_SLICE_X45Y22D : STD_LOGIC; 
  signal ift_int_test_SLICE_X43Y22C_to_SLICE_X28Y21A : STD_LOGIC; 
  signal ift_int_test_SLICE_X30Y20A_to_SLICE_X46Y21B : STD_LOGIC; 
  signal ift_int_test_SLICE_X45Y22D_to_SLICE_X30Y20A : STD_LOGIC; 
  signal ift_int_test_SLICE_X35Y21B_to_SLICE_X43Y20C : STD_LOGIC; 
  signal ift_int_test_SLICE_X46Y21B_to_SLICE_X35Y21B : STD_LOGIC; 
  signal ift_int_test_SLICE_X33Y23D_to_SLICE_X41Y23C : STD_LOGIC; 
  signal ift_int_test_SLICE_X43Y20C_to_SLICE_X33Y23D : STD_LOGIC; 
  signal ift_int_test_SLICE_X31Y23C_to_SLICE_X47Y24C : STD_LOGIC; 
  signal ift_int_test_SLICE_X41Y23C_to_SLICE_X31Y23C : STD_LOGIC; 
  signal ift_int_test_SLICE_X31Y22B_to_SLICE_X47Y23C : STD_LOGIC; 
  signal ift_int_test_SLICE_X47Y24C_to_SLICE_X31Y22B : STD_LOGIC; 
  signal ift_int_test_SLICE_X35Y23B_to_SLICE_X43Y24C : STD_LOGIC; 
  signal ift_int_test_SLICE_X47Y23C_to_SLICE_X35Y23B : STD_LOGIC; 
  signal ift_int_test_SLICE_X29Y22B_to_SLICE_X45Y23C : STD_LOGIC; 
  signal ift_int_test_SLICE_X43Y24C_to_SLICE_X29Y22B : STD_LOGIC; 
  signal harness_ram_Mram_state_machine_DOBDO0 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DOBDO0
  signal harness_ram_Mram_state_machine_DOBDO1 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DOBDO1
  signal harness_ram_Mram_state_machine_DOBDO2 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DOBDO2
  signal harness_ram_Mram_state_machine_DOBDO3 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DOBDO3
  signal harness_ram_Mram_state_machine_DOBDO4 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DOBDO4
  signal harness_ram_Mram_state_machine_DOBDO5 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DOBDO5
  signal harness_ram_Mram_state_machine_DOBDO6 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DOBDO6
  signal harness_ram_Mram_state_machine_DOBDO7 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DOBDO7
  signal harness_ram_Mram_state_machine_DOBDO8 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DOBDO8
  signal harness_ram_Mram_state_machine_DOBDO9 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DOBDO9
  signal harness_ram_Mram_state_machine_DOBDO10 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DOBDO10
  signal harness_ram_Mram_state_machine_DOBDO11 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DOBDO11
  signal harness_ram_Mram_state_machine_DOBDO12 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DOBDO12
  signal harness_ram_Mram_state_machine_DOBDO13 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DOBDO13
  signal harness_ram_Mram_state_machine_DOBDO14 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DOBDO14
  signal harness_ram_Mram_state_machine_DOBDO15 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DOBDO15
  signal harness_ram_Mram_state_machine_DOPBDOP0 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DOPBDOP0
  signal harness_ram_Mram_state_machine_DOPBDOP1 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DOPBDOP1
  signal harness_ram_Mram_state_machine_DOPADOP0 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DOPADOP0
  signal harness_ram_Mram_state_machine_DOPADOP1 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DOPADOP1
  signal harness_ram_Mram_state_machine_DOADO6 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DOADO6
  signal harness_ram_Mram_state_machine_DOADO7 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DOADO7
  signal harness_ram_Mram_state_machine_DOADO8 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DOADO8
  signal harness_ram_Mram_state_machine_DOADO9 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DOADO9
  signal harness_ram_Mram_state_machine_DOADO10 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DOADO10
  signal harness_ram_Mram_state_machine_DOADO11 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DOADO11
  signal harness_ram_Mram_state_machine_DOADO12 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DOADO12
  signal harness_ram_Mram_state_machine_DOADO13 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DOADO13
  signal harness_ram_Mram_state_machine_DOADO14 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DOADO14
  signal harness_ram_Mram_state_machine_DOADO15 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DOADO15
  signal harness_ram_Mram_state_machine_DIPADIP1 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DIPADIP1
  signal harness_ram_Mram_state_machine_ADDRBRDADDR0 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/ADDRBRDADDR0
  signal harness_ram_Mram_state_machine_ADDRBRDADDR1 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/ADDRBRDADDR1
  signal harness_ram_Mram_state_machine_ADDRBRDADDR2 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/ADDRBRDADDR2
  signal harness_ram_Mram_state_machine_ADDRBRDADDR3 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/ADDRBRDADDR3
  signal harness_ram_Mram_state_machine_ADDRBRDADDR4 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/ADDRBRDADDR4
  signal harness_ram_Mram_state_machine_ADDRBRDADDR5 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/ADDRBRDADDR5
  signal harness_ram_Mram_state_machine_ADDRBRDADDR6 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/ADDRBRDADDR6
  signal harness_ram_Mram_state_machine_ADDRBRDADDR7 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/ADDRBRDADDR7
  signal harness_ram_Mram_state_machine_ADDRBRDADDR8 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/ADDRBRDADDR8
  signal harness_ram_Mram_state_machine_ADDRBRDADDR9 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/ADDRBRDADDR9
  signal harness_ram_Mram_state_machine_ADDRBRDADDR10 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/ADDRBRDADDR10
  signal harness_ram_Mram_state_machine_ADDRBRDADDR11 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/ADDRBRDADDR11
  signal harness_ram_Mram_state_machine_ADDRBRDADDR12 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/ADDRBRDADDR12
  signal harness_ram_Mram_state_machine_DIADI8 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DIADI8
  signal harness_ram_Mram_state_machine_DIADI9 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DIADI9
  signal harness_ram_Mram_state_machine_DIADI10 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DIADI10
  signal harness_ram_Mram_state_machine_DIADI11 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DIADI11
  signal harness_ram_Mram_state_machine_DIADI12 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DIADI12
  signal harness_ram_Mram_state_machine_DIADI13 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DIADI13
  signal harness_ram_Mram_state_machine_DIADI14 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DIADI14
  signal harness_ram_Mram_state_machine_DIADI15 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DIADI15
  signal harness_ram_Mram_state_machine_DIBDI0 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DIBDI0
  signal harness_ram_Mram_state_machine_DIBDI1 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DIBDI1
  signal harness_ram_Mram_state_machine_DIBDI2 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DIBDI2
  signal harness_ram_Mram_state_machine_DIBDI3 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DIBDI3
  signal harness_ram_Mram_state_machine_DIBDI4 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DIBDI4
  signal harness_ram_Mram_state_machine_DIBDI5 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DIBDI5
  signal harness_ram_Mram_state_machine_DIBDI6 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DIBDI6
  signal harness_ram_Mram_state_machine_DIBDI7 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DIBDI7
  signal harness_ram_Mram_state_machine_DIBDI8 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DIBDI8
  signal harness_ram_Mram_state_machine_DIBDI9 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DIBDI9
  signal harness_ram_Mram_state_machine_DIBDI10 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DIBDI10
  signal harness_ram_Mram_state_machine_DIBDI11 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DIBDI11
  signal harness_ram_Mram_state_machine_DIBDI12 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DIBDI12
  signal harness_ram_Mram_state_machine_DIBDI13 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DIBDI13
  signal harness_ram_Mram_state_machine_DIBDI14 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DIBDI14
  signal harness_ram_Mram_state_machine_DIBDI15 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DIBDI15
  signal harness_ram_Mram_state_machine_DIPBDIP0 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DIPBDIP0
  signal harness_ram_Mram_state_machine_DIPBDIP1 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/DIPBDIP1
  signal harness_ram_Mram_state_machine_ADDRAWRADDR0 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/ADDRAWRADDR0
  signal harness_ram_Mram_state_machine_ADDRAWRADDR1 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/ADDRAWRADDR1
  signal harness_ram_Mram_state_machine_ADDRAWRADDR2 : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/ADDRAWRADDR2
  signal harness_ram_Mram_state_machine_WEAWEL0_INT : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/WEAWEL0_INT
  signal harness_ram_Mram_state_machine_WEAWEL1_INT : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/WEAWEL1_INT
  signal harness_ram_Mram_state_machine_RSTA_INT : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/RSTA_INT
  signal harness_ram_Mram_state_machine_CLKAWRCLK_INT : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/CLKAWRCLK_INT
  signal harness_ram_Mram_state_machine_ENAWREN_INT : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/ENAWREN_INT
  signal harness_ram_Mram_state_machine_REGCEA_INT : STD_LOGIC; -- AKA:harness/ram/Mram_state_machine/REGCEA_INT
  signal harness_counter1_M0 : STD_LOGIC; -- AKA:harness/counter1/M0
  signal harness_counter1_M1 : STD_LOGIC; -- AKA:harness/counter1/M1
  signal harness_counter1_M2 : STD_LOGIC; -- AKA:harness/counter1/M2
  signal harness_counter1_M3 : STD_LOGIC; -- AKA:harness/counter1/M3
  signal harness_counter1_M4 : STD_LOGIC; -- AKA:harness/counter1/M4
  signal harness_counter1_M5 : STD_LOGIC; -- AKA:harness/counter1/M5
  signal harness_counter1_M6 : STD_LOGIC; -- AKA:harness/counter1/M6
  signal harness_counter1_M7 : STD_LOGIC; -- AKA:harness/counter1/M7
  signal harness_counter1_M8 : STD_LOGIC; -- AKA:harness/counter1/M8
  signal harness_counter1_M9 : STD_LOGIC; -- AKA:harness/counter1/M9
  signal harness_counter1_M10 : STD_LOGIC; -- AKA:harness/counter1/M10
  signal harness_counter1_M11 : STD_LOGIC; -- AKA:harness/counter1/M11
  signal harness_counter1_M12 : STD_LOGIC; -- AKA:harness/counter1/M12
  signal harness_counter1_M13 : STD_LOGIC; -- AKA:harness/counter1/M13
  signal harness_counter1_M14 : STD_LOGIC; -- AKA:harness/counter1/M14
  signal harness_counter1_M15 : STD_LOGIC; -- AKA:harness/counter1/M15
  signal harness_counter1_M16 : STD_LOGIC; -- AKA:harness/counter1/M16
  signal harness_counter1_M17 : STD_LOGIC; -- AKA:harness/counter1/M17
  signal harness_counter1_M18 : STD_LOGIC; -- AKA:harness/counter1/M18
  signal harness_counter1_M19 : STD_LOGIC; -- AKA:harness/counter1/M19
  signal harness_counter1_M20 : STD_LOGIC; -- AKA:harness/counter1/M20
  signal harness_counter1_M21 : STD_LOGIC; -- AKA:harness/counter1/M21
  signal harness_counter1_M22 : STD_LOGIC; -- AKA:harness/counter1/M22
  signal harness_counter1_M23 : STD_LOGIC; -- AKA:harness/counter1/M23
  signal harness_counter1_M24 : STD_LOGIC; -- AKA:harness/counter1/M24
  signal harness_counter1_M25 : STD_LOGIC; -- AKA:harness/counter1/M25
  signal harness_counter1_M26 : STD_LOGIC; -- AKA:harness/counter1/M26
  signal harness_counter1_M27 : STD_LOGIC; -- AKA:harness/counter1/M27
  signal harness_counter1_M28 : STD_LOGIC; -- AKA:harness/counter1/M28
  signal harness_counter1_M29 : STD_LOGIC; -- AKA:harness/counter1/M29
  signal harness_counter1_M30 : STD_LOGIC; -- AKA:harness/counter1/M30
  signal harness_counter1_M31 : STD_LOGIC; -- AKA:harness/counter1/M31
  signal harness_counter1_M32 : STD_LOGIC; -- AKA:harness/counter1/M32
  signal harness_counter1_M33 : STD_LOGIC; -- AKA:harness/counter1/M33
  signal harness_counter1_M34 : STD_LOGIC; -- AKA:harness/counter1/M34
  signal harness_counter1_M35 : STD_LOGIC; -- AKA:harness/counter1/M35
  signal harness_counter1_PCOUT0 : STD_LOGIC; -- AKA:harness/counter1/PCOUT0
  signal harness_counter1_PCOUT1 : STD_LOGIC; -- AKA:harness/counter1/PCOUT1
  signal harness_counter1_PCOUT2 : STD_LOGIC; -- AKA:harness/counter1/PCOUT2
  signal harness_counter1_PCOUT3 : STD_LOGIC; -- AKA:harness/counter1/PCOUT3
  signal harness_counter1_PCOUT4 : STD_LOGIC; -- AKA:harness/counter1/PCOUT4
  signal harness_counter1_PCOUT5 : STD_LOGIC; -- AKA:harness/counter1/PCOUT5
  signal harness_counter1_PCOUT6 : STD_LOGIC; -- AKA:harness/counter1/PCOUT6
  signal harness_counter1_PCOUT7 : STD_LOGIC; -- AKA:harness/counter1/PCOUT7
  signal harness_counter1_PCOUT8 : STD_LOGIC; -- AKA:harness/counter1/PCOUT8
  signal harness_counter1_PCOUT9 : STD_LOGIC; -- AKA:harness/counter1/PCOUT9
  signal harness_counter1_PCOUT10 : STD_LOGIC; -- AKA:harness/counter1/PCOUT10
  signal harness_counter1_PCOUT11 : STD_LOGIC; -- AKA:harness/counter1/PCOUT11
  signal harness_counter1_PCOUT12 : STD_LOGIC; -- AKA:harness/counter1/PCOUT12
  signal harness_counter1_PCOUT13 : STD_LOGIC; -- AKA:harness/counter1/PCOUT13
  signal harness_counter1_PCOUT14 : STD_LOGIC; -- AKA:harness/counter1/PCOUT14
  signal harness_counter1_PCOUT15 : STD_LOGIC; -- AKA:harness/counter1/PCOUT15
  signal harness_counter1_PCOUT16 : STD_LOGIC; -- AKA:harness/counter1/PCOUT16
  signal harness_counter1_PCOUT17 : STD_LOGIC; -- AKA:harness/counter1/PCOUT17
  signal harness_counter1_PCOUT18 : STD_LOGIC; -- AKA:harness/counter1/PCOUT18
  signal harness_counter1_PCOUT19 : STD_LOGIC; -- AKA:harness/counter1/PCOUT19
  signal harness_counter1_PCOUT20 : STD_LOGIC; -- AKA:harness/counter1/PCOUT20
  signal harness_counter1_PCOUT21 : STD_LOGIC; -- AKA:harness/counter1/PCOUT21
  signal harness_counter1_PCOUT22 : STD_LOGIC; -- AKA:harness/counter1/PCOUT22
  signal harness_counter1_PCOUT23 : STD_LOGIC; -- AKA:harness/counter1/PCOUT23
  signal harness_counter1_PCOUT24 : STD_LOGIC; -- AKA:harness/counter1/PCOUT24
  signal harness_counter1_PCOUT25 : STD_LOGIC; -- AKA:harness/counter1/PCOUT25
  signal harness_counter1_PCOUT26 : STD_LOGIC; -- AKA:harness/counter1/PCOUT26
  signal harness_counter1_PCOUT27 : STD_LOGIC; -- AKA:harness/counter1/PCOUT27
  signal harness_counter1_PCOUT28 : STD_LOGIC; -- AKA:harness/counter1/PCOUT28
  signal harness_counter1_PCOUT29 : STD_LOGIC; -- AKA:harness/counter1/PCOUT29
  signal harness_counter1_PCOUT30 : STD_LOGIC; -- AKA:harness/counter1/PCOUT30
  signal harness_counter1_PCOUT31 : STD_LOGIC; -- AKA:harness/counter1/PCOUT31
  signal harness_counter1_PCOUT32 : STD_LOGIC; -- AKA:harness/counter1/PCOUT32
  signal harness_counter1_PCOUT33 : STD_LOGIC; -- AKA:harness/counter1/PCOUT33
  signal harness_counter1_PCOUT34 : STD_LOGIC; -- AKA:harness/counter1/PCOUT34
  signal harness_counter1_PCOUT35 : STD_LOGIC; -- AKA:harness/counter1/PCOUT35
  signal harness_counter1_PCOUT36 : STD_LOGIC; -- AKA:harness/counter1/PCOUT36
  signal harness_counter1_PCOUT37 : STD_LOGIC; -- AKA:harness/counter1/PCOUT37
  signal harness_counter1_PCOUT38 : STD_LOGIC; -- AKA:harness/counter1/PCOUT38
  signal harness_counter1_PCOUT39 : STD_LOGIC; -- AKA:harness/counter1/PCOUT39
  signal harness_counter1_PCOUT40 : STD_LOGIC; -- AKA:harness/counter1/PCOUT40
  signal harness_counter1_PCOUT41 : STD_LOGIC; -- AKA:harness/counter1/PCOUT41
  signal harness_counter1_PCOUT42 : STD_LOGIC; -- AKA:harness/counter1/PCOUT42
  signal harness_counter1_PCOUT43 : STD_LOGIC; -- AKA:harness/counter1/PCOUT43
  signal harness_counter1_PCOUT44 : STD_LOGIC; -- AKA:harness/counter1/PCOUT44
  signal harness_counter1_PCOUT45 : STD_LOGIC; -- AKA:harness/counter1/PCOUT45
  signal harness_counter1_PCOUT46 : STD_LOGIC; -- AKA:harness/counter1/PCOUT46
  signal harness_counter1_PCOUT47 : STD_LOGIC; -- AKA:harness/counter1/PCOUT47
  signal harness_counter1_P0 : STD_LOGIC; -- AKA:harness/counter1/P0
  signal harness_counter1_P1 : STD_LOGIC; -- AKA:harness/counter1/P1
  signal harness_counter1_P2 : STD_LOGIC; -- AKA:harness/counter1/P2
  signal harness_counter1_P3 : STD_LOGIC; -- AKA:harness/counter1/P3
  signal harness_counter1_P4 : STD_LOGIC; -- AKA:harness/counter1/P4
  signal harness_counter1_P5 : STD_LOGIC; -- AKA:harness/counter1/P5
  signal harness_counter1_P6 : STD_LOGIC; -- AKA:harness/counter1/P6
  signal harness_counter1_P7 : STD_LOGIC; -- AKA:harness/counter1/P7
  signal harness_counter1_P8 : STD_LOGIC; -- AKA:harness/counter1/P8
  signal harness_counter1_P9 : STD_LOGIC; -- AKA:harness/counter1/P9
  signal harness_counter1_P10 : STD_LOGIC; -- AKA:harness/counter1/P10
  signal harness_counter1_P11 : STD_LOGIC; -- AKA:harness/counter1/P11
  signal harness_counter1_P12 : STD_LOGIC; -- AKA:harness/counter1/P12
  signal harness_counter1_P14 : STD_LOGIC; -- AKA:harness/counter1/P14
  signal harness_counter1_P15 : STD_LOGIC; -- AKA:harness/counter1/P15
  signal harness_counter1_P16 : STD_LOGIC; -- AKA:harness/counter1/P16
  signal harness_counter1_P17 : STD_LOGIC; -- AKA:harness/counter1/P17
  signal harness_counter1_P18 : STD_LOGIC; -- AKA:harness/counter1/P18
  signal harness_counter1_P19 : STD_LOGIC; -- AKA:harness/counter1/P19
  signal harness_counter1_P20 : STD_LOGIC; -- AKA:harness/counter1/P20
  signal harness_counter1_P21 : STD_LOGIC; -- AKA:harness/counter1/P21
  signal harness_counter1_P22 : STD_LOGIC; -- AKA:harness/counter1/P22
  signal harness_counter1_P23 : STD_LOGIC; -- AKA:harness/counter1/P23
  signal harness_counter1_P24 : STD_LOGIC; -- AKA:harness/counter1/P24
  signal harness_counter1_P25 : STD_LOGIC; -- AKA:harness/counter1/P25
  signal harness_counter1_P26 : STD_LOGIC; -- AKA:harness/counter1/P26
  signal harness_counter1_P27 : STD_LOGIC; -- AKA:harness/counter1/P27
  signal harness_counter1_P28 : STD_LOGIC; -- AKA:harness/counter1/P28
  signal harness_counter1_P29 : STD_LOGIC; -- AKA:harness/counter1/P29
  signal harness_counter1_P30 : STD_LOGIC; -- AKA:harness/counter1/P30
  signal harness_counter1_P31 : STD_LOGIC; -- AKA:harness/counter1/P31
  signal harness_counter1_P32 : STD_LOGIC; -- AKA:harness/counter1/P32
  signal harness_counter1_P33 : STD_LOGIC; -- AKA:harness/counter1/P33
  signal harness_counter1_P34 : STD_LOGIC; -- AKA:harness/counter1/P34
  signal harness_counter1_P35 : STD_LOGIC; -- AKA:harness/counter1/P35
  signal harness_counter1_P36 : STD_LOGIC; -- AKA:harness/counter1/P36
  signal harness_counter1_P37 : STD_LOGIC; -- AKA:harness/counter1/P37
  signal harness_counter1_P38 : STD_LOGIC; -- AKA:harness/counter1/P38
  signal harness_counter1_P39 : STD_LOGIC; -- AKA:harness/counter1/P39
  signal harness_counter1_P40 : STD_LOGIC; -- AKA:harness/counter1/P40
  signal harness_counter1_P41 : STD_LOGIC; -- AKA:harness/counter1/P41
  signal harness_counter1_P42 : STD_LOGIC; -- AKA:harness/counter1/P42
  signal harness_counter1_P43 : STD_LOGIC; -- AKA:harness/counter1/P43
  signal harness_counter1_P44 : STD_LOGIC; -- AKA:harness/counter1/P44
  signal harness_counter1_P45 : STD_LOGIC; -- AKA:harness/counter1/P45
  signal harness_counter1_P46 : STD_LOGIC; -- AKA:harness/counter1/P46
  signal harness_counter1_P47 : STD_LOGIC; -- AKA:harness/counter1/P47
  signal harness_counter1_BCOUT0 : STD_LOGIC; -- AKA:harness/counter1/BCOUT0
  signal harness_counter1_BCOUT1 : STD_LOGIC; -- AKA:harness/counter1/BCOUT1
  signal harness_counter1_BCOUT2 : STD_LOGIC; -- AKA:harness/counter1/BCOUT2
  signal harness_counter1_BCOUT3 : STD_LOGIC; -- AKA:harness/counter1/BCOUT3
  signal harness_counter1_BCOUT4 : STD_LOGIC; -- AKA:harness/counter1/BCOUT4
  signal harness_counter1_BCOUT5 : STD_LOGIC; -- AKA:harness/counter1/BCOUT5
  signal harness_counter1_BCOUT6 : STD_LOGIC; -- AKA:harness/counter1/BCOUT6
  signal harness_counter1_BCOUT7 : STD_LOGIC; -- AKA:harness/counter1/BCOUT7
  signal harness_counter1_BCOUT8 : STD_LOGIC; -- AKA:harness/counter1/BCOUT8
  signal harness_counter1_BCOUT9 : STD_LOGIC; -- AKA:harness/counter1/BCOUT9
  signal harness_counter1_BCOUT10 : STD_LOGIC; -- AKA:harness/counter1/BCOUT10
  signal harness_counter1_BCOUT11 : STD_LOGIC; -- AKA:harness/counter1/BCOUT11
  signal harness_counter1_BCOUT12 : STD_LOGIC; -- AKA:harness/counter1/BCOUT12
  signal harness_counter1_BCOUT13 : STD_LOGIC; -- AKA:harness/counter1/BCOUT13
  signal harness_counter1_BCOUT14 : STD_LOGIC; -- AKA:harness/counter1/BCOUT14
  signal harness_counter1_BCOUT15 : STD_LOGIC; -- AKA:harness/counter1/BCOUT15
  signal harness_counter1_BCOUT16 : STD_LOGIC; -- AKA:harness/counter1/BCOUT16
  signal harness_counter1_BCOUT17 : STD_LOGIC; -- AKA:harness/counter1/BCOUT17
  signal harness_counter1_CARRYOUT : STD_LOGIC; -- AKA:harness/counter1/CARRYOUT
  signal harness_counter1_CARRYOUTF : STD_LOGIC; -- AKA:harness/counter1/CARRYOUTF
  signal harness_counter1_BCIN0 : STD_LOGIC; -- AKA:harness/counter1/BCIN0
  signal harness_counter1_BCIN1 : STD_LOGIC; -- AKA:harness/counter1/BCIN1
  signal harness_counter1_BCIN2 : STD_LOGIC; -- AKA:harness/counter1/BCIN2
  signal harness_counter1_BCIN3 : STD_LOGIC; -- AKA:harness/counter1/BCIN3
  signal harness_counter1_BCIN4 : STD_LOGIC; -- AKA:harness/counter1/BCIN4
  signal harness_counter1_BCIN5 : STD_LOGIC; -- AKA:harness/counter1/BCIN5
  signal harness_counter1_BCIN6 : STD_LOGIC; -- AKA:harness/counter1/BCIN6
  signal harness_counter1_BCIN7 : STD_LOGIC; -- AKA:harness/counter1/BCIN7
  signal harness_counter1_BCIN8 : STD_LOGIC; -- AKA:harness/counter1/BCIN8
  signal harness_counter1_BCIN9 : STD_LOGIC; -- AKA:harness/counter1/BCIN9
  signal harness_counter1_BCIN10 : STD_LOGIC; -- AKA:harness/counter1/BCIN10
  signal harness_counter1_BCIN11 : STD_LOGIC; -- AKA:harness/counter1/BCIN11
  signal harness_counter1_BCIN12 : STD_LOGIC; -- AKA:harness/counter1/BCIN12
  signal harness_counter1_BCIN13 : STD_LOGIC; -- AKA:harness/counter1/BCIN13
  signal harness_counter1_BCIN14 : STD_LOGIC; -- AKA:harness/counter1/BCIN14
  signal harness_counter1_BCIN15 : STD_LOGIC; -- AKA:harness/counter1/BCIN15
  signal harness_counter1_BCIN16 : STD_LOGIC; -- AKA:harness/counter1/BCIN16
  signal harness_counter1_BCIN17 : STD_LOGIC; -- AKA:harness/counter1/BCIN17
  signal harness_counter1_PCIN0 : STD_LOGIC; -- AKA:harness/counter1/PCIN0
  signal harness_counter1_PCIN1 : STD_LOGIC; -- AKA:harness/counter1/PCIN1
  signal harness_counter1_PCIN2 : STD_LOGIC; -- AKA:harness/counter1/PCIN2
  signal harness_counter1_PCIN3 : STD_LOGIC; -- AKA:harness/counter1/PCIN3
  signal harness_counter1_PCIN4 : STD_LOGIC; -- AKA:harness/counter1/PCIN4
  signal harness_counter1_PCIN5 : STD_LOGIC; -- AKA:harness/counter1/PCIN5
  signal harness_counter1_PCIN6 : STD_LOGIC; -- AKA:harness/counter1/PCIN6
  signal harness_counter1_PCIN7 : STD_LOGIC; -- AKA:harness/counter1/PCIN7
  signal harness_counter1_PCIN8 : STD_LOGIC; -- AKA:harness/counter1/PCIN8
  signal harness_counter1_PCIN9 : STD_LOGIC; -- AKA:harness/counter1/PCIN9
  signal harness_counter1_PCIN10 : STD_LOGIC; -- AKA:harness/counter1/PCIN10
  signal harness_counter1_PCIN11 : STD_LOGIC; -- AKA:harness/counter1/PCIN11
  signal harness_counter1_PCIN12 : STD_LOGIC; -- AKA:harness/counter1/PCIN12
  signal harness_counter1_PCIN13 : STD_LOGIC; -- AKA:harness/counter1/PCIN13
  signal harness_counter1_PCIN14 : STD_LOGIC; -- AKA:harness/counter1/PCIN14
  signal harness_counter1_PCIN15 : STD_LOGIC; -- AKA:harness/counter1/PCIN15
  signal harness_counter1_PCIN16 : STD_LOGIC; -- AKA:harness/counter1/PCIN16
  signal harness_counter1_PCIN17 : STD_LOGIC; -- AKA:harness/counter1/PCIN17
  signal harness_counter1_PCIN18 : STD_LOGIC; -- AKA:harness/counter1/PCIN18
  signal harness_counter1_PCIN19 : STD_LOGIC; -- AKA:harness/counter1/PCIN19
  signal harness_counter1_PCIN20 : STD_LOGIC; -- AKA:harness/counter1/PCIN20
  signal harness_counter1_PCIN21 : STD_LOGIC; -- AKA:harness/counter1/PCIN21
  signal harness_counter1_PCIN22 : STD_LOGIC; -- AKA:harness/counter1/PCIN22
  signal harness_counter1_PCIN23 : STD_LOGIC; -- AKA:harness/counter1/PCIN23
  signal harness_counter1_PCIN24 : STD_LOGIC; -- AKA:harness/counter1/PCIN24
  signal harness_counter1_PCIN25 : STD_LOGIC; -- AKA:harness/counter1/PCIN25
  signal harness_counter1_PCIN26 : STD_LOGIC; -- AKA:harness/counter1/PCIN26
  signal harness_counter1_PCIN27 : STD_LOGIC; -- AKA:harness/counter1/PCIN27
  signal harness_counter1_PCIN28 : STD_LOGIC; -- AKA:harness/counter1/PCIN28
  signal harness_counter1_PCIN29 : STD_LOGIC; -- AKA:harness/counter1/PCIN29
  signal harness_counter1_PCIN30 : STD_LOGIC; -- AKA:harness/counter1/PCIN30
  signal harness_counter1_PCIN31 : STD_LOGIC; -- AKA:harness/counter1/PCIN31
  signal harness_counter1_PCIN32 : STD_LOGIC; -- AKA:harness/counter1/PCIN32
  signal harness_counter1_PCIN33 : STD_LOGIC; -- AKA:harness/counter1/PCIN33
  signal harness_counter1_PCIN34 : STD_LOGIC; -- AKA:harness/counter1/PCIN34
  signal harness_counter1_PCIN35 : STD_LOGIC; -- AKA:harness/counter1/PCIN35
  signal harness_counter1_PCIN36 : STD_LOGIC; -- AKA:harness/counter1/PCIN36
  signal harness_counter1_PCIN37 : STD_LOGIC; -- AKA:harness/counter1/PCIN37
  signal harness_counter1_PCIN38 : STD_LOGIC; -- AKA:harness/counter1/PCIN38
  signal harness_counter1_PCIN39 : STD_LOGIC; -- AKA:harness/counter1/PCIN39
  signal harness_counter1_PCIN40 : STD_LOGIC; -- AKA:harness/counter1/PCIN40
  signal harness_counter1_PCIN41 : STD_LOGIC; -- AKA:harness/counter1/PCIN41
  signal harness_counter1_PCIN42 : STD_LOGIC; -- AKA:harness/counter1/PCIN42
  signal harness_counter1_PCIN43 : STD_LOGIC; -- AKA:harness/counter1/PCIN43
  signal harness_counter1_PCIN44 : STD_LOGIC; -- AKA:harness/counter1/PCIN44
  signal harness_counter1_PCIN45 : STD_LOGIC; -- AKA:harness/counter1/PCIN45
  signal harness_counter1_PCIN46 : STD_LOGIC; -- AKA:harness/counter1/PCIN46
  signal harness_counter1_PCIN47 : STD_LOGIC; -- AKA:harness/counter1/PCIN47
  signal harness_counter1_RSTP_INT : STD_LOGIC; -- AKA:harness/counter1/RSTP_INT
  signal harness_counter1_RSTA_INT : STD_LOGIC; -- AKA:harness/counter1/RSTA_INT
  signal harness_counter1_CEA_INT : STD_LOGIC; -- AKA:harness/counter1/CEA_INT
  signal harness_counter1_CEP_INT : STD_LOGIC; -- AKA:harness/counter1/CEP_INT
  signal harness_counter1_CEB_INT : STD_LOGIC; -- AKA:harness/counter1/CEB_INT
  signal harness_counter1_CEM_INT : STD_LOGIC; -- AKA:harness/counter1/CEM_INT
  signal harness_counter1_RSTB_INT : STD_LOGIC; -- AKA:harness/counter1/RSTB_INT
  signal harness_counter1_CLK_INT : STD_LOGIC; -- AKA:harness/counter1/CLK_INT
  signal harness_counter1_RSTM_INT : STD_LOGIC; -- AKA:harness/counter1/RSTM_INT
  signal harness_counter1_RSTOPMODE_INT : STD_LOGIC; -- AKA:harness/counter1/RSTOPMODE_INT
  signal harness_counter1_CEC_INT : STD_LOGIC; -- AKA:harness/counter1/CEC_INT
  signal harness_counter1_CEOPMODE_INT : STD_LOGIC; -- AKA:harness/counter1/CEOPMODE_INT
  signal harness_counter1_RSTD_INT : STD_LOGIC; -- AKA:harness/counter1/RSTD_INT
  signal harness_counter1_CED_INT : STD_LOGIC; -- AKA:harness/counter1/CED_INT
  signal harness_counter1_RSTCARRYIN_INT : STD_LOGIC; -- AKA:harness/counter1/RSTCARRYIN_INT
  signal harness_counter1_RSTC_INT : STD_LOGIC; -- AKA:harness/counter1/RSTC_INT
  signal harness_counter1_CECARRYIN_INT : STD_LOGIC; -- AKA:harness/counter1/CECARRYIN_INT
  signal NlwBufferSignal_BUFG_inst_IN : STD_LOGIC; -- AKA:NlwBufferSignal_BUFG_inst/IN
  signal NlwBufferSignal_BSCAN_inst_TDO : STD_LOGIC; -- AKA:NlwBufferSignal_BSCAN_inst/TDO
  signal NLW_harness_ram_Mram_state_machine_RSTBRST_UNCONNECTED : STD_LOGIC; -- AKA:NLW_harness/ram/Mram_state_machine_RSTBRST_UNCONNECTED
  signal NLW_harness_ram_Mram_state_machine_ENBRDEN_UNCONNECTED : STD_LOGIC; -- AKA:NLW_harness/ram/Mram_state_machine_ENBRDEN_UNCONNECTED
  signal NLW_harness_ram_Mram_state_machine_CLKBRDCLK_UNCONNECTED : STD_LOGIC; -- AKA:NLW_harness/ram/Mram_state_machine_CLKBRDCLK_UNCONNECTED
  signal NLW_harness_ram_Mram_state_machine_REGCEBREGCE_UNCONNECTED : STD_LOGIC; -- AKA:NLW_harness/ram/Mram_state_machine_REGCEBREGCE_UNCONNECTED
  signal NLW_harness_ram_Mram_state_machine_WEBWEU_1_UNCONNECTED : STD_LOGIC; -- AKA:NLW_harness/ram/Mram_state_machine_WEBWEU(1)_UNCONNECTED
  signal NLW_harness_ram_Mram_state_machine_WEBWEU_0_UNCONNECTED : STD_LOGIC; -- AKA:NLW_harness/ram/Mram_state_machine_WEBWEU(0)_UNCONNECTED
  signal GND : STD_LOGIC; 
  signal VCC : STD_LOGIC; 
  signal NLW_STARTUP_SPARTAN6_inst_CFGCLK_UNCONNECTED : STD_LOGIC; 
  signal NLW_STARTUP_SPARTAN6_inst_EOS_UNCONNECTED : STD_LOGIC; 
  signal NLW_BSCAN_inst_CAPTURE_UNCONNECTED : STD_LOGIC; 
  signal NLW_BSCAN_inst_DRCK_UNCONNECTED : STD_LOGIC; 
  signal NLW_BSCAN_inst_RESET_UNCONNECTED : STD_LOGIC; 
  signal NLW_BSCAN_inst_RUNTEST_UNCONNECTED : STD_LOGIC; 
  signal NLW_BSCAN_inst_SEL_UNCONNECTED : STD_LOGIC; 
  signal NLW_BSCAN_inst_SHIFT_UNCONNECTED : STD_LOGIC; 
  signal NLW_BSCAN_inst_TCK_UNCONNECTED : STD_LOGIC; 
  signal NLW_BSCAN_inst_TDI_UNCONNECTED : STD_LOGIC; 
  signal NLW_BSCAN_inst_TMS_UNCONNECTED : STD_LOGIC; 
  signal NLW_BSCAN_inst_UPDATE_UNCONNECTED : STD_LOGIC; 
  signal harness_counter : STD_LOGIC_VECTOR ( 13 downto 13 ); -- AKA:harness/counter
  signal harness_ram_dout : STD_LOGIC_VECTOR ( 5 downto 5 ); -- AKA:harness/ram/dout
  signal harness_state : STD_LOGIC_VECTOR ( 2 downto 0 ); -- AKA:harness/state
  signal NlwBufferSignal_harness_ram_Mram_state_machine_ADDRAWRADDR : STD_LOGIC_VECTOR ( 8 downto 3 ); -- AKA:NlwBufferSignal_harness/ram/Mram_state_machine/ADDRAWRADDR
begin
  harness_ram_Mram_state_machine_WEAWEL0INV : X_BUF -- AKA:harness/ram/Mram_state_machine/WEAWEL0INV
    generic map(
      LOC => "RAMB8_X3Y1",
      PATHPULSE => 115 ps
    )
    port map (
      I => '0',
      O => harness_ram_Mram_state_machine_WEAWEL0_INT
    );
  harness_ram_Mram_state_machine_WEAWEL1INV : X_BUF -- AKA:harness/ram/Mram_state_machine/WEAWEL1INV
    generic map(
      LOC => "RAMB8_X3Y1",
      PATHPULSE => 115 ps
    )
    port map (
      I => '0',
      O => harness_ram_Mram_state_machine_WEAWEL1_INT
    );
  harness_ram_Mram_state_machine_RSTAINV : X_BUF -- AKA:harness/ram/Mram_state_machine/RSTAINV
    generic map(
      LOC => "RAMB8_X3Y1",
      PATHPULSE => 115 ps
    )
    port map (
      I => '0',
      O => harness_ram_Mram_state_machine_RSTA_INT
    );
  harness_ram_Mram_state_machine_CLKAWRCLKINV : X_BUF -- AKA:harness/ram/Mram_state_machine/CLKAWRCLKINV
    generic map(
      LOC => "RAMB8_X3Y1",
      PATHPULSE => 115 ps
    )
    port map (
      I => iclk50MHz,
      O => harness_ram_Mram_state_machine_CLKAWRCLK_INT
    );
  harness_ram_Mram_state_machine_ENAWRENINV : X_BUF -- AKA:harness/ram/Mram_state_machine/ENAWRENINV
    generic map(
      LOC => "RAMB8_X3Y1",
      PATHPULSE => 115 ps
    )
    port map (
      I => '1',
      O => harness_ram_Mram_state_machine_ENAWREN_INT
    );
  harness_ram_Mram_state_machine_REGCEAINV : X_BUF -- AKA:harness/ram/Mram_state_machine/REGCEAINV
    generic map(
      LOC => "RAMB8_X3Y1",
      PATHPULSE => 115 ps
    )
    port map (
      I => '0',
      O => harness_ram_Mram_state_machine_REGCEA_INT
    );
  harness_ram_Mram_state_machine : X_RAMB8BWER -- AKA:harness/ram/Mram_state_machine
    generic map(
      DATA_WIDTH_A => 9,
      DATA_WIDTH_B => 0,
      DOA_REG => 0,
      DOB_REG => 0,
      EN_RSTRAM_A => TRUE,
      EN_RSTRAM_B => TRUE,
      RAM_MODE => "TDP",
      RST_PRIORITY_A => "CE",
      RST_PRIORITY_B => "CE",
      RSTTYPE => "SYNC",
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      SIM_COLLISION_CHECK => "ALL",
      INITP_00 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_01 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_02 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_03 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_00 => X"27272727020202020101010107070707070707071F1712120706010105050505",
      INIT_01 => X"2F2F2F2F07070707070707070707070707070707070707070707070707070707",
      INIT_02 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_03 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_04 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_05 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_06 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_07 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_08 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_09 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0A => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0B => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0C => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0E => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0F => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_10 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_11 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_12 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_13 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_14 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_15 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_16 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_17 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_18 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_19 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1A => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1B => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1C => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1E => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1F => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_A => X"00000",
      INIT_B => X"00000",
      SRVAL_A => X"00000",
      SRVAL_B => X"00000",
      LOC => "RAMB8_X3Y1"
    )
    port map (
      RSTBRST => NLW_harness_ram_Mram_state_machine_RSTBRST_UNCONNECTED,
      ENBRDEN => NLW_harness_ram_Mram_state_machine_ENBRDEN_UNCONNECTED,
      REGCEA => harness_ram_Mram_state_machine_REGCEA_INT,
      ENAWREN => harness_ram_Mram_state_machine_ENAWREN_INT,
      CLKAWRCLK => harness_ram_Mram_state_machine_CLKAWRCLK_INT,
      CLKBRDCLK => NLW_harness_ram_Mram_state_machine_CLKBRDCLK_UNCONNECTED,
      REGCEBREGCE => NLW_harness_ram_Mram_state_machine_REGCEBREGCE_UNCONNECTED,
      RSTA => harness_ram_Mram_state_machine_RSTA_INT,
      WEAWEL(1) => harness_ram_Mram_state_machine_WEAWEL1_INT,
      WEAWEL(0) => harness_ram_Mram_state_machine_WEAWEL0_INT,
      WEBWEU(1) => NLW_harness_ram_Mram_state_machine_WEBWEU_1_UNCONNECTED,
      WEBWEU(0) => NLW_harness_ram_Mram_state_machine_WEBWEU_0_UNCONNECTED,
      ADDRAWRADDR(12) => GND,
      ADDRAWRADDR(11) => GND,
      ADDRAWRADDR(10) => GND,
      ADDRAWRADDR(9) => GND,
      ADDRAWRADDR(8) => NlwBufferSignal_harness_ram_Mram_state_machine_ADDRAWRADDR(8),
      ADDRAWRADDR(7) => NlwBufferSignal_harness_ram_Mram_state_machine_ADDRAWRADDR(7),
      ADDRAWRADDR(6) => NlwBufferSignal_harness_ram_Mram_state_machine_ADDRAWRADDR(6),
      ADDRAWRADDR(5) => NlwBufferSignal_harness_ram_Mram_state_machine_ADDRAWRADDR(5),
      ADDRAWRADDR(4) => NlwBufferSignal_harness_ram_Mram_state_machine_ADDRAWRADDR(4),
      ADDRAWRADDR(3) => NlwBufferSignal_harness_ram_Mram_state_machine_ADDRAWRADDR(3),
      ADDRAWRADDR(2) => harness_ram_Mram_state_machine_ADDRAWRADDR2,
      ADDRAWRADDR(1) => harness_ram_Mram_state_machine_ADDRAWRADDR1,
      ADDRAWRADDR(0) => harness_ram_Mram_state_machine_ADDRAWRADDR0,
      DIPBDIP(1) => harness_ram_Mram_state_machine_DIPBDIP1,
      DIPBDIP(0) => harness_ram_Mram_state_machine_DIPBDIP0,
      DIBDI(15) => harness_ram_Mram_state_machine_DIBDI15,
      DIBDI(14) => harness_ram_Mram_state_machine_DIBDI14,
      DIBDI(13) => harness_ram_Mram_state_machine_DIBDI13,
      DIBDI(12) => harness_ram_Mram_state_machine_DIBDI12,
      DIBDI(11) => harness_ram_Mram_state_machine_DIBDI11,
      DIBDI(10) => harness_ram_Mram_state_machine_DIBDI10,
      DIBDI(9) => harness_ram_Mram_state_machine_DIBDI9,
      DIBDI(8) => harness_ram_Mram_state_machine_DIBDI8,
      DIBDI(7) => harness_ram_Mram_state_machine_DIBDI7,
      DIBDI(6) => harness_ram_Mram_state_machine_DIBDI6,
      DIBDI(5) => harness_ram_Mram_state_machine_DIBDI5,
      DIBDI(4) => harness_ram_Mram_state_machine_DIBDI4,
      DIBDI(3) => harness_ram_Mram_state_machine_DIBDI3,
      DIBDI(2) => harness_ram_Mram_state_machine_DIBDI2,
      DIBDI(1) => harness_ram_Mram_state_machine_DIBDI1,
      DIBDI(0) => harness_ram_Mram_state_machine_DIBDI0,
      DIADI(15) => harness_ram_Mram_state_machine_DIADI15,
      DIADI(14) => harness_ram_Mram_state_machine_DIADI14,
      DIADI(13) => harness_ram_Mram_state_machine_DIADI13,
      DIADI(12) => harness_ram_Mram_state_machine_DIADI12,
      DIADI(11) => harness_ram_Mram_state_machine_DIADI11,
      DIADI(10) => harness_ram_Mram_state_machine_DIADI10,
      DIADI(9) => harness_ram_Mram_state_machine_DIADI9,
      DIADI(8) => harness_ram_Mram_state_machine_DIADI8,
      DIADI(7) => GND,
      DIADI(6) => GND,
      DIADI(5) => GND,
      DIADI(4) => GND,
      DIADI(3) => GND,
      DIADI(2) => GND,
      DIADI(1) => GND,
      DIADI(0) => GND,
      ADDRBRDADDR(12) => harness_ram_Mram_state_machine_ADDRBRDADDR12,
      ADDRBRDADDR(11) => harness_ram_Mram_state_machine_ADDRBRDADDR11,
      ADDRBRDADDR(10) => harness_ram_Mram_state_machine_ADDRBRDADDR10,
      ADDRBRDADDR(9) => harness_ram_Mram_state_machine_ADDRBRDADDR9,
      ADDRBRDADDR(8) => harness_ram_Mram_state_machine_ADDRBRDADDR8,
      ADDRBRDADDR(7) => harness_ram_Mram_state_machine_ADDRBRDADDR7,
      ADDRBRDADDR(6) => harness_ram_Mram_state_machine_ADDRBRDADDR6,
      ADDRBRDADDR(5) => harness_ram_Mram_state_machine_ADDRBRDADDR5,
      ADDRBRDADDR(4) => harness_ram_Mram_state_machine_ADDRBRDADDR4,
      ADDRBRDADDR(3) => harness_ram_Mram_state_machine_ADDRBRDADDR3,
      ADDRBRDADDR(2) => harness_ram_Mram_state_machine_ADDRBRDADDR2,
      ADDRBRDADDR(1) => harness_ram_Mram_state_machine_ADDRBRDADDR1,
      ADDRBRDADDR(0) => harness_ram_Mram_state_machine_ADDRBRDADDR0,
      DIPADIP(1) => harness_ram_Mram_state_machine_DIPADIP1,
      DIPADIP(0) => GND,
      DOADO(15) => harness_ram_Mram_state_machine_DOADO15,
      DOADO(14) => harness_ram_Mram_state_machine_DOADO14,
      DOADO(13) => harness_ram_Mram_state_machine_DOADO13,
      DOADO(12) => harness_ram_Mram_state_machine_DOADO12,
      DOADO(11) => harness_ram_Mram_state_machine_DOADO11,
      DOADO(10) => harness_ram_Mram_state_machine_DOADO10,
      DOADO(9) => harness_ram_Mram_state_machine_DOADO9,
      DOADO(8) => harness_ram_Mram_state_machine_DOADO8,
      DOADO(7) => harness_ram_Mram_state_machine_DOADO7,
      DOADO(6) => harness_ram_Mram_state_machine_DOADO6,
      DOADO(5) => harness_ram_dout(5),
      DOADO(4) => driver_net,
      DOADO(3) => pass,
      DOADO(2) => harness_state(2),
      DOADO(1) => harness_state(1),
      DOADO(0) => harness_state(0),
      DOPADOP(1) => harness_ram_Mram_state_machine_DOPADOP1,
      DOPADOP(0) => harness_ram_Mram_state_machine_DOPADOP0,
      DOPBDOP(1) => harness_ram_Mram_state_machine_DOPBDOP1,
      DOPBDOP(0) => harness_ram_Mram_state_machine_DOPBDOP0,
      DOBDO(15) => harness_ram_Mram_state_machine_DOBDO15,
      DOBDO(14) => harness_ram_Mram_state_machine_DOBDO14,
      DOBDO(13) => harness_ram_Mram_state_machine_DOBDO13,
      DOBDO(12) => harness_ram_Mram_state_machine_DOBDO12,
      DOBDO(11) => harness_ram_Mram_state_machine_DOBDO11,
      DOBDO(10) => harness_ram_Mram_state_machine_DOBDO10,
      DOBDO(9) => harness_ram_Mram_state_machine_DOBDO9,
      DOBDO(8) => harness_ram_Mram_state_machine_DOBDO8,
      DOBDO(7) => harness_ram_Mram_state_machine_DOBDO7,
      DOBDO(6) => harness_ram_Mram_state_machine_DOBDO6,
      DOBDO(5) => harness_ram_Mram_state_machine_DOBDO5,
      DOBDO(4) => harness_ram_Mram_state_machine_DOBDO4,
      DOBDO(3) => harness_ram_Mram_state_machine_DOBDO3,
      DOBDO(2) => harness_ram_Mram_state_machine_DOBDO2,
      DOBDO(1) => harness_ram_Mram_state_machine_DOBDO1,
      DOBDO(0) => harness_ram_Mram_state_machine_DOBDO0
    );
  BUFG_inst : X_CKBUF
    generic map(
      LOC => "BUFGMUX_X2Y3",
      PATHPULSE => 115 ps
    )
    port map (
      I => NlwBufferSignal_BUFG_inst_IN,
      O => iclk50MHz
    );
  harness_counter1_RSTPINV : X_BUF -- AKA:harness/counter1/RSTPINV
    generic map(
      LOC => "DSP48_X1Y1",
      PATHPULSE => 115 ps
    )
    port map (
      I => harness_state(2),
      O => harness_counter1_RSTP_INT
    );
  harness_counter1_RSTAINV : X_BUF -- AKA:harness/counter1/RSTAINV
    generic map(
      LOC => "DSP48_X1Y1",
      PATHPULSE => 115 ps
    )
    port map (
      I => GND,
      O => harness_counter1_RSTA_INT
    );
  harness_counter1_CEAINV : X_BUF -- AKA:harness/counter1/CEAINV
    generic map(
      LOC => "DSP48_X1Y1",
      PATHPULSE => 115 ps
    )
    port map (
      I => '0',
      O => harness_counter1_CEA_INT
    );
  harness_counter1_CEPINV : X_BUF -- AKA:harness/counter1/CEPINV
    generic map(
      LOC => "DSP48_X1Y1",
      PATHPULSE => 115 ps
    )
    port map (
      I => '1',
      O => harness_counter1_CEP_INT
    );
  harness_counter1_CEBINV : X_BUF -- AKA:harness/counter1/CEBINV
    generic map(
      LOC => "DSP48_X1Y1",
      PATHPULSE => 115 ps
    )
    port map (
      I => '0',
      O => harness_counter1_CEB_INT
    );
  harness_counter1_CEMINV : X_BUF -- AKA:harness/counter1/CEMINV
    generic map(
      LOC => "DSP48_X1Y1",
      PATHPULSE => 115 ps
    )
    port map (
      I => '0',
      O => harness_counter1_CEM_INT
    );
  harness_counter1_RSTBINV : X_BUF -- AKA:harness/counter1/RSTBINV
    generic map(
      LOC => "DSP48_X1Y1",
      PATHPULSE => 115 ps
    )
    port map (
      I => GND,
      O => harness_counter1_RSTB_INT
    );
  harness_counter1_CLKINV : X_BUF -- AKA:harness/counter1/CLKINV
    generic map(
      LOC => "DSP48_X1Y1",
      PATHPULSE => 115 ps
    )
    port map (
      I => iclk50MHz,
      O => harness_counter1_CLK_INT
    );
  harness_counter1_RSTMINV : X_BUF -- AKA:harness/counter1/RSTMINV
    generic map(
      LOC => "DSP48_X1Y1",
      PATHPULSE => 115 ps
    )
    port map (
      I => GND,
      O => harness_counter1_RSTM_INT
    );
  harness_counter1_RSTOPMODEINV : X_BUF -- AKA:harness/counter1/RSTOPMODEINV
    generic map(
      LOC => "DSP48_X1Y1",
      PATHPULSE => 115 ps
    )
    port map (
      I => GND,
      O => harness_counter1_RSTOPMODE_INT
    );
  harness_counter1_CECINV : X_BUF -- AKA:harness/counter1/CECINV
    generic map(
      LOC => "DSP48_X1Y1",
      PATHPULSE => 115 ps
    )
    port map (
      I => '0',
      O => harness_counter1_CEC_INT
    );
  harness_counter1_CEOPMODEINV : X_BUF -- AKA:harness/counter1/CEOPMODEINV
    generic map(
      LOC => "DSP48_X1Y1",
      PATHPULSE => 115 ps
    )
    port map (
      I => '0',
      O => harness_counter1_CEOPMODE_INT
    );
  harness_counter1_RSTDINV : X_BUF -- AKA:harness/counter1/RSTDINV
    generic map(
      LOC => "DSP48_X1Y1",
      PATHPULSE => 115 ps
    )
    port map (
      I => GND,
      O => harness_counter1_RSTD_INT
    );
  harness_counter1_CEDINV : X_BUF -- AKA:harness/counter1/CEDINV
    generic map(
      LOC => "DSP48_X1Y1",
      PATHPULSE => 115 ps
    )
    port map (
      I => '0',
      O => harness_counter1_CED_INT
    );
  harness_counter1_RSTCARRYININV : X_BUF -- AKA:harness/counter1/RSTCARRYININV
    generic map(
      LOC => "DSP48_X1Y1",
      PATHPULSE => 115 ps
    )
    port map (
      I => GND,
      O => harness_counter1_RSTCARRYIN_INT
    );
  harness_counter1_RSTCINV : X_BUF -- AKA:harness/counter1/RSTCINV
    generic map(
      LOC => "DSP48_X1Y1",
      PATHPULSE => 115 ps
    )
    port map (
      I => GND,
      O => harness_counter1_RSTC_INT
    );
  harness_counter1_CECARRYININV : X_BUF -- AKA:harness/counter1/CECARRYININV
    generic map(
      LOC => "DSP48_X1Y1",
      PATHPULSE => 115 ps
    )
    port map (
      I => '0',
      O => harness_counter1_CECARRYIN_INT
    );
  harness_counter1 : X_DSP48A1 -- AKA:harness/counter1
    generic map(
      A0REG => 0,
      A1REG => 0,
      B0REG => 0,
      B1REG => 0,
      CREG => 0,
      DREG => 0,
      MREG => 0,
      OPMODEREG => 0,
      PREG => 1,
      CARRYINREG => 0,
      CARRYOUTREG => 0,
      B_INPUT => "DIRECT",
      CARRYINSEL => "OPMODE5",
      RSTTYPE => "SYNC",
      LOC => "DSP48_X1Y1"
    )
    port map (
      CECARRYIN => harness_counter1_CECARRYIN_INT,
      RSTC => harness_counter1_RSTC_INT,
      RSTCARRYIN => harness_counter1_RSTCARRYIN_INT,
      CED => harness_counter1_CED_INT,
      RSTD => harness_counter1_RSTD_INT,
      CEOPMODE => harness_counter1_CEOPMODE_INT,
      CEC => harness_counter1_CEC_INT,
      RSTOPMODE => harness_counter1_RSTOPMODE_INT,
      RSTM => harness_counter1_RSTM_INT,
      CLK => harness_counter1_CLK_INT,
      RSTB => harness_counter1_RSTB_INT,
      CEM => harness_counter1_CEM_INT,
      CEB => harness_counter1_CEB_INT,
      CARRYIN => GND,
      CEP => harness_counter1_CEP_INT,
      CEA => harness_counter1_CEA_INT,
      RSTA => harness_counter1_RSTA_INT,
      RSTP => harness_counter1_RSTP_INT,
      CARRYOUTF => harness_counter1_CARRYOUTF,
      CARRYOUT => harness_counter1_CARRYOUT,
      B(17) => GND,
      B(16) => GND,
      B(15) => GND,
      B(14) => GND,
      B(13) => GND,
      B(12) => GND,
      B(11) => GND,
      B(10) => GND,
      B(9) => GND,
      B(8) => GND,
      B(7) => GND,
      B(6) => GND,
      B(5) => GND,
      B(4) => GND,
      B(3) => GND,
      B(2) => GND,
      B(1) => GND,
      B(0) => GND,
      PCIN(47) => harness_counter1_PCIN47,
      PCIN(46) => harness_counter1_PCIN46,
      PCIN(45) => harness_counter1_PCIN45,
      PCIN(44) => harness_counter1_PCIN44,
      PCIN(43) => harness_counter1_PCIN43,
      PCIN(42) => harness_counter1_PCIN42,
      PCIN(41) => harness_counter1_PCIN41,
      PCIN(40) => harness_counter1_PCIN40,
      PCIN(39) => harness_counter1_PCIN39,
      PCIN(38) => harness_counter1_PCIN38,
      PCIN(37) => harness_counter1_PCIN37,
      PCIN(36) => harness_counter1_PCIN36,
      PCIN(35) => harness_counter1_PCIN35,
      PCIN(34) => harness_counter1_PCIN34,
      PCIN(33) => harness_counter1_PCIN33,
      PCIN(32) => harness_counter1_PCIN32,
      PCIN(31) => harness_counter1_PCIN31,
      PCIN(30) => harness_counter1_PCIN30,
      PCIN(29) => harness_counter1_PCIN29,
      PCIN(28) => harness_counter1_PCIN28,
      PCIN(27) => harness_counter1_PCIN27,
      PCIN(26) => harness_counter1_PCIN26,
      PCIN(25) => harness_counter1_PCIN25,
      PCIN(24) => harness_counter1_PCIN24,
      PCIN(23) => harness_counter1_PCIN23,
      PCIN(22) => harness_counter1_PCIN22,
      PCIN(21) => harness_counter1_PCIN21,
      PCIN(20) => harness_counter1_PCIN20,
      PCIN(19) => harness_counter1_PCIN19,
      PCIN(18) => harness_counter1_PCIN18,
      PCIN(17) => harness_counter1_PCIN17,
      PCIN(16) => harness_counter1_PCIN16,
      PCIN(15) => harness_counter1_PCIN15,
      PCIN(14) => harness_counter1_PCIN14,
      PCIN(13) => harness_counter1_PCIN13,
      PCIN(12) => harness_counter1_PCIN12,
      PCIN(11) => harness_counter1_PCIN11,
      PCIN(10) => harness_counter1_PCIN10,
      PCIN(9) => harness_counter1_PCIN9,
      PCIN(8) => harness_counter1_PCIN8,
      PCIN(7) => harness_counter1_PCIN7,
      PCIN(6) => harness_counter1_PCIN6,
      PCIN(5) => harness_counter1_PCIN5,
      PCIN(4) => harness_counter1_PCIN4,
      PCIN(3) => harness_counter1_PCIN3,
      PCIN(2) => harness_counter1_PCIN2,
      PCIN(1) => harness_counter1_PCIN1,
      PCIN(0) => harness_counter1_PCIN0,
      C(47) => GND,
      C(46) => GND,
      C(45) => GND,
      C(44) => GND,
      C(43) => GND,
      C(42) => GND,
      C(41) => GND,
      C(40) => GND,
      C(39) => GND,
      C(38) => GND,
      C(37) => GND,
      C(36) => GND,
      C(35) => GND,
      C(34) => GND,
      C(33) => GND,
      C(32) => GND,
      C(31) => GND,
      C(30) => GND,
      C(29) => GND,
      C(28) => GND,
      C(27) => GND,
      C(26) => GND,
      C(25) => GND,
      C(24) => GND,
      C(23) => GND,
      C(22) => GND,
      C(21) => GND,
      C(20) => GND,
      C(19) => GND,
      C(18) => GND,
      C(17) => GND,
      C(16) => GND,
      C(15) => GND,
      C(14) => GND,
      C(13) => GND,
      C(12) => GND,
      C(11) => GND,
      C(10) => GND,
      C(9) => GND,
      C(8) => GND,
      C(7) => GND,
      C(6) => GND,
      C(5) => GND,
      C(4) => GND,
      C(3) => GND,
      C(2) => GND,
      C(1) => GND,
      C(0) => VCC,
      OPMODE(7) => GND,
      OPMODE(6) => GND,
      OPMODE(5) => GND,
      OPMODE(4) => GND,
      OPMODE(3) => VCC,
      OPMODE(2) => VCC,
      OPMODE(1) => VCC,
      OPMODE(0) => GND,
      D(17) => GND,
      D(16) => GND,
      D(15) => GND,
      D(14) => GND,
      D(13) => GND,
      D(12) => GND,
      D(11) => GND,
      D(10) => GND,
      D(9) => GND,
      D(8) => GND,
      D(7) => GND,
      D(6) => GND,
      D(5) => GND,
      D(4) => GND,
      D(3) => GND,
      D(2) => GND,
      D(1) => GND,
      D(0) => GND,
      A(17) => GND,
      A(16) => GND,
      A(15) => GND,
      A(14) => GND,
      A(13) => GND,
      A(12) => GND,
      A(11) => GND,
      A(10) => GND,
      A(9) => GND,
      A(8) => GND,
      A(7) => GND,
      A(6) => GND,
      A(5) => GND,
      A(4) => GND,
      A(3) => GND,
      A(2) => GND,
      A(1) => GND,
      A(0) => GND,
      BCIN(17) => harness_counter1_BCIN17,
      BCIN(16) => harness_counter1_BCIN16,
      BCIN(15) => harness_counter1_BCIN15,
      BCIN(14) => harness_counter1_BCIN14,
      BCIN(13) => harness_counter1_BCIN13,
      BCIN(12) => harness_counter1_BCIN12,
      BCIN(11) => harness_counter1_BCIN11,
      BCIN(10) => harness_counter1_BCIN10,
      BCIN(9) => harness_counter1_BCIN9,
      BCIN(8) => harness_counter1_BCIN8,
      BCIN(7) => harness_counter1_BCIN7,
      BCIN(6) => harness_counter1_BCIN6,
      BCIN(5) => harness_counter1_BCIN5,
      BCIN(4) => harness_counter1_BCIN4,
      BCIN(3) => harness_counter1_BCIN3,
      BCIN(2) => harness_counter1_BCIN2,
      BCIN(1) => harness_counter1_BCIN1,
      BCIN(0) => harness_counter1_BCIN0,
      BCOUT(17) => harness_counter1_BCOUT17,
      BCOUT(16) => harness_counter1_BCOUT16,
      BCOUT(15) => harness_counter1_BCOUT15,
      BCOUT(14) => harness_counter1_BCOUT14,
      BCOUT(13) => harness_counter1_BCOUT13,
      BCOUT(12) => harness_counter1_BCOUT12,
      BCOUT(11) => harness_counter1_BCOUT11,
      BCOUT(10) => harness_counter1_BCOUT10,
      BCOUT(9) => harness_counter1_BCOUT9,
      BCOUT(8) => harness_counter1_BCOUT8,
      BCOUT(7) => harness_counter1_BCOUT7,
      BCOUT(6) => harness_counter1_BCOUT6,
      BCOUT(5) => harness_counter1_BCOUT5,
      BCOUT(4) => harness_counter1_BCOUT4,
      BCOUT(3) => harness_counter1_BCOUT3,
      BCOUT(2) => harness_counter1_BCOUT2,
      BCOUT(1) => harness_counter1_BCOUT1,
      BCOUT(0) => harness_counter1_BCOUT0,
      P(47) => harness_counter1_P47,
      P(46) => harness_counter1_P46,
      P(45) => harness_counter1_P45,
      P(44) => harness_counter1_P44,
      P(43) => harness_counter1_P43,
      P(42) => harness_counter1_P42,
      P(41) => harness_counter1_P41,
      P(40) => harness_counter1_P40,
      P(39) => harness_counter1_P39,
      P(38) => harness_counter1_P38,
      P(37) => harness_counter1_P37,
      P(36) => harness_counter1_P36,
      P(35) => harness_counter1_P35,
      P(34) => harness_counter1_P34,
      P(33) => harness_counter1_P33,
      P(32) => harness_counter1_P32,
      P(31) => harness_counter1_P31,
      P(30) => harness_counter1_P30,
      P(29) => harness_counter1_P29,
      P(28) => harness_counter1_P28,
      P(27) => harness_counter1_P27,
      P(26) => harness_counter1_P26,
      P(25) => harness_counter1_P25,
      P(24) => harness_counter1_P24,
      P(23) => harness_counter1_P23,
      P(22) => harness_counter1_P22,
      P(21) => harness_counter1_P21,
      P(20) => harness_counter1_P20,
      P(19) => harness_counter1_P19,
      P(18) => harness_counter1_P18,
      P(17) => harness_counter1_P17,
      P(16) => harness_counter1_P16,
      P(15) => harness_counter1_P15,
      P(14) => harness_counter1_P14,
      P(13) => harness_counter(13),
      P(12) => harness_counter1_P12,
      P(11) => harness_counter1_P11,
      P(10) => harness_counter1_P10,
      P(9) => harness_counter1_P9,
      P(8) => harness_counter1_P8,
      P(7) => harness_counter1_P7,
      P(6) => harness_counter1_P6,
      P(5) => harness_counter1_P5,
      P(4) => harness_counter1_P4,
      P(3) => harness_counter1_P3,
      P(2) => harness_counter1_P2,
      P(1) => harness_counter1_P1,
      P(0) => harness_counter1_P0,
      PCOUT(47) => harness_counter1_PCOUT47,
      PCOUT(46) => harness_counter1_PCOUT46,
      PCOUT(45) => harness_counter1_PCOUT45,
      PCOUT(44) => harness_counter1_PCOUT44,
      PCOUT(43) => harness_counter1_PCOUT43,
      PCOUT(42) => harness_counter1_PCOUT42,
      PCOUT(41) => harness_counter1_PCOUT41,
      PCOUT(40) => harness_counter1_PCOUT40,
      PCOUT(39) => harness_counter1_PCOUT39,
      PCOUT(38) => harness_counter1_PCOUT38,
      PCOUT(37) => harness_counter1_PCOUT37,
      PCOUT(36) => harness_counter1_PCOUT36,
      PCOUT(35) => harness_counter1_PCOUT35,
      PCOUT(34) => harness_counter1_PCOUT34,
      PCOUT(33) => harness_counter1_PCOUT33,
      PCOUT(32) => harness_counter1_PCOUT32,
      PCOUT(31) => harness_counter1_PCOUT31,
      PCOUT(30) => harness_counter1_PCOUT30,
      PCOUT(29) => harness_counter1_PCOUT29,
      PCOUT(28) => harness_counter1_PCOUT28,
      PCOUT(27) => harness_counter1_PCOUT27,
      PCOUT(26) => harness_counter1_PCOUT26,
      PCOUT(25) => harness_counter1_PCOUT25,
      PCOUT(24) => harness_counter1_PCOUT24,
      PCOUT(23) => harness_counter1_PCOUT23,
      PCOUT(22) => harness_counter1_PCOUT22,
      PCOUT(21) => harness_counter1_PCOUT21,
      PCOUT(20) => harness_counter1_PCOUT20,
      PCOUT(19) => harness_counter1_PCOUT19,
      PCOUT(18) => harness_counter1_PCOUT18,
      PCOUT(17) => harness_counter1_PCOUT17,
      PCOUT(16) => harness_counter1_PCOUT16,
      PCOUT(15) => harness_counter1_PCOUT15,
      PCOUT(14) => harness_counter1_PCOUT14,
      PCOUT(13) => harness_counter1_PCOUT13,
      PCOUT(12) => harness_counter1_PCOUT12,
      PCOUT(11) => harness_counter1_PCOUT11,
      PCOUT(10) => harness_counter1_PCOUT10,
      PCOUT(9) => harness_counter1_PCOUT9,
      PCOUT(8) => harness_counter1_PCOUT8,
      PCOUT(7) => harness_counter1_PCOUT7,
      PCOUT(6) => harness_counter1_PCOUT6,
      PCOUT(5) => harness_counter1_PCOUT5,
      PCOUT(4) => harness_counter1_PCOUT4,
      PCOUT(3) => harness_counter1_PCOUT3,
      PCOUT(2) => harness_counter1_PCOUT2,
      PCOUT(1) => harness_counter1_PCOUT1,
      PCOUT(0) => harness_counter1_PCOUT0,
      M(35) => harness_counter1_M35,
      M(34) => harness_counter1_M34,
      M(33) => harness_counter1_M33,
      M(32) => harness_counter1_M32,
      M(31) => harness_counter1_M31,
      M(30) => harness_counter1_M30,
      M(29) => harness_counter1_M29,
      M(28) => harness_counter1_M28,
      M(27) => harness_counter1_M27,
      M(26) => harness_counter1_M26,
      M(25) => harness_counter1_M25,
      M(24) => harness_counter1_M24,
      M(23) => harness_counter1_M23,
      M(22) => harness_counter1_M22,
      M(21) => harness_counter1_M21,
      M(20) => harness_counter1_M20,
      M(19) => harness_counter1_M19,
      M(18) => harness_counter1_M18,
      M(17) => harness_counter1_M17,
      M(16) => harness_counter1_M16,
      M(15) => harness_counter1_M15,
      M(14) => harness_counter1_M14,
      M(13) => harness_counter1_M13,
      M(12) => harness_counter1_M12,
      M(11) => harness_counter1_M11,
      M(10) => harness_counter1_M10,
      M(9) => harness_counter1_M9,
      M(8) => harness_counter1_M8,
      M(7) => harness_counter1_M7,
      M(6) => harness_counter1_M6,
      M(5) => harness_counter1_M5,
      M(4) => harness_counter1_M4,
      M(3) => harness_counter1_M3,
      M(2) => harness_counter1_M2,
      M(1) => harness_counter1_M1,
      M(0) => harness_counter1_M0
    );
  STARTUP_SPARTAN6_inst : X_STARTUP_SPARTAN6
    port map (
      CFGCLK => NLW_STARTUP_SPARTAN6_inst_CFGCLK_UNCONNECTED,
      CFGMCLK => clk,
      CLK => '0',
      EOS => NLW_STARTUP_SPARTAN6_inst_EOS_UNCONNECTED,
      GSR => '0',
      GTS => '0',
      KEYCLEARB => '0'
    );
  BSCAN_inst : X_BSCAN_SPARTAN6
    port map (
      CAPTURE => NLW_BSCAN_inst_CAPTURE_UNCONNECTED,
      DRCK => NLW_BSCAN_inst_DRCK_UNCONNECTED,
      RESET => NLW_BSCAN_inst_RESET_UNCONNECTED,
      RUNTEST => NLW_BSCAN_inst_RUNTEST_UNCONNECTED,
      SEL => NLW_BSCAN_inst_SEL_UNCONNECTED,
      SHIFT => NLW_BSCAN_inst_SHIFT_UNCONNECTED,
      TCK => NLW_BSCAN_inst_TCK_UNCONNECTED,
      TDI => NLW_BSCAN_inst_TDI_UNCONNECTED,
      TDO => NlwBufferSignal_BSCAN_inst_TDO,
      TMS => NLW_BSCAN_inst_TMS_UNCONNECTED,
      UPDATE => NLW_BSCAN_inst_UPDATE_UNCONNECTED
    );
  SLICE_X43Y24_C6LUT : X_LUT6
    generic map(
      LOC => "SLICE_X43Y24",
      INIT => X"FF00FF00FF00FF00"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => ift_int_test_SLICE_X35Y23B_to_SLICE_X43Y24C,
      ADR4 => '1',
      ADR5 => '1',
      O => ift_int_test_SLICE_X43Y24C_to_SLICE_X29Y22B
    );
  SLICE_X47Y24_C6LUT : X_LUT6
    generic map(
      LOC => "SLICE_X47Y24",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => ift_int_test_SLICE_X31Y23C_to_SLICE_X47Y24C,
      ADR5 => '1',
      O => ift_int_test_SLICE_X47Y24C_to_SLICE_X31Y22B
    );
  SLICE_X31Y23_C6LUT : X_LUT6
    generic map(
      LOC => "SLICE_X31Y23",
      INIT => X"FFFFFFFF00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      ADR5 => ift_int_test_SLICE_X41Y23C_to_SLICE_X31Y23C,
      O => ift_int_test_SLICE_X31Y23C_to_SLICE_X47Y24C
    );
  SLICE_X33Y23_D6LUT : X_LUT6
    generic map(
      LOC => "SLICE_X33Y23",
      INIT => X"FFFFFFFF00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      ADR5 => ift_int_test_SLICE_X43Y20C_to_SLICE_X33Y23D,
      O => ift_int_test_SLICE_X33Y23D_to_SLICE_X41Y23C
    );
  SLICE_X35Y23_B6LUT : X_LUT6
    generic map(
      LOC => "SLICE_X35Y23",
      INIT => X"FFFFFFFF00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      ADR5 => ift_int_test_SLICE_X47Y23C_to_SLICE_X35Y23B,
      O => ift_int_test_SLICE_X35Y23B_to_SLICE_X43Y24C
    );
  SLICE_X41Y23_C6LUT : X_LUT6
    generic map(
      LOC => "SLICE_X41Y23",
      INIT => X"FFFFFFFF00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      ADR5 => ift_int_test_SLICE_X33Y23D_to_SLICE_X41Y23C,
      O => ift_int_test_SLICE_X41Y23C_to_SLICE_X31Y23C
    );
  SLICE_X45Y23_C6LUT : X_LUT6
    generic map(
      LOC => "SLICE_X45Y23",
      INIT => X"FF00FF00FF00FF00"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => ift_int_test_SLICE_X29Y22B_to_SLICE_X45Y23C,
      ADR4 => '1',
      ADR5 => '1',
      O => result_net
    );
  SLICE_X47Y23_C6LUT : X_LUT6
    generic map(
      LOC => "SLICE_X47Y23",
      INIT => X"FF00FF00FF00FF00"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => ift_int_test_SLICE_X31Y22B_to_SLICE_X47Y23C,
      ADR4 => '1',
      ADR5 => '1',
      O => ift_int_test_SLICE_X47Y23C_to_SLICE_X35Y23B
    );
  SLICE_X29Y22_B6LUT : X_LUT6
    generic map(
      LOC => "SLICE_X29Y22",
      INIT => X"FFFFFFFF00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      ADR5 => ift_int_test_SLICE_X43Y24C_to_SLICE_X29Y22B,
      O => ift_int_test_SLICE_X29Y22B_to_SLICE_X45Y23C
    );
  SLICE_X31Y22_B6LUT : X_LUT6
    generic map(
      LOC => "SLICE_X31Y22",
      INIT => X"FFFFFFFF00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      ADR5 => ift_int_test_SLICE_X47Y24C_to_SLICE_X31Y22B,
      O => ift_int_test_SLICE_X31Y22B_to_SLICE_X47Y23C
    );
  SLICE_X41Y22_C6LUT : X_LUT6
    generic map(
      LOC => "SLICE_X41Y22",
      INIT => X"FF00FF00FF00FF00"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => ift_int_test_SLICE_X25Y21B_to_SLICE_X41Y22C,
      ADR4 => '1',
      ADR5 => '1',
      O => ift_int_test_SLICE_X41Y22C_to_SLICE_X27Y20B
    );
  SLICE_X43Y22_C6LUT : X_LUT6
    generic map(
      LOC => "SLICE_X43Y22",
      INIT => X"FFFFFFFF00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      ADR5 => ift_int_test_SLICE_X35Y21D_to_SLICE_X43Y22C,
      O => ift_int_test_SLICE_X43Y22C_to_SLICE_X28Y21A
    );
  SLICE_X45Y22_D6LUT : X_LUT6
    generic map(
      LOC => "SLICE_X45Y22",
      INIT => X"F0F0F0F0F0F0F0F0"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => ift_int_test_SLICE_X28Y21A_to_SLICE_X45Y22D,
      ADR3 => '1',
      ADR4 => '1',
      ADR5 => '1',
      O => ift_int_test_SLICE_X45Y22D_to_SLICE_X30Y20A
    );
  SLICE_X47Y22_C6LUT : X_LUT6
    generic map(
      LOC => "SLICE_X47Y22",
      INIT => X"FF00FF00FF00FF00"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => ift_int_test_SLICE_X31Y21B_to_SLICE_X47Y22C,
      ADR4 => '1',
      ADR5 => '1',
      O => ift_int_test_SLICE_X47Y22C_to_SLICE_X33Y20B
    );
  SLICE_X25Y21_B6LUT : X_LUT6
    generic map(
      LOC => "SLICE_X25Y21",
      INIT => X"FFFFFFFF00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      ADR5 => driver_net,
      O => ift_int_test_SLICE_X25Y21B_to_SLICE_X41Y22C
    );
  SLICE_X28Y21_A6LUT : X_LUT6
    generic map(
      LOC => "SLICE_X28Y21",
      INIT => X"FFFFFFFF00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      ADR5 => ift_int_test_SLICE_X43Y22C_to_SLICE_X28Y21A,
      O => ift_int_test_SLICE_X28Y21A_to_SLICE_X45Y22D
    );
  SLICE_X29Y21_C6LUT : X_LUT6
    generic map(
      LOC => "SLICE_X29Y21",
      INIT => X"FFFFFFFF00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      ADR5 => ift_int_test_SLICE_X39Y21C_to_SLICE_X29Y21C,
      O => ift_int_test_SLICE_X29Y21C_to_SLICE_X37Y21C
    );
  SLICE_X31Y21_C6LUT : X_LUT6
    generic map(
      LOC => "SLICE_X31Y21",
      INIT => X"FFFFFFFF00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      ADR5 => ift_int_test_SLICE_X37Y20C_to_SLICE_X31Y21C,
      O => ift_int_test_SLICE_X31Y21C_to_SLICE_X39Y21C
    );
  SLICE_X31Y21_B6LUT : X_LUT6
    generic map(
      LOC => "SLICE_X31Y21",
      INIT => X"FFFFFFFF00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      ADR5 => ift_int_test_SLICE_X47Y21C_to_SLICE_X31Y21B,
      O => ift_int_test_SLICE_X31Y21B_to_SLICE_X47Y22C
    );
  SLICE_X35Y21_D6LUT : X_LUT6
    generic map(
      LOC => "SLICE_X35Y21",
      INIT => X"FFFFFFFF00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      ADR5 => ift_int_test_SLICE_X47Y21D_to_SLICE_X35Y21D,
      O => ift_int_test_SLICE_X35Y21D_to_SLICE_X43Y22C
    );
  SLICE_X35Y21_B6LUT : X_LUT6
    generic map(
      LOC => "SLICE_X35Y21",
      INIT => X"FFFFFFFF00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      ADR5 => ift_int_test_SLICE_X46Y21B_to_SLICE_X35Y21B,
      O => ift_int_test_SLICE_X35Y21B_to_SLICE_X43Y20C
    );
  SLICE_X37Y21_C6LUT : X_LUT6
    generic map(
      LOC => "SLICE_X37Y21",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => ift_int_test_SLICE_X29Y21C_to_SLICE_X37Y21C,
      ADR5 => '1',
      O => ift_int_test_SLICE_X37Y21C_to_SLICE_X31Y20B
    );
  SLICE_X39Y21_C6LUT : X_LUT6
    generic map(
      LOC => "SLICE_X39Y21",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => ift_int_test_SLICE_X31Y21C_to_SLICE_X39Y21C,
      ADR5 => '1',
      O => ift_int_test_SLICE_X39Y21C_to_SLICE_X29Y21C
    );
  SLICE_X43Y21_C6LUT : X_LUT6
    generic map(
      LOC => "SLICE_X43Y21",
      INIT => X"FF00FF00FF00FF00"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => ift_int_test_SLICE_X27Y20B_to_SLICE_X43Y21C,
      ADR4 => '1',
      ADR5 => '1',
      O => ift_int_test_SLICE_X43Y21C_to_SLICE_X29Y20D
    );
  SLICE_X45Y21_C6LUT : X_LUT6
    generic map(
      LOC => "SLICE_X45Y21",
      INIT => X"FF00FF00FF00FF00"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => ift_int_test_SLICE_X29Y20B_to_SLICE_X45Y21C,
      ADR4 => '1',
      ADR5 => '1',
      O => ift_int_test_SLICE_X45Y21C_to_SLICE_X35Y20B
    );
  SLICE_X46Y21_B6LUT : X_LUT6
    generic map(
      LOC => "SLICE_X46Y21",
      INIT => X"CCCCCCCCCCCCCCCC"
    )
    port map (
      ADR0 => '1',
      ADR1 => ift_int_test_SLICE_X30Y20A_to_SLICE_X46Y21B,
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      ADR5 => '1',
      O => ift_int_test_SLICE_X46Y21B_to_SLICE_X35Y21B
    );
  SLICE_X47Y21_D6LUT : X_LUT6
    generic map(
      LOC => "SLICE_X47Y21",
      INIT => X"AAAAAAAAAAAAAAAA"
    )
    port map (
      ADR0 => ift_int_test_SLICE_X31Y20C_to_SLICE_X47Y21D,
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      ADR5 => '1',
      O => ift_int_test_SLICE_X47Y21D_to_SLICE_X35Y21D
    );
  SLICE_X47Y21_C6LUT : X_LUT6
    generic map(
      LOC => "SLICE_X47Y21",
      INIT => X"FF00FF00FF00FF00"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => ift_int_test_SLICE_X31Y20B_to_SLICE_X47Y21C,
      ADR4 => '1',
      ADR5 => '1',
      O => ift_int_test_SLICE_X47Y21C_to_SLICE_X31Y21B
    );
  SLICE_X27Y20_B6LUT : X_LUT6
    generic map(
      LOC => "SLICE_X27Y20",
      INIT => X"FFFFFFFF00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      ADR5 => ift_int_test_SLICE_X41Y22C_to_SLICE_X27Y20B,
      O => ift_int_test_SLICE_X27Y20B_to_SLICE_X43Y21C
    );
  SLICE_X29Y20_D6LUT : X_LUT6
    generic map(
      LOC => "SLICE_X29Y20",
      INIT => X"FFFFFFFF00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      ADR5 => ift_int_test_SLICE_X43Y21C_to_SLICE_X29Y20D,
      O => ift_int_test_SLICE_X29Y20D_to_SLICE_X37Y20C
    );
  SLICE_X29Y20_B6LUT : X_LUT6
    generic map(
      LOC => "SLICE_X29Y20",
      INIT => X"FFFFFFFF00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      ADR5 => ift_int_test_SLICE_X41Y20C_to_SLICE_X29Y20B,
      O => ift_int_test_SLICE_X29Y20B_to_SLICE_X45Y21C
    );
  SLICE_X30Y20_A6LUT : X_LUT6
    generic map(
      LOC => "SLICE_X30Y20",
      INIT => X"FFFFFFFF00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      ADR5 => ift_int_test_SLICE_X45Y22D_to_SLICE_X30Y20A,
      O => ift_int_test_SLICE_X30Y20A_to_SLICE_X46Y21B
    );
  SLICE_X31Y20_C6LUT : X_LUT6
    generic map(
      LOC => "SLICE_X31Y20",
      INIT => X"FFFFFFFF00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      ADR5 => ift_int_test_SLICE_X43Y19C_to_SLICE_X31Y20C,
      O => ift_int_test_SLICE_X31Y20C_to_SLICE_X47Y21D
    );
  SLICE_X31Y20_B6LUT : X_LUT6
    generic map(
      LOC => "SLICE_X31Y20",
      INIT => X"FFFFFFFF00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      ADR5 => ift_int_test_SLICE_X37Y21C_to_SLICE_X31Y20B,
      O => ift_int_test_SLICE_X31Y20B_to_SLICE_X47Y21C
    );
  SLICE_X33Y20_B6LUT : X_LUT6
    generic map(
      LOC => "SLICE_X33Y20",
      INIT => X"FFFFFFFF00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      ADR5 => ift_int_test_SLICE_X47Y22C_to_SLICE_X33Y20B,
      O => ift_int_test_SLICE_X33Y20B_to_SLICE_X41Y20C
    );
  SLICE_X35Y20_B6LUT : X_LUT6
    generic map(
      LOC => "SLICE_X35Y20",
      INIT => X"FFFFFFFF00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      ADR5 => ift_int_test_SLICE_X45Y21C_to_SLICE_X35Y20B,
      O => ift_int_test_SLICE_X35Y20B_to_SLICE_X43Y19C
    );
  SLICE_X37Y20_C6LUT : X_LUT6
    generic map(
      LOC => "SLICE_X37Y20",
      INIT => X"FFFFFFFF00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      ADR5 => ift_int_test_SLICE_X29Y20D_to_SLICE_X37Y20C,
      O => ift_int_test_SLICE_X37Y20C_to_SLICE_X31Y21C
    );
  SLICE_X41Y20_C6LUT : X_LUT6
    generic map(
      LOC => "SLICE_X41Y20",
      INIT => X"FF00FF00FF00FF00"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => ift_int_test_SLICE_X33Y20B_to_SLICE_X41Y20C,
      ADR4 => '1',
      ADR5 => '1',
      O => ift_int_test_SLICE_X41Y20C_to_SLICE_X29Y20B
    );
  SLICE_X43Y20_C6LUT : X_LUT6
    generic map(
      LOC => "SLICE_X43Y20",
      INIT => X"FF00FF00FF00FF00"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => ift_int_test_SLICE_X35Y21B_to_SLICE_X43Y20C,
      ADR4 => '1',
      ADR5 => '1',
      O => ift_int_test_SLICE_X43Y20C_to_SLICE_X33Y23D
    );
  SLICE_X43Y19_C6LUT : X_LUT6
    generic map(
      LOC => "SLICE_X43Y19",
      INIT => X"FF00FF00FF00FF00"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => ift_int_test_SLICE_X35Y20B_to_SLICE_X43Y19C,
      ADR4 => '1',
      ADR5 => '1',
      O => ift_int_test_SLICE_X43Y19C_to_SLICE_X31Y20C
    );
  NlwBufferBlock_harness_ram_Mram_state_machine_ADDRAWRADDR_8_Q : X_BUF -- AKA:NlwBufferBlock_harness/ram/Mram_state_machine/ADDRAWRADDR<8>
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pass,
      O => NlwBufferSignal_harness_ram_Mram_state_machine_ADDRAWRADDR(8)
    );
  NlwBufferBlock_harness_ram_Mram_state_machine_ADDRAWRADDR_7_Q : X_BUF -- AKA:NlwBufferBlock_harness/ram/Mram_state_machine/ADDRAWRADDR<7>
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => harness_state(2),
      O => NlwBufferSignal_harness_ram_Mram_state_machine_ADDRAWRADDR(7)
    );
  NlwBufferBlock_harness_ram_Mram_state_machine_ADDRAWRADDR_6_Q : X_BUF -- AKA:NlwBufferBlock_harness/ram/Mram_state_machine/ADDRAWRADDR<6>
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => harness_state(1),
      O => NlwBufferSignal_harness_ram_Mram_state_machine_ADDRAWRADDR(6)
    );
  NlwBufferBlock_harness_ram_Mram_state_machine_ADDRAWRADDR_5_Q : X_BUF -- AKA:NlwBufferBlock_harness/ram/Mram_state_machine/ADDRAWRADDR<5>
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => harness_state(0),
      O => NlwBufferSignal_harness_ram_Mram_state_machine_ADDRAWRADDR(5)
    );
  NlwBufferBlock_harness_ram_Mram_state_machine_ADDRAWRADDR_4_Q : X_BUF -- AKA:NlwBufferBlock_harness/ram/Mram_state_machine/ADDRAWRADDR<4>
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => harness_counter(13),
      O => NlwBufferSignal_harness_ram_Mram_state_machine_ADDRAWRADDR(4)
    );
  NlwBufferBlock_harness_ram_Mram_state_machine_ADDRAWRADDR_3_Q : X_BUF -- AKA:NlwBufferBlock_harness/ram/Mram_state_machine/ADDRAWRADDR<3>
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => result_net,
      O => NlwBufferSignal_harness_ram_Mram_state_machine_ADDRAWRADDR(3)
    );
  NlwBufferBlock_BUFG_inst_IN : X_BUF -- AKA:NlwBufferBlock_BUFG_inst/IN
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => clk,
      O => NlwBufferSignal_BUFG_inst_IN
    );
  NlwBufferBlock_BSCAN_inst_TDO : X_BUF -- AKA:NlwBufferBlock_BSCAN_inst/TDO
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pass,
      O => NlwBufferSignal_BSCAN_inst_TDO
    );
  NlwBlock_top_level_GND : X_ZERO
    port map (
      O => GND
    );
  NlwBlock_top_level_VCC : X_ONE
    port map (
      O => VCC
    );
  NlwBlockROC : X_ROC
    port map (O => GSR);
  NlwBlockTOC : X_TOC
    port map (O => GTS);

end STRUCTURE;

