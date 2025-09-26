TAC.Static = { }

local List = TAC.Lists.Merge("Static")

local TYPE_DIR = 0
local TYPE_FILE = 1

function TAC.Static.Run(Index)
	if Index.Type == TYPE_DIR then
		return file.IsDir(Index.Directory, Index.Path)
	else
		return file.Exists(Index.Directory, Index.Path)
	end
end

function TAC.Static.Scan()
	local Config = TAC.Config.Static
	
	if not Config.Enabled then
		return
	end
	
	for k, Index in ipairs(List) do 
		if TAC.Static.Run(Index) then
			TAC.Flag("Static Script", "Script Detected [name: %s]", Index.Name)
		end
	end
end

hook.Add("TAC.Initialize", "TAC.Static.Scan", TAC.Static.Scan)