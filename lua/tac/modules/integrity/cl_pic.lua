function TAC.PIC.Run()
	if not TAC.Config.Integrity.PIC then
		return
	end

	local Checksum = TAC.PIC.GenerateChecksum(TAC.PIC.Generated)
	
	TAC.Atlas:Send(
		"PIC", 
		Checksum
	)
	
	if not TAC.Config.Silent then
		TAC.Print("PIC Checksum: %s", Checksum)
	end
end

TAC.PIC.Run()