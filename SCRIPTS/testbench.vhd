-- Copyright University of Southern California 2019
--
-- DISCLAIMER. USC MAKES NO EXPRESS OR IMPLIED WARRANTIES, EITHER IN FACT OR BY
-- OPERATION OF LAW, BY STATUTE OR OTHERWISE, AND USC SPECIFICALLY AND EXPRESSLY
-- DISCLAIMS ANY EXPRESS OR IMPLIED WARRANTY OF MERCHANTABILITY OR FITNESS FOR A
-- PARTICULAR PURPOSE, VALIDITY OF THE SOFTWARE OR ANY OTHER INTELLECTUAL PROPERTY
-- RIGHTS OR NON-INFRINGEMENT OF THE INTELLECTUAL PROPERTY OR OTHER RIGHTS OF ANY
-- THIRD PARTY. SOFTWARE IS MADE AVAILABLE AS-IS.
-- LIMITATION OF LIABILITY. TO THE MAXIMUM EXTENT PERMITTED BY LAW, IN NO EVENT WILL
-- USC BE LIABLE TO ANY USER OF THIS CODE FOR ANY INCIDENTAL, CONSEQUENTIAL, EXEMPLARY
-- OR PUNITIVE DAMAGES OF ANY KIND, LOST GOODWILL, LOST PROFITS, LOST BUSINESS AND/OR
-- ANY INDIRECT ECONOMIC DAMAGES WHATSOEVER, REGARDLESS OF WHETHER SUCH DAMAGES
-- ARISE FROM CLAIMS BASED UPON CONTRACT, NEGLIGENCE, TORT (INCLUDING STRICT LIABILITY
-- OR OTHER LEGAL THEORY), A BREACH OF ANY WARRANTY OR TERM OF THIS AGREEMENT, AND
-- REGARDLESS OF WHETHER USC WAS ADVISED OR HAD REASON TO KNOW OF THE POSSIBILITY OF
-- INCURRING SUCH DAMAGES IN ADVANCE.
--
-- Travis Haroldsen
--
-- Testbench wrapper.
--

use std.textio.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;

entity testbench is
end entity testbench;

architecture tb of testbench is
	signal clk: std_logic := '1';
	signal pass: std_logic;
	signal done: std_logic;

	signal finished: boolean := false;
begin
	process
	begin
		if finished then
			wait;  -- terminate the simulation
		end if;

		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
	end process;

	harness: entity work.harness
	port map(
		clk => clk,
		pass => pass,
		error => open,
		load_next => '1',
		done => done
	);

	process
		variable my_line: line;
		file file_RESULTS: text;
	begin
		wait until done = '1';
		finished <= true;
		wait for 1 ns;  -- let the circuit settle
		file_open(file_RESULTS, "simulation.out", write_mode);
		write(my_line, std_logic'image(pass));
		writeline(file_RESULTS, my_line);
		file_close(file_RESULTS);
		wait;
	end process;

	-- in case done never goes high
	process
	begin
		wait for 40 ms;
		if not finished then
			assert false severity FAILURE;
		end if;
		wait;
	end process;
end architecture;
