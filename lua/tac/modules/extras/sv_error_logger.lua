function TAC.Extra.Errors(Error, Player, Stack, Name)
	local Config = TAC.Config["Errors"]
	
	if not Config.Enabled then
		return
	end
	
	local Source = string.Split(Error, ":")[1]

	if Source then
		TAC.Punishment.Wrapper("Errors", Player, "Error [source: %s]", TAC.Fix(Source))
	end
	
	if not Config.Scan then
		return
	end
	
	-- What is actually really cool about this is they can't lie about the file without a module. 
	-- It completely bypasses identifiers all together. Kinda neat.
	
	for k, Object in ipairs(Stack) do 
		if Object.File == "[C]" then
			continue
		end
		
		if Object.File == "LuaCmd" or not file.Exists(Object.File, "GAME") then
			local Status, Token = TAC.Punishment.Evaluate("Errors", Player, "Error [invalid: %s; level: %i]", TAC.Fix(Object.File), k)
	
			if Status == EVALUATE_SUCCESS and Token then
				Token.Method = Config.ScanMethod
			
				return TAC.Execute(Token)
			end
		end
	end
end

hook.Add("OnClientLuaError", "TAC.Extra.Errors", TAC.Extra.Errors)