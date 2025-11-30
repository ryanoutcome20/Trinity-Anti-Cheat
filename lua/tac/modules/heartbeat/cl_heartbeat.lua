TAC.Heartbeat = { }

function TAC.Heartbeat.Send()
    TAC.Atlas:Send(
        "Heartbeat"
    )

    TAC.Heartbeat.Start()
end

function TAC.Heartbeat.Start()
    timer.Simple(
        TAC.Config.Heartbeat.Await, 
        TAC.Heartbeat.Send
    )
end

hook.Add("TAC.Initialize", "TAC.Heartbeat", function()
    if not TAC.Config.Heartbeat.Enabled then
        return
    end

    TAC.Heartbeat.Start()
end)