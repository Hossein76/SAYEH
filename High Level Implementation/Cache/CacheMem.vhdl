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
  Data_input : in std_logic_vector(15 downto 0);
  Data_Output : out std_logic_vector (15 downto 0)
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
      hit , w0_valid,w1_valid ,access_signal: in std_logic ;
      wreplace : in std_logic_vector(1 downto 0);
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
      w0_tagvalid_input, w1_tagvalid_input : in std_logic_vector(4 downto 0);
      read_data , write_data , memory_data_ready , hit , w0_valid , w1_valid , mru_input: in std_logic;
      w0_data_wren  ,  w0_tagvalid_wren , w0_Invalidate ,w1_data_wren, w1_tagvalid_wren , w1_Invalidate1 ,  Read_from_Mem ,  Write_to_Mem , access_signal : out std_logic;
      wreplace : out std_logic_vector(1 downto 0)
      );
      end component;

      signal  w0_data_wren, w1_data_wren, w0_tagvalid_wren, w1_tagvalid_wren, w0_tagvalid_reset, w1_tagvalid_reset,
              w0_tagvalid_invalidate, w1_tagvalid_invalidate, hit , w0_valid , w1_valid, w0_p1, w1_p1, w0_reset, w1_reset, w0_confirm, w1_confirm,
              memdataready, readMem , writeMem , mru_access_signal  ,way_select_signal   : std_logic;
              signal mru_wreplace : std_logic_vector (1 downto 0);
      signal w0_data_output , w1_data_output , w0_data_input , w1_data_input , data_to_cpu , Mem_data_inout : std_logic_vector(15 downto 0);
      signal w0_tagvalid_output , w1_tagvalid_output : std_logic_vector(4 downto 0);
  begin

        cache_controller_module : cache_controller port map(clk , AddressBus  , w0_tagvalid_output , w1_tagvalid_output , Read_Data , Write_Data , memdataready , hit , w0_valid , w1_valid ,
                              way_select_signal, w0_data_wren ,w0_tagvalid_wren, w0_tagvalid_invalidate,w1_data_wren  , w1_tagvalid_wren  ,
                                  w1_tagvalid_invalidate , readMem , writeMem,mru_access_signal,mru_wreplace);

    w0_data_array_module : data_array port map (clk , AddressBus(5 downto 0) , w0_data_wren , w0_data_input , w0_data_output);
    w1_data_array_module : data_array port map (clk , AddressBus(5 downto 0) , w1_data_wren , w1_data_input , w1_data_output);

    w0_tagvalid_module : tag_valid_array port map(clk , w0_tagvalid_reset , AddressBus(5 downto 0) , w0_tagvalid_wren , w0_tagvalid_invalidate , AddressBus(9 downto 6) , w0_tagvalid_output);
    w1_tagvalid_module : tag_valid_array port map(clk , w1_tagvalid_reset , AddressBus(5 downto 0) , w1_tagvalid_wren , w1_tagvalid_invalidate , AddressBus(9 downto 6) , w1_tagvalid_output);

    miss_hit_logic_module : miss_hit_logic port map(AddressBus(9 downto 6) , w0_tagvalid_output , w1_tagvalid_output , hit, w0_valid , w1_valid);

    data_selection_module : data_selection port map(w0_valid , w1_valid , w0_data_output , w1_data_output , data_to_cpu);

    mru_module : most_recently_used_array port map(clk , AddressBus(5 downto 0) , hit , w0_valid , w1_valid, mru_access_signal , mru_wreplace , way_select_signal);
    mem_module : Memory port map(clk , readMem , writeMem , AddressBus , Mem_data_inout , memdataready);

      Mem_data_inout <= Data_input when  Write_Data = '1' else  "ZZZZZZZZZZZZZZZZ";
      w0_data_input <= Mem_data_inout;
      w1_data_input <= Mem_data_inout;

      Data_Output <= data_to_cpu when hit = '1' else
                Mem_data_inout ;
  end description_cache_memory;
