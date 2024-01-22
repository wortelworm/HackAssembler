
// general purpuse counter/pointer
$ i: 1


$ coord: 1
$ coord2: 1

$ GameOver: 1

// Food location
$ Food: 1

// Pointers to Front and back of Snake
$ SnakeFront: 1
$ SnakeBack: 1

// this might be bit too small
$ Snake: 32

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
    // somehow set new head location by determining direction & checking wall collision
        // direction for now hardcoded to be (1, 0)
            @coord
            M=1

        // set new head location in @coord
            @coord
            D=M
            @SnakeFront
            A=M
            D=D+M

            @coord
            M=D

    
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
                // Food = RANDOM & 0x00FF
                    @RANDOM
                    D=M
                    @255
                    D=D&A
                    @Food
                    M=D
                
                // i = SnakeBack
                    @SnakeBack
                    D=M
                    @i
                    M=D
                
                (respawn_food_loop)
                    // if (*i == Food) goto respawn_food
                        @i
                        A=M
                        D=M
                        @Food
                        D=D-M

                        @respawn_food
                        D;JEQ
                    
                    // if (i == SnakeFront) done
                        @i
                        D=M
                        @SnakeFront
                        D=D-M

                        @respawn_food_finish
                        D;JEQ

                    // i = ((i+1)-&Snake) % 32 + &Snake
                        // D = ++i
                            @i
                            M=M+1
                            D=M
                        
                        // D = D - &Snake - 32
                            @Snake
                            D=D-A
                            @32
                            D=D-A

                        // jump past -32 if D<0
                            @past_foodi_sub
                            D;JLT

                        // i -= 32
                            @32
                            D=A
                            @i
                            M=M-D

                        (past_foodi_sub)
                    
                    @respawn_food_loop
                    0;JMP

            (respawn_food_finish)
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

                // skip tail removing
                    @after_tail_removing
                    0;JMP
        
        (collision_checks)
        // check collidings of snake with itself
            // i = SnakeBack
                @SnakeBack
                D=M
                @i
                M=D
            
            (collision_self_loop)
                // if (*i == coord) goto collision_found
                    @i
                    A=M
                    D=M
                    @coord
                    D=D-M

                    @collision_found
                    D;JEQ
                
                // if (i == SnakeFront) done
                    @i
                    D=M
                    @SnakeFront
                    D=D-M

                    @no_collision_found
                    D;JEQ

                // i = ((i+1)-&Snake) % 32 + &Snake
                    // D = ++i
                        @i
                        M=M+1
                        D=M
                    
                    // D = D - &Snake - 32
                        @Snake
                        D=D-A
                        @32
                        D=D-A

                    // jump past -32 if D<0
                        @past_collision_self_sub
                        D;JLT

                    // i -= 32
                        @32
                        D=A
                        @i
                        M=M-D

                    (past_collision_self_sub)
                
                @collision_self_loop
                0;JMP

            (no_collision_found)
                @before_tail_removing
                0;JMP

            (collision_found)
                @GameOver
                M=1

        (before_tail_removing)

        // load *SnakeBack into coord2
            @SnakeBack
            A=M
            D=M
            @coord2
            M=D
        
        // advance SnakeBack to next
            // SnakeBack += 1
                @SnakeBack
                M=M+1
            
            // SnakeBack %= 32
                // if (SnakeBack < &Snake - 32){skip}
                    D=M
                    @Snake
                    D=D-A
                    @32
                    D=D-A

                    @past_snakeback_sub
                    D;JLT

                // subtract 32 from SnakeBack
                    @32
                    D=A
                    @SnakeBack
                    M=M-D

                (past_snakeback_sub)

        // remove SnakeBack drawing
            // pixel location: A=&SCREEN+coord2
                @SCREEN
                D=A
                @coord2
                A=D+M
            
            // clear the pixel
                M=0

        (after_tail_removing)
        
        // Stop if GameOver
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
        
        // save new head
            // SnakeFront += 1
                @SnakeFront
                M=M+1
            
            // SnakeFront %= 32
                // if (SnakeFront < &Snake - 32){skip}
                    D=M
                    @Snake
                    D=D-A
                    @32
                    D=D-A
                    @past_snakefront_sub
                    D;JLT

                // subtract 32 from SnakeFront
                    @32
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