TAC.Tracer = { }

TAC.Lists.Merge("Traces")

function TAC.Tracer.Run()
	if not TAC.Config.Integrity.Tracer.Enabled then
		return
	end

	local List = TAC.Lists.Grab("Traces")
	
	if not List then
		return TAC.Flag("Error Tracer", "Error Tracer [missing]")
	end
	
	for i = 1, #List do 
		local Object = List[i]
		
		local Status, Message = pcall(Object.Pointer, nil)
		
		if Status then
			TAC.Flag("Error Tracer", "Error Status [name: %s]", Object.Name)
		elseif not Status and Message ~= Object.Message then
			TAC.Flag("Error Tracer", "Error Content [name: %s; expected: %i; got: %i]", Object.Name, #Object.Message, #Message)
		end
	end
end

TAC.Tracer.Run()