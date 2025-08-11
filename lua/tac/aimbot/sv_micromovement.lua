function TAC.Aimbot.Micromovement(Player, cNew, cOld, CUserCMD)
	local Config = TAC.Config.Micromovement

	if not Config.Enabled then
		return
	end
	
	local Trace = cNew:GetTraceData()
	
	if not Trace.Valid or Trace.Entity:GetPos():DistToSqr(cNew:GetPos()) <= Config.Distance then
		return
	end
	
    local Delta, oDelta = cNew:GetDelta(), cOld:GetDelta()
	
	local Offset = oDelta - Delta
	
	if Delta > 0 and Delta < Config.Delta then
		if Offset >= Config.hOffset then
			local Status, Token = TAC.Punishment.Evaluate("Micromovement", Player, "Micromovement [offset: %f; high]", Offset)
	
			if Status == EVALUATE_SUCCESS and Token then
				Token.Increment = Config.hIncrement
			
				return TAC.Execute(Token)
			end
		elseif Offset >= Config.lOffset then
			TAC.Punishment.Wrapper("Micromovement", Player, "Micromovement [offset: %f; low]", Offset)
		end
	end
end

hook.Add("StartCommandPlus", "TAC.Aimbot.Micromovement", TAC.Aimbot.Micromovement)