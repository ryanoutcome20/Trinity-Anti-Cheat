_G.QAC = {}

setmetatable(_G.QAC, {
    __eq = function(...)
        return TAC.Captures.Stack("QAC.__eq")
    end,
	
	__index = function(...)
		return TAC.Captures.Stack("QAC.__index")
	end,
	
	__newindex = function(...)
		return TAC.Captures.Stack("QAC.__newindex")
	end
})
