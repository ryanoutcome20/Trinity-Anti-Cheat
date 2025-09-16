-- If you put these in a meta they'll be capable
-- of being broken by desynculator since that
-- breaks all synced timers.

function TAC.TimeSinceCreated(Player)
	return CurTime() - Player:GetCreationTime()
end

function TAC.TimeSinceSpawned(Player)
	local Time = Player:Grab("Spawned", math.huge)
	
	if Time == math.huge then
		return Time
	end
	
	return CurTime() - Time
end

function TAC.SetSpawnTime(Player)
	Player:Set("Spawned", CurTime())
end

function TAC.LastTouchTime(Player)	
	return CurTime() - Player:Grab("Last Touch Time", -1)
end

function TAC.UpdateLastTouchTime(ENT)
	-- This isn't too bad but it still isn't great.
	-- I'd like to have this in a global collision
	-- hook.
	
	if not IsValid(ENT) or not ENT:IsPlayer() then
		return
	end
	
	ENT:AddCallback("PhysicsCollide", function(self, Data)
		self:Set("Last Touch Time", CurTime())
	end)
end

hook.Add("OnEntityCreated", "TAC.UpdateLastTouchTime", TAC.UpdateLastTouchTime)
hook.Add("PlayerSpawn", "TAC.SetSpawnTime", TAC.SetSpawnTime)