function TAC.Movement.Input(Player, cNew, cOld, CUserCMD)
	local Config = TAC.Config.Input
	
	if not Config.Enabled then
		return
	end
	
	if TAC.LastTouchTime(Player) <= Config.LTT then
		TAC.Punishment.ResetFlags(Player, "Input")
		return
	end
	
	local Forward, Side = math.abs(cNew:GetForwardMove()), math.abs(cNew:GetSideMove())

	if Forward > Config.Minimum and not Config.Vectors[Forward] then
		TAC.Punishment.Wrapper("Input", Player, "Input [forward: %i]", math.Round(Forward, 2))
	elseif Side > Config.Minimum and not Config.Vectors[Side] then
		TAC.Punishment.Wrapper("Input", Player, "Input [side: %i]", math.Round(Side, 2))
	end
	
end

hook.Add("StartCommandPlus", "TAC.Movement.Input", TAC.Movement.Input)