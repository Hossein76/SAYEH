library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;

entity ALU is  port (Rs : in std_logic_vector(15 downto 0); ---source Register
Rd : in std_logic_vector(15 downto 0);--- destination register
carryFlagIn : in std_logic;   --- we get the carry
opcode : in std_logic_vector(3 downto 0); --- we get the opcode to know what to do
Result : out std_logic_vector(15 downto 0);  ---- result of alu
carryFlagOut : out std_logic; ----- we set the carry
zeroFlag : out std_logic);  ----- we set the zero flag
end  ALU;


architecture description_ALU of ALU is
  signal result : std_logic_vector(16 downto 0);
  signal Rs_temp :  std_logic_vector(16 downto 0);
  signal Rd_temp :  std_logic_vector(16 downto 0);

  begin

    process (Rd, Rs, opcode, carryFlagIn)

    begin
      if opcode = "0000" then  -- and component
      Result <= Rd and Rs;
      carryFlagOut <= '0';
      zeroFlag<='0';
    elsif opcode = "0001" then  --- or component
    Result <= Rd or Rs;
    carryFlagOut <= '0';
    zeroFlag<='0';
  elsif opcode = "0010"  then ----xor component
  Result <= Rd xor Rs;
  carryFlagOut <= '0';
  zeroFlag<='0';
elsif opcode = "0011" then ----- 2' complement component
Result <=((not Rs)+'1');
carryFlagOut <= '0';
if ((not Rs)+'1')=x"F0" then
  zeroFlag <='1';
else
  zeroFlag<= '0';
end if ;

elsif opcode = "0100" then ----- addition_component
Rd_temp(15 downto 0)<= Rd;
Rs_temp(15 downto 0)<= Rs;
Rs_temp(16)<= '0';
Rd_temp(16)<= '0';

result <=  Rd_temp+Rs_temp+carryFlagIn;
carryFlagOut <= result(16);
Result<= result(15 downto 0);
if result(15 downto 0)=x"F0" then
  zeroFlag <='1';
else
  zeroFlag<= '0';
end if ;

elsif opcode = "0101" then ----- subtraction_component
Rd_temp(15 downto 0)<= Rd;
Rs_temp(15 downto 0)<= Rs;
Rs_temp(16)<= '0';
Rd_temp(16)<= '0';
result <=(not(Rs+carryFlagIn))+'1'+ Rd;
carryFlagOut <= result(16);
Result<= result(15 downto 0);
if result(15 downto 0)=x"F0" then
  zeroFlag <='1';
else
  zeroFlag<= '0';
end if ;

elsif opcode = "0110" then ----- MULTIPLICATION_component

carryFlagOut <= '0';
Result<=  Rs(7 DOWNTO 0) * Rd(7 DOWNTO 0);
if  Rs(7 DOWNTO 0) * Rd(7 DOWNTO 0)=x"F0" then
  zeroFlag <='1';
else
  zeroFlag<= '0';
end if ;

elsif opcode = "0111" then ----- division_component

carryFlagOut <= '0';
Result<=  Rs/ Rd(7 DOWNTO 0);
if  Rs/Rd(7 DOWNTO 0)=x"F0" then
  zeroFlag <='1';
else
  zeroFlag<= '0';
end if ;

elsif opcode = "1000" then ----- right_shift_component

carryFlagOut <= '0';
Result <=  Rs(0) & Rs(15 DOWNTO 1) ;
if  Rs=x"F0" then
  zeroFlag <='1';
else
  zeroFlag<= '0';
end if ;

elsif opcode = "1001" then ----- left_shift_component

carryFlagOut <= '0';
Result <= Rs(14 DOWNTO 0) & Rs(15) ;
if  Rs=x"F0" then
  zeroFlag <='1';
else
  zeroFlag<= '0';
end if ;

elsif opcode = "1010" then ----- sequare root component

----to be completed
Result<= x"F0";
carryFlagOut <= '0';
zeroFlag <='0';
elsif opcode = "1011" then ----- random generator component

----to be completed
Result<= x"F0";
carryFlagOut <= '0';
zeroFlag <='0';
elsif opcode = "1100" then ----- Trigonometry component

----to be completed
Result<= x"F0";
carryFlagOut <= '0';
zeroFlag <='0';

else

  Result<= x"F0";
  carryFlagOut <= '0';
  zeroFlag <='0';

end if ;


end process;

end  description_ALU;
