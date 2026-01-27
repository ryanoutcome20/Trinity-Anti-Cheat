function TAC.Detours.CheckC(Player, Object)
	if not isnumber(Object.linedefined) or not isnumber(Object.lastlinedefined) then
		return TAC.Detours.Wrapper(Player, "Emulated C [line not number]")
	elseif not isstring(Object.j_linedefined) then
		return TAC.Detours.Wrapper(Player, "Emulated C [jit line not string]")
	elseif not isstring(Object.what) then
		return TAC.Detours.Wrapper(Player, "Emulated C [what not string]")
	end

	if Object.linedefined ~= -1 or Object.linedefined ~= Object.lastlinedefined then
		return TAC.Detours.Wrapper(Player, "Emulated C [%i ~= %i]", Object.linedefined, Object.lastlinedefined)
	end
	
	if Object.j_linedefined ~= "ld" then
		return TAC.Detours.Wrapper(Player, "Emulated C [line: %s]", TAC.Fix(Object.j_linedefined))
	end
	
	if Object.what == "main" then
		return TAC.Detours.Wrapper(Player, "Lua Executor")
	end
end

function TAC.Detours.CheckLua(Player, Object)
	if not isstring(Object.short_src) then
		return TAC.Detours.Wrapper(Player, "Emulated Lua [short source not string]")
	elseif not isstring(Object.what) then
		return TAC.Detours.Wrapper(Player, "Emulated Lua [short source not string]")
	elseif not isnumber(Object.lastlinedefined) then
		return TAC.Detours.Wrapper(Player, "Emulated Lua [last line not number]")
	elseif not isnumber(Object.linedefined) or not isnumber(Object.j_linedefined) then
		return TAC.Detours.Wrapper(Player, "Emulated Lua [lines not number]")
	end

	local Cache = TAC.Detours.Get(Object.short_src)

	if not Cache.Exists then
		return TAC.Detours.Wrapper(Player, "Source [%s -> %s]", TAC.Fix(Object.Message), TAC.Fix(Object.short_src))
	elseif Object.lastlinedefined > Cache.Lines then
		return TAC.Detours.Wrapper(Player, "Source [%s -> %s, lines]", TAC.Fix(Object.Message), TAC.Fix(Object.short_src))
	end
end

function TAC.Detours.Verify(Mode, Player, Objects)
	if not Objects or not istable(Objects) then
		return TAC.Detours.Integrity(
			Player, 
			"Invalid detour objects [got: %s; expected: table]", 
			type(Objects)
		)
	end
	
	for k, Object in ipairs(Objects) do 		
		if TAC.Detours.Whitelisted(Player, Object.short_src, Object.what) then
			continue
		end
		
		if Object.short_src == "[C]" then
			TAC.Detours.CheckC(Player, Object)
		else
			TAC.Detours.CheckLua(Player, Object)
		end
	end
end

Atlas:Listen("Function Batch", "TAC.Detours.Verify", MODE_DONE, TAC.Detours.Verify)