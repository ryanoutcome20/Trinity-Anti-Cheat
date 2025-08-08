function TAC.LastTouchTime(Player)
	local Time = CurTime()

	return Time - Player:Grab("Last Touch Time", Time)
end

function TAC.UpdateLastTouchTime()
	local Time = CurTime()

	for k, Player in ipairs(player.GetAll()) do 
		local Trace = Player:GetTouchTrace()
		
		if not Trace.Entity:IsWorld() then
			Player:Set("Last Touch Time", Time)
		end
	end
end

hook.Add("Think", "TAC.UpdateLastTouchTime", TAC.UpdateLastTouchTime)