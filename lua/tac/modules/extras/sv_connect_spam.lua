TAC.ConnectSpam = {
    Cache = { }
}

function TAC.ConnectSpam.Run(ID, IP, ServerPassword, ClientPassword, Name)
	local Config = TAC.Config.AntiConnectSpam

	if not Config.Enabled then
		return
	end

    local Cache = TAC.ConnectSpam.Cache[ID] or {
        Retries = 0,
        Cooldown = 0
    }

    if SysTime() < Cache.Cooldown then
        Cache.Cooldown = Cache.Cooldown + 1
        
        return false, "[TAC] Blocked spam retry, please wait!"
    else
        Cache.Cooldown = 0
    end

    if Cache.Retries + 1 >= Config.Range then
        TAC.Print(
            PRINT_WARN,
            "Info",
            "Blocked retry spam from ID `%s` (pw: `%s`, name: `%s`)",
            ID,
            TAC.Fix(ClientPassword),
            TAC.Fix(Name)
        )

        local Time = Cache.Cooldown + Config.Cooldown

        Cache.Cooldown = Time + SysTime()
        Cache.Retries = 0

        TAC.ConnectSpam.Cache[ID] = Cache

        return false, "[TAC] Blocked spam retry, try again in " .. string.NiceTime(Time) .. "!"
    end

    Cache.Retries = Cache.Retries + 1

    timer.Simple(
        Config.Decay,
        function()
            if not TAC.ConnectSpam.Cache[ID] then
                return
            end

            TAC.ConnectSpam.Cache[ID].Retries = math.max(TAC.ConnectSpam.Cache[ID].Retries - 1, 0)
        end
    )

    TAC.ConnectSpam.Cache[ID] = Cache
end

hook.Add("CheckPassword", "TAC.ConnectSpam.Run", TAC.ConnectSpam.Run)