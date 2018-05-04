-------------------------------------------
-- Block code:  testbench_milestone2_top.vhd
-- History: 	22.Mar.2017 - 1st version (dqtm)
--                 <date> - <changes>  (<author>)
-- Function: Testbench for audio_synth_top in DTP2 project - Milestone-1
--           
-------------------------------------------

-- Library & Use Statements
LIBRARY ieee;
use ieee.std_logic_1164.all;

-- Entity Declaration 
ENTITY testbench_milestone2_top IS
  
END testbench_milestone2_top ;


-- Architecture Declaration 
ARCHITECTURE struct OF testbench_milestone2_top IS

	-- Components Declaration
COMPONENT i2s_master_top 
	PORT(
		CLK_12M		: IN  	std_logic;		-- DE2 clock from xtal 50MHz
		INIT_N		: IN  	std_logic;  -- DE2 low_active input buttons
		ADCDAT_s_i	: IN 	std_logic;	-- DE2 input switches
		DACDAT_pl_i	: IN 	std_logic_vector(15 downto 0);
		DACDAT_pr_i	: IN 	std_logic_vector(15 downto 0);
		
		BCLK_o		: OUT 	std_logic;
		STROBE		: OUT 	std_logic;
		WS			: OUT 	std_logic;
		DACDAT_pl_o	: OUT	std_logic_vector(15 downto 0);
		DACDAT_pr_o	: OUT 	std_logic_vector(15 downto 0)
	);
END COMPONENT ; --FPGA_infrastructure_block



	-- Signals & Constants Declaration 

	signal tb_clk_12m		: std_logic;		-- DE2 clock from xtal 50MHz
	signal tb_init_n		: std_logic;  -- DE2 low_active input buttons
	signal tb_adcdat_s_i	: std_logic;	-- DE2 input switches
	signal tb_dacdat_pl		: std_logic_vector(15 downto 0);
	signal tb_dacdat_pr		: std_logic_vector(15 downto 0);
	signal tb_bclk_o		: std_logic;
	signal tb_strobe		: std_logic;
	signal tb_ws			: std_logic;
	signal td_data			: std_logic_vector(15 downto 0);

	CONSTANT CST_ONE 			: std_logic := '1';
	CONSTANT CST_ZERO			: std_logic := '0';
	CONSTANT CLK_12M_HALFP	 	: time := 40 ns;  		-- Half-Period of Clock 50MHz
	
BEGIN
  -- Instantiations
  DUT: i2s_master_top 
	PORT MAP(
		CLK_12M		 =>	tb_clk_12m,
		INIT_N		 =>	tb_init_n,
		ADCDAT_s_i	 =>	tb_adcdat_s_i,
		DACDAT_pl_i	 =>	tb_dacdat_pl,
		DACDAT_pr_i	 =>	tb_dacdat_pr,
		
		BCLK_o		 =>	tb_bclk_o,
		STROBE		 =>	tb_strobe,
		WS			 =>	tb_ws,
		DACDAT_pl_o	 =>	tb_dacdat_pl,
		DACDAT_pr_o	 =>	tb_dacdat_pr
	);

		
  -- Clock Generation Process	
	generate_clock: PROCESS
	BEGIN
		tb_clock_12<= '1';
		wait for CLK_12M_HALFP;	
		tb_clock_12<= '0';
		wait for CLK_12M_HALFP;
	END PROCESS generate_clock;
	
		
	-------------------------------------------
	-- VHDL-2008 Syntax allowing to bind 
	--           internal signals to a debug signal in the testbench
	-------------------------------------------
	-- tb_reg0_up <= <<signal DUT.reg0_up_hexa : std_logic_vector(3 downto 0) >>;
	-- tb_reg0_lo <= <<signal DUT.reg0_lo_hexa : std_logic_vector(3 downto 0) >>;
	
	
  -- Stimuli Process
	stimuli: PROCESS
	BEGIN
		-- initialise with reset pulse
		tb_init_n <= '1';
		wait until falling_edge(tb_bclk_o);
		tb_init_n <= '0';

	
		-- send serial data left
		wait until falling_edge(tb_ws);	
		wait until falling_edge(tb_bclk_o);
		t_data <= "1100010011101001";   -- or in hexa x"..."
		
		for i in 15 downto 0 loop
			t_ADCDAT_s <= t_data(i);
			wait until falling_edge(tb_bclk_o);	
		end loop;

		
	END PROCESS stimuli;
	
	-- Comments:
	-- remember to re-save wave.do after setting radix and time ranges
	-- use >wave>format>toggle leaf names  to display shorter names
	-- remark syntax with aux debug signal to track in TB internal DUT signals
  
END struct;

