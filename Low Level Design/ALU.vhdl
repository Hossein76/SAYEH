LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
----------------------
ENTITY and_component IS PORT(
Rs   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);  -- Source Register
Rd   : IN STD_LOGIC_VECTOR(15 DOWNTO 0) ; -- Destination Register
Result   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)  -- the result goes into destination register
);
END and_component;

ARCHITECTURE description_and_component OF and_component IS

BEGIN
Result <= Rs and Rd ;
END description_and_component;

---------------------

ENTITY or_component IS PORT(
Rs   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);  -- Source Register
Rd   : IN STD_LOGIC_VECTOR(15 DOWNTO 0) ; -- Destination Register
Result   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)  -- the result goes into destination register
);
END or_component;

ARCHITECTURE description_or_component OF or_component IS

BEGIN
Result <= Rs or Rd ;
END description_or_component;
----------------------------

ENTITY rshift_component IS PORT(
Rs   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);  -- Source Register
Rd   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)  -- Destination Register
);
END rshift_component;

ARCHITECTURE description_rshift_component OF rshift_component IS

BEGIN
Rd <=  Rs(15) & Rs(14 DOWNTO 0) ;
END description_rshift_component;

---------------------------
ENTITY lshift_component IS PORT(
Rs   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);  -- Source Register
Rd   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)  -- Destination Register
);
END lshift_component;

ARCHITECTURE description_lshift_component OF lshift_component IS

BEGIN
Rd <=  Rs(14 DOWNTO 0) & Rs(15);
END description_lshift_component;
---------------------------

---------------------------
ENTITY comparison_component IS PORT(
Rs   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);  -- Source Register
Rd   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);  -- Destination Register
zeroFlag : OUT STD_LOGIC ;  -- output to the zero flag register
carryFlag : OUT STD_LOGIC   -- output to the carry flag register
);
END comparison_component;

ARCHITECTURE description_comparison_component OF comparison_component IS
BEGIN
process(RS,Rd)
begin
  if Rs=Rd then
    zeroFlag <= '1';
    carryFlag <= '0';
  elsif to_integer(Rd) < to_integer(Rs) then
    zeroFlag <= '0';
    carryFlag <= '1';
  else
    zeroFlag <= '0';
    carryFlag <= '0';
  end if;
end process;
END description_comparison_component;
---------------------------

entity addition_component is
  port (
  Rs   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);  -- Source Register
  Rd   : IN STD_LOGIC_VECTOR(15 DOWNTO 0) ; -- Destination Register
  carryFlagIn   : IN STD_LOGIC ; -- input from the carry flag register
  Result   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);  -- the result goes into destination register
  carryFlagOut : OUT STD_LOGIC   -- output to the carry flag register

  );
end addition_component;


architecture description_addition_component of addition_component is

  component full_adder is
    port (
    a  : in  std_logic;
    b  : in  std_logic;
    cin : in  std_logic;
    s   : out std_logic;
    cout : out std_logic);
  end component full_adder;

  signal g : std_logic_vector(15 downto 0); -- Generate
  signal p : std_logic_vector(15 downto 0); -- Propagate
  signal c : std_logic_vector(16 downto 0); -- Carry

  signal sum   : std_logic_vector(15 downto 0);


  begin

    FAB_0 : full_adder
    port map (
    a  => Rs(0),
    b  => Rd(0),
    cin => c(0),
    s   => sum(0),
    cout => open
    );

    FAB_1 : full_adder
    port map (
    a  => Rs(1),
    b  => Rd(1),
    cin => c(1),
    s   => sum(1),
    cout => open
    );

    FAB_2 : full_adder
    port map (
    a  => Rs(2),
    b  => Rd(2),
    cin => c(2),
    s   => sum(2),
    cout => open
    );

    FAB_3 : full_adder
    port map (
    a  => Rs(3),
    b  => Rd(3),
    cin => c(3),
    s   => sum(3),
    cout => open
    );

    FAB_4 : full_adder
    port map (
    a  => Rs(4),
    b  => Rd(4),
    cin => c(4),
    s => sum(4),
    cout => open
    );
    FAB_5 : full_adder
    port map (
    a  => Rs(5),
    b  => Rd(5),
    cin => c(5),
    s => sum(5),
    cout => open
    );
    FAB_6 : full_adder
    port map (
    a  => Rs(6),
    b  => Rd(6),
    cin => c(6),
    s => sum(6),
    cout => open
    );
    FAB_7 : full_adder
    port map (
    a  => Rs(7),
    b  => Rd(7),
    cin => c(7),
    s => sum(7),
    cout => open
    );
    FAB_8 : full_adder
    port map (
    a  => Rs(8),
    b  => Rd(8),
    cin => c(8),
    s => sum(8),
    cout => open
    );

    FAB_9 : full_adder
    port map (
    a  => Rs(9),
    b  => Rd(9),
    cin => c(9),
    s => sum(9),
    cout => open
    );
    FAB_10 : full_adder
    port map (
    a  => Rs(10),
    b  => Rd(10),
    cin => c(10),
    s => sum(10),
    cout => open
    );
    FAB_11 : full_adder
    port map (
    a  => Rs(11),
    b  => Rd(11),
    cin => c(11),
    s => sum(11),
    cout => open
    );
    FAB_12 : full_adder
    port map (
    a  => Rs(12),
    b  => Rd(12),
    cin => c(12),
    s => sum(12),
    cout => open
    );

    FAB_13 : full_adder
    port map (
    a  => Rs(13),
    b  => Rd(13),
    cin => c(13),
    s => sum(13),
    cout => open
    );
    FAB_14 : full_adder
    port map (
    a  => Rs(14),
    b  => Rd(14),
    cin => c(14),
    s => sum(14),
    cout => open
    );

    FAB_15 : full_adder
    port map (
    a  => Rs(15),
    b  => Rd(15),
    cin => c(15),
    s => sum(15),
    cout => open
    );


    -- here we create the g signal g(i)=a(i) * b(i)
    g(0) <= Rs(0) and Rd(0);
    g(1) <= Rs(1) and Rd(1);
    g(2) <= Rs(2) and Rd(2);
    g(3) <= Rs(3) and Rd(3);
    g(4) <= Rs(4) and Rd(4);
    g(5) <= Rs(5) and Rd(5);
    g(6) <= Rs(6) and Rd(6);
    g(7) <= Rs(7) and Rd(7);
    g(8) <= Rs(8) and Rd(8);
    g(9) <= Rs(9) and Rd(9);
    g(10) <= Rs(10) and Rd(10);
    g(11) <= Rs(11) and Rd(11);
    g(12) <= Rs(12) and Rd(12);
    g(13) <= Rs(13) and Rd(13);
    g(14) <= Rs(14) and Rd(14);
    g(15) <= Rs(15) and Rd(15);


    -- here we create the p signal p(i)=a(i) + b(i)
    p(0) <= Rs(0) or Rd(0);
    p(1) <= Rs(1) or Rd(1);
    p(2) <= Rs(2) or Rd(2);
    p(3) <= Rs(3) or Rd(3);
    p(4) <= Rs(4) or Rd(4);
    p(5) <= Rs(5) or Rd(5);
    p(6) <= Rs(6) or Rd(6);
    p(7) <= Rs(7) or Rd(7);
    p(8) <= Rs(8) or Rd(8);
    p(9) <= Rs(9) or Rd(9);
    p(10) <= Rs(10) or Rd(10);
    p(11) <= Rs(11) or Rd(11);
    p(12) <= Rs(12) or Rd(12);
    p(13) <= Rs(13) or Rd(13);
    p(14) <= Rs(14) or Rd(14);
    p(15) <= Rs(15) or Rd(15);

    -- here we create each the carry signl  c(i+1)=g(i)+(p(i)*c(i))
    c(0) <= carryFlagIn; -- no carry input
    c(1) <= g(0) or (p(0) and c(0));
    c(2) <= g(1) or (p(1) and c(1));
    c(3) <= g(2) or (p(2) and c(2));
    c(4) <= g(3) or (p(3) and c(3));
    c(5) <= g(4) or (p(4) and c(4));
    c(6) <= g(5) or (p(5) and c(5));
    c(7) <= g(6) or (p(6) and c(6));
    c(8) <= g(7) or (p(7) and c(7));
    c(9) <= g(8) or (p(8) and c(8));
    c(10) <= g(9) or (p(9) and c(9));
    c(11) <= g(10) or (p(10) and c(10));
    c(12) <= g(11) or (p(11) and c(11));
    c(13) <= g(12) or (p(12) and c(12));
    c(14) <= g(13) or (p(13) and c(13));
    c(15) <= g(14) or (p(14) and c(14));
    c(16) <= g(15) or (p(15) and c(15));


    -- Final Answer

    Result <=sum; 
    carryFlagOut <= c(16);

  end description_addition_component;
  -------------------------------
  entity full_adder is
    Port ( a : in STD_LOGIC;
    b : in STD_LOGIC;
    cin : in STD_LOGIC;
    s : out STD_LOGIC;
    cout : out STD_LOGIC);
  end full_adder;

  architecture description_full_adder of full_adder is

    begin

      s <= b xor cin xor a ;
      cout <= (a and b) OR (cin and b) OR (a and cin) ;

    end description_full_adder;
    ---------------------------------

    ENTITY subtraction_component IS PORT(
    Rs   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);  -- Source Register
    carryFlagIn: IN STD_LOGIC;
    Result   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);  -- Result goes to the Rs of the addition_component
    carryFlagOut : OUT STD_LOGIC   -- output to the carryFlagIn of addition_component
    );
    END subtraction_component;

    ARCHITECTURE description_subtraction_component OF subtraction_component IS
    BEGIN

    Result <= Rs xnor x"F0";
    if carryFlag='1'then
     carryFlagOut<='0';
   else
     carryFlagOut<='1';
   end if;

    END description_subtraction_component;
