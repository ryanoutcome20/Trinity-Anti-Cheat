if not util.IsBinaryModuleInstalled("reqwest") then
    MsgN("  No webhook module detected")
else
    MsgN("  Webhook module (reqwest) detected")
    
    require("reqwest")
end

function TAC.Webhook(Token)
    if not reqwest then
        return
    end

    local Config = TAC.Config.Webhook

    if not Config.Enabled then 
        return 
    end

    local Interpolated = TAC.Format(Token, file.Read("tac/embed/template.json", "LUA"), true)

	reqwest({
		method = "POST",
		url = Config.URL,
		timeout = Config.Timeout,
		
		body = Interpolated,
		type = "application/json",

		headers = {
			["User-Agent"] = "Trinity-Anti-Cheat/" .. TAC.Version,
		},

		success = function(Status, Body, Headers) end,

		failed = function(Error, Reason)
            TAC.Print(
                PRINT_ERROR,
                "Webhook",
                "`%s` -> `%s`",
                Error,
                Reason
            )
        end
	})
end