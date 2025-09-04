TAC.Detours = { 
	Cache = { }
}

if CLIENT then
	TAC.Detours = {
		Ran = { }
	}

	return
end

include("sv_whitelist.lua")
include("sv_cache.lua")
include("sv_verify.lua")

function TAC.Detours.Integrity(Player, Message, ...)
	return TAC.Punishment.Wrapper("Client Integrity", Player, Message, ...)
end

return {
	"init.lua",
	"cl_whitelist.lua",
	"cl_capture.lua",
	"cl_detours.lua"
}