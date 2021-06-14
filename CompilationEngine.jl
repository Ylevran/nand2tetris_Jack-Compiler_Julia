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

varName = ""
labelIndex = 1

# Global Symbol Tables
classTable = Dict()
subRoutineTable = Dict()



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

    global labelIndex = 1

    global countClassDic = createCountDic("static", "field")
    lines = lines[2:length(lines) - 1]

    eatToken(lines) # class
    global currentClassName = split(lines[1])[2]    
    eatToken(lines) # className   
    eatToken(lines) # {
        
    global classTable = classVarSymbolTable(lines, Dict(), countClassDic)

    while split(lines[1])[2] in ClassVarDecFirst
        compileClassVarDec(lines) 
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

    temp = split(lines[1])[2] 
    eatToken(lines) # constructor|function|method
    eatToken(lines) # void|type
    out *= "function $currentClassName." * split(lines[1])[2] * " " * string(countSubDic["var"]) * "\n"
    eatToken(lines) # subroutineName
    eatToken(lines) # (

    if temp == "constructor"
        out *= writePush("CONST", countClassDic["field"])
        out *= writeCall("Memory.alloc", 1)
        out *= writePop("POINTER", 0)
    elseif temp == "method"
        out *= writePush("ARG", 0)
        out *= writePop("POINTER", 0)
    end

    

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
        if haskey(subRoutineTable, varName)
            out *= writePush(subRoutineTable[varName][2], subRoutineTable[varName][3])
        elseif haskey(classTable, varName)
            out *= writePush(classTable[varName][2], classTable[varName][3])
        end
        out *= compileExpression(lines)
        out *= writeArihtmetic("add")
        eatToken(lines) # ]
        eatToken(lines) # =
        out *= compileExpression(lines)
        out *= writePop("TEMP", 0)
        out *= writePop("POINTER", 1)
        out *= writePush("TEMP", 0)
        out *= writePop("THAT", 0)
        if split(lines[1])[2] == ")"
            eatToken(lines) # )
        end
        eatToken(lines) # ;
        return out

    else
        eatToken(lines) # =
        out *= compileExpression(lines)
        if haskey(subRoutineTable, varName)
            out *= writePop(subRoutineTable[varName][2], subRoutineTable[varName][3])
        elseif haskey(classTable, varName)
            out *= writePop(classTable[varName][2], classTable[varName][3])
        end
        if split(lines[1])[2] == ")"
            eatToken(lines) # )
        end
        eatToken(lines) # ;
    
        return out
    end
end

function compileIf(lines)
    out = ""
    index = labelIndex
    global labelIndex += 1

    eatToken(lines) # if
    eatToken(lines) # (
    out *= compileExpression(lines)
    out *= writeArihtmetic("not")
    out *= writeIf("IF_FALSE$index")
    eatToken(lines) # )
    eatToken(lines) # {
    out *= compileStatements(lines)
    out *= writeGoto("IF_TRUE$index")
    out *= writeLabel("IF_FALSE$index")
    eatToken(lines) # }

    if split(lines[1])[2] == "else"
        eatToken(lines) # else
        eatToken(lines) # {
        out *= compileStatements(lines)
        eatToken(lines) # }
    end
    out *= writeLabel("IF_TRUE$index")

    return out
end

function compileWhile(lines)
    out = ""
    index = labelIndex    
    global labelIndex += 1

    out *= writeLabel("WHILE_EXP$index")
    eatToken(lines) # while
    eatToken(lines) # (
    out *= compileExpression(lines)
    out *= writeArihtmetic("not")
    out *= writeIf("WHILE_END$index")
    eatToken(lines) # )
    eatToken(lines) # {
    out *= compileStatements(lines)
    out *= writeGoto("WHILE_EXP$index")
    out *= writeLabel("WHILE_END$index")
    eatToken(lines) # }

    return out
end

function compileDo(lines)
    out = ""
    subroutineName = ""
    argsNum = 0
    thisArg = 0

    eatToken(lines) # do

    if split(lines[2])[2] == "."
        if haskey(classTable, split(lines[1])[2])
            subroutineName = classTable[split(lines[1])[2]][1] * "." * split(lines[3])[2]
            out *= writePush("FIELD", classTable[split(lines[1])[2]][3])
            thisArg = 1
        elseif haskey(subRoutineTable, split(lines[1])[2])
            subroutineName = subRoutineTable[split(lines[1])[2]][1] * "." * split(lines[3])[2]
            out *= writePush(subRoutineTable[split(lines[1])[2]][2], subRoutineTable[split(lines[1])[2]][3])
            thisArg = 1
        else
            subroutineName = split(lines[1])[2] * "." * split(lines[3])[2]
        end         
        eatToken(lines) # className | varName
        eatToken(lines) # .
        eatToken(lines) # subroutineName 
        
    else
        subroutineName = currentClassName * "." * split(lines[1])[2]
        out *= writePush("POINTER", 0)
        thisArg = 1
        eatToken(lines) # subroutineName
    end

    eatToken(lines) # (
    res, argsNum = compileExpressionList(lines, argsNum)
    argsNum += thisArg
    out *= res
    out *= "call $subroutineName $argsNum\n"
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
            out *= writeArihtmetic("add")
        
        elseif op == "-"
            out *= writeArihtmetic("sub")

        elseif op == "*"
            out *= writeCall("Math.multiply", 2)

        elseif op == "/"
            out *= writeCall("Math.divide", 2)

        elseif op == "&gt;"
            out *= writeArihtmetic("gt")

        elseif op == "&lt;"
            out *= writeArihtmetic("lt")
        
        elseif op == "&amp;"
            out *= writeArihtmetic("and")

        elseif  op == "="
            out *= writeArihtmetic("eq")
        end
    end

    return out
end

function compileTerm(lines)
    out = ""

    # array case
    if split(lines[2])[2] == "["
        if haskey(classTable, split(lines[1])[2])
            out *= writePush(classTable[split(lines[1])[2]][2], classTable[split(lines[1])[2]][3])
        elseif haskey(subRoutineTable, split(lines[1])[2])
            out *= writePush(subRoutineTable[split(lines[1])[2]][2], subRoutineTable[split(lines[1])[2]][3])
        end
        eatToken(lines) # varName
        eatToken(lines) # [
        out *= compileExpression(lines)
        out *= writeArihtmetic("add")
        eatToken(lines) # ] 
        out *= writePop("POINTER", 1)
        out *= writePush("THAT", 0)    

    # expression case
    elseif split(lines[1])[2] == "("
        eatToken(lines) # (
        out *= compileExpression(lines)
        eatToken(lines) # )
    
    # unaryOp term
    elseif split(lines[1])[2] in unaryOperators
        if split(lines[1])[2] == "-"
            res = writeArihtmetic("neg")
        elseif split(lines[1])[2] == "~"
            res = writeArihtmetic("not")
        end
        eatToken(lines) # Uop
        out *= compileTerm(lines)
        out *= res

    # subroutineCall case
    elseif split(lines[2])[2] == "." || split(lines[2])[2] == "("
        subroutineName = ""
        argsNum = 0
        thisArg = 0

        if split(lines[2])[2] == "."
            if haskey(classTable, split(lines[1])[2])
                subroutineName = classTable[split(lines[1])[2]][1] * "." * split(lines[3])[2]
                out *= writePush("FIELD", classTable[split(lines[1])[2]][3])
                thisArg = 1
            elseif haskey(subRoutineTable, split(lines[1])[2])
                subroutineName = subRoutineTable[split(lines[1])[2]][1] * "." * split(lines[3])[2]
                out *= writePush(subRoutineTable[split(lines[1])[2]][2], subRoutineTable[split(lines[1])[2]][3])
                thisArg = 1
            else
                subroutineName = split(lines[1])[2] * "." * split(lines[3])[2]
            end         
            eatToken(lines) # className | varName
            eatToken(lines) # .
            eatToken(lines) # subroutineName 
            
        else
            subroutineName = currentClassName * "." * split(lines[1])[2]
            out *= writePush("POINTER", 0)
            thisArg = 1
            eatToken(lines) # subroutineName
        end
    
        eatToken(lines) # (        
        res, argsNum = compileExpressionList(lines, argsNum)
        eatToken(lines) # )
        argsNum += thisArg
        out *= res
        out *= "call $subroutineName $argsNum\n"

    elseif split(lines[1])[1] == "<integerConstant>"
        out *= writePush("CONST",split(lines[1])[2])
        eatToken(lines) # integerConstant

    elseif split(lines[1])[1] == "<identifier>"
        id = split(lines[1])[2]
        if haskey(subRoutineTable, id)
            out *= writePush(subRoutineTable[id][2], subRoutineTable[id][3])
        elseif haskey(classTable, id)
            out *= writePush(classTable[id][2], classTable[id][3])
        end
        eatToken(lines) # indentifier
    
    elseif split(lines[1])[1] == "<stringConstant>"
        str = SubString(lines[1], 18, length(lines[1]) - 18)
        out *= writePush("CONST", length(str))
        out *= writeCall("String.new", 1)
        for c in str
            out *= writePush("CONST", Int(c))
            out *= writeCall("String.appendChar", 2)            
        end
        eatToken(lines) # StringConstant


    elseif split(lines[1])[1] == "<keyword>" 
        if split(lines[1])[2] == "true"
            out *= writePush("CONST", 0)
            out *= writeArihtmetic("not")
        elseif split(lines[1])[2] == "false"
            out *= writePush("CONST", 0)
        elseif split(lines[1])[2] == "this"
            out *= writePush("POINTER", 0)
        elseif split(lines[1])[2] == "null"
            out *= writePush("CONST", 0)
        end            
        eatToken(lines) # keywordConstant
    end

    return out
end

function compileExpressionList(lines, argsNum) 
    out = "" 

    if split(lines[1])[2] != ")"
        out *= compileExpression(lines)
        argsNum += 1

        while split(lines[1])[2] == ","
            eatToken(lines) # ,
            out *= compileExpression(lines)
            argsNum += 1
        end
    end    

    return out, argsNum
end

function main()
    directory = ARGS[1]
    # directory = "C:\\Users\\Yossef\\Desktop\\nand2tetris\\projects\\11\\CircleSnake"    
    files = readdir(directory)

    for file in files
        if split(file, ".")[2] == "xml"
            fileName = chop(split(file, ".")[1])
            lines =  readlines("$directory\\$file")
            f = open("$directory\\$fileName.vm", "w")
            write(f, compileClass(lines))
            print("Successfuly created file $fileName.vm\n")
            close(f)
        end
    end

    return 0
end


main()