TAC.Audits = { }

function TAC.Audits.Dispatch(Player, Message)
    TAC.Tell(
		Message,
		ALERT_STAFF,
		NOTIFY_CLEANUP,
		TAC.Config.Alerts.Sounds.Notify,
		Player
	)
end

function TAC.Audits.Log(Player, Message)
    TAC.API.Log(
		Player,
		"AUDIT", 
		Message,
		true
	)

    TAC.Print(
		PRINT_INFO,
		"Audit",
		Message
	)
end

function TAC.Audits.Receive(Stage, Player, Message, Source)
	local Time = CurTime()
	
    local Last = Player:Get("Last Audit", 0) + 5.0

	if Last > Time then
		return
	end
	
	Player:Set("Last Audit", Time)

    local Formatted = string.format(
        "%s [%s] Raised audit: `%s` [%s]",
        TAC.Fix(Player:Nick()),
        Player:SteamID64(),
        TAC.Fix(Message),
        TAC.Fix(Source)
    )

    TAC.Audits.Log(Player, Formatted)
    TAC.Audits.Dispatch(Player, Formatted)
end

Atlas:Listen("Audit", "TAC.Audits.Receive", MODE_DONE, TAC.Audits.Receive)