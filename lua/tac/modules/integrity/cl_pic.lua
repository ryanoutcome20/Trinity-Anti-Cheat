TAC.PIC = { }

function TAC.PIC.Generate(Target, Visited, Buffer)
	Visited = Visited or { 
		[_G] = true
	}
	Target = Target or _G
	Buffer = Buffer or { }

	for k,v in pairs(Target) do 
		if Visited[v] then
			continue
		end
		
		Visited[v] = true
		
		if istable(v) then
			if Buffer[k] then
				continue
			end
		
			Buffer[k] = { }
			TAC.PIC.Generate(v, Visited, Buffer[k])
		elseif isfunction(v) then
			Buffer[k] = { 
				Key = tostring(k),
				Value = TAC.GenerateBuffer(v)
			}
		end
	end
	
	return Buffer
end

function TAC.PIC.Sort(Target)
	local Keys = { }
	
	for k,v in pairs(Target) do
		table.insert(Keys, k)
	end
	
	table.sort(Keys, function(a, b)
		return tostring(a) < tostring(b)
	end)
	
	return Keys
end

function TAC.PIC.GenerateChecksum(Target, Buffer)
	Buffer = Buffer or ""

	local Keys = TAC.PIC.Sort(Target)
	
	for k, v in ipairs(Keys) do
		local Object = Target[v]
		
		if not istable(Object) then
			continue
		end
		
		if Object.Key and Object.Value then
			Buffer = Buffer .. "|" .. Object.Key .. ":" .. Object.Value
		else
			Buffer = Buffer .. "|" .. tostring(v)
			Buffer = Buffer .. TAC.PIC.GenerateChecksum(Object, "")
		end
	end
	
	return util.CRC(Buffer)
end


function TAC.PIC.Run()
	if not TAC.Config.Integrity.PIC then
		return
	end

	local Checksum = TAC.PIC.GenerateChecksum(TAC.PIC.Generate())
		
	TAC.Atlas:Send(
		"PIC", 
		Checksum
	)
	
	if not TAC.Config.Silent then
		TAC.Print("PIC Checksum: %s", Checksum)
	end
end

TAC.PIC.Run()