TAC.Breakers = { }

if SERVER then
	include("sv_clicker.lua")
	include("sv_interpolated.lua")
	include("sv_pvs.lua")
	
	AddCSLuaFile("cl_fsb.lua")
else
	TAC.LoadFile("tac/breakers/cl_fsb.lua")
end

return true