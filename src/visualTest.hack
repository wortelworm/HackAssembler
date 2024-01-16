$ index: 1


(inits)
    // index = &SCREEN
    @SCREEN
    D=A
    @index
    M=D

(loop)
    // set color WHITE to the current index
        // load WHITE in D
        @32767
        D=A

        // set memory[index] = D
        @index
        A=M
        M=D



    // index++
    @index
    M=M+1

    // goto loop
    @loop
    0;JMP


