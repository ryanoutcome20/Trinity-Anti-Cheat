--- Localization ---

local Detour = TAC.Detour.Register

local Wrap = function(ID, Meta)
	Detour(ID, function(Original, ...)
		TAC.CaptureStack(ID)
		return Original(...)
	end, Meta)
end

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

Wrap("Color")
Wrap("Angle")
Wrap("Vector")
Wrap("getmetatable")
Wrap("setmetatable")
Wrap("FindMetaTable")
Wrap("print")
Wrap("MsgN")
Wrap("MsgC")

--- Classes ---

Wrap("CommandNumber", "CUserCmd")
Wrap("TickCount", "CUserCmd")
Wrap("SetViewAngles", "CUserCmd")
Wrap("SetMouseX", "CUserCmd")
Wrap("SetMouseY", "CUserCmd")
Wrap("SetSideMove", "CUserCmd")
Wrap("SetForwardMove", "CUserCmd")

Wrap("RotateAroundAxis", "Angle")
Wrap("Normalize", "Angle")

Wrap("Forward", "Vector")
Wrap("Angle", "Vector")
Wrap("AngleEx", "Vector")

Wrap("Nick", "Player")
Wrap("Ping", "Player")
Wrap("Team", "Player")
Wrap("GetUserGroup", "Player")
Wrap("IsUserGroup", "Player")
Wrap("IsAdmin", "Player")
Wrap("IsSuperAdmin", "Player")

Wrap("IsDormant", "Entity")

--- Libraries ---

Wrap("timer.Simple")
Wrap("timer.Create")

Wrap("util.IsBinaryModuleInstalled")
Wrap("util.TraceLine")
Wrap("util.TraceHull")

Wrap("math.random")
Wrap("math.randomseed")

Wrap("hook.Add")
Wrap("hook.Remove")

Wrap("concommand.Add")
Wrap("concommand.Remove")

Wrap("input.SetCursorPos")

Wrap("net.SendToServer")