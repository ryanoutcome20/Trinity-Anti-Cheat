local Files = TAC.Lists.Merge("Files")
local Directories = TAC.Lists.Merge("Directories")

local function Scan()
	local Config = TAC.Config.Files

	if not Config.Enabled then
		return
	end
	
	for Name, v in pairs(Files) do
		if file.Exists(Name, "DATA") then
			TAC.Flag("Files", "Bad File [name: %s]", Name)
			break
		end
	end

	for Name, v in pairs(Directories) do
		if file.IsDir(Name, "DATA") then
			TAC.Flag("Files", "Bad File Directory [data; name: %s]", Name)
			break
		end
		
		if file.IsDir(Name, "GAME") then
			TAC.Flag("Files", "Bad File Directory [game; name: %s]", Name)
			break
		end
		
		if file.IsDir("lua/" .. Name, "GAME") then
			TAC.Flag("Files", "Bad File Directory [lua; name: %s]", Name)
			break
		end
	end
end

hook.Add("TAC.Initialize", "TAC.Files", Scan)