local function Scan()
    if not TAC.Config.Integrity.DebugSelf.Enabled then
        return
    end 

    local Data = debug.getinfo(debug.getinfo).func(debug.getinfo)
    local Next = debug.getinfo(debug.getinfo)

    if Data.func ~= Next.func then
        local DataPointer, NextPointer = tostring(Data.func), tostring(Next.func)

        if DataPointer == NextPointer then
            return TAC.Flag(
                "Debug Self", 
                "Incorrect function addresses [detoured tostring]"
            )
        else
            return TAC.Flag(
                "Debug Self", 
                "Incorrect function addresses [%s -> %s]",
                DataPointer,
                NextPointer
            )
        end
    elseif Data.source ~= Next.source then
        return TAC.Flag(
            "Debug Self", 
            "Incorrect function source [%s -> %s]",
            tostring(Data.source),
            tostring(Next.source)
        )
    end
end

hook.Add("TAC.Initialize", "TAC.DebugSelf", Scan)