--[[ ~~~~~~~~~~~~~~~~~~ ]]--
--[[ Trinity Anti-Cheat ]]--
--[[ ~~~~~~~~~~~~~~~~~~ ]]--

-- Don't touch these.
local Config = { }

TAC.Config = Config

--- Interpolated Strings ---

--[[
	{Name}
	{SteamID64}
	{SteamID}
	{IP}
	{Ping}
	{Position}
	{Angle}
--]]

--- Logging ---

Config.Logging = {
	Console = true,
	DB = false,
	File = true, 
	
	dbCreate = function()
		return "CREATE TABLE IF NOT EXISTS trinity_db( sid TEXT, type TEXT, text TEXT )"
	end,
	
	dbQuery = function(User, Type, Message)
		return string.format(
            "INSERT INTO trinity_db( sid, type, text ) VALUES( %s, %s, %s )",
            sql.SQLStr(User:SteamID64()),
            sql.SQLStr(Type),
            sql.SQLStr(Message)    
        )
	end,
	
	Callback = function(User, Type, Text)
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
	Fallback = {
		
	},
}


return Config