TAC.Verbose = { }

function TAC.Verbose.TableDumpFlat(Table)
    local Append = ""
    local Stack = {
		{
			Table = Table, 
			Indent = 0, 
			Keys = nil, 
			Index = 1
		}
	}

    while #Stack > 0 do
        local Frame = Stack[#Stack]
        local Table, Indent = Frame.Table, Frame.Indent

        if not Frame.Keys then
            Frame.Keys = { }
			
            for k,v in pairs(Table) do 
				table.insert(Frame.Keys, k)
			end
        end

        local Key = Frame.Keys[Frame.Index]
        if Key then
            local Value = Table[Key]
            local Line = string.rep("  ", Indent) .. tostring(Key) .. " = "
			
            if istable(Value) then
                Append = Append .. Line .. "{\n"
				
                table.insert(Stack, {
					Table = Value, 
					Indent = Indent + 1, 
					Keys = nil, 
					Index = 1
				})
            else
                Append = Append .. Line .. tostring(Value) .. "\n"
            end
			
            Frame.Index = Frame.Index + 1
        else
            if Indent > 0 then
                Append = Append .. string.rep("  ", Indent - 1) .. "}\n"
            end
			
            table.remove(Stack)
        end
    end

    return string.sub(Append, 1, -2)
end

function TAC.Verbose.Dump(Player)
	assert(IsValid(Player) and Player:IsPlayer(), "No `Player` player provided to TAC.Verbose.Dump!", type(Player))

	local Position = Player:GetPos()
	local Velocity = Player:GetVelocity()
	
	local Angle = Player:EyeAngles()
	local cAngle = Player:GetAimVector():AngleEx(vector_origin)
	
	local SWEP = Player:GetActiveWeapon()

	if SWEP and IsValid(SWEP) then
		SWEP = SWEP:GetClass()
	end
	
	local Dump = string.format(
		"Verbose dump:\n\nname:%s\nsteamid:%s\nusergroup:%s\npos:[%s,%s,%s]\nvel:[%s,%s,%s]\nang:[%s,%s,%s]\nang_comp:[%s,%s,%s]\nmove:%i\ncar:%s\nswep:%s",
		Player:Name(),
		Player:SteamID64(),
		Player:GetUserGroup(),
		Position.x, Position.y, Position.z,
		Velocity.x, Velocity.y, Velocity.z,
		Angle.x, Angle.y, Angle.z,
		cAngle.x, cAngle.y, cAngle.z,
		Player:GetMoveType(),
		Player:InVehicle() and "yes" or "no",
		SWEP
	)
	
	Dump = Dump .. "\n\n---\n\n"
	
	Dump = Dump .. TAC.Verbose.TableDumpFlat(Player.TAC or { })

	TAC.API.Log(
		Player,
		"VERBOSE",
		Dump,
		"Verbose dump completed!"
	)
end

concommand.Add("tac_verbose_dump", function(Player, Command, Arguments)
	if Player and not Player:IsSuperAdmin() then
		TAC.API.Alert(
			Player,
			"This command is restricted to Super Admin only",
			NOTIFY_ERROR
		)
		
		TAC.Print(
			PRINT_WARN,
			"PVS",
			"Blocked client `%s` from recomputing PVS", 
			Player:Name()
		)
		
		return
	end

	local Name = Arguments[1]

	if not Name then
		return
	end
	
	for k, Target in player.Iterator() do 
		if Target:Name() == Name then
			TAC.Verbose.Dump(Target)
		end
	end
end)