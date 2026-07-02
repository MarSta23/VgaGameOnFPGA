library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;


entity snakeRenderer is 

    port(

        pixel_x : in unsigned (9 downto 0); 
        pixel_y : in unsigned (9 downto 0);  
        snake_x : in unsigned(9 downto 0);
        snake_y : in unsigned(9 downto 0);
        active_area : in std_ulogic; 
        direction_in : in std_ulogic_Vector(1 downto 0);
        rgb_out : out std_ulogic_vector( 23 downto 0) 

    );

end entity;


architecture rtl of snakeRenderer is 


begin

    process(all)
    begin 

        if active_area = '1' then 
            -- std.. black 
            rgb_out <= x"000000";

            if pixel_x >= snake_x and pixel_x < snake_x + to_unsigned(20,10) and pixel_y >= snake_y and pixel_y < snake_y + to_unsigned(20,10) then 

                rgb_out <= x"00FF00";
            end if; 

            -- eyes 
if direction_in = "00" then  -- Up
    if (pixel_x >= snake_x+4  and pixel_x < snake_x+8  and
        pixel_y >= snake_y+4  and pixel_y < snake_y+8) or
       (pixel_x >= snake_x+12 and pixel_x < snake_x+16 and
        pixel_y >= snake_y+4  and pixel_y < snake_y+8) then
        rgb_out <= x"000000";
    end if;

elsif direction_in = "01" then  -- Down
    if (pixel_x >= snake_x+4  and pixel_x < snake_x+8  and
        pixel_y >= snake_y+12 and pixel_y < snake_y+16) or
       (pixel_x >= snake_x+12 and pixel_x < snake_x+16 and
        pixel_y >= snake_y+12 and pixel_y < snake_y+16) then
        rgb_out <= x"000000";
    end if;

elsif direction_in = "10" then  -- Left
    if (pixel_x >= snake_x+4  and pixel_x < snake_x+8  and
        pixel_y >= snake_y+4  and pixel_y < snake_y+8) or
       (pixel_x >= snake_x+4  and pixel_x < snake_x+8  and
        pixel_y >= snake_y+12 and pixel_y < snake_y+16) then
        rgb_out <= x"000000";
    end if;
else  -- Right
    if (pixel_x >= snake_x+12 and pixel_x < snake_x+16 and
        pixel_y >= snake_y+4  and pixel_y < snake_y+8) or
       (pixel_x >= snake_x+12 and pixel_x < snake_x+16 and
        pixel_y >= snake_y+12 and pixel_y < snake_y+16) then
        rgb_out <= x"000000";
    end if;
end if;
        else 

            rgb_out <= x"000000";
        end if; 

        
    end process;


end architecture;
