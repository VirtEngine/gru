--
-- Mru module for installing and configuring
-- The require command respresents the serially execute the process.
--

io.stdout:write([[
---------------------------------------------
                launching...

                ███╗   ███╗██████╗ ██╗   ██╗
                ████╗ ████║██╔══██╗██║   ██║
                ██╔████╔██║██████╔╝██║   ██║
                ██║╚██╔╝██║██╔══██╗██║   ██║
                ██║ ╚═╝ ██║██║  ██║╚██████╔╝
                ╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝

 [*] Current time: ]], os.date("%x-%X"), "\n\n")
io.stdout:flush()

require("setupenv")

local DataStorage = require("datastorage")

local MruManager = require("mrumanager")

local exit_code = nil

exit_code = MruManager:run()

local function exitReader()
    if type(exit_code) == "number" then
        os.exit(exit_code)
    else
        os.exit(0)
    end
end

exitReader()
