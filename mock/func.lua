local util = require("mock.util")
local Args = require("mock.args")


local ExeType = {
    Never = 0,
    AtLeast = 1,
    Once = 2,
    Exacatly = 3,
}



local FuncMock = {}

function FuncMock:New(func)

   
    local mock_obj = {}
    mock_obj.type = util.type.func
    mock_obj.info = debug.getinfo(func)
    mock_obj.exe_count = {count = 0, type=ExeType.AtLeast , current=0 }
    mock_obj.name = string.match(util.split_by_new_line(mock_obj.info.source)[mock_obj.info.linedefined], "function%s[_%a][_%w]*[:.]([_%a][_%w]*)")
    self.__index = self

    
    setmetatable(mock_obj, self)

    return mock_obj

end


function FuncMock:with(...)

    self.args = Args:New(...)

    return self
    
end


function FuncMock:returns(...)

    self.returns = table.pack(...)
    return self
end


function FuncMock:count(n)
    self.count = n

    return self
end

function FuncMock:after (fun)
    self.after = fun
    return self
end

function FuncMock:__exe(ref_table)
    -- verify count
    -- verify args 
    -- verify after 

    if(self.exe_count.type == ExeType.Never) then  
        error(string.format("%s should never be called", self.name)) 

    elseif (self.exe_count.type == ExeType.Once and self.exe_count.current > 0) then  
        error(string.format("%s should be called exactly once, but it was called %d", self.name, self.exe_count.current+1)) 
        
    elseif (self.exe_count.type == ExeType.Exacatly and self.exe_count.current >= self.exe_count.count) then  
        error(string.format("%s should be called exactly %d, but it was called %d", self.name, self.exe_count.count, self.exe_count.current+1)) 
    end

    
    return function(...) 
  
        local given_arg = table.pack(...)
        if given_arg[1] == ref_table then 
            table.remove(given_arg, 1)
        end
        if not self.args:verify(table.unpack(given_arg)) then error("different args was passed to the function") end

        self.exe_count.current = self.exe_count.current + 1
        
        return table.unpack(self.returns)
     end
end

function FuncMock:get_attr()
    
    return self
end

function FuncMock:run_never()

    self.exe_count.type = ExeType.Never
    return self
end

function FuncMock:run_once()

    self.exe_count.type = ExeType.Once
    return self
end



function FuncMock:run_exactly(count)

    if util.gettype(count) ~= util.type.integer then error("count should be of type integer")end
    self.exe_count.count = count
    self.exe_count.type = ExeType.Exacatly
    return self
end


function FuncMock:run_at_least(count)

    if util.gettype(count) ~= util.type.integer then error("count should be of type integer")end
    self.exe_count.count = count
    self.exe_count.type = ExeType.AtLeast
    
    return self
end

function FuncMock.find(func, func_list)

    return func_list

    
end






return FuncMock





