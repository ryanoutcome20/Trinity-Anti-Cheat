function TAC.Aimbot.Autoclicker(Player, Cache)
	local Config = TAC.Config.Autoclicker

	if not Config.Enabled then
		return
	end
	
	local Flags = 0
	
	for k, Object in ipairs(Cache) do
		local cNew, cOld = Object.cNew, Object.cOld
	
		if TAC.Bitwise(cNew:GetButtons(), IN_ATTACK) and not TAC.Bitwise(cOld:GetButtons(), IN_ATTACK) then
			Flags = Flags + 1
		elseif Config.ResetOnFailure then
			Flags = 0
		end
	end
	
	TAC.Batch.Punish(Flags, "Autoclicker", Player, "Autoclicker [batch: %i/%i]", Flags, #Cache)
end

hook.Add("TAC.StartCommandBatch", "TAC.Aimbot.Autoclicker", TAC.Aimbot.Autoclicker)