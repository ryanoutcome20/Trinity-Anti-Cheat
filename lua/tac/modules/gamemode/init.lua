local File = "tac/gamemode/cl_" .. engine.ActiveGamemode() .. ".lua"

if file.Exists(File, "LUA") then
	AddCSLuaFile(File)
	return {
		"cl_gamemode.lua"
	}
end