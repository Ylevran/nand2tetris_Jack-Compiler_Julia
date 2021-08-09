/// BOOTSTRAP CODE START///
@256
D=A
@SP
M=D

/// call Sys.init 0 ///
// Store the return adress in the stack
@RETURN_0
D=A
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// push segment LCL ///
@LCL
D=M
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// push segment ARG ///
@ARG
D=M
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// push segment THIS ///
@THIS
D=M
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// push segment THAT ///
@THAT
D=M
@SP
A=M
M=D
// SP++
@SP
M=M+1


// ARG = SP - n - 5
@SP
D=M
@5
D=D-A
@0
D=D-A
@ARG
M=D

// LCL = SP
@SP
D=M
@LCL
M=D

/// goto Sys.init ///
@Sys.init
0;JMP


(RETURN_0)


/// BOOTSTRAP CODE END ///


/// function Main.fibonacci 0 ///
(Main.fibonacci)


/// push argument 0 ///
@ARG
D=M
@0
D=D+A
A=D
D=M

// load D into SP
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// push constant 2 ///
@2
D=A

// load D into SP
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// lt ///
// SP--
@SP
M=M-1

@SP
A=M
D=M

// SP--
@SP
M=M-1

@SP
A=M
D=M-D

@TRUE0
D;JLT
@SP
A=M
M=0
@FALSE0
0;JMP

(TRUE0)
@SP
A=M
M=-1
(FALSE0)

// SP++
@SP
M=M+1


/// if-goto IF_TRUE ///
// SP--
@SP
M=M-1

@SP
A=M
D=M

@IF_TRUE
D;JNE


/// goto IF_FALSE ///
@IF_FALSE
0;JMP


/// label IF_TRUE ///
(IF_TRUE)


/// push argument 0 ///
@ARG
D=M
@0
D=D+A
A=D
D=M

// load D into SP
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// return ///
// FRAME = LCL      // store FRAME into temp R7
@LCL
D=M
@R7
M=D


//RET = *(FRAME - 5)      // store the return address into temp R14
@5
A=D-A
D=M
@R14
M=D


//*ARG = pop()        // pop the return value for the caller
/// pop argument 0 ///
@ARG
D=M
@0
D=D+A
@R13
M=D

// SP--
@SP
M=M-1

@SP
A=M
D=M

@R13
A=M
M=D


//SP = ARG + 1      // SP Restoration for the caller
@ARG
D=M
@SP
M=D+1

//THAT = *(FRAME - 1)     // THAT Restoration for the caller
@R7
D=M
@1
A=D-A
D=M

@THAT
M=D


//THIS = *(FRAME - 2)     // THIS Restoration for the caller
@R7
D=M
@2
A=D-A
D=M

@THIS
M=D


//ARG = *(FRAME - 3)     // ARG Restoration for the caller
@R7
D=M
@3
A=D-A
D=M

@ARG
M=D


//LCL = *(FRAME - 4)     // LCL Restoration for the caller
@R7
D=M
@4
A=D-A
D=M

@LCL
M=D


//goto return address (back to the caller's code)
@R14
A=M
0;JMP


/// label IF_FALSE ///
(IF_FALSE)


/// push argument 0 ///
@ARG
D=M
@0
D=D+A
A=D
D=M

// load D into SP
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// push constant 2 ///
@2
D=A

// load D into SP
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// sub ///
// SP--
@SP
M=M-1

@SP
A=M
D=M

// SP--
@SP
M=M-1

@SP
A=M
M=M-D

// SP++
@SP
M=M+1


/// call Main.fibonacci 1 ///
// Store the return adress in the stack
@RETURN_1
D=A
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// push segment LCL ///
@LCL
D=M
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// push segment ARG ///
@ARG
D=M
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// push segment THIS ///
@THIS
D=M
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// push segment THAT ///
@THAT
D=M
@SP
A=M
M=D
// SP++
@SP
M=M+1


// ARG = SP - n - 5
@SP
D=M
@5
D=D-A
@1
D=D-A
@ARG
M=D

// LCL = SP
@SP
D=M
@LCL
M=D

/// goto Main.fibonacci ///
@Main.fibonacci
0;JMP


(RETURN_1)


/// push argument 0 ///
@ARG
D=M
@0
D=D+A
A=D
D=M

// load D into SP
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// push constant 1 ///
@1
D=A

// load D into SP
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// sub ///
// SP--
@SP
M=M-1

@SP
A=M
D=M

// SP--
@SP
M=M-1

@SP
A=M
M=M-D

// SP++
@SP
M=M+1


/// call Main.fibonacci 1 ///
// Store the return adress in the stack
@RETURN_2
D=A
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// push segment LCL ///
@LCL
D=M
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// push segment ARG ///
@ARG
D=M
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// push segment THIS ///
@THIS
D=M
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// push segment THAT ///
@THAT
D=M
@SP
A=M
M=D
// SP++
@SP
M=M+1


// ARG = SP - n - 5
@SP
D=M
@5
D=D-A
@1
D=D-A
@ARG
M=D

// LCL = SP
@SP
D=M
@LCL
M=D

/// goto Main.fibonacci ///
@Main.fibonacci
0;JMP


(RETURN_2)


/// add ///
// SP--
@SP
M=M-1

@SP
A=M
D=M

// SP--
@SP
M=M-1

@SP
A=M
M=M+D

// SP++
@SP
M=M+1


/// return ///
// FRAME = LCL      // store FRAME into temp R7
@LCL
D=M
@R7
M=D


//RET = *(FRAME - 5)      // store the return address into temp R14
@5
A=D-A
D=M
@R14
M=D


//*ARG = pop()        // pop the return value for the caller
/// pop argument 0 ///
@ARG
D=M
@0
D=D+A
@R13
M=D

// SP--
@SP
M=M-1

@SP
A=M
D=M

@R13
A=M
M=D


//SP = ARG + 1      // SP Restoration for the caller
@ARG
D=M
@SP
M=D+1

//THAT = *(FRAME - 1)     // THAT Restoration for the caller
@R7
D=M
@1
A=D-A
D=M

@THAT
M=D


//THIS = *(FRAME - 2)     // THIS Restoration for the caller
@R7
D=M
@2
A=D-A
D=M

@THIS
M=D


//ARG = *(FRAME - 3)     // ARG Restoration for the caller
@R7
D=M
@3
A=D-A
D=M

@ARG
M=D


//LCL = *(FRAME - 4)     // LCL Restoration for the caller
@R7
D=M
@4
A=D-A
D=M

@LCL
M=D


//goto return address (back to the caller's code)
@R14
A=M
0;JMP


/// function Sys.init 0 ///
(Sys.init)


/// push constant 4 ///
@4
D=A

// load D into SP
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// call Main.fibonacci 1 ///
// Store the return adress in the stack
@RETURN_3
D=A
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// push segment LCL ///
@LCL
D=M
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// push segment ARG ///
@ARG
D=M
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// push segment THIS ///
@THIS
D=M
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// push segment THAT ///
@THAT
D=M
@SP
A=M
M=D
// SP++
@SP
M=M+1


// ARG = SP - n - 5
@SP
D=M
@5
D=D-A
@1
D=D-A
@ARG
M=D

// LCL = SP
@SP
D=M
@LCL
M=D

/// goto Main.fibonacci ///
@Main.fibonacci
0;JMP


(RETURN_3)


/// label WHILE ///
(WHILE)


/// goto WHILE ///
@WHILE
0;JMP


