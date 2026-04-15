local addonName, addonTable = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

-- 定义 Launcher 对象
local Launcher = {}
addonTable.Launcher = Launcher

function Launcher.OpenFromSystemSettings(openCallback)
    if not openCallback then return end

    if SettingsPanel and SettingsPanel:IsShown() then
        if HideUIPanel then
            HideUIPanel(SettingsPanel)
        else
            SettingsPanel:Hide()
        end
    end

    if C_Timer and C_Timer.After then
        C_Timer.After(0, function()
            openCallback()
        end)
        return
    end

    openCallback()
end

function Launcher:CreatePanel(openCallback)
    -- 创建
    local f = CreateFrame("Frame", addonName .. "LauncherFrame", UIParent)
    f:Hide()

    -- 1. 大标题 (SmartFocus)
    local title = f:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
    title:SetPoint("TOP", 0, -10)
    title:SetText("|cFFFF0000S|cFFFF7F00m|cFFFFFF00a|cff00FF00r|cff00FFFFt|cffff00ffF|cffffff00o|cff00FF00c|cffff7f00u|cffff0000s|r")
    title:SetScale(5)

    -- 2. 版本号
    local subtitle = f:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
    subtitle:SetPoint("TOP", title, "BOTTOM", 0, -10)
    
    -- 兼容性处理
    local GetMeta = C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata
    local version = GetMeta(addonName, "Version") or "12.0"
    
    subtitle:SetText("|cffffffff版本: " .. version .. " (至暗之夜)|r")

    -- 3. 命令提示
    local cmd = f:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
    cmd:ClearAllPoints()
    cmd:SetPoint("TOP", subtitle, "BOTTOM", 0, -30)
    cmd:SetText("/sf")
    cmd:SetScale(5)
    cmd:SetScript("OnMouseUp", function(self, button)
        if button == "LeftButton" then
            Launcher.OpenFromSystemSettings(openCallback)
        end
    end)
    cmd:SetScript("OnEnter", function(self)
        -- 仅在未保存原始颜色时保存，防止高亮色覆盖原始色
        if not self.r then
            self.r, self.g, self.b, self.a = self:GetTextColor()
        end
        self:SetTextColor(1, 1, 0, 1) -- 悬停时变为纯黄色
    end)
    cmd:SetScript("OnLeave", function(self)
        if self.r then
            self:SetTextColor(self.r, self.g, self.b, self.a)
        end
    end)

    -- 5. 底部信息
	local footer = f:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
    footer:SetPoint("BOTTOM", 0, 20)
    footer:SetText("curseforge.com/wow/addons/smartfocus")
    footer:SetScale(1.2)

    local pTex = f:CreateTexture(nil, "BACKGROUND")
    pTex:SetAllPoints()
    pTex:SetTexture("Interface\\COMMON\\ShadowControl")
    pTex:SetAlpha(0.2)
    pTex:SetTexCoord(0, 1, 1, 0)

    -- 6. 注册面板
    local category = Settings.RegisterCanvasLayoutCategory(f, "SmartFocus")
    Settings.RegisterAddOnCategory(category)
    
    self.frame = f
    self.category = category
end