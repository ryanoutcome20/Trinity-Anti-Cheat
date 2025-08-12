function TAC.Aimbot.Snap(Player, cNew, cOld, CUserCMD)
	local Config = TAC.Config.Snap

	if not Config.Enabled then
		return
	end
		
	if TAC.TimeSinceSpawned(Player) <= Config.TSS then
		return
	end
	
	local Trace = cNew:GetTraceData()
		
	if not Trace.Valid or Trace.Entity:GetPos():DistToSqr(cNew:GetPos()) <= Config.Distance then
		return
	end
		
	if Config.UseTwoTarget then
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