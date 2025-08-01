--[[
	StartCommandPlus is a little library for caching and handling the StartCommand
	CUserCMD requests for modules that may require checking requests that were older
	than the newest one.
]]--

TAC.SCP = { }

local Base = { }

AccessorFunc(Base, "Impulse", "Impulse")
AccessorFunc(Base, "Buttons", "Buttons")
AccessorFunc(Base, "MouseX", "MouseX")
AccessorFunc(Base, "ViewAngles", "ViewAngles")
AccessorFunc(Base, "SideMove", "SideMove")
AccessorFunc(Base, "MouseWheel", "MouseWheel")
AccessorFunc(Base, "MouseY", "MouseY")
AccessorFunc(Base, "ForwardMove", "ForwardMove")
AccessorFunc(Base, "UpMove", "UpMove")
AccessorFunc(Base, "CommandNumber", "CommandNumber")

AccessorFunc(Base, "EyeTrace", "EyeTrace")

function TAC.SCP.CopyMeta(Player, CUserCMD)
	local Meta = setmetatable({}, {
		__index = Base
	})

	Meta:SetImpulse(CUserCMD:GetImpulse())
	Meta:SetButtons(CUserCMD:GetButtons())
	Meta:SetMouseX(CUserCMD:GetMouseX())
	Meta:SetViewAngles(CUserCMD:GetViewAngles())
	Meta:SetSideMove(CUserCMD:GetSideMove())
	Meta:SetMouseWheel(CUserCMD:GetMouseWheel())
	Meta:SetMouseY(CUserCMD:GetMouseY())
	Meta:SetForwardMove(CUserCMD:GetForwardMove())
	Meta:SetUpMove(CUserCMD:GetUpMove())
	Meta:SetCommandNumber(CUserCMD:CommandNumber())
	
	Meta:SetEyeTrace(Player:GetEyeTrace())
	
	return Meta
end

function TAC.SCP.StartCommand(Player, CUserCMD)
	-- We have to cache some of the incoming commands
	-- so that we can use comparisons later.
	
	-- Also technically we should be using the EyeTrace
	-- and generating our angles from that but to me it
	-- is a bit too unoptimized and not nearly precise
	-- enough for some of our checks.
	
	local cOld = Player:Grab("SCP")
	local cNew = TAC.SCP.CopyMeta(Player, CUserCMD)
	
	Player:Set("SCP", cNew)
	
	if not cOld then
		return
	end
	
	hook.Run("StartCommandPlus", Player, cNew, cOld, CUserCMD)
end

hook.Add("StartCommand", "TAC.SCP.StartCommand", TAC.SCP.StartCommand)