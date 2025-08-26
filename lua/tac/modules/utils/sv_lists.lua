TAC.Lists = { 
	Cache = { }
}

function TAC.Lists.Merge(Name, Shared)
	local Prefix = Shared and "sh_" or "sv_"

	if TAC.Lists.Cache[Name] then
		return TAC.Lists.Cache[Name]
	end

	TAC.Lists.Cache[Name] = include("tac/lists/" .. Prefix .. string.lower(Name) .. ".lua")
	
	return TAC.Lists.Cache[Name]
end

function TAC.Lists.Grab(Name)
	return TAC.Lists.Cache[Name]
end