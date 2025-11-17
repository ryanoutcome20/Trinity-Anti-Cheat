function TAC.Aimbot.Snap(Player, Cache)
	local Config = TAC.Config.Snap

	if not Config.Enabled then
		return
	end
	
	if TAC.TimeSinceSpawned(Player) <= Config.TimeSinceSpawned then
		return
	end
	
	local Flags = {
		Amount = 0,
		Highest = 0
	}
	
	for k, Object in ipairs(Cache) do
		local cNew, cOld = Object.cNew, Object.cOld
	
		local Trace = cNew:GetTraceData()
		
		if not Trace.Valid then
			continue
		end
		
		local Distance = Trace.Entity:GetPos():DistToSqr(cNew:GetPos())

		if Distance <= Config.Distance then
			continue
		end
		
		local Delta = cNew:GetDelta()
		
		if Delta >= Config.Delta then
			Flags.Amount = Flags.Amount + 1
			
			if Delta >= Flags.Highest then
				Flags.Highest = Delta
			end
		end
	end
	
	TAC.Batch.Punish(Flags.Amount, "Snap", Player, "Snapped [batch: %i/%i; highest: %f]", Flags.Amount, #Cache, Flags.Highest)
end

hook.Add("TAC.StartCommandBatch", "TAC.Aimbot.Snap", TAC.Aimbot.Snap)