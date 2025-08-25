TAC.Keys = {
	IN = {
		{
			Status = false,
			Name = "+jump",
			Enum = IN_JUMP
		},
		{
			Status = false,
			Name = "+attack",
			Enum = IN_ATTACK
		},
		{
			Status = false,
			Name = "+use",
			Enum = IN_USE
		}
	}
}

function TAC.Keys.Press(Player, Bind, Status, Code)
	if Player ~= LocalPlayer() then
		return
	end

	local Translated = input.TranslateAlias(Bind) or Bind
	
	for k, Object in ipairs(TAC.Keys.IN) do 
		if string.find(Translated, Object.Name) then
			Object.Status = true
			return
		end
	end
end

function TAC.Keys.Verify(Player, CMoveData, CUserCMD)
	if not TAC.Config.Integrity.Keys then
		return
	end

	if not IsFirstTimePredicted() then
		return
	end
	
	Player = GetPredictionPlayer()
	CUserCMD = Player:GetCurrentCommand()

	for k, Object in ipairs(TAC.Keys.IN) do
		if CMoveData:KeyPressed(Object.Enum) then
			if not Object.Status then
				TAC.Flag("Key Input", "Key Input [name: %s]", Object.Name)
			end
			
			Object.Status = false
		end
	end
end

hook.Add("PlayerBindPress", "TAC.Keys.Press", TAC.Keys.Press)
hook.Add("SetupMove", "TAC.Keys.Verify", TAC.Keys.Verify)