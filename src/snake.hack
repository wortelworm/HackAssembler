
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
        A=M
        M=D


        // (3, 10)
        D=D+1
        M=M+1
        M=D
        
        // (4, 10)
        D=D+1
        M=M+1
        M=D

        // (5, 10)
        D=D+1
        M=M+1
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
    // somehow determine direction & wall collision
        // for now hardcoded to be (1, 0)
        @coord
        M=1

    
    
    // move by given direction
        // set new head location in @coord
            @coord
            D=M
            @SnakeFront
            A=M
            D=D+M

            @coord
            M=D

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
                
                // i = SnakeFront
                    @SnakeFront
                    A=M
                    D=M
                    @i
                    M=D
                    
                
                (respawn_food_loop)
                    // if (CurrentSnakePart == Food) goto respawn_food



            // skip tail removing
                @after_tail_removing
                0;JMP
        
        (collision_checks)
        // Todo: check collidings of snake with itself
        
        // no collision found
            @before_tail_removing
            0;JMP

        // if collission found
            (collision)
            @GameOver
            M=1

        (before_tail_removing)

        // load SnakeBack into coord2
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