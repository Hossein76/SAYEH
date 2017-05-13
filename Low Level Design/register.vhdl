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

BEGIN
    process(clk)
    begin
      if rising_edge(clk)then
        if ld='1' then
           q <= d ;
        elsif sinput='1' then
           q <= q(14 DOWNTO 0) or d(0);
        elsif clr='1' then
          q <= x"F0";
        elsif sleft='1' then
          q <= q(14 DOWNTO 0) & q(15);
          if slogical ='1' then
            q(0)<= '0';
          end if ;
        elsif sright='1' then
          q <=   q(0) & q(15 DOWNTO 1) ;
          if slogical ='1' then
            q(15)<= '0';
          end if ;
        end if;

      end if;
    end process;
END description_register16;






ENTITY register6 IS PORT(
    d   : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
    sinput  : IN STD_LOGIC; -- serila input.
    sleft  : IN STD_LOGIC; -- shift left.
    sright  : IN STD_LOGIC; -- shift right.
    slogical  : IN STD_LOGIC; -- if 1 logical shift instead of circural shift.
    ld  : IN STD_LOGIC; -- load/enable.
    clr : IN STD_LOGIC; -- clear.
    clk : IN STD_LOGIC; -- clock.
    q   : OUT STD_LOGIC_VECTOR(5 DOWNTO 0) -- output
);
END register6;

ARCHITECTURE description_register6 OF register6 IS

BEGIN
    process(clk)
    begin
      if rising_edge(clk)then
        if ld='1' then
           q <= d ;
        elsif sinput='1' then
           q <= q(4 DOWNTO 0) or d(0);
        elsif clr='1' then
          q <= "000000";
        elsif sleft='1' then
          q <= q(4 DOWNTO 0) & q(5);
          if slogical ='1' then
            q(0)<= '0';
          end if ;
        elsif sright='1' then
          q <=   q(0) & q(5 DOWNTO 1) ;
          if slogical ='1' then
            q(5)<= '0';
          end if ;
        end if;

      end if;
    end process;
END description_register6;


ENTITY register1 IS PORT(
    d   : IN STD_LOGIC;
    ld  : IN STD_LOGIC; -- load/enable.
    clr : IN STD_LOGIC; -- clear.
    clk : IN STD_LOGIC; -- clock.
    q   : OUT STD_LOGIC -- output
);
END register1;

ARCHITECTURE description_register1 OF register1 IS

BEGIN
    process(clk)
    begin
      if rising_edge(clk)then
        if ld='1' then
           q <= d ;
        elsif clr='1' then
          q <= "0";
      end if;
    end if;
    end process;
END description_register1;
