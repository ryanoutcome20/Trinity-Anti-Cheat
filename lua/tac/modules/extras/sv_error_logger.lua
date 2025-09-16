function TAC.Extra.Errors(Error, Player, Stack, Name)
	local Config = TAC.Config["Errors"]
	
	if not Config.Enabled then
		return
	end
	
	local Source = string.Split(Error, ":")[1]

	if Source then
		TAC.Punishment.Wrapper("Errors", Player, "Error [source: %s]", TAC.Fix(Source))
	end
end

hook.Add("OnClientLuaError", "TAC.Extra.Errors", TAC.Extra.Errors)