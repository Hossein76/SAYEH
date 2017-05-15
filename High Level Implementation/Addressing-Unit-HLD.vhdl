library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
---------------
entity addressing_unit is

  port (
  Rside : in std_logic_vector (15 DOWNTO 0);
  IRinput : in std_logic_vector (7 DOWNTO 0);
  clk: in std_logic;
  ResetPC: in std_logic;
  PCplusI: in std_logic;
  PCplus1 : in std_logic;
  RplusI: in std_logic;
  Rplus0: in std_logic;
  pc_enabled : in std_logic;
  adress : OUT std_logic_vector (15 DOWNTO 0)
  );

end addressing_unit;
architecture description_addressing_unit of addressing_unit is

  component adress_logic is
    port (
    PCinput: in std_logic_vector(15 downto 0);
    Rside : in std_logic_vector(15 downto 0);
    IRinput : in std_logic_vector(7 downto 0);
    ResetPC : in std_logic;
    PCplusI : in std_logic;
    PCplus1 : in std_logic;
    RplusI  : in std_logic;
    Rplus0 : in std_logic;
    adress : out std_logic_vector(15 downto 0)
    );

  end component;


  component register16 is
    port (
    d   : in STD_LOGIC_VECTOR(15 DOWNTO 0);
    sinput  : in std_logic; -- serila input.
    sleft  : in std_logic; -- shift left.
    sright  : in std_logic; -- shift right.
    slogical  : in std_logic; -- if 1 logical shift instead of circural shift.
    ld  : in std_logic; -- load/enable.
    clr : in std_logic; -- clear.
    clk : in std_logic; -- clock.
    q   : OUT std_logic_vector(15 DOWNTO 0) -- output
    );
  end component;
  singal pcout : std_logic_vector (15 DOWNTO 0);
  singal final_address : std_logic_vector (15 DOWNTO 0);
  begin
    PC : register16 port map (final_address, '0', '0', '0','0',pc_enabled,ResetPC,clk,pcout);
    AL : AddressLogic port map (pcout, Rside, IRinput, final_address,ResetPC, PCplusI, PCplus1, RplusI, Rplus0);
    address <= final_address;
  end description_addressing_unit;
