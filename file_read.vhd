library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.textio.all;
use ieee.std_logic_textio.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- READ ME

-- TO dO:
--     1. Convert PC to binary (4-bits)
--     2. Start Clock Cycle shit
--     3. Gumawa ng mock instructions (hanggang 15 sana or kahit kumuha sa mga past handouts)

-- Reminders:
--     1. Check if tama yung pagset ng flags (mindali ko)
--     2. Check yung buong program as you code
--     3. Piniprint pala nung code yung result lang nung mismong operation
--     4. Yung nasa read.txt 
        -- LOAD R0, 3
        -- LOAD R1, 1
        -- ADD R2, R0, R1
        -- SUB R2, R0, R1
        -- DIV R2, R0, R1
        -- MUL R2, R0, R1
        -- MOD R2
    
-- #LETZDOTHISSHIT 
-- #HAHAAHAHAHAHHA

ENTITY file_read is
END file_read;

ARCHITECTURE behave OF file_read is

    -- ARRAYS of OPCODES
    type instruction_array is array (0 to 14) of string(1 to 6);
    type register_array is array (0 to 44) of string(1 to 6);
    type immediate_array is array (0 to 44) of string(1 to 6);
    type operand_array is array (0 to 44) of string(1 to 6);
    type values_array is array (0 to 44) of integer;

    -- ARRAYS OF VALUES
    type register_values is array (0 to 32) of integer;

    -- FUNCTIONS
    function classifyOC (opcode : in string)
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

    function specifyINST (instruction : in string)
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

    function specifyIMMDT (immediate : in string)
        return integer is variable classification : integer := -1;
        begin
            if( immediate = "010000" ) then
                classification := 0;
            elsif ( immediate = "010001" ) then
                classification := 1;
            elsif ( immediate = "010010" ) then
                classification := 2;
            elsif ( immediate = "010011" ) then
                classification := 3;
            -- else
            --     report "Invalid"; 
            end if;
        return classification;
    end function specifyIMMDT;

    function specifyREG (vregister : in string)
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

    function load (operand2 : in integer)
        return integer is variable result : integer := -1;
            begin 
                result := operand2;
                report integer'image(result);
                return result;
    end function;

    function modulo (operand2 : in  integer)
        return integer is variable result : integer := -1;
            begin
                result := operand2 - ((operand2/2)*2);
                report integer'image(result);
                return result;
    end function;

    function add (operand2 : in integer; operand1 : in integer)
        return integer is variable result : integer := -1;
           begin
                result := operand1 + operand2;
                report integer'image(result);
                return result;
    end function;

    function sub (operand2 : in integer; operand1 : in integer)
        return integer is variable result : integer := -1;
           begin
                result := operand2 - operand1;
                report integer'image(result);
                return result;
    end function;

    function mul (operand2 : in  integer; operand1 : in integer)
        return integer is variable result : integer := -1;
            begin
                 result := operand1 * operand2;
                report integer'image(result);
                return result;
    end function;

    function div (operand2 : in  integer; operand1 : in integer)
        return integer is variable result : integer := -1;
            begin
                result := operand2/operand1;
                report integer'image(result);
                return result;
    end function;

    function get_value(operand : in string)
        return integer is variable classification : integer := -1;
            begin
                if(classifyOC(operand) = 2) then 
                    classification := specifyREG(operand);
                else
                    classification := specifyIMMDT(operand);                           
                end if;
        return classification;
    end function;
             
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
            variable result: integer := 0;
            
            -- variables for execution
            variable operand_counter : integer := 0;
            variable register_values : values_array;
            variable cur_op1 : integer := 0;
            variable cur_op2 : integer := 0;
            variable storage : integer := 0;

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
                            operands(o_counter) := opcode;
                            o_counter := o_counter + 1;
                        end if;  
                    end loop;
                    
                    i := i + 1; -- increment indexing
                end loop;
                    no_of_instructions := i;

                -- Execution
                report "EXECUTION";                
                while (PC < no_of_instructions) loop
                    
                    storage := get_value(Operands(operand_counter)); -- register

                     -- get the immediate value or the register index
                    cur_op1 := get_value(Operands(operand_counter+1));
                    cur_op2 := get_value(Operands(operand_counter+2));

                    -- report integer'image(cur_op1) & " : " & integer'image(cur_op2);
                    -- report Operands(operand_counter+1) & " : " & Operands(operand_counter+2);
                    
                    if(classifyOC(Operands(operand_counter+1)) = 2) then -- if register
                        cur_op1 := register_values(cur_op1);
                    end if;

                    if(classifyOC(Operands(operand_counter+2)) = 2) then -- if register
                        cur_op2 := register_values(cur_op2);
                    end if;
                   
                    -- identify the instruction name
                    if (specifyINST(instructions(PC)) = 1) then
                        register_values(storage) := load(cur_op1);
                    elsif (specifyINST(instructions(PC)) = 2) then
                        register_values(storage) := add(cur_op1, cur_op2);
                    elsif (specifyINST(instructions(PC)) = 3) then
                        register_values(storage) := sub(cur_op1, cur_op2);
                    elsif (specifyINST(instructions(PC)) = 4) then
                        register_values(storage) := mul(cur_op1, cur_op2);
                    elsif (specifyINST(instructions(PC)) = 5) then
                        register_values(storage) := div (cur_op1, cur_op2);
                    elsif (specifyINST(instructions(PC)) = 6) then
                        register_values(storage) := modulo(cur_op1); 
                    else 
                        report "Invalid";
                    end if;

                    -- set flags
                        if(register_values(storage) >= 0) then -- sign flag
                            S_flag := 1;
                        else
                            S_flag := 0;
                        end if;
                        
                        if(register_values(storage) > 3) then -- overflow flag
                            O_flag := 1;
                        else
                            O_flag := 0;
                        end if;

                        if(register_values(storage) < 0) then -- underflow flag
                            U_flag := 1;
                        else
                            U_flag := 0;
                        end if;

                        if(register_values(storage) = 0) then -- zero flag
                            Z_flag := 1;
                        else
                            Z_flag := 0;
                        end if;

                    -- go to next instruction
                    PC := PC + 1;

                    -- go to next set of operands
                    operand_counter := operand_counter + 3;
                   
                end loop;

                -- close the file
                file_close(file_pointer);

                no_of_instructions := i; -- secure the size of instructions

                

                wait;
        end process;

end behave;

-- -- Specifying all Instruction
-- for i in 0 to no_of_instructions-1 loop
--     classification := specifyINST(instructions(i));
-- end loop;

-- -- Specifying all Immediate
-- for i in 0 to m_counter-1 loop
--     classification := specifyIMMDT(immediates(i));
-- end loop;

-- Specify all Register
-- for i in 0 to r_counter-1 loop
--     report integer'image(specifyREG(registers(i)));
-- end loop;

-- -- Print all Operands
-- for i in 0 to o_counter-1 loop
--     report operands(i);
-- end loop;