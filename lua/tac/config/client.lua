--[[ ~~~~~~~~~~~~~~~~~~ ]]--
--[[ Trinity Anti-Cheat ]]--
--[[ ~~~~~~~~~~~~~~~~~~ ]]--

-- Don't touch these.
local Config = { }

--- Flag Batches ---

Config.Batch = 32000
Config.ProcessTime = 0.25

--- Aimbot Checks ---

/*
	This check simply detects when the player is using movement code more
	than once to fix a prediction issue with all Source games. This fix 
	increases their accuracy with Aimbots but is also trivial to detect.
*/

Config.Prediction = {
	Enabled = true
}

/*
	This check simply sits between StartCommand and SetupMove to detect players
	manipulating CUserCMD values within CreateMove. Likely to false flag some
	addons that meddle with these values especially view angles.
*/

Config.InputGuard = {
	Enabled = true,

	Angles = false,
	Offset = 1,

	Buttons = false,

	Movement = false
}

/*
	This check simply checks if the player is adjusting view angles within a
	VGUI frame. Might false flag alot of addons but you should probably
	disable it serverside!
*/

Config.MenuMovement = {
	Enabled = true
}
 
--- Integrity ---

Config.Integrity = {
	Tracer = {
		Enabled = true
	},

	Stack = {
		Enabled = true
	},

	DebugSelf = {
		Enabled = true
	},

	Libraries = {
		Enabled = true,
		
		concommand = {
			Enabled = true,
			Size = 1
		},
		
		net = {
			Enabled = true,
			Size = 4
		}
	},

	DebugHooks = {
		Enabled = true,

		Lines = true,
		Target = 7,

		Garbage = true,
		Delta = 100,
		Fill = 3
	}
}

--- Static Cheats / Scripts ---

Config.Static = {
	Enabled = true
}

--- Breakers ---

Config.FSB = {
	Enabled = false,

	Code = "\n",
	Identifier = ".DEL\nCON.",

	Spammer = true,
	Ticks = 1,
	Size = 1
}

Config.ESP = {
	Enabled = false
}

--- Heartbeat ---

Config.Heartbeat = {
	Enabled = true,

	Await = 15
}

--- Scans ---

Config.Scans = {
	Binaries = {
		Enabled = true,

		Detour = true
	},

	Commands = {
		Enabled = true,
		Delay = 600,

		Detour = true
	},

	Globals = {
		Enabled = true,

		Delay = 60
	},

	Files = {
		Enabled = true
	},

	Hooks = {
		Enabled = true,

		Delay = 120
	}
}

--- Listeners ---

Config.Listeners = {
	Enabled = true
}

return Config