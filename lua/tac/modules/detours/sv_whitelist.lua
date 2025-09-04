function TAC.Detours.Whitelisted(Player, Source, What)	
	if Source ~= "LuaCmd" then
		return false
	end
		
	if What == "Lua" then
		return true
	end
	
	local Amount = Player:Grab("Whitelist Counter", 0)
	
	if Amount == 0 then
		return false
	end
	
	Player:Set("Whitelist Counter", math.max(Amount - 1, 0)) 
	
	return true
end

function TAC.Detours.IncrementWhitelist(Player)
	Player:Set("Whitelist Counter", Player:Grab("Whitelist Counter", 0) + 1)
end

local BroadcastLua = BroadcastLua

_G.BroadcastLua = function(Code, ...)
	for k, Player in ipairs(player.GetHumans()) do 
		TAC.Detours.IncrementWhitelist(Player)
	end
	
	return BroadcastLua(Code, ...)
end

local Player = FindMetaTable("Player")
local SendLua = Player.SendLua

Player.SendLua = function(self, Code, ...)
	TAC.Detours.IncrementWhitelist(self)

	return SendLua(self, Code, ...)
end