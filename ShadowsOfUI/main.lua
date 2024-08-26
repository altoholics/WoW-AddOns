local _, ns = ...

local ui = LibNUI
local StatusBar = ui.StatusBar
local Background = ui.layer.Background
local BottomLeft, BottomRight = ui.edge.BottomLeft, ui.edge.BottomRight

local UnitLevel, UnitXP, UnitXPMax = UnitLevel, UnitXP, UnitXPMax
local StatusTrackingBarManager = StatusTrackingBarManager

-- default xp bar: https://github.com/Gethe/wow-ui-source/blob/c0f3b4f1794953ba72fa3bc5cd25a6f2cdd696a1/Interface/AddOns/Blizzard_ActionBar/Mainline/ExpBar.lua

-- https://github.com/teelolws/EditModeExpanded

local function GetPlayerLevelXP()
    local level = UnitLevel("player")
    local currentXP = UnitXP("player")
    local maxXP = UnitXPMax("player")
    return level, currentXP, maxXP
end

local ExpBar = StatusBar:new{
    parent = UIParent,
    position = {
        height = 11,
        bottomLeft = {},
        bottomRight = {}
    },
    events = {"PLAYER_ENTERING_WORLD", "PLAYER_XP_UPDATE", "PLAYER_LEVEL_UP", "UPDATE_EXHAUSTION", "PLAYER_UPDATE_RESTING"},
    fillColor = {0, 1, 0}
}

function ExpBar:update()
    
end

function ExpBar:PLAYER_ENTERING_WORLD() self:update() end
function ExpBar:PLAYER_XP_UPDATE() self:update() end
function ExpBar:PLAYER_LEVEL_UP() end
function ExpBar:UPDATE_EXHAUSTION() end
function ExpBar:PLAYER_UPDATE_RESTING() end

-- function xp:update()
--     local level, currentXP, maxXP = GetPlayerLevelXP()
--     print(level, currentXP, maxXP)

--     if currentXP ~= nil then
--         self.frame:SetMinMaxValues(0, maxXP)
--         self.frame:SetValue(currentXP)
--     end
-- end


-- xp.frame:SetStatusBarColor(170/255, 10/255, 10/255)
-- xp.frame:SetColorFill(0, 1, 0)


-- hide the default blizzard frame
local f = CreateFrame("Frame")
function f:OnEvent(event, ...)
    if self[event] then
        self[event](self, event, ...)
    end
end
f:SetScript("OnEvent", f.OnEvent)

function f:PLAYER_ENTERING_WORLD(event, name, login, reload)
    if login or reload then
        -- print(StatusTrackingBarManager, StatusTrackingBarManager:IsVisible())
        -- print(MainStatusTrackingBarContainer, MainStatusTrackingBarContainer:IsVisible())
        StatusTrackingBarManager:Hide()
    end
end
f:RegisterEvent("PLAYER_ENTERING_WORLD")

