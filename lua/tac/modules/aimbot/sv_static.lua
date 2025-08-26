function TAC.Aimbot.Static(Player, cNew, cOld, CUserCMD)
	local Config = TAC.Config["Static"]

	if not Config.Enabled then
		return
	end
	
	local Offset = cNew:GetMouseY() * cOld:GetMouseY()
	
	if cNew:GetMouseY() == cOld:GetMouseY() and Offset > 10000 and Offset < 500000 then
		TAC.Punishment.Wrapper("Static", Player, "Static [offset: %i]", Offset)
	end
end

hook.Add("StartCommandPlus", "TAC.Aimbot.Static", TAC.Aimbot.Static)