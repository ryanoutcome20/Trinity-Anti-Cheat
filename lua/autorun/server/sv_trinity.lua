--[[ ~~~~~~~~~~~~~~~~~~ ]]--
--[[ Trinity Anti-Cheat ]]--
--[[ ~~~~~~~~~~~~~~~~~~ ]]--

MsgN("")
MsgN("--[[ ~~~~~~~~~~~~~~~~~~ ]]--")
MsgN("--[[ Trinity Anti-Cheat ]]--")
MsgN("--[[ ~~~~~~~~~~~~~~~~~~ ]]--")
MsgN("")

TAC = { }

--- Config ---

TAC.Version = "0.0.1"
TAC.Edition = "Pre-Alpha"

MsgN("  Loading config")
include("tac_config.lua")

--- Setup ---

MsgN("  Loading base")
include("tac_base.lua")

MsgN("  Caching resources")
-- ...

--- Lists ---

MsgN("  Loading lists")

TAC.Lists = 0
 
for k, List in pairs(file.Find("lists/*.lua", "LUA")) do 
	if (List:StartWith("sv_")) then
		include("lists/" .. List)
	elseif(List:StartWith("sh_")) then
		include("lists/" .. List)
		AddCSLuaFile("lists/" .. List)
	elseif(List:StartWith("cl_")) then
		AddCSLuaFile("lists/" .. List)
	end

	TAC.Lists = TAC.Lists + 1
end

--- Plugins ---

MsgN("  Loading plugins")

TAC.Plugins = 0

for k, Plugin in pairs(file.Find("tac/*.lua", "LUA")) do
	if (Plugin:StartWith("sv_")) then
		include("tac/" .. Plugin)
	elseif(Plugin:StartWith("sh_")) then
		include("tac/" .. Plugin)
		AddCSLuaFile("tac/" .. Plugin)
	elseif(Plugin:StartWith("cl_")) then
		AddCSLuaFile("tac/" .. Plugin)
	end

	TAC.Plugins = TAC.Plugins + 1
end

--- End ---

MsgN("")

MsgN("  Loaded [" .. TAC.Plugins .. "] Plugins, [" .. TAC.Lists .. "] Lists!")

MsgN("  Version " .. TAC.Version .. " [" .. TAC.Edition .. "] Done!")

MsgN("")
MsgN("--[[ ~~~~~~~~~~~~~~~~~~ ]]--")
MsgN("--[[ Trinity Anti-Cheat ]]--")
MsgN("--[[ ~~~~~~~~~~~~~~~~~~ ]]--")
MsgN("")