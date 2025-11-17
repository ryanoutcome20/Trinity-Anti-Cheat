TAC.Captures = {
	Data = { },
	Ran = { }
}

local tostring = tostring

local debug_getinfo = debug.getinfo

function TAC.Captures.Direct(Function, Message)
	TAC.Captures.Data = TAC.GenerateBuffer(Function, true)
	
	if TAC.Detours.Whitelist.Whitelisted(Function, TAC.Captures.Data) then
		return
	end

	TAC.Captures.Data.Message = Message
	
	TAC.Batch.Add(
		"Function", 
		TAC.Captures.Data, 
		TAC.Size(TAC.Captures.Data)
	)
end

function TAC.Captures.Stack(Message)
	for i = 3, 8 do 
		local Info = debug_getinfo(i, "f")
	
		if not Info then
			break
		end
		
		local Hash = tostring(Info.func)
		
		if TAC.Captures.Ran[Hash] then
			continue
		end
		
		TAC.Captures.Direct(Info.func, Message)
		
		TAC.Captures.Ran[Hash] = true
	end
end