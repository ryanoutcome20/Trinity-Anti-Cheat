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
		
		formatFlags = function(Token)
			return tFormat(
				Token,
				"{Name} [{SteamID64}] was flagged for \"{Info}\" ({ID})!"
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
	
	Distance = 35,
	useTwoTarget = false,
	
	Flags = true,
	Maximum = 6,
	Decay = 3,
	
	Vehicles = true,
	Ping = 90,
	Loss = 80
})

--- Aimbot Breakers ---

--- ...
-- TODO: Interp VA, C Clicker

Config.aimbotBreakers = {

}