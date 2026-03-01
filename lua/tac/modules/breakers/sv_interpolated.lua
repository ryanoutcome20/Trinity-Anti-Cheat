function TAC.Breakers.InterpolateViewAngles(Player, cNew, cOld, CUserCMD)
	local Config = TAC.Config.Interpolated
	
	if not Config.Enabled then
		return
	end
	
	-- Check whitelist.
	
	local SWEP = cNew:GetWeapon()
	
	if IsValid(SWEP) then
		if Config.Whitelisted[SWEP:GetClass()] then
			return
		end
	end
	
	-- Generate ratio.
	
	local Ratio = Config.Ratio
	
	if Config.Randomize then
		Ratio = Ratio * math.random()
	end
	
	-- Apply patch.
	
	CUserCMD:SetViewAngles(LerpAngle(
		Ratio / cNew:GetCommandNumber(),
		cOld:GetViewAngles(),
		cNew:GetViewAngles()
	))
end

hook.Add("TAC.PostStartCommandPlus", "TAC.Breakers.InterpolateViewAngles", TAC.Breakers.InterpolateViewAngles)