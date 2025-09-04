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

function TAC.Detours.Whitelist.Whitelisted(Info, Hash)
	local Whitelist = TAC.Detours.Whitelist
	
	if not Whitelist.Identifiers[Info.short_src] then
		return false
	end

	if tobool(Info.isfunc) and Info.what ~= "main" and Whitelist.Counter > 0 then
		if Info.namewhat == "global" and not _G[Info.name] then
			-- Raise an audit event?
			-- setfenv
		end
		
		return true
	end
	
	if Whitelist.Counter == 0 then
		return false
	end

	Whitelist.Counter = math.max(Whitelist.Counter - 1, 0)
		
	for k, Object in ipairs(Whitelist.Compiled) do 
		if Object.Hash == Hash and Object.Length == Info.lastlinedefined then
			return true
		end
	end
	
	return false
end

function TAC.Detours.Whitelist.Increment()
	TAC.Detours.Whitelist.Counter = TAC.Detours.Whitelist.Counter + 1
end