function TAC.Detours.Verify(Mode, Player, Objects)
	if not Objects or not istable(Objects) then
		return TAC.Detours.Integrity(
			Player, 
			"Invalid detour objects [got: %s; expected: table]", 
			type(Objects)
		)
	end
	
	for k, Object in ipairs(Objects) do 
		local Function = Object.Function
		local Message = Object.Message
		
		if TAC.Detours.Whitelisted(Player, Function.short_src, Function.what) then
			continue
		end
		
		if Function.short_src == "[C]" then
			if not isnumber(Function.linedefined) or not isnumber(Function.lastlinedefined) then
				return TAC.Detours.Wrapper(Player, "Emulated C [line not number]")
			elseif not isstring(Function.j_linedefined) then
				return TAC.Detours.Wrapper(Player, "Emulated C [jit line not string]")
			elseif not isstring(Function.what) then
				return TAC.Detours.Wrapper(Player, "Emulated C [what not string]")
			end
		
			if Function.linedefined ~= -1 or Function.linedefined ~= Function.lastlinedefined then
				TAC.Detours.Wrapper(Player, "Emulated C [%i ~= %i]", Function.linedefined, Function.lastlinedefined)
			end
			
			if Function.j_linedefined ~= "ld" then
				TAC.Detours.Wrapper(Player, "Emulated C [line: %s]", TAC.Fix(Function.j_linedefined))
			end
			
			if Function.what == "main" then
				TAC.Detours.Wrapper(Player, "Lua Executor")
			end
			
			continue
		end
	
		local Cache = TAC.Detours.Get(Function.short_src)
	
		if not Cache.Exists then
			TAC.Detours.Wrapper(Player, "Source [%s]", TAC.Fix(Function.short_src))
		end
	end
end

Atlas:Listen("Function Batch", "TAC.Detours.Verify", MODE_DONE, TAC.Detours.Verify)