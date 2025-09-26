hook.Add("TAC.Initialize", "TAC.Heartbeat", function()
    -- Yeah, you could make this send more than once.
    
    TAC.Atlas:Send(
        "Heartbeat"
    )
end)