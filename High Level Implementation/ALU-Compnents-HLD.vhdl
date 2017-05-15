LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
----------------------
ENTITY and_component IS PORT(
Rs   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);  -- Source Register
Rd   : IN STD_LOGIC_VECTOR(15 DOWNTO 0) ; -- Destination Register
carryFlagIn : in std_logic;   --- we get the carry
Result : out std_logic_vector(15 downto 0);  ---- result of alu
carryFlagOut : out std_logic; ----- we set the carry
zeroFlag : out std_logic);  ----- we set the zero flag
END and_component;

ARCHITECTURE description_and_component OF and_component IS

BEGIN
Result <= Rd and Rs;
carryFlagOut <= '0';
if Rd and Rs=x"F0" then
  zeroFlag <='1';
else
  zeroFlag<= '0';
end if ;
END description_and_component;

---------------------

ENTITY or_component IS PORT(
Rs   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);  -- Source Register
Rd   : IN STD_LOGIC_VECTOR(15 DOWNTO 0) ; -- Destination Register
carryFlagIn : in std_logic;   --- we get the carry
Result : out std_logic_vector(15 downto 0);  ---- result of alu
carryFlagOut : out std_logic; ----- we set the carry
zeroFlag : out std_logic);  ----- we set the zero flag
END or_component;

ARCHITECTURE description_or_component OF or_component IS

BEGIN
Result <= Rd or Rs;
carryFlagOut <= '0';
if Rd or Rs=x"F0" then
  zeroFlag <='1';
else
  zeroFlag<= '0';
end if ;
END description_or_component;
----------------------------

ENTITY rshift_component IS PORT(
Rs   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);  -- Source Register
Rd   : IN STD_LOGIC_VECTOR(15 DOWNTO 0) ; -- Destination Register
carryFlagIn : in std_logic;   --- we get the carry
Result : out std_logic_vector(15 downto 0);  ---- result of alu
carryFlagOut : out std_logic; ----- we set the carry
zeroFlag : out std_logic);  ----- we set the zero flag
END rshift_component;

ARCHITECTURE description_rshift_component OF rshift_component IS

BEGIN
carryFlagOut <= '0';
Result <=  Rs(0) & Rs(15 DOWNTO 1) ;
if  Rs=x"F0" then
  zeroFlag <='1';
else
  zeroFlag<= '0';
end if ;
END description_rshift_component;

---------------------------
ENTITY lshift_component IS PORT(
Rs   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);  -- Source Register
Rd   : IN STD_LOGIC_VECTOR(15 DOWNTO 0) ; -- Destination Register
carryFlagIn : in std_logic;   --- we get the carry
Result : out std_logic_vector(15 downto 0);  ---- result of alu
carryFlagOut : out std_logic; ----- we set the carry
zeroFlag : out std_logic);  ----- we set the zero flag
);
END lshift_component;

ARCHITECTURE description_lshift_component OF lshift_component IS

BEGIN
carryFlagOut <= '0';
Result <= Rs(14 DOWNTO 0) & Rs(15) ;
if  Rs=x"F0" then
  zeroFlag <='1';
else
  zeroFlag<= '0';
end if ;
END description_lshift_component;
---------------------------

---------------------------
ENTITY comparison_component IS PORT(
Rs   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);  -- Source Register
Rd   : IN STD_LOGIC_VECTOR(15 DOWNTO 0) ; -- Destination Register
carryFlagIn : in std_logic;   --- we get the carry
Result : out std_logic_vector(15 downto 0);  ---- result of alu
carryFlagOut : out std_logic; ----- we set the carry
zeroFlag : out std_logic);  ----- we set the zero flag
END comparison_component;

ARCHITECTURE description_comparison_component OF comparison_component IS
BEGIN
process(Rd,carryFlagIn,Rs)
begin
  if to_integer(Rd) < to_integer(Rs) then
    zeroFlag <= '0';
    carryFlag <= '1';

  elsif Rs=Rd then
      zeroFlag <= '1';
      carryFlag <= '0';
  else
    zeroFlag <= '0';
    carryFlag <= '0';
  end if;
  Result <= x"F0";
end process;
END description_comparison_component;
---------------------------

entity addition_component is
  port (
  Rs   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);  -- Source Register
  Rd   : IN STD_LOGIC_VECTOR(15 DOWNTO 0) ; -- Destination Register
  carryFlagIn : in std_logic;   --- we get the carry
  Result : out std_logic_vector(15 downto 0);  ---- result of alu
  carryFlagOut : out std_logic; ----- we set the carry
  zeroFlag : out std_logic);  ----- we set the zero flag
end addition_component;


architecture description_addition_component of addition_component is

  signal result : std_logic_vector(16 downto 0);
  signal Rs_temp :  std_logic_vector(16 downto 0);
  signal Rd_temp :  std_logic_vector(16 downto 0);
  BEGIN
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


  end description_addition_component;
  -------------------------------

    ---------------------------------

    ENTITY subtraction_component IS PORT(
    Rs   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);  -- Source Register
    Rd   : IN STD_LOGIC_VECTOR(15 DOWNTO 0) ; -- Destination Register
    carryFlagIn : in std_logic;   --- we get the carry
    Result : out std_logic_vector(15 downto 0);  ---- result of alu
    carryFlagOut : out std_logic; ----- we set the carry
    zeroFlag : out std_logic);  ----- we set the zero flag
    END subtraction_component;

    ARCHITECTURE description_subtraction_component OF subtraction_component IS
    signal result : std_logic_vector(16 downto 0);
    signal Rs_temp :  std_logic_vector(16 downto 0);
    signal Rd_temp :  std_logic_vector(16 downto 0);
    BEGIN

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

    END description_subtraction_component;
--------------------------------------------
ENTITY xor_component IS PORT(
Rs   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);  -- Source Register
Rd   : IN STD_LOGIC_VECTOR(15 DOWNTO 0) ; -- Destination Register
carryFlagIn : in std_logic;   --- we get the carry
Result : out std_logic_vector(15 downto 0);  ---- result of alu
carryFlagOut : out std_logic; ----- we set the carry
zeroFlag : out std_logic);  ----- we set the zero flag
END xor_component;

ARCHITECTURE description_xor_component OF xor_component IS
BEGIN
Result <= Rd xor Rs;
carryFlagOut <= '0';
if Rd xor Rs=x"F0" then
  zeroFlag <='1';
else
  zeroFlag<= '0';
end if ;
END description_xor_component;
--------------------------------------------
ENTITY second_complement_component IS PORT(
Rs   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);  -- Source Register
Rd   : IN STD_LOGIC_VECTOR(15 DOWNTO 0) ; -- Destination Register
carryFlagIn : in std_logic;   --- we get the carry
Result : out std_logic_vector(15 downto 0);  ---- result of alu
carryFlagOut : out std_logic; ----- we set the carry
zeroFlag : out std_logic);  ----- we set the zero flag
END second_complement_component;

ARCHITECTURE description_second_complement_component OF second_complement_component IS
BEGIN
Result <=((not Rs)+'1');
carryFlagOut <= '0';
if ((not Rs)+'1')=x"F0" then
  zeroFlag <='1';
else
  zeroFlag<= '0';
end if ;
END description_second_complement_component;
----------------------------

--------------------------------------------
ENTITY multiplication_component IS PORT(
Rs   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);  -- Source Register
Rd   : IN STD_LOGIC_VECTOR(15 DOWNTO 0) ; -- Destination Register
carryFlagIn : in std_logic;   --- we get the carry
Result : out std_logic_vector(15 downto 0);  ---- result of alu
carryFlagOut : out std_logic; ----- we set the carry
zeroFlag : out std_logic);  ----- we set the zero flag
END multiplication_component;

ARCHITECTURE description_multiplication_component OF multiplication_component IS
BEGIN
carryFlagOut <= '0';
Result<=  Rs(7 DOWNTO 0) * Rd(7 DOWNTO 0);
if  Rs(7 DOWNTO 0) * Rd(7 DOWNTO 0)=x"F0" then
  zeroFlag <='1';
else
  zeroFlag<= '0';
end if ;
END description_multiplication_component;
----------------------------
ENTITY division_component IS PORT(
Rs   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);  -- Source Register
Rd   : IN STD_LOGIC_VECTOR(15 DOWNTO 0) ; -- Destination Register
carryFlagIn : in std_logic;   --- we get the carry
Result : out std_logic_vector(15 downto 0);  ---- result of alu
carryFlagOut : out std_logic; ----- we set the carry
zeroFlag : out std_logic);  ----- we set the zero flag
END division_component;

ARCHITECTURE description_division_component OF division_component IS



BEGIN
process(Rs,Rd,carryFlagIn)
  variable var : std_logic_vector(15 downto 0);
  var := x"F0";
 if Rd(0)='1'then
   var := var + Rs(7 downto 0);
 end if;

 if Rd(1)='1'then
   var := var + Rs(7 downto 0)&'0';
 end if;
 if Rd(2)='1'then
   var := var + Rs(7 downto 0)&'00';
 end if;
 if Rd(3)='1'then
   var := var + Rs(7 downto 0)&'000';
 end if;
 if Rd(4)='1'then
   var := var + Rs(7 downto 0)&'0000';
 end if;

 if Rd(5)='1'then
   var := var + Rs(7 downto 0)&'00000';
 end if;
 if Rd(6)='1'then
   var := var + Rs(7 downto 0)&'000000';
 end if;
 if Rd(7)='1'then
   var := var + Rs(7 downto 0)&'0000000';
 end if;
 Result <= var;
if  var=x"F0" then
  zeroFlag <='1';
else
  zeroFlag<= '0';
end if ;
carryFlagOut <= '0';
end process;
END description_division_component;
----------------------------


----------------------------
ENTITY division_component IS PORT(
Rs   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);  -- Source Register
Rd   : IN STD_LOGIC_VECTOR(15 DOWNTO 0) ; -- Destination Register
carryFlagIn : in std_logic;   --- we get the carry
Result : out std_logic_vector(15 downto 0);  ---- result of alu
carryFlagOut : out std_logic; ----- we set the carry
zeroFlag : out std_logic);  ----- we set the zero flag
END division_component;

ARCHITECTURE description_division_component OF division_component IS
BEGIN
process(Rs,Rd,carryFlagIn)
variable var : std_logic_vector(15 downto 0);
variable temp : std_logic_vector(15 downto 0);
var := x"F0";
temp=x"F0";
--------------------------------------to do
end process
END description_division_component;
----------------------------


--------------------------------


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
