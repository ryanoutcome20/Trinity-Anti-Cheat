TAC.Breakers.PVS = {
	Interval = engine.TickInterval()
}

function TAC.Breakers.PVS.BuildOffset()
	TAC.Breakers.PVS.Offsets = { }

	local Size, Squared = TAC.Config.PVS.squareSize, TAC.Config.PVS.squaredSize

    for i = -Size, Size do
        for k = -Size, Size do
            for v = -Size, Size do				
				table.insert(
					TAC.Breakers.PVS.Offsets, 
					Vector(i * Squared, k * Squared, v * Squared)
				)
            end
        end
    end
end

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

function TAC.Breakers.PVS.Predict(Player)
	-- No, we won't do any AABB checks in here since it would be 
	-- too expensive.

    local Data, Index = { }, 1

    local Gravity   = Player:GetGravity()
    local Velocity  = Player:GetVelocity()
    local Position  = Player:EyePos()

	-- Insert squared size.
    if not TAC.Breakers.PVS.Offsets then
		TAC.Breakers.PVS.BuildOffset()
	end
	
    for i = 1, #TAC.Breakers.PVS.Offsets do
		local Offset = TAC.Breakers.PVS.Offsets[i]
		
		Data[Index] = Position + Offset
		
		Index = Index + 1
    end

	-- Insert tick.
    local Tick = TAC.Breakers.PVS.Interval + (Player:Ping() / 1000) * TAC.Config.PVS.intervalScale

    Velocity = Velocity + (-vector_up * Gravity * Tick)

    Data[Index] = Position + Velocity * Tick

    return Data
end

function TAC.Breakers.PVS.Run(Player)
	local Config = TAC.Config.PVS
	
	if not Config.Enabled then
		return
	end
	
	local Positions = TAC.Breakers.PVS.Predict(Player)

	local PVS = ents.FindInPVS(Player)

	for i = 1, #PVS do 
		local Target = PVS[i]
	
		if not Target:IsPlayer() or Target == Player then
			continue
		end
		
		local Validated = false
		
		for k = 1, #Positions do
			if TAC.Breakers.PVS.Check(Player, Positions[k], Target) then
				Validated = true
				break
			end
		end
		
		TAC.Breakers.PVS.Set(Player, Target, not Validated)
	end
end

hook.Add("StartCommandPlus", "TAC.Breakers.PVS.Run", TAC.Breakers.PVS.Run)

concommand.Add("tac_recompute_pvs", function(Player)
	if Player and not Player:IsSuperAdmin() then
		Player:tAlert(
			"This command is restricted to Super Admin only!",
			NOTIFY_ERROR
		)
		
		TAC.Print("Blocked client '%s' from recomputing PVS!", Player:Name())
		
		return
	end

	TAC.Breakers.PVS.Offsets = nil
end)