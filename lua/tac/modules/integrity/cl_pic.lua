function TAC.PIC.Run()
	if not TAC.Config.PIC then
		return
	end

	local Checksum = TAC.PIC.GenerateChecksum(TAC.PIC.Generated)
	
	TAC.Atlas:Send(
		"PIC", 
		Checksum
	)
	
	TAC.Print(
		PRINT_INFO,
		"PIC",
		"PIC Checksum: %s", 
		Checksum
	)
end

TAC.PIC.Run()