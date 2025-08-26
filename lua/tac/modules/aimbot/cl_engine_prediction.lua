TAC.Engine = { 
	Object = NULL
}

function TAC.Engine.CreateMove(CUserCMD)
	local Command = CUserCMD:CommandNumber()

	if Command == 0 then
		return
	end

	TAC.Engine.Object = Command
end

function TAC.Engine.SetupMove(Player, CMoveData, CUserCMD)
	if not TAC.Config.Aimbot.EnginePrediction then
		return
	end

	local Command = CUserCMD:CommandNumber()
	
	if Command == 0 or not TAC.Engine.Object then
		return
	end

	if Command > TAC.Engine.Object then
		TAC.Flag("Engine Prediction", "Engine Prediction [in: %i; out: %i]", TAC.Engine.Object, Command)
	end
end

hook.Add("CreateMove", "TAC.Engine.CreateMove", TAC.Engine.CreateMove)
hook.Add("SetupMove", "TAC.Engine.SetupMove", TAC.Engine.SetupMove)
