local List = TAC.Lists.Merge("Hooks")

local Cache = { }

local Config = TAC.Config.Scans.Hooks

local function Scan()
	if not Config.Enabled then
		return
	end
	
    if not List then
        return TAC.Flag("Hooks", "Bad Hook [missing]")
    end 
	
	local Table = hook.GetTable()
	
	for k, Object in ipairs(List) do 
		if Table[Object.Hook] and Table[Object.Hook][Object.Name] then
			TAC.Flag("Hooks", "Bad Hook [hook: %s; name: %s]", Object.Hook, Object.Name)
			break
		end
	end
	
	for Hook, Sub in pairs(Table) do
		Cache[Hook] = Cache[Hook] or { }

		for Name, Func in pairs(Sub) do
			if Cache[Hook][Func] then
				continue
			end

			Cache[Hook][Func] = true

			local Match = TAC.Match(Name)
			
			if Match then
				TAC.Flag("Hooks", "Bad Hook Match [hook: %s; name: %s; match: %s]", Hook, Name, Match)
			end

			TAC.Captures.Direct(Func, "hook.GetTable (sub)")
		end
	end
	
	timer.Simple(Config.Delay, Scan)
end

hook.Add("TAC.Initialize", "TAC.Hooks", function()
	timer.Simple(Config.Delay, Scan)
end)