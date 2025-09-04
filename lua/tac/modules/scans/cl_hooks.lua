 --- Setup ---

local Config = TAC.Config.Scans.Hooks

if not Config.Enabled then
	return
end

local Hooks = TAC.Lists.Merge("Hooks")

--- Main Loop ---

local function Scan()
	local Table = hook.GetTable()
	local Name, Value = debug.getupvalue(hook.GetTable, 1)
	
	if Value ~= Table then
		return TAC.Flag("Hooks", "Bad Hook [detoured]", Object.Hook, Object.Name)
	end
	
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