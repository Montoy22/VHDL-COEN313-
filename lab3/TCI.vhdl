library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity converter is
port( sign_mag : in std_logic_vector(3 downto 0) ;
twos_comp : out std_logic_vector(3 downto 0) );
end converter;

architecture arch_converter of converter is
begin
	process(sign_mag)
		variable negated_sign_mag, three_bit_two_comp: std_logic_vector(2 downto 0);
		variable sign_input: std_logic;	
	begin
		sign_input := sign_mag(3);
		if(sign_input = '0') then--positive number
			twos_comp <= sign_mag;
		else
			negated_sign_mag := NOT sign_mag(2 downto 0);
			three_bit_two_comp := std_logic_vector(to_unsigned(to_integer(unsigned(negated_sign_mag))+1,3));
			twos_comp <= sign_input & three_bit_two_comp(2 downto 0);
		end if;

	end process;
	
end arch_converter;

