--- Localization ---

local Detour = TAC.Detour.Register

local Wrap = function(ID, Meta)
	Detour(ID, function(Original, ...)
		TAC.Captures.Stack(ID)

		return Original(...)
	end, Meta)
end

--- Globals ---

Wrap("gcinfo")
Wrap("collectgarbage")
Wrap("getfenv")
Wrap("setfenv")
Wrap("FindMetaTable")
Wrap("print")
Wrap("Msg")
Wrap("MsgN")
Wrap("MsgC")
Wrap("MsgAll")
Wrap("RunConsoleCommand")
Wrap("GetConVar_Internal")
Wrap("Derma_DrawBackgroundBlur")

--- Classes ---

Wrap("TickCount", "CUserCmd")
Wrap("SetViewAngles", "CUserCmd")
Wrap("SetMouseX", "CUserCmd")
Wrap("SetMouseY", "CUserCmd")
Wrap("SetSideMove", "CUserCmd")
Wrap("SetForwardMove", "CUserCmd")

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

Wrap("hook.Add")
Wrap("hook.Remove")

Wrap("input.SetCursorPos")

Wrap("net.SendToServer")

Wrap("gui.EnableScreenClicker")

Wrap("render.IsTakingScreenshot")