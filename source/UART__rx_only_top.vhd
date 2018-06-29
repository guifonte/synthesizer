LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY uart_rx_only_top IS
	PORT(
	CLOCK_50 :  	IN   STD_LOGIC;
	GPIO_1 :  		IN   STD_LOGIC_VECTOR(35 DOWNTO 0);
	KEY :   		IN   STD_LOGIC_VECTOR(3 DOWNTO 0);
	HEX0 :    		OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
	HEX1 :   	 	OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
	LEDR :  		OUT  STD_LOGIC_VECTOR(9 DOWNTO 0)
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
		clk,reset_n						: 	IN    std_logic;
		activator						: 	IN    std_logic;
		par_bit0_o, par_bit1_o			: 	OUT   std_logic_vector(3 downto 0);
		ser_i							: 	IN   	std_logic;
		led_o 							:  OUT	std_logic
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
	
	COMPONENT hex2sevseg
	PORT(
		hexa_i    						: 	IN   std_logic_vector(3 downto 0);  
		seg_o							: 	OUT  std_logic_vector(6 downto 0)
	);
	END COMPONENT;
	
	SIGNAL sync2fsm,sync2rx						: 	std_logic;
	SIGNAL tick_top,activator_top, halfsize_top	: 	std_logic;
	SIGNAL mod_clk								: 	std_logic;
	SIGNAL rx2hex1,rx2hex2	 					: 	std_logic_vector(3 downto 0);

	
	BEGIN
		inst_sync_n_edgeDetector: sync_n_edgeDetector
		PORT MAP( 
					data_in 		=>		GPIO_1(0),					
					clock			=>		mod_clk,
					reset_n			=>		KEY(0),	
					data_out		=>		sync2rx,	
					--rise   						 	
					fall     		=>		sync2fsm	
				);
					
		inst_modulo_divider : modulo_divider
		PORT MAP( 
					clk				=>		CLOCK_50,
					reset_n			=>		KEY(0),						
					clk_div     	=>		mod_clk					
				);
					
		inst_tick_generator : tick_generator
		PORT MAP(
					clk				=>		mod_clk,
					reset_n			=>		KEY(0),					
					ativo			=>		activator_top,					
					half			=> 		halfsize_top,
					tick_o     		=>		tick_top
				);
		
		inst_fsm : fsm
		PORT MAP (
					clk				=>		mod_clk,
					reset_n 		=>		KEY(0),					
					tick			=>		tick_top,
					fall 			=>		sync2fsm,	
					tick_halfsize	=> 		halfsize_top,
					tick_activator	=>		activator_top				
				);
					
		inst_rx_register_s2p : rx_register_s2p
		PORT MAP( 
					clk     		=>		mod_clk,
					reset_n			=>		KEY(0),		
					activator		=>		tick_top,
					par_bit0_o		=>		rx2hex1,
					par_bit1_o		=>		rx2hex2,
					ser_i			=>		sync2rx,	
					led_o			=>		LEDR(0)
				);
					
		inst_hex2sevseg_1 : hex2sevseg
		PORT MAP(
					hexa_i    		=> rx2hex1,
					seg_o			=>	HEX0			
				);	
		
		inst_hex2sevseg_2 : hex2sevseg
		PORT MAP(
					hexa_i    		=> rx2hex2,
					seg_o			=>	HEX1			
				);					
					
	END struct;