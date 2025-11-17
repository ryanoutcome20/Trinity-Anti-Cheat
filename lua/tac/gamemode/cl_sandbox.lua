local PLAYER = _G.FindMetaTable("Player")
local ENTITY = _G.FindMetaTable("Entity")

--- DarkRP Honeypot ---

_G.DarkRP = { }

setmetatable(_G.DarkRP, {
    __eq = function(...)
		TAC.Captures.Stack("DarkRP __eq")
        return
    end,
	
	__index = function(...)
		TAC.Captures.Stack("DarkRP __index")
		return
	end,
	
	__newindex = function(...)
		TAC.Captures.Stack("DarkRP __newindex")
		return
	end
})

function ENTITY:getDarkRPVar(...)
	local Caller = debug.getinfo(2)

	if Caller.what == "C" then
		TAC.Audit(
			"DarkRP getDarkRPVar called from C/C++ source?", 
			"DarkRP"
		)
	end

	TAC.Captures.Stack("getDarkRPVar")
end

PLAYER.getDarkRPVar = ENTITY.getDarkRPVar

--- TTT Honeypot ---

function ENTITY:IsDetective(...)
	local Caller = debug.getinfo(2)

	if Caller.what == "C" then
		TAC.Audit(
			"TTT IsDetective called from C/C++ source?", 
			"TTT"
		)
	end

	TAC.Captures.Stack("IsDetective")
end

PLAYER.IsDetective = ENTITY.IsDetective

function ENTITY:IsTraitor(...)
	local Caller = debug.getinfo(2)

	if Caller.what == "C" then
		TAC.Audit(
			"TTT IsTraitor called from C/C++ source?", 
			"TTT"
		)
	end

	TAC.Captures.Stack("IsTraitor")
end

PLAYER.IsTraitor = ENTITY.IsTraitor