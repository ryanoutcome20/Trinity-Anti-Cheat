function TAC.Punishment.Backend(Token)
	pLib:SetCore(string.lower(Token.Backend))
	
	return pLib
end

function TAC.Execute(Token, noDelay)
	if not Token then
		return EXECUTE_FAILED, false
	end
	
	local Player = Token.Player
	
	if not IsValid(Player) then
		return EXECUTE_FAILED, false
	end

	if not TAC.Punishment.Valid(nil, Token, true, noDelay) then
		return EXECUTE_BYPASSED, false
	end
	
	if not TAC.Punishment.Flag(Token) then
		return EXECUTE_FLAG, false
	end

	local onlyLog = Token.Method == PUNISHMENT_LOG
	
	-- Check for delays.
	if not noDelay and TAC.Punishment.Delay(Token) then
		return EXECUTE_SUCCESS, false
	end
	
	-- Log specific override stuff.
	local Formatted = onlyLog and tFormat(Token, Token.formatLog) or tFormat(Token, Token.formatPunishment)
	local Sound = onlyLog and TAC.Config.Alerts.Sounds.Notify or TAC.Config.Alerts.Sounds.Punishment

	-- Log.
	Player:tLog(
		"PUNISHMENT", 
		Formatted
	)

	TAC.Tell(
		Formatted,
		Token.Alerts.Punishment,
		NOTIFY_ERROR,
		Sound,
		Player
	)

	if onlyLog then
		return EXECUTE_SUCCESS, true
	end

	-- Get message.
	local Message = tFormat(Token)

	-- Run punishment.
	local Backend = TAC.Punishment.Backend(Token)
	
	if not Backend then
		return EXECUTE_FAILED, false
	end
		
	if Token.Method == PUNISHMENT_BAN then
		Backend.Ban(
			Token.Player,
			Message,
			Token.Time
		)
	else
		Backend.Kick(
			Token.Player,
			Message
		)
	end

	return EXECUTE_SUCCESS, false
end

function TAC.ExecuteSID(Token)
	-- The issue with supporting this is that I cannot even verify if the
	-- user is staff or whatnot. This is an API function. Don't use this
	-- unless you are SURE the user is meant to be punished.
	
	local Backend = TAC.Punishment.Backend(Token)
	
	if Token.Method == PUNISHMENT_BAN then
		Backend.BanID(
			Token.SID,
			Token.Message,
			Token.Time
		)
	else
		TAC.Print("Was going to kick player but early disconnect: \"%s\"", Token.SID)
	end
end