local addonName, addonTable = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

-- 动态获取职业列表
local systemClasses = {}
for i = 1, GetNumClasses() do
    local className, classTag = GetClassInfo(i)
    if classTag then
        systemClasses[classTag] = className
    end
end

-- 辅助函数：快速获取当前 profile
local function GetDB()
    local app = LibStub("AceAddon-3.0"):GetAddon(addonName, true)
    if app and app.db then
        return app.db.profile
    end
end

addonTable.Options = {
    name = L["SETTING_TITLE"] or "SmartFocus",
    type = "group",
    args = {
        debugMode = {
            name = L["DEBUG_MODE"] or "Debug Mode",
            type = "group",
            inline = true,
            order = 0,
            args = {
                debugMode = {
                    name = L["DEBUG_MODE"],
                    desc = L["DEBUG_MODE_DESC"],
                    type = "toggle",
                    get = function() return GetDB().debugMode end,
                    set = function(_, v) GetDB().debugMode = v end,
                },
            }
        },
        positionSettings = {
            name = L["POS_SETTING"] or "Button Position Settings",
            type = "group",
            inline = true,
            order = 4,
            args = {
                posX = {
                    name = L["POS_X"] or "Horizontal Offset (X)",
                    type = "range",
                    min = -math.floor(GetScreenWidth() / 2),
                    max = math.floor(GetScreenWidth() / 2),
                    step = 1,
                    get = function() return GetDB().buttonPos.x end,
                    set = function(_, v)
                        GetDB().buttonPos.x = v
                        SmartFocus:UpdateButtonPosition() -- 实时移动
                    end,
                    order = 1,
                },
                posY = {
                    name = L["POS_Y"] or "Vertical Offset (Y)",
                    type = "range",
                    min = -math.floor(GetScreenHeight() / 2),
                    max = math.floor(GetScreenHeight() / 2),
                    step = 1,
                    get = function() return GetDB().buttonPos.y end,
                    set = function(_, v)
                        GetDB().buttonPos.y = v
                        SmartFocus:UpdateButtonPosition() -- 实时移动
                    end,
                    order = 2,
                },
                resetPos = {
                    name = L["POS_RESET"] or "Reset Button Position",
                    type = "execute",
                    func = function()
                        GetDB().buttonPos.x = 0
                        GetDB().buttonPos.y = -100
                        SmartFocus:UpdateButtonPosition()
                    end,
                    order = 3,
                }
            }
        },
        classSettings = {
            name = L["APP_CLASS"] or "Enabled Classes",
            type = "multiselect",
            order = 1,
            values = systemClasses,
            get = function(info, key) return GetDB().enabledClasses[key] end,
            set = function(info, key, value) GetDB().enabledClasses[key] = value end,
        },
        scenarioSettings = {
            name = L["APP_SCENARIO"] or "Scenarios",
            type = "group",
            inline = true,
            order = 2,
            args = {
                delve = {
                    name = L["DELVE"] or "Delves",
                    type = "toggle",
                    get = function() return GetDB().scenarios.delve end,
                    set = function(_, v) GetDB().scenarios.delve = v end
                },
                dungeon = {
                    name = L["DUNGEON"] or "Dungeons",
                    type = "toggle",
                    get = function() return GetDB().scenarios.dungeon end,
                    set = function(_, v) GetDB().scenarios.dungeon = v end
                },
                raid = {
                    name = L["RAID"] or "Raids",
                    type = "toggle",
                    get = function() return GetDB().scenarios.raid end,
                    set = function(_, v) GetDB().scenarios.raid = v end
                },
                pvp = {
                    name = L["PVP_SCENE"] or "PVP",
                    type = "toggle",
                    get = function() return GetDB().scenarios.pvp end,
                    set = function(_, v) GetDB().scenarios.pvp = v end
                },
            }
        },
        pvpSettings = {
            name = L["PVP_SUB_OPTS"] or "PVP Options",
            type = "group",
            inline = true,
            order = 3,
            hidden = function() return not GetDB().scenarios.pvp end,
            args = {
                focusTank = {
                    name = L["FOCUS_TANK"] or "Focus Tank",
                    type = "toggle",
                    order = 1,
                    get = function() return GetDB().pvpOptions.focusTank end,
                    set = function(_, v) GetDB().pvpOptions.focusTank = v end,
                },
                focusDPS = {
                    name = L["FOCUS_DPS"] or "Focus DPS",
                    type = "toggle",
                    order = 2,
                    get = function() return GetDB().pvpOptions.focusDPS end,
                    set = function(_, v) GetDB().pvpOptions.focusDPS = v end,
                },
                dpsClassPick = {
                    name = L["PICK_DPS_CLASS"] or "Pick Classes",
                    type = "multiselect",
                    order = 3,
                    hidden = function() return not GetDB().pvpOptions.focusDPS end,
                    values = systemClasses,
                    get = function(info, key) return GetDB().pvpOptions.dpsClasses[key] end,
                    set = function(info, key, value) GetDB().pvpOptions.dpsClasses[key] = value end,
                }
            }
        }
    }
}
