TAC.API = { }

local Meta = FindMetaTable("Player")

--- Logging ---

MsgN("  Initializing logging API")

function TAC.API.Log(Player, Type, Text, Override)
	assert(isstring(Type), "No `Type` string provided to TAC.API.Log!", type(Type))
	assert(isstring(Text), "No `Text` string provided to TAC.API.Log!", type(Text))

    Type = string.upper(Type)

	if TAC.Config.Logging.Console and Override ~= true then 
		TAC.Print(
			PRINT_WARN,
			Type,
			Override or Text
		)
	end

	Text = TAC.Config.Logging.Prefix(Type) .. Text
	
	if TAC.Config.Logging.DB then 
		TAC.Config.Logging.DBCreate()
		
		TAC.Config.Logging.DBQuery(
			Player,
			Type,
			Text
		)
	end

	if TAC.Config.Logging.File then
        TAC.API.WritePlayerDirectory(
            Player, 
            "log.txt",
            Text, 
            true
        )
	end
	
	TAC.Config.Logging.Callback(
		Player,
		Type,
		Text
	)
end

function TAC.API.WritePlayerDirectory(Player, Directory, Text, useHeader, deleteData)
	assert(isstring(Directory), "No `Directory` string provided to TAC.API.WritePlayerDirectory!", type(Directory))
	assert(isstring(Text), "No `Text` string provided to TAC.API.WritePlayerDirectory!", type(Text))

    Directory = TAC.API.GetPlayerDirectory(Player, Directory)

    file.CreateDir(string.GetPathFromFilename(Directory))

    if deleteData or not file.Exists(Directory, "DATA") then 
        file.Write(Directory, useHeader and TAC.API.GetPlayerFileHeader(Player) or "")
    end

    file.Append(Directory, Text .. "\n")
end

function TAC.API.GetPlayerDirectory(Player, Directory)
    return string.format(
        "%s/%s/%s", 
        TAC.Config.Logging.Directory,
        Player:SteamID64(),
        Directory or "error.txt"
    )
end

function TAC.API.GetPlayerFileHeader(Player)
    return string.format(
        "Trinity Anti-Cheat [%s %s -> %s]\n\nCreated on: %s\nCreated for: %s (%s, %s) [%s]\n\n",
        TAC.Version,
		TAC.Edition,
		VERSION,
        os.date("%d/%m/%Y %H:%M:%S"),
        TAC.Fix(Player:Name()),
        Player:SteamID(),
        Player:SteamID64(),
        TAC.IP(Player)
    )
end

--- Caching ---

MsgN("  Initializing caching API")

function TAC.API.Set(Player, Key, Value)
	Player.TAC = Player.TAC or { }
	
	Player.TAC[Key] = Value
	
	return Value
end

function TAC.API.Get(Player, Key, Default)
	Player.TAC = Player.TAC or { }

	return Player.TAC[Key] or Default
end

Meta.Get = TAC.API.Get
Meta.Set = TAC.API.Set

--- Alerts ---

MsgN("  Initializing alerts API")

function TAC.API.Alert(Player, Message, Type, Sound)
	assert(isstring(Message), "No `Message` string provided to TAC.API.Alert!", type(Message))

	if not IsValid(Player) or not Player:IsPlayer() then
		return
	end

	if not Sound then
		-- https://github.com/Facepunch/garrysmod/blob/a55a2c1b19c442eb4b5e9cebc260ed3b6d4598ff/garrysmod/gamemodes/sandbox/gamemode/cl_hints.lua#L34
		Sound = "ambient/water/drip" .. math.random( 1, 4 ) .. ".wav"
	end

	if not Type then
		Type = NOTIFY_GENERIC
	end

	Atlas:Send(
		"Alert",
		Player,
		{
			Message,
			Type,
			Sound
		}
	)
end