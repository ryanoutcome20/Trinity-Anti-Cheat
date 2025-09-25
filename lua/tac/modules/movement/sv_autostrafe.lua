function TAC.Movement.Autostrafe(Player, cNew, cOld, CUserCMD)
	local Config = TAC.Config.Autostrafe
	
	if not Config.Enabled then
		return
	end
	
	local New, Old = cNew:GetSideMove(), cOld:GetSideMove()
	
	if New ~= Old and New == math.abs(Old) and New ~= 0 then		
		TAC.Punishment.Wrapper("Autostrafe", Player, "Autostrafe [move: %i]", New)
	end
end

hook.Add("TAC.StartCommandPlus", "TAC.Movement.Autostrafe", TAC.Movement.Autostrafe)