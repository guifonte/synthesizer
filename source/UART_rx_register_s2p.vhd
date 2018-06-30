-------------------------------------------
-- Block code:  rx_register_s2p.vhd
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

ENTITY rx_register_s2p IS
  PORT( clk,reset_n: 						IN    std_logic;			-- Attention, this block has a set_n input for initialisation!!
  		activator: 								IN    std_logic;
  		midi_o: 			            OUT   std_logic_vector(7 downto 0);
      data_valid_out:           OUT   std_logic;
    	ser_i: 									  IN   	std_logic
    	);
END rx_register_s2p;

ARCHITECTURE rtl OF rx_register_s2p IS
-- Signals & Constants Declaration
-------------------------------------------
	SIGNAL 		shiftreg, next_shiftreg: 	std_logic_vector(9 downto 0);	 -- add one FF for start_bit 0
  SIGNAL    count, next_count : unsigned(3 downto 0); -- bitcounter (message = 10 bits)
BEGIN

  --------------------------------------------------
  -- PROCESS FOR COMBINATIONAL LOGIC
  --------------------------------------------------
  shift_comb: PROCESS(shiftreg, ser_i, activator)
  BEGIN	
  next_shiftreg <= shiftreg;
  next_count <= count;
  --loading 1 bit (serial)
	IF (activator = '1') THEN			  -- load serial data (startbit 0)
		next_shiftreg <=  shiftreg(8 downto 0 ) &  ser_i; -- LSB='0' is the start_bit
    next_count <= count + 1; 
	END IF;  
  IF (count >= 10) THEN
    next_count <= to_unsigned(0,4);

	END IF;

  END PROCESS shift_comb;   
  
  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  shift_dffs : PROCESS(clk, reset_n)
  BEGIN	
	IF reset_n = '0' THEN
		shiftreg <= (others=>'1');
    count <= (others => '0');
   ELSIF rising_edge(clk) THEN
		shiftreg <= next_shiftreg ;
    count <= next_count;
   END IF;
  END PROCESS shift_dffs;		
  
  --------------------------------------------------
  -- CONCURRENT ASSIGNMENTS
  --------------------------------------------------
  -- take LSB of shiftreg as serial output
  led_comb : PROCESS(shiftreg)
  BEGIN

  data_valid_out <= '0';
  midi_o <= (others => '1');

  	IF (count >= 10) THEN
  		midi_o <= shiftreg (8 downto 1);
      data_valid_out <= '1';
  	END IF;

  END PROCESS led_comb;

END rtl;

