local tac_notify_chat = CreateClientConVar("tac_notify_chat", 1)
local tac_notify_popups = CreateClientConVar("tac_notify_popups", 1)

TAC.Atlas:Listen("Alert", "TAC.Alert", MODE_DONE, function(Mode, Data)	
	local Message, Type, Sound = unpack(Data)
	
	if tac_notify_popups:GetBool() then
		notification.AddLegacy("[TAC]: " .. Message, Type, 8)
		surface.PlaySound(Sound)
	end
	
	if tac_notify_chat:GetBool() then
		chat.AddText(
			TAC.WHITE,
			"[",
			TAC.SIGNITURE_GREEN,
			"TAC",
			TAC.WHITE,
			"] ",
			Message
		)
	end
end)