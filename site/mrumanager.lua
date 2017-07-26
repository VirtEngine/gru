--[[--
This module manages mru software
]]


-- there is only one instance of this
local MruManager = {
  _exit_code = nil

}

function MruManager:init()

end

-- this is the main loop of Mru
-- it is intended to call the appropriate software
function MruManager:run()
  
    return self._exit_code
end


MruManager:init()
return MruManager
