TAC.MenuMovement = { }

function TAC.MenuMovement.Run(CUserCMD)
	if not TAC.Config.MenuMovement.Enabled then
		return
	end
	
	if not vgui.CursorVisible() then
		return
	end
	
	if CUserCMD:GetMouseX() == 0 and CUserCMD:GetMouseY() == 0 then
		return
	end

	TAC.Flag("Menu Movement", "Menu Movement")
end

hook.Add("CreateMove", "TAC.MenuMovement.Run", TAC.MenuMovement.Run)