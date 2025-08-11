local Loaded = 0

local function LoadPlugins(Root)
	Root = Root or "tac/"

    local Stack = { }
	
    table.insert(Stack, Root)

    while #Stack > 0 do
        local Directory = table.remove(Stack)
        local Files, Directories = file.Find(Directory .. "*", "LUA")

		if Root ~= Directory then
			local Formatted = Directory .. "init.lua"
			
			if file.Exists(Formatted, "LUA") then
				include(Formatted)
				
				Loaded = Loaded + 1
			end
		end

        for k, Sub in ipairs(Directories) do
            table.insert(Stack, Directory .. Sub .. "/")
        end
    end
end

LoadPlugins()