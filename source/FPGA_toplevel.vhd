-------------------------------------------
-- Block code:  infrastructure_block.vhd
-- History: 	12.Apr.2018 - 1st version (guifonte)
--                 <date> - <changes>  (<author>)
-- Function: Top for an infrastructure block that has a clock divisor
--				buttons synchronizers, a Codec Controller and a I2C master.
--           
-------------------------------------------

-- Library & Use Statements
LIBRARY ieee;
use ieee.std_logic_1164.all;

-- Entity Declaration 
ENTITY infrastructure_block IS
	PORT(
	clk_50M  		: 	 IN			STD_LOGIC;
	button_1		:	 IN			STD_LOGIC;
	button_2		: 	 IN			STD_LOGIC;
	event_control	:	 IN			std_logic_vector(2 downto 0);

	clk_12M			:	BUFFER		STD_LOGIC;
	button_1sync	:	BUFFER		STD_LOGIC; --reset
	button_2sync	:	BUFFER		STD_LOGIC; --initialize
	write_done		: 	BUFFER		STD_LOGIC;
	ack_error		: 	BUFFER		STD_LOGIC;
	write_			: 	BUFFER 		STD_LOGIC;
	write_data		: 	BUFFER 		std_logic_vector(15 downto 0)

	sda 			:	INOUT 		STD_LOGIC;
	scl 			:	OUT 		STD_LOGIC
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
		clk					: IN    std_logic;
		syncd_o				: OUT	  std_logic 
	);
	END COMPONENT;	

	COMPONENT codec_control 
    PORT(
        clk         		: in    std_logic;
        reset_n     		: in    std_logic;

        write_done_i		: in    std_logic;
		event_control_i		: in	std_logic_vector(2 downto 0);
		
		initialize			: in	std_logic;
		ack_error_i			: in	std_logic;

		write_o 			: out 	std_logic;
		write_data_o		: out 	std_logic_vector(15 downto 0)
    );
	END COMPONENT;
	

	COMPONENT i2c_master
    PORT(
        clk         		: in    std_logic;
        reset_n     		: in    std_logic;
		
        write_i     		: in    std_logic;
		write_data_i		: in	std_logic_vector(15 downto 0);
				
		sda_io				: inout	std_logic;
		scl_o				: out   std_logic;
				
		write_done_o		: out	std_logic;
		ack_error_o			: out	std_logic
    );
	END COMPONENT;
	
	BEGIN
		inst_takt_teiler: takt_teiler
		PORT MAP(
					clk_fast_i	=> clk_50M,
					clk_slow_o  =>	clk_12M
					);
					
		--button1 =  reset
		inst_sync_block_1: sync_block
		PORT MAP(
					async_i		=>	button_1,
					clk 		=> clk_12M,
					syncd_o 	=>	button_1sync
					);
		
		-- button2 = initialize
		inst_sync_block_2: sync_block
		PORT MAP(
					async_i		=>	button_2,
					clk 		=> clk_12M,
					syncd_o 	=>	button_2sync
					);	

		inst_codec_control: codec_control
		PORT MAP (
			clk    				=> clk_12M,
	        reset_n     		=> button_1sync,

	        write_done_i		=> write_done,
			event_control_i		=> event_control,
	
			initialize			=> button_2sync,
			ack_error_i			=> ack_error,

			write_o 			=> write_,
			write_data_o		=> write_data

		);

		inst_i2c_master: i2c_master
		PORT MAP (
			clk    				=> clk_12M,
	        reset_n     		=> button_1sync,

	        write_i     		=> write_,
			write_data_i		=> write_data,
			
			sda_io				=> sda,
			scl_o				=> scl,
			
			write_done_o		=> write_done,
			ack_error_o			=> ack_error

		);
		
END struct;	
