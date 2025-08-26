TAC.Stack = { }

function TAC.Stack.Scan()
	local Index = 0
	
	while true do 
		local Info = debug.getinfo(Index, "Sln")
		
		if not Info then
			break
		end
		
		if not Info.name or not Info.namewhat then
			if Index ~= 2 then
				return false, "Name"
			end
		end
		
		if Info.what == "C" then
			if Info.currentline ~= -1 or Info.linedefined ~= -1 then
				return false, "C Line"
			end
			
			if Index > 1 then
				return false, "C Index"
			end
		end
	
		Index = Index + 1
	end
	
	return Index > 1, "Abrupt"
end

function TAC.Stack.Caller()
	local Valid, Reason = TAC.Stack.Scan()
	
	if not Valid then
		return TAC.Flag("Stack", "Stack %s", Reason)
	end
	
	timer.Simple(5, TAC.Stack.Caller)
end

if TAC.Config.Integrity.Stack then
	timer.Simple(5, TAC.Stack.Caller)
end