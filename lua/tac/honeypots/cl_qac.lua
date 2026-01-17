_G.QAC = {}

setmetatable(_G.QAC, {
    __eq = function(...)
		TAC.Captures.Stack("QAC.__eq")
        return
    end,
	
	__index = function(...)
		TAC.Captures.Stack("QAC.__index")
		return
	end,
	
	__newindex = function(...)
		TAC.Captures.Stack("QAC.__newindex")
		return
	end
})
