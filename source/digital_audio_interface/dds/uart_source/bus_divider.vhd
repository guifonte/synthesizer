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

ENTITY bus_divider IS
  PORT(   data_in	  	    : IN    std_logic_vector(7 downto 0);		
          data_out        : OUT   std_logic_vector(7 downto 0)
			 
    	);
END bus_divider;

ARCHITECTURE rtl OF bus_divider IS
-- Signals & Constants Declaration
-------------------------------------------	

BEGIN

  --------------------------------------------------
  -- PROCESS FOR OUTPUT CONTROL LOGIC
  --------------------------------------------------
  output_ctrl: PROCESS(data_in)
  BEGIN	
	
	data_out(7) <= data_in(0);
  data_out(6) <= data_in(1);
  data_out(5) <= data_in(2);
  data_out(4) <= data_in(3);
  data_out(3) <= data_in(4);
  data_out(2) <= data_in(5);
  data_out(1) <= data_in(6);
  data_out(0) <= data_in(7);
  END PROCESS output_ctrl; 

   --------------------------------------------------
  -- CONCURRENT ASSIGNMENTS
  --------------------------------------------------
  
END rtl;

