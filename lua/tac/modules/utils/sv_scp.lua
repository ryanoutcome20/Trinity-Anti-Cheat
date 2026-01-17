--[[
	StartCommandPlus is a little library for caching and handling the StartCommand
	CUserCMD requests for modules that may require checking requests that were older
	than the newest one.
]]--

local AccessorFunc = AccessorFunc
local setmetatable = setmetatable

local math_abs = math.abs
local math_AngleDifference = math.AngleDifference

local hook_Add = hook.Add
local hook_Run = hook.Run

TAC.SCP = { }

local Base = { }

AccessorFunc(Base, "Buttons", "Buttons")
AccessorFunc(Base, "MouseX", "MouseX")
AccessorFunc(Base, "ViewAngles", "ViewAngles")
AccessorFunc(Base, "SideMove", "SideMove")
AccessorFunc(Base, "MouseY", "MouseY")
AccessorFunc(Base, "ForwardMove", "ForwardMove")
AccessorFunc(Base, "UpMove", "UpMove")
AccessorFunc(Base, "CommandNumber", "CommandNumber")
AccessorFunc(Base, "TickCount", "TickCount")
AccessorFunc(Base, "IsForced", "IsForced")

AccessorFunc(Base, "Pos", "Pos")
AccessorFunc(Base, "EyeTrace", "EyeTrace")
AccessorFunc(Base, "Weapon", "Weapon")
AccessorFunc(Base, "OnGround", "OnGround")

AccessorFunc(Base, "Delta", "Delta")
AccessorFunc(Base, "TraceData", "TraceData")

AccessorFunc(Base, "PhysgunTarget", "PhysgunTarget")

function TAC.SCP.CopyMeta(Player, CUserCMD)
	local Meta = setmetatable({ }, {
		__index = Base
	})

	Meta.Buttons = CUserCMD:GetButtons()
	Meta.MouseX = CUserCMD:GetMouseX()
	Meta.SideMove = CUserCMD:GetSideMove()
	Meta.MouseY = CUserCMD:GetMouseY()
	Meta.ForwardMove = CUserCMD:GetForwardMove()
	Meta.UpMove = CUserCMD:GetUpMove()
	Meta.CommandNumber = CUserCMD:CommandNumber()
	Meta.TickCount = CUserCMD:TickCount()
	Meta.IsForced = CUserCMD:IsForced()
	
	Meta.Pos = Player:GetPos()
	Meta.Weapon = Player:GetActiveWeapon()
	Meta.OnGround = Player:IsOnGround()
	
	Meta.EyeTrace = TAC.EyeTrace(Player, true)

	if TAC.Config.AccurateAngles then
		Meta.ViewAngles = Player:GetAimVector():AngleEx(vector_origin)
	else
		Meta.ViewAngles = CUserCMD:GetViewAngles()
	end

	Meta.PhysgunTarget = Player:Get("Physgun Target")

	return Meta
end

function TAC.SCP.Valid(Player)
	return Player:GetObserverMode() == OBS_MODE_NONE and not Player:IsFrozen() and Player:IsFullyAuthenticated() and not Player:IsBot() and not Player:IsTimingOut() and Player:Alive()
end

function TAC.SCP.StartCommand(Player, CUserCMD)
	-- We have to cache some of the incoming commands
	-- so that we can use comparisons later.
	
	if not TAC.SCP.Valid(Player) then
		return
	end
	
	local cOld = Player:Get("SCP")
	local cNew = TAC.SCP.CopyMeta(Player, CUserCMD)
		
	if not cOld then
		Player:Set("SCP", cNew)
		return
	end
	
	cNew.Delta = math_abs(math_AngleDifference(TAC.StandardAngle(cNew.ViewAngles.y), TAC.StandardAngle(cOld.ViewAngles.y)))
	
	local Trace = cNew.EyeTrace
	
	if Trace then
		cNew.TraceData = {
			Entity = Trace.Entity,
			Valid = Trace.Entity and Trace.Entity:IsPlayer() or false
		}
	end
	
	Player:Set("SCP", cNew)
	
	if cOld.Delta and cOld.TraceData then
		hook_Run("TAC.StartCommandPlus", Player, cNew, cOld, CUserCMD)
	end
end

hook_Add("StartCommand", "TAC.SCP.StartCommand", TAC.SCP.StartCommand)