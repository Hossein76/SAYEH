library ieee;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;


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
  type tags is array (0 to 63) of std_logic_vector(15 downto 0);
  signal temp: tags := (others => x"0000");
  begin

    process (clk)
    variable init : boolean := true;
    begin
      if init = true then
        temp(0) <= x"9354";
        temp(1) <= x"2845";
        temp(2) <= x"6739";
        temp(3) <= x"1223";
        init := false;
      end if;

      if rising_edge(clk) then
        if   (wren='1') then
          temp(to_integer(unsigned (address))) <= wrdata;
        end if;
          data <= temp(to_integer(unsigned(address)));
      end if;
    end process;
  end description_data_array;
