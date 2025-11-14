TAC.DebugHooks = { }

local Config = TAC.Config.DebugHooks

local List = TAC.Lists.Merge("Debug Hooks")

function TAC.DebugHooks.Scan(Function, ...)
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

function TAC.DebugHooks.Run(Function)
    if debug.getinfo(Function, "S").what ~= "C" then 
        return false
    end

    jit.flush()
    collectgarbage()

    local Initial = TAC.DebugHooks.Scan(Function, nil)

    if Config.Garbage and Initial.Garbage > Config.Delta then
        TAC.Flag("Debug Hooks", "Just-In-Time Garbage Size [delta: %i]", Initial.Garbage)
        return true
    elseif Config.Lines then
        local Secondary = TAC.DebugHooks.Scan(Function, nil)
        
        if Initial.Lines ~= Secondary.Lines then
            TAC.Flag("Debug Hooks", "Just-In-Time Lines [first: %i; second: %i]", Initial.Lines, Secondary.Lines)
            return true
        end
    end

    return false
end

function TAC.DebugHooks.Step(Index)
    Index = Index or 1

    local Function = List[Index]

    if not Function then
        return
    end

    local Break = TAC.DebugHooks.Run(Function)

    if Break then
        return
    end

    timer.Simple(Config.Step, function()
        TAC.DebugHooks.Step(Index + 1)
    end)
end

timer.Simple(Config.Step, TAC.DebugHooks.Step)