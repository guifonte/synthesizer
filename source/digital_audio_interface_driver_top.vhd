-------------------------------------------
-- Block code:  digital_audio_interface_driver_top.vhd
-- History: 	12.Apr.2018 - 1st version (guifonte)
--                 <date> - <changes>  (<author>)
-- Function: Top for the digital audio interface driver, 
--           with the i2s_master and the audio_ctrl blocks
--           
-------------------------------------------
-- Library & Use Statements
LIBRARY ieee;
use ieee.std_logic_1164.all;

-- Entity Declaration 
ENTITY digital_audio_interface_driver_top IS
	PORT(
		CLK_12M					: IN  std_logic;	
		RESET_N					: IN  std_logic;
		ADCDAT_s_in				: IN  std_logic;
		FIR_ctrl_in				: IN 	std_logic;
		DACDAT_s_out			: OUT	std_logic;
		BCLK_out					: OUT	std_logic;
		WS_out					: OUT std_logic
	);
END digital_audio_interface_driver_top ;

-- Architecture Declaration 
ARCHITECTURE struct OF digital_audio_interface_driver_top IS
	
	SIGNAL top_strobe				:	STD_LOGIC;
	SIGNAL top_ADCDAT_pl			:	std_logic_vector(15 downto 0);
	SIGNAL top_ADCDAT_pr			:	std_logic_vector(15 downto 0);
	SIGNAL top_DACDAT_pl_fir		:	std_logic_vector(15 downto 0);
	SIGNAL top_DACDAT_pr_fir		:	std_logic_vector(15 downto 0);
	SIGNAL top_DACDAT_pl_sig	:	std_logic_vector(15 downto 0);
	SIGNAL top_DACDAT_pr_sig	:	std_logic_vector(15 downto 0);
	
	COMPONENT fir_core
	--generic(
	--	lut_fir : t_lut_fir := LUT_FIR_LPF_200Hz );  -- from audio_filter_pkg
    PORT(
		clk         	: in    std_logic;
		reset_n     	: in    std_logic;
		strobe_i			: in    std_logic; 					   -- indicates beginning of audio frame
		adata_i			: in	  std_logic_vector(15 downto 0); --   audio  data input
		fdata_o			: out	  std_logic_vector(15 downto 0)  -- filtered data output
      );
	END COMPONENT ;
	
	COMPONENT i2s_master_top
	PORT(
		CLOCK_12M				: IN  	std_logic;	
		INIT_N					: IN  	std_logic;
		ADCDAT_s_i				: IN  	std_logic;
		DACDAT_pl_i				: IN  	std_logic_vector(15 downto 0);
		DACDAT_pr_i				: IN  	std_logic_vector(15 downto 0);
		ADCDAT_pl_o				: OUT 	std_logic_vector(15 downto 0);
		ADCDAT_pr_o				: OUT 	std_logic_vector(15 downto 0);
		STROBE					: OUT	std_logic;
		DACDAT_s_o				: OUT	std_logic;
		BCLK_o					: OUT	std_logic;
		WS						: OUT	std_logic
	);
	END COMPONENT ;
	
	BEGIN
		
		inst_fir_core_l: fir_core
		PORT MAP (
		clk         		=> CLK_12M,
		reset_n     		=> RESET_N,
		strobe_i			=> top_strobe,
		adata_i				=> top_ADCDAT_pl,
		fdata_o				=> top_DACDAT_pl_fir
		);
		
		inst_fir_core_r: fir_core
		PORT MAP (
		clk         		=> CLK_12M,
		reset_n     		=> RESET_N,
		strobe_i			=> top_strobe,
		adata_i				=> top_ADCDAT_pr,
		fdata_o				=> top_DACDAT_pr_fir
		);
		
		inst_i2s_master: i2s_master_top
		PORT MAP (
		CLOCK_12M				=> CLK_12M,	
		INIT_N					=> RESET_N,
		ADCDAT_s_i				=> ADCDAT_s_in,
		-- DACDAT_pl_i				=> top_DACDAT_pl_sig,
		-- DACDAT_pr_i				=> top_DACDAT_pr_sig,
		DACDAT_pl_i				=> top_ADCDAT_pl,
		DACDAT_pr_i				=> top_ADCDAT_pr,
		ADCDAT_pl_o				=> top_ADCDAT_pl,
		ADCDAT_pr_o				=> top_ADCDAT_pr,
		STROBE					=> top_strobe,
		DACDAT_s_o				=> DACDAT_s_out,
		BCLK_o					=> BCLK_out,
		WS							=> WS_out
		);
	  -- --------------------------------------------------
	  -- -- PROCESS FOR COMBINATORIAL LOGIC
	  -- --------------------------------------------------
	  -- comb_logic: PROCESS(FIR_ctrl_in,top_ADCDAT_pr,top_ADCDAT_pl,top_DACDAT_pl_fir,top_DACDAT_pr_fir)
	  -- BEGIN
			-- IF FIR_ctrl_in = '1' THEN
				-- top_DACDAT_pl_sig <= top_DACDAT_pl_fir;
				-- top_DACDAT_pr_sig <= top_DACDAT_pr_fir;
			-- ELSE
				-- top_DACDAT_pl_sig <= top_ADCDAT_pl;
				-- top_DACDAT_pr_sig <= top_ADCDAT_pr;
			-- END IF;
	  -- END PROCESS comb_logic; 
		
END struct;	