-- If you put these in a meta they'll be capable
-- of being broken by desynculator since that
-- breaks all synced timers.

function TAC.TimeSinceCreated(Player)
	assert(IsValid(Player) and Player:IsPlayer(), "No `Player` player provided to TAC.TimeSinceCreated!", type(Player))

	return CurTime() - Player:GetCreationTime()
end

function TAC.TimeSinceSpawned(Player)
	assert(IsValid(Player) and Player:IsPlayer(), "No `Player` player provided to TAC.TimeSinceSpawned!", type(Player))

	local Time = Player:Get("Spawned", math.huge)
	
	if Time == math.huge then
		return Time
	end
	
	return CurTime() - Time
end

function TAC.SetSpawnTime(Player)
	assert(IsValid(Player) and Player:IsPlayer(), "No `Player` player provided to TAC.SetSpawnTime!", type(Player))

	Player:Set("Spawned", CurTime())
end

function TAC.LastTouchTime(Player)
	assert(IsValid(Player) and Player:IsPlayer(), "No `Player` player provided to TAC.LastTouchTime!", type(Player))

	return CurTime() - Player:Get("Last Touch Time", -1)
end

function TAC.UpdateLastTouchTime(ENT)
	assert(IsValid(ENT), "No `ENT` player provided to TAC.UpdateLastTouchTime!", type(ENT))
	
	if not ENT:IsPlayer() then
		return
	end

	ENT:AddCallback("PhysicsCollide", function(self, Data)
		self:Set("Last Touch Time", CurTime())
	end)
end

hook.Add("OnEntityCreated", "TAC.UpdateLastTouchTime", TAC.UpdateLastTouchTime)
hook.Add("PlayerSpawn", "TAC.SetSpawnTime", TAC.SetSpawnTime)