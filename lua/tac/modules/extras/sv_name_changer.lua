function TAC.Extra.NameChanger(Data)
	local Target = Player(Data.userid)
	
	if TAC.Config["Name Changer"].Enabled then
		TAC.Punishment.Wrapper("Name Changer", Target, "Changed Named [old: %s, new: %s]", TAC.Fix(Data.oldname), TAC.Fix(Data.newname))
	end
end

gameevent.Listen("player_changename")

hook.Add("player_changename", "TAC.Extra.NameChanger", TAC.Extra.NameChanger)