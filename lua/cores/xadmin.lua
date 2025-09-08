-- https://github.com/TheXYZNetwork/xAdmin

return "xAdmin", {
	Valid = function()
		return istable(xAdmin)
	end,

	Ban = function(Player, Reason, Time)
		return xAdmin.Database.CreateBan(Player:SteamID64(), Player:Nick(), "", "", Reason, Time * 60, function() end)
	end,
	
	BanID = function(SID, Reason, Time)
		return xAdmin.Database.CreateBan(SID, "Unknown", "", "", Reason, Time * 60, function() end)
	end,
	
	Kick = function(Player, Reason)
		-- Wrapper with fancy print message.
		-- https://github.com/TheXYZNetwork/xAdmin/blob/d54527de884390758999469e1bdab42f428e4342/lua/xadmin/commands/discipline.lua#L33
		return game.KickID(Player:SteamID(), Reason)
	end
}