local _, ns = ...
local Class, UIParent = ns.lua.Class, ns.wowui.UIParent
local ui = ns.ui
local Frame = ui.Frame
local ChatTypeInfo = ChatTypeInfo -- luacheck: globals ChatTypeInfo
local strsplit = strsplit -- luacheck: globals strsplit

-- luacheck: globals ChatFontNormal CreateFont
local file, _, flags = ChatFontNormal:GetFont()
local chatFont = CreateFont("ShadowChatFont")
chatFont:SetFont(file, 18, flags)
chatFont:SetJustifyH("LEFT")
chatFont:SetShadowColor(0, 0, 0, 0.5)
chatFont:SetShadowOffset(2, -2)

-- https://github.com/Gethe/wow-ui-source/blob/5076663b5454de9e7522320994ea7cc15b2a961c/Interface/AddOns/Blizzard_ChatFrameBase/Mainline/ChatFrame.lua
local MessageFrame = Class(Frame, function(self)
  self.frame:SetFontObject(chatFont)
  self.frame:SetTimeVisible(60)
  self.frame:SetSpacing(3)
  -- self.frame:EnableMouse(true)
  -- self.frame:SetMouseClickEnabled(true)
  -- self.frame:EnableMouseWheel(true)
  self.frame:SetHyperlinksEnabled(true)
  -- self.frame:SetFading(false)

  -- for i=1,10 do self.frame:AddMessage("sample line of text "..i, 1, 1, 1) end
end, {
  type = "ScrollingMessageFrame",
})

-- https://wowpedia.fandom.com/wiki/ChatTypeInfo
local Chat = Class(MessageFrame, function(self)
end, {
  parent = UIParent,
  name = "ShadowUIChat",
  position = {
    bottomLeft = {20, 20},
    width = 800,
    height = 300,
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

function Chat:OnHyperlinkClick(_, link)
  local linkType, cmd, arg1 = strsplit(":", link) -- item,
  if linkType == "item" then
    -- show item tooltip
  elseif linkType == "ShadowUI" then
    -- handle
    print(cmd, arg1)
    if "player" == cmd then
      -- set whisper target, open command
    end
  end
end

local ChannelStrings = {
  EMOTE = "%s %s",
  INSTANCE = "[Instance] %s: %s",
  PARTY = "[Party] %s: %s",
  GUILD = "[Guild] %s: %s",
  MONSTER_EMOTE = "%s %s",
  MONSTER_SAY = "%s says: %s",
  MONSTER_YELL = "%s yells: %s",
  RAID = "[Raid] %s: %s",
  SAY = "%s says: %s",
  YELL = "%s yells: %s",
}

local strf = string.format
function Chat:AddChannelMessage(channel, text, player)
  local info = ChatTypeInfo[channel]
  self.frame:AddMessage(strf(ChannelStrings[channel], player, text), info.r, info.g, info.b, info.id)
end

local function linkPlayer(player)
  return "[|cff1eff00|HShadowUI:player:"..player.."|h"..player.."|h|r]"
end

function Chat:CHAT_MSG_EMOTE(text, player) self:AddChannelMessage("EMOTE", text, linkPlayer(player)) end
function Chat:CHAT_MSG_INSTANCE_CHAT(text, player) self:AddChannelMessage("INSTANCE", text, linkPlayer(player)) end
function Chat:CHAT_MSG_PARTY(text, player) self:AddChannelMessage("PARTY", text, linkPlayer(player)) end
function Chat:CHAT_MSG_GUILD(text, player) self:AddChannelMessage("GUILD", text, linkPlayer(player)) end
function Chat:CHAT_MSG_RAID(text, player) self:AddChannelMessage("RAID", text, linkPlayer(player)) end
function Chat:CHAT_MSG_SAY(text, player) self:AddChannelMessage("SAY", text, linkPlayer(player)) end
function Chat:CHAT_MSG_YELL(text, player) self:AddChannelMessage("YELL", text, linkPlayer(player)) end
function Chat:CHAT_MSG_MONSTER_SAY(text, player) self:AddChannelMessage("MONSTER_SAY", text, player) end
function Chat:CHAT_MSG_MONSTER_YELL(text, player) self:AddChannelMessage("MONSTER_YELL", text, player) end
function Chat:CHAT_MSG_MONSTER_EMOTE(text, player) self:AddChannelMessage("MONSTER_EMOTE", text, player) end
