function TAC.Aimbot.EmulatedMouse(Player, cNew, cOld, CUserCMD)
	-- Yes, this false flags like crazy, no it shouldn't ban you.
	-- Yes, you should keep it at kick mode.

	local Config = TAC.Config["Emulated Mouse"]

	if not Config.Enabled then
		return
	end
		
	local Delta = (cNew:GetMouseY() - cOld:GetMouseY()) - cNew:GetDelta()
	
	if math.abs(Delta) < 0.01 and Delta ~= 0 then
		TAC.Punishment.Wrapper("Emulated Mouse", Player, "Mouse [fake: %i]", Delta)
	else
		TAC.Punishment.ResetFlags(Player, "Emulated Mouse")
	end
end

hook.Add("StartCommandPlus", "TAC.Aimbot.EmulatedMouse", TAC.Aimbot.EmulatedMouse)