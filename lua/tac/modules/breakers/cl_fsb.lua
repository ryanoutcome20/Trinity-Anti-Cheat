function TAC.Breakers.FSB()
	local Config = TAC.Config.FSB

	if not Config.Enabled then
		return
	end

	RunString(Config.Code, Config.Indentifier)
				
	if Config.Spammer then
		local Text = string.rep(Config.Identifier, Config.Size)
	
		hook.Add("Think", "TAC-FSB", function()
			for i = 1, Config.Ticks do 
				local Buffer = TAC.Random()
				
				RunString("--[[" .. Buffer .. Text .. Buffer .. "--]]", Buffer)
			end
		end)
	end
end

TAC.Breakers.FSB()