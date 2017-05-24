--------------------------------------------------------------------------------

-- Author:        Parham Alvani (parham.alvani@gmail.com)

--

-- Create Date:   16-03-2017

-- Module Name:   memory.vhd

--------------------------------------------------------------------------------

library IEEE;

use IEEE.std_logic_1164.all;

use IEEE.numeric_std.all;



entity memory is

	generic (blocksize : integer := 1024);



	port (clk, readmem, writemem : in std_logic;

		addressbus: in std_logic_vector (15 downto 0);

		databus : inout std_logic_vector (15 downto 0);

		memdataready : out std_logic);

end entity memory;



architecture behavioral of memory is

	type mem is array (0 to blocksize - 1) of std_logic_vector (15 downto 0);

begin

	process (clk)

		variable buffermem : mem := (others => (others => '0'));
		variable ad : integer;
		variable init : boolean := true;
	begin
		if init = true then
			-- some initiation
			buffermem(0) := "0000011100000011";
			buffermem(1) := "1111111111111111";
			buffermem(2) := "1111111111111111";
			buffermem(3) := "1111100000000001";
			buffermem(4) := "1111110000000010";
			buffermem(5) := "0010001000000000";
			buffermem(6) := "0010011100000000";
			buffermem(7) := "1100000100000000";
			buffermem(8) := "0000100000001010";
			buffermem(18) := "0110000100000000";


			init := false;
		end if;
		memdataready <= '0';
		if  clk'event and clk = '1' then

			ad := to_integer(unsigned(addressbus));
			if readmem = '1' then -- Readiing :)
				memdataready <= '1';
				if ad >= blocksize then
					databus <= (others => 'Z');
				else
					databus <= buffermem(ad);
				end if;
			elsif writemem = '1' then -- Writing :)
				memdataready <= '1';
				if ad < blocksize then
					buffermem(ad) := databus;
				end if;
			elsif readmem = '0' then
				databus <= (others => 'Z');
			end if;
		end if;
	end process;

end architecture behavioral;
