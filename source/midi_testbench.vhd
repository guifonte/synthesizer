-------------------------------------------
-- Block code:  MIDI TESTBENCH
-- History: 	13.Mar.2018 - 1st version (dqtm)
--                 <date> - <changes>  (<author>)
-- Function: Testbench for uart_rx_only_top in EA999 - Lab2
--           
-------------------------------------------

-- Library & Use Statements
LIBRARY ieee;
use ieee.std_logic_1164.all;

-- Entity Declaration 
ENTITY midi_testbench IS
  
END midi_testbench ;


-- Architecture Declaration 
ARCHITECTURE struct OF midi_testbench IS

	-- Components Declaration
COMPONENT Milestone3_infrastructure_block IS
	PORT(
		CLOCK_50				: IN  	std_logic;		-- DE2 clock from xtal 50MHz
		KEY						: IN  	std_logic_vector( 3 downto 0);  -- DE2 low_active input buttons
		SW						: IN	std_logic_vector(9 downto 0);	-- DE2 input switches
		GPIO_0					: IN 	std_logic_vector(35 downto 0);
		AUD_XCK					: OUT	std_logic;		-- master clock for Audio Codec
		I2C_SCLK				: OUT	std_logic;		-- clock from I2C master block
		I2C_SDAT				: INOUT std_logic;		-- data  from I2C master block
		AUD_DACDAT				: OUT	std_logic;	
		AUD_BCLK				: OUT	std_logic;	
		AUD_DACLRCK				: OUT	std_logic;	
		AUD_ADCLRCK				: OUT	std_logic;	
		AUD_ADCDAT				: IN  	std_logic
	);
END COMPONENT ;
	
	
	-- Signals & Constants Declaration 
	-- Inputs
	SIGNAL tb_clock 	: std_logic;
	SIGNAL tb_reset_n 	: std_logic;
	SIGNAL tb_serdata	: std_logic;

	SIGNAL tb_clock_50					: std_logic;		-- DE2 clock from xtal 50MHz
	SIGNAL tb_key						: std_logic_vector( 3 downto 0);  -- DE2 low_active input buttons
	SIGNAL tb_sw						: std_logic_vector(9 downto 0);	-- DE2 input switches
	SIGNAL tb_gpio_0					: std_logic_vector(35 downto 0);
	SIGNAL tb_aud_xck					: std_logic;		-- master clock for Audio Codec
	SIGNAL tb_i2c_sclk					: std_logic;		-- clock from I2C master block
	SIGNAL tb_i2c_sdat					: std_logic;		-- data  from I2C master block
	SIGNAL tb_aud_dacdat				: std_logic;	
	SIGNAL tb_aud_bclk					: std_logic;	
	SIGNAL tb_aud_daclrck				: std_logic;	
	SIGNAL tb_aud_adclrck				: std_logic;	
	SIGNAL tb_aud_adcdat				: std_logic;


	-- Outputs
	
	
	CONSTANT clk_50M_halfp 	: time := 10 ns;  		-- Half-Period of Clock 50MHz
	CONSTANT baud_31k250_per : time := 32 us;		-- One-Period of Baud Rate 31.25KHz
	
	--SIGNAL tb_reg0_hi	: std_logic_vector(3 downto 0); -- to check DUT-internal signal
	--SIGNAL tb_reg0_lo	: std_logic_vector(3 downto 0);

	SIGNAL tb_test_note_on, tb_test_note_off : std_logic_vector(9 downto 0); -- (start-bit)+(data-byte)+(stop-bit) to shift in serial_in
	SIGNAL tb_test_c4 : std_logic_vector(9 downto 0); -- (start-bit)+(data-byte)+(stop-bit) to shift in serial_in
	SIGNAL tb_test_velocity : std_logic_vector(9 downto 0); -- (start-bit)+(data-byte)+(stop-bit) to shift in serial_in
	
	
BEGIN
  -- Instantiations
  DUT: Milestone3_infrastructure_block
  PORT MAP (

  	CLOCK_50		=>	tb_clock,	
	KEY				=>	tb_key,
	SW				=>  tb_sw,
	GPIO_0			=> 	tb_gpio_0,
	AUD_XCK			=> 	tb_aud_xck,
	I2C_SCLK		=> 	tb_i2c_sclk,
	I2C_SDAT		=> 	tb_i2c_sdat,
	AUD_DACDAT		=> 	tb_aud_dacdat,
	AUD_BCLK		=> 	tb_aud_bclk,
	AUD_DACLRCK		=> 	tb_aud_daclrck,
	AUD_ADCLRCK		=> 	tb_aud_adclrck,
	AUD_ADCDAT		=> 	tb_aud_adcdat
		);
		
  -- Clock Generation Process	
	generate_clock: PROCESS
	BEGIN
		tb_clock <= '1';
		wait for clk_50M_halfp;	
		tb_clock <= '0';
		wait for clk_50M_halfp;
	END PROCESS generate_clock;
	
		
	-------------------------------------------
	-- VHDL-2008 Syntax allowing to bind 
	--           internal signals to a debug signal in the testbench
	-------------------------------------------
	--tb_reg0_hi <= <<signal DUT.hexa_hi : std_logic_vector(3 downto 0) >>;
	--tb_reg0_lo <= <<signal DUT.hexa_lo : std_logic_vector(3 downto 0) >>;
	
	
  -- Stimuli Process
	stimuli: PROCESS
	BEGIN
		-- STEP 0
		report "Initialise: define constants and pulse reset on/off";




		tb_gpio_0(0) <= '1';

		--note on
		tb_test_note_on <= B"0_1001_0100_1"; -- (stop-bit)+(data-byte)+(start-bit)
		--note off
		tb_test_note_off <= B"0_1000_0100_1"; -- (stop-bit)+(data-byte)+(start-bit)
		--note: c4
		tb_test_c4 <= B"0_0011_1100_1";
		--velocity: very loud
		tb_test_velocity <= B"0_0111_1111_1";

		--ativando o I2S
		tb_sw(0) <= '0';
		tb_sw(1) <= '0';
		tb_sw(2) <= '1';

		--ativando o DDS
		tb_sw(8) <= '1';
		--desativando o FIR
		tb_sw(9) <= '0';
		--ativando a onda senoidal
		tb_sw(3) <= '0';
		tb_sw(4) <= '0';


		--Reseting
		----------------
		tb_key(0) <= '0';
		wait for 20 * clk_50M_halfp; 
		tb_key(0)  <= '1';
		wait for 100 us;  -- introduce pause to check HW-bug after reset release
		
		--Initializing
		-----------------
		tb_key(1) <= '0';
		wait for 20 * clk_50M_halfp; 
		tb_key(1)  <= '1';
		wait for 100 us;  -- introduce pause to check HW-bug after reset release

		-- STEP 1
		report "Send (start-bit)+(data-byte)+(stop-bit) with baud rate 31250 (async from clk50M)";
		wait for 200 * clk_50M_halfp;
		
		-- shift-direction is LSB first
		-- START-BIT 
		-- BIT-0 (LSB-first of lower nibbl
		-- BIT-1
		-- ...
		-- BIT-7
		-- STOP-BIT
		-- SERDATA BACK TO INACTIVE

		-- note on C3
		for I in 9 downto 0 loop
			tb_gpio_0(0) <= tb_test_note_on(I);
			wait for baud_31k250_per;
		end loop;
		
		wait for 200 * clk_50M_halfp;


		for I in 9 downto 0 loop
			tb_gpio_0(0) <= tb_test_c4(I);
			wait for baud_31k250_per;
		end loop;

		wait for 200 * clk_50M_halfp;

		for I in 9 downto 0 loop
			tb_gpio_0(0) <= tb_test_velocity(I);
			wait for baud_31k250_per;
		end loop;


		wait for 400 * clk_50M_halfp;



		for I in 9 downto 0 loop
			tb_gpio_0(0) <= tb_test_note_off(I);
			wait for baud_31k250_per;
		end loop;
		
		wait for 200 * clk_50M_halfp;


		for I in 9 downto 0 loop
			tb_gpio_0(0) <= tb_test_c4(I);
			wait for baud_31k250_per;
		end loop;

		wait for 200 * clk_50M_halfp;

		for I in 9 downto 0 loop
			tb_gpio_0(0) <= tb_test_velocity(I);
			wait for baud_31k250_per;
		end loop;

		wait for 400 * clk_50M_halfp;


		
	END PROCESS stimuli;
	
	-- Comments:
	-- remember to re-save wave.do after setting radix and time ranges
	-- use >wave>format>toggle leaf names  to display shorter names
	-- remark syntax with aux debug signal to track in TB internal DUT signals
  
END struct;

