TAC.SendLua = { }

function TAC.SendLua.Start(Player)	
	if not IsValid(Player) or Player:IsBot() then
		return
	end
    
    local Config = TAC.Config["Send Lua"]

    if not Config.Enabled then
        return
    end

    local Key = TAC.Random(math.random(5,10))

    Player:SendLua("CreateConVar([[" .. Key .. "]], [[" .. Key .. "]], FCVAR_USERINFO)")
    
    TAC.Timer(Player, Config.Wait, function(Player)
        if Player:GetInfo(Key) == Key then
            return
        end
        
        TAC.Punishment.Wrapper(
            "Send Lua",
            Player, 
            "Send Lua [blocked]" 
        )
    end)
end

hook.Add("TAC.TransferConfig", "TAC.SendLua.Start", TAC.SendLua.Start)