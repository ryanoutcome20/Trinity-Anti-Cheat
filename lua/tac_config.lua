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
	
	dbCreate = function()
		return "CREATE TABLE IF NOT EXISTS trinity_db( sid TEXT, type TEXT, text TEXT )"
	end,
	
	dbQuery = function(Player, Type, Message)
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
		
		-- Punishment section.
		Backend = "ULX", -- See "backends/" for adding new ones.
		Method = PUNISHMENT_LOG,
		Message = "Unfair Advantage: {Contact}",
		Time = 0,

		-- Flag section.
		Flags = false,
		Maximum = 3,
		Decay = -1,
		
		alertFlagsMinimum = 0,
		
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
		
		-- Avoidance
		Ping = -1,
		Loss = -1,
		Vehicles = false,

		-- Extra
		-- ...
	}),
}

--- Aimbots ---

pStub.Register("Angles", {
	Enabled = false,
	Name = "Angles",
	Description = "Detects invalid source engine angles.",
	Category = "Aimbot",
	
	Method = PUNISHMENT_KICK,
	
	checkPitch = true,
	maxPitch = 90,
	checkYaw = true,
	maxYaw = 180,
	
	Vehicles = true
})

pStub.Register("Snap", {
	Enabled = true,
	Name = "Snap",
	Description = "Detects snapping to players in a single tick.",
	Category = "Aimbot",
	
	Method = PUNISHMENT_KICK,
	
	Delta = 35,
	Distance = 5000,
	useTwoTarget = false,

	Flags = true,
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
	
	iDeltaMax = 1.0,
	iDeltaMin = 0.5,
	fDelta = 15,
	Distance = 5000,
	
	Flags = true,
	Maximum = 10,
	Decay = 4,
	
	alertFlagsMinimum = 8,
	
	Vehicles = true,
	Ping = 150,
	Loss = 80
})

--- Movement ---

--- Exploits ---

pStub.Register("Interpolation Abuse", {
	Enabled = false,
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
	
	alertFlagsMinimum = 40,
	
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
	Maximum = 10,
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
	
	Message = "Timed Out",
	
	Method = PUNISHMENT_KICK,
	
	Low = -150,
	High = 150,
	
	Flags = true,
	Maximum = 10,
	Decay = 5,
	
	Ping = 250,
	Loss = 80
})

--- Interpolated View Angles ---

--[[
	This will cause prediction issues but considering how low
	the TPS of most Garry's Mod servers are anyway it shouldn't
	effect the player as much as it effects the cheats.
]]--

Config.Interpolated = {
	Enabled = true,
	
	Ratio = 0.25,
	Randomize = true,
	
	Whitelisted = {
		weapon_physgun = false,
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
	
	Ticks = 16,
	pingScale = 0.80,
	squaredSize = 16
}