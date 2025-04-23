local addonName, addonTable = ...
local ns = _G.KhiroksyUI_NS
local KhiroksyUI = ns.KhiroksyUI
local RaidFrames = KhiroksyUI.RaidFrames

---------------------------------------------------------------
-- Settings
---------------------------------------------------------------
RaidFrames.Defaults = {
    width = 256,
    height = 32,
    spacing = 8,
}

---------------------------------------------------------------
-- Create Raid Frame Style
---------------------------------------------------------------
function RaidFrames:CreateRaidFrame(frame, unit)
    frame:SetSize(self:GetSetting("width"), self:GetSetting("height"))

    -- Container
    local container = self:CreateContainerFrame(frame)
    container:SetPoint("TOPLEFT", frame, "TOPLEFT", -1, 1)
    container:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 1, -1)
    container:SetFrameLevel(frame:GetFrameLevel() + 3)
    frame.Container = container

    -- Health Holder
    local healthHolder = CreateFrame("Frame", nil, container)
    healthHolder:SetPoint("TOPLEFT", container, "TOPLEFT", 2, -2)
    healthHolder:SetPoint("BOTTOMRIGHT", container, "BOTTOMRIGHT", -2, 2)
    healthHolder:SetFrameLevel(container:GetFrameLevel() - 2)
    frame.HealthHolder = healthHolder

    -- Health Elements
    frame.HealthBackground = self:CreateHealthBackground(healthHolder)
    frame.HealthLoss = self:CreateHealthLossBar(healthHolder)
    frame.Health = self:CreateHealthBar(healthHolder)

    -- Smooth Health Animation
    self:SetupSmoothHealth(frame)

    -- Role Icon and Level
    frame.GroupRoleIndicator = self:CreateRoleIcon(container)
    frame.LevelText = self:CreateLevelText(container, frame.GroupRoleIndicator)

    -- Name and Health Text
    frame.Name = self:CreateNameText(container, frame.GroupRoleIndicator)
    frame:Tag(frame.Name, "[name]")

    frame.HealthText = self:CreateHealthText(container)
    frame:Tag(frame.HealthText, "[khiroksyui:health]")

    -- Ready Check
    frame.ReadyCheckIndicator = self:CreateReadyCheck(container)
    self:SetupReadyCheck(frame)

    -- Role Icon behavior
    self:SetupRoleIcon(frame)

    -- Range Fade
    frame.Range = {
        insideAlpha = 1,
        outsideAlpha = 0.55,
    }
end

---------------------------------------------------------------
-- Smooth Health Animation Setup
---------------------------------------------------------------
function RaidFrames:SetupSmoothHealth(frame)
    local animationDelay = 0.5
    local animationSpeed = 0.5

    frame.Health.PostUpdate = function(health, unit, cur, max)
        if not frame or not frame.HealthLoss or not unit then return end
        if not UnitIsConnected(unit) then return end
        if not cur or not max or max == 0 then return end

        local curPerc = cur / max
        health:SetMinMaxValues(0, 1)
        health:SetValue(curPerc)

        if frame.HealthLoss:GetValue() <= curPerc then
            frame.HealthLoss:SetValue(curPerc)
            frame.HealthLoss:SetScript("OnUpdate", nil)
            return
        end

        local elapsed = 0
        frame.HealthLoss:SetScript("OnUpdate", function(_, delta)
            elapsed = elapsed + delta

            if elapsed < animationDelay then
                return
            end

            local lossValue = frame.HealthLoss:GetValue()
            local shrinkAmount = delta / animationSpeed
            lossValue = math.max(lossValue - shrinkAmount, curPerc)

            frame.HealthLoss:SetValue(lossValue)

            if lossValue <= curPerc then
                frame.HealthLoss:SetValue(curPerc)
                frame.HealthLoss:SetScript("OnUpdate", nil)
            end
        end)
    end
end

---------------------------------------------------------------
-- Ready Check Setup
---------------------------------------------------------------
function RaidFrames:SetupReadyCheck(frame)
    frame.ReadyCheckIndicator.PostUpdate = function(readyCheck, unit, status)
        if not status then
            C_Timer.After(2, function()
                if readyCheck:IsVisible() then
                    RaidFrames:FadeOut(readyCheck, 1)
                end
            end)
        end
    end
end

---------------------------------------------------------------
-- Role Icon Setup
---------------------------------------------------------------
function RaidFrames:SetupRoleIcon(frame)
    frame.GroupRoleIndicator.PostUpdate = function(roleIcon, role)
        local unit = roleIcon:GetParent().unit
        if role == nil or role == "" or role == "NONE" then
            roleIcon:Hide()
            if unit and UnitExists(unit) then
                local level = UnitLevel(unit)
                frame.LevelText:SetText(level)
                frame.LevelText:Show()
            end
        else
            roleIcon:Show()
            frame.LevelText:Hide()

            if role == "TANK" then
                roleIcon:SetAtlas("roleicon-tiny-tank")
            elseif role == "HEALER" then
                roleIcon:SetAtlas("roleicon-tiny-healer")
            elseif role == "DAMAGER" then
                roleIcon:SetAtlas("roleicon-tiny-dps")
            else
                roleIcon:SetTexture(nil)
            end

            roleIcon:SetTexCoord(0, 1, 0, 1)
        end
    end
end