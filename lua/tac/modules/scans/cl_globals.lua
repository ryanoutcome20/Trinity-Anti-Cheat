local List = TAC.Lists.Merge("Globals")

local Config = TAC.Config.Scans.Globals

local function Scan()
	if not Config.Enabled then
		return
	end

	for k, Global in ipairs(List) do
		if _G[Global] then
			TAC.Flag("Globals", "Bad Global [name: %s]", Global)
        end
    end
end

hook.Add("TAC.Initialize", "TAC.Globals", function()
	timer.Simple(Config.Delay, Scan)
end)