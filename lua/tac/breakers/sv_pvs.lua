TAC.Breakers.PVS = { 
	Interval = engine.TickInterval()
}

function TAC.Breakers.PVS.Set(Player, ENT, Status)
	ENT:SetPreventTransmit(Player, Status)
	
	local Sub = ENT:GetChildren()
	
	for i = 1, #Sub do
		TAC.Breakers.PVS.Set(Player, Sub[i], Status)
	end
end

function TAC.Breakers.PVS.Check(Player, Position, Target)
	local Trace = util.TraceLine({
		start = Position,
		endpos = Target:EyePos(),
		mask = MASK_VISIBLE,
		filter = {
			Player, 
			Target
		}
	})

	return not Trace.Hit or Trace.Entity == Target
end

function TAC.Breakers.PVS.Predict(Player, Ticks)
	-- No, we won't do any AABB checks in here since it would be
	-- too expensive.
		
    local Data = {}

    local Gravity = Player:GetGravity()
    local Grounded = Player:IsOnGround()
    local Position = Player:EyePos()
    local Velocity = Player:GetVelocity()
	local Friction = Player:GetFriction()

	-- Insert squared size.
	
	local Size = TAC.Config.PVS.squaredSize
	
	for i = -2, 2 do 
		for k = -2, 2 do 
			for v = -2, 2 do
				table.insert(Data, {
					Position = Position + (Vector(i, k, v) * Size),
					Velocity = Velocity
				})
			end
		end
	end

	-- Insert ticks.
	
    for i = 1, Ticks do
        if not Grounded then
            Velocity = Velocity + (-vector_up * Gravity * TAC.Breakers.PVS.Interval)
        else
            Velocity = Velocity * Friction
        end

        Position = Position + Velocity * TAC.Breakers.PVS.Interval

        table.insert(Data, {
            Position = Position,
            Velocity = Velocity
        })
    end

    return Data
end

function TAC.Breakers.PVS.Run(Player)
	local Config = TAC.Config.PVS
	
	if not Config.Enabled then
		return
	end
	
	local Positions = TAC.Breakers.PVS.Predict(Player, Config.Ticks + math.ceil(Player:Ping() * Config.pingScale))

	for k, Target in ipairs(ents.FindInPVS(Player)) do 
		if not Target:IsPlayer() or Target == Player then
			continue
		end
		
		local Validated = false
		
		for k, Data in ipairs(Positions) do 
			if TAC.Breakers.PVS.Check(Player, Data.Position, Target) then
				Validated = true
				break
			end
		end
		
		TAC.Breakers.PVS.Set(Player, Target, not Validated)
	end
end

hook.Add("StartCommandPlus", "TAC.Breakers.PVS.Run", TAC.Breakers.PVS.Run)