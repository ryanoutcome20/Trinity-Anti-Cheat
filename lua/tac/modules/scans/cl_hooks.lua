 --- Setup ---

local Config = TAC.Config.Scans.Hooks

if not Config.Enabled then
	return
end

local Hooks = TAC.Lists.Merge("Hooks")
local Match = TAC.Lists.Merge("Match")

--- Main Loop ---

local function Scan()
	local Table = hook.GetTable()
	
	for k, Object in pairs(Hooks) do 
		if Table[Object.Hook] and Table[Object.Hook][Object.Name] then
			TAC.Flag("Hooks", "Bad Hook [hook: %s; name: %s]", Object.Hook, Object.Name)
			break
		end
	end
	
	for Hook, v in pairs(Table) do
		for Name, p in pairs(Hooks) do
			local Match = TAC.Match(string.lower(tostring(Name)))
			if Match then
				TAC.Flag("Hooks", "Bad Hook Match [hook: %s; name: %s; match: %s]", Hook, Name, Match)
			end
		end
	end
	
	timer.Simple(Config.Delay, Scan)
end

timer.Simple(Config.Delay, Scan)