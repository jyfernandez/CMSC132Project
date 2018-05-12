library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.textio.all;
use ieee.std_logic_textio.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


ENTITY file_read is
END file_read;

ARCHITECTURE behave OF file_read is

    -- array of lines
    type instruction_array is array (0 to 10) of std_logic_vector(5 downto 0);
    type register_array is array (0 to 32) of std_logic_vector(5 downto 0);
    type immediate_array is array (0 to 32) of std_logic_vector(5 downto 0);
    type operand_array is array (0 to 32) of std_logic_vector(5 downto 0);



    BEGIN 
        process
            file file_pointer : text; -- pointed to the text file
            variable line_num : line; -- temporary holder for line

            variable no_of_instructions : integer := 0;
            variable i_counter : integer := 0; -- counter for instructions
            variable r_counter : integer := 0; -- counter for registers
            variable m_counter : integer := 0; -- counter for immediate
            variable o_counter : integer := 0; -- counter for operand
            variable i : integer := 0; -- index
            variable j : integer := 0; -- index

            -- variable for instruction
            variable opcode : std_logic_vector(0 to 5);
            -- variable for space
            variable space : character;

            -- arrays
            variable instructions : instruction_array;
            variable registers : register_array;
            variable immediates : immediate_array;
            variable operands : operand_array;
            

            begin
                -- open the file in Read mode
                file_open(file_pointer, ".\read.txt", READ_MODE);    
                
                -- File Reading and Classification
                report "CLASSIFICATION OF OPCODES";
                while not endfile(file_pointer) loop

                    readline (file_pointer, line_num); -- read a specific line

                    for i in 0 to 3 loop
                        read(line_num, opcode); -- get opcode
                        if (i /= 3) then
                            read(line_num, space); -- get space
                        end if;
                        
                        -- Classify Opcodes
                        if(opcode(0) = '0') 
                            then if(opcode(1) = '0') then -- 00 opcode 
                                report "instruction";
                                instructions(i_counter) := opcode;
                                i_counter := i_counter + 1;
                            elsif(opcode(1) = '1') then -- 01 immediate
                                report "immediate";
                                immediates(m_counter) := opcode;                                 
                                operands(o_counter) := opcode;                                 
                                m_counter := m_counter + 1;
                                o_counter := o_counter + 1;                                
                            end if;
                        elsif (opcode(0) = '1') then -- 10 register
                            report "register";
                            registers(r_counter) := opcode;    
                            operands(o_counter) := opcode;                                                                                                                     
                            r_counter := r_counter + 1;
                            o_counter := o_counter + 1;                            
                        end if;
                    end loop;
                    
                    i := i + 1; -- increment indexing
                end loop;

                no_of_instructions := i; -- secure the size of instructions

                            
                -- Specifying Instruction
                report " ";
                report "SPECIFYING INSTRUCTIONS";
                for i in 0 to no_of_instructions-1 loop
                    if( instructions(i)(0) = '0' and instructions(i)(1) = '0' and instructions(i)(2) = '0' ) then
                        report "Load";
                    elsif( instructions(i)(0) = '1' and instructions(i)(1) = '0' and instructions(i)(2) = '0' ) then
                        report "Add";
                    elsif( instructions(i)(0) = '0' and instructions(i)(1) = '1' and instructions(i)(2) = '0' ) then
                        report "Sub";
                    elsif(instructions(i)(0) = '1' and instructions(i)(1) = '1' and instructions(i)(2) = '0') then
                        report "Mul";
                    elsif(instructions(i)(0) = '0' and instructions(i)(1) = '0' and instructions(i)(2) = '1') then
                        report "Div";
                    elsif(instructions(i)(1) = '0' and instructions(i)(1) = '0' and instructions(i)(2) = '1') then
                        report "Mod" ;
                    else
                        report "Invalid";  
                    end if;
                end loop;
                
                -- Specifying Immediate
                report " ";
                report "SPECIFYING IMMEDIATE";
                for i in 0 to m_counter-1 loop
                    if( immediates(i)(0) = '0' and immediates(i)(1) = '0' ) then
                        report "0";
                    elsif ( immediates(i)(0) = '0' and immediates(i)(1) = '1' ) then
                        report "2";
                    elsif ( immediates(i)(0) = '1' and immediates(i)(1) = '0' ) then
                        report "1";
                    elsif ( immediates(i)(0) = '1' and immediates(i)(1) = '1' ) then
                        report "3";
                    else
                        report "Invalid";  
                    end if;
                end loop;

                -- Specifying Immediate
                report " ";
                report "SPECIFYING REGISTER";
                for i in 0 to r_counter-1 loop
                    if(registers(i)(4) = '0' and registers(i)(3) = '0' and registers(i)(2) = '0' and registers(i)(1) = '0' and registers(i)(0) = '0') then
                        report "R0";
                    elsif(registers(i)(4) = '0' and registers(i)(3) = '0' and registers(i)(2) = '0' and registers(i)(1) = '0' and registers(i)(0) = '1') then
                        report "R1";
                    elsif(registers(i)(4) = '0' and registers(i)(3) = '0' and registers(i)(2) = '0' and registers(i)(1) = '1' and registers(i)(0) = '0') then
                        report "R2";
                    elsif(registers(i)(4) = '0' and registers(i)(3) = '0' and registers(i)(2) = '0' and registers(i)(1) = '1' and registers(i)(0) = '0') then
                        report "R3";
                    elsif(registers(i)(4) = '0' and registers(i)(3) = '0' and registers(i)(2) = '1' and registers(i)(1) = '0' and registers(i)(0) = '0') then
                        report "R4";
                    elsif(registers(i)(4) = '0' and registers(i)(3) = '0' and registers(i)(2) = '1' and registers(i)(1) = '0' and registers(i)(0) = '1') then
                        report "R5";
                    else
                        report "Invalid";  
                    end if;
                end loop;



                -- close the file
                file_close(file_pointer);
                wait;
        end process;

end behave;

-- printing of whole instruction

    -- for i in 0 to 5 loop
    --     report std_logic'image(instruction(i));
    -- end loop;

-- getting of instruction

    -- read(line_num, operand_1); -- get first operand 
    -- read(line_num, space);                    
    -- read(line_num, operand_2); -- get second operand
    -- read(line_num, space);                    
    -- read(line_num, operand_3); -- get third operand

-- print all the instructions or registers or immediate
    -- for i in 0 to 2 loop
    --     for j in 5 downto 0 loop
    --         report std_logic'image(instructions(i)(j));
    --     end loop;
    --     report " ";
    -- end loop;