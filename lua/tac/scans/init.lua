if SERVER then
	AddCSLuaFile("cl_binaries.lua")
	AddCSLuaFile("cl_hooks.lua")

	return true
end

TAC.LoadFile("tac/scans/cl_binaries.lua")
TAC.LoadFile("tac/scans/cl_hooks.lua")