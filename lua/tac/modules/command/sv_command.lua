function TAC.Commands.BuildSlots()
    -- Get slots and patch.
    
    local Slots = hook.Run("TAC.Commands", Player) or { }

    table.Merge(
        Slots, 
        TAC.Config["Command Enforcer"].Commands,
        true
    )

    for Name, Input in pairs(Slots) do
        if not Input.Patch then
            continue
        end

        local ConVar = GetConVar(Name)

        if not ConVar then
            continue
        end

        Slots[Name].Value = ConVar:GetString()
    end

    -- Get built values.

    local Built = { }

    for Name, Input in pairs(Slots) do 
        Built[Name] = true
    end

    return Slots, Built
end

function TAC.Commands.Hook(Player)
    if Player:IsBot() then
        return
    end

    hook.Run("TAC.PreCommands", Player)

    local Await = TAC.Config["Command Enforcer"].Await

	TAC.Timer(
		Player, 
		Await / 2,
		function(Player)
            if Player:Grab("Command Enforcer") then
                return TAC.Punishment.Wrapper(
                    "Command Enforcer", 
                    Player, 
                    "Not Initialized"
                )
            end
        end
	)

    TAC.Timer(
		Player, 
		Await, 
		TAC.Commands.Hook
	)
end

function TAC.Commands.Setup(Player)
    local Slots, Built = TAC.Commands.BuildSlots()

    Player:Set(
        "Command Enforcer",
        Slots
    )

    Atlas:Send(
		"Commands", 
		Player, 
        Built
	)
end

function TAC.Commands.Receiver(Stage, Player, Slots)
    local Cache = Player:Grab("Command Enforcer")

    if not Cache then
        return
    end

    for Name, Input in pairs(Slots) do
        local Cached = Cache[Name]
        
        if not Cached or Input ~= Cached.Value then
            if Cached.Log then
                Player:tLog(
                    "Commands", 
                    string.format(
                        "Got incorrect command match [got: %s; expected: %s; on: %s]",
                        TAC.Fix(Input),
                        Cached and Cached.Value or "N/A",
                        TAC.Fix(Name)
                    )
                )
            else
                MsgN("! Banned")
                MsgN(Input)
                MsgN(Cache[Name].Value)

                PrintTable(Cache[Name])
            end
        end
    end

    Player:Set(
        "Command Enforcer",
        nil
    )

    hook.Run("TAC.PostCommands", Player, Slots, Cache)
end

hook.Add("TAC.PreCommands", "TAC.Commands.Setup", TAC.Commands.Setup)
hook.Add("PlayerInitialSpawn", "TAC.Commands.Hook", TAC.Commands.Hook)

Atlas:Listen("Commands", "TAC.Commands.Receiver", MODE_DONE, TAC.Commands.Receiver)