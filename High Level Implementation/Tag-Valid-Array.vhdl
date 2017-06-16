library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

---------------
entity tag_valid_array is
  port(
  clk: in std_logic;
  reset_n : in std_logic;
  address : in std_logic_vector(5 downto 0);
  wren,invalidate : in std_logic;
  wrdata : out std_logic_vector(3 downto 0)
  );
end tag_valid_array;
architecture description_tag_valid_array of tag_valid_array is
  type tags is array (63 downto 0) of std_logic_vector(4 downto 0);
  signal temp: tags := (others => "00000");
  begin
    process (clk)
    begin
      if rising_edge(clk) then
        if   (wren='1') then
          temp(to_integer(unsigned (address))) <= '1' & wrdata;
        elsif (invalidate='1') then
          temp(to_integer(unsigned (address)))(4) <= '0';
        elsif   (reset_n='1') then
        temp<=(others => "00000");
        end if;
      end if;
    end process;
  end description_tag_valid_array;
