TAC.Commands = { }

if SERVER then
	include("sv_command.lua")

	return {
		"init.lua",
		"cl_command.lua"
	}
end