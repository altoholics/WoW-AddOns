local ADDON_NAME, ns = ...

local MainMenuBar, MultiBarBottomLeft, Tutorials, IsAddonLoaded = ns.g.MainMenuBar, ns.g.MultiBarBottomLeft, ns.g.Tutorials, ns.g.IsAddonLoaded

function PurgeKey(t, k)
	t[k] = nil
	local c = 42
	repeat
		if t[c] == nil then
			t[c] = nil
		end
		c = c + 1
	until issecurevariable(t, k)
end

local function hideActionBarFrame(frame, clearEvents)
	if frame then
		if clearEvents then
			frame:UnregisterAllEvents()
		end

		-- remove some EditMode hooks
		if frame.system then
			-- purge the show state to avoid any taint concerns
			PurgeKey(frame, "isShownExternal")
		end

		-- EditMode overrides the Hide function, avoid calling it as it can taint
    frame:HideBase()
		-- frame:SetParent(ns.UIHider)
	end
end

local function hideActionButton(button)
	if not button then return end

	button:Hide()
	button:UnregisterAllEvents()
	button:SetAttribute("statehidden", true)
end

local function disbaleTutorials()
	if not (Tutorials and Tutorials.AddSpellToActionBar) then return end

	-- Action Bar drag tutorials
	Tutorials.AddSpellToActionBar:Disable()
	Tutorials.AddClassSpellToActionBar:Disable()

	-- these tutorials rely on finding valid action bar buttons, and error otherwise
	Tutorials.Intro_CombatTactics:Disable()

	-- enable spell pushing because the drag tutorial is turned off
	Tutorials.AutoPushSpellWatcher:Complete()
end

function ns:HideBlizzard()
	-- Hidden parent frame
	local UIHider = CreateFrame("Frame")
	UIHider:Hide()
	self.UIHider = UIHider

	hideActionBarFrame(MainMenuBar, false)
	hideActionBarFrame(MultiBarBottomLeft, true)
	-- hideActionBarFrame(MultiBarBottomRight, true)
	-- hideActionBarFrame(MultiBarLeft, true)
	-- hideActionBarFrame(MultiBarRight, true)
	-- hideActionBarFrame(MultiBar5, true)
	-- hideActionBarFrame(MultiBar6, true)
	-- hideActionBarFrame(MultiBar7, true)

	-- Hide MultiBar Buttons, but keep the bars alive
	-- for i=1,12 do
	-- 	hideActionButton(_G["ActionButton" .. i])
	-- 	hideActionButton(_G["MultiBarBottomLeftButton" .. i])
		-- hideActionButton(_G["MultiBarBottomRightButton" .. i])
		-- hideActionButton(_G["MultiBarRightButton" .. i])
		-- hideActionButton(_G["MultiBarLeftButton" .. i])
		-- hideActionButton(_G["MultiBar5Button" .. i])
		-- hideActionButton(_G["MultiBar6Button" .. i])
		-- hideActionButton(_G["MultiBar7Button" .. i])
	-- end

	-- hideActionBarFrame(MicroButtonAndBagsBar, false)
	-- hideActionBarFrame(StanceBar, true)
	-- hideActionBarFrame(PossessActionBar, true)
	-- hideActionBarFrame(MultiCastActionBarFrame, false)
	-- hideActionBarFrame(PetActionBar, true)
	-- hideActionBarFrame(StatusTrackingBarManager, false)
	-- hideActionBarFrame(BagsBar, true)
	-- hideActionBarFrame(MicroMenu, true)

	-- these events drive visibility, we want the MainMenuBar to remain invisible
	MainMenuBar:UnregisterEvent("PLAYER_REGEN_ENABLED")
	MainMenuBar:UnregisterEvent("PLAYER_REGEN_DISABLED")
	MainMenuBar:UnregisterEvent("ACTIONBAR_SHOWGRID")
	MainMenuBar:UnregisterEvent("ACTIONBAR_HIDEGRID")

	if IsAddonLoaded("Blizzard_NewPlayerExperience") then
		disbaleTutorials()
	end
end
