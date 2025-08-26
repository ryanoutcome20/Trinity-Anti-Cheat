TAC.Libraries = { }

function TAC.Libraries.Run()
	local Config = TAC.Config.Integrity.Libraries
	
	if not Config.Enabled then
		return
	end

	-- Command list.
	if Config.Command then
		local Name, Object = debug.getupvalue(concommand.GetTable, 1)
		
		local Size = table.Count(Object)
		
		if Size ~= Config.Commands then
			return TAC.Flag("Libraries", "Bad Libraries [concommand; expected: %i; got: %i]", Config.Commands, Size)
		end
	end
	
	-- Command list.
	if Config.Hook then
		local Name, Object = debug.getupvalue(hook.GetTable, 1)
		
		local Size = table.Count(Object)
		
		if Size ~= Config.Hooks then
			return TAC.Flag("Libraries", "Bad Libraries [hook; expected: %i; got: %i]", Config.Hooks, Size)
		end
	end
	
	-- Command list.
	if Config.Net then		
		local Size = table.Count(net.Receivers)
		
		if Size ~= Config.Nets then
			return TAC.Flag("Libraries", "Bad Libraries [net; expected: %i; got: %i]", Config.Nets, Size)
		end
	end
end

TAC.Libraries.Run()