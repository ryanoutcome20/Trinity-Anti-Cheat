local Listeners = TAC.Lists.Merge("Listener")

hook.Add("TAC.Initialize", "TAC.SetupListeners", function()
    local Config = TAC.Config.Listeners

    if not Config.Enabled then
        return
    end
    
    for k, Data in pairs(Listeners) do 
        local Name, Type = Data.Name, Data.Type

        hook.Add(Name, "TAC.Listener." .. Name, function(...)
            TAC.Flag("Listener", "Bad Hook Listener [name: %s; type: %s]", Name, Type)

            hook.Remove(Name, "TAC.Listener." .. Name)
        end)
    end
end)