function TAC.Extra.Keypresses(Player, Button)
	local Config = TAC.Config["Suspicious Keypresses"]
	
	if not Config.Enabled then
		return
	end
	
	local Key = Config.Keys[Button]
	
	if Key then
		local Presses = Player:Get("Keypresses", 0)

		if Config.MaximumLogs == -1 or Presses < Config.MaximumLogs then
			TAC.Punishment.Wrapper("Suspicious Keypresses", Player, "Suspicious Keypresses [key: %s]", Key)
		
			Player:Set("Keypresses", Presses + 1)
		end
	else
		Player:Set("Keypresses", 0)
	end
end

hook.Add("PlayerButtonDown", "TAC.Extra.Keypresses", TAC.Extra.Keypresses)