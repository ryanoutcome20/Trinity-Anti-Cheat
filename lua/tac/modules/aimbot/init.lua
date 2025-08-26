TAC.Aimbot = { }

if SERVER then
	include("sv_snap.lua")
	include("sv_mouse.lua")
	include("sv_static.lua")
	include("sv_angles.lua")
	include("sv_nospread.lua")
	include("sv_autoclicker.lua")
	include("sv_micromovement.lua")
	include("sv_emulated_mouse.lua")
	
	return {
		"init.lua",
		"cl_input_guard.lua",
		"cl_engine_prediction.lua",
		"cl_menu_movement.lua"
	}
end