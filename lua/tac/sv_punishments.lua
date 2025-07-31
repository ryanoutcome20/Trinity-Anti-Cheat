TAC.Punishment = { }

TAC.Enum(
	"PUNISHMENT_IGNORE",
	"PUNISHMENT_LOG",
	"PUNISHMENT_KICK",
	"PUNISHMENT_BAN"
)

TAC.Enum(
	"BACKEND_DEFAULT",
	"BACKEND_ULX",
	"BACKEND_SAM",
	"BACKEND_CUSTOM"
)

TAC.Enum(
	"FUN_NONE"
)

TAC.Enum(
	"EVALUATE_FAILED",
	"EVALUATE_FALLBACK",
	"EVALUATE_SUCCESS",
	"EVALUATE_BYPASSED",
	"EVALUATE_FORCED"
)

--- Registers ---

function TAC.Punishment.Register(ID, Token)
	-- We just shove these into the config for later use.
	
	local Fallback = TAC.Config.Fallback or { }
	
	TAC.Config[ID] = table.Merge(
		Fallback,
		Token
	)
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

function TAC.Punishment.Valid(Player, Config)
	if (not IsValid(Player) or not Player:IsPlayer()) then
		return
	end
	
	-- Global Checks.
	
	if (TAC.Config.Punishment.ignoreStaff and TAC.IsStaff(Player)) then
		return
	end
	
	if (TAC.Config.Punishment.globalFilter and not TAC.globalFilterCallback(Player, Config)) then
		return
	end
	
	-- Config Checks.
	
	if (not Config.Enabled) then
		return false
	end
	
	if (Config.Ping ~= -1 and Player:Ping() >= Config.Ping) then
		return
	end
	
	if (Config.Loss ~= -1 and Player:PacketLoss() >= Config.Loss) then
		return
	end
	
	if (Config.Vehicles and Player:InVehicle()) then
		return
	end
	
	return true
end

function TAC.Punishment.Evaluate(ID, Player, Info, ...)
	if (not ID or not Player or not Info) then
		return EVALUATE_FAILED, nil
	end

	Info = string.format(Info, ...)

	local Config = TAC.Config[ID]
	local usingFallback = false

	if (not Config) then
		Config = TAC.Config.Fallback
		usingFallback = true
	end

	Config = table.Copy(Config)

	if (not TAC.Punishment.Valid(Player, Config) or Config.Method == PUNISHMENT_IGNORE) then
		return EVALUATE_BYPASSED, nil
	end

	local Token = {
		ID = ID,
		Player = Player,
		Info = Info
	}

	table.Merge(Token, Config, true)
		
	TAC.Tell(
		Token.formatEvaluate(Token),
		Token.Alerts.Evaluate,
		NOTIFY_GENERIC,
		TAC.Config.Alerts.Sounds.Notify,
		-- TODO: Don't show alert to banned player, configurable.
	)

	return usingFallback and EVALUATE_FALLBACK or EVALUATE_SUCCESS, Token
end

--- Flags ---

-- ...

--- Execute ---

-- ...

--- End ---

concommand.Add("tac_pstubs", TAC.Punishment.LoadStubs)

TAC.Punishment.LoadStubs()