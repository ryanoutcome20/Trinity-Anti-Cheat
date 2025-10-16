local PLAYER = _G.FindMetaTable("Player")
local ENTITY = _G.FindMetaTable("Entity")

--- DarkRP Honeypot ---

_G.DarkRP = { }

setmetatable(_G.DarkRP, {
    __eq = function(...)
		TAC.CaptureStack("DarkRP __eq")
        return
    end,
	
	__index = function(...)
		TAC.CaptureStack("DarkRP __index")
		return
	end,
	
	__newindex = function(...)
		TAC.CaptureStack("DarkRP __newindex")
		return
	end
})

function ENTITY:getDarkRPVar(...)
	local Caller = debug.getinfo(2)

	if Caller.what == "C" then
		-- TODO: Raise an audit event?
	end

	TAC.CaptureStack("getDarkRPVar")
end

PLAYER.getDarkRPVar = ENTITY.getDarkRPVar

--- TTT Honeypot ---

function ENTITY:IsDetective(...)
	local Caller = debug.getinfo(2)

	if Caller.what == "C" then
		-- TODO: Raise an audit event?
	end

	TAC.CaptureStack("IsDetective")
end

PLAYER.IsDetective = ENTITY.IsDetective

function ENTITY:IsTraitor(...)
	local Caller = debug.getinfo(2)

	if Caller.what == "C" then
		-- TODO: Raise an audit event?
	end

	TAC.CaptureStack("IsTraitor")
end

PLAYER.IsTraitor = ENTITY.IsTraitor