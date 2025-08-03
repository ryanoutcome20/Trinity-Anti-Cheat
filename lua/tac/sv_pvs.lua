TAC.PVS = { 
	Interval = engine.TickInterval()
}

function TAC.PVS.Set(Player, ENT, Status)
	ENT:SetPreventTransmit(Player, Status)
	
	local Sub = ENT:GetChildren()
	
	for i = 1, #Sub do
		TAC.PVS.Set(Player, Sub[i], Status)
	end
end

function TAC.PVS.Check(Player, Position, Target)
	local Trace = util.TraceLine({
		start = Position,
		endpos = Target:EyePos(),
		mask = MASK_VISIBLE,
		filter = { Player, Target }
	})

	return not Trace.Hit or Trace.Entity == Target
end

function TAC.PVS.Predict(Player, Ticks)
	-- No, we won't do any AABB checks in here since it would be
	-- too expensive.
		
    local Data = {}

    local Gravity = Player:GetGravity()
    local Grounded = Player:IsOnGround()
    local Position = Player:EyePos()
    local Velocity = Player:GetVelocity()
	local Friction = Player:GetFriction()

    for i = 1, Ticks do
        if not Grounded then
            Velocity = Velocity + (-vector_up * Gravity * TAC.PVS.Interval)
        else
            Velocity = Velocity * Friction
        end

        Position = Position + Velocity * TAC.PVS.Interval

        Data[i] = {
            Position = Position,
            Velocity = Velocity
        }
    end

    return Data
end

function TAC.PVS.Run(Player)
	local Config = TAC.Config.PVS
	
	if not Config.Enabled then
		return
	end

	local Positions = TAC.PVS.Predict(Player, Config.Ticks + math.ceil(Player:Ping() * Config.pingScale))

	for k, Target in ipairs(ents.FindInPVS(Player)) do 
		if not Target:IsPlayer() or Target == Player then
			continue
		end
		
		local Validated = false
	
		for k, Data in ipairs(Positions) do 
			if TAC.PVS.Check(Player, Data.Position, Target) then
				Validated = true
				break
			end
		end
		
		TAC.PVS.Set(Player, Target, not Validated)
	end
end

hook.Add("StartCommandPlus", "TAC.PVS.Run", TAC.PVS.Run)