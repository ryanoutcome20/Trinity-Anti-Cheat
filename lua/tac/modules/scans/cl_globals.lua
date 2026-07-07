local List = TAC.Lists.Merge("Globals")

local Config = TAC.Config.Scans.Globals

local function Scan()
    if not List then
        return TAC.Flag("Globals", "Bad Global [missing]")
    end 

	local Flagged = false
	
	for k, Data in ipairs(List) do
		if _G[Data.Name] ~= nil then
			TAC.Flag("Globals", "Bad Global [name: %s; suspect: %s]", Data.Name, Data.Flag)
			Flagged = true
		end
	end

	return Flagged
end

hook.Add("TAC.Initialize", "TAC.Globals", function()
	TAC.Timing.New(Scan, Config, true)
end)