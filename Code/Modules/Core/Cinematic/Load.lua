local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales

addon.Cinematic = {}
local NS = addon.Cinematic; addon.Cinematic = NS

function NS:Load()
	local function Modules()
		NS.Util:Load()

		NS.Elements:Load()
		NS.Script:Load()
	end

	local function Submodules()
		NS.Effects:Load()
	end

	local function Misc()
		-- This UnregisterEvent no longer has any effect on the current client:
		-- EXPERIMENTAL_CVAR_CONFIRMATION_NEEDED is now dispatched through
		-- Blizzards newer EventRouting/EventImplementation system rather than a
		-- plain per-frame RegisterEvent/OnEvent, so it cannot be silenced this
		-- way anymore. Kept as a harmless no-op for older clients; the actual
		-- fix is addon.API.Util:SetExperimentalCVar disabling test_ CVar writes
		-- outright (see Code/API/Core/Util.lua).
		UIParent:UnregisterEvent("EXPERIMENTAL_CVAR_CONFIRMATION_NEEDED")

		local function Start()
			local cinematicMode = addon.Database.DB_GLOBAL.profile.INT_CINEMATIC

			if cinematicMode then
				addon.API.Util:SetExperimentalCVar("test_cameraTargetFocusInteractEnable", addon.ConsoleVariables.Variables.Saved_cameraTargetFocusInteractEnable)
			end
		end

		Start()
	end

	Modules()
	Misc()

	C_Timer.After(0, function()
		Submodules()
	end)
end
