function TAC.Punishment.Register(ID, Token)
	local Base = TAC.Config.Fallback or { }
		
	TAC.Config[ID] = table.Merge(
		table.Copy(Base), 
		Token
	)
end

function TAC.Punishment.LoadStubs(Player)
	if Player and not Player:IsSuperAdmin() then
		TAC.API.Alert(
			Player,
			"This command is restricted to Super Admin only",
			NOTIFY_ERROR
		)
		
		TAC.Print(
			PRINT_WARN,
			"Punishment",
			"Blocked client `%s` from reloading pStubs", 
			Player:Name()
		)
		
		return
	end

	for k, Data in pairs(pStub.Registers) do 
		TAC.Punishment.Register(
			Data.ID,
			Data.Token
		)
	end
end

function TAC.Punishment.ID(SID)
	return string.format(
		"TAC_PUNISHMENT_%s",
		SID
	)
end

function TAC.Punishment.Valid(Player, Config, isToken, noDelay)
	if isToken then
		Player = Config.Player
	end

	if not IsValid(Player) or not Player:IsPlayer() then
		return
	end
	
	-- Global Checks.
	if not noDelay and TAC.Punishment.IsActive(Player) then
		return
	end
	
	if TAC.Config.Punishment.IgnoreStaff and TAC.IsStaff(Player) then
		return
	end
	
	if TAC.Config.Punishment.GlobalFilter and not TAC.GlobalFilterCallback(Player, Config) then
		return
	end
	
	-- Config Checks.
	if not Config.Enabled then
		return
	end
	
	if Config.Callback and Config.Callback(Player) then
		return
	end
	
	if Config.Ping ~= -1 and Player:Ping() >= Config.Ping then
		return
	end
	
	if Config.Loss ~= -1 and Player:PacketLoss() >= Config.Loss then
		return
	end

	if Config.Sensitivity ~= -1 and Player:Get("Sensitivity", 3) < Config.Sensitivity then
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
		local Class = SWEP:GetClass()
		
		if Class and Config.SWEPs[Class] then
			return
		end
	end
	
	return true
end