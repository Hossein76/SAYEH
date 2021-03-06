library ieee;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;


---------------
entity most_recently_used_array  is
  port (
  clk : in std_logic;
  address : in std_logic_vector(5 downto 0);
  hit , w0_valid,w1_valid ,access_signal: in std_logic ;
  wreplace : in std_logic_vector(1 downto 0);
  way_select : out std_logic
  );
end most_recently_used_array;

architecture description_mru of most_recently_used_array is

  type useage is array (0 to 63) of integer;
  signal w0_useage : useage := (others => 0);
  signal w1_useage : useage := (others => 0);

  begin

    process(clk)
    begin
      if rising_edge(clk)  then

        if ( hit='1' and access_signal= '1' )then
          if(w0_valid = '1') then
            w0_useage(to_integer(unsigned(address))) <= w0_useage(to_integer(unsigned(address))) + 1;
          elsif (w1_valid = '1') then
            w1_useage(to_integer(unsigned(address))) <= w1_useage(to_integer(unsigned(address))) + 1;
          end if;
        elsif (wreplace="10")then
          w0_useage(to_integer(unsigned(address))) <= w0_useage(to_integer(unsigned(address))) + 1;
        elsif (wreplace="11")then
          w1_useage(to_integer(unsigned(address))) <= w1_useage(to_integer(unsigned(address))) + 1;
        end if ;
        if(w0_useage(to_integer(unsigned(address))) > w1_useage(to_integer(unsigned(address)))) then
          way_select <= '0';
        else
          way_select <= '1';
        end if;
      end if;
    end process;
  end description_mru;
