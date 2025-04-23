local addonName, addonTable = ...
local ns = _G.KhiroksyUI_NS or {}
_G.KhiroksyUI_NS = ns

ns.KhiroksyUI = ns.KhiroksyUI or {}
local KhiroksyUI = ns.KhiroksyUI

KhiroksyUI.Modules = KhiroksyUI.Modules or {}
KhiroksyUI.DB = KhiroksyUI.DB or {}

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(_, _, addon)
    if addon ~= addonName then return end

    KhiroksyUI_DB = KhiroksyUI_DB or {}
    KhiroksyUI.DB = KhiroksyUI_DB

    for name, mod in pairs(KhiroksyUI.Modules) do
        if type(mod.Init) == "function" then
            mod:Init()
        end
    end

    if KhiroksyUI.Options and type(KhiroksyUI.Options.Register) == "function" then
        if C_AddOns.IsAddOnLoaded("Blizzard_Settings") then
            KhiroksyUI.Options:Register()
        else
            local waitFrame = CreateFrame("Frame")
            waitFrame:RegisterEvent("ADDON_LOADED")
            waitFrame:SetScript("OnEvent", function(_, _, subAddon)
                if subAddon == "Blizzard_Settings" then
                KhiroksyUI.Options:Register()
                    waitFrame:UnregisterAllEvents()
            end
        end)
        end
    end
end)