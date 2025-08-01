if CLIENT then
	local shouldNotify = CreateClientConVar("tac_should_notify", 1)

	net.Receive("tac-alert", function()
		if not shouldNotify:GetBool() then
			return
		end
	
		local Message, Type, Sound = unpack(net.ReadTable())
		
		Message = "TAC: " .. Message
		
		notification.AddLegacy(Message, Type, 8)
		surface.PlaySound(Sound)
	end)
	
	return
end

util.AddNetworkString("tac-alert")

local Player = FindMetaTable("Player")

function Player:tAlert(Message, Type, Sound)
	if not Sound then
		Sound = Type
		Type = NOTIFY_GENERIC
	end
	
	net.Start("tac-alert")
		net.WriteTable({
			Message,
			Type,
			Sound
		})
	net.Send(self)
end