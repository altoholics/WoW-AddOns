local _, ns = ...
local Class, UIParent = ns.lua.Class, ns.wowui.UIParent
local ui = ns.ui
local Frame = ui.Frame
-- luacheck: globals ChatFontNormal CreateFont

-- https://github.com/Gethe/wow-ui-source/blob/5076663b5454de9e7522320994ea7cc15b2a961c/Interface/AddOns/Blizzard_ChatFrameBase/Mainline/ChatFrame.lua
local MessageFrame = Class(Frame, function(self)
end, {
  parent = UIParent,
  type = "MessageFrame",
  name = "ShadowUIChat",
  position = {
    bottomLeft = {5, 12},
    width = 600,
    height = 400,
  },
})

-- https://wowpedia.fandom.com/wiki/ChatTypeInfo
local Chat = Class(MessageFrame, function(self)
end, {
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
    "CHAT_MSG_MOSNTER_SAY",
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
})
ns.Chat = Chat
