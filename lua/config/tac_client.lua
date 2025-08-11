--[[ ~~~~~~~~~~~~~~~~~~ ]]--
--[[ Trinity Anti-Cheat ]]--
--[[ ~~~~~~~~~~~~~~~~~~ ]]--

-- Don't touch these.
local Config = { }

--- General ---

Config.Silent = false

Config.FlagInterval = 0.25

--- Aimbot ---

Config.Mouse = true
Config.EnginePrediction = true

--- Breakers ---

Config.FSB = {
	Enabled = false,
	
	Code = "\n",
	Identifier = {
		"COM",
		"\00"
	},
	Handle = RunString
}


return Config