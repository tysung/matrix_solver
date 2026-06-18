--------------------------------------------------------------------------------
-- Copyright (c) 1995-2008 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor: Xilinx
-- \   \   \/     Version: K.39
--  \   \         Application: netgen
--  /   /         Timestamp: Wed Jul 15 15:00:09 2020
-- /___/   /\     
-- \   \  /  \ 
--  \___\/\___\
--             
-- Command: -w -aka -sim -ofmt vhdl -intstyle ise -mhf -pcf harness_placed.pcf -tb luts1-0.ncd 
-- Design Name: top_level
--             
-- Purpose:    
--     Xilinx Testbench Template produced by program netgen K.39
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
      boardInputClk : in STD_LOGIC := 'X'
    );
  end component;

  signal clk : STD_LOGIC;
  signal finished: boolean := false;

  begin
    UUT : top_level
      port map (
        boardInputClk => clk
      );
    -- User: Put your stimulus here.
    process
    begin
            if finished then
                    wait;  -- terminate the simulation
            end if;

            wait for 20 ns;
              clk <= '0';
            wait for 20 ns;
              clk <= '1';
    end process;


end TBX_ARCH;

configuration TBX_CFG_top_level_TBX_ARCH of TBX_top_level is
  for TBX_ARCH
  end for;
end TBX_CFG_top_level_TBX_ARCH;
