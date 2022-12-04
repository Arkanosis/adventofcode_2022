use std.textio.all;

entity aoc_01_2 is

end aoc_01_2;

architecture behavior of aoc_01_2 is

  constant calories_max_digits: natural := 5;

  file input_file: text;

begin

  process
    variable introduction : line;
    variable aliment_calories : line;

  begin

    file_open(input_file, "01.input", read_mode);

    while not endfile(input_file) loop
      readline(input_file, aliment_calories);
      write (introduction, String'("Found calories:"));
      writeline (output, introduction);
      writeline (output, aliment_calories);
      wait for 10 ns;
    end loop;

    file_close(input_file);

    wait;

  end process;

end behavior;
