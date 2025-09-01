TAC.Breakers = { }

if SERVER then
	include("sv_clicker.lua")
	include("sv_interpolated.lua")
	include("sv_pvs.lua")
	include("sv_spread.lua")
	
	return {
		"init.lua",
		"cl_fsb.lua"
	}
end