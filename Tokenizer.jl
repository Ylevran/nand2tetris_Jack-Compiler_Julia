# lists of characters and keywords in jack
symbols = ['}', '{', ')','(', '[', ']', '.', ',', ';', '+', '-', '*', '/', '&', '|', '<', '>', '=', '~', "}", "{", ")","(", "[", "]", ".", ",", ";", "+", "-", "*", "/", "&", "|", "<", ">", "=", "~"]
keywords = ["class", "constructor", "function", "method", "field", "static", "var", "int", "char", "boolean", "void", "true", "false", "null", "this", "let", "do", "if", "else", "while", "return"]

# a dictionary to convert some symbols that we use in xml
symbolDict = Dict("<" => "&lt;", ">" => "&gt;", "\"" => "&quot;", "&" =>"&amp;")

# a function to find the places in a line that we have quotes
function findQuotsPlace(line)
    places = []
    range = 1:length(line)
    for i in range
        if line[i] == '\"'
            append!(places, i)
        end
    end
    return places
end

# a function to check if some word isn't an identifier 
# but a glue words
function checkGlueSymbols(word)
    if length(word) == 1 # the minimum length - means its not glue
        return false
    end
    
    # if the length bigger than 1 we checks if it glue
    for chr in word
        if chr in symbols
            return true
        end
    end
    return false
end

# a function to check if character is a digit
function checkDigit(str)
    try 
        parse(Int64, str)
        true
    catch
        false
    end
end

# a function to remove the quotes before and after a string
function extractString(str)
    return SubString(str, 2:length(str) - 1)
end

# a function to identify every word to his tag
# assuming that we get jus a word from a line
function identify(word)
    id = ""
    if word in symbols
        if word in keys(symbolDict)
            word = symbolDict[word]
        end
        id = "symbol"
    elseif word in keywords
        id = "keyword"
    elseif word[1] == '\"'
        id = "stringConstant"
        word = extractString(word)
    elseif checkDigit(word)
        id = "integerConstant"
    else
        id = "identifier"
    end
    
    return id, word
end

# a function to write the start of the xml tag
function start(word)
    return "<$word> "
end

# a function to write the end of the xml file
function finish(word)
    return " </$word>"
end

# a function to print the tag of the word
function printIdentify(id, word)
    return (start(id) * word * finish(id) * "\n")
end

# a function to separate glue words into sme words
function separate(word)
newWord = ""
wordLength = length(word)
range = 1:wordLength - 1
for i in range # the loop is running on the word without its last character
  newWord *= word[i]
  thisChr = word[i] # pointed to the character in word[i]
  nextChr = word[i + 1] # pointed to the character after word[i]
  if thisChr in symbols && !(nextChr in symbols) # we need to saparate the symbol and the other
    newWord *= " "
  elseif !(thisChr in symbols) && nextChr in symbols
    newWord *= " "
  elseif  thisChr in symbols && nextChr in symbols
    newWord *= " "
  end
end
 newWord *= word[end] 
 return newWord
end

# a general function who gets a line and identify every word in it
function generateTokenizer(line)
    token = ""
    places = []
    splitLine = []
    if '\"' in line # first we checks if we have a quote - means that we had a string 
        places = findQuotsPlace(line) # we get the places of the quotes
        range = places[1]:places[2]
        str = line[range] # the string in the line
        line1 = line[1:places[1] - 1] # the part from  the start to the string
        splitting = split(line1, " ")
        for i in splitting
            if i != ""
              append!(splitLine, [i]) # create a new list of words
            end
        end
        append!(splitLine, [str]) # insert to the list the whole string together

        line2 = line[places[2] + 1:end] # the part from the string to the end
        splitting = split(line2, " ")
        for i in splitting
            if i != ' '
              append!(splitLine, [i])
            end
        end
    else # if we hasn't a string in the line
       splitLine = split(line, " ")
    end
    
        
    # running on every place in the list
    for word in splitLine
        if checkGlueSymbols(word) == false && word != ""
            id, printing = identify(word)
           token *= printIdentify(id, printing)
        elseif word != "" # if we have a glue words
           newLine = separate(word)
           splitLine = split(newLine)
          for word in splitLine
            id, printing = identify(word)
          token *=  printIdentify(id, printing)
          end                    
        end
    end
    return token

end

# this function checks if a line is a comment
function isComment(line)
if line[1] == '/' || line[1] == '*' # the line starts with the comment
    return true
elseif line[1] == ' ' # the line didn't start with the comment
    splitLine = split(line)
    return isComment(join(splitLine))
elseif "/*" in split(line) || "//" in split(line)
    return true
end
return false
end


# a main function create an xml file from a jack file
function main()
    splitLine = []
   # directory = "C:\\Users\\Yossef\\Desktop\\nand2tetris\\projects\\10\\Test\\ArrayTest"
   directory = ARGS[1]
    files = readdir(directory)
    T = "T" 
    for file in files
        if split(file, ".")[2] == "jack"
            lines = readlines("$directory\\$file")
            tokens = start("tokens")
            tokens *= "\n"
             for line in lines
                if  length(split(line)) != 0  # if the line isn't empty
                    if !(isComment(line))
                        splitLine = split(line)
                      if "//" in splitLine # there is a comment but it's not the whole line
                        line1 = []
                        index = findall(x-> x == "//", splitLine)[1] # getting the index of the comment
                        range  = 1:(index -1)
                        for i in range
                          append!(line1, [splitLine[i]])
                        end
                        line = join(line1, " ")
                        tokens *= generateTokenizer(line)
                      else # there arn't any comment in the line
                        if line[1] != ' '
                          if  line[1] == '\t' # remove the Tabs
                            line = line[2:end]
                          end
                          if line[1] == ' ' #remove the spaces after the Tabs
                            line = join(splitLine, " ")
                          end
                            tokens *= generateTokenizer(line)
                       
                        else
                            splitLine = split(line)
                            line = join(splitLine, " ")
                            tokens *= generateTokenizer(line)
                        end
                      end
                    end

               end
             end
        tokens *= finish("tokens")
        tokens *= "\n"
        #print(tokens)
            shortFileName = split(file, ".")[1]
            open("$directory\\$shortFileName$T.xml", "w") do f
                write(f, tokens)
            end
        print("Successfuly created file $shortFileName$T.xml\n")
        end
    end
    return 0
end   

main()