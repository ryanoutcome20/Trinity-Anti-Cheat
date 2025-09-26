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

concommand.Add("tac_reload_config", function(Player)
	if Player and not Player:IsSuperAdmin() then
		Player:tAlert(
			"This command is restricted to Super Admin only!",
			NOTIFY_ERROR
		)
		
		TAC.Print(
			PRINT_WARN,
			"Networking",
			"Blocked client `%s` from reloading clientside configs!", 
			Player:Name()
		)
		
		return
	end

	TAC.Print(
		PRINT_WARN,
		"Networking",
		"`tac_reload-config` is considered a debug feature! It may break things or affect performance!"
	)

    for k, Player in player.Iterator() do
        TAC.Networking.SendConfig(Player)
    end
end)