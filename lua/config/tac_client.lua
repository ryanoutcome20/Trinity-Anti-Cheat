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

--- Lua Execution / Detours ---

Config.Tracer = true
Config.PIC = true

--- Breakers ---

Config.FSB = {
	Enabled = true,
	
	Code = "\n",
	Identifiers = {
		".\n."
	},
	Handle = RunString,
	
	Spammer = true,
	Size = 1
}


return Config