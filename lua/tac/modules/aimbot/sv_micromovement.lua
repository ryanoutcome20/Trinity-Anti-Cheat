function TAC.Aimbot.Micromovement(Player, cNew, cOld, CUserCMD)
	local Config = TAC.Config.Micromovement

	if not Config.Enabled then
		return
	end
	
	local Trace = cNew:GetTraceData()
	
	if not Trace.Valid or Trace.Entity:GetPos():DistToSqr(cNew:GetPos()) <= Config.Distance then
		return
	end
	
    local Delta = cNew:GetDelta()
	
	if Delta > 0 and Delta < Config.Delta then
		local Offset = cOld:GetDelta() - Delta

		if Offset >= Config.HighOffset then
			local Status, Token = TAC.Punishment.Evaluate("Micromovement", Player, "Micromovement [offset: %f; delta: %f; high]", Offset, Delta)
	
			if Status == EVALUATE_SUCCESS and Token then
				Token.Increment = Config.HighIncrement
			
				return TAC.Execute(Token)
			end
		elseif Offset <= Config.LowOffset then
			TAC.Punishment.Wrapper("Micromovement", Player, "Micromovement [offset: %f; delta: %f; low]", Offset, Delta)
		end
	end
end

hook.Add("TAC.StartCommandPlus", "TAC.Aimbot.Micromovement", TAC.Aimbot.Micromovement)