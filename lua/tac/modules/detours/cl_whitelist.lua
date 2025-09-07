TAC.Detours.Whitelist = {
	Counter = 0,
	Identifiers = { 
		["RunString(Ex)"] = true,
		["CompileString"] = true
	},
	Compiled = { }
}

-- Example identifier structure:
--[[
	["name"] = true
]]--
-- RunString("", "Test")

-- Example compiled structure:
--[[
	Hash = Hash or nil
	Length = Length or 0
]]--

function TAC.Detours.Whitelist.Whitelisted(Info, Function)
	local Whitelist = TAC.Detours.Whitelist
	
	if not TAC.Detours.Whitelist.Identifiers[Info.short_src] then
		return false
	end

	if tobool(Info.isfunc) and Info.what ~= "main" and TAC.Detours.Whitelist.Counter > 0 then
		if Info.namewhat == "global" and not _G[Info.name] then
			-- Raise an audit event?
			-- setfenv
		end
		
		return true
	end
	
	if TAC.Detours.Whitelist.Counter == 0 then
		return false
	end

	TAC.Detours.Whitelist.Counter = math.max(TAC.Detours.Whitelist.Counter - 1, 0)
	
	local Hash = TAC.Detours.Whitelist.Hash(Function)
	
	MsgN(Hash)
	PrintTable(Info)
	
	if not Hash then
		return false
	end
	
	for k, Object in ipairs(Whitelist.Compiled) do
		if Object.Hash == Hash then
			return true
		end
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

	local Valid, Dump = pcall(string.dump, Function)
	
	if not Valid then
		return 
	end
	
	return util.MD5(Dump)
end

function TAC.Detours.Whitelist.Increment()
	TAC.Detours.Whitelist.Counter = TAC.Detours.Whitelist.Counter + 1
end