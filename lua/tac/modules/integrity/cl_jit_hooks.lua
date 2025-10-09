TAC.Garbage = { }

local Config = TAC.Config.JITHooks

local List = TAC.Lists.Merge("JIT Hooks")

function TAC.Garbage.Scan(Function, ...)
    local Lines = 0

    collectgarbage()

    local Pre = collectgarbage("count")

    debug.sethook(function()
        Lines = Lines + 1
        
        for i = 1, Config.Fill do 
            debug.getinfo(i, "f")
            continue
        end
    end, "l")
	pcall(Function, ...)
    debug.sethook()

    local Post = collectgarbage("count")

    return {
        Lines = Lines,
        Garbage = Post - Pre
    }
end

function TAC.Garbage.Run(Function)
    if debug.getinfo(Function, "S").what ~= "C" then 
        return false
    end

    jit.flush()
    collectgarbage()

    local Initial = TAC.Garbage.Scan(Function, nil)

    if Config.Garbage and Initial.Garbage > Config.Delta then
        TAC.Flag("JIT Hooks", "Just-In-Time Garbage Size [delta: %i]", Initial.Garbage)
        return true
    elseif Config.Lines then
        local Secondary = TAC.Garbage.Scan(Function, nil)
        
        if Initial.Lines ~= Secondary.Lines then
            TAC.Flag("JIT Hooks", "Just-In-Time Lines [first: %i; second: %i]", Initial.Lines, Secondary.Lines)
            return true
        end
    end

    return false
end

function TAC.Garbage.Step(Index)
    Index = Index or 1

    local Function = List[Index]

    if not Function then
        return
    end

    local Break = TAC.Garbage.Run(Function)

    if Break then
        return
    end

    timer.Simple(Config.Step, function()
        TAC.Garbage.Step(Index + 1)
    end)
end

timer.Simple(Config.Step, TAC.Garbage.Step)