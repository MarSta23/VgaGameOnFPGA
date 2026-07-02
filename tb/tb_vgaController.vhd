library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;
library lib;

library vunit_lib;
context vunit_lib.vunit_context;




entity tb_vgaController is 
    generic(
        
        runner_cfg : string
         
        
        );
    end entity;


architecture sim of tb_vgaController is 

    signal clk_50 : std_ulogic := '0';
    signal rst_n : std_ulogic := '0';

    signal vga_hsync : std_ulogic := '0'; 
    signal vga_vsync : std_ulogic := '0'; 
    signal vga_blank_n : std_ulogic := '0'; 
    signal vga_sync_n : std_ulogic := '0'; 

    signal vga_r :  std_ulogic_vector(7 downto 0); 
    signal vga_g :  std_ulogic_vector(7 downto 0); 
    signal vga_b :  std_ulogic_vector(7 downto 0); 


        --pixel for rendern 

    signal pixel_x : unsigned (9 downto 0);        --render needs position x, y 
    signal pixel_y : unsigned(9 downto 0);
    signal active_area : std_ulogic;               --sync area ? no output! -> check with active area 

    signal rgb_in : std_ulogic_vector( 23 downto 0) := x"FF0000";    --red std val
    signal hsync_count : integer := 0;
    signal vsync_count : integer := 0; 

begin 


    clk_50 <= not clk_50 after 10 ns;            -- f = 1/T -> 1 / 20ns = 50MHz --switch ev 10ns *2
    

    dut: entity lib.vgaController 

    port map(
        clk_50 => clk_50,
        rst_n => rst_n,
        vga_hsync => vga_hsync,
        vga_vsync=>vga_vsync,
        vga_blank_n  => vga_blank_n,
        vga_sync_n => vga_sync_n,
        vga_r => vga_r,
        vga_g => vga_g,
        vga_b => vga_b,

        pixel_x => pixel_x,
        pixel_y => pixel_y,
        active_area => active_area,
        rgb_in => rgb_in
    );



    p_hsync_count : process

    begin 

        wait until falling_edge(vga_hsync);
        hsync_count <= hsync_count +1;
    end process;

    p_vsync_count : process

    begin 

        wait until falling_edge(vga_vsync);
        vsync_count <= vsync_count +1;
    end process;

    process 

    begin 

        test_runner_setup(runner, runner_cfg);

        rst_n <= '0';
        wait for 100 ns; 

        rst_n <= '1';

        wait for 34 ms; 

        check(hsync_count >= 524, "Hsync Error!");
        check(vsync_count >= 2, "Vsync Error!");





        test_runner_cleanup(runner);

    end process;

    end architecture sim; 



