local _, ns = ...

-- set up event handling
-- eventually this should keep the frame local and expose register/unregister functions
-- so we can chain callbacks

local function OnEvent(self, event, ...)
	if event == "ADDON_LOADED" then
		local addOnName = ...
		--print(event, addOnName)
	elseif event == "PLAYER_ENTERING_WORLD" then
		local isLogin, isReload = ...
		local playerName = UnitName("player");
		ChatFrame1:AddMessage('Hi my name is: ' .. playerName);
		--print(event, isLogin, isReload)
	elseif event == "CHAT_MSG_CHANNEL" then
		local text, playerName, _, channelName = ...
		--print(event, text, playerName, channelName)
	elseif event == "PLAYER_LEVEL_UP" then
		--PlayMusic(642322) -- sound/music/pandaria/mus_50_toast_b_hero_01.mp3
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("CHAT_MSG_CHANNEL")
f:RegisterEvent("PLAYER_LEVEL_UP")
f:SetScript("OnEvent", OnEvent)


ns.frame = f
