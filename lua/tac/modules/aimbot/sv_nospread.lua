TAC.Nospread = { }

function TAC.Nospread.Variance(Deltas)
    local Sum, Quantifier = 0, 0
	
    for k, Delta in ipairs(Deltas) do
        Sum = Sum + Delta
		
        Quantifier = Quantifier + (Delta ^ 2)
    end
	
	return (Quantifier / #Deltas) - (Sum / #Deltas) ^ 2
end

function TAC.Nospread.Run(Player, Samples)
    local Deltas = { }

    for k, Object in ipairs(Samples) do
        local Pre, Post = Object.Pre, Object.Post
		
        if not Pre or not Post then 
			continue 
		end

        local Shot = (Post.Trace.HitPos - Pre.Src):GetNormalized()
        local Aim = Pre.Dir:GetNormalized()

        local Offset = math.deg(math.acos(math.Clamp(Aim:Dot(Shot), -1, 1)))

        local Cone = math.deg(math.atan(math.max(Pre.Spread.x, Pre.Spread.y)))

        if Cone < 0.1 then 
			continue 
		end

        table.insert(Deltas, Offset / Cone)
    end

    if #Deltas < 8 then 
		return
	end

	local Variance = TAC.Nospread.Variance(Deltas)
    if Variance < 0.01 then
		TAC.Punishment.Wrapper("Nospread", Player, "Nospread [variance: %f of %i]", Variance, #Deltas)
	end
end

function TAC.Nospread.EntityFireBullets(Player, Pre)
	if not Player:IsPlayer() then
		return
	end

	local Samples = Player:Get("Nospread Samples", { })
		
	table.insert(Samples, 1, {
		Pre = Pre,
		Verified = false,
	})
	
	Player:Set("Nospread Samples", Samples)
end

function TAC.Nospread.PostEntityFireBullets(Player, Post)
	if not Player:IsPlayer() then
		return
	end
	
	local Samples = Player:Get("Nospread Samples", { })
	
	local Sample = Samples[1]
	
	if not Sample or Sample.Verified then
		return
	end	

	if Post.Trace.HitPos:Distance2D(Sample.Pre.Src) <= 400 then
		return
	end

	Sample.Post = Post
	Sample.Verified = true
	
	if #Samples >= 10 then
		TAC.Nospread.Run(Player, Samples)
		
		Samples = { }
	end
	
	Player:Set("Nospread Samples", Samples)
end

hook.Add("PostEntityFireBullets", "TAC.Nospread.PostEntityFireBullets", TAC.Nospread.PostEntityFireBullets)
hook.Add("EntityFireBullets", "TAC.Nospread.EntityFireBullets", TAC.Nospread.EntityFireBullets)