TAC.Punishment = { }

--- Registers ---

function TAC.Punishment.Register(ID, Token)
	-- We just shove these into the config for later use.
	
	local Base = table.Copy(TAC.Config.Fallback or { })
	
	TAC.Config[ID] = table.Merge(Base, Token)
end

function TAC.Punishment.LoadStubs()
	for k, Data in pairs(pStub.Registers) do 
		TAC.Punishment.Register(
			Data.ID,
			Data.Token
		)
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
	
	if Config.Water and Player:WaterLevel() ~= 0 then
		return
	end
	
	if Config.Noclip and Player:GetMoveType() == MOVETYPE_NOCLIP then
		return
	end
	
	local SWEP = Player:GetActiveWeapon()
	
	if SWEP and IsValid(SWEP) then
		if Config[SWEP:GetClass()] then
			return
		end
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

function TAC.Punishment.Wrapper(ID, Player, Info, ...)
	local Status, Token = TAC.Punishment.Evaluate(ID, Player, Info, ...)
	
	if Status == EVALUATE_SUCCESS and Token then
		return TAC.Execute(Token)
	end
	
	return Status, Token
end

--- Flags ---

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

	local onlyLog = Token.Method == PUNISHMENT_LOG
	
	-- Log specific override stuff.
	local Formatted = onlyLog and Token.formatLog(Token) or Token.formatPunishment(Token)
	local Sound = onlyLog and TAC.Config.Alerts.Sounds.Notify or TAC.Config.Alerts.Sounds.Punishment

	-- Log.
	Player:tLog(
		"PUNISHMENT", 
		Formatted
	)

	TAC.Tell(
		Formatted,
		Token.Alerts.Punishment,
		NOTIFY_GENERIC,
		Sound,
		Player
	)

	if onlyLog then
		return EXECUTE_SUCCESS
	end

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