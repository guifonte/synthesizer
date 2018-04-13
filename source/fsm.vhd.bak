
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  LIBRARY work;
  USE work.reg_table_pkg.all


entity codec_control is
        port(
            clk         		: in    std_logic;
            reset_n     		: in    std_logic;

            write_done_i		: in    std_logic;
			event_control_i		: in	std_logic_vector(2 downto 0);
			
			initialize			: in	std_logic;
			ack_error_i			: in	std_logic;

			write_o 			: out 	std_logic;
			write_data_o		: out 	std_logic_vector(15 downto 0)
        );
end entity;

architecture rtl of codec_control is

constant reg_size	: natural := 7;

type t_fsm_states is (
    S_IDLE,
    S_START_WRITE,
    S_WAIT,
);

signal fsm_state, next_fsm_state	: t_fsm_states;
signal reg,next_reg					: integer;

--Begining architecture 

begin
	
	--Process that controls the state machine

	fsm: process(event_control_i,initialize,write_done_i, reg, fsm_state)
	begin

		variable last_reg 	: std_logic;

		--Default statement
		next_fsm_state <= fsm_state;
		next_reg <= reg;

		--Check if it's the last register to be written

		if(reg = 9) then
			last_reg <= '1';
		else
			last_reg <= '0';
		end if;

		--Changes states (moore machine)

		case fsm_state is
			when S_IDLE =>
				if (initialize = '1') then
					next_fsm_state 	<= S_IDLE;
				end if;
				if (initialize = '0') then
					next_fsm_state <= S_START_WRITE;
					next_reg <= (reg + 1) mod 10;
				end if;
			
			when S_START_WRITE =>
				next_fsm_state <= S_WAIT;


			when S_WAIT =>
				if (write_done_i = '1' and last_reg = '0') then
					next_fsm_state <= S_START_WRITE;
				elsif ((write_done_i = '1' and last_reg = '1') or (ack_error_i = '1')) then
					next_fsm_state <= S_IDLE;
				end if;
		end case;

	end process ; --fsm

	--Flip-flops process

	ff_process: process(clk,reset_n)
	begin
		if (reset_n = '0') then
			fsm_state 	<= S_IDLE;
			reg 		<= 0;
		elsif rising_edge(clk) then
			fsm_state <= next_fsm_state;
			reg <= next_reg;
		end if;

	end process; --ff_process(fsm_state, reg, event_control_i);

	-- Process that defines outputs

	outputs: process(fsm_state,reg, event_control_i)
		--Default statement
		write_o <= '0';
		write_data_o <= (others =>'0');


		case fsm_state is
			when S_IDLE =>
				write_o <= '0';
			when S_START_WRITE =>

				if (event_control_i = "000") then
					write_o <='1';
					write_data_o(15 downto 9) <= std_logic_vector(to_unsigned(reg));
					write_data_o(8 downto 0) <= C_W8731_ANALOG_BYPASS(reg);
				end if;

				if (event_control_i = "001") then
					write_o <='1';
					write_data_o(15 downto 9) <= std_logic_vector(to_unsigned(reg));
					write_data_o(8 downto 0) <= C_W8731_ANALOG_MUTE_LEFT(reg);
				end if;
				
				if (event_control_i = "010") then
					write_o <='1';
					write_data_o(15 downto 9) <= std_logic_vector(to_unsigned(reg));
					write_data_o(8 downto 0) <= C_W8731_ANALOG_MUTE_RIGHT(reg);
				end if;

				if (event_control_i = "010") then
					write_o <='1';
					write_data_o(15 downto 9) <= std_logic_vector(to_unsigned(reg));
					write_data_o(8 downto 0) <= C_W8731_ANALOG_MUTE_BOTH(reg);
				end if;

				if (event_control_i = "010") then
					write_o <='1';
					write_data_o(15 downto 9) <= std_logic_vector(to_unsigned(reg));
					write_data_o(8 downto 0) <= C_W8731_ADC_DAC_0DB_48K(reg);
				end if;

			when S_WAIT =>
				write_o <= '0';
		end case;

	end process ; -- outputsssss

end architecture;

