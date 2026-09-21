local List = TAC.Lists.Merge("Binaries")

local function Scan()
	local Config = TAC.Config.Scans.Binaries

	if not Config.Enabled then
		return
	end
    
    if not List then
        return TAC.Flag("Binaries", "Bad Module [missing]")
    end 

	for Module, v in pairs(List) do
		local Name, Flag = "lua/bin/" .. Module .. ".dll", false

		if file.Exists(Name, "GAME") then
			TAC.Flag("Binaries", "Bad Module [exists; name: %s]", Module)
			Flag = true
			break
		elseif file.Read(Name, "GAME") ~= nil then
			TAC.Flag("Binaries", "Bad Module [valid; name: %s]", Module)
			Flag = true
			break
		end
		
		if Flag then
			break
		end
	end
end

hook.Add("TAC.Initialize", "TAC.Binaries", Scan)