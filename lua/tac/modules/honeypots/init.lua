if modern_anti_cheat_config or QAC then
	MsgN("  Avoiding honeypot! QAC/MAC are installed.")
	return
end

TAC.Honeypot = { }

MsgN("  Loading honeypots")

local Found = file.Find("tac/honeypots/*", "LUA")

for Index, Name in ipairs(Found) do 
	Found[Index] = "tac/honeypots/" .. Name
end

return Found, true