TAC.Heartbeat = { }

function TAC.Heartbeat.Send()
    TAC.Atlas:Send(
        "Heartbeat"
    )

    TAC.Heartbeat.Start()
end

function TAC.Heartbeat.Start()
    if not TAC.Config.Heartbeat.Enabled then
        return
    end

    timer.Simple(
        TAC.Config.Heartbeat.Await, 
        TAC.Heartbeat.Send
    )
end

hook.Add("TAC.Initialize", "TAC.Heartbeat", TAC.Heartbeat.Start)