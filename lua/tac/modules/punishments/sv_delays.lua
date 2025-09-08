function TAC.Punishment.Delay(Token)
	if not Token or not Token.Delay then
		return false
	end
	
	if Token.Method == PUNISHMENT_LOG and Token.DelayIgnoreLogOnly then
		return false
	end

	-- Get time.
	Token.Timer = math.random(Token.DelayMinimum, Token.DelayMaximum)
		
	-- Get formatted.
	local Formatted = tFormat(Token, Token.formatDelayedPunishment)
		
	-- Log.
	Token.Player:tLog(
		"DELAY", 
		Formatted
	)
	
	TAC.Tell(
		Formatted,
		Token.Alerts.Delays,
		NOTIFY_GENERIC,
		TAC.Config.Alerts.Sounds.Important,
		Token.Player
	)
	
	-- Main timer.
	timer.Create(TAC.Punishment.ID(Token.SID), Token.Timer, 1, function()
		if not Token then
			return TAC.Print("Delayed punishment missing token!")
		end
		
		if Token.Player and IsValid(Token.Player) then
			TAC.Execute(Token, true)
		elseif Token.DelaySID and Token.SID then
			TAC.ExecuteSID(Token)
		end
	end)
	
	return true
end

function TAC.Punishment.IsActive(Player)
	local ID = TAC.Punishment.ID(Player:SteamID64())
	
	return timer.Exists(ID), ID
end