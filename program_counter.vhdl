use WORK.ALL;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use Std.TextIO.all;
use work.debugtools.all;

entity program_counter is
  port (
    clock : in std_logic;
    pcl_in : unsigned(7 downto 0);
    pch_in : unsigned(7 downto 0);

    branch8_in : unsigned(7 downto 0);
    branch16_in : unsigned(15 downto 0);

    set_pcl : in std_logic;
    set_pch : in std_logic;
    inc_pc : in std_logic;
    take_branch8 : in std_logic;
    take_branch16 : in std_logic;

    pc_out : out unsigned(15 downto 0)
    );
end entity program_counter;

architecture behavioural of program_counter is
  signal pc_in : unsigned(15 downto 0) := x"0000";
begin  -- behavioural

  -- purpose: calculate new value of PC
  -- type   : sequential
  -- inputs : clock, pc_in, pcl_in, pch_in, branch8_in, branch16_in, set_pcl, set_pch, inc_pc, take_branch8, take_branch16
  -- outputs: pc_out
  pc: process (clock)
    variable new_pc : unsigned(15 downto 0);
  begin  -- process pc
    if rising_edge(clock) then
      if inc_pc='1' then
        new_pc := pc_in + 1;
      elsif set_pcl='1' and set_pch='0' then
        new_pc(7 downto 0) := pcl_in;
        new_pc(15 downto 8) := pc_in(15 downto 8);
      elsif set_pcl='0' and set_pch='1' then
        new_pc(7 downto 0) := pc_in(7 downto 0);
        new_pc(15 downto 8) := pch_in;
      elsif set_pcl='1' and set_pch='1' then
        new_pc(7 downto 0) := pcl_in;
        new_pc(15 downto 8) := pch_in;
      elsif take_branch8='1' then
        if branch8_in(7)='0' then -- branch forwards.
          new_pc := pc_in + branch8_in(6 downto 0) - 1;
        else -- branch backwards.
          new_pc := (pc_in - x"0081") + branch8_in(6 downto 0);
        end if;
      elsif take_branch16='1' then
        if branch16_in(15)='0' then -- branch forwards.
          new_pc := pc_in + branch16_in(14 downto 0) - 1;
        else -- branch backwards.
          new_pc := (pc_in - x"8001") + branch16_in(14 downto 0);
        end if;
      else
        new_pc := pc_in;
      end if;      
      pc_in <= new_pc;
      pc_out <= new_pc;
    end if;
  end process pc;

end behavioural;
