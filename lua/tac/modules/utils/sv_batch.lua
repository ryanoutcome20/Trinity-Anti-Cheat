TAC.Batch = { }

function TAC.Batch.StartCommandPlus(Player, cNew, cOld)
	local Cache = Player:Grab("Batch Storage", { })
	
	table.insert(Cache, {
		cNew = cNew,
		cOld = cOld
	})
	
	if #Cache >= 40 then
		hook.Run("StartCommandBatch", Player, Cache)
	
		Cache = { }
	end
		
	Player:Set("Batch Storage", Cache)
end

hook.Add("StartCommandPlus", "TAC.Batch.StartCommandPlus", TAC.Batch.StartCommandPlus)