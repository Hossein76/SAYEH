library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity SAYEH is
  port (
    clk,External_Reset : in std_logic
  );
end SAYEH;

architecture description_SAYEH of SAYEH is
  component memory is
    generic (blocksize : integer := 1024);
  	port (
  		clk, ReadMem, WriteMem : in std_logic;
  		AddressBus: in std_logic_vector (15 downto 0);
  		DataBus : inout std_logic_vector (15 downto 0);
  		MemDataReady : out std_logic
  		);
  end component;

  component cpu is port (
  clk : in std_logic;
  MemDataReady,External_Reset : in std_logic;
  memory_data_input : in std_logic_vector(15 downto 0) ;
  ReadMem, WriteMem : out std_logic;
  memory_data_output,address_to_memory : out std_logic_vector(15 downto 0)
  ) ;
    end component;

    signal mu_ReadMem,mu_WriteMem : std_logic;
    signal cpu_address_to_memory : std_logic_vector(15 downto 0);
    signal cpu_MemDataReady : std_logic;
    signal cpu_Databus : std_logic_vector(15 downto 0);


begin
  memory_unit : Memory port map(clk,mu_ReadMem,mu_WriteMem,cpu_address_to_memory,cpu_DataBus,cpu_MemDataReady);
  central_proccessin_unit : cpu port map(clk,cpu_MemDataReady,External_Reset,cpu_Databus,mu_ReadMem,mu_WriteMem,cpu_Databus,cpu_address_to_memory);

end description_SAYEH;
