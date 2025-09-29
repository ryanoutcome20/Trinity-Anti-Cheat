local Config = TAC.Config.Commands
local List = TAC.Lists.Merge("Commands")

local function Scan()
	if not Config.Enabled then
		return
	end

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

local function Detour()
	if not Config.Enabled then
		return
	end

	timer.Simple(Config.Delay, Scan)

	if not Config.Detour then
		return
	end

	TAC.Detour.Register("CreateConVar", function(Original, Name, ...)
		if List[string.lower(Name)] then
			return TAC.Flag("Commands", "Bad Commands [convar; name: %s]", Name)
		end
				
		local Match = TAC.Match(Name)
		
		if Match then
			TAC.Flag("Commands", "Bad Commands [matched; name: %s; match: %s]", Name, Match)
			return
		end
		
		return Original(Name, ...)
	end)

	TAC.Detour.Register("AddConsoleCommand", function(Original, Name, ...)
		if List[string.lower(Name)] then
			return TAC.Flag("Commands", "Bad Commands [acc; name: %s]", Name)
		end
		
		return Original(Name, ...)
	end)
end

hook.Add("TAC.Initialize", "TAC.ConCommands", Detour)