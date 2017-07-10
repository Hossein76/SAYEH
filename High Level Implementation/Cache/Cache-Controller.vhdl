library ieee;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;


---------------
entity cache_controller  is
  port (
    clk : in std_logic;
    address : in std_logic_vector(9 downto 0);
    w0_tagvalid_input, w1_tagvalid_input : in std_logic_vector(4 downto 0);
    read_data , write_data , memory_data_ready , hit , w0_valid , w1_valid , mru_input: in std_logic;
    w0_data_wren  ,  w0_tagvalid_wren , w0_Invalidate ,w1_data_wren, w1_tagvalid_wren , w1_Invalidate1 ,  Read_from_Mem ,  Write_to_Mem , access_signal : out std_logic;
    wreplace : out std_logic_vector(1 downto 0)
    );
end cache_controller;

architecture description_cache_controller of cache_controller is

  type state is (Initial_state , Initial_state_2 , Read_data_State , WAITING , Writing_data_to_Mem ,writing_data2, Reading_data_from_Mem , Writing_data_to_Cache);
  signal current_state , upcoming_state  : state;

begin
  process (clk)
  begin
    if rising_edge(clk) then
      current_state <= upcoming_state;
    end if;
  end process;

  process (current_state)
  begin
    w0_data_wren <= '0';
    w1_data_wren <= '0';
    w0_tagvalid_wren <= '0';
    w0_Invalidate <= '0';
    w1_Invalidate1 <= '0';
    Read_from_Mem <= '0';
    Write_to_Mem <= '0';
    access_signal <= '0';
    wreplace <= "00";
    w1_tagvalid_wren <= '0';

    case current_state is

      when Initial_state =>
        upcoming_state <= Initial_state_2;

      when Initial_state_2 =>
      if(read_data = '1') then
          upcoming_state <= Read_data_State;
      elsif (write_data = '1') then
        Write_to_Mem <= '1';
        upcoming_state <= Writing_data_to_Mem;
      else
        upcoming_state <= Initial_state;
      end if;

      when Writing_data_to_Mem   =>

        if(w0_valid = '1') and address(9 downto 6)=w0_tagvalid_input(3 downto 0) then

          w0_Invalidate <= '1';
          w0_tagvalid_wren <= '0';
        end if;
        if(w1_valid = '1') and address(9 downto 6)=w1_tagvalid_input(3 downto 0) then
          w1_Invalidate1 <= '1';
          w1_tagvalid_wren <= '0';
        end if;
        upcoming_state <= Initial_state;



      when Writing_data_to_Cache =>
        if(w0_tagvalid_input(4) = '0') then
          w0_data_wren <= '1';
          w0_tagvalid_wren <= '1';
          wreplace  <= "10";
        elsif (w1_tagvalid_input(4) = '0') then
          w1_data_wren <= '1';
          w1_tagvalid_wren <= '1';
          wreplace  <= "11";
        elsif (w0_tagvalid_input(4) = '1' and w1_tagvalid_input(4) = '1') then
          if(mru_input = '0') then
            w0_data_wren <= '1';
            w0_tagvalid_wren <= '1';
            wreplace  <= "10";
          else
            w1_data_wren <= '1';
            w1_tagvalid_wren <= '1';
            wreplace  <= "11";
          end if;
        end if;
        upcoming_state <= Initial_state;

        when Read_data_State =>
          if(hit = '1') then
            access_signal <= '1';
            upcoming_state <= Initial_state;
          else
            Read_from_Mem <= '1';
            upcoming_state <= Reading_data_from_Mem;
          end if;

        when Reading_data_from_Mem =>
          Read_from_Mem <= '1';
          upcoming_state <= WAITING;

        when WAITING =>
          Read_from_Mem <= '1';
          upcoming_state <= Writing_data_to_Cache;
      when Others =>

    end case;
  end process;

end description_cache_controller;
