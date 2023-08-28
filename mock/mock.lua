local util = require("mock.util")
local FuncMock = require ("mock.func")

local Mock = {}



function Mock:new(obj, strict)  -- obj to mock, 

    local mock = {}
   mock.__is_function = (util.gettype(obj) == util.type.func) or false;
   mock.__is_table = (util.gettype(obj) == util.type.table) or false;

   if not mock.__is_function and not mock.__is_table then error(string.format("%s type can't be mocked", util.gettype(obj))) end

   mock.__strict = strict or false -- default is loose mode 

   mock.__obj_ref = obj -- holds a reference to the original object

   mock.__settings = {} --> array holds the settings for each method that we want to mock

   mock.__events_queue = {}

   setmetatable(mock, { 
            __index = function (t, k)
               
                local mock_func = mock.__settings[k]
                if not mock_func  and mock.__strict then error(string.format("%s is called but was not set. you can set %s or strict mode to false", k, k))
                elseif mock_func then return mock_func:__exe(t)
                else return function ()
                    
                end

                end   
            end 
        }
    )


    function mock:setup(func)

        local func_mock = FuncMock:New(func)
        mock.__settings[func_mock.name] = func_mock
    
        return func_mock
    end

 
    return mock
    
end 






return Mock
