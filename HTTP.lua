

local Lib = {}

function Lib.New()
  return Lib
end


function Lib:Get(url)
  print (string.format("[%s][GET] %s ", os.date("%H:%M:%S", os.time()), url)) 
end



function Lib:Post(url, data)
  print (string.format("[%s][POST] %s ", os.date("%H:%M:%S", os.time()), url), data) 
end


return Lib