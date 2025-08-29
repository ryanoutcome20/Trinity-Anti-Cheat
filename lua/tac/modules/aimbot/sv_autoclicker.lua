function TAC.Aimbot.Autoclicker(Player, Cache)
	local Config = TAC.Config.Autoclicker

	if not Config.Enabled then
		return
	end
	
	local Caught = 0
	
	for k, Object in ipairs(Cache) do
		local cNew, cOld = Object.cNew, Object.cOld
	
		if TAC.Bitwise(cNew:GetButtons(), IN_ATTACK) and not TAC.Bitwise(cOld:GetButtons(), IN_ATTACK) then
			Caught = Caught + 1
		elseif Config.ResetOnFailure then
			Caught = 0
		end
	end
	
	if Caught ~= 0 then
		local Status, Token = TAC.Punishment.Evaluate("Autoclicker", Player, "Autoclicker [batch: %i/%i]", Caught, #Cache)
	
		if Status == EVALUATE_SUCCESS and Token then
			Token.Increment = Caught
		
			return TAC.Execute(Token)
		end
	end
end

hook.Add("StartCommandBatch", "TAC.Aimbot.Autoclicker", TAC.Aimbot.Autoclicker)