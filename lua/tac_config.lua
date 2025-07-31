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
		Punishment = "vo/ravenholm/madlaugh04.wav", -- Ha!
		Important = "npc/roller/mine/rmine_taunt1.wav",
		Notify = "npc/roller/mine/rmine_blip1.wav",
		Error = "npc/roller/mine/rmine_blip3.wav"
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
		Enabled = true,
		Name = "Fallback",
		Description = "",
		Category = "None",
		
		-- Punishment section.
		Backend = "ULX", -- See "backends/" for adding new ones.
		Method = PUNISHMENT_BAN,
		Message = "Unfair Advantage: {Contact}",
		Time = 0,

		-- Flag section.
		Flags = false,
		Maximum = 3,
		Decay = -1,
		
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
				"{Name} [{SteamID64}] was evaluated for \"{Info}\"!"
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


return Config