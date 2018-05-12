library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.textio.all;
use ieee.std_logic_textio.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


ENTITY file_read is
END file_read;

ARCHITECTURE behave OF file_read is

    -- ARRAYS of OPCODES
    type instruction_array is array (0 to 14) of string(1 to 6);
    type register_array is array (0 to 44) of string(1 to 6);
    type immediate_array is array (0 to 44) of string(1 to 6);
    type operand_array is array (0 to 44) of string(1 to 6);

    -- ARRAYS OF VALUES
    type register_values is array (0 to 32) of integer;

    -- FUNCTIONS
    function classifyOC (opcode: in string)
        return integer is variable classification : integer := -1;
        begin
            if(opcode(1) = '0') then 
                if(opcode(2) = '0') then -- 00 opcode 
                    classification := 1;
                elsif(opcode(2) = '1') then -- 01 immediate
                    classification := 3;                             
                end if;
            elsif(opcode(1) = '1') then -- 10 register
                classification := 2;                            
            end if;
        
        return classification;
    end function classifyOC;

    function specifyINST (instruction: in string)
        return integer is variable classification : integer := -1;
        begin
            if( instruction = "000000" ) then
                classification := 1;
            elsif( instruction = "000001" ) then
                classification := 2;
            elsif( instruction = "000010") then
                classification := 3;
            elsif(instruction = "000011") then
                classification := 4;
            elsif(instruction = "000100") then
                classification := 5;
            elsif(instruction = "000101") then
                classification := 6;
            else
                report "Invalid";
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

    function specifyREG (vregister: in string)
        return integer is variable classification : integer := -1;
        begin
            if(vregister = "100000") then
                classification := 0;
            elsif(vregister = "100001") then
                classification := 1;
            elsif(vregister = "100010") then
                classification := 2;
            elsif(vregister = "100011") then
                classification := 3;
            elsif(vregister = "100100") then
                classification := 4;
            elsif(vregister = "100101") then
                classification := 5;
            elsif(vregister = "100110") then
                classification := 6;
            elsif(vregister = "100111") then
                classification := 7;
            elsif(vregister = "101000") then
                classification := 8;
            elsif(vregister = "101001") then
                classification := 9;
            elsif(vregister = "101010") then
                classification := 10;
            elsif(vregister = "101011") then
                classification := 11;
            elsif(vregister = "101100") then
                classification := 12;
            elsif(vregister = "100111") then
                classification := 13;
            elsif(vregister = "101110") then
                classification := 14;
            elsif(vregister = "101111") then
                classification := 15;
            elsif(vregister = "110000") then
                classification := 16;
            elsif(vregister = "110001") then
                classification := 17;
            elsif(vregister = "110010") then
                classification := 18;
            elsif(vregister = "110011") then
                classification := 19;
            elsif(vregister = "110100") then
                classification := 20;
            elsif(vregister = "110001") then
                classification := 21;
            elsif(vregister = "110110") then
                classification := 22;
            elsif(vregister = "110111") then
                classification := 23;
            elsif(vregister = "111000") then
                classification := 24;
            elsif(vregister = "111001") then
                classification := 25;
            elsif(vregister = "111010") then
                classification := 26;
            elsif(vregister = "111011") then
                classification := 27;
            elsif(vregister = "111100") then
                classification := 28;
            elsif(vregister = "111101") then
                classification := 29;
            elsif(vregister = "111110") then
                classification := 30;
            elsif(vregister = "111111") then
                classification := 31;
            else 
                report "Invalid";
            end if;
        return classification;
    end function specifyREG;
             
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

            -- Flags
            variable S_flag : integer := 0;
            variable O_flag : integer := 0;
            variable U_flag : integer := 0;
            variable Z_flag : integer := 0;
            variable PC : integer := 0; -- number of current instruction
            
            -- variables for execution
            variable operand_counter : integer := 0;

            begin
                -- open the file in Read mode
                file_open(file_pointer, ".\read.txt", READ_MODE);    
                
                -- File Reading and Classification
                report "CLASSIFICATION OF OPCODES";
                while not endfile(file_pointer) loop

                    readline (file_pointer, line_num); -- read a specific line

                    for i in 1 to 4 loop
                        READ(line_num, opcode); -- get opcode
                        if (i /= 4) then
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
                        else
                            report opcode;
                        end if;  
                    end loop;
                    
                    i := i + 1; -- increment indexing
                end loop;
                    no_of_instructions := i;

                
                -- Execution
                report "Execution";                
                while (PC < no_of_instructions) loop
                    
                    -- identify the instruction name
                    if (specifyINST(instructions(PC)) = 1) then
                        report "LOAD"& ", " & Operands(operand_counter) & ", " & Operands(operand_counter+1);
                    elsif (specifyINST(instructions(PC)) = 2) then
                        report "ADD" & ", " & Operands(operand_counter) & ", " & Operands(operand_counter+1) & ", " & Operands(operand_counter+2);                        
                    elsif (specifyINST(instructions(PC)) = 3) then
                        report "SUB" & ", " & Operands(operand_counter) & ", " & Operands(operand_counter+1) & ", " & Operands(operand_counter+2);
                    elsif (specifyINST(instructions(PC)) = 4) then
                        report "MUL" & ", " & Operands(operand_counter) & ", " & Operands(operand_counter+1) & ", " & Operands(operand_counter+2);
                    elsif (specifyINST(instructions(PC)) = 5) then
                        report "DIV" & ", " & Operands(operand_counter) & ", " & Operands(operand_counter+1) & ", " & Operands(operand_counter+2);
                    elsif (specifyINST(instructions(PC)) = 6) then 
                        report "MOD" & ", " & Operands(operand_counter);
                    else 
                        report "Invalid";
                    end if;
                    PC := PC + 1;
                    operand_counter := operand_counter + 3;

                   
                end loop;

                -- close the file
                file_close(file_pointer);

                no_of_instructions := i; -- secure the size of instructions

                

                wait;
        end process;

end behave;

-- -- Specifying Instruction
-- for i in 0 to no_of_instructions-1 loop
--     classification := specifyINST(instructions(i));
-- end loop;

-- -- Specifying Immediate
-- for i in 0 to m_counter-1 loop
--     classification := specifyIMMDT(immediates(i));
-- end loop;

-- Specify Register
-- for i in 0 to r_counter-1 loop
--     report integer'image(specifyREG(registers(i)));
-- end loop;
