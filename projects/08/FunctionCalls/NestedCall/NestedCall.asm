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


/// function Sys.init 0 ///
(Sys.init)


/// push constant 4000 ///
@4000
D=A

// load D into SP
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// pop pointer 0 ///
// SP--
@SP
M=M-1

@SP
A=M
D=M

@THIS
M=D
/// push constant 5000 ///
@5000
D=A

// load D into SP
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// pop pointer 1 ///
// SP--
@SP
M=M-1

@SP
A=M
D=M

@THAT
M=D


/// call Sys.main 0 ///
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
@0
D=D-A
@ARG
M=D

// LCL = SP
@SP
D=M
@LCL
M=D

/// goto Sys.main ///
@Sys.main
0;JMP


(RETURN_1)


/// pop temp 1 ///
@5
D=A
@1
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


/// label LOOP ///
(LOOP)


/// goto LOOP ///
@LOOP
0;JMP


/// function Sys.main 5 ///
(Sys.main)

@0
D=A
@SP
A=M
M=D
// SP++
@SP
M=M+1


@0
D=A
@SP
A=M
M=D
// SP++
@SP
M=M+1


@0
D=A
@SP
A=M
M=D
// SP++
@SP
M=M+1


@0
D=A
@SP
A=M
M=D
// SP++
@SP
M=M+1


@0
D=A
@SP
A=M
M=D
// SP++
@SP
M=M+1



/// push constant 4001 ///
@4001
D=A

// load D into SP
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// pop pointer 0 ///
// SP--
@SP
M=M-1

@SP
A=M
D=M

@THIS
M=D
/// push constant 5001 ///
@5001
D=A

// load D into SP
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// pop pointer 1 ///
// SP--
@SP
M=M-1

@SP
A=M
D=M

@THAT
M=D


/// push constant 200 ///
@200
D=A

// load D into SP
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// pop local 1 ///
@LCL
D=M
@1
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


/// push constant 40 ///
@40
D=A

// load D into SP
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// pop local 2 ///
@LCL
D=M
@2
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


/// push constant 6 ///
@6
D=A

// load D into SP
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// pop local 3 ///
@LCL
D=M
@3
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


/// push constant 123 ///
@123
D=A

// load D into SP
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// call Sys.add12 1 ///
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

/// goto Sys.add12 ///
@Sys.add12
0;JMP


(RETURN_2)


/// pop temp 0 ///
@5
D=A
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


/// push local 0 ///
@LCL
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


/// push local 1 ///
@LCL
D=M
@1
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


/// push local 2 ///
@LCL
D=M
@2
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


/// push local 3 ///
@LCL
D=M
@3
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


/// push local 4 ///
@LCL
D=M
@4
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


/// function Sys.add12 0 ///
(Sys.add12)


/// push constant 4002 ///
@4002
D=A

// load D into SP
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// pop pointer 0 ///
// SP--
@SP
M=M-1

@SP
A=M
D=M

@THIS
M=D
/// push constant 5002 ///
@5002
D=A

// load D into SP
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// pop pointer 1 ///
// SP--
@SP
M=M-1

@SP
A=M
D=M

@THAT
M=D


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


/// push constant 12 ///
@12
D=A

// load D into SP
@SP
A=M
M=D
// SP++
@SP
M=M+1


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


