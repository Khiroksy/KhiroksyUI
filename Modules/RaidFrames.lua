local addonName, addonTable = ...
local ns = _G.KhiroksyUI_NS
local KhiroksyUI = ns.KhiroksyUI

local oUF = _G.oUF
local RaidFrames = KhiroksyUI.RaidFrames or {}
KhiroksyUI.RaidFrames = RaidFrames

---------------------------------------------------------------
-- Default Settings
---------------------------------------------------------------
RaidFrames.Defaults = {
    width = 256,
    height = 32,
    spacing = 8,
}

---------------------------------------------------------------
-- Settings Helper
---------------------------------------------------------------
function RaidFrames:GetSetting(key)
    KhiroksyUI_DB = KhiroksyUI_DB or {}
    KhiroksyUI_DB.RaidFrames = KhiroksyUI_DB.RaidFrames or {}

    local db = KhiroksyUI_DB.RaidFrames
    local defaults = self.Defaults

    return db[key] or defaults[key]
end

---------------------------------------------------------------
-- Module Initialization
---------------------------------------------------------------
function RaidFrames:Init()
    if not oUF then
        print("KhiroksyUI: oUF not available.")
        return
    end

    -- ✅ Register custom tags FIRST before creating frames
    oUF.Tags.Events["khiroksyui:health"] = "UNIT_HEALTH UNIT_MAXHEALTH"
    oUF.Tags.Methods["khiroksyui:health"] = function(unit)
        return RaidFrames:FormatHealth(unit)
    end

    -- ✅ Now it's safe to create frames
    self:RebuildRaidFrames()
end

-- ✅ Module registration
KhiroksyUI.Modules.RaidFrames = RaidFrames