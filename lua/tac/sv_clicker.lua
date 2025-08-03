function TAC.DisableWWorldClicking(Player)
	Player:DisableWorldClicking(TAC.Config.WorldClicker)
end

hook.Add("StartCommandPlus", "TAC.DisableWWorldClicking", TAC.DisableWWorldClicking)