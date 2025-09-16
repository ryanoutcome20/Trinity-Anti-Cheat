function TAC.Breakers.Spread(Player, Data)
	local Config = TAC.Config.Spread
	
	if not Config.Enabled then
		return
	end
	
	Data.Spread = Data.Spread * (1 + math.Rand(Config.Minimum, Config.Maximum))
	
	return true
end

hook.Add("EntityFireBullets", "TAC.Breakers.Spread", TAC.Breakers.Spread)