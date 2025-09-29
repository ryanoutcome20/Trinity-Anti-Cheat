local List = TAC.Lists.Merge("Binaries")

local function Scan()
	local Config = TAC.Config.Binaries

	if not Config.Enabled then
		return
	end

	for Module, v in pairs(List) do
		local Names, Flag = TAC.GetBinaryNames(Module), false

		for k, Name in ipairs(Names) do
			if file.Exists(Name, "GAME") then
				TAC.Flag("Binaries", "Bad Module [exists; name: %s]", Module)
				Flag = true
			elseif file.Read(Name, "GAME") ~= nil then
				TAC.Flag("Binaries", "Bad Module [valid; name: %s]", Module)
				Flag = true
			end
		end
		
		if Flag then
			break
		end
	end

	if not Config.Detour then
		return
	end

	TAC.Detour.Register("require", function(Original, Name, ...)
		if List[string.lower(Name)] then
			TAC.Flag("Binaries", "Bad Module [req; name: %s]", Name)
		end
		
		return Original(Name, ...)
	end)
end

hook.Add("TAC.Initialize", "TAC.Binaries", Scan)