library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity SAYEH is
  port (
    clk2,clk,External_Reset : in std_logic
  );
end SAYEH;

architecture description_SAYEH of SAYEH is
  component cache_memory is
  	port (
    clk : in std_logic;
    Read_Data : in std_logic;
    Write_Data : in std_logic;
    AddressBus: in std_logic_vector (15 downto 0);
    Data_input : in std_logic_vector(15 downto 0);
    data_ready : out std_logic;
    Data_Output : out std_logic_vector (15 downto 0)
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
    signal cpu_data_to_mem : std_logic_vector(15 downto 0);
    signal mem_data_to_cpu : std_logic_vector(15 downto 0);


begin
  memory_unit : cache_memory port map(clk2,mu_ReadMem,mu_WriteMem,cpu_address_to_memory,cpu_data_to_mem,cpu_MemDataReady,mem_data_to_cpu);
  central_proccessin_unit : cpu port map(clk,cpu_MemDataReady,External_Reset,mem_data_to_cpu,mu_ReadMem,mu_WriteMem,cpu_data_to_mem,cpu_address_to_memory);

end description_SAYEH;
