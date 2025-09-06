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

MsgN("  Loading stub systems")
include("tac/stubs/punishment_stubs.lua")
include("tac/stubs/module_stubs.lua")

MsgN("  Checking debug file")
include("tac/debug.lua")

MsgN("  Loading base")
include("tac/base.lua")

MsgN("  Caching resources")
-- ...

--- Config ---

TAC.Version = "0.1.8"
TAC.Edition = "Pre-Alpha"

MsgN("  Loading config")
include("tac/config/server.lua")

--- Clientside ---

MsgN("  Creating clientside")
AddCSLuaFile("tac/client.lua")
AddCSLuaFile("tac/config/client.lua")

--- Atlas ---

MsgN("  Creating Atlas instance")
include("atlas/sv_atlas.lua")
AddCSLuaFile("atlas/cl_atlas.lua")

--- Backends ---

MsgN("  Loading backend managers")

TAC.Backends = { }

for k, Backend in ipairs(file.Find("tac/backends/*.lua", "LUA")) do 
	local Name, Data = include("tac/backends/" .. Backend)
	
	if not Name or not Data then
		continue
	end
	
	TAC.Backends[string.lower(Name)] = Data
end

--- Lists ---
 
MsgN("  Caching lists")

for k, List in ipairs(file.Find("tac/lists/*.lua", "LUA")) do 
	if List:StartWith("sv_") then
		continue
	end
	
	AddCSLuaFile("tac/lists/" .. List)
end

--- Plugins ---

MsgN("  Loading plugins")

TAC.Plugins = 0

local function LoadPlugins(Root)
    Root = Root or "tac/modules"

    local Stack = { }
    table.insert(Stack, Root)

    while #Stack > 0 do
        local Directory = table.remove(Stack)
        local Files, Directories = file.Find(Directory .. "/*", "LUA")

        for k, Sub in ipairs(Directories) do
            table.insert(Stack, Directory .. "/" .. Sub)
        end

        if Root == Directory then
            continue
        end

        local Formatted = Directory .. "/init.lua"

        if file.Exists(Formatted, "LUA") then
			TAC.Plugins = TAC.Plugins + 1
			
            local Clientside, Absolute = include(Formatted)

            if not Clientside then
                continue
            end

            for k, Sub in ipairs(Clientside) do
                local Path = Absolute and Sub or Directory .. "/" .. Sub
                mStub.Register(Path)
            end
        end
    end
end

LoadPlugins()

--- End ---

MsgN("")

MsgN(string.format(
	"  Loaded [%i] Plugins!",
	TAC.Plugins,
	TAC.Lists
))

MsgN(string.format(
	"  Version %s [%s] Done!",
	TAC.Version,
	TAC.Edition
))

Header()

--- Dedicated Server ---

if not game.IsDedicated() then
	TAC.Print("Loopback / LAN server detected, anti-cheat cannot run at full capacity!")
end