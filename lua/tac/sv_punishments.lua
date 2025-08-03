TAC.Punishment = { }

--- Registers ---

function TAC.Punishment.Register(ID, Token)
	-- We just shove these into the config for later use.
	
	local Fallback = TAC.Config.Fallback or { }
	
	for k,v in pairs(Fallback) do 
		if Token[k] == nil then
			Token[k] = v
		end
	end
	
	TAC.Config[ID] = Token	
end

function TAC.Punishment.LoadStubs()
	for k, Data in pairs(pStub.Registers) do 
		TAC.Punishment.Register(
			Data.ID,
			Data.Token
		)
		
		TAC.Print("%s loaded from pStubs!", Data.ID)
	end
end

--- Evaluate ---

function TAC.Punishment.Valid(Player, Config, isToken)
	if isToken then
		Player = Config.Player
	end

	if not IsValid(Player) or not Player:IsPlayer() then
		return
	end
	
	-- Global Checks.
	
	if TAC.Config.Punishment.ignoreStaff and TAC.IsStaff(Player) then
		return
	end
	
	if TAC.Config.Punishment.globalFilter and not TAC.globalFilterCallback(Player, Config) then
		return
	end
	
	-- Config Checks.
	
	if not Config.Enabled then
		return
	end
	
	if Config.Ping ~= -1 and Player:Ping() >= Config.Ping then
		return
	end
	
	if Config.Loss ~= -1 and Player:PacketLoss() >= Config.Loss then
		return
	end
	
	if Config.Vehicles and Player:InVehicle() then
		return
	end
	
	return true
end

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
		Token.formatEvaluate(Token),
		Token.Alerts.Evaluate,
		NOTIFY_GENERIC,
		TAC.Config.Alerts.Sounds.Notify,
		Player
	)

	return usingFallback and EVALUATE_FALLBACK or EVALUATE_SUCCESS, Token
end

--- Flags ---

function TAC.Punishment.Flag(Token)
	-- We just take this and evaluate it for the
	-- execution function.
	
	if not Token.Flags then
		return true
	end
	
	local Player = Token.Player
	
	Token.flagsCount = Player:Grab(Token.ID, 0) + 1
	
	if Player:Set(Token.ID, Token.flagsCount) >= Token.Maximum then
		Player:Set(Token.ID, 0)
		return true
	end
	
	if Token.Decay ~= -1 then
		TAC.Timer(Player, Token.Decay, function(Player)
			Player:Set(Token.ID, math.max(Player:Grab(Token.ID, 0) - 1, 0))
		end)
	end
	
	if Token.alertFlagsMinimum <= Token.flagsCount then
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

--- Execute ---

function TAC.Punishment.Backend(Token)
	local Backend = TAC.Backends[string.lower(Token.Backend)]
	
	if not Backend then
		TAC.Print("No backend for punishment! (%s -> %s, doesn't exist)", Token.ID, Token.Backend)
		return TAC.Backends.default
	elseif not Backend.Valid() then
		TAC.Print("Invalid backend for punishment! (%s -> %s, valid failed)", Token.ID, Token.Backend)
		return TAC.Backends.default
	end
	
	return Backend
end

function TAC.Execute(Token)
	if not Token then
		return EXECUTE_FAILED
	end
	
	local Player = Token.Player
	
	if not IsValid(Player) then
		return EXECUTE_FAILED
	end

	if not TAC.Punishment.Valid(nil, Token, true) then
		return EXECUTE_BYPASSED
	end
	
	if not TAC.Punishment.Flag(Token) then
		return EXECUTE_FLAG
	end

	-- Log.
	Player:tLog(
		"PUNISHMENT", 
		Token.formatPunishment(Token)
	)

	if Token.Method == PUNISHMENT_LOG then
		return EXECUTE_SUCCESS
	end
	
	TAC.Tell(
		Token.formatPunishment(Token),
		Token.Alerts.Punishment,
		NOTIFY_GENERIC,
		TAC.Config.Alerts.Sounds.Punishment,
		Player
	)

	-- Get message.
	local Message = tFormat(Token)

	-- Run punishment.
	local Backend = TAC.Punishment.Backend(Token)
	
	if not Backend then
		return
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

	return EXECUTE_SUCCESS
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

--- End ---

concommand.Add("tac_pstubs", TAC.Punishment.LoadStubs)

TAC.Punishment.LoadStubs()