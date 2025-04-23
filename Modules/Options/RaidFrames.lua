local addonName, addonTable = ...
local ns = _G.KhiroksyUI_NS
local KhiroksyUI = ns.KhiroksyUI

local Options = KhiroksyUI.Options
local Utilities = Options.Utilities
local RaidFrames = KhiroksyUI.RaidFrames

---------------------------------------------------------------
-- Create Raid Frames Options Panel
---------------------------------------------------------------
function Options:CreateRaidFramesPanel(parentCategory)
    local frame = CreateFrame("Frame", nil, UIParent)

    local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("Raid Frames Settings")

    ---------------------------------------------------------------
    -- Sliders
    ---------------------------------------------------------------
    local widthSlider = Utilities:CreateSlider(frame, "KhiroksyUI_RaidFramesWidthSlider", "Frame Width", 50, 400, 1)
    widthSlider:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -30)

    local heightSlider = Utilities:CreateSlider(frame, "KhiroksyUI_RaidFramesHeightSlider", "Frame Height", 20, 100, 1)
    heightSlider:SetPoint("TOPLEFT", widthSlider, "BOTTOMLEFT", 0, -50)

    local spacingSlider = Utilities:CreateSlider(frame, "KhiroksyUI_RaidFramesSpacingSlider", "Frame Spacing", 0, 20, 1)
    spacingSlider:SetPoint("TOPLEFT", heightSlider, "BOTTOMLEFT", 0, -50)

    ---------------------------------------------------------------
    -- Setup Initialization and Auto Save
    ---------------------------------------------------------------
    local sliders = {
        width = widthSlider,
        height = heightSlider,
        spacing = spacingSlider,
    }

    Utilities:SetupSliderInitialization(sliders, KhiroksyUI_DB.RaidFrames, RaidFrames)

    ---------------------------------------------------------------
    -- Register as Subcategory
    ---------------------------------------------------------------
    local subcategory = Settings.RegisterCanvasLayoutSubcategory(parentCategory, frame, "Raid Frames")
end

---------------------------------------------------------------
-- Safe Registration
---------------------------------------------------------------
Options.SubPanels = Options.SubPanels or {}
table.insert(Options.SubPanels, function(parentCategory)
    Options:CreateRaidFramesPanel(parentCategory)
end)