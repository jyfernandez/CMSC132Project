library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.textio.all;
use ieee.std_logic_textio.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


ENTITY file_read is
END file_read;

ARCHITECTURE behave OF file_read is

    -- ARRAYS
    type instruction_array is array (0 to 10) of string(1 to 6);
    type register_array is array (0 to 32) of string(1 to 6);
    type immediate_array is array (0 to 32) of string(1 to 6);
    type operand_array is array (0 to 32) of string(1 to 6);

    -- FUNCTIONS
    function classifyOC (opcode: in string)
        return integer is variable classification : integer := -1;
        begin
            if(opcode(1) = '0') 
                then if(opcode(2) = '0') then -- 00 opcode 
                    report "instruction";
                    classification := 1;
                elsif(opcode(2) = '1') then -- 01 immediate
                    report "immediate";
                    classification := 3;                             
                end if;
            elsif (opcode(1) = '1') then -- 10 register
                report "register";
                classification := 2;                            
            end if;
        
        return classification;
    end function classifyOC;

    function specifyINST (instruction: in string)
        return integer is variable classification : integer := -1;
        begin
            if( instruction = "000000" ) then
                report "Load";
                classification := 1;
            elsif( instruction = "000001" ) then
                report "Add";
                classification := 2;
            elsif( instruction = "000010") then
                report "Sub";
                classification := 3;
            elsif(instruction = "000011") then
                report "Mul";
                classification := 4;
            elsif(instruction = "000100") then
                report "Div";
                classification := 5;
            elsif(instruction = "000101") then
                report "Mod" ;
                classification := 6;
            else
                report instruction;
            end if;
        return classification;
    end function specifyINST;

    function specifyIMMDT (immediate: in string)
        return integer is variable classification : integer := -1;
        begin
            if( immediate = "010000" ) then
                report "0";
                classification := 0;
            elsif ( immediate = "010001" ) then
                report "1";
                classification := 1;
            elsif ( immediate = "010010" ) then
                report "2";
                classification := 2;
            elsif ( immediate = "010011" ) then
                report "3";
                classification := 3;
            else
                report "Invalid"; 
            end if;
        return classification;
    end function specifyIMMDT;



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
            variable classification : integer :=0;

            -- variable for instruction
            variable opcode : string(1 to 6);
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

                    for i in 1 to 4 loop
                        READ(line_num, opcode); -- get opcode
                        if (i /= 3) then
                            read(line_num, space); -- get space
                        end if;

                        -- Classify Opcodes
                        classification := classifyOC(opcode);

                        -- Store Opcodes
                        if(classification = 1) then
                            instructions(i_counter) := opcode;
                            i_counter := i_counter + 1;
                        elsif(classification = 2) then
                            registers(r_counter) := opcode;    
                            operands(o_counter) := opcode;                                                                                                                     
                            r_counter := r_counter + 1;
                            o_counter := o_counter + 1;   
                        elsif(classification = 3) then
                            immediates(m_counter) := opcode;                                 
                            operands(o_counter) := opcode;                                 
                            m_counter := m_counter + 1;
                            o_counter := o_counter + 1;
                        end if;  
                    end loop;
                    
                    i := i + 1; -- increment indexing
                end loop;

                -- close the file
                file_close(file_pointer);

                no_of_instructions := i; -- secure the size of instructions




                wait;
        end process;

end behave;

-- -- Specifying Instruction
-- report " ";
-- report "SPECIFYING INSTRUCTIONS";
-- for i in 0 to no_of_instructions-1 loop
--     classification := specifyINST(instructions(i));
-- end loop;

-- -- Specifying Immediate
-- report " ";
-- report "SPECIFYING IMMEDIATE";
-- for i in 0 to m_counter-1 loop
--     classification := specifyIMMDT(immediates(i));
-- end loop;