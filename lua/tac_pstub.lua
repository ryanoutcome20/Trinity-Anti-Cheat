--[[
	This is dumb but it has to be done in order for the config to both setup the fallbacks
	and also at the same time register any number of new punishment tokens.
--]]

pStub = { 
	Registers = { }
}

function pStub:Register(ID, Data)
	table.insert(self.Registers, {
		ID = ID,
		Data = Data
	})
end