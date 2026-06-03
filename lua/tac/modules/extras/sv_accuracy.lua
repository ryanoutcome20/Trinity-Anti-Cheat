TAC.Accuracy = { }

function TAC.Accuracy.Process(Player, Hits, Shots, Target)
	local Percentage = Hits / Shots

	if Percentage < Target then
		return
	end
	
	TAC.Punishment.Wrapper(
		"Accuracy",
		Player,
		"Accuracy [%i/%i shots at %i percent]",
		Hits,
		Shots,
		math.Round(Percentage, 2) * 100
	)
end

function TAC.Accuracy.Compute(Player, Data)
	if not Player or not Player:IsPlayer() then
		return
	end
	
	local Config = TAC.Config.Accuracy
	
	if not Config.Enabled then
		return
	end
	
	local Time = CurTime()
	
	local Info = Player:Get("Accuracy Info", {
		Last = Time,
		Shots = 0,
		Hits = 0
	})
	
	if Info.Last > Time then
		return
	end

	local cOld = Player:Get("SCP")
	
	if not cOld then
		return
	end
	
	local Trace = Data.Trace

	if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
		if Config.Distance == -1 and cOld.Pos:Distance(Trace.Entity:GetPos()) > Config.Distance then
			Info.Hits = Info.Hits + 1
		end
	end

	Info.Shots = Info.Shots + 1
	Info.Last = Time + Config.ShotWait

	if Info.Shots >= Config.Window then	
		TAC.Accuracy.Process(
			Player, 
			Info.Hits, 
			Info.Shots, 
			Config.MinimumAccuracy
		)
		
		Info.Shots = 0
		Info.Hits = 0
	end
	
	Player:Set("Accuracy Info", Info)
end

hook.Add("PostEntityFireBullets", "TAC.Accuracy.Compute", TAC.Accuracy.Compute)