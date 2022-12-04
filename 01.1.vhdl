----------------------------
-- max calories computer
----------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity max_calories_computer is
  generic (
    constant calories_max_bits: integer
  );
  port (
    clk: in std_logic;
    next_elf: in std_logic;
    calories: in std_logic_vector(calories_max_bits - 1 downto 0);
    --
    max_calories: out std_logic_vector(calories_max_bits downto 0)
  );
end max_calories_computer;

architecture rtl of max_calories_computer is
  signal current_elf_sum: unsigned(calories_max_bits downto 0);
  signal current_max_calories: unsigned(calories_max_bits downto 0);
begin
  process(clk) is
  begin
    if rising_edge(clk) then
      if next_elf = '1' then
        if current_elf_sum > current_max_calories then
          current_max_calories <= current_elf_sum;
        end if;
        current_elf_sum <= to_unsigned(0, 18);
      else
        current_elf_sum <= current_elf_sum + unsigned(calories);
      end if;
    end if;
  end process;
  max_calories <= std_logic_vector(current_max_calories);
end rtl;

----------------------------
-- Test bench
----------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity aoc_01_1 is

end aoc_01_1;

architecture behavior of aoc_01_1 is

  constant calories_max_bits: integer := 17;

  component module_computer is
    port (
      clk: in std_logic;
      next_elf: in std_logic;
      calories: in std_logic_vector(calories_max_bits - 1 downto 0);
      --
      max_calories: out std_logic_vector(calories_max_bits downto 0)
    );
  end component module_computer;

  file input_file: text;

  signal r_clk: std_logic;
  signal r_next_elf: std_logic;
  signal r_calories: std_logic_vector(calories_max_bits - 1 downto 0);
  signal w_max_calories: std_logic_vector(calories_max_bits downto 0);

begin

  module_computer_inst: module_computer
    port map (
      clk => r_clk,
      next_elf => r_next_elf,
      calories => r_calories,
      max_calories => w_max_calories
    );

  process
    variable introduction : line;
    variable aliment_calories_line : line;
    variable aliment_calories : unsigned(calories_max_bits - 1 downto 0);

  begin

    file_open(input_file, "01.input", read_mode);

    while not endfile(input_file) loop
      readline(input_file, aliment_calories_line);
      if aliment_calories_line.all /= "" then
        write (introduction, String'("Found calories:"));
        writeline (output, introduction);
        writeline (output, aliment_calories_line);
        r_next_elf <= '0';
        read(aliment_calories_line, aliment_calories);
        r_calories <= std_logic_vector(aliment_calories);
      else
        write (introduction, String'("next elf:"));
        writeline (output, introduction);
        r_next_elf <= '1';
      end if;
      r_clk <= '1';
      wait for 10 ns;
      r_clk <= '0';
      wait for 10 ns;
    end loop;
    r_next_elf <= '1';
    r_clk <= '1';
    -- TODO output max_calories

    file_close(input_file);

    wait;

  end process;

end behavior;
