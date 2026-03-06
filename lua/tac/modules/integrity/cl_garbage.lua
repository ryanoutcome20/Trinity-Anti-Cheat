TAC.Garbage = {
    Pre = 0,
    Post = 0
}

TAC.Lists.Merge("Garbage")

function TAC.Garbage.GetOffset(Callback)
    collectgarbage()

    TAC.Garbage.Pre = collectgarbage("count")

    for i = 1, 15 do
        debug.sethook(function(...)
            TAC.Garbage.Post = collectgarbage("count")
        end, "c")

        for i = 1, 30 do 
            pcall(Callback)
        end

        debug.sethook()
    end

    return (TAC.Garbage.Post - TAC.Garbage.Pre)
end

function TAC.Garbage.Run()
    local Config = TAC.Config.Integrity.Garbage

    if not Config.Enabled then
        return
    end

	local List = TAC.Lists.Grab("Garbage")
	
	if not List then
		return TAC.Flag("Garbage", "Garbage [missing]")
	end

    for k, Callback in pairs(List) do
        local First, Second = TAC.Garbage.GetOffset(Callback), TAC.Garbage.GetOffset(Callback)
        
        if First ~= Second then
            TAC.Flag("Garbage", "Garbage [not equal; %f ~= %f]", First, Second)
        elseif First > Config.Delta then
            TAC.Flag("Garbage", "Garbage [delta; %f]", First)
        end
    end
end

TAC.Garbage.Run()