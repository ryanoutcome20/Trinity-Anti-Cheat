function TAC.Extra.Keypresses(Player, Button)
	local Config = TAC.Config["Suspicious Keypresses"]
	
	if not Config.Enabled then
		return
	end

	local Presses = Player:Grab("Keypresses", 0)

	if Config.MaximumLogs ~= -1 and Presses >= Config.MaximumLogs then
		return
	end
	
	local Key = Config.Keys[Button]
	
	if Key then
		TAC.Punishment.Wrapper("Suspicious Keypresses", Player, "Suspicious Keypresses [key: %s]", Key)
	
		Player:Set("Keypresses", Presses + 1)
	end
end

hook.Add("PlayerButtonDown", "TAC.Extra.Keypresses", TAC.Extra.Keypresses)