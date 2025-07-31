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

if not TAC then
	MsgN("Can't load any further due to missing init.lua file!")
	MsgN("Check your addons and try again!")
	
	Header()
	
	return
end

--- Pre-Base ---

MsgN("  Loading punishment stubs")
include("tac_pstub.lua")

MsgN("  Checking debug file")
include("tac_debug.lua")

--- Config ---

TAC.Version = "0.0.6"
TAC.Edition = "Pre-Alpha"

MsgN("  Loading config")
include("tac_config.lua")
AddCSLuaFile("tac_config.lua")

--- Setup ---

MsgN("  Loading base")
include("tac_base.lua")

MsgN("  Caching resources")
-- ...

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

TAC.Plugins_SV = 0
TAC.Plugins_CL = 0 

for k, Plugin in ipairs(file.Find("tac/*.lua", "LUA")) do
	if Plugin:StartWith("sv_") then
		include("tac/" .. Plugin)
		TAC.Plugins_SV = TAC.Plugins_SV + 1
		continue
	elseif Plugin:StartWith("cl_") then
		AddCSLuaFile("tac/" .. Plugin)
		TAC.Plugins_CL = TAC.Plugins_CL + 1
		continue
	end

	include("tac/" .. Plugin)
	AddCSLuaFile("tac/" .. Plugin)
		
	TAC.Plugins_SV = TAC.Plugins_SV + 1
	TAC.Plugins_CL = TAC.Plugins_CL + 1
end

--- End ---

MsgN("")

MsgN(string.format(
	"  Loaded [%i] Serverside Plugins, [%i] Clientside Plugins, [%i] Lists!",
	TAC.Plugins_SV,
	TAC.Plugins_CL,
	TAC.Lists
))

MsgN(string.format(
	"  Version %s [%s] Done!",
	TAC.Version,
	TAC.Edition
))

Header()