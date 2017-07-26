local Device = require("device")

local ConfirmBox = require("ui/widget/confirmbox")
local DataStorage = require("datastorage")
local LuaSettings = require("luasettings")
local UIManager = require("ui/uimanager")
local WidgetContainer = require("ui/widget/container/widgetcontainer")
local logger = require("logger")

local _ = require("gettext")
local T = require("ffi/util").template

local JavaBuilder = {
  settings = LuaSettings:open(DataStorage:getSettingsDir() .. "/JavaBuilder.lua"),
  settings_id = 0,
  enabled = false,
  last_brightness = -1,
}


function JavaBuilder:init()
    self.enabled = self.settings:nilOrTrue("enable")
    self.settings_id = self.settings_id + 1
    logger.dbg("JavaBuilder:init() self.enabled: ", self.enabled, " with id ", self.settings_id)
end

function JavaBuilder:preflipSetting()
    self.settings:flipNilOrTrue("enable")
    self:init()
end

function JavaBuilder:onFlushSettings()
    self.settings:flush()
end

JavaBuilder:init()

local JavaBuilderWidget = WidgetContainer:new{
    name = "JavaBuilder",
}

function JavaBuilderWidget:init()
    -- self.ui and self.ui.menu are nil in unittests.
    if self.ui ~= nil and self.ui.menu ~= nil then
        self.ui.menu:registerToMainMenu(self)
    end
end

function JavaBuilderWidget:flipSetting()
    JavaBuilder:flipSetting()
end

-- For test only.
function JavaBuilderWidget:deprecateLastTask()
    logger.dbg("JavaBuilderWidget:deprecateLastTask() @ ", JavaBuilder.settings_id)
    JavaBuilder.settings_id = JavaBuilder.settings_id + 1
end

function JavaBuilderWidget:addToMainMenu(menu_items)
    menu_items.auto_frontlight = {
        text = _("Auto frontlight"),
        callback = function()
            UIManager:show(ConfirmBox:new{
                text = T(_("Auto frontlight detects the brightness of the environment and automatically turn on and off the frontlight.\nFrontlight will be turned off to save battery in bright environment, and turned on in dark environment.\nDo you want to %1 it?"),
                         JavaBuilder.enabled and _("disable") or _("enable")),
                ok_text = JavaBuilder.enabled and _("Disable") or _("Enable"),
                ok_callback = function()
                    self:flipSetting()
                end
            })
        end,
        checked_func = function() return JavaBuilder.enabled end,
    }
end

function JavaBuilderWidget:onFlushSettings()
    JavaBuilder:onFlushSettings()
end

return JavaBuilderWidget
