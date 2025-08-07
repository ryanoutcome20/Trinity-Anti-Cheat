--[[ ~~~~~~~~~~~~~~~~~~ ]]--
--[[ Trinity Anti-Cheat ]]--
--[[ ~~~~~~~~~~~~~~~~~~ ]]--

local function Header()
	MsgN("")
	MsgN("--[[ ~~~~~~~~~~~~~~~~~~ ]]--")
	MsgN("--[[ Trinity Anti-Cheat ]]--")
	MsgN("--[[ ~~~~~~~~~~~~~~~~~~ ]]--")
	MsgN("")
end

--- Initialize ---

Header()

TAC = { }

--- Base ---

MsgN("  Loading punishment stubs")
include("tac_pstub.lua")

MsgN("  Checking debug file")
include("tac_debug.lua")

MsgN("  Loading base")
include("tac_base.lua")

MsgN("  Caching resources")
-- ...

--- Config ---

TAC.Version = "0.1.1"
TAC.Edition = "Pre-Alpha"

MsgN("  Loading config")
include("tac_config.lua")

--- Clientside ---

MsgN("  Creating clientside")
AddCSLuaFile("tac_client.lua")

--- Backends ---

MsgN("  Loading backend managers")

TAC.Backends = { }

for k, Backend in ipairs(file.Find("backends/*.lua", "LUA")) do 
	local Name, Data = include("backends/" .. Backend)
	
	if not Name or not Data then
		continue
	end
	
	TAC.Backends[string.lower(Name)] = Data
end

--- Lists ---
 
MsgN("  Loading lists")

TAC.Lists = 0
 
for k, List in ipairs(file.Find("lists/*.lua", "LUA")) do 
	if List:StartWith("sv_") then
		include("lists/" .. List)
	elseif List:StartWith("sh_") then
		include("lists/" .. List)
		AddCSLuaFile("lists/" .. List)
	elseif List:StartWith("cl_") then
		AddCSLuaFile("lists/" .. List)
	end

	TAC.Lists = TAC.Lists + 1
end

--- Plugins ---

MsgN("  Loading plugins")

TAC.Plugins = 0 

local function LoadPlugins(Root)
	Root = Root or "tac/"

    local Stack = { }
	
    table.insert(Stack, Root)

    while #Stack > 0 do
        local Directory = table.remove(Stack)
        local Files, Directories = file.Find(Directory .. "*", "LUA")

		if Root ~= Directory then
			local Formatted = Directory .. "/" .. "init.lua"
			
			if file.Exists(Formatted, "LUA") then
				if include(Formatted) then
					AddCSLuaFile(Formatted)
				end
				
				TAC.Plugins = TAC.Plugins + 1
			end
		end

        for k, Sub in ipairs(Directories) do
            table.insert(Stack, Directory .. "/" .. Sub .. "/")
        end
    end
end

LoadPlugins()

--- End ---

MsgN("")

MsgN(string.format(
	"  Loaded [%i] Plugins, [%i] Lists!",
	TAC.Plugins,
	TAC.Lists
))

MsgN(string.format(
	"  Version %s [%s] Done!",
	TAC.Version,
	TAC.Edition
))

Header()