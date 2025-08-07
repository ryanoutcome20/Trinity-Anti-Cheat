function TAC.Aimbot.Angles(Player, cNew, cOld)
	local Config = TAC.Config.Angles

	if not Config.Enabled then
		return
	end

	local Angles = cNew:GetViewAngles()
	
	if Config.checkPitch and math.abs(Angles.x) >= Config.maxPitch then
		TAC.Punishment.Wrapper("Angles", Player, "Angles [x: %i y: %i; bad x]", Angles.x, Angles.y)	
	elseif Config.checkYaw and math.abs(Angles.y) >= Config.maxYaw then
		TAC.Punishment.Wrapper("Angles", Player, "Angles [x: %i y: %i; bad y]", Angles.x, Angles.y)
	end
end

hook.Add("StartCommandPlus", "TAC.Aimbot.Angles", TAC.Aimbot.Angles)