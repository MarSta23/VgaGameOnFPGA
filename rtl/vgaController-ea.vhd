library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity vgaController is 
    port(

        clk_25 : in std_ulogic;             --clock
        rst_n : in std_ulogic;                 --activ low reset key 0

        --VGA output

        vga_hsync : out std_ulogic; 
        vga_vsync : out std_ulogic; 
        vga_blank_n : out std_ulogic; 
        vga_sync_n : out std_ulogic; 

        vga_r : out std_ulogic_vector(7 downto 0); 
        vga_g : out std_ulogic_vector(7 downto 0); 
        vga_b : out std_ulogic_vector(7 downto 0); 


        --pixel for rendern 

        pixel_x : out unsigned (9 downto 0);        --render needs position x, y 
        pixel_y : out unsigned(9 downto 0);
        active_area : out std_ulogic;               --sync area ? no output! -> check with active area 
        
        rgb_in : in std_ulogic_vector( 23 downto 0)        -- tell controller which color -> 
    );       

    end entity vgaController; 

    architecture rtl of vgaController is 

        signal h_count : unsigned(9 downto 0) := (others =>'0'); 
        signal v_count :unsigned (9 downto 0) := (others => '0');
        signal rst_sync : std_ulogic := '0';
        signal rst_mayMeta : std_ulogic := '0';



    begin 


    pRst_sync : process(clk_25, rst_n)           --sync with 2 FFs 
    begin 


        if rst_n = '0'  then

            rst_mayMeta <= '0';
            rst_sync <= '0';

        elsif rising_edge(clk_25) then 
            rst_mayMeta <= rst_n;
            rst_sync <= rst_mayMeta; 
        end if; 
    end process pRst_sync; 

    p_hcount : process(clk_25)
    begin 

        if rising_edge(clk_25) then 
            if rst_sync = '0' then 
            h_count <= (others => '0');             --reset -> set to zero 
            elsif h_count = 799 then 
                h_count <= (others => '0');
            else
                h_count <= h_count +1;
            end if; 
        end if; 
    end process p_hcount; 


    p_vcount : process(clk_25) 
    begin 

        if rising_edge(clk_25) then 
            if rst_sync = '0' then 
                v_count <= (others => '0'); 
            elsif h_count = 799 then 

                if v_count = 524 then 
                    v_count <= (others => '0');
                else 
                    v_count <= v_count +1;
                end if;
            end if; 
        end if; 

        end process p_vcount;

        p_hsync : process(h_count) 
        begin 

            if h_count >= 656 and h_count < 752 then 
                vga_hsync <= '0'; 
            else 

                vga_hsync <= '1';
            end if; 
        end process;


        p_vsync : process (v_count) 
        begin 

            if v_count >= 490 and v_count < 492 then 
                vga_vsync <= '0'; 
            else 
                vga_vsync <= '1';
            end if;
        end process;

        vga_blank_n <= '1' when h_count < 640 and v_count < 480 else '0';
        vga_sync_n <= '0';
        active_area <= '1' when h_count < 640 and v_count < 480 else '0';   -- or active_area <= vga_blank_n;


        vga_r <= rgb_in(23 downto 16) when active_area = '1' else(others => '0');
        vga_g <= rgb_in (15 downto 8) when active_area = '1' else (others => '0');
        vga_b <= rgb_in(7 downto 0) when active_area = '1' else (others => '0');

        pixel_x <= h_count;
        pixel_y <= v_count; 

    end architecture rtl; 



        
