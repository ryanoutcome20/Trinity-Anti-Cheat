--[[
	This is dumb but it has to be done in order for the config to both setup the fallbacks
	and also at the same time register any number of new punishment tokens.
	
	I didn't want to keep it structured. You can currently reorder the entire config and it'll
	work fine.
--]]

pStub = { 
	Registers = { }
}

function pStub.Register(ID, Data)
	table.insert(pStub.Registers, {
		ID = ID,
		Data = Data
	})
end