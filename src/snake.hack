
// general purpuse counter/pointer
$ i: 1

// coordinates with x and y combined
$ coord: 1
$ coord2: 1

// direction, a 'enum' of left, right, up and down
$ direction: 1

$ GameOver: 1

// Food location
$ Food: 1

// Pointers to Front and back of Snake
$ SnakeFront: 1
$ SnakeBack: 1

// this might get to small, but that would be really difficult
$ Snake: 56

// Colors used:
    // snake: 20359
    // food: 2143
    // background: 0


(inits)
    // default snake is at positions ((2,10),(3,10),(4,10),(5,10))
        // (2, 10)
        @162
        D=A
        @Snake
        M=D

        // (3, 10)
        D=D+1
        A=A+1
        M=D
        
        // (4, 10)
        D=D+1
        A=A+1
        M=D

        // (5, 10)
        D=D+1
        A=A+1
        M=D
    
    // initialize coord as *SnakeFront
        @coord
        M=D

    // SnakeBack = &Snake
        @Snake
        D=A
        @SnakeBack
        M=D

    // SnakeFront = &Snake + 3
        @3
        D=D+A
        @SnakeFront
        M=D

    // Snake direction: right
        @direction
        M=1

    // Draw initial snake
        // (2, 10) is at SCREEN + (2 + 16*10) = SCREEN + 162 = 16546
        @20359
        D=A

        @16546
        M=D
        A=A+1
        M=D
        A=A+1
        M=D
        A=A+1
        M=D

    // Food is at (12, 10)
        @172
        D=A
        @Food
        M=D

    // Draw food
        // pixel address: &SCREEN + Food = 0x4000 + 172 = 16556
        @2143
        D=A
        @16556
        M=D
    
    // Reset GameOver thing
        @GameOver
        M=0


(GameLoop)
    // set new head location by determining direction & checking wall collision
        // coord is still the previous head location from previous iteration

        // D, i = KBD-1
            @KBD
            D=M-1
            @i
            M=D

        // if no new keyboard input, dont replace direction
            @past_direction_replace
            D;JLT
        
        // if direction is opposite of current, dont replace direction
            // using coord2 as temporary value because it gets replaced further on

            // coord2 = i | direction
                @direction
                // i is still equal to D
                D=D|M
                @coord2
                M=D
            
            // D = ! (i & direction)
                @direction
                D=M
                @i
                D=D&M
                D=!D
            
            // D = (D & coord2) - 1
                @coord2
                D=D&M
                D=D-1
            
            // if (D <= 0) { goto past_direction_replace }
                @past_direction_replace
                D;JLE

        // replace direction
            @i
            D=M
            @direction
            M=D
        
        (past_direction_replace)
        
        // jump to correct location
            @direction
            D=M

            @direction_left
            D;JEQ

            @direction_right
            D=D-1
            D;JEQ

            @direction_up
            D=D-1
            D;JEQ

            // direction down must be the one now

        (direction_down)
            @16
            D=A
            @coord
            DM=M+D
            @256
            D=D-A
            @collision_found
            D;JGE
            @past_wall_collission
            0;JMP

        (direction_right)
            @coord
            DM=M+1
            @15
            D=D&A
            @collision_found
            D;JEQ
            @past_wall_collission
            0;JMP

        (direction_left)
            @coord
            D=M
            M=M-1
            @15
            D=D&A
            @collision_found
            D;JEQ
            @past_wall_collission
            0;JMP

        (direction_up)
            @16
            D=A
            @coord
            DM=M-D
            @collision_found
            D;JLT

        (past_wall_collission)

    
    // move to given new head location
        // check if eating food
            // if(coord != Food) goto collision_checks
                @coord
                D=M
                @Food
                D=D-M
                @collision_checks
                D;JNE

            (respawn_food)
                // D, Food = RANDOM & 0x00FF
                    @RANDOM
                    D=M
                    @255
                    D=D&A
                    @Food
                    M=D

                // D = * (D + &SCREEN)
                    @SCREEN
                    A=D+A
                    D=M

                // if (D != 0) { goto respawn_food }
                    @respawn_food
                    D;JNE

            // respawn_food_finish
                // draw food
                    // i = &SCREEN + Food
                        @SCREEN
                        D=A
                        @Food
                        D=D+M
                        @i
                        M=D
                    
                    // *i = food_color
                        @2143
                        D=A
                        @i
                        A=M
                        M=D

                // duplicate code of drawing new head
                    // pixel location: i=&SCREEN+coord
                        @SCREEN
                        D=A
                        @coord
                        D=D+M
                        @i
                        M=D
                    
                    // draw the color
                        @20359
                        D=A
                        @i
                        A=M
                        M=D

                // skip tail removing
                    @after_tail_removing
                    0;JMP
        
        (collision_checks)
        // check collidings of snake with itself
            // D = * (&SCREEN + coord)
                @SCREEN
                D=A
                @coord
                A=D+M
                D=M
            
            // if (D != 0) { goto collision_found }
                @collision_found
                D;JNE

            (no_collision_found)
                @after_collision_checks
                0;JMP

            (collision_found)
                @GameOver
                M=1
        
        (after_collision_checks)

        // load *SnakeBack into coord2
            @SnakeBack
            A=M
            D=M
            @coord2
            M=D
        
        // remove SnakeBack drawing
            // pixel location: A=&SCREEN+coord2
                @SCREEN
                D=A
                @coord2
                A=D+M
            
            // clear the pixel
                M=0
   
        // if gameover, stop
            @GameOver
            D=M
            @end
            D;JNE

        // draw new head
            // pixel location: i=&SCREEN+coord
                @SCREEN
                D=A
                @coord
                D=D+M
                @i
                M=D
            
            // draw the color
                @20359
                D=A
                @i
                A=M
                M=D

        // advance SnakeBack to next
            // SnakeBack += 1
                @SnakeBack
                M=M+1
            
            // SnakeBack %= 56
                // if (SnakeBack < &Snake - 56){skip}
                    D=M
                    @Snake
                    D=D-A
                    @56
                    D=D-A

                    @past_snakeback_sub
                    D;JLT

                // subtract 56 from SnakeBack
                    @56
                    D=A
                    @SnakeBack
                    M=M-D

                (past_snakeback_sub)

        (after_tail_removing)
        
        // save new head
            // SnakeFront += 1
                @SnakeFront
                M=M+1
            
            // SnakeFront %= 56
                // if (SnakeFront < &Snake - 56){skip}
                    D=M
                    @Snake
                    D=D-A
                    @56
                    D=D-A
                    @past_snakefront_sub
                    D;JLT

                // subtract 56 from SnakeFront
                    @56
                    D=A
                    @SnakeFront
                    M=M-D

                (past_snakefront_sub)

            // *SnakeFront = coord
                @coord
                D=M
                @SnakeFront
                A=M
                M=D
    
    @GameLoop
    0;JMP


(end)
    @end_internal
    (end_internal)
    0;JMP