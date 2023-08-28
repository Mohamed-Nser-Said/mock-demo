local util = require("mock.util")
local it = require("mock.it")


local Args = {}

function Args:New(...)

   
    local args = {}
    self.__index = self

    args.expected_args = table.pack(...)


    setmetatable(args, self)

    return args

end


function Args:verify(...)

    local given_args  = table.pack(...)


    for key, value in pairs(self.expected_args) do
        if it.is_any(value) and it.verify_type(given_args[key], value) then
        elseif util.gettype(value) == util.type.table then 
            if not util.compare_tables(value, given_args[key]) then
                return false
            end
        
        elseif value ~= given_args[key] then return false
        end
    end

    return true

    -- return util.compare_tables(given_args, self.expected_args)
    
end






return Args

