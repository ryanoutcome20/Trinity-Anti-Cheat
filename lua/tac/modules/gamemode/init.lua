local File = "tac/gamemode/cl_" .. engine.ActiveGamemode() .. ".lua"

if file.Exists(File, "LUA") then
	return {
		File
	}, true
end