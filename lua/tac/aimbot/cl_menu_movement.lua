TAC.Mouse = { }

function TAC.Mouse.Run(CUserCMD)
	if not TAC.Config.Aimbot.Mouse then
		return
	end
	
	if not vgui.CursorVisible() then
		return
	end
	
	if CUserCMD:GetMouseX() == 0 and CUserCMD:GetMouseY() == 0 then
		return
	end

	TAC.Flag("Client Mouse", "Menu Movement")
end

hook.Add("CreateMove", "TAC.Mouse.Run", TAC.Mouse.Run)