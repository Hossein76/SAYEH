library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity ALU is  port (
clk : in std_logic ;
Rs : in std_logic_vector(15 downto 0); ---source Register
Rd : in std_logic_vector(15 downto 0);--- destination register
carryFlagIn : in std_logic;   --- we get the carry
opcode : in std_logic_vector(3 downto 0); --- we get the opcode to know what to do
Result : out std_logic_vector(15 downto 0);  ---- result of alu
carryFlagOut : out std_logic; ----- we set the carry
zeroFlag : out std_logic);  ----- we set the zero flag
end  ALU;


architecture description_ALU of ALU is
  signal rand_temp :  std_logic_vector(63 downto 0);
  signal div_temp :  std_logic_vector(15 downto 0);
  signal trigger_temp : std_logic := '0';
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

    component  Div is
      Port (trigger : in std_logic;
       Rs   : in  STD_LOGIC_VECTOR (15 downto 0);
      Rd   : in  STD_LOGIC_VECTOR (15 downto 0);
      Result   : out  STD_LOGIC_VECTOR (15 downto 0));
    end component Div;



  begin
    rand_generator : rand_component
    generic map(
    init_seed => "11111010100011010001001010101000000100111100101010000000010100000010100000000000000010000000000000100101000001010000111000100000" )
    port map (
    clk         => clk,
    rst         => '0',
    reseed      => '0',
    newseed     => "11111010100010110001001010101000000100111100101010000000010100000010100000000000000010000000000000100101000001010000111000100000",
    out_ready   => '1',
    out_valid   => open,
    out_data    => rand_temp );
    dividor : Div
    port map ( trigger => trigger_temp,  Rs => Rs,
       Rd=>Rd,
       Result => div_temp
    );

    process (Rd, Rs, opcode, carryFlagIn)
    variable result_temp : std_logic_vector(16 downto 0);
    variable Rs_temp :  std_logic_vector(16 downto 0);
    variable Rd_temp :  std_logic_vector(16 downto 0);
    variable loop_temp : std_logic_vector(15 downto 0);
    begin

      loop_temp := x"0000";

      if opcode = "0000" then  -- and component
      Result <= Rd and Rs;
      carryFlagOut <= '0';
      if (Rd and Rs)=x"0000" then
        zeroFlag <='1';
      else
        zeroFlag<= '0';
      end if ;
    elsif opcode = "0001" then  --- or component
    Result <= Rd or Rs;
    carryFlagOut <= '0';
    if (Rd or Rs)=x"0000" then
      zeroFlag <='1';
    else
      zeroFlag<= '0';
    end if ;
  elsif opcode = "0010"  then ----xor component
  Result <= Rd xor Rs;
  carryFlagOut <= '0';
  if (Rd xor Rs)=x"0000" then
    zeroFlag <='1';
  else
    zeroFlag<= '0';
  end if ;
elsif opcode = "0011" then ----- 2' complement component
Result <=((not Rs)+'1');
carryFlagOut <= '0';
if ((not Rs)+'1')=x"0000" then
  zeroFlag <='1';
else
  zeroFlag<= '0';
end if ;

elsif opcode = "0100" then ----- addition_component
Rd_temp(15 downto 0) := Rd;
Rs_temp(15 downto 0) := Rs;
Rs_temp(16) := '0';
Rd_temp(16) := '0';

result_temp :=  Rd_temp + Rs_temp + carryFlagIn;
carryFlagOut <= result_temp(16);
Result<= result_temp(15 downto 0);
if result_temp(15 downto 0)=x"0000" then
  zeroFlag <='1';
else
  zeroFlag<= '0';
end if ;

elsif opcode = "0101" then ----- subtraction_component
Rd_temp(15 downto 0) := Rd;
Rs_temp(15 downto 0) := Rs;
Rs_temp(16) := '0';
Rd_temp(16) := '0';
result_temp :=(not(Rs+carryFlagIn))+(x"0000"&'1')+ Rd;
carryFlagOut <= result_temp(16);
Result<= result_temp(15 downto 0);
if result_temp(15 downto 0)=x"0000" then
  zeroFlag <='1';
else
  zeroFlag<= '0';
end if ;

elsif opcode = "0110" then ----- MULTIPLICATION_component

carryFlagOut <= '0';
Result<=  Rs(7 DOWNTO 0) * Rd(7 DOWNTO 0);
if  Rs(7 DOWNTO 0) * Rd(7 DOWNTO 0)=x"0000" then
  zeroFlag <='1';
else
  zeroFlag<= '0';
end if ;

elsif opcode = "0111" then ----- division_component
trigger_temp<= '1';
carryFlagOut <= '0';
Result<=  div_temp;
if  div_temp=x"0000" then
  zeroFlag <='1';
else
  zeroFlag<= '0';
end if ;
trigger_temp<='0';
elsif opcode = "1000" then ----- right_shift_component

carryFlagOut <= '0';
Result <=  Rs(0) & Rs(15 DOWNTO 1) ;
if  Rs=x"0000" then
  zeroFlag <='1';
else
  zeroFlag<= '0';
end if ;

elsif opcode = "1001" then ----- left_shift_component

carryFlagOut <= '0';
Result <= Rs(14 DOWNTO 0) & Rs(15) ;
if  Rs=x"0000" then
  zeroFlag <='1';
else
  zeroFlag<= '0';
end if ;

elsif opcode = "1010" then ----- sequare root component

----to be completed
Result<= x"0000";
carryFlagOut <= '0';
zeroFlag <='0';
elsif opcode = "1011" then ----- random generator component

Result<=rand_temp(63 downto 48);
carryFlagOut <= '0';
zeroFlag <='0';
elsif opcode = "1100" then ----- Trigonometry component

----to be completed
Result<= x"0000";
carryFlagOut <= '0';
zeroFlag <='0';


elsif opcode = "1101" then ----- RS

Result<= Rs;
carryFlagOut <= '0';
if  Rs=x"0000" then
  zeroFlag <='1';
else
  zeroFlag<= '0';
end if ;
elsif opcode = "1110" then ----- not RS

----to be completed
Result<= not Rs;
carryFlagOut <= '0';
if  Rs=x"0000" then
  zeroFlag <='1';
else
  zeroFlag<= '0';
end if ;
else

  Result<= x"0000";
  carryFlagOut <= '0';
  zeroFlag <='0';

end if ;



end process;

end  description_ALU;

---------------------------


library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
entity rand_component is
  generic (
  -- Default seed value.
  init_seed:  std_logic_vector(127 downto 0) );
  port (
  -- Clock, rising edge active.
  clk:        in  std_logic;
  -- Synchronous reset, active high.
  rst:        in  std_logic;
  -- High to request re-seeding of the generator.
  reseed:     in  std_logic;
  -- New seed value (must be valid when reseed = '1').
  newseed:    in  std_logic_vector(127 downto 0);
  -- High when the user accepts the current random data word
  -- and requests new random data for the next clock cycle.
  out_ready:  in  std_logic;
  -- High when valid random data is available on the output.
  -- This signal is low during the first clock cycle after reset and
  -- after re-seeding, and high in all other cases.
  out_valid:  out std_logic;
  -- Random output data (valid when out_valid = '1').
  -- A new random word appears after every rising clock edge
  -- where out_ready = '1'.
  out_data:   out std_logic_vector(63 downto 0) );
end rand_component;
architecture description_rand_component of rand_component is
  -- Internal state of RNG.
  signal reg_state_s0:    std_logic_vector(63 downto 0) := init_seed(63 downto 0);
  signal reg_state_s1:    std_logic_vector(63 downto 0) := init_seed(127 downto 64);
  -- Output register.
  signal reg_valid:       std_logic := '0';
  signal reg_output:      std_logic_vector(63 downto 0) := (others => '0');
  -- Shift left.
  function shiftl(x: std_logic_vector; b: integer)
  return std_logic_vector
  is
    constant n: integer := x'length;
    variable y: std_logic_vector(n-1 downto 0);
    begin
      y(n-1 downto b) := x(x'high-b downto x'low);
      y(b-1 downto 0) := (others => '0');
      return y;
    end function;
    -- Rotate left.
    function rotl(x: std_logic_vector; b: integer)
    return std_logic_vector
    is
      constant n: integer := x'length;
      variable y: std_logic_vector(n-1 downto 0);
      begin
        y(n-1 downto b) := x(x'high-b downto x'low);
        y(b-1 downto 0) := x(x'high downto x'high-b+1);
        return y;
      end function;
      begin
        -- Drive output signal.
        out_valid   <= reg_valid;
        out_data    <= reg_output;
        -- Synchronous process.
        process (clk) is
          begin
            if rising_edge(clk) then
              if out_ready = '1' or reg_valid = '0' then
                -- Prepare output word.
                reg_valid       <= '1';
                reg_output      <= std_logic_vector(unsigned(reg_state_s0) +
                unsigned(reg_state_s1));
                -- Update internal state.
                reg_state_s0    <= reg_state_s0 xor
                reg_state_s1 xor
                shiftl(reg_state_s0, 14) xor
                shiftl(reg_state_s1, 14) xor
                rotl(reg_state_s0, 55);
                reg_state_s1    <= rotl(reg_state_s0, 36) xor
                rotl(reg_state_s1, 36);
              end if;
              -- Re-seed function.
              if reseed = '1' then
                reg_state_s0    <= newseed(63 downto 0);
                reg_state_s1    <= newseed(127 downto 64);
                reg_valid       <= '0';
              end if;
              -- Synchronous reset.
              if rst = '1' then
                reg_state_s0    <= init_seed(63 downto 0);
                reg_state_s1    <= init_seed(127 downto 64);
                reg_valid       <= '0';
                reg_output      <= (others => '0');
              end if;
            end if;
          end process;
        end description_rand_component;
        -----------------------------
        library IEEE;
        use IEEE.STD_LOGIC_1164.ALL;
        use IEEE.STD_LOGIC_ARITH.ALL;
        use IEEE.STD_LOGIC_UNSIGNED.ALL;


        entity Div is
          Port ( trigger : in std_logic;
           Rs   : in  STD_LOGIC_VECTOR (15 downto 0);
          Rd   : in  STD_LOGIC_VECTOR (15 downto 0);
          Result   : out  STD_LOGIC_VECTOR (15 downto 0));
        end Div;


        architecture Behavioral_div of Div is
          begin
              process (trigger,Rs, Rd)
              variable cnt  : std_logic_vector(15 downto 0);
              variable Rs_temp : std_logic_vector(15 downto 0);
              variable Rd_temp : std_logic_vector(15 downto 0);
              begin
                Rd_temp :=x"0000";
                Rd_temp(7 downto 0):= Rd(7 downto 0);
                cnt   := x"0000";
                Rs_temp :=Rs;
                if trigger ='1'then
                while (Rs_temp >= Rd_temp) loop
                  Rs_temp := (Rs_temp - Rd_temp);
                  cnt   := cnt + '1';
                end loop;
              end if;
                Result <= cnt;
              end process;

            end Behavioral_div;
