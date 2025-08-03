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

AccessorFunc(Base, "Pos", "Pos")
AccessorFunc(Base, "EyeTrace", "EyeTrace")

AccessorFunc(Base, "Delta", "Delta")
AccessorFunc(Base, "TraceData", "TraceData")
AccessorFunc(Base, "Weapon", "Weapon")

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
	
	Meta:SetPos(Player:GetPos())
	Meta:SetEyeTrace(Player:GetEyeTrace())
	Meta:SetWeapon(Player:GetActiveWeapon())

	return Meta
end

function TAC.SCP.StartCommand(Player, CUserCMD)
	-- We have to cache some of the incoming commands
	-- so that we can use comparisons later.
	
	-- Also technically we should be using the EyeTrace
	-- and generating our angles from that but to me it
	-- is a bit too unoptimized and not nearly precise
	-- enough for some of our checks.
	
	-- Player:GetAimVector():AngleEx(vector_origin)
	
	local cOld = Player:Grab("SCP")
	local cNew = TAC.SCP.CopyMeta(Player, CUserCMD)
	
	Player:Set("SCP", cNew)
	
	if not cOld then
		return
	end
	
	cNew:SetDelta(math.abs(math.AngleDifference(TAC.StandardAngle(cNew:GetViewAngles().y), TAC.StandardAngle(cOld:GetViewAngles().y))))
	
	local Trace = cNew:GetEyeTrace()
	
	cNew:SetTraceData({
		Entity = Trace.Entity,
		Valid = Trace.Entity and Trace.Entity:IsPlayer() or false
	})
	
	hook.Run("StartCommandPlus", Player, cNew, cOld, CUserCMD)
end

hook.Add("StartCommand", "TAC.SCP.StartCommand", TAC.SCP.StartCommand)