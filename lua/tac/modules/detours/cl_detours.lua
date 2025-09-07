--- Originals ---

local Get = TAC.Localizers.Get

local RunString = Get("RunString")
local RunStringEx = Get("RunStringEx")
local CompileString = Get("CompileString")

--- Whitelist ---

function _G.RunString(Code, Identifier, ...)
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
	
	return RunString(Code, Identifier, ...)
end

function _G.RunStringEx(Code, Identifier, ...)
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
	
	return RunStringEx(Code, Identifier, ...)
end

function _G.CompileString(Code, Identifier, ...)
	TAC.Detours.CaptureStack("CompileString")
	
	if Identifier then
		TAC.Detours.Whitelist.Identifiers[Identifier] = true
	end
	
	local Output = CompileString(Code, Identifier, ...)

	if isfunction(Output) then		
		table.insert(
			TAC.Detours.Whitelist.Compiled,
			TAC.Detours.Whitelist.Hash(Output, Identifier)
		)
	end
	
	TAC.Detours.Whitelist.Increment()
	
	return Output
end

--- Testing ---

function _G.Test()
	TAC.Detours.CaptureStack("CompileString")
end