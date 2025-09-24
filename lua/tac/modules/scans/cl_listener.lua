--- Setup ---

local Listeners = TAC.Lists.Merge("Listeners")

--- Hooks ---

for k, Data in ipairs(Listeners) do 
    local Name, Type = Data.Name, Data.Type

    hook.Add(Name, "TAC.Listener." .. Name, function(...)
        TAC.Flag("Listener", "Bad Hook Listener [name: %s; type: %s]", Name, Type)

        hook.Remove(Name, "TAC.Listener." .. Name)
    end)
end