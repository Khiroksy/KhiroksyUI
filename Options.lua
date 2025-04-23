local addonName = ...
local categoryName = "KhiroksyUI"

local Defaults = {
    width = 160,
    height = 60,
    preview = false,
}

local widthSlider, heightSlider, previewCheckbox

---------------------------------------------------------------
-- Helpers
---------------------------------------------------------------
local function CreateSlider(parent, label, name, minVal, maxVal, step)
    local slider = CreateFrame("Slider", name, parent, "OptionsSliderTemplate")
    slider:SetMinMaxValues(minVal, maxVal)
    slider:SetValueStep(step)
    slider:SetObeyStepOnDrag(true)
    slider:SetWidth(200)

    -- Label above
    slider.Text = slider:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    slider.Text:SetPoint("BOTTOM", slider, "TOP", 0, 4)
    slider.Text:SetText(label)

    -- Value label below
    slider.ValueLabel = slider:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    slider.ValueLabel:SetPoint("TOP", slider, "BOTTOM", 0, -2)

    -- Min/Max values
    _G[name.."Low"]:SetText(tostring(minVal))
    _G[name.."High"]:SetText(tostring(maxVal))

    return slider
end

local function UpdateSliderLabels()
    local db = KhiroksyUI_DB.raidFrames
    widthSlider.ValueLabel:SetText(string.format("%.0f", db.width or Defaults.width))
    heightSlider.ValueLabel:SetText(string.format("%.0f", db.height or Defaults.height))
end

local function ApplySettings()
    local db = KhiroksyUI_DB.raidFrames
    db.width = widthSlider:GetValue()
    db.height = heightSlider:GetValue()
    db.preview = previewCheckbox:GetChecked()

    UpdateSliderLabels()

    if KhiroksyUI.Modules["Raid Frames Improvements"] then
        KhiroksyUI.Modules["Raid Frames Improvements"]:UpdateSettings()
    end
end

local function ResetToDefaults()
    local db = KhiroksyUI_DB.raidFrames

    db.width = Defaults.width
    db.height = Defaults.height
    db.preview = Defaults.preview

    widthSlider:SetValue(db.width)
    heightSlider:SetValue(db.height)
    previewCheckbox:SetChecked(db.preview)

    UpdateSliderLabels()

    if KhiroksyUI.Modules["Raid Frames Improvements"] then
        KhiroksyUI.Modules["Raid Frames Improvements"]:UpdateSettings()
    end
end

---------------------------------------------------------------
-- Main Panel Creation
---------------------------------------------------------------
local function CreateOptionsPanel()
    local frame = CreateFrame("Frame", nil, UIParent)
    frame.name = categoryName

    -- Title
    local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("KhiroksyUI: Raid Frames Improvements")

    -- Width Slider
    widthSlider = CreateSlider(frame, "Raid Frame Width", "KhiroksyUI_WidthSlider", 10, 500, 1)
    widthSlider:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -40)

    -- Height Slider
    heightSlider = CreateSlider(frame, "Raid Frame Height", "KhiroksyUI_HeightSlider", 10, 500, 1)
    heightSlider:SetPoint("TOPLEFT", widthSlider, "BOTTOMLEFT", 0, -40)

    -- Preview Mode Checkbox
    previewCheckbox = CreateFrame("CheckButton", "KhiroksyUI_PreviewCheckbox", frame, "InterfaceOptionsCheckButtonTemplate")
    previewCheckbox:SetPoint("TOPLEFT", heightSlider, "BOTTOMLEFT", 0, -40)
    previewCheckbox.Text:SetText("Enable Preview Mode")

    -- Reset to Defaults Button
    local resetButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    resetButton:SetSize(140, 24)
    resetButton:SetPoint("TOPLEFT", previewCheckbox, "BOTTOMLEFT", 0, -20)
    resetButton:SetText("Reset to Defaults")
    resetButton:SetScript("OnClick", ResetToDefaults)

    -- Load saved or default values
    local db = KhiroksyUI_DB.raidFrames or {}
    widthSlider:SetValue(db.width or Defaults.width)
    heightSlider:SetValue(db.height or Defaults.height)
    previewCheckbox:SetChecked(db.preview or Defaults.preview)
    UpdateSliderLabels()

    -- Event bindings
    widthSlider:SetScript("OnValueChanged", ApplySettings)
    heightSlider:SetScript("OnValueChanged", ApplySettings)
    previewCheckbox:SetScript("OnClick", ApplySettings)

    -- Register the panel
    local category = Settings.RegisterCanvasLayoutCategory(frame, categoryName)
    Settings.RegisterAddOnCategory(category)
end

---------------------------------------------------------------
-- Safe Load
---------------------------------------------------------------
local loaderFrame = CreateFrame("Frame")
loaderFrame:RegisterEvent("ADDON_LOADED")
loaderFrame:SetScript("OnEvent", function(_, _, arg1)
    if arg1 == addonName then
        KhiroksyUI_DB = KhiroksyUI_DB or {}
        KhiroksyUI_DB.raidFrames = KhiroksyUI_DB.raidFrames or {}

        CreateOptionsPanel()
    end
end)