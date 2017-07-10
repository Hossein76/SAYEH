library ieee;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;


---------------
entity data_selection is
  port(
  w0_valid,w1_valid : in std_logic;
  w0_data_in,w1_data_in : in std_logic_vector(15 downto 0);
  out_put : out std_logic_vector(15 downto 0)
  );
end data_selection;

architecture description_data_selection of data_selection is
  begin
    process(w0_valid,w1_valid,w0_data_in,w1_data_in) begin
   if(w0_valid = '1') then
    out_put <= w0_data_in;
  elsif (w1_valid='1') then
    out_put <= w1_data_in;
  else
  out_put <= "ZZZZZZZZZZZZZZZZ";
end if;
end process;
end description_data_selection ;
