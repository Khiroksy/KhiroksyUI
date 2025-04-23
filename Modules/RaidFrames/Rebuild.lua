local addonName, addonTable = ...
local ns = _G.KhiroksyUI_NS
local KhiroksyUI = ns.KhiroksyUI

local oUF = _G.oUF
local RaidFrames = KhiroksyUI.RaidFrames

---------------------------------------------------------------
-- Safely Rebuild Raid Frames
---------------------------------------------------------------
function RaidFrames:RebuildRaidFrames()
    if not oUF then
        print("KhiroksyUI: oUF not available.")
        return
    end

    -- Defer if in combat lockdown
    if InCombatLockdown() then
        if not self.rebuildPending then
            self.rebuildPending = true
            local f = CreateFrame("Frame")
            f:RegisterEvent("PLAYER_REGEN_ENABLED")
            f:SetScript("OnEvent", function(selfEventFrame)
                selfEventFrame:UnregisterAllEvents()
                RaidFrames.rebuildPending = false
                RaidFrames:RebuildRaidFrames()
            end)
        end
        return
    end

    -- Clean up old header
    if self.header and self.header:IsVisible() then
        self.header:Hide()
    end
    if self.header then
        self.header:UnregisterAllEvents()
        self.header:SetParent(nil)
        self.header = nil
    end

    -- Only register the style once
    if not RaidFrames.styleRegistered then
        oUF:RegisterStyle("KhiroksyUI_Raid", function(frame, unit)
            RaidFrames:CreateRaidFrame(frame, unit)
        end)
        RaidFrames.styleRegistered = true
    end

    oUF:SetActiveStyle("KhiroksyUI_Raid")

    local db = KhiroksyUI_DB.RaidFrames or {}
    local width = db.width or self.Defaults.width
    local height = db.height or self.Defaults.height
    local spacing = db.spacing or self.Defaults.spacing

    -- Spawn the new raid header
    local header = oUF:SpawnHeader(
        "KhiroksyUI_RaidHeader",
        nil,
        "solo,raid",
        "showSolo", true,
        "showParty", false,
        "showPlayer", true,
        "showRaid", true,
        "sortMethod", "INDEX",
        "unitsPerColumn", 20,
        "maxColumns", 8,
        "columnSpacing", spacing,
        "point", "TOP",
        "columnAnchorPoint", "RIGHT",
        "xOffset", -spacing,
        "yOffset", -spacing,
        "initial-width", width,
        "initial-height", height
    )

    header:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 30, -30)

    self.header = header
end