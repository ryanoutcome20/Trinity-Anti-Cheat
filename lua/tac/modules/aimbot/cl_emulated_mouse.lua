TAC.Mouse = { }

local sensitivity = GetConVar("sensitivity")

local m_yaw = GetConVar("m_yaw")
local m_pitch = GetConVar("m_pitch")

function TAC.Mouse.Scan(CUserCMD)
	-- I know its flipped but it doesn't work the other way around
	-- so I dunno.
	
    if CUserCMD:CommandNumber() == 0 then 
		return 
	end
    
	local Current = CUserCMD:GetViewAngles()
	
	if not Capture then 
		Capture = Current
	end
	
	local Config = TAC.Config.Mouse

	if not Config.Enabled then
		return
	end

    local Sensitivity = sensitivity:GetFloat()

	-- Get expected.
    local expectedYaw = CUserCMD:GetMouseX() * Sensitivity * m_yaw:GetFloat()
    local expectedPitch = CUserCMD:GetMouseY() * Sensitivity * m_pitch:GetFloat()
	
	-- Get actual.
    local actualYaw = math.AngleDifference(TAC.StandardAngle(CUserCMD:GetViewAngles().y), TAC.StandardAngle(Capture.y))
    local actualPitch = Current.p - Capture.p

	-- Compare.
	if Config.CheckY and math.abs(actualYaw - expectedYaw) > Config.OffsetY and expectedYaw == 0 then
		TAC.Flag("Emulated Mouse", "Emulated Mouse [yaw; in: %f; out: %f]", expectedYaw, actualYaw)
	end

	if Config.CheckX and math.abs(actualPitch - expectedPitch) > Config.OffsetX and expectedPitch == 0 then
		TAC.Flag("Emulated Mouse", "Emulated Mouse [pitch; in: %f; out: %f]", expectedPitch, actualPitch)
	end

    Capture = Current
end

hook.Add("CreateMove", "TAC.Mouse.Scan", TAC.Mouse.Scan)