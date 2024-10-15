local _, ns = ...
-- luacheck: globals ChatFontNormal CreateFont ChatFrame_ImportAllListsToHash hash_SlashCmdList MAX_WOW_CHAT_CHANNELS hash_ChatTypeInfoList hash_EmoteTokenList
local ui, Colors = ns.ui, ns.Colors
local Class = ns.lua.Class
local unpack, strsub, string, strmatch = ns.lua.unpack, ns.lua.strsub, ns.lua.string, ns.lua.strmatch
local CleanFrame, Button = ui.CleanFrame, ui.Button
local UpdateHashLists = ChatFrame_ImportAllListsToHash
local COMMANDS, CHANNELS, EMOTES = hash_SlashCmdList, hash_ChatTypeInfoList, hash_EmoteTokenList
local MAX_WOW_CHAT_CHANNELS = MAX_WOW_CHAT_CHANNELS
local GetChannelName, DoEmote, SendChatMessage = ns.wow.GetChannelName, ns.wow.DoEmote, ns.wow.SendChatMessage

local file, _, flags = ChatFontNormal:GetFont()
local chatFont = CreateFont("ButtonKeybind")
chatFont:SetFont(file, 30, flags)

local SoUICmdTitleFont = CreateFont("SoUICmdTitleFont")
SoUICmdTitleFont:SetFont("fonts/frizqt__.ttf", 18, "OUTLINE")
SoUICmdTitleFont:SetShadowOffset(2, -2)
SoUICmdTitleFont:SetShadowColor(0, 0, 0, 0.5)

local EditBox = Class(CleanFrame, function(self)
  if self.autoFocus ~= nil then self.frame:SetAutoFocus(self.autoFocus); self.autoFocus = nil end
  if self.insets then self.frame:SetTextInsets(unpack(self.insets)); self.insets = nil end
  if self.font then self.frame:SetFontObject(self.font); self.font = nil end
end, {
  type = "EditBox",
})

local Command = Class(EditBox, function(self)
  local f = self
  -- invis button for custom keybind handler
  self.binder = Button:new{
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
  self.binderSlash = Button:new{
    parent = self,
    name = "$parentBinderSlash",
    bindLeftClick = "/",
    kbLabel = false,
    glow = false,
    position = {
      topRight = {self.frame, ui.edge.TopLeft},
    },
    onClick = function() if not f.frame:IsShown() then f:show() end end,
  }

  self:withLabel("channelTitle", {
    text = "Say",
    fontObj = SoUICmdTitleFont,
    alpha = 0.8,
    position = {
      bottomLeft = {self.frame, ui.edge.TopLeft, 15, -2},
    },
  })
  self:withLabel("channelTargetName", {
    text = "",
    fontObj = SoUICmdTitleFont,
    alpha = 0.8,
    color = Colors.Whisper,
    position = {
      left = {self.channelTitle.label, ui.edge.Right, 2, 0},
    },
  })
end, {
  parent = ns.wow.UIParent,
  name = "ShadowsOfUI_Command",
  strata = "DIALOG",
  level = 512,
  autoFocus = true,
  alpha = 0.8,
  background = {0, 0, 0, 0.8},
  position = {
    center = {0, -50},
    width = 800,
    height = 48,
    hide = true,
  },
  insets = {5, 5, 5, 5},
  font = chatFont,
  scripts = {
    "OnEscapePressed",
    "OnEnterPressed",
    "OnSpacePressed",
  },
  channelType = "SAY",
})
ns.Command = Command

function Command:Show()
  self.frame:Show()
end

function Command:OnEscapePressed()
  self.frame:SetText("")
  self:hide()
end

-- https://github.com/Gethe/wow-ui-source/blob/5076663b5454de9e7522320994ea7cc15b2a961c/Interface/AddOns/Blizzard_ChatFrameBase/Mainline/ChatFrame.lua#L5425
function Command:OnEnterPressed()
  local text = self.frame:GetText()
  if text ~= "" then
    if strsub(text, 1, 1) == "/" then
      local _, _, cmd, msg = string.find(text, "(/?%w+) ?(.*)")
      cmd = string.upper(cmd)
      msg = string.trim(msg)
      UpdateHashLists()

      -- only secure command needing handling is /target
      if COMMANDS[cmd] then
        COMMANDS[cmd](msg, self.frame)
      elseif EMOTES[cmd] then
        DoEmote(EMOTES[cmd], msg)
      else
        local channel = strmatch(cmd, "/([0-9]+)$")
        if channel then
          local chanNum = tonumber(channel)
          if chanNum > 0 and chanNum <= MAX_WOW_CHAT_CHANNELS then
            local num, name = GetChannelName(channel)
            if num > 0 then
              self:UpdateChannelDisplay("CHANNEL", num, name)
            end
          end
        elseif CHANNELS[cmd] then
          self:UpdateChannelDisplay(CHANNELS[cmd])
        else
          print("Unknown command:", cmd)
        end
      end
    else
      if "SMART_WHISPER" == self.channelType then
        print(self.channelTarget, text)
        SendChatMessage(text, "WHISPER", nil, self.channelTarget)
      else
        SendChatMessage(text, self.channelType, nil, self.channelNum)
      end
    end
  end

  self.frame:SetText("")
  self:hide()
end

local ChannelInfo = {
  GUILD = { title = "Guild", color = Colors.Guild },
  OFFICER = { title = "Officer", color = Colors.Officer },
  PARTY = { title = "Party", color = Colors.Party },
  RAID = { title = "Raid", color = Colors.Raid },
  SAY = { title = "Say", color = Colors.White },
  SMART_WHISPER = { title = "Whisper", color = Colors.Whisper },
  YELL = { title = "Yell", color = Colors.Yell },
}

function Command:UpdateChannelDisplay(type, num, name, target, targetDisplay)
  self.channelType = type
  self.channelNum = num
  self.channelTarget = target
  if num then
    self.channelTitle:Text(name)
    self.channelTargetName:Text("")
    if num == 1 then
      self.channelTitle:Color(unpack(Colors.General))
      self.frame:SetTextColor(unpack(Colors.General))
    else
      self.channelTitle:Color(unpack(Colors.White))
      self.frame:SetTextColor(unpack(Colors.White))
    end
  else
    local info = ChannelInfo[type]
    if info then
      self.channelTitle:Text(info.title)
      self.channelTargetName:Text(targetDisplay or "")
      self.channelTitle:Color(unpack(info.color))
      self.frame:SetTextColor(unpack(info.color))
    else
      print("Unrecognized channel type", type)
    end
  end
end

function Command:OnSpacePressed()
  local text = self.frame:GetText()
  if text == "" then return end
  if strsub(text, 1, 1) ~= "/" then return end
  local cmd = strmatch(text, "(/%w+) $")
  if not cmd then return end
  cmd = string.upper(cmd)

  if CHANNELS[cmd] then
    if "/DUMP" == cmd then return end -- why is dump a channel?
    if "/RUN" == cmd then return end -- and run? (type script)
    self:UpdateChannelDisplay(CHANNELS[cmd])
    self.frame:SetText("")
  else
    local channel = strmatch(cmd, "/([0-9]+)$")
    if channel then
      local chanNum = tonumber(channel)
      if chanNum > 0 and chanNum <= MAX_WOW_CHAT_CHANNELS then
        local num, name = GetChannelName(channel)
        if num > 0 then
          self:UpdateChannelDisplay("CHANNEL", num, name)
          self.frame:SetText("")
        end
      end
    end
  end
end
