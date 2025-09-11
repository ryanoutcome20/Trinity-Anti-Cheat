TAC.Honeypot = { }

if SERVER then
	if modern_anti_cheat_config or QAC then
		MsgN("  Avoiding honeypot! QAC/MAC are installed.")
		return
	end
	
	include("sv_manager.lua")
else
	function TAC.Honeypot.Alert(Message, ...)
		TAC.Atlas:Send(
			"Honeypot",
			string.format(
				Message,
				...
			)
		)
	end
	
	return
end

MsgN("  Loading honeypots")

local Found = file.Find("tac/honeypots/*", "LUA")

for Index, Name in ipairs(Found) do 
	Found[Index] = "tac/honeypots/" .. Name
end

table.insert(Found, 1, "tac/modules/honeypots/init.lua")

return Found, true