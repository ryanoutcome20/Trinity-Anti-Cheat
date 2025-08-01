TAC.Aimbot = { }

function TAC.Aimbot.Angles(Player, cNew, cOld)
	local Config = TAC.Config.Angles

	if not Config.Enabled then
		return
	end

	local Angles = cNew:GetViewAngles()
	
	local Status, Token = EVALUATE_FAILED, nil
	
	if Config.checkPitch and math.abs(Angles.x) >= Config.maxPitch then
		Status, Token = TAC.Punishment.Evaluate("Angles", Player, "Angles [x: %i y: %i; x]", Angles.x, Angles.y)	
	elseif Config.checkYaw and math.abs(Angles.y) >= Config.maxYaw then
		Status, Token = TAC.Punishment.Evaluate("Angles", Player, "Angles [x: %i y: %i; y]", Angles.x, Angles.y)
	end
	
	if Status == EVALUATE_SUCCESS and Token then
		return TAC.Execute(Token)
	end
end

hook.Add("StartCommandPlus", "TAC.Aimbot.Angles", TAC.Aimbot.Angles)

function TAC.Aimbot.Snap(Player, cNew, cOld)
	local Config = TAC.Config.Snap

	if not Config.Enabled then
		return
	end
	
	local Trace = cNew:GetEyeTrace()
		
	if not Trace.Entity or not Trace.Entity:IsPlayer() then
		return
	end
	
	if Config.useTwoTarget then
		Trace = cOld:GetEyeTrace()
		
		if not Trace.Entity or Trace.Entity:IsPlayer() then
			return
		end
	end
	
	local Delta = math.abs(math.AngleDifference(cNew:GetViewAngles().y+360, cOld:GetViewAngles().y+360))

	if Delta >= Config.Distance then
		local Status, Token = TAC.Punishment.Evaluate("Snap", Player, "Snapped [d: %f; >= %i]", Delta, Config.Distance)
		
		if Status == EVALUATE_SUCCESS and Token then
			return TAC.Execute(Token)
		end
	end
end

hook.Add("StartCommandPlus", "TAC.Aimbot.Snap", TAC.Aimbot.Snap)