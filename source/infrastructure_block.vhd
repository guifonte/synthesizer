-------------------------------------------
-- Block code:  infrastructure_block.vhd
-- History: 	12.Apr.2018 - 1st version (guifonte)
--                 <date> - <changes>  (<author>)
-- Function: Top for an infrastructure block that has a clock divisor
--				 and as many buttons synchronizers as wanted.
--           
-------------------------------------------

-- Library & Use Statements
LIBRARY ieee;
use ieee.std_logic_1164.all;

-- Entity Declaration 
ENTITY infrastructure_block IS
	PORT(
	clk_50M  		:  IN   STD_LOGIC;
	button_1			:  IN   STD_LOGIC;
	button_2			:  IN   STD_LOGIC;
	clk_12M			:	OUT  STD_LOGIC;
	button_1sync	:	OUT  STD_LOGIC;
	button_2sync	:	OUT  STD_LOGIC
	);
END infrastructure_block ;

-- Architecture Declaration 
ARCHITECTURE struct OF infrastructure_block IS

	COMPONENT takt_teiler
	PORT(
		clk_fast_i		: IN    std_logic;
		clk_slow_o     : OUT   std_logic
	);
	END COMPONENT;
	
	COMPONENT sync_block
	PORT(
		async_i 			: IN    std_logic;
		clk				: IN    std_logic;
		syncd_o			: OUT	  std_logic 
	);
	END COMPONENT;
	
	SIGNAL clk_12M_sig	:	std_logic;
	
	BEGIN
		inst_takt_teiler: takt_teiler
		PORT MAP(
					clk_fast_i	=> clk_50M;
					clk_slow_o  =>	clk_12M
					);
					
		inst_sync_block_1: sync_block
		PORT MAP(
					async_i	=>	button_1;
					clk 		=> clk_12M;
					syncd_o  =>	button_1sync
					);
	
		inst_sync_block_2: sync_block
		PORT MAP(
					async_i	=>	button_2;
					clk 		=> clk_12M;
					syncd_o  =>	button_2sync
					);
END struct;	
