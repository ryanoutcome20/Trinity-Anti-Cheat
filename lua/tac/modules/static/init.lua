if SERVER then
	return {
		"init.lua"
	}
end

TAC.Static = { }

function TAC.Static.Interstate()
	return file.IsDir("interscripts/stolen", "DATA")
end

function TAC.Static.Memoriam()
	return file.IsDir("memoriam/configs", "BASE_PATH")
end

function TAC.Static.Coffee()
	return file.IsDir("coffee", "GAME")
end

function TAC.Static.D3C()
	-- Yes, this is a cheat. No don't ask.
	return file.IsDir("icefuse/content/colorpicker", "DATA")
end

function TAC.Static.Majestic()
	return file.IsDir("majestic", "GAME")
end

function TAC.Static.Run()
	local Config = TAC.Config.Static
	
	if not Config.Enabled then
		return
	end
	
	local Data = {
		{
			Enabled = Config.Interstate,
			Callback = TAC.Static.Interstate,
			Name = "Interstate"
		},
		{
			Enabled = Config.Memoriam,
			Callback = TAC.Static.Memoriam,
			Name = "Memoriam"
		},
		{
			Enabled = Config.Coffee,
			Callback = TAC.Static.Coffee,
			Name = "Coffee"
		},
		{
			Enabled = Config.D3C,
			Callback = TAC.Static.D3C,
			Name = "D3C"
		},
		{
			Enabled = Config.Majestic,
			Callback = TAC.Static.Majestic,
			Name = "Majestic"
		}
	}
	
	for k, Object in ipairs(Data) do 
		if Object.Enabled and Object.Callback() then
			TAC.Flag("Static Script", "Script Detected [name: %s]", Object.Name)
		end
	end
end

hook.Add("TAC.Initialize", "TAC.Static.Run", TAC.Static.Run)