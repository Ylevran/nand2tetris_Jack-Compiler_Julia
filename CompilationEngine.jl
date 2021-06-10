# CompilationEngine for Jack language
# Authors: Yossef Levran & Maor Sarussi
# Converts xml tokens shallow list to xml syntax tree according to Jack Grammar
# The input xml is error free

include("SymbolTable.jl")
include("VMWriter.jl")

currentClassName = ""
ClassVarDecFirst = ["static", "field"]
SubroutineDecFirst = ["constructor", "function", "method"]
operators = ["+", "-", "*", "/", "&", "|", "<", ">", "=", "&lt;", "&gt;", "&quot;", "&amp;"]
unaryOperators = ["~", "-"]

# Global Symbol Tables
classTable = Dict()
subRoutineTable = Dict()

varName = ""

countClassDic = Dict()
countSubDic = Dict()

# Every time the engine is seeing a terminal token,
# this function adds the token to the output 
# and remove the token from the remain input
function eatToken(lines)
    popfirst!(lines)    
end

function compileClass(lines)
    out = ""

    global countClassDic = createCountDic("static", "field")
    lines = lines[2:length(lines) - 1]

    eatToken(lines) # class
    global currentClassName = split(lines[1])[2]    
    eatToken(lines) # className   
    eatToken(lines) # {
        
    global classTable = classVarSymbolTable(lines, Dict(), countClassDic)

    while split(lines[1])[2] in ClassVarDecFirst
        out *= compileClassVarDec(lines) 
    end

    while split(lines[1])[2] in SubroutineDecFirst
        out *= compileSubroutineDec(lines)
    end

    eatToken(lines) # } 

    return out    
end

function compileClassVarDec(lines)   

    eatToken(lines) # static | field
    eatToken(lines) # type
    eatToken(lines) # varName

    while split(lines[1])[2] == ","
        eatToken(lines) # ,
        eatToken(lines) # varName
    end

    eatToken(lines) # ;
       
end

function compileSubroutineDec(lines)
    out = ""

    global countSubDic = createCountDic("argument", "var")
    global subRoutineTable = generateSubroutines(lines, countSubDic, currentClassName, Dict())    
    out = ""

    eatToken(lines) # constructor|function|method
    eatToken(lines) # void|type
    out *= "function $currentClassName." * split(lines[1])[2] * " " * string(countSubDic["var"]) * "\n"
    eatToken(lines) # subroutineName
    eatToken(lines) # (
    compileParameterList(lines)
    eatToken(lines) # )
    out *= compileSubroutineBody(lines)

    return out
end

function compileParameterList(lines)
    if split(lines[1])[2] != ")"
        eatToken(lines) # type
        eatToken(lines) # varName
    end
    
    while split(lines[1])[2] != ")"
        eatToken(lines) # ,
        eatToken(lines) # type|varName
        eatToken(lines) # type|varName
    end
end

function compileSubroutineBody(lines)
    out = ""

    eatToken(lines) # {

    while split(lines[1])[2] == "var"
        compileVarDec(lines)
    end

    out *= compileStatements(lines)
    eatToken(lines) # }

    return out
end

function compileVarDec(lines)

    eatToken(lines) # var
    eatToken(lines) # type
    eatToken(lines) # varName

    while split(lines[1])[2] == ","
        eatToken(lines) # ,
        eatToken(lines) # varName
    end

    eatToken(lines) # ;
    
end

function compileStatements(lines)
    out = ""

    while split(lines[1])[2] != "}"

        if split(lines[1])[2] == "let"
            out *= compileLet(lines) 

        elseif  split(lines[1])[2] == "if"
            out *= compileIf(lines)

        elseif  split(lines[1])[2] == "while"
            out *= compileWhile(lines)

        elseif  split(lines[1])[2] == "do"
            out *= compileDo(lines)

        elseif  split(lines[1])[2] == "return"
            out *= compileReturn(lines)
        end
    end

    return out
end

function compileLet(lines)
    out = ""

    eatToken(lines) # let
    global varName = split(lines[1])[2]
    eatToken(lines) # varName
    
    if split(lines[1])[2] == "["
        eatToken(lines) # [
        out *= compileExpression(lines)
        eatToken(lines) # ]
    end

    eatToken(lines) # =
    out *= compileExpression(lines)
    eatToken(lines) # ;

    return out
end

function compileIf(lines, tabs)
    out = "$tabs<ifStatement>\n"
    tabsN = tabs * "  "

    out *= eatToken(lines, tabsN) # if
    out *= eatToken(lines, tabsN) # (
    out *= compileExpression(lines, tabsN)
    out *= eatToken(lines, tabsN) # )
    out *= eatToken(lines, tabsN) # {
    out *= compileStatements(lines, tabsN)
    out *= eatToken(lines, tabsN) # }

    if split(lines[1])[2] == "else"
        out *= eatToken(lines, tabsN) # else
        out *= eatToken(lines, tabsN) # {
        out *= compileStatements(lines, tabsN)
        out *= eatToken(lines, tabsN) # }
    end

    out *= "$tabs</ifStatement>\n" 
    return out
end

function compileWhile(lines, tabs)
    out = "$tabs<whileStatement>\n"
    tabsN = tabs * "  "

    out *= eatToken(lines, tabsN) # while
    out *= eatToken(lines, tabsN) # (
    out *= compileExpression(lines, tabsN)
    out *= eatToken(lines, tabsN) # )
    out *= eatToken(lines, tabsN) # {
    out *= compileStatements(lines, tabsN)
    out *= eatToken(lines, tabsN) # }

    out *= "$tabs</whileStatement>\n" 
    return out
end

function compileDo(lines)
    out = ""
    subroutineName = ""
    args_num = 0

    eatToken(lines) # do

    if split(lines[2])[2] == "."
        subroutineName = split(lines[1])[2] * "." * split(lines[3])[2] 
        eatToken(lines) # className | varName
        eatToken(lines) # .
        eatToken(lines) # subroutineName 
        
    else
        subroutineName = split(lines[1])[2]
        eatToken(lines) # subroutineName
    end

    eatToken(lines) # (
    res, args_num = compileExpressionList(lines, args_num)
    out *= res
    out *= "call $subroutineName $args_num\n"
    out *= writePop("TEMP", 0)
    eatToken(lines) # )
    eatToken(lines) # ;

    return out
end

function compileReturn(lines)
    out = ""
    eatToken(lines) # return

    if split(lines[1])[2] != ";"
        out *= compileExpression(lines)
    else
        out *= writePush("CONST", 0)
    end

    out *= writeReturn()
    eatToken(lines) # ;

    return out
end

function compileExpression(lines)
    out = ""

    out *= compileTerm(lines)

    while split(lines[1])[2] in operators
        op = split(lines[1])[2]
        eatToken(lines) # op
        out *= compileTerm(lines)
        
        if op == "+"
            out *= "add\n"
        
        elseif op == "-"
            out *= "sub\n"

        elseif op == "*"
            out *= "call Math.multiply 2\n"

        elseif op == "\\"
            out *= "call Math.divide 2\n"
        end
    end

    return out
end

function compileTerm(lines)
    out = ""

    # array case
    if split(lines[2])[2] == "["
        eatToken(lines) # varName
        eatToken(lines) # [
        out *= compileExpression(lines)
        eatToken(lines) # ]     

    # expression case
    elseif split(lines[1])[2] == "("
        eatToken(lines) # (
        out *= compileExpression(lines)
        eatToken(lines) # )
    
    # unaryOp term
    elseif split(lines[1])[2] in unaryOperators
        if split(lines[1])[2] == "-"
            res = "neg\n"
        end
        eatToken(lines) # Uop
        out *= compileTerm(lines)
        out *= res

    # subroutineCall case
    elseif split(lines[2])[2] == "." || split(lines[2])[2] == "("
        subroutineName = ""
        args_num = 0
        if split(lines[2])[2] == "."
            subroutineName = split(lines[1])[2] * "." * split(lines[3])[2]
            eatToken(lines) # className | varName
            eatToken(lines) # .
            eatToken(lines) # subroutineName 
        else
            subroutineName = split(lines[1])[2]
            eatToken(lines) # subroutineName
        end
    
        eatToken(lines) # (        
        res, args_num = compileExpressionList(lines, args_num)
        out *= res
        out *= "call $subroutineName $args_num\n"
        out *= writePop(subRoutineTable[varName][2], subRoutineTable[varName][3])
        eatToken(lines) # )    



    else
        if split(lines[1])[1] == "<integerConstant>"
           out *= writePush("CONST",split(lines[1])[2])
        elseif split(lines[1])[1] == "<identifier>"
            id = split(lines[1])[2]
            out *= writePush(subRoutineTable[id][2], subRoutineTable[id][3])  
        end  
        eatToken(lines) # integerConstant | stringConstant | keywordConstant | varName
    end

    return out
end

function compileExpressionList(lines, args_num) 
    out = "" 

    if split(lines[1])[2] != ")"
        out *= compileExpression(lines)
        args_num += 1

        while split(lines[1])[2] == ","
            eatToken(lines) # ,
            out *= compileExpression(lines)
            args_num += 1
        end
    end    

    return out, args_num
end

function main()
    # directory = ARGS[1]
    directory = "C:\\Users\\Yossef\\Desktop\\nand2tetris\\projects\\11\\ConvertToBin"

    # ClassSymbolTable = createCountDic("argument", "var")
    # SubRoutineSymboleTable = createCountDic("static", "field")
    
    files = readdir(directory)

    for file in files
        if split(file, ".")[2] == "xml"
            fileName = chop(split(file, ".")[1])
            lines =  readlines("$directory\\$file")
            f = open("$directory\\$fileName.vm", "w")
            write(f, compileClass(lines))
            print("Successfuly created file $fileName.xml\n")
            close(f)
        end
    end

    return 0
end


main()