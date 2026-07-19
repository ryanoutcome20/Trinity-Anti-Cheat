if SERVER then
	return {
		"init.lua"
	}
end

TAC.Static = { }

local List = TAC.Lists.Merge("Static")

local TYPE_DIR = 0
local TYPE_FILE = 1

function TAC.Static.Run(Index)
	if Index[4] == TYPE_DIR then
		return file.IsDir(Index[3], Index[2])
	else
		return file.Exists(Index[3], Index[2])
	end
end

function TAC.Static.Scan()
	local Config = TAC.Config.Static
	
	if not Config.Enabled then
		return
	end

	if not List then
		return TAC.Flag("Static Script", "Script List [missing]")
	end
	
	for k, Index in ipairs(List) do 
		if TAC.Static.Run(Index) then
			TAC.Flag("Static Script", "Script Detected [name: %s]", Index[1])
		end
	end
end

hook.Add("TAC.Initialize", "TAC.Static.Scan", TAC.Static.Scan)