library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;

entity ALU is  port (Rs : in std_logic_vector(15 downto 0); ---source Register
Rd : in std_logic_vector(15 downto 0);--- destination register
carryFlagIn : in std_logic;   --- we get the carry
opcode : in std_logic_vector(3 downto 0); --- we get the opcode to know what to do
Result : out std_logic_vector(15 downto 0);  ---- result of alu
clk : in std_logic ;
carryFlagOut : out std_logic; ----- we set the carry
zeroFlag : out std_logic);  ----- we set the zero flag
end  ALU;


architecture description_ALU of ALU is
  signal result : std_logic_vector(16 downto 0);
  signal Rs_temp :  std_logic_vector(16 downto 0);
  signal Rd_temp :  std_logic_vector(16 downto 0);
  signal rand_temp :  std_logic_vector(63 downto 0);
  component  rand_component is
    generic (
    init_seed:  std_logic_vector(127 downto 0) );
    port (
    clk:        in  std_logic;
    rst:        in  std_logic;
    reseed:     in  std_logic;
    newseed:    in  std_logic_vector(127 downto 0);
    out_ready:  in  std_logic;
    out_valid:  out std_logic;
    out_data:   out std_logic_vector(63 downto 0) );
  end component rand_component;


  begin
    rand_generator : rand_component
    generic map
              init_seed => "1111101010001010001001010101000000100111100101010000000010100000010100000000000000010000000000000100101000001010000111000100000" )
          port map (
              clk         => clk,
              rst         => '0',
              reseed      => '0',
              newseed     => open,
              out_ready   => '1',
              out_valid   => open,
              out_data    => rand_temp );

    process (Rd, Rs, opcode, carryFlagIn)

    begin
      if opcode = "0000" then  -- and component
      Result <= Rd and Rs;
      carryFlagOut <= '0';
      if Rd and Rs=x"F0" then
        zeroFlag <='1';
      else
        zeroFlag<= '0';
      end if ;
    elsif opcode = "0001" then  --- or component
    Result <= Rd or Rs;
    carryFlagOut <= '0';
    if Rd or Rs=x"F0" then
      zeroFlag <='1';
    else
      zeroFlag<= '0';
    end if ;
  elsif opcode = "0010"  then ----xor component
  Result <= Rd xor Rs;
  carryFlagOut <= '0';
  if Rd xor Rs=x"F0" then
    zeroFlag <='1';
  else
    zeroFlag<= '0';
  end if ;
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
