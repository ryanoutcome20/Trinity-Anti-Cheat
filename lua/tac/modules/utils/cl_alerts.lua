local tac_notify_chat = CreateClientConVar("tac_notify_chat", 1)
local tac_notify_popups = CreateClientConVar("tac_notify_popups", 1)

local notification = _G.notification

TAC.Atlas:Listen("Alert", "TAC.Alert", MODE_DONE, function(Mode, Data)	
	local Message, Type, Sound = unpack(Data)
	
	if tac_notify_popups:GetBool() then
		notification.AddLegacy("[TAC]: " .. Message, Type, 8)
		surface.PlaySound(Sound)
	end
	
	if tac_notify_chat:GetBool() then
		chat.AddText(
			TAC.GRAY,
			"[ ",
			TAC.SIGNITURE_GREEN,
			"Trinity",
			TAC.GRAY,
			" : ALERT ] ",
			TAC.WHITE,
			Message
		)
	end
end)