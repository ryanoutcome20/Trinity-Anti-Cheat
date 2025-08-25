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
	
	AddCSLuaFile("cl_input_guard.lua")
	AddCSLuaFile("cl_engine_prediction.lua")
	AddCSLuaFile("cl_menu_movement.lua")
else
	TAC.LoadFile("tac/aimbot/cl_input_guard.lua")
	TAC.LoadFile("tac/aimbot/cl_engine_prediction.lua")
	TAC.LoadFile("tac/aimbot/cl_menu_movement.lua")
end

return true