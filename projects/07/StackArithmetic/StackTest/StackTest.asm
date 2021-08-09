/// push constant 17 ///
@17
D=A

// load D into SP
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// push constant 17 ///
@17
D=A

// load D into SP
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// eq ///
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
D;JEQ
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


/// push constant 17 ///
@17
D=A

// load D into SP
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// push constant 16 ///
@16
D=A

// load D into SP
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// eq ///
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

@TRUE1
D;JEQ
@SP
A=M
M=0
@FALSE1
0;JMP

(TRUE1)
@SP
A=M
M=-1
(FALSE1)

// SP++
@SP
M=M+1


/// push constant 16 ///
@16
D=A

// load D into SP
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// push constant 17 ///
@17
D=A

// load D into SP
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// eq ///
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

@TRUE2
D;JEQ
@SP
A=M
M=0
@FALSE2
0;JMP

(TRUE2)
@SP
A=M
M=-1
(FALSE2)

// SP++
@SP
M=M+1


/// push constant 892 ///
@892
D=A

// load D into SP
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// push constant 891 ///
@891
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

@TRUE3
D;JLT
@SP
A=M
M=0
@FALSE3
0;JMP

(TRUE3)
@SP
A=M
M=-1
(FALSE3)

// SP++
@SP
M=M+1


/// push constant 891 ///
@891
D=A

// load D into SP
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// push constant 892 ///
@892
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

@TRUE4
D;JLT
@SP
A=M
M=0
@FALSE4
0;JMP

(TRUE4)
@SP
A=M
M=-1
(FALSE4)

// SP++
@SP
M=M+1


/// push constant 891 ///
@891
D=A

// load D into SP
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// push constant 891 ///
@891
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

@TRUE5
D;JLT
@SP
A=M
M=0
@FALSE5
0;JMP

(TRUE5)
@SP
A=M
M=-1
(FALSE5)

// SP++
@SP
M=M+1


/// push constant 32767 ///
@32767
D=A

// load D into SP
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// push constant 32766 ///
@32766
D=A

// load D into SP
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// gt ///
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

@TRUE6
D;JGT
@SP
A=M
M=0
@FALSE6
0;JMP

(TRUE6)
@SP
A=M
M=-1
(FALSE6)

// SP++
@SP
M=M+1


/// push constant 32766 ///
@32766
D=A

// load D into SP
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// push constant 32767 ///
@32767
D=A

// load D into SP
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// gt ///
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

@TRUE7
D;JGT
@SP
A=M
M=0
@FALSE7
0;JMP

(TRUE7)
@SP
A=M
M=-1
(FALSE7)

// SP++
@SP
M=M+1


/// push constant 32766 ///
@32766
D=A

// load D into SP
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// push constant 32766 ///
@32766
D=A

// load D into SP
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// gt ///
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

@TRUE8
D;JGT
@SP
A=M
M=0
@FALSE8
0;JMP

(TRUE8)
@SP
A=M
M=-1
(FALSE8)

// SP++
@SP
M=M+1


/// push constant 57 ///
@57
D=A

// load D into SP
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// push constant 31 ///
@31
D=A

// load D into SP
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// push constant 53 ///
@53
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


/// push constant 112 ///
@112
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


/// neg ///
// SP--
@SP
M=M-1

@SP
A=M
D=0
M=D-M

// SP++
@SP
M=M+1


/// and ///
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

M=M&D

// SP++
@SP
M=M+1


/// push constant 82 ///
@82
D=A

// load D into SP
@SP
A=M
M=D
// SP++
@SP
M=M+1


/// or ///
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

M=M|D

// SP++
@SP
M=M+1


/// not ///
// SP--
@SP
M=M-1

@SP
A=M
M=!M

// SP++
@SP
M=M+1

