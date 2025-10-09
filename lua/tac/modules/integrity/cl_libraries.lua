TAC.Libraries = { }

function TAC.Libraries.Run()
	local Config = TAC.Config.Libraries
	
	if not Config.Enabled then
		return
	end

	-- Command list.
	if Config.Command then		
		local Size = TAC.Sizes.Commands.Size or "nothing"
		
		if Size ~= Config.Commands then
			return TAC.Flag("Libraries", "Bad Libraries [concommand; expected: %i; got: %s]", Config.Commands, Size)
		end
	end
	
	-- Net list.
	if Config.Net then		
		local Size = TAC.Sizes.Net.Size or "nothing"
		
		if Size ~= Config.Nets then
			return TAC.Flag("Libraries", "Bad Libraries [net; expected: %i; got: %s]", Config.Nets, Size)
		end
	end
end

TAC.Libraries.Run()