function TAC.FSB()
	local Config = TAC.Config.Breakers.FSB

	if Config.Enabled then
		local Text = ""
		
		for k, Indentifier in ipairs(Config.Identifiers or { }) do 
			Config.Handle(Config.Code, Indentifier)
			Text = Text .. Indentifier
		end
			
		if Config.Spammer then
			Text = string.rep(Text, Config.Size)
		
			hook.Add("Think", "TAC-FSB", function()
				for i = 1, Config.Ticks do 
					local Buffer = TAC.Random()
					
					Config.Handle("--[[" .. Buffer .. Text .. Buffer .. "--]]", Buffer)
				end
			end)
		end
	end
end

TAC.FSB()