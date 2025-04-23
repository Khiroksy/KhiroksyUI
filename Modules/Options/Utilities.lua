local addonName, addonTable = ...
local ns = _G.KhiroksyUI_NS
local KhiroksyUI = ns.KhiroksyUI

KhiroksyUI.Options = KhiroksyUI.Options or {}
local Options = KhiroksyUI.Options

Options.Utilities = Options.Utilities or {}
local Utilities = Options.Utilities

---------------------------------------------------------------
-- Create a Standardized Slider
---------------------------------------------------------------
function Utilities:CreateSlider(parent, name, label, minVal, maxVal, step)
    local slider = CreateFrame("Slider", name, parent, "OptionsSliderTemplate")
    slider:SetMinMaxValues(minVal, maxVal)
    slider:SetValueStep(step)
    slider:SetObeyStepOnDrag(true)
    slider:SetWidth(200)

    -- Main label above
    slider.Text = slider:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    slider.Text:SetPoint("BOTTOM", slider, "TOP", 0, 4)
    slider.Text:SetText(label)

    -- Current value label below
    slider.ValueLabel = slider:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    slider.ValueLabel:SetPoint("TOP", slider, "BOTTOM", 0, -4)
    slider.ValueLabel:SetText("")

    return slider
end

---------------------------------------------------------------
-- Setup Saved Values and Auto Apply with Debounce
---------------------------------------------------------------
function Utilities:SetupSliderInitialization(sliders, dbTable, raidFramesModule)
    for key, slider in pairs(sliders) do
        if slider then
            local savedValue = dbTable[key] or (raidFramesModule.Defaults and raidFramesModule.Defaults[key]) or 0
            slider:SetValue(savedValue)
            if slider.ValueLabel then
                slider.ValueLabel:SetText(string.format("%.0f", savedValue))
            end

            slider:HookScript("OnValueChanged", function(self)
                local value = self:GetValue()
                dbTable[key] = value

                if self.ValueLabel then
                    self.ValueLabel:SetText(string.format("%.0f", value))
                end

                -- Debounced Rebuild
                if self.rebuildTimer then
                    self.rebuildTimer:Cancel()
                end
                self.rebuildTimer = C_Timer.NewTimer(0.5, function()
                    if raidFramesModule and raidFramesModule.RebuildRaidFrames then
                        raidFramesModule:RebuildRaidFrames()
                    end
                end)
            end)
        end
    end
end
