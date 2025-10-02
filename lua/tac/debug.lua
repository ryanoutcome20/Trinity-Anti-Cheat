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