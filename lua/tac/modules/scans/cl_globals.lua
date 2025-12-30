local List = TAC.Lists.Merge("Globals")

local Config = TAC.Config.Scans.Globals

local function Scan()
	if not Config.Enabled then
		return
	end

	for k, Data in ipairs(List) do
		if _G[Data.Name] then
			TAC.Flag("Globals", "Bad Global [name: %s; suspect: %s]", Data.Name, Data.Flag)
		end
	end
	
	timer.Simple(Config.Delay, Scan)
end

hook.Add("TAC.Initialize", "TAC.Globals", function()
	timer.Simple(Config.Delay, Scan)
end)