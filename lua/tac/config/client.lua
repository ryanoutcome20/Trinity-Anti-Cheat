--[[ ~~~~~~~~~~~~~~~~~~ ]]--
--[[ Trinity Anti-Cheat ]]--
--[[ ~~~~~~~~~~~~~~~~~~ ]]--

-- Don't touch these.
local Config = { }


--- Flag Batches ---

Config.Batch = 32000

--- Aimbot Checks ---

/*
	This check leverages the default games mouse calculations to attempt to
	detect strange mouse patterns. 
	
	This occurs most commonly in faulty or incomplete C++ mouse aimbots 
	although some Lua based ones will fail this as well.
*/

Config.Mouse = {
	Enabled = true,

	CheckY = true,
	OffsetY = 5,
	
	CheckX = true,
	OffsetX = 5
}

/*
	This check simply detects when the player is using movement code more
	than once to fix a prediction issue with all Source games. This fix 
	increases their accuracy with Aimbots but is also trivial to detect.
*/

Config.Prediction = {
	Enabled = true
}

/*
	This check simply sits between StartCommand and SetupMove to detect players
	manipulating CUserCMD values within CreateMove. Likely to false flag some
	addons that meddle with these values especially view angles.
*/

Config.InputGuard = {
	Enabled = true,

	Angles = false,
	Offset = 1,

	Buttons = false,

	Movement = false
}

/*
	This check simply checks if the player is adjusting view angles within a
	VGUI frame. Might false flag alot of addons but you should probably
	disable it serverside!
*/

Config.MenuMovement = {
	Enabled = true
}
 
--- Integrity ---

Config.Tracer = true

Config.Stack = true

Config.Libraries = {
	Enabled = true,
	
	Command = true,
	Commands = 1,
			
	Net = true,
	Nets = 4
}

Config.JITHooks = {
	Enabled = true,

	Lines = true,

	Garbage = true,
	Delta = 100,
	Fill = 100,

	Step = 0.5
}

--- Static Cheats / Scripts ---

Config.Static = {
	Enabled = true,

	Interstate = true,
	Memoriam = true,
	Coffee = true,
	D3C = true,
	Majestic = true
}

--- Breakers ---

Config.FSB = {
	Enabled = false,

	Code = "\n",
	Identifier = ".DEL\nCON.",

	Spammer = true,
	Ticks = 1,
	Size = 1
}

Config.ESP = {
	Enabled = false
}

--- Scans ---

Config.Binaries = {
	Enabled = true,
	
	Detour = true
}

Config.Commands = {
	Enabled = true,
	Delay = 600,

	Detour = true
}

Config.Files = {
	Enabled = true
}

Config.Hooks = {
	Enabled = true,

	Delay = 45
}

--- Listeners ---

Config.Listeners = {
	Enabled = true
}

return Config