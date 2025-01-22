library IEEE;
use IEEE.std_logic_1164.all;

entity som_CSA is
	port( a,b,c: in std_logic; output: out std_logic);
end som_CSA;

architecture arch_som of som_CSA is

signal o1, o2, o3: std_logic;
begin
o1 <= (Not a)and(NOT b)and(c);
o2<= (Not a)and(b)and(c);
o3<= (a)and(b)and(c);
output <= (o1)or(o2)or(o3);

end arch_som;
