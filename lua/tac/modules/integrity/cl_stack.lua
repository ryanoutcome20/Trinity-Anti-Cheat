TAC.Stack = { }

local Config = TAC.Config.Integrity.Stack

function TAC.Stack.Scan()
	local Index = 0
	
	while true do 
		local Info = debug.getinfo(Index, "Sln")
		
		if not Info then
			break
		end
		
		if not Info.name or not Info.namewhat then
			if Index ~= 3 then
				return false, "name"
			end
		end
		
		if Info.what == "C" then
			if Info.currentline ~= -1 or Info.linedefined ~= -1 then
				return false, "C line"
			end
			
			if Index > 1 then
				return false, "C index"
			end
		end
	
		Index = Index + 1
	end
	
	return Index > 1, "Abrupt"
end

function TAC.Stack.Self()
	local Self = debug.getinfo(1)

	if not Self then
		return TAC.Flag("Stack", "Stack Fields [invalid]")
	end

	if Self.name ~= "Self" or Self.namewhat ~= "field" then
		return TAC.Flag("Stack", "Stack Fields [local]")
	end
end

function TAC.Stack.Caller()
	local Valid, Reason = TAC.Stack.Scan()
	
	if not Valid then
		return TAC.Flag("Stack", "Stack [%s]", Reason)
	end
end

if Config.Enabled then
	TAC.Timing.New(TAC.Stack.Caller, Config, true)
end

TAC.Stack.Self()