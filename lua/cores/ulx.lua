-- https://github.com/TeamUlysses/ulx

return "ULX", {
	Valid = function()
		return istable(ULib)
	end,

	Ban = function(Player, Reason, Time)
		return ULib.ban(Player, Time, Reason)
	end,
	
	BanID = function(SID, Reason, Time)
		return ULib.addBan(SID, Time, Reason)
	end,
	
	Kick = function(Player, Reason)
		return ULib.kick(Player, Reason)
	end
}