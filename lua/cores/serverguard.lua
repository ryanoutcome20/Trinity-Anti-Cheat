-- https://www.gmodstore.com/market/view/serverguard

return "ServerGuard", {
	Valid = function()	
		return istable(serverguard)
	end,

	Ban = function(Player, Reason, Time)
		return serverguard:BanPlayer(nil, Player, Time, Reason, true)
	end,
	
	BanID = function(SID, Reason, Time)
		-- This API is deprecated, lacking documentation, and DRM protected.
		-- If this exists I cannot find it in the little source code I can find.
		return RunConsoleCommand("banid", SID, Time, Reason)
	end,
	
	Kick = function(Player, Reason)
		-- SG is just an annoying wrapper here.
		-- see: lua/modules/sh_commands.lua
		return game.KickID(Player:SteamID64(), Reason)
	end
}