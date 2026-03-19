TAC.Breakers = { }

if SERVER then
	include("sv_interpolated.lua")
	include("sv_clicker.lua")
	include("sv_far_esp.lua")
	include("sv_pvs.lua")
	
	return {
		"init.lua",
		"cl_fsb.lua",
		"cl_esp.lua"
	}
end