function TAC.Punishment.Evaluate(ID, Player, Info, ...)
	if not ID or not Player or not Info then
		return EVALUATE_FAILED, nil
	end

	Info = string.format(Info, ...)

	local Config = TAC.Config[ID]
	local usingFallback = false

	if not Config then
		Config = TAC.Config.Fallback
		usingFallback = true
	end

	Config = table.Copy(Config)

	if not TAC.Punishment.Valid(Player, Config) then
		return EVALUATE_BYPASSED, nil
	end

	local Token = {
		ID = ID,
		Player = Player,
		SID = Player:SteamID64(),
		Info = Info
	}

	table.Merge(Token, Config, true)
		
	TAC.Tell(
		tFormat(Token, Token.formatEvaluate),
		Token.Alerts.Evaluate,
		NOTIFY_HINT,
		TAC.Config.Alerts.Sounds.Notify,
		Player
	)
	
	if Token.Verbose then
		TAC.Verbose.Dump(Player)
	end

	return usingFallback and EVALUATE_FALLBACK or EVALUATE_SUCCESS, Token
end