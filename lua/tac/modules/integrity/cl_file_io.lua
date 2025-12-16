TAC.FileIO = { }

function TAC.FileIO.Run()
    local Directory, Data = TAC.Random(5) .. ".txt", TAC.Random()

    file.Write(Directory, Data)

    if not file.Exists(Directory, "DATA") then
        return TAC.Flag("File IO", "Doesn't Exist")
    else
        local Read = file.Read(Directory, "DATA")

        if Read ~= Data then
            return TAC.Flag("File IO", "Invalid Data Written")
        end
    end

    file.Delete(Directory)

    if file.Exists(Directory, "DATA") then
        return TAC.Flag("File IO", "Blocked Delete Call")
    end
end

TAC.FileIO.Run()