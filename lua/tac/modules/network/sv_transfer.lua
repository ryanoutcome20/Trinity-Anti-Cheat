TAC.Transfer = { }

function TAC.Transfer.ID(Player)
	return string.format(
		"TAC_TRANSFER_%s",
		Player:SteamID64()
	)
end

function TAC.Transfer.Get(Index)
	local Stubs = mStub.Files[Index]
	
	if not Stubs then
		return false
	end
	
	return Stubs
end

function TAC.Transfer.Step(Player, ID)
	if not Player or not IsValid(Player) then
		return timer.Remove(ID)
	end

	local Index = Player:Get("Transfer Step", 1)
	
	local File = TAC.Transfer.Get(Index)
	
	if not File then
		hook.Run("TAC.PreTransferStopped", Player)
		hook.Run("TAC.TransferStopped", Player)
		return timer.Remove(ID)
	end

	Player:Set("Transfer Step", Index + 1)

	local Code = file.Read(File, "LUA")

	if not Code or #Code == 0 then
		return TAC.Print(
			PRINT_ERROR,
			"File Transfer",
			"Client `%s` cannot get file `%s` (missing or empty)!", 
			Player:Name(),
			File
		)
	end
	
	local Block = hook.Run("TAC.Transfer", Player, File, Code)
	
	if not Block then
		Atlas:Send(
			"Plugin", 
			Player, 
			File,
			Code
		)

		Player:Set("Transfer Sent", Index)
	else
		TAC.Print(
			PRINT_INFO,
			"File Transfer",
			"Server transfer hook blocked transfer for file `%s` (`%s`)!", 
			File,
			Player:Name()
		)
	end
end

function TAC.Transfer.Stop(Player)
	local Identity = TAC.Transfer.ID(Player)
	
	if timer.Exists(Identity) then
		Player:Set("Transfer Step", 1)
	
		timer.Remove(Identity)
	end
end

function TAC.Transfer.Start(Data)
	local Player = Player(Data.userid)
	
	if not IsValid(Player) or Player:IsBot() then
		return
	end
	
	Player:Set("Transfer Step", 1)
	
	local Config = TAC.Config.Networking
	
	TAC.Timer(
		Player, 
		Config.Delay, 
		function(self)
			local ID = TAC.Transfer.ID(self)
			
			timer.Create(
				ID,
				Config.Step,
				-1,
				function()
					TAC.Transfer.Step(self, ID)
				end
			)
		end
	)
end

gameevent.Listen("player_activate")

hook.Add("player_activate", "TAC.Transfer.Start", TAC.Transfer.Start)
hook.Add("PlayerDisconnected", "TAC.Transfer.Stop", TAC.Transfer.Stop)