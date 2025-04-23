local addonName, addonTable = ...
local ns = _G.KhiroksyUI_NS
local KhiroksyUI = ns.KhiroksyUI
local RaidFrames = KhiroksyUI.RaidFrames

---------------------------------------------------------------
-- Frame Elements Building
---------------------------------------------------------------

function RaidFrames:CreateHealthBackground(parent)
    local bg = self:CreateTexture(parent, "BACKGROUND", -8, "Interface\\Buttons\\WHITE8x8")
    bg:SetAllPoints(parent)
    bg:SetVertexColor(0, 0, 0, 0.7)
    return bg
end

function RaidFrames:CreateHealthLossBar(parent)
    local loss = self:CreateStatusBar(parent, -1, parent:GetWidth(), parent:GetHeight())
    loss:SetAllPoints(parent)
    loss:SetStatusBarColor(1, 0.1, 0.1, 0.75)
    return loss
end

function RaidFrames:CreateHealthBar(parent)
    local health = self:CreateStatusBar(parent, 0, parent:GetWidth(), parent:GetHeight())
    health:SetAllPoints(parent)
    health.colorClass = true
    health.colorDisconnected = true
    health.colorReaction = true
    return health
end

function RaidFrames:CreateRoleIcon(parent)
    local icon = self:CreateTexture(parent, "OVERLAY", 5)
    icon:SetSize(16, 16)
    icon:SetPoint("LEFT", parent, "LEFT", 4, 0)
    return icon
end

function RaidFrames:CreateLevelText(parent, anchorTo)
    local text = self:CreateFont(parent, 11)
    text:SetPoint("CENTER", anchorTo, "CENTER", 0, 0)
    text:Hide()
    return text
end

function RaidFrames:CreateNameText(parent, anchorTo)
    local text = self:CreateFont(parent, 12)
    text:SetPoint("LEFT", anchorTo, "RIGHT", 4, 0)
    text:SetPoint("RIGHT", parent, "CENTER", -2, 0)
    text:SetJustifyH("LEFT")
    return text
end

function RaidFrames:CreateHealthText(parent)
    local text = self:CreateFont(parent, 12)
    text:SetPoint("RIGHT", parent, "RIGHT", -4, 0)
    text:SetJustifyH("RIGHT")
    return text
end

function RaidFrames:CreateReadyCheck(parent)
    local rc = self:CreateTexture(parent, "OVERLAY", 7)
    rc:SetSize(20, 20)
    rc:SetPoint("CENTER", parent, "CENTER", 0, 0)
    return rc
end