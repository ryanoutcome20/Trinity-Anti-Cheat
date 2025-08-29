TAC.Punishment = { }

include("sv_setup.lua")
include("sv_evaluate.lua")
include("sv_flags.lua")
include("sv_delays.lua")
include("sv_execute.lua")

function TAC.Punishment.Wrapper(ID, Player, Info, ...)
	local Status, Token = TAC.Punishment.Evaluate(ID, Player, Info, ...)
	
	if Status == EVALUATE_SUCCESS and Token then
		return TAC.Execute(Token)
	end
	
	return Status, Token
end

concommand.Add("tac_pstubs", TAC.Punishment.LoadStubs)

TAC.Punishment.LoadStubs()