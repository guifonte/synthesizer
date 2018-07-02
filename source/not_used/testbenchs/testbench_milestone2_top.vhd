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
		CLOCK_12M				: IN  std_logic;	
		INIT_N					: IN  std_logic;
		ADCDAT_s_i				: IN  std_logic;
		DACDAT_pl_i				: IN  std_logic_vector(15 downto 0);
		DACDAT_pr_i				: IN  std_logic_vector(15 downto 0);
		
		ADCDAT_pl_o				: OUT std_logic_vector(15 downto 0);
		ADCDAT_pr_o				: OUT std_logic_vector(15 downto 0);
		STROBE					: OUT	std_logic;
		DACDAT_s_o				: OUT	std_logic;
		BCLK_o					: OUT	std_logic;
		WS							: OUT std_logic
	);
END COMPONENT ; --FPGA_infrastructure_block



	-- Signals & Constants Declaration 

	signal tb_clk_12m		: std_logic;		-- DE2 clock from xtal 50MHz
	signal tb_init_n		: std_logic;  -- DE2 low_active input buttons
	signal tb_adcdat_s_i	: std_logic;	-- DE2 input switches
	signal tb_dacdat_pl		: std_logic_vector(15 downto 0);
	signal tb_dacdat_pr		: std_logic_vector(15 downto 0);
	--signal tb_adcdat_pl		: std_logic_vector(15 downto 0);
	--signal tb_adcdat_pr		: std_logic_vector(15 downto 0);
	signal tb_bclk_o		: std_logic;
	signal tb_strobe		: std_logic;
	signal tb_dacdat_s		: std_logic;
	signal tb_ws			: std_logic;
	signal tb_data			: std_logic_vector(15 downto 0);

	CONSTANT CST_ONE 			: std_logic := '1';
	CONSTANT CST_ZERO			: std_logic := '0';
	CONSTANT CLK_12M_HALFP	 	: time := 40 ns;  		-- Half-Period of Clock 50MHz
	
BEGIN
  -- Instantiations
  DUT: i2s_master_top 
	PORT MAP(
		CLOCK_12M			 =>	tb_clk_12m,
		INIT_N				 =>	tb_init_n,
		ADCDAT_s_i			 =>	tb_adcdat_s_i,
		DACDAT_pl_i			 =>	tb_dacdat_pl,
		DACDAT_pr_i			 =>	tb_dacdat_pr,
		
		ADCDAT_pl_o			 =>	tb_dacdat_pl,
		ADCDAT_pr_o			 =>	tb_dacdat_pr,
		STROBE				 =>	tb_strobe,
		DACDAT_s_o			 =>	tb_dacdat_s,
		BCLK_o				 =>	tb_bclk_o,
		WS					 =>	tb_ws
	);		

		
  -- Clock Generation Process	
	generate_clock: PROCESS
	BEGIN
		tb_clk_12m<= '1';
		wait for CLK_12M_HALFP;	
		tb_clk_12m<= '0';
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
		tb_data <= "1100010011101001";   -- or in hexa x"..."
		-- initialise with reset pulse
		tb_init_n <= '0';
		wait until falling_edge(tb_clk_12m);
		tb_init_n <= '1';

	
		-- send serial data left

		wait until falling_edge(tb_ws);	
		wait until falling_edge(tb_bclk_o);
		
		
		for i in 15 downto 0 loop
			tb_adcdat_s_i <= tb_data(i);
			wait until falling_edge(tb_bclk_o);	
		end loop;
		
		wait until rising_edge(tb_ws);	
		wait until falling_edge(tb_bclk_o);
		
		-- send serial data right
		
		for i in 15 downto 0 loop
			tb_adcdat_s_i <= tb_data(i);
			wait until falling_edge(tb_bclk_o);	
		end loop;
		
	wait for 1_000 * CLK_12M_HALFP;
		
	END PROCESS stimuli;
	
	-- Comments:
	-- remember to re-save wave.do after setting radix and time ranges
	-- use >wave>format>toggle leaf names  to display shorter names
	-- remark syntax with aux debug signal to track in TB internal DUT signals
  
END struct;

