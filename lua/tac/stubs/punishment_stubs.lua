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