function TAC.Punishment.Flag(Token)
	-- We just take this and evaluate it for the
	-- execution function.
	
	if not Token.Flags then
		return true
	end
	
	Token.Increment = Token.Increment or 1
	Token.FlagsCount = Token.Player:Get(Token.ID, 0) + Token.Increment
	
	if Token.Player:Set(Token.ID, Token.FlagsCount) >= Token.Maximum then
		TAC.Punishment.ResetFlags(Token.Player, Token.ID)
		return true
	end
	
	if Token.Decay ~= -1 then
		TAC.Timer(
			Token.Player, 
			Token.Decay, 
			function(self)
				self:Set(
					Token.ID, 
					math.max(
						self:Get(Token.ID, 0) - Token.Increment, 
						0
					)
				)
			end
		)
	end
	
	if Token.AlertFlagsMinimum <= Token.FlagsCount then
		TAC.Tell(
			TAC.Format(Token, Token.FormatFlags),
			Token.Alerts.Flags,
			NOTIFY_GENERIC,
			TAC.Config.Alerts.Sounds.Important,
			Token.Player
		)
	end
	
	return false
end

function TAC.Punishment.ResetFlags(Player, ID)
	Player:Set(ID, 0)
end