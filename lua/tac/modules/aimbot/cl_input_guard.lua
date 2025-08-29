TAC.Aimbot.InputGuard = { }

function TAC.Aimbot.InputGuard.Verify(Config, Object, CUserCMD)
	-- Verify angles.
	
	local Angles = Object.Angles - CUserCMD:GetViewAngles()
	
	local Offset = Angle(
		Config.Offset,
		Config.Offset,
		Config.Offset
	)
	
	Angles.x = math.abs(Angles.x)
	Angles.y = math.abs(Angles.y)
		
	if Config.Angles and Angles.x >= Offset.x and Angles.y >= Offset.y then
		TAC.Flag("Input Guard Angles", "Input Guard [angles; offset: %s]", tostring(Angles))
	end
	
	-- Verify buttons.
	
	if Config.Buttons and Object.Buttons ~= CUserCMD:GetButtons() then
		TAC.Flag("Input Guard Buttons", "Input Guard [buttons]")
	end
		
	-- Verify movement.
	
	local Movement = CUserCMD:GetSideMove() + CUserCMD:GetForwardMove()
	
	if Config.Movement and Object.Movement ~= Movement then
		TAC.Flag("Input Guard Movement", "Input Guard [movement; delta: %i; expected: %i]", Movement, Object.Movement)
	end
end

function TAC.Aimbot.InputGuard.StartCommand(Player, CUserCMD)
	TAC.Aimbot.InputGuard.Storage = {
		Angles = CUserCMD:GetViewAngles(),
		Buttons = CUserCMD:GetButtons(),
		
		Movement = CUserCMD:GetSideMove() + CUserCMD:GetForwardMove()
	}
end

function TAC.Aimbot.InputGuard.SetupMove(Player, CMoveData, CUserCMD)
	local Config = TAC.Config.Aimbot.InputGuard
	local Object = TAC.Aimbot.InputGuard.Storage

	if Object and IsFirstTimePredicted() then
		Player = GetPredictionPlayer()
		CUserCMD = Player:GetCurrentCommand()
	
		if not CUserCMD:IsForced() then
			TAC.Aimbot.InputGuard.Verify(Config, Object, CUserCMD)
		end
		
		TAC.Aimbot.InputGuard.Storage = nil
	end
end

hook.Add("StartCommand", "TAC.Aimbot.InputGuard.StartCommand", TAC.Aimbot.InputGuard.StartCommand)
hook.Add("SetupMove", "TAC.Aimbot.InputGuard.SetupMove", TAC.Aimbot.InputGuard.SetupMove)