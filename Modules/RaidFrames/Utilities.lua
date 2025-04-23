local addonName, addonTable = ...
local ns = _G.KhiroksyUI_NS
local KhiroksyUI = ns.KhiroksyUI

local RaidFrames = KhiroksyUI.RaidFrames

---------------------------------------------------------------
-- Utility Functions
---------------------------------------------------------------

function RaidFrames:CreateFont(parent, size, outline)
    local font = parent:CreateFontString(nil, "OVERLAY")
    font:SetFont("Fonts\\FRIZQT__.TTF", size or 12, outline or "OUTLINE")
    font:SetShadowOffset(1, -1)
    font:SetShadowColor(0, 0, 0, 1)
    font:SetTextColor(1, 1, 1)
    font:SetJustifyV("MIDDLE")
    font:SetWordWrap(false)
    return font
end

function RaidFrames:CreateStatusBar(parent, layer, width, height, texture)
    local bar = CreateFrame("StatusBar", nil, parent)
    bar:SetSize(width, height)
    bar:SetStatusBarTexture(texture or "Interface\\Buttons\\WHITE8x8")
    bar:SetMinMaxValues(0, 1)
    bar:SetValue(1)
    bar:SetFrameLevel(parent:GetFrameLevel() + (layer or 0))
    return bar
end

function RaidFrames:CreateTexture(parent, layer, sublayer, texturePath)
    local tex = parent:CreateTexture(nil, layer or "ARTWORK", nil, sublayer or 0)
    tex:SetTexture(texturePath or "Interface\\Buttons\\WHITE8x8")
    return tex
end

function RaidFrames:CreateContainerFrame(parent)
    local frame = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    frame:SetBackdrop({
        bgFile = nil,
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    frame:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
    return frame
end

function RaidFrames:FadeOut(texture, duration)
    if not texture then return end
    duration = duration or 1

    local elapsed = 0
    texture:SetScript("OnUpdate", function(_, delta)
        elapsed = elapsed + delta
        local alpha = 1 - (elapsed / duration)
        if alpha <= 0 then
            texture:SetAlpha(0)
            texture:SetScript("OnUpdate", nil)
            texture:Hide()
        else
            texture:SetAlpha(alpha)
        end
    end)
end

---------------------------------------------------------------
-- Health Formatting Helper
---------------------------------------------------------------
function RaidFrames:FormatHealth(unit)
    local cur = UnitHealth(unit)
    local max = UnitHealthMax(unit)

    if max == 0 then return "" end

    local perc = math.floor((cur / max) * 100)
    local function Shorten(value)
        if value >= 1e9 then
            return string.format("%.1fB", value / 1e9)
        elseif value >= 1e6 then
            return string.format("%.1fM", value / 1e6)
        elseif value >= 1e3 then
            return string.format("%.0fk", value / 1e3)
        else
            return tostring(value)
        end
    end

    return string.format("%d%% | %s", perc, Shorten(cur))
end