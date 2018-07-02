-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- PROGRAM		"Quartus II 64-Bit"
-- VERSION		"Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition"
-- CREATED		"Thu Mar 22 17:48:02 2018"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY uart IS 
	PORT
	(
		CLOCK_12M5 	:  IN  STD_LOGIC;
		DATA_IN 	:  IN  STD_LOGIC;
		RESET_N 	:  IN  STD_LOGIC;
		NEW_DATA    :  OUT STD_LOGIC;
    	DATA_OUT    :  OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END uart;

ARCHITECTURE bdf_type OF uart IS 

COMPONENT rx_reg
	PORT(tick : IN STD_LOGIC;
		 serial_i : IN STD_LOGIC;
		 clk, reset : IN STD_LOGIC;
		 new_out_data : OUT STD_LOGIC;
		 parallel_o : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT tick_generator
GENERIC (width : INTEGER
			);
	PORT(enable : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 tick : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT fsm_midi
	PORT(clk, reset : IN STD_LOGIC;
		 data : IN STD_LOGIC;
		 tick : IN STD_LOGIC;
		 enable : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT bus_divider
	PORT(data_in  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 data_out : OUT   std_logic_vector(7 downto 0)
	);
END COMPONENT;

COMPONENT sync_n_edgedetector
	PORT(data_in : IN STD_LOGIC;
		 clock : IN STD_LOGIC;
		 reset_n : IN STD_LOGIC;
		 data_sync : OUT STD_LOGIC;
		 rise : OUT STD_LOGIC;
		 fall : OUT STD_LOGIC
	);
END COMPONENT;

--COMPONENT hex2sevseg_w_control
--	PORT(blank_n_i : IN STD_LOGIC;
--		 lamp_test_n_i : IN STD_LOGIC;
--		 ripple_blank_n_i : IN STD_LOGIC;
--		 hexa_i : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
--		 ripple_blank_n_o : OUT STD_LOGIC;
--		 seg_o : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
--	);
--END COMPONENT;

SIGNAL	clk1 :  STD_LOGIC;
SIGNAL	data1 :  STD_LOGIC;
SIGNAL	enable1 :  STD_LOGIC;
SIGNAL	LSB :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	middle :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	MSB :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	tick1 :  STD_LOGIC;
SIGNAL	vcc1 :  STD_LOGIC;
--SIGNAL	vcc2 :  STD_LOGIC;
SIGNAL  reset1 : STD_LOGIC;


BEGIN 



b2v_inst : rx_reg
PORT MAP(tick => tick1,
		 serial_i => DATA_IN,
		 clk => clk1,
		 reset => reset1,
		 new_out_data => NEW_DATA,
		 parallel_o => middle
		 );


b2v_inst1 : tick_generator
GENERIC MAP(width => 12
			)
PORT MAP(enable => enable1,
		 clk => clk1,
		 tick => tick1);




b2v_inst4 : fsm_midi
PORT MAP(clk => clk1,
		 reset => reset1,
		 data => DATA_IN,
		 tick => tick1,
		 enable => enable1);


b2v_inst5 : bus_divider
PORT MAP(data_in => middle,
		 data_out => DATA_OUT);


--b2v_inst7 : sync_n_edgedetector
--PORT MAP(data_in => GPIO_1(0),
--		 clock => clk1,
--		 reset_n => vcc1,
--		 data_sync => data1);

reset_inst : sync_n_edgedetector
PORT MAP(data_in => RESET_N,
		 clock => clk1,
		 reset_n => vcc1,
		 data_sync => reset1);


--b2v_inst8 : hex2sevseg_w_control
--PORT MAP(blank_n_i => vcc2,
--		 lamp_test_n_i => vcc2,
--		 ripple_blank_n_i => vcc2,
--		 hexa_i => LSB,
--		 seg_o => HEX0);


--b2v_inst9 : hex2sevseg_w_control
--PORT MAP(blank_n_i => vcc1,
--		 lamp_test_n_i => vcc1,
--		 ripple_blank_n_i => vcc1,
--		 hexa_i => MSB,
--		 seg_o => HEX1);

clk1 <= CLOCK_12M5;

vcc1 <= '1';
--vcc2 <= '1';
END bdf_type;