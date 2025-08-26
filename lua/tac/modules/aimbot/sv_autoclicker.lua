function TAC.Aimbot.Autoclicker(Player, cNew, cOld, CUserCMD)
	local Config = TAC.Config.Autoclicker

	if not Config.Enabled then
		return
	end
	
	if TAC.Bitwise(cNew:GetButtons(), IN_ATTACK) and not TAC.Bitwise(cOld:GetButtons(), IN_ATTACK) then
		TAC.Punishment.Wrapper("Autoclicker", Player, "Autoclicker")
	elseif Config.ResetOnFailure then
		TAC.Punishment.ResetFlags(Player, "Autoclicker")	
	end
end

hook.Add("StartCommandPlus", "TAC.Aimbot.Autoclicker", TAC.Aimbot.Autoclicker)