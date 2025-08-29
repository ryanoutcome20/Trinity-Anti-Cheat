function TAC.Punishment.Flag(Token)
	-- We just take this and evaluate it for the
	-- execution function.
	
	if not Token.Flags then
		return true
	end
	
	local Increment = Token.Increment or 1
	local Player = Token.Player
	
	Token.FlagsCount = Player:Grab(Token.ID, 0) + Increment
	
	if Player:Set(Token.ID, Token.FlagsCount) >= Token.Maximum then
		Player:Set(Token.ID, 0)
		return true
	end
	
	if Token.Decay ~= -1 then
		TAC.Timer(Player, Token.Decay, function(Player)
			Player:Set(Token.ID, math.max(Player:Grab(Token.ID, 0) - Increment, 0))
		end)
	end
	
	if Token.AlertFlagsMinimum <= Token.FlagsCount then
		TAC.Tell(
			Token.formatFlags(Token),
			Token.Alerts.Flags,
			NOTIFY_GENERIC,
			TAC.Config.Alerts.Sounds.Important,
			Player
		)
	end
	
	return false
end

function TAC.Punishment.ResetFlags(Player, ID)
	Player:Set(ID, 0)
end