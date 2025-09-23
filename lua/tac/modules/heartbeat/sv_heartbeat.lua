TAC.Heartbeat = { }

function TAC.Heartbeat.Receive(Stage, Player)
    Player:Set("Heartbeat", true)
end

function TAC.Heartbeat.Check(Player)
    if not IsValid(Player) then
        return TAC.Print(
            PRINT_WARN,
            "Heartbeat",
            "Attempted to verify type `%s` which isn't valid!",
            type(Player)
        )
    end

    if not Player:Grab("Heartbeat", false) then
        return TAC.Punishment.Wrapper(
            "Heartbeat",
            Player,
            "Not Initialized"
        )	
    end

    -- For disconnecting/retrying players.
    Player:Set("Heartbeat", false)
end

function TAC.Heartbeat.Initialize(Player)
    TAC.Timer(Player, TAC.Config.Heartbeat.Await, TAC.Heartbeat.Check)
end

Atlas:Listen("Heartbeat", "TAC.Heartbeat.Receive", MODE_DONE, TAC.Heartbeat.Receive)
hook.Add("TransferStopped", "TAC.Heartbeat.Initialize", TAC.Heartbeat.Initialize)