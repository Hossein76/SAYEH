library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

---------------
entity data_array is
  port(
  clk: in std_logic;
  address : in std_logic_vector(5 downto 0);
  wren : in std_logic;
  wrdata : in std_logic_vector(15 downto 0);
  data : out std_logic_vector(15 downto 0)
  );
end data_array;
architecture description_data_array of data_array is
  type tags is array (63 downto 0) of std_logic_vector(15 downto 0);
  signal temp: tags := (others => x"0000");
  begin
    data <= temp(to_integer(unsigned(address)));
    process (clk)
    begin
      if rising_edge(clk) then
        if   (wren='1') then
          temp(to_integer(unsigned (address))) <= wrdata;
        end if;
      end if;
    end process;
  end description_data_array;
