function TAC.Detours.Capture(Function, Message, ...)
	if TAC.Detours.Ran[Function] then
		return
	end
	
	MsgN(Function)
	
	local Data = {
		Function = TAC.GenerateBuffer(
			Function, 
			true
		),
		Message = string.format(
			Message,
			...
		)
	}
	
	TAC.Batch.Add(
		"Function", 
		Data, 
		TAC.Size(Data.Function) + #Data.Message
	)
	
	TAC.Detours.Ran[Function] = true
end

function TAC.Detours.CaptureStack(Message, ...)
	for i = 1, 32 do 
		local Info = debug.getinfo(i)
		
		if not Info then
			break
		end
		
		if Info.func then
			TAC.Detours.Capture(Info.func, Message, ...)
		end
	end
end

TAC.Capture = TAC.Detours.Capture
TAC.CaptureStack = TAC.Detours.CaptureStack