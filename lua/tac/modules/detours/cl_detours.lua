--- Localization ---

local Detour = TAC.Detour.Register

--- Whitelist ---

Detour("RunString", function(Original, Code, Identifier, ...)
	TAC.Detours.CaptureStack("RunString")
	
	if Identifier then
		TAC.Detours.Whitelist.Identifiers[Identifier] = true
	end
	
	if isstring(Code) then
		table.insert(
			TAC.Detours.Whitelist.Compiled,
			TAC.Detours.Whitelist.Hash(Code, Identifier)
		) 
	end
	
	TAC.Detours.Whitelist.Increment()
	
	return Original(Code, Identifier, ...)
end)

Detour("RunStringEx", function(Original, Code, Identifier, ...)
	TAC.Detours.CaptureStack("RunStringEx")
	
	if Identifier then
		TAC.Detours.Whitelist.Identifiers[Identifier] = true
	end
	
	if isstring(Code) then
		table.insert(
			TAC.Detours.Whitelist.Compiled,
			TAC.Detours.Whitelist.Hash(Code, Identifier)
		) 
	end
	
	TAC.Detours.Whitelist.Increment()
	
	return Original(Code, Identifier, ...)
end)

Detour("CompileString", function(Original, Code, Identifier, ...)
	TAC.Detours.CaptureStack("CompileString")
	
	if Identifier then
		TAC.Detours.Whitelist.Identifiers[Identifier] = true
	end
	
	local Output = Original(Code, Identifier, ...)

	if isfunction(Output) then		
		table.insert(
			TAC.Detours.Whitelist.Compiled,
			TAC.Detours.Whitelist.Hash(Output, Identifier)
		)
	end
	
	TAC.Detours.Whitelist.Increment()
	
	return Output
end)

--- Testing ---
 
_G.Test = function(Value)
	print("Test: " .. Value)
end

Detour("Test", function(Original, ...)
	MsgN("Test: detoured")
	return Original(...)
end)