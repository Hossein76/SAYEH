library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
---------------
entity register_file is
  port(
  clk: in std_logic;
  data_in : in std_logic_vector(15 downto 0);
  window_pointer : in std_logic_vector(5 downto 0);
  selector : in std_logic_vector(3 downto 0);
  RFLwrite,RFHwrite : in std_logic;
  Rs,  Rd : out std_logic_vector(15 downto 0)
  );
end register_file;
architecture description_register_file of register_file is
  type registers is array (63 downto 0) of std_logic_vector(15 downto 0);
  signal temp: registers := (others => (x"F0")+2);
  begin
    Rd <= temp(to_integer(unsigned(std_logic_vector(unsigned(window_pointer) + (unsigned (selctor(3 downto 2)))))));
    Rs <= temp(to_integer(unsigned(std_logic_vector(unsigned(window_pointer) + (unsigned (selctor(1 downto 0)))))));
    process (clk)
    begin
      if rising_edge(clk) then
        if   (RFHWrite = '1' and RFLwrite = '1') then
          temp(to_integer (unsigned (window_pointer)) + to_integer (unsigned (selector(3 downto 2)))) <= data_in;
        elsif (RFHWrite = '1' and RFLwrite = '0') then
          temp(  to_integer (unsigned (selector(3 downto 2)))+to_integer (unsigned (window_pointer)))(7 downto 0) <= x"F0";
          temp(to_integer (unsigned (window_pointer)) + to_integer (unsigned (selector(3 downto 2))))(15 downto 8) <= data_in(7 downto 0);
        elsif   (RFLwrite = '1' and RFHWrite = '0' ) then
          temp(  to_integer (unsigned (selector(3 downto 2))) + to_integer (unsigned (window_pointer)))(7 downto 0) <= data_in(7 downto 0);
          temp(  to_integer (unsigned (window_pointer)) + to_integer (unsigned (selector(3 downto 2))))(15 downto 8) <= x"F0";
        end if;
      end if;
    end process;
  end description_register_file;
