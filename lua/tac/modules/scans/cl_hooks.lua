local Hooks = TAC.Lists.Merge("Hooks")

local function Scan()
	local Config = TAC.Config.Hooks

	if not Config.Enabled then
		return
	end
	
	local Table = hook.GetTable()
	
	for k, Object in ipairs(Hooks) do 
		if Table[Object.Hook] and Table[Object.Hook][Object.Name] then
			TAC.Flag("Hooks", "Bad Hook [hook: %s; name: %s]", Object.Hook, Object.Name)
			break
		end
	end
	
	for Hook, Sub in pairs(Table) do
		for Name, p in pairs(Sub) do
			local Match = TAC.Match(Name)
			
			if Match then
				TAC.Flag("Hooks", "Bad Hook Match [hook: %s; name: %s; match: %s]", Hook, Name, Match)
			end
		end
	end
	
	timer.Simple(Config.Delay, Scan)
end

timer.Simple(Config.Delay, Scan)