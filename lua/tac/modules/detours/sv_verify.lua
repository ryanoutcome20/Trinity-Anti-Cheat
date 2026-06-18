function TAC.Detours.CheckC(Player, Object)
	if not isnumber(Object.linedefined) or not isnumber(Object.lastlinedefined) then
		return TAC.Detours.Wrapper(
			Player, 
			"Emulated C [lines; number expected got %s and %s]", 
			type(Object.linedefined), type(Object.lastlinedefined)
		)
	elseif not isstring(Object.j_linedefined) then
		return TAC.Detours.Wrapper(
			Player, 
			"Emulated C [jit lines; string expected got %s]",
			type(Object.j_linedefined)
		)
	elseif not isstring(Object.what) then
		return TAC.Detours.Wrapper(
			Player, 
			"Emulated C [what; string expected got %s]", 
			type(Object.what)
		)
	end

	if Object.linedefined ~= -1 then
		return TAC.Detours.Wrapper(
			Player, 
			"Emulated C [line valid: %i]", 
			Object.linedefined
		)
	elseif Object.linedefined ~= Object.lastlinedefined then
		return TAC.Detours.Wrapper(
			Player, 
			"Emulated C [%i ~= %i]", 
			Object.linedefined, 
			Object.lastlinedefined
		)
	end
	
	if Object.j_linedefined ~= "ld" then
		return TAC.Detours.Wrapper(
			Player, 
			"Emulated C [jit line valid: %s]", 
			TAC.Fix(Object.j_linedefined)
		)
	end
	
	if Object.what == "main" then
		return TAC.Detours.Wrapper(
			Player, 
			"Lua Executor"
		)
	end
	
	return true
end

function TAC.Detours.CheckLua(Player, Object)
	if not isstring(Object.short_src) then
		return TAC.Detours.Wrapper(
			Player, 
			"Emulated Lua [short_src; string expected got %s]", 
			type(Object.short_src)
		)
	elseif not isstring(Object.what) then
		return TAC.Detours.Wrapper(
			Player, 
			"Emulated Lua [what; string expected got %s]", 
			type(Object.what)
		)
	elseif not isnumber(Object.lastlinedefined) then
		return TAC.Detours.Wrapper(
			Player, 
			"Emulated Lua [last line; number expected got %s]", 
			type(Object.lastlinedefined)
		)
	elseif not isnumber(Object.linedefined) or not isnumber(Object.j_linedefined) then
		return TAC.Detours.Wrapper(
			Player, 
			"Emulated Lua [lines; number expected got %s and %s]", 
			type(Object.linedefined), 
			type(Object.j_linedefined)
		)
	elseif Object.last and not isbool(Object.last) then
		return TAC.Detours.Wrapper(
			Player, 
			"Emulated Lua [last; bool or nil expected got %s]", 
			type(Object.last)
		)
	end

	if Object.j_linedefined ~= Object.linedefined then
		return TAC.Detours.Wrapper(
			Player, 
			"Emulated Lua [lines; %i ~= %i]", 
			Object.j_linedefined, 
			Object.linedefined
		)
	elseif Object.linedefined > Object.lastlinedefined then
		return TAC.Detours.Wrapper(
			Player, 
			"Emulated Lua [last over line; %i > %i]", 
			Object.lastlinedefined, 
			Object.linedefined
		)
	end

	local Cache = TAC.Detours.Get(Object.short_src)

	if not Cache.Exists then
		return TAC.Detours.Wrapper(
			Player, 
			"Source [%s -> %s]", 
			TAC.Fix(Object.Message), 
			TAC.Fix(Object.short_src)
		)
	elseif Object.lastlinedefined > Cache.Lines then
		return TAC.Detours.Wrapper(
			Player, 
			"Source [%s -> %s, lines]", 
			TAC.Fix(Object.Message), 
			TAC.Fix(Object.short_src)
		)
	elseif Object.name ~= "nn" and not Object.last then
		if not isnumber(Object.nextline) then
			return TAC.Detours.Wrapper(
				Player, 
				"Emulated Lua [next; number expected got %s]", 
				type(Object.nextline)
			)
		elseif not isstring(Object.nextsrc) then
			return TAC.Detours.Wrapper(
				Player, 
				"Emulated Lua [next; string expected got %s]", 
				type(Object.nextsrc)
			)
		end

		local nextCache = TAC.Detours.Get(Object.nextsrc)

		if nextCache.Split then
			local Index = nextCache.Split[Object.nextline]
		
			if not Index then
				return TAC.Detours.Wrapper(
					Player, 
					"Emulated Lua [next; invalid cache]"
				)
			elseif not string.find(Index, Object.name) then
				return TAC.Detours.Wrapper(
					Player, 
					"Emulated Lua [next; invalid data]"
				)
			end
		end
	end
	
	return true
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

		local Valid = Object.short_src == "[C]" and TAC.Detours.CheckC(Player, Object) or TAC.Detours.CheckLua(Player, Object)
		
		if Valid ~= true then
			break
		end
	end
end

Atlas:Listen("Function Batch", "TAC.Detours.Verify", MODE_DONE, TAC.Detours.Verify)