local File = "tac/gamemode/cl_" .. engine.ActiveGamemode() .. ".lua"

if file.Exists(File, "LUA") then
	TAC.LoadCode(file.Read(File, "LUA"), File)
end