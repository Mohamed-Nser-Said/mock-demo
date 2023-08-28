local util = require("mock.util")
local args = require("mock.args")

local Settings = {
    
}

function Settings:__new (mock_ref, func)
    self.__mock_ref = mock_ref
    self.__type = util.gettype(func)
    self.__func= func
    self.__name = util.get_key(mock_ref.obj_ref, func)
    self.__call_counter = 0
    mock_ref.settings[self.__name] = self:__exe()
            
    return self
end 


function Settings:returns (returns )
    
    self.__returns = returns or nil
    return self
end 

function Settings:with (...)
    local expected_args = table.pack(...)

    self.__args = ArgList:new(expected_args)

    return self
end 

function Settings:with_any_argument ()

    self.__args = ArgList:new(nil)

    return self
end 

function Settings:after(after)

    self.__after = after
    return self
end

function Settings:times(times)

    self.__times = times

    return self
    
end

function Settings:__exe()

    return function (...) 

        if self:__verfiy(...) then
            self.__call_counter = self.__call_counter + 1
            table.insert(self.__mock_ref.call_queue, self.__name)
            return self.__returns
        end
    
    end
end


function Settings:__verfiy(...)

    if not self.__mock_ref.strict then return true end
    -- check arguments is the same as the mock settings 
    local args = table.pack(...)
    
    if not util.compare_tables(args, self.__args) then 
        error(string.format("%s called with different argumnet, try to set the strict mode off", self.__name))
        
    end 

    if self.__times == times.never then
        error(string.format("%s should never be called", self.__name))

    elseif self.__times == times.once and self.__call_counter > 0 then
        error(string.format("%s should be called exactly once but it was called %d times", self.__name, self.__call_counter + 1))
    
        
    end


    return true



end


return Settings