function TAC.Breakers.DisableWorldClicking(Player)
	Player:DisableWorldClicking(TAC.Config.WorldClicker)
end

hook.Add("StartCommandPlus", "TAC.Breakers.DisableWorldClicking", TAC.Breakers.DisableWorldClicking)