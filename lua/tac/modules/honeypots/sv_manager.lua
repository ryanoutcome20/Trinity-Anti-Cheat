function TAC.Honeypot.Wrapper(Player, Message, ...)
	return TAC.Punishment.Wrapper("Honeypot", Player, Message, ...)
end

function TAC.Honeypot.Receive(Stage, Player, Message)
	local Time = CurTime()
	
	if Player:Grab("Honeypot Delay", 0) > Time then
		return
	end
	
	Player:Set("Honeypot Delay", Time + 0.25)

	TAC.Honeypot.Wrapper(
		Player, 
		"Honeypot [client: \"%s\"]", 
		TAC.Fix(Message)
	)
end

Atlas:Listen("Honeypot", "TAC.Honeypot.Receive", MODE_DONE, TAC.Honeypot.Receive)

--- MAC ---

util.AddNetworkString("m_loaded")
util.AddNetworkString("m_validate_player")

net.Receive("m_loaded", function(Length, Player)
	TAC.Honeypot.Wrapper(Player, "Honeypot [MAC: m_loaded]")
end)

net.Receive("m_validate_player", function(Length, Player)
	TAC.Honeypot.Wrapper(Player, "Honeypot [MAC: m_validate_player]")
end)

--- QAC ---

util.AddNetworkString("gcontrolled_vars")
util.AddNetworkString("controlled_vars")
util.AddNetworkString("Ping1")

net.Receive("gcontrolled_vars", function(Length, Player)
	TAC.Honeypot.Wrapper(Player, "Honeypot [QAC: gcontrolled_vars]")
end)

net.Receive("controlled_vars", function(Length, Player)
	TAC.Honeypot.Wrapper(Player, "Honeypot [QAC: controlled_vars]")
end)

net.Receive("Ping1", function(Length, Player)
	TAC.Honeypot.Wrapper(Player, "Honeypot [QAC: Ping1]")
end)