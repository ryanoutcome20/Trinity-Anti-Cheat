--[[ ~~~~~~~~~~~~~~~~~~ ]]--
--[[ Trinity Anti-Cheat ]]--
--[[ ~~~~~~~~~~~~~~~~~~ ]]--

-- Don't touch these.
local Config = { }

TAC.Config = Config

--- Interpolated Strings ---

--[[
	Default Player Strings:
	
	These only function if a player is provided (IE: punishment context, etc).

	{Name} - Provides the name of a player.
	{SteamID64} - Provides the SteamID64 of a player.
	{SteamID} - Provides the SteamID of a player.
	{IP} - Provides the IP of a player in non-port (1.1.1.1) form.
	{Ping} - Provides the ping of a player.
	{Loss} - Provides the packet loss of a player.
	{Position} - Provides the position (x y z) of a player.
	{Angle} - Provides the angle (x y r) of a player.
--]]

--[[
	Default Token Strings:
	
	These only function if a token is provided (punishment context).

	{Info} - Punishment reason.
	{ID} - Punishment config ID.
--]]

--[[
	Flags Specific Strings:

	This only functions when in the FormatFlags context.

	{Flags} - The number of flags total a player has received for this config ID. 
--]]

--[[
	Delayed Punishment Specific Strings:

	This only functions when in the FormatDelayedPunishment context.

	{Timer} - The time until the punishment executes.
--]]

--[[
	Default Global Strings:

	This function always, they provide global context for the server.

	{Contact} - Contact string (Config.Contact).
	{Map} - Map.
	{Gamemode} - Gamemode name.
--]]

--- General ---

-- Contact text used when {Contact} interpolated string is used.
Config.Contact = "github.com/ryanoutcome20/Trinity-Anti-Cheat/"

--[[
	When patching text sent from the clientside this will be the maximum
	size cap to the text. This prevents someone from spamming your logs
	with endless text.
--]]
Config.Sanitization = 120

--- Staff ---

Config.Staff = {
	Roles = {
		admin = true,
		operator = true,
		superadmin = true
	},
	
	IDs = {
		-- ["SteamID64"] = true,
		-- ["SteamID"] = true
	},

	IPs = {
		-- ["1.1.1.1"] = true
	}
}

--- Audits ---

--[[
	Handles giving server administrators a pointer to look into a player due
	to specific check failures or clientside issues (often bypasses or attempts).

	Set timeout to -1 to disable timeouts completely (not recommended).
--]]

Config.Audits = {
	Enabled = true,
	Timeout = 5
}

--- StartCommandPlus ---

--[[
	This uses a bit more of an advanced angle system instead of
	using CUserCMD's angle system. 
	
	The issue with these more accurate angles is that they are 
	extremely unoptimized to generate and can result in poor 
	performance.
	
	Unless you are allowing world clicker its probably best
	to stay away.
	
	It is ~314% slower to use this method of angles.
--]]

Config.AccurateAngles = false

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
	File = true,
	DB = false,
	
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
	IgnoreStaff = false,

	GlobalFilter = false,
	GlobalFilterCallback = function(Player, Config)
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
		Backend = "ULX", -- See "cores/" for adding new ones.
		Method = PUNISHMENT_LOG,
		Message = "Unfair Advantage: {Contact}",
		Time = 0,

		-- Flag section.
		Flags = false,
		Maximum = 3,
		Decay = -1,
		
		AlertFlagsMinimum = 0,
		
		-- Delay section.
		Delay = false,
		DelayMinimum = 1,
		DelayMaximum = 10,
		DelaySID = true,
		DelayIgnoreLogOnly = true,
		
		-- Alert section.
		Alerts = {
			Evaluate = ALERT_NONE,
			Flags = ALERT_STAFF,
			Delays = ALERT_STAFF,
			Punishment = ALERT_EVERYONE
		},
		
		-- Formats.
		FormatEvaluate = "{Name} [{SteamID64}] was evaluated for \"{Info}\" ({ID})!",	
		FormatFlags = "{Name} [{SteamID64}] was flagged for \"{Info}\" ({ID})! [{Flags}]",
		FormatPunishment = "{Name} [{SteamID64}] was punished for \"{Info}\" ({ID})!",
		FormatDelayedPunishment = "{Name} [{SteamID64}] is about to be punished for \"{Info}\" ({ID})! [{Timer}s]",
		FormatLog = "{Name} [{SteamID64}] was logged for \"{Info}\" ({ID})!",
		
		-- Avoidance
		Ping = -1,
		Loss = -1,
		Sensitivity = -1,
		Vehicles = false,
		Water = false,
		Noclip = false,
		SWEPs = {
			-- ...
			-- weapon_smg1 = true
		},

		-- Extra
		Verbose = false,
		Callback = function(self) 
			return false
		end
	}),
}

--- Networking ---

--[[
	Delay handles the initial transfer delay, in other words, how long the
	server will take after the player spawns to begin transferring files
	to them.

	Step handles the speed in which each file transfer will occur.
--]]

Config.Networking = {
	Delay = 2,
	Step = 0.5
}

--[[
	This usually occurs when the client manipulates data before sending it to
	the serverside. It can occur from both "detours" and "network" modules.

	Detours throws a client integrity when it sends a batch of functions that
	are empty. This doesn't happen normally and is either an addon conflict or
	is a bypass attempt.

	The network module throws it from receiving invalid flags; this also shouldn't
	happen. And will only occur with an addon conflict or bypass attempt.
--]]

pStub.Register("Client Integrity", {
	Enabled = true,
	Name = "Client Integrity",
	Description = "Occurs when invalid data is sent to the server from the clientside. Can occur from various modules.",
	Category = "Networking",
	
	Method = PUNISHMENT_BAN
})

--- Aimbots ---

--[[
	This occurs when CUserCMD reports angles outside of the limit
	of the engine (89 pitch & 180 yaw). Depending on the addons 
	you have, this can false flag quite a bit.

	Adjust the MaxPitch/MaxYaw to reduce false positives if you have an
	addon confliction.
--]]

pStub.Register("Angles", {
	Enabled = true,
	Name = "Angles",
	Description = "Detects invalid source engine angles.",
	Category = "Aimbot",
	
	Method = PUNISHMENT_BAN,
	
	CheckPitch = true,
	MaxPitch = 90,
	CheckYaw = true,
	MaxYaw = 180,

	TimeSinceCreated = 25,
	
	Vehicles = true
})

--[[
	This occurs when a player snaps to another player in a single tick. The 
	"delta" of the tick, or difference between this angle and the last angle,
	will be what stops it from false flagging.

	Beware of aimbot addons or similar things. Teleportation addons can also
	cause some degree of false positives if they make you look at the person you
	teleport to.
--]]

pStub.Register("Snap", {
	Enabled = true,
	Name = "Snap",
	Description = "Detects snapping to players in a single tick.",
	Category = "Aimbot",
	
	Method = PUNISHMENT_BAN,
	
	Delta = 35,
	Distance = 10000,
	TimeSinceSpawned = 3.5,
	
	Flags = true,
	Maximum = 2,
	Decay = 1,
	
	Vehicles = true,
	Ping = 250,
	Loss = 90
})

--[[
	This occurs when a player is updating angles but not updating the 
	MouseX/MouseY input handlers from the engine. This is unlikely
	to false positive unless someone manually edits them.
--]]

pStub.Register("Mouse", {
	Enabled = true,
	Name = "Mouse",
	Description = "Detects invalid MouseX/MouseY values compared to angle changes.",
	Category = "Aimbot",
	
	Method = PUNISHMENT_BAN,
	
	InputlessDeltaMax = 2.5,
	InputlessDeltaMin = 0.25,
	FarDelta = 15,
	Distance = 8000,
	
	Flags = true,
	Maximum = 4,
	Decay = 0.5,
	
	AlertFlagsMinimum = 2,

	Vehicles = true,
	Ping = 250,
	Loss = 90,
	Sensitivity = 0.5
})

--[[
	This occurs when a player has a "shaky" angle delta over another player. It
	can occur due to various factors such as recoil or spread cheats. Unlikely
	to false positive.
--]]

pStub.Register("Micromovement", {
	Enabled = true,
	Name = "Micromovement",
	Description = "Detects strange stuttery movement within a players view angles.",
	Category = "Aimbot",
	
	Method = PUNISHMENT_BAN,
		
	Delta = 0.01,
	LowOffset = 0.000001,
	HighOffset = 0.75,
	HighIncrement = 3,
	Distance = 2000,
	
	Flags = true,
	Maximum = 4,
	Decay = 0.5,
	
	AlertFlagsMinimum = 2,

	Vehicles = true,
	Ping = 250,
	Loss = 90,
	Sensitivity = 0.5
})

--[[
	This occurs when a player is clicking as fast as the engine will allow. Most
	commonly triggered by rapidfire scripts, although it can be triggered through
	"double click" methods like butterfly clicking. 

	While unlikely, any detection can still can be a false positive.
--]]

pStub.Register("Autoclicker", {
	Enabled = true,
	Name = "Autoclicker",
	Description = "Detects autoclickers. Will flag external autoclickers as well.",
	Category = "Aimbot",
	
	Message = "Autoclicker: {Contact}",

	Method = PUNISHMENT_KICK,
	
	ResetOnFailure = false,
	
	Flags = true,
	Maximum = 35,
	Decay = 1.0,
	
	Alerts = {
		Flags = ALERT_NONE
	}
})

--- Movement ---

--[[
	This occurs when a player lands perfect bunny hops back-to-back. If you have
	a very good player they can actually false flag this, so beware.

	LTT is Last Touch Time, which handles avoiding collision-based false positives.
--]]

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

--[[
	This occurs when the movement of a player flip flops between the same value
	back to back (IE: 1000, -1000, 1000, -1000, etc). Unlikely to false flag.
--]]

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

--[[
	This occurs when a player has a movement value that isn't clamped to one
	that the engine will use. Can false flag when interacting with predicted
	entities (prediction errors).
--]]

pStub.Register("Input", {
	Enabled = true,
	Name = "Input",
	Description = "Detects players who are using something to manipulate their movement vectors.",
	Category = "Movement",
	
	Message = "Movement Vector Error: {Contact}",
	
	Method = PUNISHMENT_KICK,
	
	Minimum = 1000,
	LTT = 2.5,

	Vectors = {
		[2500] = true,
		[5000] = true,
		[7500] = true,
		[10000] = true
	},
	
	Flags = true,
	Maximum = 12,
	Decay = 8,
	
	Alerts = {
		Flags = ALERT_NONE
	},
	
	Ping = 250,
	Loss = 90,
	Vehicles = true,
	Water = true
})

--- Exploits ---

--[[
	This occurs when a player either breaks lerp completely (positive direction desynculator) or sets their interpolation off by
	abusing hidden console commands (cl_interpolate). You cannot naturally set your interpolation off without a module, so the risk
	of this false flagging is practically nonexistent.
--]]

pStub.Register("Interpolation Abuse", {
	Enabled = true,
	Name = "Interpolation Abuse",
	Description = "Detects two methods of interpolation abuse to catch cheaters.",
	Category = "Exploit",
	
	Method = PUNISHMENT_BAN,
	
	Overflow = true,
	
	Flags = true,
	Maximum = 4,
	Decay = 8,
	
	Ping = 250,
	Loss = 90
})

--[[
	This is a check that occurs from either command number manipulation or speedhack. It will not false flag unless the player is 
	cheating or your server uses an external module.

	You should also consider forcing sv_maxusrcmdprocessticks to a value that isn't zero. When it is at zero it allows a player to
	speedhack by sending extra commands.
--]]

pStub.Register("Speedhack", {
	Enabled = true,
	Name = "Speedhack",
	Description = "Detects speedhack on servers with sv_maxusrcmdprocessticks set to zero. May also detect other exploits.",
	Category = "Exploit",

	Method = PUNISHMENT_BAN,
	
	Flags = true,
	Maximum = 45,
	Decay = 0.15,
	
	AlertFlagsMinimum = 40,
	
	Alerts = {
		Flags = ALERT_NONE
	},
	
	Ping = 250,
	Loss = 90
})

--[[
	This is a check that occurs when a player messes with their tickcount. This usually occurs with backtrack but can also occur
	with some aimbot quality of life features like aligning simulation time with tickcount.

	It will not false flag unless the player is cheating or your server uses an external module.
--]]

pStub.Register("Tickcount", {
	Enabled = true,
	Name = "Tickcount",
	Description = "Detects tickcount manipulation to do things like backtrack.",
	Category = "Exploit",
	
	Method = PUNISHMENT_BAN,
	
	Regular = true,
	
	Negative = true,
	Range = -350,
	
	Flags = true,
	Maximum = 25,
	Decay = 5,
	
	Alerts = {
		Flags = ALERT_NONE
	},
	
	Ping = 250,
	Loss = 90
})

--[[
	This is a check that occurs when a player uses a cheat called "Desynculator". It is an engine exploit where in which you are able to
	lower your simulation time to negative values and when combined with other exploits even positive values. This can be very dangerous
	since it will break engine timers and predicted timers (in hooks such as Move).
--]]

pStub.Register("Simulation Time", {
	Enabled = true,
	Name = "Simulation Time",
	Description = "Detects players using the 'Desynculator' simulation time exploit.",
	Category = "Exploit",
	
	Message = "Simulation Time: {Contact}",
	
	Method = PUNISHMENT_BAN,
	
	TimeSinceCreated = 25,
	Low = -150,
	High = 150,
	
	Flags = true,
	Maximum = 10,
	Decay = 5,
	
	Ping = 250,
	Loss = 90
})

--[[
	This is a check that occurs when an exploit is used that allows a player to move while act taunting.

	Set CheckGamemode to false if you want this to activate on any gamemode other than sandbox.
--]]

pStub.Register("Act", {
	Enabled = true,
	Name = "Act",
	Description = "Detects players who are moving while taunting (act commands).",
	Category = "Exploit",

	Message = "Act Movement: {Contact}",

	Method = PUNISHMENT_KICK,

	CheckGamemode = false
})

--- Extras ---

--[[
	This is a check that goes off when a player changes their username. It can be used to kick players who are using
	name spoofers but will also kick players who just simply change their name on Steam.
--]]

pStub.Register("Name Changer", {
	Enabled = true,
	Name = "Name Changer",
	Description = "Detects when players change Steam username/name command, can be used to kick players if needed.",
	Category = "Extra",
	
	Method = PUNISHMENT_LOG
})

--[[
	This is a check that goes off when a player presses a specific key; it can be used to log a player who might be
	using a cheat menu (insert and delete are the most common ones).

	Maximum logs controls the amount of times the key will have to be pressed back to back in order to 
	flag (set to -1 to always flag).
--]]

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

--[[
	This is a check that goes off when a player encounters an error. Can be used to manually catch cheaters who 
	have faulty cheats.
--]]

pStub.Register("Errors", {
	Enabled = true,
	Name = "Errors",
	Description = "Logs errors, if given the option it can also scan for errors from files that aren't supposed to exist.",
	Category = "Extra",
	
	Method = PUNISHMENT_LOG
})

--[[
	This is a check that goes off when a player is too accurate. You can use this to manually detect cheaters
	by looking at the accuracy of their shots.
--]]

pStub.Register("Accuracy", {
	Enabled = false,
	Name = "Accuracy",
	Description = "Gives reports about suspicious aiming accuracy.",
	Category = "Extra",
	
	Method = PUNISHMENT_LOG,

	Distance = 1000,
	Window = 25,
	ShotWait = 0.1,
	MinimumAccuracy = 0.75
})

--- Command Enforcer ---

--[[
	Patch in this context applies a patch to fix
	shared ConVars by making sure the values are
	replicated on the server. 
	
	For each ConVar you wish you verify you have
	a few options:

		- Value: This is the value that will be verified by the anti-cheat.
		- Patch: This makes the value replicated, it'll dynamically grab it from the server instead of using a static number.
		- Log: Logs instead of banning, useful for ConVars that can be changed by the client.

	Interval is the amount of time between each check of the commands.

	Await is the amount of time until the server verifies that commands have been sent. Keep this lower than the interval.
--]]

pStub.Register("Command Enforcer", {
	Enabled = true,
	Name = "Command Enforcer",
	Description = "Enforces console commands that shouldn't be changable without cheats.",
	Category = "Commands",
	
	Message = "Bad Command: {Contact}",
	
	Method = PUNISHMENT_KICK,
	
	Commands = {
		["sv_cheats"] = {
			Value = "0",
			Patch = true,
			Log = false
		},

		["sv_allowcslua"] = {
			Value = "0",
			Patch = true,
			Log = false
		}
	},
	
	Interval = 50,
	Await = 25,
	
	Flags = false,
	Maximum = -1,
	Decay = -1,
})

--- Interpolated View Angles ---

--[[
	What this does is break aimbots and other cheats by desyncing
	view angles between client and server. To see what it does to
	aimbot cheats you can checkout the offical TAC `Aimbot Breaker`
	showcase:

	https://www.youtube.com/watch?v=xNqrlCG11Ws

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
	What this does is break ESP by not sending entity information down to
	clients from the server when the player isn't visible to one of the 
	nodes around the target player. Check out the showcase to see what these
	nodes look like:

	https://www.youtube.com/watch?v=Nwy0jQc8S4Y

	This may come with a moderate to severe proformance impact depending on
	the size of the server and the amount of players present in the players
	default PVS.
	
	This will never add onto the PVS, just remove. Also won't ever effect
	entities, just players.
]]--

Config.PVS = {
	Enabled = true,
	
	squareSize = 1,
	squaredSize = 256,
	intervalScale = 128,
	Step = 8
}

--- Menu Movement ---

--[[
	This check occurs when a player starts moving his mouse while the mouse is visible. This
	usually signifies a C++ cheat menu.

	It is unlikely to false flag, although updates and addons can affect the stability of this
	check.
--]]

pStub.Register("Menu Movement", {
	Enabled = true,
	Name = "Menu Movement",
	Description = "Occurs when the player moves their MouseX/MouseY while in an active menu.",
	Category = "Aimbot",
	
	Client = true,

	Message = "Invalid Movement: {Contact}",
	
	Method = PUNISHMENT_KICK,
	
	Flags = true,
	Maximum = 6,
	Decay = 2
})

--- Engine Prediction ---

--[[
	This check occurs when a player attempts to predict his movement for the next tick to match the
	server. This usually is done to improve aimbot accuracy although some exploits will also trigger
	this.

	Chances of false flagging are low, but not impossible depending on the addons on the server.
--]]

pStub.Register("Engine Prediction", {
	Enabled = true,
	Name = "Engine Prediction",
	Description = "Occurs when the player attempts to use an aimbot prediction.",
	Category = "Aimbot",
	
	Client = true,
	
	Method = PUNISHMENT_BAN,
	
	Flags = true,
	Maximum = 4,
	Decay = 1
})

--- Input Guard ---

--[[
	This check occurs when a player adjusts his angles without actually moving his angles naturally. 
	Due to the nature of a check like this, it is highly susceptible to addon compatibility issues.
--]]

pStub.Register("Input Guard Angles", {
	Enabled = false,
	Name = "Input Guard Angles",
	Description = "Occurs when the player is detected for manipulating angles. Likely to flag poorly coded addons.",
	Category = "Aimbot",
	
	Client = true,

	Message = "Angle Input Error: {Contact}",
	
	Method = PUNISHMENT_KICK,
	
	Flags = true,
	Maximum = 10,
	Decay = 3
})

--[[
	This check occurs when a player registers button presses without actually pressing buttons naturally. 
	Due to the nature of a check like this, it is highly susceptible to addon compatibility issues.
--]]

pStub.Register("Input Guard Buttons", {
	Enabled = false,
	Name = "Input Guard Buttons",
	Description = "Occurs when the player is detected for manipulating buttons. Unlikely to false flag.",
	Category = "Aimbot",
	
	Client = true,

	Message = "Button Input Error: {Contact}",
	
	Method = PUNISHMENT_KICK,

	Flags = true,
	Maximum = 4,
	Decay = 3
})

--[[
	This check occurs when a player updates his movement values without actually moving naturally.
	Due to the nature of a check like this, it is highly susceptible to addon compatibility issues.
--]]

pStub.Register("Input Guard Movement", {
	Enabled = false,
	Name = "Input Guard Movement",
	Description = "Occurs when the player is detected for manipulating movement values. Likely to flag poorly coded addons.",
	Category = "Aimbot",
	
	Client = true,

	Message = "Movement Input Error: {Contact}",
	
	Method = PUNISHMENT_KICK,

	Flags = true,
	Maximum = 15,
	Decay = 3
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
		
	Method = PUNISHMENT_BAN
})

--- Honeypot ---

--[[
	This check acts like popular anti-cheat addons and tries to see if they are
	bypassed or accessed in any weird ways. Detects a lot of older cheats and
	some security scripts.

	Wait handles the delay between times the client can request a punishment.
--]]

pStub.Register("Honeypot", {
	Enabled = true,
	Name = "Honeypot",
	Description = "Emulates popular anti-cheat plugins to detect players attempting bruteforce bypasses.",
	Category = "Integrity",
	
	Message = "Compatibility Error: {Contact}",

	Method = PUNISHMENT_KICK,

	Wait = 0.25
})

--- Static Script ---

--[[
	This check detects the files of known cheats. See the `cl_static.lua` list.
--]]

pStub.Register("Static Script", {
	Enabled = true,
	Name = "Static Script",
	Description = "Occurs when cheat file traces are left on a players computer.",
	Category = "Integrity",
	
	Client = true,
	
	Method = PUNISHMENT_BAN
})

--- Anti-Screengrab ---

--[[
	This check will attempt to capture a screenshot of the players view. If it 
	fails that means the screenshot (or screengrab) is being blocked. Can be used
	in combination with a screengrab addon.
--]]

pStub.Register("Anti-Screengrab", {
	Enabled = true,
	Name = "Anti-Screengrab",
	Description = "Occurs when a player blocks screengrab addons.",
	Category = "Integrity",
	
	Client = true,
	
	Message = "Screengrab Error: {Contact}",
	
	Method = PUNISHMENT_KICK
})

--- Error Tracer ---

--[[
	This check verifies that errors that occur on the clientside are matched to what
	they should be. It manually causes hidden errors to facilitate this.
--]]

pStub.Register("Error Tracer", {
	Enabled = true,
	Name = "Error Tracer",
	Description = "Occurs when a player uses a bypass or an addon is overriding a function incorrectly.",
	Category = "Integrity",
	
	Client = true,
	
	Message = "Error Issue: {Contact}",
	
	Method = PUNISHMENT_KICK
})


--- File IO ---

--[[
	This check attempts to write & delete files, if it cannot do that then the player is
	blocking file I/O through a security script like Spectre or Majestic.
--]]

pStub.Register("File IO", {
	Enabled = true,
	Name = "File I/O",
	Description = "Occurs when a player blocks file I/O.",
	Category = "Integrity",
	
	Client = true,
	
	Message = "File I/O Error: {Contact}",
	
	Method = PUNISHMENT_KICK
})

--- Debug Self ---

--[[
	This check abuses a logical flaw in security scripts to detect when a player is detouring debug
	functions and returning fake information.
--]]

pStub.Register("Debug Self", {
	Enabled = true,
	Name = "Debug Self",
	Description = "Occurs when a player uses a pre-autorun script. Uses a logical flaw in most security scripts to detect them.",
	Category = "Integrity",
	
	Client = true,
	
	Method = PUNISHMENT_BAN
})

--- Libraries ---

--[[
	This check verifies the size of libraries on the clientside when loading in. They shouldn't
	change unless another addon is also running in pre-init like us.
--]]

pStub.Register("Libraries", {
	Enabled = true,
	Name = "Libraries",
	Description = "Occurs when the integrity of libraries during the player joining cannot be verified, may false flag addons.",
	Category = "Integrity",
	
	Client = true,
	
	Message = "Library Size Error: {Contact}",
	
	Method = PUNISHMENT_KICK
})

--- Scans ---

--[[
	All of these scans are manual scans that use the lists located in `tac/lists/*`. Its recommended
	you read the description of each check and configure them accordingly.
--]]

pStub.Register("Binaries", {
	Enabled = true,
	Name = "Binaries",
	Description = "Occurs when a player uses a C++ module ingame through the require system, may false flag some addons.",
	Category = "Scans",
	
	Client = true,
	
	Method = PUNISHMENT_BAN
})

pStub.Register("Files", {
	Enabled = true,
	Name = "Files",
	Description = "Occurs when a player uses a cheat that will leave traces in the data folder.",
	Category = "Scans",
	
	Client = true,
	
	Method = PUNISHMENT_BAN
})

pStub.Register("Globals", {
	Enabled = true,
	Name = "Globals",
	Description = "Occurs when an invalid global is registered on the clientside.",
	Category = "Scans",
	
	Client = true,
	
	Method = PUNISHMENT_BAN
})

pStub.Register("Hooks", {
	Enabled = true,
	Name = "Hooks",
	Description = "Occurs when the player has a hook registered from the blacklist.",
	Category = "Scans",
	
	Client = true,
	
	Method = PUNISHMENT_BAN
})

pStub.Register("Commands", {
	Enabled = true,
	Name = "Commands",
	Description = "Occurs when the player has a command or convar registered from the blacklist.",
	Category = "Scans",
	
	Client = true,
	
	Method = PUNISHMENT_BAN
})

pStub.Register("Listener", {
	Enabled = true,
	Name = "Listener",
	Description = "Occurs when the player runs a hook that is considered blacklisted. Usually occurs with C++ modules.",
	Category = "Scans",
	
	Client = true,

	Method = PUNISHMENT_BAN
})

--- Detours ---

--[[
	This check detours things clientside and transfers them dynamically
	to the server for review. Contains various checks including emulated C
	functions, invalid sources, detoured info, etc. 
	
	Disable if its causing you issues but please report issues on the GitHub.
]]--

pStub.Register("Detours", {
	Enabled = true,
	Name = "Detours",
	Description = "Occurs when detours are triggered clientside and called from invalid files, contains C function checks as well.",
	Category = "Scans",
	
	Method = PUNISHMENT_BAN
})

--- Heartbeat ---

--[[
	This module is designed specifically to insure proper loading of the clientside.
	
	Yes, theortically if you have issues in the transfer system this will false flag 
	but ideally the hook that causes this check to start its routine won't get called
	if you have errors.

	If you tune the await timer then you should probably adjust it on the clients config
	too.

	Probably shouldn't turn this off, if you have issues make a GitHub issue.
]]--

pStub.Register("Heartbeat", {
	Enabled = true,
	Name = "Heartbeat",
	Description = "Occurs when the clientside doesn't boot properly.",
	Category = "Integrity",
	
	Message = "Failed to load! Rejoin!",

	Method = PUNISHMENT_KICK,

	Await = 30
})