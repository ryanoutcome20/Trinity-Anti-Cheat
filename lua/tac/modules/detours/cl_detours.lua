--- Localization ---

local Detour = TAC.Detour.Register

--- Whitelist ---

Detour("RunString", function(Original, Code, Identifier, ...)
	TAC.CaptureStack("RunString")
	
	if Identifier then
		TAC.Detours.Whitelist.Identifiers[Identifier] = true
	end
	
	if isstring(Code) then
		TAC.Detours.Whitelist.Update(Code, Identifier)
	end
	
	TAC.Detours.Whitelist.Increment()
	
	return Original(Code, Identifier, ...)
end)

Detour("RunStringEx", function(Original, Code, Identifier, ...)
	TAC.CaptureStack("RunStringEx")
	
	if Identifier then
		TAC.Detours.Whitelist.Identifiers[Identifier] = true
	end
	
	if isstring(Code) then
		TAC.Detours.Whitelist.Update(Code, Identifier)
	end
	
	TAC.Detours.Whitelist.Increment()
	
	return Original(Code, Identifier, ...)
end)

Detour("CompileString", function(Original, Code, Identifier, ...)
	TAC.CaptureStack("CompileString")
	
	if Identifier then
		TAC.Detours.Whitelist.Identifiers[Identifier] = true
	end
	
	local Output = Original(Code, Identifier, ...)

	if isfunction(Output) then		
		TAC.Detours.Whitelist.Update(Output, Identifier)
	end
	
	TAC.Detours.Whitelist.Increment()
	
	return Output
end)

--- Globals ---

Detour("Color", function(Original, ...)
	TAC.CaptureStack("Color")
	return Original(...)
end)