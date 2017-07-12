library IEEE;
use IEEE.std_logic_1164.all;
entity controller is
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

end controller;
architecture description_controller of controller is
  --  s0 --> fetch ,  s2..29 --> ir instruction decode
  type state is (reseting_controller,
  fetch_one,
  fetch_two,
  wait_for_decode ,
  decoding, pc_update,
  execute_nothing,
  halting ,
  execute_ZFset,
  execute_ZF_clr,
  execute_CFset ,
  execute_CF_clr,
  execute_WP_clr,
  execute_move_register,
  execute_load_address ,
  execute_load_address_two,
  execute_save_address,
  execute_input_from_port,
  execute_output_to_port,
  execute_and ,
  execute_or ,
  execute_not ,
  execute_shift_left ,
  execute_shift_right ,
  execute_add ,
  execute_subtraction ,
  execute_multiply ,
  execute_compare ,
  execute_move_immd_low,
  execute_move_immd_high,
  execute_save_pc,
  execute_jump_address,
  execute_jump_relative,
  execute_branch_if_zero,
  execute_branch_if_carry,
  execute_add_WP);
  signal controller_state : state := reseting_controller;
  signal upcoming_state : state;
  begin
    -- next to current
    process (clk,External_Reset)
    begin
      if External_Reset = '1' then
        controller_state <= reseting_controller;
      elsif rising_edge(clk) then
        controller_state <= upcoming_state;
      end if;
    end process;
    -- next based on state
    process (controller_state)
    begin
      ResetPC  <='0';
      PCplusI  <='0';
      PCplus1  <='0';
      RplusI  <='0';
      Rplus0 <='0';
      EnablePC <='0';
      CSet  <='0';
      CReset  <='0';
      ZSet  <='0';
      ZReset  <='0';
      SRload  <='0';
      RFLwrite <='0';
      RFHwrite <='0';
      WPadd <='0';
      WPreset <='0';
      IRload <='0';
      opcode <= "0000";
      Address_on_Databus <='0';
      ALUout_on_Databus	 <='0';
      Rs_on_AddressUnitRSide <='0';
      Rd_on_AddressUnitRSide <='0';
      PortNumber <= "000000";
      ReadPort <= '0';
      WritePort<='0';
      ReadMem  <='0';
      WriteMem <='0';
      case controller_state is
        --  reset states of the controller
        when reseting_controller =>
        ResetPC <= '1';
        EnablePC <= '1';
        CReset <= '1';
        ZReset <= '1';
        WPreset <= '1';
        upcoming_state <= fetch_one;
        when fetch_one =>
        -- fist fetch data
        ReadMem <= '1';
        upcoming_state <= fetch_two;
        when fetch_two =>
        -- second fetch data
        ReadMem <= '1';
        IRLoad <= '1';
        upcoming_state <= wait_for_decode;
        when wait_for_decode =>
        upcoming_state <= decoding;
        when decoding =>
        -- Decode IR_output_to_controller
        case(IRdataIN(15 downto 12)) is
          when "0000"=>
          case(IRdataIN(11 downto 8)) is
            when "0000" =>
            upcoming_state <= execute_nothing;  -- no operation
            when "0001" =>
            upcoming_state <= halting;      --  halt ,fetching stops
            when "0010" =>
            upcoming_state <= execute_ZFset;      -- Z<='1' and fetch
            when "0011" =>
            upcoming_state <= execute_ZF_clr;  -- Z<='0' and fetch
            when "0100"	=>
            upcoming_state <= execute_CFset;  -- C<='1' and fetch
            when "0101"	=>
            upcoming_state <= execute_CF_clr;   -- C<='0' and fetch
            when "0110"	=>
            upcoming_state <= execute_WP_clr;    -- WP<="000" and fetch
            when "0111"	=>
            upcoming_state <= execute_jump_relative;   -- PC <= PC + I
            when "1000"	=>
            upcoming_state <= execute_branch_if_zero; -- PC <= PC + I if Z is  1
            when "1001"	=>
            upcoming_state <= execute_branch_if_carry; -- PC <= PC + I if C is  1
            when "1010"=>
            upcoming_state <= execute_add_WP;  -- WP <= WP + I  and fetch
            when others =>
            upcoming_state <= reseting_controller;
          end case;
          when "0001" =>
          upcoming_state <= execute_move_register;      --   Rd <= Rs
          when "0010" =>
          upcoming_state <=execute_load_address;   --   Rd <= (Rs)
          when "0011" =>
          upcoming_state <= execute_save_address;     --   (Rd) <= Rs
          when "0100" =>
          upcoming_state <= execute_input_from_port;           -- input form port mannager goes to Rd
          when "0101" =>
          upcoming_state <= execute_output_to_port;          -- out from Rs goes to portmanger
          when "0110" =>
          upcoming_state <= execute_and; -- Rd <= Rd & Rs
          when "0111" =>
          upcoming_state <= execute_or; -- Rd <= Rd | Rs
          when "1000" =>
          upcoming_state <= execute_not;  -- Rd <= ~Rs
          when "1001" =>
          upcoming_state <= execute_shift_left; -- Rd <=sla Rs
          when "1010" =>
          upcoming_state <= execute_shift_right; -- Rd <= sra Rs
          when "1011" =>
          upcoming_state <= execute_add; -- Rd <= Rd + Rs+ C
          when "1100" =>
          upcoming_state <= execute_subtraction; -- Rd <= Rd - Rs - C
          when "1101" =>
          upcoming_state <= execute_multiply; -- Rd <= Rd * Rs 8 bit multiply
          when "1110" =>
          upcoming_state <= execute_compare; -- Rd , Rs (if equal:Z=1; if Rd<Rs :C=1)
          when "1111" =>
          -- we care about IR (9 downto 8)
          case(IRdataIN(9 downto 8)) is
            when "00" =>
            upcoming_state <= execute_move_immd_low;-- Rdl <= {8'bZ,I}
            when "01" =>
            upcoming_state <= execute_move_immd_high;-- Rdl <= {I,8'bZ}
            when "10" =>
            upcoming_state <= execute_save_pc; -- Rd<= PC +I
            when "11" =>
            upcoming_state <= execute_jump_address; --PC <= Rd+I
            when others =>
            upcoming_state <= reseting_controller;
          end case;
          when others =>
          upcoming_state <= reseting_controller;
        end case;
        when pc_update =>
        EnablePC <= '1';
        PCplus1 <= '1';
        upcoming_state <= fetch_one;
        when  execute_nothing =>
        EnablePC <= '1';
        PCplus1 <= '1';
        upcoming_state <= fetch_one;
        when halting =>
        upcoming_state <= halting;
        when  execute_ZFset =>
        ZSet <= '1';
        EnablePC <= '1';
        PCplus1 <= '1';
        upcoming_state <= fetch_one;
        when  execute_ZF_clr =>
        EnablePC <= '1';
        PCplus1 <= '1';
        ZReset <= '1';
        upcoming_state <= fetch_one;
        when  execute_CFset =>
        CSet <= '1';
        EnablePC <= '1';
        PCplus1 <= '1';
        upcoming_state <= fetch_one;
        when  execute_CF_clr =>
        EnablePC <= '1';
        PCplus1 <= '1';
        CReset <= '1';
        upcoming_state <= fetch_one;
        when  execute_WP_clr =>
        WPreset <= '1';
        EnablePC <= '1';
        PCplus1 <= '1';
        upcoming_state <= fetch_one;
        when  execute_move_register =>
        opcode <= "1101";
        ALUout_on_Databus <= '1';
        RFLwrite <= '1';
        RFHwrite <= '1';
        EnablePC <= '1';
        PCplus1 <= '1';
        upcoming_state <= fetch_one;
        when  execute_load_address =>
        Rs_on_AddressUnitRSide <= '1';
        Rplus0 <= '1';
        ReadMem <= '1';
        upcoming_state <= execute_load_address_two;
        when execute_load_address_two =>
        ReadMem <= '1';
        RFHwrite <= '1';
        RFLwrite <= '1';
        upcoming_state <= pc_update;
        when  execute_save_address =>
        opcode <= "1101";
        ALUout_on_Databus <= '1';
        Rd_on_AddressUnitRSide <= '1';
        Rplus0 <= '1';
        WriteMem <= '1';
        upcoming_state <= pc_update;
        when execute_input_from_port =>
           PortNumber <="110011";
           ReadPort<='1';
           upcoming_state <= pc_update;
           when execute_output_to_port =>
              PortNumber <="110011";
              WritePort<='1';
              upcoming_state <= pc_update;
        when  execute_and =>
        opcode <= "0000";
        ALUout_on_Databus <= '1';
        RFLwrite <= '1';
        RFHwrite <= '1';
        EnablePC <= '1';
        PCplus1 <= '1';
        upcoming_state <= fetch_one;
        when  execute_or =>
        opcode <= "0001";
        ALUout_on_Databus <= '1';
        RFLwrite <= '1';
        RFHwrite <= '1';
        EnablePC <= '1';
        PCplus1 <= '1';
        upcoming_state <= fetch_one;
        when  execute_not =>
        opcode <= "1110";
        ALUout_on_Databus <= '1';
        RFLwrite <= '1';
        RFHwrite <= '1';
        EnablePC <= '1';
        PCplus1 <= '1';
        upcoming_state <= fetch_one;
        when  execute_shift_left =>
        opcode <= "1001";
        ALUout_on_Databus <= '1';
        RFLwrite <= '1';
        RFHwrite <= '1';
        EnablePC <= '1';
        PCplus1 <= '1';
        upcoming_state <= fetch_one;
        when  execute_shift_right =>
        opcode <= "1000";
        ALUout_on_Databus <= '1';
        RFLwrite <= '1';
        RFHwrite <= '1';
        EnablePC <= '1';
        PCplus1 <= '1';
        upcoming_state <= fetch_one;
        when  execute_add =>
        opcode <= "0100";
        SRload <= '1';
        ALUout_on_Databus <= '1';
        RFLwrite <= '1';
        RFHwrite <= '1';
        EnablePC <= '1';
        PCplus1 <= '1';
        upcoming_state <= fetch_one;
        when  execute_subtraction =>
        opcode <= "0101";
        SRload <= '1';
        ALUout_on_Databus <= '1';
        RFLwrite <= '1';
        RFHwrite <= '1';
        EnablePC <= '1';
        PCplus1 <= '1';
        upcoming_state <= fetch_one;
        when  execute_multiply =>
        opcode <= "0110";
        SRload <= '1';
        ALUout_on_Databus <= '1';
        RFLwrite <= '1';
        RFHwrite <= '1';
        EnablePC <= '1';
        PCplus1 <= '1';
        upcoming_state <= fetch_one;
        when  execute_compare =>
        opcode <= "0010";
        RFLwrite <= '1';
        RFHwrite <= '1';
        EnablePC <= '1';
        PCplus1 <= '1';
        upcoming_state <= fetch_one;
        when  execute_move_immd_low =>
        RplusI <= '1';
        Address_on_Databus <= '1';
        RFLwrite <= '1';
        upcoming_state <= pc_update;
        when  execute_move_immd_high =>
        RplusI <= '1';
        Address_on_Databus <= '1';
        RFHwrite <= '1';
        upcoming_state <= pc_update;
        when  execute_save_pc =>
        PCplusI <= '1';
        Address_on_Databus <= '1';
        RFHwrite <= '1';
        RFLwrite <= '1';
        upcoming_state <= pc_update;
        when  execute_jump_address =>
        Rd_on_AddressUnitRSide <= '1';
        RplusI <= '1';
        EnablePC <= '1';
        upcoming_state <= fetch_one;
        when  execute_jump_relative =>
        EnablePC <= '1';
        PCplusI <='1';
        upcoming_state <= fetch_one;
        when  execute_branch_if_zero =>
        EnablePC <= '1';
        if (Zin = '1' ) then
          PCplusI <= '1';
        else
          PCplus1 <= '1';
        end if;
        upcoming_state <= fetch_one;
        when   execute_branch_if_carry =>
        EnablePC <= '1';
        if (Cin  = '1' ) then
          PCplusI <= '1';
        else
          PCplus1 <= '1';
        end if;
        upcoming_state <= fetch_one;
        when  execute_add_WP =>
        WPadd <= '1';
        EnablePC <= '1';
        PCplus1 <= '1';
        upcoming_state <= fetch_one;
        when others =>
        upcoming_state <= reseting_controller;
      end case;
    end process;
  end description_controller;
