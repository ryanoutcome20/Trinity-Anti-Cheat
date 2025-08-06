TAC.Aimbot = { }

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

function TAC.Aimbot.Snap(Player, cNew, cOld)
	local Config = TAC.Config.Snap

	if not Config.Enabled then
		return
	end
	
	local Trace = cNew:GetTraceData()
		
	if not Trace.Valid or Trace.Entity:GetPos():DistToSqr(cNew:GetPos()) <= Config.Distance then
		return
	end
		
	if Config.useTwoTarget then
		Trace = cOld:GetTraceData()
		
		if not Trace.Valid then
			return
		end
	end
	
	local Delta = cNew:GetDelta()
	
	if Delta >= Config.Delta then
		TAC.Punishment.Wrapper("Snap", Player, "Snapped [delta: %f; >= %i]", Delta, Config.Delta)
	end
end

hook.Add("StartCommandPlus", "TAC.Aimbot.Snap", TAC.Aimbot.Snap)

function TAC.Aimbot.Mouse(Player, cNew, cOld)
	local Config = TAC.Config.Mouse

	if not Config.Enabled then
		return
	end
	
	local Trace = cNew:GetTraceData()
	
	if not Trace.Valid or Trace.Entity:GetPos():DistToSqr(cNew:GetPos()) <= Config.Distance then
		return
	end

	local mX, mY = cNew:GetMouseX(), cNew:GetMouseY()
	
	local Delta = cNew:GetDelta()
	
	if Delta >= Config.iDeltaMin and Delta <= Config.iDeltaMax and mX == 0 and mY == 0 then
		TAC.Punishment.Wrapper("Mouse", Player, "Mouse [inputless delta: %f]", Delta, mX, mY)
	elseif Delta >= Config.fDelta and mX == mY then
		TAC.Punishment.Wrapper("Mouse", Player, "Mouse [far delta: %f; mx: %i; my: %i]", Delta, mX, mY)
	end
end

hook.Add("StartCommandPlus", "TAC.Aimbot.Mouse", TAC.Aimbot.Mouse)