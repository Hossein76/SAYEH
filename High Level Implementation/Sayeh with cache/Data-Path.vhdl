library IEEE;
use IEEE.std_logic_1164.all;
entity data_path is
  port (
  clk: in std_logic;
  Zout,Cout : out std_logic;
  IRdataOUT : out std_logic_vector(15 downto 0);
  ResetPC , PCplusI , PCplus1, RplusI , Rplus0  , EnablePC : in std_logic;  --  signals for the addressing unit
  CSet , CReset , ZSet, ZReset , SRload : in std_logic;  -- signals for the flags
  IRload : in std_logic;  --signals for the instruction register
  opcode : in std_logic_vector(3 downto 0);  -- signals for the alu
  RFLwrite , RFHwrite: in std_logic;  --  signals for the register file
  WPadd , WPreset : in std_logic;  -- signals for the window pointer
  Address_on_Databus , ALUout_on_Databus , Rs_on_AddressUnitRSide , Rd_on_AddressUnitRSide : in std_logic;  --singals for the datapath
  PortNumber : in std_logic_vector(5 downto 0); ---- number of the port to be used
  ReadPort,WritePort: in std_logic;  --  signals for the portmanager
  ReadMem,WriteMem: in std_logic;  --  signals for the memory
  memory_data_in : in std_logic_vector(15 downto 0);
  data_to_memory : out std_logic_vector(15 downto 0);
  addressing_unit_output : out std_logic_vector(15 downto 0)
  );

end data_path;


architecture description_data_path of data_path is




  component ADDRESS_UNIT IS
  PORT (
  Rside : IN std_logic_vector (15 DOWNTO 0);
  Iside : IN std_logic_vector (7 DOWNTO 0);
  Address : OUT std_logic_vector (15 DOWNTO 0);
  clk, ResetPC, PCplusI, PCplus1 : IN std_logic;
  RplusI, Rplus0, EnablePC : IN std_logic
  );
end component;


component register_file is
  port(
  clk: in std_logic;
  data_in : in std_logic_vector(15 downto 0);
  window_pointer : in std_logic_vector(5 downto 0);
  selector : in std_logic_vector(3 downto 0);
  RFLwrite,RFHwrite : in std_logic;
  Rs,  Rd : out std_logic_vector(15 downto 0)
  );
end component;


component instruction_register IS PORT(
clk,IRload : in std_logic;
IRin : in std_logic_vector(15 downto 0);
IRout : out std_logic_vector(15 downto 0)
);
end component;
component  window_pointer IS PORT(
clk : in std_logic;
wp_in : in std_logic_vector(5 downto 0);
WPadd,WPreset : in std_logic;
wp_out : out std_logic_vector(5 downto 0)
);
end component;


component  flags IS PORT(
clk : IN STD_LOGIC; -- clock.
Zin,Cin,CSet,CReset,ZSet,ZReset,SRload   : IN STD_LOGIC;
Cout,Zout   : OUT STD_LOGIC -- output
);
end component;

component ALU is  port (
clk : in std_logic ;
Rs : in std_logic_vector(15 downto 0); ---source Register
Rd : in std_logic_vector(15 downto 0);--- destination register
carryFlagIn : in std_logic;   --- we get the carry
opcode : in std_logic_vector(3 downto 0); --- we get the opcode to know what to do
Result : out std_logic_vector(15 downto 0);  ---- result of alu
carryFlagOut : out std_logic; ----- we set the carry
zeroFlag : out std_logic);  ----- we set the zero flag
end component;
signal Databus,au_RSide,addressing_unit_out,register_file_left,register_file_right,IRout,alu_out : std_logic_vector(15 downto 0);
signal window_pointer_signal : std_logic_vector(5 downto 0);
signal flags_register_cout,flags_register_zout ,alu_cout,alu_zout: std_logic;
begin
  addressing_unit : ADDRESS_UNIT port map (au_RSide , IRout(7 downto 0) , addressing_unit_out , clk, ResetPC, PCplusI, PCplus1 ,RplusI, Rplus0, EnablePC);
  registerFile : register_file port map (clk,Databus,window_pointer_signal,IRout (11 downto 8),RFLwrite,RFHwrite,register_file_right , register_file_left);
  IR_register : instruction_register port map (clk , IRload , DataBus , IRout);
  windowPointer_register : window_pointer port map (clk,IRout (5 downto 0)  , WPadd , WPreset , window_pointer_signal);
  flags_register : flags port map (clk, alu_zout,alu_cout,CSet , CReset , ZSet, ZReset , SRload, flags_register_cout , flags_register_zout);
  arithmetic_logic_unit : ALU port map (clk,register_file_left , register_file_right ,  flags_register_cout , opcode ,alu_out, alu_cout , alu_zout );

  databus <= memory_data_in when ReadMem = '1' else alu_out when ALUout_on_Databus = '1'
else addressing_unit_out when Address_on_Databus = '1' else "ZZZZZZZZZZZZZZZZ";

au_RSide <= register_file_right when Rs_on_AddressUnitRSide = '1'
else register_file_left when Rd_on_AddressUnitRSide = '1' else x"0000";

Cout <= flags_register_cout;
Zout <= flags_register_zout;

data_to_memory <= Databus when WriteMem = '1' else "ZZZZZZZZZZZZZZZZ" ;
addressing_unit_output <= addressing_unit_out;
IRdataOUT <= IRout;
end description_data_path;
