--[[ ~~~~~~~~~~~~~~~~~~ ]]--
--[[ Trinity Anti-Cheat ]]--
--[[ ~~~~~~~~~~~~~~~~~~ ]]--

-- Don't touch these.
local Config = { }

--- Batches ---

--[[
	These are the options that control the rate in which the client will
	transfer data to the server.

	Batch is the size of individual net messages, lower this if you keep
	getting "overflowed network channel" errors in console.

	ProcessTime is the time between each burst.
--]]

Config.Batch = 32000
Config.ProcessTime = 0.25

--- Aimbot Checks ---

--[[
	This is the clientside version of the config for `Engine Prediction` serverside.

	This controls whether or not to run the check. This check doesn't have a huge impact
	on clientside performance so it is not necessary to disable it here.
--]]

Config.Prediction = {
	Enabled = true
}

--[[
	This is the clientside version of the config for the various `Input Guard` checks 
	serverside.
--]]

Config.InputGuard = {
	Enabled = false,

	Angles = false,
	Offset = 1,

	Buttons = false,

	Movement = false
}

--[[
	This is the clientside version of the config for `Menu Movement` serverside.

	This controls whether or not to run the check. This check doesn't have a huge impact
	on clientside performance so it is not necessary to disable it here.
--]]

Config.MenuMovement = {
	Enabled = true
}
 
--- Integrity ---

--[[
	These are the clientside version of the various `Integrity` checks 
	you'll find serverside.
	
	These do not have a huge impact on clientside performance so it is
	not necessary to disable them here.

	As for the libraries size, you can adjust them to fix false flags here.
	This isn't recommended though.
--]]

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
	}
}

--- Static Cheats / Scripts ---

--[[
	This is the clientside version of the config for `Static Script` serverside.

	This controls whether or not to run the check. This check doesn't have a huge impact
	on clientside performance so it is not necessary to disable it here.
--]]


Config.Static = {
	Enabled = true
}

--- Breakers ---

--[[
	What this does is spam RunString with corrupted identifiers to attempt to confuse
	or break file stealers. Various file stealers are prevented from working properly
	with this enabled (Interstate, GLuaSteal, etc).
--]]

Config.FSB = {
	Enabled = false,

	Code = "\n",
	Identifier = ".DEL\nCON.",

	Spammer = true,
	Ticks = 1,
	Size = 1
}

--[[
	What this does is setup a render target (new camera) and destroying it every frame to break
	C++ ESP systems. Works on a various cheats but can be extremely performance intensive.
--]]

Config.ESP = {
	Enabled = false
}

--- Heartbeat ---

--[[
	This is the clientside version of the config for `Heartbeat` serverside.

	This is the heartbeat sent to the server every couple of seconds (controlled by Await).
--]]

Config.Heartbeat = {
	Enabled = true,

	Await = 15
}

--- Scans ---

--[[
	These are the clientside version of the various `Scan` checks 
	you'll find serverside.
	
	These do not have a huge impact on clientside performance so it is
	not necessary to disable them here.

	You can control the individual flags in the lists files (`tac/lists/*`)
--]]

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

--[[
	These are the clientside version of the `Listener` check 
	you'll find serverside.

	This controls whether or not to run the check. This check doesn't have a huge impact
	on clientside performance so it is not necessary to disable it here.

	If you'd like to modify the listeners individually you can modify them in the file:
	`tac/lists/cl_listener.lua`
--]]

Config.Listeners = {
	Enabled = true
}

return Config