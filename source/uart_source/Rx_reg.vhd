-------------------------------------------
-- Block code:  shiftreg_p2s.vhd
-- History: 	12.Nov.2013 - 1st version (dqtm)
--                 <date> - <changes>  (<author>)
-- Function: shift-register working as a parallel to serial converter.
--			The block has a load( or shift_n) control input, plus a parallel data input.
--			If load is high the parallel data is loaded, and if load is low the data is shifted towards the LSB.
--			During shift the MSB gets the value of '1'.
--			The serial output is the LSB of the shiftregister.  
--			Can be used as P2S in a serial interface, where inactive value (or rest_value)  equals '1'.
-------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY rx_reg IS
  PORT(   tick	  	    : IN    std_logic;			
  		    serial_i			: IN    std_logic;
          parallel_o    : OUT   std_logic_vector(7 downto 0);
          new_out_data  : OUT   std_logic;
          --serial_o      : OUT   std_logic;
			 clk, reset				: IN std_logic
    	);
END rx_reg;

ARCHITECTURE rtl OF rx_reg IS
-- Signals & Constants Declaration
-------------------------------------------
	SIGNAL 		shift_reg, next_shift_reg: 	std_logic_vector (9 downto 0) := (9 downto 0 => '0'); -- add one FF for start_bit
	SIGNAL		out_reg, next_out_reg :	std_logic_vector(7 downto 0) := (7 downto 0 => '0');
  SIGNAL    count, next_count:      unsigned (3 downto 0) := to_unsigned(0,4);

BEGIN

  --------------------------------------------------
  -- PROCESS FOR OUTPUT CONTROL LOGIC
  --------------------------------------------------
  output_ctrl: PROCESS(tick, serial_i, next_count, shift_reg, count, out_reg)
  BEGIN	
	   IF (tick = '1') THEN
	     next_shift_reg(0) <= serial_i;
       next_shift_reg(1) <= shift_reg(0);
       next_shift_reg(2) <= shift_reg(1);
       next_shift_reg(3) <= shift_reg(2);
       next_shift_reg(4) <= shift_reg(3);
       next_shift_reg(5) <= shift_reg(4);
       next_shift_reg(6) <= shift_reg(5);
       next_shift_reg(7) <= shift_reg(6);
       next_shift_reg(8) <= shift_reg(7);
       next_shift_reg(9) <= shift_reg(8);
       next_count        <= count + 1;
       next_out_reg      <= out_reg;
       new_out_data <= '0';

     ELSIF (count = 10) THEN
      next_out_reg <= shift_reg(8 downto 1);
      new_out_data <= '0';
      next_count   <= count + 1;
      --next_count   <= to_unsigned(0,4);
      next_shift_reg <= (9 downto 0 => '0');

      ELSIF (count = 11) THEN
       next_shift_reg(0) <= shift_reg(0);
       next_shift_reg(1) <= shift_reg(1);
       next_shift_reg(2) <= shift_reg(2);
       next_shift_reg(3) <= shift_reg(3);
       next_shift_reg(4) <= shift_reg(4);
       next_shift_reg(5) <= shift_reg(5);
       next_shift_reg(6) <= shift_reg(6);
       next_shift_reg(7) <= shift_reg(7);
       next_shift_reg(8) <= shift_reg(8);
       next_shift_reg(9) <= shift_reg(9);
       next_out_reg      <= out_reg;
       next_count        <= to_unsigned(0,4);
       new_out_data      <= '1';

	   ELSE
			 next_shift_reg(0) <= shift_reg(0);
       next_shift_reg(1) <= shift_reg(1);
       next_shift_reg(2) <= shift_reg(2);
       next_shift_reg(3) <= shift_reg(3);
       next_shift_reg(4) <= shift_reg(4);
       next_shift_reg(5) <= shift_reg(5);
       next_shift_reg(6) <= shift_reg(6);
       next_shift_reg(7) <= shift_reg(7);
       next_shift_reg(8) <= shift_reg(8);
			 next_shift_reg(9) <= shift_reg(9);
       next_out_reg      <= out_reg;
			 next_count        <= count;
       new_out_data      <= '0';
	   END IF;
  END PROCESS output_ctrl; 

  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  ffs : PROCESS(clk,reset)
  BEGIN
    IF (reset = '0') THEN
      count <= to_unsigned(0,4);
      shift_reg <= "0000000000";
      out_reg <= "00000000";
    ELSIF rising_edge(clk) THEN
			out_reg <= next_out_reg;
			shift_reg <= next_shift_reg;
			count <= next_count;
    END IF;
  END PROCESS ffs;
  
   --------------------------------------------------
  -- CONCURRENT ASSIGNMENTS
  --------------------------------------------------
  parallel_o <= out_reg;
  
END rtl;

