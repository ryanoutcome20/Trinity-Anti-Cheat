--- Setup ---

local Config = TAC.Config.Scans.Commands

if not Config.Enabled then
	return
end

local List = TAC.Lists.Merge("Commands")

--- Main Loop ---

local function Scan()
	local Name, Value = debug.getupvalue(concommand.GetTable, 1)
	
	if not istable(Value) then
		Value = concommand.GetTable()
		
		if not istable(Value) then
			return TAC.Flag("Commands", "Bad Commands [none]")
		end
	end
	
	for Name, Value in pairs(Value) do 
		if List[Name] then
			TAC.Flag("Commands", "Bad Commands [concommand; name: %s]", Name)
			continue
		end
		
		local Match = TAC.Match(Name)
		
		if Match then
			TAC.Flag("Commands", "Bad Commands [matched; name: %s; match: %s]", Name, Match)
			continue
		end
	end
	
	timer.Simple(Config.Delay, Scan)
end

timer.Simple(Config.Delay, Scan)

-- Detours ---

local CreateConVar = Get("CreateConVar")

_G.CreateConVar = function(Name, ...)
	if List[string.lower(Name)] then
		return TAC.Flag("Commands", "Bad Commands [convar; name: %s]", Name)
	end
			
	local Match = TAC.Match(Name)
	
	if Match then
		TAC.Flag("Commands", "Bad Commands [matched; name: %s; match: %s]", Name, Match)
		return
	end
	
	return CreateConVar(Name, ...)
end

local AddConsoleCommand = Get("AddConsoleCommand")

_G.AddConsoleCommand = function(Name, ...)
	if List[string.lower(Name)] then
		return TAC.Flag("Commands", "Bad Commands [acc; name: %s]", Name)
	end
	
	return AddConsoleCommand(Name, ...)
end