-------------------------------------------
-- Block code:  dacdat_sum.vhd
-- History: 	15.Jun.2018 - 1st version (Guifonte)
--                 
-- Function: Sums the exits of the dds
-------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  LIBRARY work;
  USE work.tone_gen_pkg.all;
  

entity dacdat_sum is
	port(
        dacdat_in       		    : in        NAUDIO_array_type;
        dacdat_sum_out              : out       std_logic_vector(N_AUDIO - 1 downto 0);
        strobe_in                   : in        std_logic;
        clk							: in        std_logic;
        reset_n                     : in        std_logic
	);
end entity;

architecture rtl of dacdat_sum is
	
    signal sum, next_sum				:   std_logic_vector(N_AUDIO - 1 downto 0);
    --signal temp_sum:   std_logic_vector(N_AUDIO - 1 downto 0);
    
begin

    sum_ff : PROCESS(clk, reset_n)
    begin
        if reset_n ='0' then
            sum     <=  (others=>'0');
        elsif rising_edge(clk) then
            sum  <=  next_sum;
        end if ;
    end process sum_ff;

    fsm_comb : process(all)
    begin
        next_sum  <=  sum;
		  --temp_sum <= (others=>'0');
		  
        if (strobe_in) then
            next_sum <= std_logic_vector(signed(dacdat_in(0))+signed(dacdat_in(1)) + signed(dacdat_in(2))+ signed(dacdat_in(3))+ signed(dacdat_in(4))+ signed(dacdat_in(5)) + signed(dacdat_in(6)) + signed(dacdat_in(7)) + signed(dacdat_in(8)) + signed(dacdat_in(9)));
            --sum_loop : for i in 0 to 9 loop
            --    temp_sum <= std_logic_vector(signed(dacdat_in(i)) + signed(temp_sum));
            --end loop sum_loop;
            --next_sum <= temp_sum;
        end if ;
    end process fsm_comb;

    dacdat_sum_out <= sum;

end rtl;