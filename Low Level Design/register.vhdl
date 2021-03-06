LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY register16 IS PORT(
d   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
sinput  : IN STD_LOGIC; -- serila input.
sleft  : IN STD_LOGIC; -- shift left.
sright  : IN STD_LOGIC; -- shift right.
slogical  : IN STD_LOGIC; -- if 1 logical shift instead of circural shift.
ld  : IN STD_LOGIC; -- load/enable.
clr : IN STD_LOGIC; -- clear.
clk : IN STD_LOGIC; -- clock.
q   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) -- output
);
END register16;

ARCHITECTURE description_register16 OF register16 IS
singal temp : std_logic_vector(15 downto 0);
BEGIN
process(clk)
begin
  if rising_edge(clk)then
    if ld='1' then
      temp <= d;
      q <= d ;
    elsif sinput='1' then
      q <= temp(14 DOWNTO 0) & d(0);
    elsif clr='1' then
      q <= x"F0";
    elsif sleft='1' then
      q <= temp(14 DOWNTO 0) & temp(15);
      if slogical ='1' then
        q(0)<= '0';
      end if ;
    elsif sright='1' then
      q <=   temp(0) & temp(15 DOWNTO 1) ;
      if slogical ='1' then
        q(15)<= '0';
      end if ;
    end if;

  end if;
end process;
END description_register16;






ENTITY window_pointer IS PORT(
wp_in : in std_logic_vector(5 downto 0);
WPadd,WPreset,clk : in std_logic;
wp_out : out std_logic_vector(5 downto 0)
);
END window_pointer;

ARCHITECTURE description_window_pointer OF window_pointer IS
singal temp : std_logic_vector(5 downto 0);
BEGIN
process(clk)
begin
  if rising_edge(clk)then
    if(WPreset = '1') then
      temp <= x"F0";
    elsif(WPadd = '1') then
      temp <= temp + wp_in;
    end if;
  end if;
end process;
END description_window_pointer;
-----------------------------------------

ENTITY flags IS PORT(
Zin,Cin,CSet,CReset,ZSet,ZReset,SRload   : IN STD_LOGIC;
clk : IN STD_LOGIC; -- clock.
Cout,Zout   : OUT STD_LOGIC -- output
);
END flags;

ARCHITECTURE description_flags OF flags IS

BEGIN
process(clk)
begin
  if rising_edge(clk)then
    if (SRload = '1') then
      Cout <= Cin;
      Zout <= Zin;
    elsif (ZReset = '1') then
      Zout <= '0';
    elsif (ZSet = '1') then
      Zout <= '1';
    elsif (CSet = '1') then
      Cout <= '1';
    elsif (CReset = '1') then
      Cout <= '0';
    end if;
  end if;
end process;
END description_flags;

-----------------------------------------------
