pLib = { 
	Cores = { }
}

--- Punishment Functionality ---

function pLib:Ban(Player, Reason, Time)
	return self:GetCore().Ban(Player, Reason, Time)
end

function pLib:BanID(SID, Reason, Time)
	return self:GetCore().BanID(SID, Reason, Time)
end

function pLib:Kick(Player, Reason)
	return self:GetCore().Kick(Player, Reason)
end

--- Core Management Functionality ---

function pLib:Valid(Core)
	return self.Cores[Core] ~= nil
end

function pLib:GetCore()
	return self.Active or self.Cores["default"]
end

function pLib:SetCore(Core)
	self.Active = self.Cores["default"]

	Core = Core and string.lower(Core)

	if Core then
		Core = self.Cores[Core]
		
		if not Core or not Core.Valid() then
			return self.Active, false
		end
		
		self.Active = Core
	end
	
	return self.Active, true
end

--- Load Cores ---

local function Load()
	pLib.Cores = { }

	local Cores = file.Find("cores/*.lua", "LUA")

	for k, File in ipairs(Cores) do 
		local Name, Core = include("cores/" .. File)

		if not Name or not Core then
			continue
		end
		
		pLib.Cores[string.lower(Name)] = Core
	end
end

Load()

concommand.Add("plib_reload", Load)