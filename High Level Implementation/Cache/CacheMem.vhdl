library ieee;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;


---------------
entity cache_memory is
  port (
  clk : in std_logic;
  Read_Data : in std_logic;
  Write_Data : in std_logic;
  AddressBus: in std_logic_vector (9 downto 0);
  dataIn : in std_logic_vector(15 downto 0);
  dataOut : out std_logic_vector (15 downto 0)
  );
end cache_memory;
architecture description_cache_memory of cache_memory is

    component data_array is port (
    clk: in std_logic;
    address : in std_logic_vector(5 downto 0);
    wren : in std_logic;
    wrdata : in std_logic_vector(15 downto 0);
    data : out std_logic_vector(15 downto 0)
    );
    end component;

    component tag_valid_array is
      port (
      clk: in std_logic;
      reset_n : in std_logic;
      address : in std_logic_vector(5 downto 0);
      wren,invalidate : in std_logic;
      wrdata : in std_logic_vector(3 downto 0);
      output_signal : out std_logic_vector(4 downto 0)
      );
    end component;

    component miss_hit_logic is port (
    tag : in std_logic_vector(3 downto 0);
    w0,w1 : in std_logic_vector(4 downto 0);
    hit : out std_logic;
    w0_valid,w1_valid : out std_logic
    );
    end component;

    component data_selection is
      port (
      w0_valid,w1_valid : in std_logic;
      w0_data_in,w1_data_in : in std_logic_vector(15 downto 0);
      out_put : out std_logic_vector(15 downto 0)
      );
    end component;

    component most_recently_used_array is
      port (
      clk : in std_logic;
      address : in std_logic_vector(5 downto 0);
      hit : in std_logic;
      w0_valid,w1_valid : in std_logic ;
      wprevious : in std_logic;
      way_select : out std_logic
      );
    end component;

    component Memory is
    	generic (blocksize : integer := 1024);
    	port (
    		clk, ReadMem, WriteMem : in std_logic;
    		AddressBus: in std_logic_vector (9 downto 0);
    		DataBus : inout std_logic_vector (15 downto 0);
    		memdataready : out std_logic
    		);
      end component;

      component cache_controller is   port (
      clk : in std_logic;
      address : in std_logic_vector(9 downto 0);
      index : in std_logic_vector(5 downto 0);
      tag : in std_logic_vector(3 downto 0);
      w0_tagvalid_input, w1_tagvalid_input : in std_logic_vector(4 downto 0);
      read_data , write_data , memory_data_ready , hit , w0_valid , w1_valid , w0_tagvalid_valid , w1_tagvalid_valid , mru_input: in std_logic;
      w0_data_wren ,  w1_data_wren ,  w0_tagvalid_wren , w1_tagvalid_wren , w0_Invalidate , w1_Invalidate1 ,  Read_from_Mem ,  Write_to_Mem : out std_logic
      );
      end component;

      signal  dwriteEnable0, dwriteEnable1, tvwriteEnable0, tvwriteEnable1, reset_n0, reset_n1,
              invalidate0, invalidate1, hit , w0_valid , w1_valid, w0_p1, w1_p1, w0_reset, w1_reset, w0_confirm, w1_confirm,
              memdataready, readMem , writeMem : std_logic;
      signal dataOut0 , dataOut1 , writeData0 , writeData1 , cacheFinalOut , memInOut : std_logic_vector(15 downto 0);
      signal tvOut0 , tvOut1 : std_logic_vector(4 downto 0);
  begin

    dw0 : dataArray port map (clk , AddressBus(5 downto 0) , dwriteEnable0 , writeData0 , dataOut0);
    dw1 : dataArray port map (clk , AddressBus(5 downto 0) , dwriteEnable1 , writeData1 , dataOut1);

    tvw0 : tagValidArray port map(clk , reset_n0 , AddressBus(5 downto 0) , tvwriteEnable0 , invalidate0 , AddressBus(9 downto 6) , tvOut0);
    tvw1 : tagValidArray port map(clk , reset_n1 , AddressBus(5 downto 0) , tvwriteEnable1 , invalidate1 , AddressBus(9 downto 6) , tvOut1);

    mhl : missHitLogic port map(AddressBus(9 downto 6) , tvOut0 , tvOut1 , hit, w0_valid , w1_valid);

    ds : dataSelection port map(w0_valid , w1_valid , dataOut0 , dataOut1 , cacheFinalOut);

    --mru : mruArray port map(clk , AddressBus(5 downto 0) , w0_p1 , w1_p1 , w0_reset , w1_reset , w0_confirm , w1_confirm);
    mem : Memory port map(clk , readMem , writeMem , AddressBus , memInOut , memdataready);

    con : controller port map(clk , AddressBus(5 downto 0) , AddressBus(9 downto 6) , Read_Data , Write_Data , memdataready , hit , w0_valid , w1_valid ,
                              tvOut0(4) , tvOut1(4) , dwriteEnable0 , dwriteEnable1 ,tvwriteEnable0 , tvwriteEnable1 , invalidate0 ,
                              invalidate1 , readMem , writeMem);

      memInOut <= dataIn when Read_Data = '1' and Write_Data = '0' else dataIn when Write_ = '1' else "ZZZZZZZZZZZZZZZZ";
      writeData0 <= memInOut;
      writeData1 <= memInOut;

      dataOut <= cacheFinalOut when hit = '1' else
                memInOut when hit = '0' else
                "ZZZZZZZZZZZZZZZZ";
  end description_cache_memory;
