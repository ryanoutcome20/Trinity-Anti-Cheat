TAC.Detours.Whitelist = {
	Counter = 0,
	Identifiers = { 
		["RunString(Ex)"] = true,
		["CompileString"] = true
	},
	Hashes = { },
	Dumps = { }
}

setmetatable(TAC.Detours.Whitelist.Dumps, {
	__mode = "k"
})

function TAC.Detours.Whitelist.Whitelisted(Function, Info)
	local Whitelist = TAC.Detours.Whitelist

	if Whitelist.Counter == 0 or not Whitelist.Identifiers[Info.short_src] then
		return false
	end

	if tobool(Info.isfunc) and Info.what ~= "main" then
		if Info.namewhat == "global" and not _G[Info.name] then
			TAC.Audit(
				"Whitelist encountered secure shell environment, possible bypass attempt?", 
				"Detours",
				"Shell Environment"
			)
		end
		
		return true
	end
	
	local Hash = Whitelist.Hash(Function, Info.short_src)

	if Hash and Whitelist.Hashes[Hash] then
		Whitelist.Counter = math.max(Whitelist.Counter - 1, 0)
		return true
	end
	
	return false
end

function TAC.Detours.Whitelist.Hash(Function, Identifier)
	if not Function then
		return
	end
	
	if isstring(Function) then
		Function = CompileString(Function, Identifier)
	end
	
	if TAC.Detours.Whitelist.Dumps[Function] then
		return TAC.Detours.Whitelist.Dumps[Function]
	end

	local Valid, Dump = pcall(string.dump, Function, true)

	if not Valid then
		return 
	end
	
	local Checksum = util.CRC(Dump) 
	
	TAC.Detours.Whitelist.Dumps[Function] = Checksum
	
	return Checksum
end

function TAC.Detours.Whitelist.Increment()
	TAC.Detours.Whitelist.Counter = TAC.Detours.Whitelist.Counter + 1
end

function TAC.Detours.Whitelist.Update(Code, Identifier)
	TAC.Detours.Whitelist.Hashes[TAC.Detours.Whitelist.Hash(Code, Identifier)] = true
end