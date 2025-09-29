TAC.Networking.PIC = { }

function TAC.Networking.PIC.Receive(Stage, Player, Checksum)
	Player:Set("PIC", TAC.Fix(Checksum))
end

function TAC.Networking.PIC.Await(Target)
	if Target:IsBot() then
		return
	end

	TAC.Timer(Target, TAC.Config.PIC.Await, function(Player)
		TAC.Networking.PIC.Run(
			Player,
			Player:Grab("PIC", "nothing")
		)
	end)
end

function TAC.Networking.PIC.Run(Player, Checksum)
	local Config = TAC.Config.PIC
	
	if Config.PIC == "" then
		return TAC.Print(
			PRINT_WARN,
			"PIC",
			"Please setup a PIC checksum, we cannot run PIC checks without it"
		)
	elseif Config.PIC ~= Checksum then
		return TAC.Punishment.Wrapper("PIC", Player, "PIC [cs: %s; got: %s]", Config.PIC, Checksum)	
	end
end

Atlas:Listen("PIC", "TAC.Networking.PIC.Receive", MODE_DONE, TAC.Networking.PIC.Receive)

hook.Add("PlayerInitialSpawn", "TAC.Networking.PIC.Await", TAC.Networking.PIC.Await)