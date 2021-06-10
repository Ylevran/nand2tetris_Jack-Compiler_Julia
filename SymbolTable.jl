# dictionary to convert segments to to vm
segDic = Dict("argument" => "ARG", "var" => "LOCAL", "static" => "STATIC","field" => "FIELD")

# function that get a line in xml and return the word in it
function extractToken(line)
   splitting = split(line)
   tokens = []
    for i in splitting
        if '<' ∉ i || '>' ∉ i
          append!(tokens, [i])
        end
    end

    return join(tokens, " ") # if it a string
end

# a function that gets a line and find the and of it
function findAndLine(lines)
    lineDec = []
    for line in lines
        append!(lineDec, [line])
        token  = extractToken(line)
        if token == ";"
           return lineDec 
        end
    end
end

# a function that check if we had a more vars in the class
function checkVars(lines)
    for line in lines
        token = extractToken(line)
        if token == "function" || token == "method" || token == "constructor"
            return true
        end
    end
    return false
end

# a function that get xml file and gets the whole lines that
# belongs to the class vars
function findVars(lines)
    classLines = []
    for line in lines
        token = extractToken(line)
        if token == "function" || token == "method" || token == "constructor"
            return classLines
        end
        append!(classLines, [line])
    end
end

# a function that eat all the tokens tkens in lines that 
# we have in to
function eatTokens(lines, to)
    if to == []
        return lines
    end
    x = lines[2:end]
    y = to[2:end]
    return eatTokens(x, y)
end

# a function that returns the line till we have a getTillComma
# (or ; if we havn't a comma)
function getTillComma(line)
    tokenList = []
for token in line
    append!(tokenList, [token])
    if extractToken(token) == ","  || extractToken(token) == ";"
     return tokenList
    end
end
end

# a function that insert to the dictionary the values that we have 
# from the comma to the end of the line
function insertAfterComma(line, dictionary,CountDict, type, kind)
    tokensToComma = getTillComma(line)
    if extractToken(line[2]) == ";"
      #  lines = eatTokens(line, tokensToComma)
        return dictionary, CountDict
    end
    lines = eatTokens(line, tokensToComma)
    name = extractToken(lines[1])
    count = CountDict[kind]
    push!(dictionary, name => [type, segDic[kind], "$count"])
    CountDict[kind] += 1
    return insertAfterComma(lines, dictionary, CountDict, type, kind)
end

function manageClasslines(lines)
    # spliting = split(lines, "\n")
    if checkVars(lines)
      classLines = findVars(lines)
    else
        classLines = lines
    end
    return classLines
    end

# the generating function to insert to class symbol table its values
function classVarSymbolTable(lines, dictionary, CountDict)
    kind = ""
    name = ""
    classLines = manageClasslines(lines)

    if classLines == [] || classLines == [""]
        return dictionary
    end

    line = findAndLine(classLines)
 
    kind = extractToken(line[1])
    type = extractToken(line[2])
    name = extractToken(line[3]) 
    count = CountDict[kind]
    dictionary[name] = [type, segDic[kind], "$count"]
   # push!(dictionary, name => [type, segDic[kind], "$count"])
    CountDict[kind] += 1
    if extractToken(line[4]) == ";" # it means that we have only 1 var 
        lines =  eatTokens(classLines, line)
    else # it means that we had  more than 1 var
        dictionary, CountDict = insertAfterComma(classLines, dictionary, CountDict, type, kind)
        lines =  eatTokens(classLines, line)
    end
    return classVarSymbolTable(lines, dictionary, CountDict)
   
return dictionary

end

# a function that managed the argument in subroutine
function findArguments(subroutine)
    subArgs = []
    for line in subroutine
        token = extractToken(line)
        append!(subArgs, [line])
        if token == "("
            subArgs = eatTokens(subroutine, subArgs)
            args = getArgs(subArgs)
            return args, subArgs
            
        end
    
    end
    
end
# a function that gives the code line of the arguments
function getArgs(subroutine)
    args = []
    for line in subroutine
        append!(args, [line])

        if extractToken(line) == "{" 
            return args
        end
    end

end

function findLocal(file)
    locals = []
    for line in file
        if extractToken(line) != "let" && extractToken(line) != "do"
          append!(locals, [line])
        else
            return locals
        end
    end
end

# a function to create a count dictionary to count the vars 
function createCountDic(keyWord1, keyWord2)
    return  Dict(keyWord1 => 0, keyWord2 => 0)
  end
  
  # the main function that return the symbol table to every subtoutine scope
  function generateSubroutines(file, dictionary, className, symbolTable)
    if extractToken(file[1]) == "method"
        symbolTable["this"] = [className, "ARG", "0"]
       # push!( symbolTable, "this" => [methodName, "ARG", "0"])
        dictionary["argument"] += 1
      end
      args, subArgs = findArguments(file)
      symbolTable = manageArguments(args, dictionary, symbolTable)

     
      file = eatTokens(subArgs, args)
      locals = findLocal(file)
      if locals == [] || locals == [""]
        return symbolTable
      else 
        return insertLocals(locals, dictionary, symbolTable)
      end
      
  end

  function insertLocals(file, dictionary, symbolTable)
    if file == [] || file == [""]
        return symbolTable
    end
    lines = findAndLine(file)
    kind = extractToken(file[1])
    type =  extractToken(file[2])
    name =  extractToken(file[3])
    count = dictionary[kind]
    # push!(symbolTable, name => [type, segDic[kind], "$count"])
    symbolTable[name] = [type, segDic[kind], "$count"]
    dictionary[kind] += 1
    if extractToken(file[4]) == ";" # it means that we have only 1 var 
        lines =  eatTokens(file, lines)
    else # it means that we had  more than 1 var
        symbolTable, dictionary = insertAfterComma(lines, symbolTable, dictionary, type, kind)
        lines =  eatTokens(file, lines)
    
    end
    return insertLocals(lines, dictionary, symbolTable)

  end

  # a function that return the symbol table for the arguments
  
  function manageArguments(args, CountDictionary, dictionary)
    if extractToken(args[1]) == ")"
        return dictionary
    end

    name = ""
    type = ""
    count = 1
    kind = "argument"
    type = extractToken(args[1])
    name = extractToken( args[2])
    count = CountDictionary[kind]
    CountDictionary[kind] += 1
    push!(dictionary, name => [type, segDic[kind], "$count"])
    if extractToken(args[3])  == ","
       return manageArguments(args[4:end], CountDictionary, dictionary)
    else
        return manageArguments(args[3:end], CountDictionary, dictionary)
    end
  end