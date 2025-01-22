library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;


--D_FF with reset
entity D_FF is
port(
clk : in std_logic;
reset: in std_logic;
d: in std_logic_vector(3 downto 0);
q: out std_logic_vector(3 downto 0));
end D_FF;

--architecture D_FF
architecture arch_D_FF of D_FF is
begin
        process(clk,
reset)
        begin
        if(reset='1') then
                q<="1000";
        elsif (clk'event and clk='1') then
                q<=d;
        end if;
        end process;
end arch_D_FF;


---------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
--D_FF_load MAXIMUM
entity D_FF_load_max is
port(
clk: in std_logic;
ld,reset : in std_logic;
d: in std_logic_vector(3 downto 0);
q: out std_logic_vector(3 downto 0));
end D_FF_load_max;

--architecture D_FF_load
architecture arch_D_FF_load_max of D_FF_load_max is
begin
        process(clk, reset)
        begin
        if(reset ='1') then
                q<="0000"; --resets to lowest value 0
        elsif(ld='1'and clk'event and clk='0')then
                q<=d;
        end if;
        end process;
end arch_D_FF_load_max;
---------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
--D_FF_load MINIMUM
entity D_FF_load_min is
port(
clk: in std_logic;
ld,reset : in std_logic;
d: in std_logic_vector(3 downto 0);
q: out std_logic_vector(3 downto 0));
end D_FF_load_min;

--architecture D_FF_load
architecture arch_D_FF_load_min of D_FF_load_min is
begin
        process(reset, clk)
        begin
        if(reset ='1') then
                q<="1111"; --resets to max value 15
        elsif(ld='1'and clk'event and clk='0')then
                q<=d;
        end if;
        end process;
end arch_D_FF_load_min;
---------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

--combinational_min_max
entity combinational_min_max is
port(
clk : in std_logic;
din0: in std_logic_vector(3 downto 0);
din1: in std_logic_vector(3 downto 0);
din2: in std_logic_vector(3 downto 0);
din3: in std_logic_vector(3 downto 0);
max_out : out std_logic_vector(3 downto 0);
min_out : out std_logic_vector(3 downto 0);
reg_out : out std_logic_vector(3 downto 0));
end combinational_min_max ;

--architecture combinational_min_max
architecture arch_combinational_min_max of combinational_min_max is
signal bigger1,bigger2,smaller1,smaller2: std_logic_vector(3 downto 0);--,biggest,smallest
begin
        process(clk)--din3, din2, din1, din0
        begin
                 if (clk'event and clk='1') then--clk ='0'
                        if(unsigned(din0)<unsigned(din1)) then
                                bigger1<=din1;
                                smaller1<=din0;
                        else
                                bigger1<= din0;
                                smaller1<=din1;
                        end if;
                        if(unsigned(din2)<unsigned(din3)) then
                                bigger2<=din3;
                                smaller2<=din2;
                        else
                                bigger2<= din2;
                                smaller2<=din3;
                        end if;
                        if(unsigned(bigger1)<unsigned(bigger2)) then
                                max_out<=bigger2;
                        else
                                max_out<=bigger1;
                        end if;
                        if(unsigned(smaller1)<unsigned(smaller2)) then
                                min_out<=smaller1;
                        else
                                min_out<=smaller2;
                        end if;
                end if;
        end process;

end arch_combinational_min_max;
------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
--MUX4to1
entity MUX4to1 is
port(
sel: in std_logic_vector(1 downto 0);
a,b,c,d: in std_logic_vector(3 downto 0);
output: out std_logic_vector(3 downto 0));
end MUX4to1;

--architecture MUX4to1
architecture arch_MUX4to1 of MUX4to1 is
begin
        process(sel)
        begin
                if(sel="00") then
                        output<=a;
                elsif(sel="01") then
                        output<=b;
                elsif(sel="10") then
                        output<=c;
                else
                        output<=d;
                end if;
        end process;
end arch_MUX4to1;


------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

--comparator BIGGEST
entity comparatorB is
port(
in0,in1: in std_logic_vector(3 downto 0); --in0 is the number already in load register/ in1 output from comb_max_min
outForLoad: out std_logic
);
end comparatorB;

--architecture comparator
architecture arch_comparatorB of comparatorB is
begin
        process(in1)
        begin
                if(unsigned(in0)<unsigned(in1)) then
                        outForLoad<='1';
                else
                        outForLoad<='0';
                end if;
        end process;


end arch_comparatorB;
------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

--comparator SMALLEST
entity comparatorS is
port(
in0,in1: in std_logic_vector(3 downto 0); --in0 is the number already in load register/ in1 output from comb_max_min
outForLoad: out std_logic
);
end comparatorS;

--architecture comparator
architecture arch_comparatorS of comparatorS is
begin
        process(in1)
        begin
                if(unsigned(in0)>unsigned(in1)) then
                        outForLoad<='1';
                else
                        outForLoad<='0';
                end if;
        end process;


end arch_comparatorS;

---------------------------------------------------------------------------------------SUM OF ALL PARTS----------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

-- entity registers_min_max
entity registers_min_max is
port(
din :in std_logic_vector(3 downto 0);
sel: in std_logic_vector(1 downto 0);
clk, reset: in std_logic;
reg_out: out std_logic_vector(3 downto 0);
outputMAX: out std_logic_vector(3 downto 0);
outputMIN: out std_logic_vector(3 downto 0)
);
end registers_min_max;

-- architecture registers_min_max
architecture arch_registers_min_max of registers_min_max is

signal  reg0output, reg1output, reg2output,reg3output, minimum, maximum,minimum_output, maximum_output: std_logic_vector(3 downto 0);
signal  loadSignal0, loadSignal1: std_logic;

begin

shift_reg0: entity work.D_FF port map(d=>din,clk=>clk, reset=>reset,q=>reg0output);
shift_reg1: entity work.D_FF port map(d=>reg0output,clk=>clk, reset=>reset,q=>reg1output);
shift_reg2: entity work.D_FF port map(d=>reg1output,clk=>clk, reset=>reset,q=>reg2output);
shift_reg3: entity work.D_FF port map(d=>reg2output,clk=>clk, reset=>reset,q=>reg3output);
mux: entity work.MUX4to1 port map(a=>reg0output, b=> reg1output, c=>reg2output,d=> reg3output, sel=>sel,output => reg_out);
min_max: entity work.combinational_min_max port map(clk=>clk,din0=>reg0output,din1=>reg1output,din2=>reg2output,din3=>reg3output,min_out =>minimum ,max_out =>maximum );

ld_reg0: entity work.D_FF_load_max port map(clk=>clk,d=>maximum,ld=>loadSignal0,q=>maximum_output, reset => reset);--max
ld_reg1: entity work.D_FF_load_min port map(clk=>clk,d=>minimum,ld=>loadSignal1,q=>minimum_output, reset => reset);--min

cmp0: entity work.comparatorB port map(in0=>maximum_output,in1=>maximum,outForLoad=>loadSignal0);--max
cmp1: entity work.comparatorS port map(in0=>minimum_output,in1=>minimum,outForLoad=>loadSignal1);--min


outputMAX<=maximum_output;
outputMIN<=minimum_output;

end arch_registers_min_max;
