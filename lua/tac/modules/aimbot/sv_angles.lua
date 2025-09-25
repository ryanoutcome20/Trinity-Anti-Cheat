function TAC.Aimbot.Angles(Player, cNew, cOld, CUserCMD)
	local Config = TAC.Config.Angles

	if not Config.Enabled then
		return
	end

	local Angles = cNew:GetViewAngles()
	
	if Config.CheckPitch and math.abs(Angles.x) > Config.MaxPitch then
		TAC.Punishment.Wrapper("Angles", Player, "Angles [x: %i y: %i; bad x]", Angles.x, Angles.y)	
	elseif Config.CheckYaw and math.abs(Angles.y) > Config.MaxYaw then
		TAC.Punishment.Wrapper("Angles", Player, "Angles [x: %i y: %i; bad y]", Angles.x, Angles.y)
	end
end

hook.Add("TAC.StartCommandPlus", "TAC.Aimbot.Angles", TAC.Aimbot.Angles)