local util = {}


util.type = {
    func = "function",
    table= "table",
    string = "string",
    number = "number",
    flaot = "float",
    integer = "integer",
    bool = "boolean",
}

function util.gettype(obj)
    
    local obj_type = type(obj)
    if obj_type==util.type.number then obj_type = math.type(obj) end
    return obj_type 

end


function util.get_key(table, value) 

    for k,v in pairs(table) do
        if v==value then return k end
    end
    return nil
end

function util.clone(obj) 
    local clone = {}
    for k,v in pairs(obj) do
        clone[k] = v
    end
    return clone
end

function util.find(value, table)
    for key, val in pairs(table) do
        if val == value then
            return key
        end
    end
    return nil
end

function util.compare_tables(table1, table2)
    if type(table1) ~= "table" or type(table2) ~= "table" then
        return false
    end

    -- Check if both tables have the same keys
    for key in pairs(table1) do
        if table2[key] == nil then
            return false
        end
    end
    for key in pairs(table2) do
        if table1[key] == nil then
            return false
        end
    end

    -- Check if values for each key are equal
    for key, val in pairs(table1) do
        if type(val) == "table" then
            if not util.compare_tables(val, table2[key]) then
                return false
            end
        elseif val ~= table2[key] then
            return false
        end
    end

    return true
end


function util.str_split(str, delimiter)
    local result = {}
    local pattern = string.format("([^%s]+)", delimiter)
    
    for match in str:gmatch(pattern) do
        table.insert(result, match)
    end
    
    return result
end

function util.split_by_new_line(inputString)
    local result = {}
    local pattern = "([^\r\n]*)\r?\n"
    
    for match in inputString:gmatch(pattern) do
        table.insert(result, match)
    end
    
    -- Check if the last line doesn't end with a newline
    local lastLine = inputString:match("[^\r\n]*$")
    if lastLine ~= "" then
        table.insert(result, lastLine)
    end
    
    return result
end

return util