LIBRARY ieee;
USE iEEE.std_logic_1164.ALL;
use STD.textio.all; -- for file operations

ENTITY file_read is
END file_read;

ARCHITECTURE behave OF file_read is

    -- array of lines
    type instructions_array is array (0 to 14) of line;

    -- array of strings

    BEGIN 
        -- file reading
        process
            file file_pointer : text; -- pointed to the text file
            variable line_num : line; -- temporary holder for line

            variable instructions: instructions_array; -- array of instructions
            variable i : integer := 0; -- index
            variable no_of_instructions : integer := 0; -- size of instructions

            begin
                -- open the file in Read mode
                file_open(file_pointer,".\read.txt",READ_MODE);    
                
                -- traverse the whole file
                while not endfile(file_pointer) loop
                    readline (file_pointer, line_num); -- read a specific line
                    instructions(i) := line_num; -- put the line to the array
                    i := i + 1; -- increment indexing
                end loop;

                no_of_instructions := i; -- secure the size of instructions

                -- print the instructions
                for i in 0 to no_of_instructions loop 
                    writeline(output, instructions(i));
                end loop;
                



                -- close the file
                file_close(file_pointer);
                wait;
        end process;

end behave;