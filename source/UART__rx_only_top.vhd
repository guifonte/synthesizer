LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY uart_rx_only_top IS
	PORT(
	CLOCK_50 :  	IN   STD_LOGIC;
	RESET_N :		IN 	 STD_LOGIC;
	GPIO_1 :  		IN   STD_LOGIC;
	LED_O 	:		OUT  STD_LOGIC;
	DATA_VALID_O :	OUT  STD_LOGIC;
	DATA_O :		OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END uart_rx_only_top;


ARCHITECTURE struct OF uart_rx_only_top IS

	COMPONENT tick_generator
	PORT(
	clk,reset_n						: IN    	std_logic; 		
		ativo						: IN		std_logic; --continuos signal to set the working of the down counter
		half						: IN		std_logic;
    	tick_o     					: OUT   	std_logic
	);
	END COMPONENT;
	
	COMPONENT fsm
	PORT (
		clk,reset_n 				:	IN std_logic;
		tick, fall 					:	IN std_logic;
		tick_halfsize 				:	OUT std_logic;
		tick_activator				:	OUT std_logic
	);
	END COMPONENT;
	
	COMPONENT modulo_divider
	PORT( 
		clk,reset_n						:	IN    std_logic;
		clk_div     					: 	OUT   std_logic
	);
	END COMPONENT;
	
	COMPONENT rx_register_s2p
	PORT( 
		clk,reset_n: 						IN    std_logic;			-- Attention, this block has a set_n input for initialisation!!
  		activator: 								IN    std_logic;
  		midi_o: 			            OUT   std_logic_vector(7 downto 0);
  		data_valid_out:           OUT   std_logic;
     	led_o:                    OUT   std_logic;
    	ser_i: 									  IN   	std_logic
	);
	END COMPONENT;
	
	COMPONENT sync_n_edgeDetector
	PORT( 
		data_in 						:	IN    std_logic;
		clock							:	IN    std_logic;
		reset_n							:	IN    std_logic;
		data_out						:	OUT	std_logic; 
		rise   						 	:	OUT   std_logic;
		fall     						:	OUT   std_logic
	);
	END COMPONENT;

	
	SIGNAL sync2fsm,sync2rx						: 	std_logic;
	SIGNAL tick_top,activator_top, halfsize_top	: 	std_logic;
	SIGNAL mod_clk								: 	std_logic;

	
	BEGIN
		inst_sync_n_edgeDetector: sync_n_edgeDetector
		PORT MAP( 
					data_in 		=>		GPIO_1,					
					clock			=>		mod_clk,
					reset_n			=>		RESET_N,	
					data_out		=>		sync2rx,	
					--rise   						 	
					fall     		=>		sync2fsm	
				);
					
		inst_modulo_divider : modulo_divider
		PORT MAP( 
					clk				=>		CLOCK_50,
					reset_n			=>		RESET_N,						
					clk_div     	=>		mod_clk					
				);
					
		inst_tick_generator : tick_generator
		PORT MAP(
					clk				=>		mod_clk,
					reset_n			=>		RESET_N,					
					ativo			=>		activator_top,					
					half			=> 		halfsize_top,
					tick_o     		=>		tick_top
				);
		
		inst_fsm : fsm
		PORT MAP (
					clk				=>		mod_clk,
					reset_n 		=>		RESET_N,					
					tick			=>		tick_top,
					fall 			=>		sync2fsm,	
					tick_halfsize	=> 		halfsize_top,
					tick_activator	=>		activator_top				
				);
					
		inst_rx_register_s2p : rx_register_s2p
		PORT MAP( 
					clk 			=>		mod_clk,
					reset_n 		=>		RESET_N,
					activator 		=> 		tick_top,
					midi_o			=> 		DATA_O,
					data_valid_out 	=> 		DATA_VALID_O,
					ser_i	 		=>		sync2rx,
					led_o 			=> 		LED_O
				);
					
					
	END struct;