local addonName, addonTable = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

-- 创建安全按钮
local focusBtn = CreateFrame("Button", "SmartFocusClickButton", UIParent, "SecureActionButtonTemplate, BackdropTemplate")
SmartFocus.focusBtn = focusBtn

focusBtn:SetSize(150, 40)
focusBtn:SetFrameStrata("MEDIUM")
focusBtn:SetClampedToScreen(true)
focusBtn:SetAlpha(0)
focusBtn:Hide()

-- 样式美化
focusBtn:SetBackdrop({
    bgFile = "Interface\\Buttons\\WHITE8X8",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
focusBtn:SetBackdropColor(0, 0, 0, 0.8)

focusBtn.Text = focusBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
focusBtn.Text:SetPoint("CENTER")

-- 公开方法：更新位置
function SmartFocus:UpdateButtonPosition()
    local pos = self.db.profile.buttonPos
    focusBtn:ClearAllPoints()
    focusBtn:SetPoint("CENTER", UIParent, "CENTER", pos.x, pos.y)
end

-- 公开方法：显示按钮
function SmartFocus:ShowFocusButton(unit)
    if InCombatLockdown() or UnitExists("focus") then return end
    
    local name = GetUnitName(unit, true)
    if not name then return end

    -- 安全动作
    focusBtn:SetAttribute("type1", "macro")
    focusBtn:SetAttribute("macrotext1", "/focus " .. name)
    
    -- 文本与自适应宽度
    focusBtn.Text:SetText(string.format("|cff00ff00%s:|r %s", L["FOCUS_SET"], name))
    local textWidth = focusBtn.Text:GetUnboundedStringWidth()
    focusBtn:SetWidth(math.max(160, textWidth + 40))
    
    -- 显示与定时器
    focusBtn:Show()
    focusBtn:SetAlpha(0.7)
    
    if focusBtn.hideTimer then focusBtn.hideTimer:Cancel() end
    focusBtn.hideTimer = C_Timer.NewTimer(15, function()
        if not InCombatLockdown() then focusBtn:Hide() end
    end)
end