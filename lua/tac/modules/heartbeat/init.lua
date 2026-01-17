TAC.Heartbeat = { }

function TAC.Heartbeat.Receive(Stage, Player)
    Player:Set("Heartbeat", true)
end

function TAC.Heartbeat.Check(Player)
    if not IsValid(Player) then
        return TAC.Print(
            PRINT_WARN,
            "Heartbeat",
            "Attempted to verify heartbeat of type `%s` which isn't valid",
            type(Player)
        )
    end

    if not Player:Get("Heartbeat", false) then
        return TAC.Punishment.Wrapper(
            "Heartbeat",
            Player,
            "Not Initialized"
        )	
    end

    TAC.Heartbeat.Start(Player)
end

function TAC.Heartbeat.Start(Player)
    if not IsValid(Player) then
        return TAC.Print(
            PRINT_WARN,
            "Heartbeat",
            "Attempted to start heartbeat of type `%s` which isn't valid",
            type(Player)
        )
    end

    Player:Set("Heartbeat", false)

    TAC.Timer(
        Player, 
        TAC.Config.Heartbeat.Await, 
        TAC.Heartbeat.Check
    )
end

Atlas:Listen("Heartbeat", "TAC.Heartbeat.Receive", MODE_DONE, TAC.Heartbeat.Receive)
hook.Add("TAC.TransferStopped", "TAC.Heartbeat.Start", TAC.Heartbeat.Start)

return {
    "cl_heartbeat.lua"
}