local _, ns = ...
-- luacheck: globals ChatFontNormal CreateFont
local Class = ns.lua.Class
local ui = ns.ui
local Frame, CleanFrame, SecureButton = ui.Frame, ui.CleanFrame, ui.SecureButton

-- https://github.com/Gethe/wow-ui-source/blob/5076663b5454de9e7522320994ea7cc15b2a961c/Interface/AddOns/Blizzard_ChatFrameBase/Mainline/ChatFrame.lua

local file, _, flags = ChatFontNormal:GetFont()
local chatFont = CreateFont("ButtonKeybind")
chatFont:SetFont(file, 30, flags)

local EditBox = Class(CleanFrame, function(self)
  local f = self
  if self.autoFocus ~= nil then self.frame:SetAutoFocus(self.autoFocus); self.autoFocus = nil end
  self.frame:SetTextInsets(5, 5, 5, 5)

  -- invis button for custom keybind handler
  self.binder = SecureButton:new{
    parent = self,
    name = "$parentBinder",
    bindLeftClick = "ENTER",
    kbLabel = false,
    glow = false,
    position = {
      topRight = {self.frame, ui.edge.TopLeft},
    },
    onClick = function() if not f.frame:IsShown() then f:show() end end,
  }

  self.frame:SetFontObject(chatFont)
  self.frame:SetScript("OnEscapePressed", function() f:hide() end)
  self.frame:SetScript("OnEnterPressed", function()
    -- https://github.com/Gethe/wow-ui-source/blob/5076663b5454de9e7522320994ea7cc15b2a961c/Interface/AddOns/Blizzard_ChatFrameBase/Mainline/ChatFrame.lua#L5425
    local t = f.frame:GetText()
    if t ~= "" then
      local _, _, cmd, args = string.find(t, "(/?%w+) ?(.*)")
      -- https://wowpedia.fandom.com/wiki/API_SendChatMessage
      -- ConsoleExec -- same as /console <command>
      -- DoEmote
      if t == "/reload" then
        C_UI.Reload() -- luacheck: ignore
      elseif cmd == "/s" or cmd == "/say" then
        SendChatMessage(args, "SAY")
      elseif cmd == "/p" or cmd == "/party" then
        SendChatMessage(args, "PARTY")
      elseif cmd == "/sit" then
        DoEmote(string.sub(cmd, 2))
      end
    end
    f.frame:SetText("")
    f:hide()
  end)
end, {
  type = "EditBox",
  autoFocus = true,
})

local MessageFrame = Class(Frame, function(self)
end, {
  type = "MessageFrame",
})

local Command = Class(EditBox, function(self)end, {
  name = "ShadowsOfUI_Command",
  alpha = 0.8,
  background = {0, 0, 0, 0.8},
  position = {
    center = {0, -50},
    width = "600",
    height = "48",
    hide = true,
  },
})
ns.Command = Command

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
