if SERVER then
	AddCSLuaFile("cl_error_tracer.lua")
	AddCSLuaFile("cl_stack.lua")
	AddCSLuaFile("cl_libraries.lua")
	AddCSLuaFile("cl_pic.lua")
	AddCSLuaFile("cl_key_input.lua")
else
	TAC.LoadFile("tac/integrity/cl_error_tracer.lua")
	TAC.LoadFile("tac/integrity/cl_stack.lua")
	TAC.LoadFile("tac/integrity/cl_libraries.lua")
	TAC.LoadFile("tac/integrity/cl_pic.lua")
	TAC.LoadFile("tac/integrity/cl_key_input.lua")
end

return true