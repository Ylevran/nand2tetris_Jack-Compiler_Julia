seg_dic = Dict("CONST" => "constant", "ARG" => "argument", "LOCAL" => "local", "STATIC" => "static", "FIELD" => "this", "THAT" => "that", "POINTER" => "pointer", "TEMP" => "temp" )

function writePush(segment, index)
    return "push " * seg_dic[segment] * " $index\n"
end

function writePop(segment, index)
    return "pop " * seg_dic[segment] * " $index\n"
end

function writeArihtmetic(command)
    return "$command\n"
end

function writeLabel(label)
    return "label $label\n"
end

function writeGoto(label)
    return "goto $label\n"
end

function writeIf(label)
    return "if-goto $label\n"    
end

function writeCall(name, nArgs)
    return "call $name $nArgs\n"
end

function writeFunction(name, nLocals)
    return "function $name $nLocals\n"
end

function writeReturn()
    return "return\n"
    
end