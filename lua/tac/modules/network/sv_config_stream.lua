function TAC.Networking.SendConfig(Player)
    local Config = include("tac/config/client.lua")

    Atlas:Send(
		"Config", 
		Player, 
        Config
	)

    hook.Run("TAC.TransferConfig", Player)
end

hook.Add("TAC.TransferStopped", "TAC.Networking.SendConfig", TAC.Networking.SendConfig)