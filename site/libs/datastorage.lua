local DataStorage = {}

local data_dir

function DataStorage:getBuildpackDir()
    if data_dir then return data_dir end

    data_dir = os.getenv("RIOOS_HOME") .. "/" .. "buildpacks"

    return data_dir
end

function DataStorage:getBuildDir()
    return self:getDataDir() .. "/builds"
end

function DataStorage:getCodeDir()
    return self:getDataDir() .. "/builds" .. "/code"
end

local function initDataDir()
end

initDataDir()

return DataStorage
