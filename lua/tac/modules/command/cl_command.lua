function TAC.Commands.GeneratePackage(Slots)
    local Built = { }
    
    for Name, Input in pairs(Slots) do 
        local ConVar = GetConVar(Name)

        if not ConVar then
            continue
        end
        
        Built[Name] = ConVar:GetString() 
    end

    return Built
end

function TAC.Commands.Receiver(Stage, Slots)
    local Package = TAC.Commands.GeneratePackage(Slots)

    if not Package then
        return TAC.Print(
            PRINT_ERROR,
            "Commands",
            "Failed to get packages for %s slots",
            istable(Package) and table.Count(Package) or "invalid"
        )
    end

    TAC.Atlas:Send(
        "Commands",
        Package
    )
end

TAC.Atlas:Listen("Commands", "TAC.Commands.Receiver", MODE_DONE, TAC.Commands.Receiver)