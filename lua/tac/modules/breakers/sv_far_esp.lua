TAC.Breakers.FarESP = { }

function TAC.Breakers.FarESP.PreventFarESP(Data)
    if not TAC.Config.FarESP.Enabled then
        return
    end
    
	if IsValid(Data.Entity) and IsValid(Data.Pos) then
		EmitSound(
			Data.OriginalSoundName,
			Data.Pos,
			nil,
			Data.SoundLevel,
			Data.Pitch,
			Data.Volume,
			Data.Channel,
			Data.Flags,
			Data.DSP
		)

		return false
	end
end

hook.Add("EntityEmitSound", "TAC.Breakers.FarESP.PreventFarESP", TAC.Breakers.FarESP.PreventFarESP)