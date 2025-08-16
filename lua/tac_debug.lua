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
	
	TAC.Print("Dumped %i indexes from TAC!", table.Count(TAC))
end)

concommand.Add("tac_reload", function()
	include("autorun/server/sv_trinity.lua")
end)

dbg = TAC.Print

hook.Add("StartCommandPlus", "DBG", function(ply, cNew, cOld, cmd)
    if not IsValid(ply) or not ply:IsPlayer() then return end


end)
