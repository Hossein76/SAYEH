library IEEE;

use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY ADDRESS_LOGIC IS
    PORT (
        PCside, Rside : IN std_logic_vector (15 DOWNTO 0);
        Iside : IN std_logic_vector (7 DOWNTO 0);
        ALout : OUT std_logic_vector (15 DOWNTO 0);
        ResetPC, PCplusI, PCplus1, RplusI, Rplus0 : IN std_logic
    );
END ADDRESS_LOGIC;
ARCHITECTURE ADDRESS_LOGIC_ARCH of ADDRESS_LOGIC IS
    CONSTANT one   : std_logic_vector (4 DOWNTO 0)
                   := "10000";
    CONSTANT two   : std_logic_vector (4 DOWNTO 0)
                   := "01000";
    CONSTANT three : std_logic_vector (4 DOWNTO 0)
                   := "00100";
    CONSTANT four  : std_logic_vector (4 DOWNTO 0)
                   := "00010";
    CONSTANT five  : std_logic_vector (4 DOWNTO 0)
                   := "00001";
BEGIN
    PROCESS (PCside, Rside, Iside, ResetPC,
            PCplusI, PCplus1, RplusI, Rplus0)
        VARIABLE temp : std_logic_vector (4 DOWNTO 0);
BEGIN
        temp := (ResetPC & PCplusI & PCplus1 & RplusI & Rplus0);
        CASE temp IS
            WHEN one => ALout <= (OTHERS => '0');
            WHEN two => ALout <= std_logic_vector(unsigned(PCside) + unsigned(Iside));
            WHEN three => ALout <= std_logic_vector(unsigned(PCside) + 1);
            WHEN four => ALout <= std_logic_vector(unsigned(Rside)+ unsigned(Iside));
            WHEN five => ALout <= Rside;
            WHEN OTHERS => ALout <= PCside;
        END CASE;
    END PROCESS;
END ADDRESS_LOGIC_ARCH;