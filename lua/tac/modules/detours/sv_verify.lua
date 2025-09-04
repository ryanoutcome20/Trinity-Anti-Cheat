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
			MsgN("whitelisted: " .. Function.short_src)
			continue
		end
		
		if Function.short_src == "[C]" then
			if Function.linedefined ~= -1 or Function.linedefined ~= Function.lastlinedefined then
				MsgN("FLAG [C]: LD")
			end
			
			if Function.j_linedefined ~= "ld" then
				MsgN("FLAG [C]: J_LD")
			end
			
			if Function.what == "main" then
				MsgN("FLAG [C]: Lua Executor")
			end
			
			continue
		end
	
		local Cache = TAC.Detours.Get(Function.short_src)
	
		if not Cache.Exists then
			MsgN("Flag: " .. Function.short_src)
			MsgN(Message)
			PrintTable(Function)
		else
			MsgN("PASS: " .. Function.short_src)
		end
	end
end

Atlas:Listen("Function Batch", "TAC.Detours.Verify", MODE_DONE, TAC.Detours.Verify)