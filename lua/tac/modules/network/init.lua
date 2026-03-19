TAC.Networking = { }

include("sv_transfer.lua")
include("sv_config_stream.lua")

function TAC.Networking.Integrity(Player, Message, ...)
	return TAC.Punishment.Wrapper("Client Integrity", Player, Message, ...)
end

function TAC.Networking.Flag(Stage, Player, Data)
	if not Data then
		return TAC.Networking.Integrity(Player, "Invalid Flags [no data]")
	end

	if not Data.cID or not Data.Message then
		return TAC.Networking.Integrity(Player, "Invalid Flags [cid: %s; message: %s]", type(Data.cID), type(Data.Message))
	end
	
	local Config = TAC.Config[Data.cID]
	
	if not Config or not Config.Client then
		return TAC.Networking.Integrity(Player, "Invalid Flags [config: %s]", tostring(Data.cID))
	end
	
	return TAC.Punishment.Wrapper(Data.cID, Player, TAC.Fix(Data.Message) .. " [CL]")
end

function TAC.Networking.FlagBatch(Stage, Player, Objects)
	Objects = istable(Objects) and Objects or { }

	if #Objects == 0 then
		return TAC.Networking.Integrity(Player, "Networking Batch [empty]")
	end
	
	for k, Object in ipairs(Objects) do 
		local Status, Log = TAC.Networking.Flag(
			Stage, 
			Player, 
			Object
		)
		
		if Status == EXECUTE_SUCCESS and Log ~= true then
			break
		end
	end
end

Atlas:Listen("Flag", "TAC.Networking.Flag", MODE_DONE, TAC.Networking.Flag)

Atlas:Listen("Flag Batch", "TAC.Networking.FlagBatch", MODE_DONE, TAC.Networking.FlagBatch)