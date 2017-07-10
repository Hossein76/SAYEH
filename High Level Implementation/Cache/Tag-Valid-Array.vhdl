library ieee;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;


---------------
entity tag_valid_array is
  port(
  clk: in std_logic;
  reset_n : in std_logic;
  address : in std_logic_vector(5 downto 0);
  wren,invalidate : in std_logic;
  wrdata : in std_logic_vector(3 downto 0);
  output_signal : out std_logic_vector(4 downto 0)
  );
end tag_valid_array;
architecture description_tag_valid_array of tag_valid_array is
  type tags is array (0 to 63) of std_logic_vector(4 downto 0);
  signal temp: tags := (others => "00000");
  begin
    process (clk)
    variable init : boolean := true;
    begin
      if init = true then
        temp(0) <= "10000";
        temp(1) <= "10000";
        temp(2) <= "10000";
        temp(3) <= "10000";
        init := false;
      end if;
      if rising_edge(clk) then
        if   (wren='1') then
          temp(to_integer(unsigned (address))) <= '1' & wrdata;
        elsif (invalidate='1') then
             temp(to_integer(unsigned (address)))(4) <= '0' ;
        elsif   (reset_n='1') then
        temp<=(others => "00000");
        end if;
        output_signal <= temp(to_integer(unsigned(address)));
      end if;
    end process;
  end description_tag_valid_array;
