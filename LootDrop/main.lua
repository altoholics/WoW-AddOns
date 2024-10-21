local ADDON_NAME, ns = ...

local GetMoney, GetCoinTextureString, GetItemInfo = GetMoney, C_CurrencyInfo.GetCoinTextureString, C_Item.GetItemInfo
local ExtractHyperlinkString = ExtractHyperlinkString

LibNAddOn{
  name = ADDON_NAME,
  addOn = ns,
  db = {
    name = "LootDropDB",
    defaults = {
      trackedItems = {n=0},
    },
  },
  slashCommands = {
    warband = {"/lootdrop", "/ld"},
  },
}

local Class, tinsert, tremove = ns.lua.Class, ns.lua.tinsert, ns.lua.tremove
local max = ns.lua.max
local ui = LibNUI
local Frame, CleanFrame, Label, Texture = ui.Frame, ui.CleanFrame, ui.Label, ui.Texture
local UIParent = ns.wowui.UIParent

local HistoryItem = Class(Frame, function(self)
  local name, _, qual, _, _, _, _, _, _, tex = GetItemInfo(self.link)

  self.icon = Texture:new{
    parent = self,
    layer = "ARTWORK",
    coords = {0.07, 0.93, 0.07, 0.93},
    path = tex,
    position = {
      TopLeft = {},
      BottomLeft = {},
      Width = 30,
    },
  }
  self.name = Label:new{
    parent = self,
    text = name,
    position = {
      TopLeft = {self._widget, ui.edge.TopLeft, 30, -4},
      Right = {self._widget, ui.edge.Right},
      Height = 26,
    },
    justifyH = "LEFT",
  }
end, {
  position = {
    Height = 30,
  },
  background = {0, 0, 0, 0.5},
})

function HistoryItem:Update(link)
  self.link = link
  local name, _, qual, _, _, _, _, _, _, tex = GetItemInfo(self.link)
  self.icon:setTexture(tex)
  self.name:Text(name)
end

local History = Class(CleanFrame, function(self)
  self.history = {}
end,{
  parent = UIParent,
  position = {
    Width = 150,
    Height = 12,
    Hide = true,
  },
  background = {0, 0, 0, 0.2},
  events = {"CHAT_MSG_LOOT"},
})

function History:AddItem(link)
  if #self.history < 10 then
    tinsert(self.history, HistoryItem:new{
      parent = self,
      link = link,
      position = {
        Bottom = {self._widget, ui.edge.Bottom, 0, 32 * #self.history + 2},
        Left = {self._widget, ui.edge.Left, 2, 0},
        Right = {self._widget, ui.edge.Right, -2, 0},
      },
    })
  else
    -- move oldest to end of list
    local hi = tremove(self.history, 1)
    hi:Update(link)
    tinsert(self.history, hi)
    -- reposition
    for i=1,#self.history do
      self.history[i]:bottom(self._widget, ui.edge.Bottom, 0, 32 * (i-1) + 2)
    end
  end
  self:Height(32 * #self.history + 2)
end

function History:CHAT_MSG_LOOT(text, playerName, _, _, playerName2)
  if playerName == playerName2 or playerName2 == "" then -- our loot
    local _, _, link = ExtractHyperlinkString(text)
    if link then self:AddItem(link) end
  end
end

local Bucket = Class(Frame, function(self)
  self:makeDraggable()
  self:makeContainerDraggable()
  self:withTextureBackground("topBorder", {
    color = {0, 0, 0},
    position = {
      TopLeft = {0, 1},
      TopRight = {},
    },
  })
  self.money = Label:new{
    parent = self,
    position = { TopRight = {-2, -2} },
  }

  self.fadeDelay = 10000
  self.fadeDuration = 5000
  self.tracking = {n=0}
end, {
  parent = UIParent,
  position = {
    Width = 100,
    Height = 20,
    BottomRight = {-300, 30},
  },
  events = {"PLAYER_ENTERING_WORLD", "PLAYER_MONEY"},
  scripts = {"OnEnter", "OnLeave", "OnMouseUp"},
})

function Bucket:checkSize()
  local w = max(100, self.money._widget:GetUnboundedStringWidth())
  self:Width(w + 4)
end

function Bucket:onUpdate(elapsed)
  if self.fadeWait > 0 then
    self.fadeWait = self.fadeWait - elapsed
    if self.fadeWait <= 0 then
      self.fadeWait = -1
      self.fadeTimer = self.fadeDuration
    end
  end
  if self.fadeTimer > 0 then
    self.fadeTimer = self.fadeTimer - elapsed
    if self.fadeTimer <= 0 then
      self:stopUpdates()
      self.fadeTimer = -1
      self._widget:SetAlpha(0.15)
    else
      self._widget:SetAlpha(0.15 + 0.85 * self.fadeTimer / self.fadeDuration)
    end
  end
end

function Bucket:updateMoney()
  local money = GetMoney()
  local s = GetCoinTextureString(money)
  self.money:Text(s)
  -- reset timers
  self.fadeTimer = -1
  self.fadeWait = self.fadeDelay
  self._widget:SetAlpha(1)
  self:checkSize()
  self:startUpdates()
end

function Bucket:PLAYER_MONEY()
  self:updateMoney()
end

local ExtractHyperlinkString, GetItemInfoFromHyperlink = ExtractHyperlinkString, GetItemInfoFromHyperlink -- luacheck: globals ExtractHyperlinkString GetItemInfoFromHyperlink
-- https://wowpedia.fandom.com/wiki/CHAT_MSG_LOOT
function Bucket:CHAT_MSG_LOOT(text, playerName, _, _, playerName2) -- langName, chanName, specialFlags, zoneChannelID, channelIndex, channelBaseName, langID, lineID, guid, bnSenderID, isMobile, isSubtitle, hideSenderInLetterbox, suppressRaidIcons
  if playerName == playerName2 or playerName2 == "" then -- our loot
    local link = ExtractHyperlinkString(text)
    if link then
      local itemId = GetItemInfoFromHyperlink(link)
      if self.db.trackedItems[itemId] then
        -- todo
      end
      print(link)
    end
  end
end

function Bucket:startTracking(itemName)
  local name, link, _, _, _, _, _, _, _, textureID = GetItemInfo(itemName)
  local itemId = GetItemInfoFromHyperlink(link)
  if name and not self.db.trackedItems[itemId] then
    -- if we weren't watching loot, start
    if self.db.trackedItems.n == 0 then
      self._widget:RegisterEvent("CHAT_MSG_LOOT")
    end
    self.db.trackedItems.n = self.db.trackedItems.n + 1
    self.db.trackedItems[itemId] = {id=itemId, name=name, textureID = textureID}
    print("Now tracking ", link)
  end
end

function Bucket:stopTracking(itemName)
  local name, link = GetItemInfo(itemName)
  if name and self.db.trackedItems[link] then
    local itemId = GetItemInfoFromHyperlink(link)
    self.db.trackedItems.n = self.db.trackedItems.n - 1
    self.db.trackedItems[itemId] = nil
    print("No longer tracking ", link)
  end
end

function Bucket:OnLogin(login, reload)
  self:updateMoney()
end

function Bucket:OnEnter()
  print("bucket enter")
end

function Bucket:OnLeave()
  print("bucket leave")
end

function Bucket:OnMouseUp()
  ns.history:Toggle()
end


function ns:onLoad()
  ns.bucket = Bucket:new{}
  ns.history = History:new{
    position = {
      BottomRight = {ns.bucket._widget, ui.edge.TopRight, 0, 5},
    },
  }
end

function ns:SlashCmd(_, msg) -- cmd, msg
  local _, _, cmd, args = string.find(msg, "(%w+) ?(.*)")
  if "add" == cmd then
    Bucket:startTracking(args)
  elseif "remove" == cmd then
    Bucket:stopTracking(args)
  end
end
