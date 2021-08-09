#VM Translator by Maor Sarussi & Yossef Levran

paramDict = Dict("local" => "LCL", "argument" => "ARG", "this" => "THIS", "that" => "THAT", "temp" => "5")

function increaseSP()
    # Increases the SP value at RAM[0] by 1
    sp = "// SP++\n@SP\nM=M+1\n\n"
    return sp    
end

function decreaseSp()
    # Decreases the SP value at RAM[0] by 1
    sp = "// SP--\n"
    sp *= "@SP\n"
    sp *= "M=M-1\n\n"
    return sp
end

function loadSp()    
    sp = "// load D into SP\n"
    sp *= "@SP\n" # first we get the value that the sp pointing on to register A and M = RAM[A]
    sp *= "A=M\nM=D\n"
    sp *= increaseSP() # sp++
    return sp
end

function push(param, var, className)
    #  function that generating the push operation to the stack       
    out = "/// push $param $var ///\n@"  
       
    # Group 1 - push local/argument/this/that x   
    if param == "local" || param == "argument" || param == "this" || param == "that" 
        # first we get the place of array local, so in the memory we have its data, then we add the value
        # and the value in A is var so we add to register D the value and now we have the place in local + var
        out *= string(paramDict[param]) * "\nD=M\n@$var\nD=D+A\nA=D\nD=M\n\n"
    end

    #
    if param == "temp"  
        # first we get the place of array local, so in the memory we have its data, then we add the value
        # and the value in A is var so we add to register D the value and now we have the place in local + var
        out *= string(paramDict[param]) * "\nD=A\n@$var\nD=D+A\nA=D\nD=M\n\n"
    end

    # Group 2 - push constant x 
    if param == "constant"  # insert the constant var to the stack head
        out *= "$var\nD=A\n\n" # first we take the constant to register A and M = RAM[A], then the value from A entered to register D
    end
        
   
    # Group 3 - push static x   
    if param == "static"
        out *= "$className.$var\nD=M\n@$var\nA=D+A\nD=M\n\n"       
    end
   
    # Group 4 - push pointer 0/1
    if param == "pointer"
        if var == "0"
            out *= "THIS\n"
        end
        if var == "1"
            out *= "THAT\n"
        end
        out *= "D=M\n\n"   
    end            
    
    # Load value into RAM[RAM[SP]] and increase RAM[SP] by 1 
    out *= loadSp()
    out *= "\n"
    
    return out
end

function pop(param, var, className)
    # function that generating the pop operation from the stack       
    out = "/// pop $param $var ///\n"
   
    # Group 1 - pop local/argument/this/that x     
    if param == "local" || param == "argument" || param == "this" || param == "that"
        # Save param + var location on R13
        out *= "@" * string(paramDict[param]) * "\nD=M\n@$var\nD=D+A\n@R13\nM=D\n\n"
        # Decrease SP by one
        out *= decreaseSp()
        # Save the SP register value
        out *= "@SP\nA=M\nD=M\n\n"
        # Load the value into RAM[param + var] 
        out *= "@R13\nA=M\nM=D\n\n\n"
    end

    # Group 2 - pop temp x     
    if param == "temp"
        # Save param + var location on R13
        out *= "@" * string(paramDict[param]) * "\nD=A\n@$var\nD=D+A\n@R13\nM=D\n\n"
        # Decrease SP by one
        out *= decreaseSp()
        # Save the SP register value
        out *= "@SP\nA=M\nD=M\n\n"
        # Load the value into RAM[param + var] 
        out *= "@R13\nA=M\nM=D\n\n\n"
    end

    # Group 3 - pop static x
    if param == "static"   
        out *= "@$className.$var\nD=M\n@$var\nD=D+A\n@R13\nM=D\n\n"           
        # Decrease SP by one
        out *= decreaseSp()
        # Save the SP register value
        out *= "@SP\nA=M\nD=M\n\n"
        # Load the value into className.var 
        out *= "@R13\nA=M\nM=D\n\n\n"
    end
   
    # Group 4 - pop pointer 0/1
    if param == "pointer"
        # Decrease SP by one
        out *= decreaseSp()
        # Save the SP register value
        out *= "@SP\nA=M\nD=M\n\n"            
        if var == "0"
            # Load into RAM[THIS]
            out *= "@THIS\nM=D\n"         
        elseif var == "1"
            # Load into RAM[THAT]
            out *= "@THAT\nM=D\n\n\n" 
        end   
    end
   
       
    return out
end

function mathematics(operationName, operator)
    # function that generating the add/sub operation from the stack
    out = "/// $operationName ///\n"
     # first we get the value of the first number
    out *= decreaseSp()
    out *= "@SP\nA=M\nD=M\n\n" # now the value of the head of the stack in D
    # now we get the value of the second number
    out *= decreaseSp()
    out *= "@SP\nA=M\n"
    # insert the value to M by the operation
    out *= "M=M$operator" * "D\n\n"
    out *= increaseSP()
    out *= "\n"
    return out
end

function arithmetics(op, jmpCondition, labelNum)
    # function that generating the eq/lt/gt operation from the stack
    trueLabel = "TRUE$labelNum"
    falseLabel = "FALSE$labelNum"
    out = "/// $op ///\n"
    out *= decreaseSp()
    # gets the value in the spot that sp now pointing on
    out *= "@SP\nA=M\nD=M\n\n"
    # gets the second value for equlation
    out *= decreaseSp()
    out *= "@SP\nA=M\nD=M-D\n\n"
    # create the label to jump into it
    out *= "@$trueLabel\n"
    out *= "D;$jmpCondition\n" # if its equals\greater\less -> jump to this label
    # if its isn't equals
    out *= "@SP\nA=M\nM=0\n"
    out *= "@$falseLabel\n"
    out *= "0;JMP\n\n" # jump to the label if the condition didn't  happened
    out *= "($trueLabel)\n"
    out *= "@SP\nA=M\nM=-1\n"
    out *= "($falseLabel)\n\n"
    out *= increaseSP()
    out *= "\n"
    return out
end 

function neg()
    # takes the last number in the stack and became it to its negative number
    out = "/// neg ///\n"
    # first we decrease the sp
    out *= decreaseSp()
    # now the calculte of neg x its actually 0 - x
    out *= "@SP\nA=M\nD=0\nM=D-M\n\n" # here it happens - we take the value and insert it to M than we insert 0 to D and than we do D-M
    #increase back the sp
    out *= increaseSP()
    out *= "\n"
    return out
end

function logics(param, op)
    # function that generating the and/or operation from the stack    
    out = "/// $param ///\n"
    out *= decreaseSp() #SP--
    out *= "@SP\nA=M\nD=M\n\n" # Save the value into D
    out *= decreaseSp() #SP--
    out *= "@SP\nA=M\n\n" 
    out *= "M=M" * op * "D\n\n"
    out *= increaseSP()
    out *= "\n"
    return out
end

function not()
    # Generate the not operation for the head of stack
    out = "/// not ///\n"
    out *= decreaseSp()
    out *= "@SP\nA=M\nM=!M\n\n"
    out *= increaseSP()
    return out
end

function writeLabel(labelName)
    # Generate the label command in the asm code
    out = "/// label $labelName ///\n"
    out *= "($labelName)\n\n\n" 
    return out  
end

function writeGoto(labelName)
    # Generate the goto command in the asm code
    out = "/// goto $labelName ///\n"
    out *= "@$labelName\n0;JMP\n\n\n"
    return out
end

function writeIf(labelName)
    # Generate the if-goto command in the asm code
    out = "/// if-goto $labelName ///\n"
    out *= decreaseSp()
    out *= "@SP\nA=M\nD=M\n\n"
    out *= "@$labelName\nD;JNE\n\n\n"
    return out  
end

function pushSegment(segment)
    out = "/// push segment $segment ///\n"
    out *= "@$segment\n"
    out *= "D=M\n@SP\nA=M\nM=D\n"
    out *= increaseSP()
    out *= "\n"
    return out
end

function writeInit()   
    out = "/// BOOTSTRAP CODE START///\n"
    out *= "@256\nD=A\n@SP\nM=D\n\n"
    out *= writeCall("Sys.init", 0, 0)
    out *= "/// BOOTSTRAP CODE END ///\n\n\n"   
    return out
end

function writeCall(functionName, value, returnNum)
    out = "/// call $functionName $value ///\n"
    out *= "// Store the return adress in the stack\n"
    out *= "@RETURN_$returnNum\nD=A\n@SP\nA=M\nM=D\n"
    out *= increaseSP()
    out *= "\n"
    out *= pushSegment(paramDict["local"])
    out *= pushSegment(paramDict["argument"])
    out *= pushSegment(paramDict["this"])
    out *= pushSegment(paramDict["that"])
    out *= "// ARG = SP - n - 5\n"
    out *= "@SP\nD=M\n@5\nD=D-A\n@$value\nD=D-A\n@ARG\nM=D\n\n"
    out *= "// LCL = SP\n"
    out *= "@SP\nD=M\n@LCL\nM=D\n\n"
    out *= writeGoto("$functionName")
    out *= "(RETURN_$returnNum)\n\n\n"
    return out
end

function writeFunction(functionName, value)
    out = "/// function $functionName $value ///\n"
    out *= "($functionName)\n\n"
    value = parse(Int64, value) 
    if  value > 0
        for n in 1:value
            out *= "@0\nD=A\n@SP\nA=M\nM=D\n"
            out *= increaseSP()
            out *= "\n"
        end
    end   
    out *= "\n"
    return out
end

function restoreReturn(param, place)
    out = "@R7\nD=M\n@$place\nA=D-A\nD=M\n\n"
    out *= "@$param\nM=D\n\n\n"
    return out
end

function writeReturn()
out = "/// return ///\n"
out *= "// FRAME = LCL      // store FRAME into temp R7\n"
out *= "@LCL\nD=M\n@R7\nM=D\n\n\n"
out *= "//RET = *(FRAME - 5)      // store the return address into temp R14\n"
out *= "@5\nA=D-A\nD=M\n@R14\nM=D\n\n\n"
out *= "//*ARG = pop()        // pop the return value for the caller\n"
out *= pop("argument", 0, "")
out *= "//SP = ARG + 1      // SP Restoration for the caller\n"
out *= "@ARG\nD=M\n@SP\nM=D+1\n\n"
out *= "//THAT = *(FRAME - 1)     // THAT Restoration for the caller\n"
out *= restoreReturn("THAT", 1)
out *= "//THIS = *(FRAME - 2)     // THIS Restoration for the caller\n"
out *= restoreReturn("THIS", 2)
out *= "//ARG = *(FRAME - 3)     // ARG Restoration for the caller\n"
out *= restoreReturn("ARG", 3)
out *= "//LCL = *(FRAME - 4)     // LCL Restoration for the caller\n"
out *= restoreReturn("LCL", 4)
out *= "//goto return address (back to the caller's code)\n"
out *= "@R14\nA=M\n0;JMP\n\n\n"
return out

end

function codeWriter(inputFile, labelNum, returnNum)
    # Returns translated text in assembly language from the input file
    funcDictionary  = Dict("push" => push, "pop" => pop)
    arithmeticDictionary = Dict("eq" => "JEQ", "lt" => "JLT", "gt" => "JGT")
    mathematicDictionary = Dict("add" => "+", "sub" => "-") 
    logicDictionary = Dict("and" => "&", "or" => "|")
    contolDictionary = Dict("label" => writeLabel, "goto" => writeGoto, "if-goto" => writeIf)
    
    lines = readlines(inputFile)
    code = ""
    for line in lines
        splitline = split(line)
        if line != "" && line[1] != '/'    # not cmd line            
            if splitline[1] == "pop" || splitline[1] == "push"   # pop/push cmd
                code *= funcDictionary[splitline[1]](splitline[2], splitline[3], split(split(inputFile, "\\")[end], ".")[1])
            elseif splitline[1] == "eq" || splitline[1] == "lt" || splitline[1] == "gt"
                code *= arithmetics(splitline[1], arithmeticDictionary[splitline[1]], labelNum)
                labelNum += 1
            elseif splitline[1] == "sub" || splitline[1] == "add"
                code *= mathematics(splitline[1], mathematicDictionary[splitline[1]])
            elseif splitline[1] == "neg"
                code *= neg()
            elseif splitline[1] == "and" || splitline[1] == "or"
                code *= logics(splitline[1] ,logicDictionary[splitline[1]])
            elseif splitline[1] == "not"
                code *= not()
            elseif splitline[1] == "label" || splitline[1] == "goto" || splitline[1] == "if-goto"
                code *= contolDictionary[splitline[1]](splitline[2])
            elseif splitline[1] == "function"
                code *= writeFunction(splitline[2], splitline[3])
            elseif splitline[1] ==  "call"
                code *= writeCall(splitline[2], splitline[3], returnNum)
                returnNum += 1
            elseif splitline[1] == "return"
                code *= writeReturn()
            end
        end
    end
    return (code, labelNum, returnNum)
end

function main()
    directory = ARGS[1]
    # directory = "C:\\Users\\Yossef\\Desktop\\nand2tetris\\projects\\08\\FunctionCalls\\SimpleFunction"
    fileName = split(directory, "\\")[end]
    files = readdir(directory)
    labelNum = 0 # for labels using
    returnNum = 1 # for return labels using
    open("$directory\\$fileName.asm", "w") do f
        for file in files
            if file == "Sys.vm"
                write(f, writeInit())
            end
        end
        for file in files
            if split(file, ".")[2] == "vm"                 
                code, labelNum, returnNum = codeWriter("$directory\\$file", labelNum, returnNum)
                write(f, code)
            end
        end
    end
    return 0
end

main()