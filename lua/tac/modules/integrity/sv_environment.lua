TAC.Environment = { }

function TAC.Environment.Post(Player)
	if not IsValid(Player) or Player:IsBot() then
		return
	end

    local Config = TAC.Config.Environment

    if not Config.Enabled then
        return
    end

    TAC.Timer(Player, Config.Wait, function(Player)
        local Info, Step = Player:GetInfo(Player:Get("Key")), Player:Get("Transfer Step")

        if not Info or Info == "" then
            TAC.Punishment.Wrapper(
                "Environment", 
                Player, 
                "Environment [got: %s; invalid]", 
                Info == "" and "<empty>" or "<no value>"
            )
        elseif Info ~= tostring(Step) then
            TAC.Punishment.Wrapper(
                "Environment", 
                Player, 
                "Environment [got: %s; expected: %s]", 
                TAC.Fix(Info),
                Player:Get("Transfer Step")
            )
        end
    end)
end

function TAC.Environment.Start(Player)	
	if not IsValid(Player) or Player:IsBot() then
		return
	end

    local Key = TAC.Random(math.random(5,10))

    Player:Set("Key", Key)

    Atlas:Send(
		"Plugin", 
		Player, 
		"tac/modules/utils/cl_alerts.lua",
		"CreateConVar([[" .. Key .. "]], TAC.Loaded, FCVAR_USERINFO)"
	)
end

hook.Add("TAC.PreTransferStopped", "TAC.Environment.Start", TAC.Environment.Start)

hook.Add("TAC.TransferConfig", "TAC.Environment.Post", TAC.Environment.Post)