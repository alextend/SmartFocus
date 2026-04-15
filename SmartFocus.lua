local addonName, addonTable = ...
---@class SmartFocus : AceAddon, AceEvent, AceConsole
---@field db table
---@field focusBtn table
SmartFocus = LibStub("AceAddon-3.0"):NewAddon(CreateFrame("Frame", "SmartFocus"), addonName, "AceEvent-3.0", "AceConsole-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local defaults = {
    profile = {
        debugMode = false,
        enabledClasses = {},
        scenarios = { delve = true, dungeon = true, raid = true, pvp = false },
        pvpOptions = { focusTank = false, focusDPS = false, dpsClasses = {} },
        buttonPos = { x = 0, y = -100 }
    }
}

-- 本地化调试函数
local function DebugLog(msg, ...)
    if SmartFocus.db and SmartFocus.db.profile.debugMode then
        local status, output = pcall(string.format, msg, ...)
        print("|cff00ffff[SF-Debug]|r " .. (status and output or msg))
    end
end

local function CoreLogic()
    DebugLog(L["DEBUG_START_CHECK"])

    if InCombatLockdown() then 
        DebugLog(L["DEBUG_IN_COMBAT"])
        return 
    end
    
    if UnitExists("focus") then
        if SmartFocus.focusBtn:IsShown() and not InCombatLockdown() then
            SmartFocus.focusBtn:Hide()
        end
        DebugLog(L["DEBUG_HAS_FOCUS"])
        return
    end

    if GetNumGroupMembers() == 0 then
        DebugLog(L["DEBUG_NO_GROUP"])
        return
    end

    local db = SmartFocus.db.profile
    local _, myClass = UnitClass("player")
    
    if not db.enabledClasses[myClass] then
        DebugLog(L["DEBUG_CLASS_DISABLED"], myClass)
        return
    end

    local _, instanceType = GetInstanceInfo()
    DebugLog(L["DEBUG_MAP_TYPE"], tostring(instanceType))

    -- 地下堡
    if instanceType == "scenario" and db.scenarios.delve then
        DebugLog(L["DEBUG_DELVE_SCAN"])
        local units = {"npc1", "party1", "party2", "party3", "party4"}
        for _, unit in ipairs(units) do
            if UnitExists(unit) then
                DebugLog(L["DEBUG_UNIT_FOUND"], unit, GetUnitName(unit))
                if not UnitIsPlayer(unit) and UnitCanCooperate("player", unit) then
                    SmartFocus:ShowFocusButton(unit)
                    return
                end
            end
        end
        DebugLog(L["DEBUG_NO_DELVE_NPC"])
    end
    
    -- 副本/团队
    if (instanceType == "party" and db.scenarios.dungeon) or (instanceType == "raid" and db.scenarios.raid) then
        DebugLog(L["DEBUG_GROUP_SCAN"])
        local num = GetNumGroupMembers()
        local prefix = IsInRaid() and "raid" or "party"
        for i = 1, num do
            local unit = prefix..i
            if UnitExists(unit) and not UnitIsUnit(unit, "player") then
                local role = UnitGroupRolesAssigned(unit)
                if role == "TANK" then
                    SmartFocus:ShowFocusButton(unit)
                    return
                end
            end
        end
        DebugLog(L["DEBUG_NO_TANK"])
    end

    -- PVP场景 (战场或竞技场)
    if (instanceType == "pvp" or instanceType == "arena") and db.scenarios.pvp then
        DebugLog(L["DEBUG_GROUP_SCAN"])
        local num = GetNumGroupMembers()
        local prefix = IsInRaid() and "raid" or "party"
        for i = 1, num do
            local unit = prefix..i
            if UnitExists(unit) and not UnitIsUnit(unit, "player") then
                local role = UnitGroupRolesAssigned(unit)
                local _, classTag = UnitClass(unit)

                -- 逻辑1：优先寻找坦克（如果配置开启）
                if db.pvpOptions.focusTank and role == "TANK" then
                    SmartFocus:ShowFocusButton(unit)
                    return
                end

                -- 逻辑2：寻找特定职业的 DPS（如果配置开启）
                if db.pvpOptions.focusDPS and role == "DAMAGER" and db.pvpOptions.dpsClasses[classTag] then
                    SmartFocus:ShowFocusButton(unit)
                    return
                end
            end
        end
    end
end

function SmartFocus:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("SmartFocusDB", defaults, "Default")
    LibStub("AceConfig-3.0"):RegisterOptionsTable(addonName, addonTable.Options)

    -- 调用独立的 Launcher 文件中定义的函数
    if addonTable.Launcher and addonTable.Launcher.CreatePanel then
        addonTable.Launcher:CreatePanel(function() self:OpenOptions() end)
    end
    self:RegisterChatCommand("sf", "OpenOptions")
    self:UpdateButtonPosition()
    DebugLog(L["DEBUG_INIT"])
end

function SmartFocus:OnEnable()
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("PLAYER_REGEN_ENABLED")
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "PLAYER_ENTERING_WORLD")
    self:RegisterEvent("GROUP_ROSTER_UPDATE")
    
    -- 如果是重载插件，手动触发一次检测
    CoreLogic()
end

function SmartFocus:PLAYER_ENTERING_WORLD()
    DebugLog(L["DEBUG_ZONE_CHANGE"])
    C_Timer.After(5, function()
        DebugLog(L["DEBUG_ZONE_CHANGE_COMPLETE"])
        CoreLogic()
    end)
end

function SmartFocus:GROUP_ROSTER_UPDATE()
    DebugLog("检测到队伍成员变动，重新执行检测逻辑...")
    CoreLogic()
end

function SmartFocus:PLAYER_REGEN_ENABLED()
    DebugLog(L["DEBUG_IN_COMBAT"]:gsub(L["DEBUG_COMBAT_STATE"], L["DEBUG_NON_COMBAT_STATE"])) -- 简单复用逻辑
    CoreLogic()
end

function SmartFocus:OpenOptions()
    local dialog = LibStub("AceConfigDialog-3.0")
    
    -- 如果已经打开，则关闭
    if dialog.OpenFrames[addonName] then
        dialog:Close(addonName)
        if self.focusBtn then
            self.focusBtn:Hide()
        end
        return
    end

    -- 打开配置窗口并获取框架对象
    dialog:Open(addonName)

    local frame = dialog.OpenFrames[addonName]
    if frame and not frame.sfHooked then
        frame.frame:HookScript("OnHide", function()
            if self.focusBtn and not InCombatLockdown() then
                self.focusBtn:Hide()
            end
        end)
        frame.sfHooked = true
    end

    -- 打开后处理预览按钮逻辑
    if not InCombatLockdown() and self.focusBtn then
        self.focusBtn.Text:SetText(L["POS_REVIEW"] or "Position Review")
        self.focusBtn:SetAlpha(1)
        self.focusBtn:Show()
    end
end
