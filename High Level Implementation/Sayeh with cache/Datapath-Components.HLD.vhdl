LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY instruction_register IS PORT(
clk,IRload : in std_logic;
 IRin : in std_logic_vector(15 downto 0);
 IRout : out std_logic_vector(15 downto 0)
);
END instruction_register;

ARCHITECTURE description_instruction_register OF instruction_register IS
BEGIN
process(clk)
begin
  if rising_edge(clk) and IRload='1' then
         IRout <= IRin;
       end if;
end process;
END description_instruction_register;
----------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY window_pointer IS PORT(
clk : in std_logic;
wp_in : in std_logic_vector(5 downto 0);
WPadd,WPreset : in std_logic;
wp_out : out std_logic_vector(5 downto 0)
);
END window_pointer;

ARCHITECTURE description_window_pointer OF window_pointer IS
    signal temp : std_logic_vector(5 downto 0);
BEGIN
process(clk)
begin
  if rising_edge(clk)then
    if(WPreset = '1') then
      temp <= "000000";
    elsif(WPadd = '1') then
      temp <= temp + wp_in;
    end if;
  end if;
end process;
wp_out <= temp;
END description_window_pointer;
-----------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;


ENTITY flags IS PORT(
clk : IN STD_LOGIC; -- clock.
Zin,Cin,CSet,CReset,ZSet,ZReset,SRload   : IN STD_LOGIC;
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
    end if;
    if (ZReset = '1') then
      Zout <= '0';
    elsif (ZSet = '1') then
      Zout <= '1';
    end if;
    if (CSet = '1') then
      Cout <= '1';
    elsif (CReset = '1') then
      Cout <= '0';
    end if;
  end if;
end process;
END description_flags;

-----------------------------------------------
