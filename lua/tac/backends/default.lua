return "Default", {
	Valid = function()
		return true
	end,

	Ban = function(Player, Reason, Time)
		Player:Ban(Time, false)
		
		return Player:Kick(Reason)
	end,
	
	BanID = function(SID, Reason, Time)
		return RunConsoleCommand("banid", SID, Time, Reason)
	end,
	
	Kick = function(Player, Reason)
		return Player:Kick(Reason)
	end
}