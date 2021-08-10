# CompilationEngine for Jack language
# Authors: Yossef Levran & Maor Sarussi
# Converts xml tokens shallow list to xml syntax tree according to Jack Grammar
# The input xml is error free

ClassVarDecFirst = ["static", "field"]
SubroutineDecFirst = ["constructor", "function", "method"]
operators = ["+", "-", "*", "/", "&", "|", "<", ">", "=", "&lt;", "&gt;", "&quot;", "&amp;"]
unaryOperators = ["~", "-"]

# Every time the engine is seeing a terminal token,
# this function adds the token to the output 
# and remove the token from the remain input
function eatToken(lines, tabs)
    out = tabs * lines[1] * "\n" 
    popfirst!(lines)
    return out
end

function compileClass(lines, tabs)
    lines = lines[2:length(lines) - 1]

    out = "$tabs<class>\n"
    tabsN = tabs * "  " 

    out *= eatToken(lines, tabsN) # class    
    out *= eatToken(lines, tabsN) # className   
    out *= eatToken(lines, tabsN) # {    

    while split(lines[1])[2] in ClassVarDecFirst
        out *= compileClassVarDec(lines, tabsN) 
    end

    while split(lines[1])[2] in SubroutineDecFirst
        out *= compileSubroutineDec(lines, tabsN)
    end

    out *= eatToken(lines, tabsN) # } 

    out *= "$tabs</class>\n"
    return out    
end

function compileClassVarDec(lines, tabs)
    out = "$tabs<classVarDec>\n"
    tabsN = tabs * "  "

    out *= eatToken(lines, tabsN) # static | field
    out *= eatToken(lines, tabsN) # type
    out *= eatToken(lines, tabsN) # varName

    while split(lines[1])[2] == ","
        out *= eatToken(lines, tabsN) # ,
        out *= eatToken(lines, tabsN) # varName
    end

    out *= eatToken(lines, tabsN) # ;

    out *= "$tabs</classVarDec>\n"
    return out    
end

function compileSubroutineDec(lines, tabs)
    out = "$tabs<subroutineDec>\n"
    tabsN = tabs * "  "

    out *= eatToken(lines, tabsN) # constructor|function|method
    out *= eatToken(lines, tabsN) # void|type
    out *= eatToken(lines, tabsN) # subroutineName
    out *= eatToken(lines, tabsN) # (
    out *= compileParameterList(lines, tabsN)
    out *= eatToken(lines, tabsN) # )
    out *= compileSubroutineBody(lines, tabsN)

    out *= "$tabs</subroutineDec>\n" 
    return out
end

function compileParameterList(lines, tabs)
    out = "$tabs<parameterList>\n"
    tabsN = tabs * "  "

    if split(lines[1])[2] != ")"
        out *= eatToken(lines, tabsN) # type
        out *= eatToken(lines, tabsN) # varName
    end
    
    while split(lines[1])[2] != ")"
        out *= eatToken(lines, tabsN) # ,
        out *= eatToken(lines, tabsN) # type|varName
        out *= eatToken(lines, tabsN) # type|varName
    end

    out *= "$tabs</parameterList>\n" 
    return out
end

function compileSubroutineBody(lines, tabs)
    out = "$tabs<subroutineBody>\n"
    tabsN = tabs * "  "

    out *= eatToken(lines, tabsN) # {

    while split(lines[1])[2] == "var"
        out *= compileVarDec(lines, tabsN)
    end

    out *= compileStatements(lines, tabsN)
    out *= eatToken(lines, tabsN) # }

    out *= "$tabs</subroutineBody>\n" 
    return out
end

function compileVarDec(lines, tabs)
    out = "$tabs<varDec>\n"
    tabsN = tabs * "  "

    out *= eatToken(lines, tabsN) # var
    out *= eatToken(lines, tabsN) # type
    out *= eatToken(lines, tabsN) # varName

    while split(lines[1])[2] == ","
        out *= eatToken(lines, tabsN) # ,
        out *= eatToken(lines, tabsN) # varName
    end

    out *= eatToken(lines, tabsN) # ;
    
    out *= "$tabs</varDec>\n" 
    return out
end

function compileStatements(lines, tabs)
    out = "$tabs<statements>\n"
    tabsN = tabs * "  "

    while split(lines[1])[2] != "}"

        if split(lines[1])[2] == "let"
            out *= compileLet(lines, tabsN) 

        elseif  split(lines[1])[2] == "if"
            out *= compileIf(lines, tabsN)

        elseif  split(lines[1])[2] == "while"
            out *= compileWhile(lines, tabsN)

        elseif  split(lines[1])[2] == "do"
            out *= compileDo(lines, tabsN)

        elseif  split(lines[1])[2] == "return"
            out *= compileReturn(lines, tabsN)
        end
    end

    out *= "$tabs</statements>\n" 
    return out
end

function compileLet(lines, tabs)
    out = "$tabs<letStatement>\n"
    tabsN = tabs * "  "

    out *= eatToken(lines, tabsN) # let
    out *= eatToken(lines, tabsN) # varName
    
    if split(lines[1])[2] == "["
        out *= eatToken(lines, tabsN) # [
        out *= compileExpression(lines, tabsN)
        out *= eatToken(lines, tabsN) # ]
    end

    out *= eatToken(lines, tabsN) # =
    out *= compileExpression(lines, tabsN)
    out *= eatToken(lines, tabsN) # ;

    out *= "$tabs</letStatement>\n" 
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

function compileDo(lines, tabs)
    out = "$tabs<doStatement>\n"
    tabsN = tabs * "  "
    out *= eatToken(lines, tabsN) # do

    if split(lines[2])[2] == "."
        out *= eatToken(lines, tabsN) # className | varName
        out *= eatToken(lines, tabsN) # .
        out *= eatToken(lines, tabsN) # subroutineName 
    else
        out *= eatToken(lines, tabsN) # subroutineName
    end

    out *= eatToken(lines, tabsN) # (
    out *= compileExpressionList(lines, tabsN)
    out *= eatToken(lines, tabsN) # )
    out *= eatToken(lines, tabsN) # ;

    out *= "$tabs</doStatement>\n" 
    return out
end

function compileReturn(lines, tabs)
    out = "$tabs<returnStatement>\n"
    tabsN = tabs * "  "
    out *= eatToken(lines, tabsN) # return

    if split(lines[1])[2] != ";"
        out *= compileExpression(lines,tabsN)
    end

    out *= eatToken(lines, tabsN) # ;

    out *= "$tabs</returnStatement>\n" 
    return out
end

function compileExpression(lines, tabs)
    out = "$tabs<expression>\n"
    tabsN = tabs * "  "

    out *= compileTerm(lines, tabsN)

    while split(lines[1])[2] in operators
        out *= eatToken(lines, tabsN) # op
        out *= compileTerm(lines, tabsN)
    end

    out *= "$tabs</expression>\n" 
    return out
end

function compileTerm(lines, tabs)
    out = "$tabs<term>\n"
    tabsN = tabs * "  "

    # array case
    if split(lines[2])[2] == "["
        out *= eatToken(lines, tabsN) # varName
        out *= eatToken(lines, tabsN) # [
        out *= compileExpression(lines, tabsN)
        out *= eatToken(lines, tabsN) # ]     

    # expression case
    elseif split(lines[1])[2] == "("
        out *= eatToken(lines, tabsN) # (
        out *= compileExpression(lines, tabsN)
        out *= eatToken(lines, tabsN) # )
    
    # unaryOp term
    elseif split(lines[1])[2] in unaryOperators
        out *= eatToken(lines, tabsN) # Uop
        out *= compileTerm(lines, tabsN)

    # subroutineCall case
    elseif split(lines[2])[2] == "." || split(lines[2])[2] == "("
        if split(lines[2])[2] == "."
            out *= eatToken(lines, tabsN) # className | varName
            out *= eatToken(lines, tabsN) # .
            out *= eatToken(lines, tabsN) # subroutineName 
        else
            out *= eatToken(lines, tabsN) # subroutineName
        end
    
        out *= eatToken(lines, tabsN) # (
        out *= compileExpressionList(lines, tabsN)
        out *= eatToken(lines, tabsN) # )    



    else
        out *= eatToken(lines, tabsN) # integerConstant | stringConstant | keywordConstant | varName
    end

    out *= "$tabs</term>\n" 
    return out
end

function compileExpressionList(lines, tabs) 
    out = "$tabs<expressionList>\n" 
    tabsN = tabs * "  "

    if split(lines[1])[2] != ")"
        out *= compileExpression(lines, tabsN)

        while split(lines[1])[2] == ","
            out *= eatToken(lines, tabsN) # ,
            out *= compileExpression(lines, tabsN)
        end
    end    

    out *= "$tabs</expressionList>\n" 
    return out
end

function main()
    directory = ARGS[1]
    # directory = "C:\\Users\\Yossef\\Desktop\\nand2tetris\\projects\\10\\Test\\ArrayTest"
    
    files = readdir(directory)

    for file in files
        if split(file, ".")[2] == "xml"
            fileName = chop(split(file, ".")[1])
            lines =  readlines("$directory\\$file")
            f = open("$directory\\$fileName.xml", "w")
            write(f, compileClass(lines, ""))
            print("Successfuly created file $fileName.xml\n")
            close(f)
        end
    end

    return 0
end


main()