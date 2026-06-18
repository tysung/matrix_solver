--------------------------------------------------------------------------------
-- Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor: Xilinx
-- \   \   \/     Version: P.20131013
--  \   \         Application: netgen
--  /   /         Timestamp: Fri Nov 13 15:22:15 2020
-- /___/   /\     
-- \   \  /  \ 
--  \___\/\___\
--             
-- Command: -w -aka -sim -ofmt vhdl -intstyle ise -mhf -pcf harness_placed.pcf -tb -mhf harness.ncd 
-- Design Name: top_level
--             
-- Purpose:    
--     Xilinx Testbench Template produced by program netgen P.20131013
--             
--     ATTENTION: This file was created by netgen and may therefore be 
--     overwritten by subsequent runs of netgen. Xilinx recommends that you 
--     copy this file to a new name, or 'paste' this text into another file, 
--     to avoid accidental loss of data.
--             
--------------------------------------------------------------------------------

library IEEE;
library WORK;
library SIMPRIM;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.ALL;
use SIMPRIM.VCOMPONENTS.ALL;
use SIMPRIM.VPACKAGE.ALL;

entity TBX_top_level is
end TBX_top_level;

architecture TBX_ARCH of TBX_top_level is
  component top_level
    port (
      clkin_P : in STD_LOGIC := 'X';
      clkin_N : in STD_LOGIC := 'X'
    );
  end component;

  signal finished: boolean := false;
  signal clkin_P : STD_LOGIC;
  signal clkin_N : STD_LOGIC;

  begin
    UUT : top_level
      port map (
        clkin_P => clkin_P,
        clkin_N => clkin_N
      );
    -- User: Put your stimulus here.
    process
    begin
            if finished then
                    wait;  -- terminate the simulation
            end if;

            wait for 20 ns;
              clkin_P <= '0';
              clkin_N <= '1';
            wait for 20 ns;
              clkin_P <= '1';
              clkin_N <= '0';
    end process;



end TBX_ARCH;

configuration TBX_CFG_top_level_TBX_ARCH of TBX_top_level is
  for TBX_ARCH
  end for;
end TBX_CFG_top_level_TBX_ARCH;
