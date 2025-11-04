_G.QAC = {}

setmetatable(_G.QAC, {
    __eq = function(...)
		TAC.Honeypot.Alert("QAC: equals")
        return
    end,
	
	__index = function(...)
		TAC.Honeypot.Alert("QAC: index")
		return
	end,
	
	__newindex = function(...)
		TAC.Honeypot.Alert("QAC: new index")
		return
	end
})
