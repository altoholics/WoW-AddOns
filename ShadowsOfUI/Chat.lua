local _, ns = ...
local Class, UIParent = ns.lua.Class, ns.wowui.UIParent
local ui = ns.ui
local Frame = ui.Frame
local ChatTypeInfo = ChatTypeInfo -- luacheck: globals ChatTypeInfo
local strsplit = strsplit -- luacheck: globals strsplit
local strf = string.format
local Ambiguate = Ambiguate -- luacheck: globals Ambiguate
local PlayerLocation, C_PlayerInfo, C_ClassColor = PlayerLocation, C_PlayerInfo, C_ClassColor -- luacheck: globals PlayerLocation C_PlayerInfo C_ClassColor

-- luacheck: globals ChatFontNormal CreateFont
local file, _, flags = ChatFontNormal:GetFont()
local chatFont = CreateFont("ShadowChatFont")
chatFont:SetFont(file, 18, flags)
chatFont:SetJustifyH("LEFT")
chatFont:SetShadowColor(0, 0, 0, 0.5)
chatFont:SetShadowOffset(2, -2)

-- https://github.com/Gethe/wow-ui-source/blob/5076663b5454de9e7522320994ea7cc15b2a961c/Interface/AddOns/Blizzard_ChatFrameBase/Mainline/ChatFrame.lua
local MessageFrame = Class(Frame, function(self)
  self._widget:SetFontObject(chatFont)
  self._widget:SetTimeVisible(60)
  self._widget:SetSpacing(3)
  self._widget:SetHyperlinksEnabled(true)
end, {
  type = "ScrollingMessageFrame",
})

-- https://wowpedia.fandom.com/wiki/ChatTypeInfo
local Chat = Class(MessageFrame, function(self)
end, {
  parent = UIParent,
  name = "ShadowUIChat",
  position = {
    BottomLeft = {20, 20},
    Width = 800,
    Height = 300,
  },
  events = {
    -- "CHAT_MSG_ADDON",
    -- "CHAT_MSG_ADDON_LOGGED",
    -- "CHAT_MSG_AFK",
    -- "CHAT_MSG_CHANNEL",
    "CHAT_MSG_EMOTE",
    "CHAT_MSG_GUILD",
    -- "CHAT_MSG_GUILD_ACHIEVEMENT",
    -- "CHAT_MSG_IGNORED",
    "CHAT_MSG_INSTANCE_CHAT",
    "CHAT_MSG_INSTANCE_CHAT_LEADER",
    "CHAT_MSG_MONSTER_EMOTE",
    "CHAT_MSG_MONSTER_PARTY",
    "CHAT_MSG_MONSTER_SAY",
    "CHAT_MSG_MONSTER_WHISPER",
    "CHAT_MSG_MONSTER_YELL",
    "CHAT_MSG_OFFICER",
    "CHAT_MSG_PARTY",
    "CHAT_MSG_PARTY_LEADER",
    "CHAT_MSG_RAID",
    "CHAT_MSG_RAID_BOSS_EMOTE", -- "RAID_BOSS_EMOTE",
    "CHAT_MSG_RAID_BOSS_WHISPER", -- "RAID_BOSS_WHISPER",
    "CHAT_MSG_RAID_LEADER",
    "CHAT_MSG_RAID_WARNING",
    "CHAT_MSG_SAY",
    "CHAT_MSG_SYSTEM",
    "CHAT_MSG_TEXT_EMOTE",
    "CHAT_MSG_WHISPER",
    "CHAT_MSG_WHISPER_INFORM",
    "CHAT_MSG_YELL",
    -- "UPDATE_CHAT_WINDOWS", -- Fired on load when chat settings are available for chat windows.
  },
  scripts = {
    "OnHyperlinkClick"
  },
})
ns.Chat = Chat

local GameTooltip_SetDefaultAnchor, ItemRefTooltip = GameTooltip_SetDefaultAnchor, ItemRefTooltip -- luacheck: globals GameTooltip_SetDefaultAnchor ItemRefTooltip
function Chat:OnHyperlinkClick(_, link)
  local linkType, cmd, arg1 = strsplit(":", link) -- item,
  if linkType == "ShadowUI" then
    if "player" == cmd then
      if ns.command then
        ns.command:UpdateChannelDisplay("SMART_WHISPER", nil, nil, arg1, Ambiguate(arg1, "short"))
        ns.command:Show()
      end
    end
  elseif "item" == linkType then
    GameTooltip_SetDefaultAnchor(ItemRefTooltip, UIParent)
    ItemRefTooltip:ItemRefSetHyperlink(link)
    ItemRefTooltip:Show()
  else
    print(link)
  end
end

local ChannelStrings = {
  EMOTE = "%s %s",
  INSTANCE = "[Instance] %s: %s",
  INSTANCE_LEADER = "[Instance] %s: %s",
  PARTY = "[Party] %s: %s",
  PARTY_LEADER = "[Party] %s: %s",
  GUILD = "[Guild] %s: %s",
  MONSTER_EMOTE = "%s %s",
  MONSTER_SAY = "%s says: %s",
  MONSTER_YELL = "%s yells: %s",
  MONSTER_WHISPER = "%s whispers: %s",
  RAID = "[Raid] %s: %s",
  RAID_LEADER = "[Raid] %s: %s",
  RAID_BOSS_EMOTE = "%s %s",
  RAID_BOSS_WHISPER = "%s whispers: %s",
  SAY = "%s says: %s",
  WHISPER = "%s whispers: %s",
  WHISPER_INFORM = "To %s: %s",
  YELL = "%s yells: %s",
}

function Chat:AddChannelMessage(channel, text, player)
  local info = ChatTypeInfo[channel] or {r = 1, g = 1, b = 1}
  self._widget:AddMessage(strf(ChannelStrings[channel], player or text, text), info.r, info.g, info.b, info.id)
end

function Chat:HandlePlayerMessage(channel, text, player, ...)
  local lineId = select(9, ...)
  local pl = PlayerLocation:CreateFromChatLineID(lineId)
  local _, className = C_PlayerInfo.GetClass(pl)
  local color = C_ClassColor.GetClassColor(className):GenerateHexColor()
  local p = Ambiguate(player, "short")
  self:AddChannelMessage(channel, text, "|c"..color.."|HShadowUI:player:["..player.."]|h"..p.."|h|r")
end

function Chat:CHAT_MSG_EMOTE(...) self:HandlePlayerMessage("EMOTE", ...) end
function Chat:CHAT_MSG_INSTANCE_CHAT(...) self:HandlePlayerMessage("INSTANCE", ...) end
function Chat:CHAT_MSG_INSTANCE_CHAT_LEADER(...) self:HandlePlayerMessage("INSTANCE_LEADER", ...) end
function Chat:CHAT_MSG_PARTY(...) self:HandlePlayerMessage("PARTY", ...) end
function Chat:CHAT_MSG_PARTY_LEADER(...) self:HandlePlayerMessage("PARTY_LEADER", ...) end
function Chat:CHAT_MSG_GUILD(...) self:HandlePlayerMessage("GUILD", ...) end
function Chat:CHAT_MSG_RAID(...) self:HandlePlayerMessage("RAID", ...) end
function Chat:CHAT_MSG_RAID_LEADER(...) self:HandlePlayerMessage("RAID_LEADER", ...) end
function Chat:CHAT_MSG_SAY(...) self:HandlePlayerMessage("SAY", ...) end
function Chat:CHAT_MSG_WHISPER(...)
  if select(5, ...) == "" then print("whisper no target", select(1, ...)) end
  self:HandlePlayerMessage("WHISPER", ...)
end
function Chat:CHAT_MSG_WHISPER_INFORM(...) self:HandlePlayerMessage("WHISPER_INFORM", ...) end
function Chat:CHAT_MSG_YELL(...) self:HandlePlayerMessage("YELL", ...) end

function Chat:CHAT_MSG_MONSTER_SAY(text, player) self:AddChannelMessage("MONSTER_SAY", text, player) end
function Chat:CHAT_MSG_MONSTER_YELL(text, player) self:AddChannelMessage("MONSTER_YELL", text, player) end
function Chat:CHAT_MSG_MONSTER_EMOTE(text, player) self:AddChannelMessage("MONSTER_EMOTE", text, player) end
function Chat:CHAT_MSG_MONSTER_WHISPER(text, player) self:AddChannelMessage("MONSTER_WHISPER", text, nil) end
function Chat:CHAT_MSG_RAID_BOSS_EMOTE(text, player) self:AddChannelMessage("RAID_BOSS_EMOTE", text, player) end
function Chat:CHAT_MSG_RAID_BOSS_WHISPER(text, player) self:AddChannelMessage("RAID_BOSS_WHISPER", text, player) end
