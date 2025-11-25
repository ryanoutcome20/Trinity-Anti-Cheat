TAC.Detours = { 
	Cache = { }
}

include("sv_whitelist.lua")
include("sv_cache.lua")
include("sv_verify.lua")

function TAC.Detours.Integrity(Player, Message, ...)
	return TAC.Punishment.Wrapper("Client Integrity", Player, Message, ...)
end

function TAC.Detours.Wrapper(Player, Message, ...)
	return TAC.Punishment.Wrapper("Detours", Player, Message, ...)
end

return {
	"cl_detours.lua"
}