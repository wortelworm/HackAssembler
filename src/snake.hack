
// general purpuse counter
$ i: 1

// local variables representing locations
// the y is usually 16x the true value
$ x: 1
$ y: 1

$ x2: 1
$ y2: 1

$ GameOver: 1

// Food location
$ FoodX: 1
$ FoodY: 1

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
    // default snake is at positions ((2,10),(3,10),(4,10))
        // using i as pointer to the Snake
        @Snake
        D=A
        @i
        M=D

        @2
        D=A
        @i
        A=M
        M=D
        @i
        M=M+1

        @160
        D=A
        @i
        A=M
        M=D
        @i
        M=M+1


        @3
        D=A
        @i
        A=M
        M=D
        @i
        M=M+1

        @160
        D=A
        @i
        A=M
        M=D
        @i
        M=M+1


        @4
        D=A
        @i
        A=M
        M=D
        @i
        M=M+1

        @160
        D=A
        @i
        A=M
        M=D
        @i
        M=M+1

    // SnakeBack = Snake
        @Snake
        D=A
        @SnakeBack
        M=D

    // SnakeFront = Snake + 2*2
        @4
        D=D+A
        @SnakeFront
        M=D

    // Draw initial snake
        // (2, 10) is at SCREEN + (2 + 16*10) = SCREEN + 162 = 16546
        @16546
        D=A
        @i
        M=D

        @20359
        D=A

        @i
        A=M
        M=D

        @i
        M=M+1
        A=M
        M=D

        @i
        M=M+1
        A=M
        M=D

    // Food is at (12, 10)
        @12
        D=A
        @FoodX
        M=D

        @160
        D=A
        @FoodY
        M=D

    // Draw food
        // pixel address: &SCREEN + FoodX + FoodY = 0x4000 + 12 + 160 = 16556
        @2143
        D=A
        @16556
        M=D
    
    // Reset GameOver thing
        @GameOver
        M=0


(GameLoop)
    // somehow determine direction
        // If the y is used, make sure to set it to 16 or -16
        // for now hardcoded to be (1, 0)
        @x
        M=1
        @y
        M=0
    
    // move by given direction
        // set new head location in @x and @y
            // D = *SnakeFront
                @SnakeFront
                A=M
                D=M
            // x += D
                @x
                M=M+D
            // D = *(SnakeFront+1)
                @SnakeFront
                A=M+1
                D=M
            // y += D
                @y
                M=M+D

        // check if eating food
            // if(x != FoodX) goto collision checks
                @x
                D=M
                @FoodX
                D=D-M
                @collision_checks
                D;JNE
            
            // if(y != FoodY) goto collision checks
                @y
                D=M
                @FoodY
                D=D-M
                @collision_checks
                D;JNE

            // todo: spawn new food

            // skip tail removing
                @after_tail_removing
                0;JMP

        (collision_checks)
        // check if collides with wall
            // if x < 0
                @x
                D=M
                @collision
                D;JLT
            
            // if x >= 16
                @16
                D=D-A
                @collision
                D;JGE

            // if y < 0
                @y
                D=M
                @collision
                D;JLT

            // if y >= 32*16
                @512
                D=D-A
                @collision
                D;JGE

        // Todo: check collidings of snake with itself
        
        // no collision found
            @before_tail_removing
            0;JMP

        // if collission found
            (collision)
            @GameOver
            M=1

        (before_tail_removing)

        // load SnakeBack into x2 and y2
            // x2 = *SnakeBack
                @SnakeBack
                A=M
                D=M
                @x2
                M=D
            
            // y2 = *(SnakeBack+1)
                @SnakeBack
                A=M+1
                D=M
                @y2
                M=D
                
        // advance SnakeBack to next
            // SnakeBack += 2
                @SnakeBack
                M=M+1
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
            // pixel location: A=&SCREEN+x2+y2
                @SCREEN
                D=A
                @x2
                D=D+M
                @y2
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
            // pixel location: i=&SCREEN+x+y
                @SCREEN
                D=A
                @x
                D=D+M
                @y
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
            // SnakeFront += 2
                @SnakeFront
                M=M+1
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

            // *SnakeFront = x
                @x
                D=M
                @SnakeFront
                A=M
                M=D
            
            // *(SnakeFront+1) = y
                @y
                D=M
                @SnakeFront
                A=M+1
                M=D
    
    @GameLoop
    0;JMP

(end)
    @end_internal
    (end_internal)
    0;JMP