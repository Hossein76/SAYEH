library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;
----------------------------------
package ports_list is
    type portarray is array(63 downto 0) of std_logic_vector (15 downto 0);
end package ports_list;

entity port_manager is
    port
    (
    ReadPort,WritePort : in  std_logic;
    PortNumber : in std_logic_vector(5 downto 0);
    ports        : inout portarray;
    Rs     : in std_logic_vector(15 downto 0)
    Rd     : out std_logic_vector(15 downto 0)
    );
end port_manager;
architecture description_port_manager of port_manager is
  begin
process(ReadPort,WritePort,PortNumber)
begin
    Rd<=open;
   if ReadPort ='1' and WritePort ='0'then
       Rd <= ports(to_integer(unsigned(PortNumber)));
   elsif  ReadPort ='0' and WritePort ='1' then
         ports(to_integer(unsigned(PortNumber)))<= Rs;
 end if;
end process;
  end description_port_manager;
