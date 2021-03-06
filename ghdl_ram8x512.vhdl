use WORK.ALL;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use Std.TextIO.all;
use work.debugtools.all;

ENTITY ram8x512 IS
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    clkb : IN STD_LOGIC;
    enb : IN STD_LOGIC;
    web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addrb : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    dinb : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END ram8x512;

architecture behavioural of ram8x512 is

  type ram_t is array (0 to 511) of std_logic_vector(7 downto 0);
  signal ram : ram_t;

begin  -- behavioural

  process(clka)
  begin
    if(rising_edge(Clka)) then
      report "ram(0) = $" & to_hstring(ram(0)) severity note;
      if ena='1' then
        if(wea="1") then
          ram(to_integer(unsigned(addra))) <= dina;
          report "writing $" & to_hstring(dina) & " to sector buffer offset $"
            & to_hstring("000" & addra) severity note;
        end if;
        douta <= ram(to_integer(unsigned(addra)));
      else
        douta <= "ZZZZZZZZ";
      end if;
    end if;
  end process;

  process (clkb)
  begin
    if(rising_edge(Clkb)) then 
      if enb='1' then
        if(web="1") then
          ram(to_integer(unsigned(addrb))) <= dinb;
          report "writing $" & to_hstring(dinb) & " to sector buffer offset $"
            & to_hstring("000" & addrb) severity note;
        end if;
        report "reading from sector buffer at offset %" & to_string(addrb)
        severity note;
        doutb <= ram(to_integer(unsigned(addrb)));
      else
        doutb <= "ZZZZZZZZ";
      end if;
    end if;
  end process;

end behavioural;
