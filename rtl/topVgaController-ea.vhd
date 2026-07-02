library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
library lib;

entity topVgaController is 

port(

CLOCK_50 : in std_ulogic; 
KEY : in std_ulogic_vector(2 downto 0);

--VGA 
VGA_HS : out std_ulogic; 
VGA_VS : out std_ulogic;
VGA_CLK : out std_ulogic;
VGA_BLANK_N : out std_ulogic;
VGA_SYNC_N : out std_ulogic; 
VGA_R : out std_ulogic_vector(7 downto 0);
VGA_G : out std_ulogic_vector(7 downto 0);
VGA_B : out std_ulogic_vector(7 downto 0)

); 

end entity;

architecture thb of topVgaController is 

    signal rgb : std_ulogic_vector(23 downto 0);
    signal active : std_ulogic; 
    signal px : unsigned (9 downto 0);
    signal py : unsigned (9 downto 0);
    signal clk_25 : std_ulogic := '0';
    signal snake_x : unsigned(9 downto 0);
    signal snake_y : unsigned(9 downto 0);
    signal direction : std_ulogic_vector(1 downto 0);

begin
    
    game_inst : entity lib.snakeGame

    port map (
        clk_25 => clk_25,
        rst_n => KEY(0),
        btn_left => KEY(1),
        btn_right => KEY(2),
        snake_x => snake_x,
        direction_out => direction,
        snake_y => snake_y
    );


    vga_inst : entity lib.vgaController 

port map(

    clk_25 => clk_25,
    rst_n => KEY(0),
    vga_hsync => VGA_HS,
    vga_vsync => VGA_VS,
    vga_blank_n => VGA_BLANK_N,
    vga_sync_n => VGA_SYNC_N,
    vga_r => VGA_R,
    vga_g => VGA_G,
    vga_b => VGA_B,
    pixel_x =>  px,
    pixel_y => py,
    active_area => active,
    rgb_in => rgb
);

VGA_CLK <= clk_25;

renderer_inst : entity lib.snakeRenderer
port map (
    pixel_x =>  px,
    pixel_y => py,
    active_area => active,
    snake_x => snake_x,
    snake_y => snake_y,
    direction_in => direction,
    rgb_out => rgb
);

p_clk : process(CLOCK_50) 
begin 

    if rising_edge(CLOCK_50) then 
        clk_25 <= not clk_25;
    end if; 
end process; 



end architecture; 
