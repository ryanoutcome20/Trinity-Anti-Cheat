function TAC.Aimbot.Mouse(Player, cNew, cOld, CUserCMD)
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