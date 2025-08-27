--[[ ~~~~~~~~~~~~~~~~~~ ]]--
--[[ Trinity Anti-Cheat ]]--
--[[ ~~~~~~~~~~~~~~~~~~ ]]--

-- Don't touch these.
local Config = { }

TAC.Config = Config

--- Interpolated Strings ---

--[[
	Default Player Strings:
	
	{Name}
	{SteamID64}
	{SteamID}
	{IP}
	{Ping}
	{Loss}
	{Position}
	{Angle}
--]]

--[[
	Default Token Strings:
	
	{Info}
	{ID}
--]]

--[[
	Flags Specific Strings:

	{Flags}
--]]

--[[
	Default Global Strings:

	{Contact}
	{Map}
	{Gamemode}
--]]

--- General ---

Config.Contact = "Bananas!"

Config.Staff = {
	Roles = {
		admin = true,
		operator = true,
		superadmin = true
	},
	
	IDs = {
		-- SteamID
	}
}

--- Alerts ---

Config.Alerts = {
	Enabled = true,
	
	Sounds = {
		Punishment = "npc/roller/mine/rmine_blip3.wav",
		Important = "npc/roller/mine/rmine_taunt1.wav",
		Notify = "npc/roller/mine/rmine_blip1.wav",
		Error = "buttons/combine_button_locked.wav"
	}
}

--- Logging ---

Config.Logging = {
	Console = true,
	DB = false,
	File = true,
	
	DBCreate = function()
		return "CREATE TABLE IF NOT EXISTS trinity_db( sid TEXT, type TEXT, text TEXT )"
	end,
	
	DBQuery = function(Player, Type, Message)
		return string.format(
            "INSERT INTO trinity_db( sid, type, text ) VALUES( %s, %s, %s )",
            sql.SQLStr(User:SteamID64()),
            sql.SQLStr(Type),
            sql.SQLStr(Message)    
        )
	end,
	
	Callback = function(Player, Type, Text)
		return
	end,
	
	Directory = "trinity/",
		
	Prefix = function(Type)
		return string.format( 
			"[%s] %s: ",
			os.date("%H:%M:%S"),
			Type
		)
	end
}

--- Punishment ---

Config.Punishment = {
	ignoreStaff = false,

	globalFilter = false,
	globalFilterCallback = function(Player, Config)
		return false
	end,

	pStub.Register("Fallback", {
		-- General
		Enabled = false,
		Name = "Fallback",
		Description = "",
		Category = "None",
		
		-- Clientside
		Client = false,
		
		-- Punishment section.
		Backend = "ULX", -- See "backends/" for adding new ones.
		Method = PUNISHMENT_LOG,
		Message = "Unfair Advantage: {Contact}",
		Time = 0,

		-- Flag section.
		Flags = false,
		Maximum = 3,
		Decay = -1,
		
		AlertFlagsMinimum = 0,
		
		-- Alert section.
		Alerts = {
			Evaluate = ALERT_NONE,
			Flags = ALERT_STAFF,
			Punishment = ALERT_EVERYONE
		},
		
		-- Formats.
		formatEvaluate = function(Token)
			return tFormat(
				Token,
				"{Name} [{SteamID64}] was evaluated for \"{Info}\" ({ID})!"
			)
		end,
		
		formatFlags = function(Token, Flags)
			return tFormat(
				Token,
				"{Name} [{SteamID64}] was flagged for \"{Info}\" ({ID})! [{Flags}]"
			)
		end,
		
		formatPunishment = function(Token)
			return tFormat(
				Token,
				"{Name} [{SteamID64}] was punished for \"{Info}\" ({ID})!"
			)
		end,
		
		formatLog = function(Token)
			return tFormat(
				Token,
				"{Name} [{SteamID64}] was logged for \"{Info}\" ({ID})!"
			)
		end,
		
		-- Avoidance
		Ping = -1,
		Loss = -1,
		Vehicles = false,
		Water = false,
		Noclip = false,
		SWEPs = {
			-- ...
		}

		-- Extra
		-- ...
	}),
}

--- Networking ---

Config.Networking = {
	Overreach = 2,
	Delay = 1.5,
	Step = 0.15
}

pStub.Register("Networking Batch", {
	Enabled = true,
	Name = "Networking Batch",
	Description = "Occurs when a player manipulates the punishment batch processing on the clientside.",
	Category = "Networking",
		
	Method = PUNISHMENT_KICK,
	
	Maximum = 32
})

pStub.Register("Client Integrity", {
	Enabled = true,
	Name = "Client Integrity",
	Description = "Occurs when invalid data is sent to the server from the clientside.",
	Category = "Networking",
	
	Message = "Integrity: {Contact}",
	
	Method = PUNISHMENT_KICK
})

--- Aimbots ---

pStub.Register("Angles", {
	Enabled = true,
	Name = "Angles",
	Description = "Detects invalid source engine angles.",
	Category = "Aimbot",
	
	Method = PUNISHMENT_KICK,
	
	CheckPitch = true,
	MaxPitch = 90,
	CheckYaw = true,
	MaxYaw = 180,
	
	Vehicles = true
})

pStub.Register("Snap", {
	Enabled = true,
	Name = "Snap",
	Description = "Detects snapping to players in a single tick.",
	Category = "Aimbot",
	
	Method = PUNISHMENT_KICK,
	
	Delta = 25,
	Scaled = true,
	ScaledDelta = 45,
	ScaledDistanceMin = 10000000,
	ScaledDistanceMax = 500000000,
	Distance = 65000,
	TimeSinceSpawned = 3.5,
	UseTwoTarget = false,
	
	Flags = false,
	Maximum = 2,
	Decay = 4,
	
	Vehicles = true,
	Ping = 90,
	Loss = 80
})

pStub.Register("Mouse", {
	Enabled = true,
	Name = "Mouse",
	Description = "Detects invalid MouseX/MouseY values compared to angle changes.",
	Category = "Aimbot",
	
	Method = PUNISHMENT_KICK,
	
	InputlessDeltaMax = 2.5,
	InputlessDeltaMin = 0.25,
	FarDelta = 15,
	Distance = 8000,
	
	Flags = true,
	Maximum = 6,
	Decay = 4,
	
	AlertFlagsMinimum = 3,
	
	Vehicles = true,
	Ping = 150,
	Loss = 80
})

pStub.Register("Micromovement", {
	Enabled = true,
	Name = "Micromovement",
	Description = "Detects strange stuttery movement within a players view angles.",
	Category = "Aimbot",
	
	Method = PUNISHMENT_KICK,
		
	Delta = 0.05,
	LowOffset = 0.10,
	HighOffset = 0.75,
	HighIncrement = 3,
	Distance = 4000,
	
	Flags = true,
	Maximum = 6,
	Decay = 4,
	
	AlertFlagsMinimum = 3,
	
	Vehicles = true,
	Ping = 150,
	Loss = 80
})

pStub.Register("Autoclicker", {
	Enabled = true,
	Name = "Autoclicker",
	Description = "Detects autoclickers. Will flag external autoclickers as well.",
	Category = "Aimbot",
	
	Method = PUNISHMENT_KICK,
	
	ResetOnFailure = false,
	
	Flags = true,
	Maximum = 15,
	Decay = 1.0,
	
	Alerts = {
		Flags = ALERT_NONE
	}
})

pStub.Register("Static", {
	Enabled = true,
	Name = "Static",
	Description = "Detects players moving at constant mouse speeds.",
	Category = "Aimbot",
	
	Message = "Unusual Mouse Input: {Contact}",
	
	Method = PUNISHMENT_KICK,
		
	Flags = true,
	Maximum = 15,
	Decay = 0.5,
	
	Alerts = {
		Flags = ALERT_NONE
	}
})

pStub.Register("Emulated Mouse", {
	Enabled = true,
	Name = "Emulated Mouse",
	Description = "Detects players emulating mouse inputs via SetMouseX & SetMouseY. Will false flag if given low maximums. Recommended to keep on kick instead of ban.",
	Category = "Aimbot",
	
	Message = "Unusual Mouse Input: {Contact}",
	
	Method = PUNISHMENT_KICK,
	
	Flags = true,
	Maximum = 60,
	Decay = 0.5,
	
	Alerts = {
		Flags = ALERT_NONE
	}
})

pStub.Register("Nospread", {
	Enabled = true,
	Name = "Nospread",
	Description = "Detects seed nospreads by using a delta sample check. Can be expensive and may not be worth the performance.",
	Category = "Aimbot",
	
	Message = "Unusual Spread Cone: {Contact}",
	
	Method = PUNISHMENT_KICK,
	
	Samples = 15,
	DeltaSamples = 8,
	MinimumCone = 0.05,
	Distance = 400,
	Delta = 0.01,
})

--- Movement ---

pStub.Register("Bunnyhop", {
	Enabled = true,
	Name = "Bunnyhop",
	Description = "Detects players with perfect bunnyhop. Will false flag bunnyhop addons.",
	Category = "Movement",
	
	Message = "Bunnyhop: {Contact}",
	
	Method = PUNISHMENT_KICK,
	
	LTT = 1.5,
	TimeSinceSpawned = 3.5,
	
	Flags = true,
	Maximum = 12,
	Decay = 10,
	
	AlertFlagsMinimum = 10,
	
	Vehicles = true,
	Water = true,
	Noclip = true
})

pStub.Register("Autostrafe", {
	Enabled = true,
	Name = "Autostrafe",
	Description = "Detects players with artificial movement patterns related to strafing.",
	Category = "Movement",
	
	Method = PUNISHMENT_BAN,
		
	Flags = true,
	Maximum = 20,
	Decay = 2,
		
	Alerts = {
		Flags = ALERT_NONE
	}
})

pStub.Register("Input", {
	Enabled = false,
	Name = "Input",
	Description = "Detects players who are using something to manipulate their movement vectors.",
	Category = "Movement",
	
	Method = PUNISHMENT_KICK,
	
	Minimum = 1000,
	LTT = 1.5,

	Vectors = {
		[2500] = true,
		[5000] = true,
		[7500] = true,
		[10000] = true
	},
	
	Flags = false,
	Maximum = 12,
	Decay = 8,
	
	Alerts = {
		Flags = ALERT_NONE
	},
	
	Ping = 200,
	Loss = 90,
	Vehicles = true,
	Water = true
})

--- Exploits ---

pStub.Register("Interpolation Abuse", {
	Enabled = true,
	Name = "Interpolation Abuse",
	Description = "Detects two methods of interpolation abuse to catch cheaters.",
	Category = "Exploit",
	
	Message = "Strange Interpolation: {Contact}",
	
	Method = PUNISHMENT_KICK,
	
	Overflow = true,
	
	Flags = true,
	Maximum = 4,
	Decay = 8,
	
	Ping = 350,
	Loss = 80
})

pStub.Register("Speedhack", {
	Enabled = true,
	Name = "Speedhack",
	Description = "Detects speedhack on servers with sv_maxusrcmdprocessticks set to zero. May also detect other exploits.",
	Category = "Exploit",
	
	Message = "Strange Lag Patterns: {Contact}",
	
	Method = PUNISHMENT_KICK,
	
	Flags = true,
	Maximum = 45,
	Decay = 0.15,
	
	AlertFlagsMinimum = 40,
	
	Alerts = {
		Flags = ALERT_NONE
	},
	
	Ping = 100,
	Loss = 80
})


pStub.Register("Tickcount", {
	Enabled = true,
	Name = "Tickcount",
	Description = "Detects tickcount manipulation to do things like backtrack.",
	Category = "Exploit",
	
	Message = "Strange Lag Patterns: {Contact}",
	
	Method = PUNISHMENT_KICK,
	
	Regular = true,
	
	Negative = true,
	Range = -350,
	
	Flags = true,
	Maximum = 10,
	Decay = 5,
	
	Alerts = {
		Flags = ALERT_NONE
	},
	
	Ping = 80,
	Loss = 80
})

pStub.Register("Fakelag", {
	Enabled = true,
	Name = "Fakelag",
	Description = "Detects constant lag patterns to find players who fakelag.",
	Category = "Exploit",
	
	Message = "Strange Lag Patterns: {Contact}",
	
	Method = PUNISHMENT_KICK,
	
	Flags = true,
	Maximum = 3,
	Decay = 5,
	
	Alerts = {
		Flags = ALERT_NONE
	},
	
	Ping = 150,
	Loss = 75
})

pStub.Register("Simulation Time", {
	Enabled = true,
	Name = "Simulation Time",
	Description = "Detects players using the 'Desynculator' simulation time exploit.",
	Category = "Exploit",
	
	Message = "Timed Out: {Contact}",
	
	Method = PUNISHMENT_KICK,
	
	TimeSinceCreated = 25,
	Low = -150,
	High = 150,
	
	Flags = true,
	Maximum = 10,
	Decay = 5,
	
	Ping = 250,
	Loss = 80
})

pStub.Register("Act", {
	Enabled = true,
	Name = "Act",
	Description = "Detects players who are moving while taunting (act commands).",
	Category = "Exploit",
	
	Method = PUNISHMENT_KICK
})

--- Extras ---

pStub.Register("Name Changer", {
	Enabled = true,
	Name = "Name Changer",
	Description = "Detects when players change steam username/name command, can be used to kick players if needed.",
	Category = "Extra",
	
	Method = PUNISHMENT_KICK
})

pStub.Register("Suspicious Keypresses", {
	Enabled = true,
	Name = "Suspicious Keypresses",
	Description = "Detects when players press suspicious keys. Can be configured to stop after a maximum is reached.",
	Category = "Extra",
	
	Method = PUNISHMENT_LOG,
	
	MaximumLogs = -1,
	
	Keys = {
		[KEY_INSERT] = "Insert",
		[KEY_DELETE] = "Delete"
	}
})

pStub.Register("Errors", {
	Enabled = true,
	Name = "Errors",
	Description = "Logs errors, if given the option it can also scan for errors from files that aren't supposed to exist.",
	Category = "Extra",
	
	Method = PUNISHMENT_LOG,

	Scan = true,
	ScanMethod = PUNISHMENT_Kick	
})

--- Command Enforcer ---

pStub.Register("Command Enforcer", {
	Enabled = true,
	Name = "Command Enforcer",
	Description = "Enforces console commands that shouldn't be changable without cheats.",
	Category = "Commands",
	
	Message = "Bad Command: {Contact}",
	
	Method = PUNISHMENT_KICK,
	
	Commands = {
		{
			Name = "cl_interpolate",
			Value = 1
		}
	},
	
	Delay = 5,
	
	Flags = false,
	Maximum = -1,
	Decay = -1,
})

--- Interpolated View Angles ---

--[[
	This will cause prediction issues but considering how low
	the TPS of most Garry's Mod servers are anyway it shouldn't
	effect the player as much as it effects the cheats.
]]--

Config.Interpolated = {
	Enabled = true,
	
	Ratio = 0.00005,
	Randomize = true,
	
	Whitelisted = {
		weapon_physgun = true,
		weapon_physcannon = true,
		gmod_tool = true
	}
}

--- World Clicker Disabler ---

--[[
	Disables the default context menu (c menu) world clicker that lets you shoot
	anywhere you want. This will still allow you to interact with props although
	it will remove the halo around props. Patches the pSilent exploit. 
]]--

Config.WorldClicker = true

--- Improved PVS (ESP Breaker) ---

--[[
	This may come with a moderate to severe proformance impact depending on
	the size of the server and the amount of players present in the players
	default PVS.
	
	This will never add onto the PVS, just remove. Also won't ever effect
	entities, just players.
]]--

Config.PVS = {
	Enabled = true,
	
	Ticks = 2,
	pingScale = 0.01,
	squareSize = 1,
	squaredSize = 256,
	intervalScale = 8
}

--- Client Mouse ---

pStub.Register("Client Mouse", {
	Enabled = true,
	Name = "Client Mouse",
	Description = "Occurs when the player moves their MouseX/MouseY while in an active menu.",
	Category = "Aimbot",
	
	Client = true,
	
	Method = PUNISHMENT_KICK,
	
	Flags = true,
	Maximum = 6,
	Decay = 2
})

--- Engine Prediction ---

pStub.Register("Engine Prediction", {
	Enabled = false,
	Name = "Engine Prediction",
	Description = "Occurs when the player attempts to use an aimbot prediction.",
	Category = "Aimbot",
	
	Client = true,
	
	Method = PUNISHMENT_KICK,
	
	Flags = true,
	Maximum = 4,
	Decay = 1
})

--- Input Guard ---

pStub.Register("Input Guard Angles", {
	Enabled = true,
	Name = "Input Guard Angles",
	Description = "Occurs when the player is detected for manipulating angles. Likely to flag poorly coded addons.",
	Category = "Aimbot",
	
	Client = true,
	
	Method = PUNISHMENT_LOG,
	
	Flags = false,
	Maximum = 10,
	Decay = 3
})

pStub.Register("Input Guard Buttons", {
	Enabled = true,
	Name = "Input Guard Buttons",
	Description = "Occurs when the player is detected for manipulating buttons. Unlikely to false flag.",
	Category = "Aimbot",
	
	Client = true,
	
	Method = PUNISHMENT_LOG
})

pStub.Register("Input Guard Mouse", {
	Enabled = true,
	Name = "Input Guard Mouse",
	Description = "Occurs when the player is detected for manipulating mouse movement. Unlikely to false flag.",
	Category = "Aimbot",
	
	Client = true,
	
	Method = PUNISHMENT_LOG,

	Flags = true,
	Maximum = 6,
	Decay = 3
})

pStub.Register("Input Guard Movement", {
	Enabled = true,
	Name = "Input Guard Movement",
	Description = "Occurs when the player is detected for manipulating movement values. Likely to flag poorly coded addons.",
	Category = "Aimbot",
	
	Client = true,
	
	Method = PUNISHMENT_LOG,

	Flags = false,
	Maximum = 8,
	Decay = 3
})

--- Pre-Init Checksum ---

--[[
	This will basically check all functions and variables
	in pre-init to verify the integrity of the environment.
	
	Check your console on the clientside to get the PIC 
	checksum. Be sure to not have any external cheats or
	pre-autorun scripts running when you do this!
	
	The checksum won't print if you have silent clientside
	mode enabled.
--]]

pStub.Register("PIC", {
	Enabled = true,
	Name = "PIC",
	Description = "Checks the players pre-init variables and generates a checksum to verify integrity.",
	Category = "Integrity",
	
	Message = "Bad PIC Checksum: {Contact}",
	
	Method = PUNISHMENT_KICK,
	
	PIC = "387594818",
	Await = 24
})

--- Stack ---

--[[
	This check builds a custom stack frame and then verifies that
	the stack frame is properly setup through stack traversal. Flags
	a lot of detours.
]]--

pStub.Register("Stack", {
	Enabled = true,
	Name = "Stack",
	Description = "Occurs when a player uses a bypass on the debug library.",
	Category = "Integrity",
	
	Client = true,
	
	Message = "Bad Stack Frame: {Contact}",
	
	Method = PUNISHMENT_KICK
})

--- Key Input ---

pStub.Register("Key Input", {
	Enabled = true,
	Name = "Key Input",
	Description = "Checks input compared to key inputs to verify the player actually pressed a key.",
	Category = "Integrity",
	
	Client = true,
	
	Method = PUNISHMENT_LOG
})

--- Static Script ---

pStub.Register("Static Script", {
	Enabled = true,
	Name = "Static Script",
	Description = "Occurs when cheat file traces are left on a players computer.",
	Category = "Integrity",
	
	Client = true,
	
	Message = "Likely Cheater: {Contact}",
	
	Method = PUNISHMENT_KICK
})

--- Error Tracer ---

pStub.Register("Error Tracer", {
	Enabled = true,
	Name = "Error Tracer",
	Description = "Occurs when a player uses a bypass or an addon is overriding a function incorrectly.",
	Category = "Integrity",
	
	Client = true,
	
	Message = "Error: {Contact}",
	
	Method = PUNISHMENT_KICK
})

--- Libraries ---

pStub.Register("Libraries", {
	Enabled = true,
	Name = "Libraries",
	Description = "Occurs when the integrity of libraries during the player joining cannot be verified, may false flag addons.",
	Category = "Integrity",
	
	Client = true,
	
	Message = "Library Failure: {Contact}",
	
	Method = PUNISHMENT_KICK
})

--- Scans ---

pStub.Register("Binaries", {
	Enabled = true,
	Name = "Binaries",
	Description = "Occurs when a player uses a C++ module ingame through the require system, may false flag some addons.",
	Category = "Scans",
	
	Client = true,
	
	Message = "Bad Module: {Contact}",
	
	Method = PUNISHMENT_KICK
})

pStub.Register("Hooks", {
	Enabled = true,
	Name = "Hooks",
	Description = "Occurs when the player has a hook registered from the blacklist.",
	Category = "Scans",
	
	Client = true,
	
	Message = "Bad Hook: {Contact}",
	
	Method = PUNISHMENT_KICK
})