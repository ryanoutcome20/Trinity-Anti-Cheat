if SERVER then
	include("sv_environment.lua")
	
	return {
		"cl_error_tracer.lua",
		"cl_stack.lua",
		"cl_debug_self.lua",
		"cl_file_io.lua",
		"cl_garbage.lua",
		"cl_game_events.lua"
	}
end