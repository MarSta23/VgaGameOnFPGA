library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;


entity snakeGame is 

    port(

        clk_25 : in std_ulogic;
        rst_n : in std_ulogic; 
        btn_left : in std_ulogic; 
        btn_right : in std_ulogic; 
        snake_x : out unsigned( 9 downto 0);
        direction_out : out std_ulogic_Vector(1 downto 0);
        snake_y : out unsigned (9 downto 0)

    );

    end entity;

architecture rtl of snakeGame is 

    constant cTickMax : unsigned(23 downto 0) := to_unsigned(12_500_000, 24);
    type aState is (Idle, Running, GameOver); 
    type aDirection is(Up, Down, Left, Right);

    type aRegSet is record 
        State : aState;
        Direction : aDirection; 
        pos_x : unsigned(9 downto 0);
        pos_y : unsigned (9 downto 0);
        tick : unsigned(23 downto 0);
    end record; 

    signal R, NxR : aRegSet;
    constant cInitVal : aRegSet := (

    State => Idle,
    Direction => Up, 
    pos_x => to_unsigned(320,10),
    pos_y => to_unsigned(240,10),
    tick => (others => '0')

    );

begin 

    direction_out <= "00" when R.Direction = Up    else
                 "01" when R.Direction = Down  else
                 "10" when R.Direction = Left  else
                 "11";

    

    Registers : process(clk_25, rst_n)
    begin 

        if rst_n = '0' then 
            R <= cInitVal; 
        elsif rising_edge(clk_25) then 
            R <= NxR;
        end if; 
    end process;

    Comb: process(all) 
    begin 

        --set defaults 
        NxR <= R;

        case R.State is 

            when Idle => 

            if btn_left = '0' or btn_right = '0' then 
                NxR.State <= Running; 
            end if; 

            when Running => 

            NxR.tick <= R.tick +1; 

            if(R.tick = cTickMax) then
                
                NxR.tick <= (others => '0');

                if btn_left = '0' then 
                    case R.Direction is 

                        when Up => NxR.Direction <= Left;
                        when Left => NxR.Direction <= Down;
                        when Down => NxR.Direction <= Right;
                        when Right => NxR.Direction <= Up; 
                    end case; 
                elsif btn_right = '0' then  

                    case R.Direction is 

                        when Up => NxR.Direction <= Right;
                        when Right => NxR.Direction <= Down; 
                        when Down => NxR.Direction <= Left;
                        when Left => NxR.Direction <= Up; 
                    end case; 
                end if; 

                case R.Direction is 

                    when Up => NxR.pos_y <= R.pos_y - 20;
                    when Down => NxR.pos_y <= R.pos_y + 20; 
                    when Left => NxR.pos_x <= R.pos_x - 20;
                    when Right => NxR.pos_x <= R.pos_x + 20;
                end case;


                if R.pos_x >= 620 or R.pos_x < 20 or 
                    R.pos_y >= 460 or R.pos_y < 20 then 
                        NxR.State <= GameOver;
                end if;


            end if; 


        when GameOver => 

        null; 


        end case;

        snake_x <= R.pos_x;
        snake_y <= R.pos_y;

    end process;



end architecture; 




    