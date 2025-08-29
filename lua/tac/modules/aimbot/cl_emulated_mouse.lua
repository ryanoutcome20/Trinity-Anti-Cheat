TAC.EmulatedMouse = { }

local sensitivity = GetConVar("sensitivity")

local m_yaw = GetConVar("m_yaw")
local m_pitch = GetConVar("m_pitch")

function TAC.EmulatedMouse.Scan(CUserCMD)
	-- I know its flipped but it doesn't work the other way around
	-- so I dunno.
	
    if CUserCMD:CommandNumber() == 0 then 
		return 
	end
    
	local Current = CUserCMD:GetViewAngles()
	
	if not Capture then 
		Capture = Current
	end
	
	local Config = TAC.Config.Aimbot.EmulatedMouse

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
	if Config.Yaw and math.abs(actualYaw - expectedYaw) > Config.YawOffset and expectedYaw == 0 then
		TAC.Flag("Emulated Mouse", "Emulated Mouse [yaw; in: %f; out: %f]", expectedYaw, actualYaw)
	end

	if Config.Pitch and math.abs(actualPitch - expectedPitch) > Config.PitchOffset and expectedPitch == 0 then
		TAC.Flag("Emulated Mouse", "Emulated Mouse [pitch; in: %f; out: %f]", expectedPitch, actualPitch)
	end

    Capture = Current
end

hook.Add("CreateMove", "TAC.EmulatedMouse.Scan", TAC.EmulatedMouse.Scan)