local util =   require("mock.util")
local Any = {

    String = "$any-string",
    Int = "$any-int",
    Float = "$any-float",
    Number = "$any-numbe",
    Table = "$any-table",
    Function = "$any-funciton",
    Pattern = "$any-pattern",

}


local It = {}

function It.any_string()

    return Any.String
    
    
end

function It.any_number()

    return Any.Number
    
    
end



function It.any_int()
    return Any.Int
end


function It.any_float()

    return Any.Float

end


function It.any_table()

    return Any.Table

end


function It.any_function()

    return Any.Function

end


function It.pattern(pattern)


    return Any.Pattern
  
end


function It.is_any(arg)

    for key, value in pairs(Any) do
        if value == arg then return true
        end 
    end
    return false
  
end

function It.verify_type(arg, type)
    if type ==Any.String then
        return util.gettype(arg) == util.type.string

    elseif type ==Any.Int then
        return util.gettype(arg) == util.type.integer

    elseif type ==Any.Float then
        return util.gettype(arg) == util.type.flaot

    elseif type ==Any.Number then
        return (util.gettype(arg) == util.type.flaot) or (util.gettype(arg) == util.type.integer)


    elseif type ==Any.Table then
        return util.gettype(arg) == util.type.table

    elseif type ==Any.Function then
        return util.gettype(arg) == util.type.func
    
    elseif type ==Any.Pattern then
        return  util.gettype(arg) == util.type.string 
        
    end
end



return It