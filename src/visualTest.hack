$ index: 1
$ color: 1


(inits)
    // index = &SCREEN
    @SCREEN
    D=A
    @index
    M=D

    // color = 0
    @color
    M=0

(loop_rg)
    // set color to the current index
        // load memory[&color] in D
        @color
        D=M

        // set memory[index] = D
        @index
        A=M
        M=D
    
    // color = color + 2
        // color is still in D
        @color
        D=D+1
        M=D+1

    // index++
    @index
    M=M+1

    // if index < SCREEN + 512 goto loop_rg
        // D = index - SCREEN - 512
        D=M
        @SCREEN
        D=D-A
        @512
        D=D-A

        // if D<0 goto loop_rg
        @loop_rg
        D;JLT


(exit)
    @exit_internal
(exit_internal)
    0;JMP

