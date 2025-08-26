TAC.Transfer = { }

function TAC.Transfer.ID(Player)
	return string.format(
		"TAC_%s",
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

function TAC.Transfer.Step(Player)
	local Index = Player:Grab("Transfer Step", 1)
	
	local File = TAC.Transfer.Get(Index)
	
	if not File then
		return TAC.Transfer.Stop(Player)
	end
	
	Atlas:Send(
		"Plugin", 
		Player, 
		File,
		file.Read(File, "LUA")
	)
	
	Player:Set("Transfer Step", Index + 1)
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
	
	if not Player or Player:IsBot() then
		return
	end
	
	Player:Set("Transfer Step", 1)
	
	local Config = TAC.Config.Networking
	
	TAC.Timer(Player, Config.Delay, function(Player)
		timer.Create(
			TAC.Transfer.ID(Player),
			Config.Delay,
			#mStub.Files * Config.Overreach,
			function()				
				TAC.Transfer.Step(Player)
			end
		)
	end)
end

gameevent.Listen("player_activate")

hook.Add("player_activate", "TAC.Transfer.Start", TAC.Transfer.Start)
hook.Add("PlayerDisconnected", "TAC.Transfer.Stop", TAC.Transfer.Stop)