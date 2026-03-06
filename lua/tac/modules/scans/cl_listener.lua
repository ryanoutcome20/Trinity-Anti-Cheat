local Listeners = TAC.Lists.Merge("Listener")

local function Scan()
    local Config = TAC.Config.Listeners

    if not Config.Enabled then
        return
    end
    
    if not Listeners then
        return TAC.Flag("Listener", "Hook Listener [missing]")
    end 

    for k, Data in pairs(Listeners) do 
        local Name, Type = Data.Name, Data.Type

        hook.Add(Name, "TAC.Listener." .. Name, function(...)
            TAC.Flag("Listener", "Bad Hook Listener [name: %s; type: %s]", Name, Type)

            hook.Remove(Name, "TAC.Listener." .. Name)
        end)
    end
end

hook.Add("TAC.Initialize", "TAC.SetupListeners", Scan)