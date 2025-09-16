function TAC.Detours.File(Directory)
	if not Directory then 
		return {
			Exists = false,
			Lines = 0
		}
	end

	Directory = string.TrimLeft(Directory, "lua/")
	
	if string.StartWith(Directory, "addons/") then
		Directory = string.Split(Directory, "/")
		
		for i = 1, 3 do
			table.remove(Directory, 1)
		end
		
		Directory = table.concat(Directory, "/")
	end
	
	Directory = string.TrimLeft(Directory, "gamemodes/")
	
	TAC.Detours.Cache[Directory] = {
		Exists = false,
		Lines = 0
	}
	
	local Exists = file.Exists(Directory, "LUA")
	
	TAC.Detours.Cache[Directory].Exists = Exists

	if not Exists then
		return TAC.Detours.Cache[Directory]
	end
	
	local Code = file.Read(Directory, "LUA")
	
	if not Code then
		return TAC.Detours.Cache[Directory]
	end

	TAC.Detours.Cache[Directory].Lines = #string.Split(Code, "\n")
	
	return TAC.Detours.Cache[Directory]
end

function TAC.Detours.Get(Directory)
	if TAC.Detours.Cache[Directory] then
		return TAC.Detours.Cache[Directory]
	end
	
	return TAC.Detours.File(Directory)
end