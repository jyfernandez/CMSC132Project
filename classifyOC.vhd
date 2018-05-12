-- this is the one in your exercise

library ieee;
use ieee.std_logic_1164.all;

-- create component needed for the task
entity classifyOC is
  port(
          opcode: in string;
          opcode_clone: out string
  );
end classifyOC;

-- implement architecture of that entity
architecture classify_OC of classifyOC is

  type instruction_array is array (0 to 10) of string(1 to 6);
  type register_array is array (0 to 32) of string(1 to 6);
  type immediate_array is array (0 to 32) of string(1 to 6);
  type operand_array is array (0 to 32) of string(1 to 6);

  begin
    process
      begin
        -- o1 <= not i0;
        -- wait on i0;
        if(opcode(1) = '0') 
          then if(opcode(2) = '0') then -- 00 opcode 
              report "instruction";
          elsif(opcode(2) = '1') then -- 01 immediate
              report "immediate";                                
          end if;
        elsif (opcode(1) = '1') then -- 10 register
            report "register";                            
        end if;

        opcode_clone <= opcode;
        wait 
    end process;
end classify_OC;
