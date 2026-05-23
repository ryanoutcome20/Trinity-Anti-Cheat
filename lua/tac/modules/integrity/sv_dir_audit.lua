TAC.DirectoryAudit = { }

function TAC.DirectoryAudit.Verify(Mode, Player, Objects)
    local Config = TAC.Config["Directory Audit"]

    if not Config.Enabled then
        return
    end

	if not Objects or not istable(Objects) then
		return TAC.Punishment.Wrapper(
            "Directory Audit",
			Player, 
			"Invalid file objects [got: %s; expected: table]", 
			type(Objects)
		)
	end
	
	for Entry, v in pairs(Config.Whitelisted) do 
		table.RemoveByValue(Objects, Entry)
	end

	if #Objects > 0 then
		TAC.Punishment.Wrapper(
            "Directory Audit",
			Player, 
			"Too many files objects [got: %i]", 
			#Objects
		)
	end
end

Atlas:Listen("Directory Audit", "TAC.DirectoryAudit.Verify", MODE_DONE, TAC.DirectoryAudit.Verify)