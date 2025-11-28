--[[
	This is mainly here as scratch code for writing debug tests.
--]]

TAC.Debug = true

if not TAC.Debug then
	return
end

MsgN("  Debug enabled; proceed with caution")

concommand.Add("tac_cout", function()
	PrintTable(TAC)
	
	TAC.Print(
		PRINT_DEBUG,
		"Debug",
		"Dumped %i indexes from TAC",
		table.Count(TAC)
	)
end)

local Total = 0

local function 	Callback(Table, Checked)
	if not istable(Table) then 
		return
	end

	Checked = Checked or {
		[Table] = true
	}

	for k,v in pairs(Table) do 
		if Checked[v] then
			continue
		end

		Checked[v] = true
		
		if istable(v) then
			Callback(v, Checked)
		end

		Total = Total + 1
	end
end

concommand.Add("tac_cout_recursive", function()
	PrintTable(TAC)

	Total = 0 

	Callback(TAC)

	TAC.Print(
		PRINT_DEBUG,
		"Debug",
		"Dumped %i indexes from TAC",
		Total
	)
end)

concommand.Add("tac_reload", function()
	include("autorun/server/sv_trinity.lua")
	
	TAC.Print(
		PRINT_DEBUG,
		"Debug",
		"Reloaded main file"
	)
end)

dbg = TAC.Print

hook.Add("PostEntityFireBullets", "Accuracy.Count", function() end)