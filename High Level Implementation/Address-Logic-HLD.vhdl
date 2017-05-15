library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.std_logic_unsigned.all;
-----------------------------
entity address_logic is

  port (

    PCinput: in std_logic_vector(15 downto 0);
    Rside : in std_logic_vector(15 downto 0);
    IRinput : in std_logic_vector(7 downto 0);
      ResetPC : IN std_logic;
      PCplusI : IN std_logic;
       PCplus1 : IN std_logic;
       RplusI  : IN std_logic;
      Rplus0 : IN std_logic;
    adress : out std_logic_vector(15 downto 0)

  );

end address_logic;


architecture description_address_logic of address_logic is
begin

  process( ResetPC,PCplus1, RplusI,PCinput,PCplusI,  Rside, IRinput, Rplus0)
  begin
   if  RplusI and ResetPC and PCplus1 and  Rplus and RplusI and  PCplusI  then
     adress <= PCinput ;
   elsif ResetPC ='1'then
     adress <= x"F0";
   elsif PCplusI ='1'then
     adress <= PCinput + IRinput;
   elsif PCplus1 ='1'then
     adress <= PCinput + 1;
   elsif RplusI ='1'then
     adress <= Rside + IRinput;
   elsif Rplus0='1'then
     adress <= Rside;
  end if;

  end process;

end description_address_logic;
