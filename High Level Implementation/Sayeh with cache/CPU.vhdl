library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

  entity cpu is
    port (
    clk : in std_logic;
    MemDataReady,External_Reset : in std_logic;
    memory_data_input : in std_logic_vector(15 downto 0) ;
    ReadMem, WriteMem : out std_logic;
    memory_data_output,address_to_memory : out std_logic_vector(15 downto 0)
    ) ;
  end cpu;

architecture description_cpu of  cpu is

  component controller is
    port (
    clk, External_Reset,MemDataReady,Zin,Cin : in std_logic;
    IRdataIN : in std_logic_vector(15 downto 0);
    --  ouputs starts  here :
    ResetPC , PCplusI , PCplus1, RplusI , Rplus0  , EnablePC : out std_logic;  --  signals for the addressing unit
    CSet , CReset , ZSet, ZReset , SRload : out std_logic;  -- signals for the flags
    IRload : out std_logic;  --signals for the instruction register
    opcode : out std_logic_vector(3 downto 0);  -- signals for the alu
    RFLwrite , RFHwrite: out std_logic;  --  signals for the register file
    WPadd , WPreset : out std_logic;  -- signals for the window pointer
    Address_on_Databus , ALUout_on_Databus , Rs_on_AddressUnitRSide , Rd_on_AddressUnitRSide : out std_logic;  --singals for the datapath
    PortNumber : out std_logic_vector(5 downto 0); ---- number of the port to be used
    ReadPort,WritePort: out std_logic;  --  signals for the portmanager
    ReadMem,WriteMem: out std_logic  --  signals for the memory
    );
    end component;

    component  data_path is
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
      ReadMem,WriteMem: in std_logic ; --  signals for the memory
      memory_data_in : in std_logic_vector(15 downto 0);
      data_to_memory : out std_logic_vector(15 downto 0);
      addressing_unit_output : out std_logic_vector(15 downto 0)
      );

  end component;

  signal dpu_Cout,dpu_Zout : std_logic;
  signal dpu_IRdataOUT ,dpu_data_to_memory, dpu_addressing_unit_output: std_logic_vector(15 downto 0);
  signal cu_ResetPC , cu_PCplusI ,cu_PCplus1, cu_RplusI , cu_Rplus0  , cu_EnablePC,cu_CSet , cu_CReset , cu_ZSet, cu_ZReset , cu_SRload ,cu_RFLwrite , cu_RFHwrite ,cu_WPadd ,cu_WPreset : std_logic;
  signal cu_Address_on_Databus , cu_ALUout_on_Databus , cu_Rs_on_AddressUnitRSide ,cu_IRload, cu_Rd_on_AddressUnitRSide,cu_ReadMem,cu_WriteMem: std_logic;
  signal cu_opcode : std_logic_vector(3 downto 0);

begin

  controller_unit : controller port map(clk,External_Reset,MemDataReady,dpu_Zout,dpu_Cout,dpu_IRdataOUT,cu_ResetPC , cu_PCplusI , cu_PCplus1, cu_RplusI , cu_Rplus0  , cu_EnablePC,
  cu_CSet , cu_CReset , cu_ZSet, cu_ZReset , cu_SRload,cu_IRload, cu_opcode,cu_RFLwrite , cu_RFHwrite,cu_WPadd , cu_WPreset,cu_Address_on_Databus , cu_ALUout_on_Databus , cu_Rs_on_AddressUnitRSide , cu_Rd_on_AddressUnitRSide,open,open,open,cu_ReadMem,cu_WriteMem);

  datapath_unit : data_path port map (clk,dpu_Zout,dpu_Cout,dpu_IRdataOUT,  cu_ResetPC , cu_PCplusI , cu_PCplus1, cu_RplusI , cu_Rplus0  , cu_EnablePC ,  cu_CSet , cu_CReset , cu_ZSet, cu_ZReset , cu_SRload ,cu_IRload ,cu_opcode ,cu_RFLwrite , cu_RFHwrite,cu_WPadd , cu_WPreset ,cu_Address_on_Databus , cu_ALUout_on_Databus , cu_Rs_on_AddressUnitRSide , cu_Rd_on_AddressUnitRSide ,"000000" ,'0','0',cu_ReadMem,cu_WriteMem,memory_data_input ,dpu_data_to_memory ,dpu_addressing_unit_output );
  address_to_memory <= dpu_addressing_unit_output;
  memory_data_output <= dpu_data_to_memory;
  ReadMem <= cu_ReadMem;
  WriteMem <= cu_WriteMem;

end description_cpu;
