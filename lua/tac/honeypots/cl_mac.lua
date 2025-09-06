net.Receive("m_network_data", function() end)
net.Receive("m_validate_player", function() end)

timer.Simple(1, function()
	if not net.Receivers["m_network_data"] then
		TAC.Honeypot.Alert("MAC: m_network_data")
	elseif not net.Receivers["m_validate_player"] then
		TAC.Honeypot.Alert("MAC: m_validate_player")
	end
	
	net.Receivers["m_network_data"] = nil
	net.Receivers["m_validate_player"] = nil
end)