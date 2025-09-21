--[[ ~~~~~~~~~~~~~~~~~~ ]]--
--[[ Trinity Anti-Cheat ]]--
--[[ ~~~~~~~~~~~~~~~~~~ ]]--

-- Don't touch these.
local Config = { }

--- General ---

Config.Silent = false

Config.BatchSize = 32000
Config.BatchCount = 32

--- Aimbot ---

Config.Aimbot = {
	Mouse = true,
	EnginePrediction = true,
	InputGuard = {
		Buttons = false,
		
		Angles = false,
		Offset = 1,
		
		Movement = false
	},
	EmulatedMouse = {
		Enabled = true,
		
		Yaw = true,
		YawOffset = 5,
		
		Pitch = true,
		PitchOffset = 5
	}
}

--- Pre-Init ---

Config.Integrity = {
	Tracer = true,
	PIC = true,
	Stack = true,
	Libraries = {
		Enabled = true,
		
		Command = true,
		Commands = 1,
		
		Hook = true,
		Hooks = 19,
		
		Net = true,
		Nets = 4
	},
	Keys = true
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

Config.Breakers = {
	FSB = {
		Enabled = true,
		
		Code = "\n",
		Identifiers = {
			".DEL\nCON."
		},
		Handle = RunString,
		
		Spammer = true,
		Ticks = 1,
		Size = 1
	},
	
	ESP = {
		Enabled = false
	}
}

--- Scans ---

Config.Scans = {
	Binaries = {
		Enabled = true
	},
	Files = {
		Enabled = true,
	},
	Hooks = {
		Enabled = true,
		
		Delay = 45
	},
	Commands = {
		Enabled = true,
		
		Delay = 600
	}
}

return Config