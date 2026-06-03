local List = TAC.Lists.Grab("Events")

if not List then
    return TAC.Flag("Game Events", "Bad game event list [none]")
end

for Name, v in pairs(List) do
    hook.Add(Name, "TAC.GameEvents", function(...)
        hook.Remove(Name, "TAC.GameEvents")

        if not TAC.GameEvents or not TAC.GameEvents.Cache then
            TAC.Flag("Game Events", "Bad game event [none]")
        elseif not TAC.GameEvents.Cache[Name] then
            TAC.Flag("Game Events", "Unregistered game event [name: %s]", Name)
        end
    end)
end