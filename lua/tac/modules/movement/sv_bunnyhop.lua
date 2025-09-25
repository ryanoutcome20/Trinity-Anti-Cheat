function TAC.Movement.Bunnyhop(Player, cNew, cOld, CUserCMD)
	local Config = TAC.Config.Bunnyhop
	
	if not Config.Enabled then
		return
	end
	
	if TAC.TimeSinceSpawned(Player) <= Config.TimeSinceSpawned then
		return
	end

	if TAC.LastTouchTime(Player) <= Config.LTT then
		TAC.Punishment.ResetFlags(Player, "Bunnyhop")
		return
	end
	
	if not cNew:GetOnGround() or cOld:GetOnGround() then
		return
	end
	
	if not CUserCMD:KeyDown(IN_JUMP) then
		TAC.Punishment.ResetFlags(Player, "Bunnyhop")
		return
	end
	
	TAC.Punishment.Wrapper("Bunnyhop", Player, "Bunnyhop")
end

hook.Add("TAC.StartCommandPlus", "TAC.Movement.Bunnyhop", TAC.Movement.Bunnyhop)