local function Count(Table)
	local Size = 0
	
    for k in pairs(Table) do 
        Size = Size + 1 
    end
	
    return Size
end

TAC_Packages = { }

for Name, Value in pairs(package.loaded) do 
    if Name == "_G" then
        continue
    end

    TAC_Packages[Name] = Count(Value)
end