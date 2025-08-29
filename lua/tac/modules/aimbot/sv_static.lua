function TAC.Aimbot.Static(Player, Cache)
	local Config = TAC.Config["Static"]

	if not Config.Enabled then
		return
	end
	
	local Flags = 0
	
	for k, Object in ipairs(Cache) do
		local cNew, cOld = Object.cNew, Object.cOld
		
		local Offset = cNew:GetMouseY() * cOld:GetMouseY()
		
		if cNew:GetMouseY() == cOld:GetMouseY() and Offset > 1 and Offset < 500000 then
			Flags = Flags + 1
		end
	end
	
	TAC.Batch.Punish(Flags, "Static", Player, "Static [batch: %i/%i]", Flags, #Cache)
end

hook.Add("StartCommandBatch", "TAC.Aimbot.Static", TAC.Aimbot.Static)