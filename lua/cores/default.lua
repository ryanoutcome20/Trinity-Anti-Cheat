return "Default", {
	Valid = function()
		return true
	end,

	Ban = function(Player, Reason, Time)
		Player:Ban(Time, false)
		
		return game.KickID(Player:SteamID64(), Reason)
	end,
	
	BanID = function(SID, Reason, Time)
		return RunConsoleCommand("banid", SID, Time, Reason)
	end,
	
	Kick = function(Player, Reason)
		return game.KickID(Player:SteamID(), Reason)
	end
}