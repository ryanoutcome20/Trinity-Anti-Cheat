--[[
	This is dumb but it has to be done in order for the config to both setup the fallbacks
	and also at the same time register any number of new punishment tokens.
	
	I didn't want to keep it structured. You can currently reorder the entire config and it'll
	work fine.
--]]

pStub = { 
	Registers = { }
}

function pStub.Register(ID, Token)
	-- See if we're handling a refresh.
	if TAC.Punishment then
		TAC.Punishment.Register(ID, Token)
		
		for i = #pStub.Registers, 1, -1 do
			if pStub.Registers[i].ID == ID then
				table.remove(pStub.Registers, i)
			end
		end
	end

	-- Insert new data entry.
	table.insert(pStub.Registers, {
		ID = ID,
		Token = Token
	})
end