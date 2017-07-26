local lfs = require("libs/libkoreader-lfs")

local DataStorage = {}

local data_dir

function DataStorage:getDataDir()
    if data_dir then return data_dir end

    data_dir = os.getenv("RIOOS_HOME") .. "/"

    if lfs.attributes(data_dir, "mode") ~= "directory" then
        lfs.mkdir(data_dir)
    end

    return data_dir
end

function DataStorage:getHistoryDir()
    return self:getDataDir() .. "/history"
end

function DataStorage:getSettingsDir()
    return self:getDataDir() .. "/settings"
end

local function initDataDir()
    local sub_data_dirs = {
        "cache", "clipboard", "data", "history",
        "ota", "screenshots", "settings",
    }
    for _, dir in ipairs(sub_data_dirs) do
        local sub_data_dir = DataStorage:getDataDir() .. "/" .. dir
        if lfs.attributes(sub_data_dir, "mode") ~= "directory" then
            lfs.mkdir(sub_data_dir)
        end
    end
end

initDataDir()

return DataStorage
