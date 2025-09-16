--- Setup ---

if not TAC.Config.Scans.Binaries.Enabled then
	return
end

local List = TAC.Lists.Merge("Binaries")

function TAC.GetBinaryNames(Name)
	-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/includes/extensions/util.lua#L394-L418

	local Names = { }
	local Suffixes = { "osx64", "osx", "linux64", "linux", "linux32", "win64", "win32" }
	
	for k, Suffix in ipairs(Suffixes) do 
		table.insert(Names, string.format(
			"lua/bin/gmcl_%s_%s.dll", 
			Name, 
			Suffix
		))
		
		table.insert(Names, string.format(
			"lua/bin/gmsv_%s_%s.dll", 
			Name, 
			Suffix
		))
	end
	
	return Names
end

--- Main Loop ---

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

-- Detour ---

TAC.Detour.Register("require", function(Original, Name, ...)
	if List[string.lower(Name)] then
		TAC.Flag("Binaries", "Bad Module [req; name: %s]", Name)
	end
	
	return Original(Name, ...)
end)