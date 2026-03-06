function TAC.Commands.BuildSlots()
    -- Get slots and patch.
    
    local Slots = { }

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

    return Slots
end

function TAC.Commands.BuildBuilt()
    -- Incredible name, I know.
    local Commands = TAC.Config["Command Enforcer"].Commands

    local Built = { }

    for Name, Input in pairs(Commands) do 
        Built[Name] = true
    end

    return Built
end


function TAC.Commands.Receiver(Stage, Player, Slots)
    local Cache = TAC.Commands.BuildSlots()

    if not Cache then
        return
    end

    if not istable(Slots) then
        return
    end

    for Name, Input in pairs(Slots) do
        local Cached = Cache[Name]

        if not Cached or tostring(Input) ~= tostring(Cached.Value) then
            if Cached.Log then
                TAC.API.Log(
                    Player,
                    "Commands", 
                    string.format(
                        "Got incorrect command match [got: %s; expected: %s; on: %s]",
                        TAC.Fix(Input),
                        Cached and Cached.Value or "N/A",
                        TAC.Fix(Name)
                    )
                )
            else
                TAC.Punishment.Wrapper(
                    "Command Enforcer",
                    Player,
                    "Command Mismatch [values: %s ~= %s; name: %s]",
                    Input,
                    Cache[Name].Value,
                    Name
                )
            end
        end
    end
end

function TAC.Commands.Hook(Player)
	if not IsValid(Player) or Player:IsBot() then
		return
	end

    Atlas:Send(
		"Commands", 
		Player, 
        TAC.Commands.BuildBuilt()
	)

    local Config = TAC.Config["Command Enforcer"]

	TAC.Timer(
		Player, 
		Config.Await,
		function(self)
            if self:Get("Command Enforcer") then
                return TAC.Punishment.Wrapper(
                    "Command Enforcer", 
                    self, 
                    "Not Initialized"
                )
            end
        end
	)

    TAC.Timer(
		Player, 
		Config.Interval, 
		TAC.Commands.Hook
	)
end

Atlas:Listen("Commands", "TAC.Commands.Receiver", MODE_DONE, TAC.Commands.Receiver)

hook.Add("TAC.TransferConfig", "TAC.Commands.Hook", TAC.Commands.Hook)