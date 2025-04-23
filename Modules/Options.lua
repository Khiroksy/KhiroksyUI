local addonName, addonTable = ...
local ns = _G.KhiroksyUI_NS
local KhiroksyUI = ns.KhiroksyUI

-- Safely initialize options table
KhiroksyUI.Options = KhiroksyUI.Options or {}
local Options = KhiroksyUI.Options

Options.SubPanels = Options.SubPanels or {}

---------------------------------------------------------------
-- Factory to Create Main Panel
---------------------------------------------------------------
local function CreateMainPanel()
    local frame = CreateFrame("Frame", nil, UIParent)
    frame.name = "KhiroksyUI"

    local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("KhiroksyUI - General Settings")

    return frame
end

---------------------------------------------------------------
-- Register All Options
---------------------------------------------------------------
function Options:Register()
    local mainPanel = CreateMainPanel()
    local category = Settings.RegisterCanvasLayoutCategory(mainPanel, "KhiroksyUI")

    -- Register all subpanels
    for _, createSubPanel in ipairs(Options.SubPanels) do
        createSubPanel(category)
    end

    Settings.RegisterAddOnCategory(category)
end