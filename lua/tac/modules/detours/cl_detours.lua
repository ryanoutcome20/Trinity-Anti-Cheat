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

Detour("Angle", function(Original, ...)
	TAC.CaptureStack("Angle")
	return Original(...)
end)

Detour("Vector", function(Original, ...)
	TAC.CaptureStack("Vector")
	return Original(...)
end)

Detour("getmetatable", function(Original, ...)
	TAC.CaptureStack("getmetatable")
	return Original(...)
end)

Detour("setmetatable", function(Original, ...)
	TAC.CaptureStack("setmetatable")
	return Original(...)
end)

Detour("FindMetaTable", function(Original, ...)
	TAC.CaptureStack("FindMetaTable")
	return Original(...)
end)

Detour("print", function(Original, ...)
	TAC.CaptureStack("print")
	return Original(...)
end)

Detour("MsgN", function(Original, ...)
	TAC.CaptureStack("MsgN")
	return Original(...)
end)

Detour("MsgC", function(Original, ...)
	TAC.CaptureStack("MsgC")
	return Original(...)
end)

Detour("RunString", function(Original, ...)
	TAC.CaptureStack("RunString")
	return Original(...)
end)

Detour("CompileString", function(Original, ...)
	TAC.CaptureStack("CompileString")
	return Original(...)
end)

---  ---