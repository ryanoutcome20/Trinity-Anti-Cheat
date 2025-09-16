TAC.Command = { 
	sv_cheats = GetConVar("sv_cheats")
}

function TAC.Command.Run(Player)
	if Player:IsBot() or Player:IsTimingOut() then
		return
	end
	
	local Config = TAC.Config["Command Enforcer"]
	
	if not Config.Enabled then
		return
	end
	
	if TAC.Command.sv_cheats:GetBool() then
		return
	end
	
	for k, Command in ipairs(Config.Commands) do 
		local Grabbed = Player:GetInfoNum(Command.Name, -1)
		
		if Grabbed ~= Command.Value then
			TAC.Punishment.Wrapper("Command Enforcer", Player, "Bad Command [sv: %s; cl: %s; on: %s]", Grabbed, Command.Value, Command.Name)
		end
	end
end

function TAC.Command.Hook(Player)
	hook.Run("TAC-Command", Player)
	
	TAC.Timer(
		Player, 
		TAC.Config["Command Enforcer"].Await, 
		TAC.Command.Hook
	)
end

hook.Add("PlayerInitialSpawn", "TAC.Command.Hook", TAC.Command.Hook)
hook.Add("TAC-Command", "TAC.Command.Run", TAC.Command.Run)