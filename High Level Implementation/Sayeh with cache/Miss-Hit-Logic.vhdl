library ieee;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;


---------------
entity miss_hit_logic is
  port(
  tag : in std_logic_vector(9 downto 0);
  w0,w1 : in std_logic_vector(10 downto 0);
  hit : out std_logic;
  w0_valid,w1_valid : out std_logic
  );
end miss_hit_logic;
architecture description_miss_hit_logic of miss_hit_logic is

  begin
    process (tag,w0,w1)
    begin
    if (w0(9 downto 0)=tag) and w0(10)='1' and (w1(9 downto 0)=tag) and  w1(10)='1' then
      hit<='1';
      w0_valid<='1';
      w1_valid<='1';
    elsif (w0(9 downto 0)=tag) and  w0(10)='1'then
      hit<='1';
      w0_valid<='1';
      w1_valid<='0';
    elsif (w1(9 downto 0)=tag) and  w1(10)='1'then
      hit<='1';
      w1_valid<='1';
      w0_valid<='0';
    else
      hit<='0';
      w0_valid<='0';
      w1_valid<='0';
    end if;
    end process;
  end description_miss_hit_logic;
