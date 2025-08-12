TAC.Networking = { }

include("sv_pic.lua")

function TAC.Networking.Integrity(Player, Message, ...)
	return TAC.Punishment.Wrapper("Client Integrity", Player, Message, ...)
end

function TAC.Networking.Flag(Stage, Player, Data)
	if not Data then
		return TAC.Networking.Integrity(Player, "Invalid Flags [no data]")	
	end

	if not Data.cID or not Data.Message then
		return TAC.Networking.Integrity(Player, "Invalid Flags [cid: %s; msg: %s]", type(Data.cID), type(Data.Message))	
	end
	
	local Config = TAC.Config[Data.cID]
	
	if not Config or not Config.Client then
		return TAC.Networking.Integrity(Player, "Invalid Flags [cfg: %s]", tostring(Data.cID))	
	end
	
	TAC.Punishment.Wrapper(Data.cID, Player, TAC.Fix(Data.Message) .. " [CL]")
end

Atlas:Listen("Flag", "TAC.Networking.Flag", MODE_DONE, TAC.Networking.Flag)