-- https://www.gmodstore.com/market/view/sam

return "SAM", {
	Valid = function()
		return istable(sam)
	end,

	Ban = function(Player, Reason, Time)
		return sam.player.ban(Player, Time, Reason)
	end,
	
	BanID = function(SID, Reason, Time)
		return sam.player.ban_id(SID, Time, Reason)
	end,
	
	Kick = function(Player, Reason)
		-- SAM is just an annoying wrapper here.
		-- see: lua/sam/player/sv_player.lua
		return Player:Kick(Reason)
	end
}