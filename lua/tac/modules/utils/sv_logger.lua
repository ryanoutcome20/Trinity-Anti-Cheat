local Player = FindMetaTable("Player")

function Player:tLog(Type, Text, Override)
	assert(isstring(Type), "No `Type` string provided to Player tLog!", type(Type))
	assert(isstring(Text), "No `Text` string provided to Player tLog!", type(Text))

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
			self,
			Type,
			Text
		)
	end

	if TAC.Config.Logging.File then
		self:tWrite(
			"log.txt",
			Text,
			true
		)
	end
	
	TAC.Config.Logging.Callback(
		self,
		Type,
		Text
	)
end

function Player:tWrite(Directory, Text, useHeader, deleteData)
	assert(isstring(Directory), "No `Directory` string provided to Player tWrite!", type(Directory))
	assert(isstring(Text), "No `Text` string provided to Player tWrite!", type(Text))

    Directory = self:tDir(Directory)

    file.CreateDir(string.GetPathFromFilename(Directory))

    if deleteData or not file.Exists(Directory, "DATA") then 
        file.Write(Directory, useHeader and self:tHeader() or "")
    end

    file.Append(Directory, Text .. "\n")
end

function Player:tDir(Directory)
    return string.format(
        "%s/%s/%s", 
        TAC.Config.Logging.Directory,
        self:SteamID64(),
        Directory or "error.txt"
    )
end

function Player:tHeader()
    return string.format(
        "Trinity Anti-Cheat [%s %s -> %s]\n\nCreated on: %s\nCreated for: %s (%s, %s) [%s]\n\n",
        TAC.Version,
		TAC.Edition,
		VERSION,
        os.date("%d/%m/%Y %H:%M:%S"),
        TAC.Fix(self:Name()),
        self:SteamID(),
        self:SteamID64(),
        TAC.IP(self)
    )
end