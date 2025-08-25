TAC.Networking.Plugins = { }

function TAC.Networking.Plugins.Await(Target)
	if Target:IsBot() then
		return
	end

	TAC.Timer(Target, TAC.Config.Plugins.Await, function(Player)
		TAC.Networking.Plugins.Run(
			Player,
			Player:GetInfoNum("_t", 0)
		)
	end)
end

function TAC.Networking.Plugins.Run(Player, Plugins)
	local Config = TAC.Config.Plugins
	
	if Plugins ~= TAC.Plugins.Client then
		return TAC.Punishment.Wrapper("Plugins", Player, "Failed Loaded Plugins [expected: %i; got: %i]", TAC.Plugins.Client, Plugins)	
	end
end

hook.Add("PlayerInitialSpawn", "TAC.Networking.Plugins.Await", TAC.Networking.Plugins.Await)