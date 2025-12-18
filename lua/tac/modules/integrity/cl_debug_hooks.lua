TAC.DebugHooks = { }

local Config = TAC.Config.Integrity.DebugHooks

local List = TAC.Lists.Merge("Debug Hooks")
local Lines = 0

function TAC.DebugHooks.Scan(Function, ...)
    Lines = 0

    collectgarbage()

    local Pre = collectgarbage("count")
 
    for i = 1, Config.Fill / 2 do 
        Lines = Lines + 1
    end

	pcall(Function, ...)

    local Post = collectgarbage("count")

    return {
        Lines = Lines,
        Garbage = Post - Pre
    }
end

function TAC.DebugHooks.Run()
    debug.sethook(function()
        Lines = Lines + 1
    end, "l")

    for k, Function in ipairs(List) do
        local Initial = TAC.DebugHooks.Scan(Function, nil)

        if Config.Garbage and Initial.Garbage > Config.Delta then
            TAC.Flag("Debug Hooks", "Just-In-Time Garbage Size [delta: %i]", Initial.Garbage)
            break
        elseif Config.Lines then
            local Secondary = TAC.DebugHooks.Scan(Function, nil)
            
            if Initial.Lines ~= Secondary.Lines then
                TAC.Flag("Debug Hooks", "Just-In-Time Lines [first: %i; second: %i]", Initial.Lines, Secondary.Lines)
                break
             elseif Initial.Lines - Config.Fill ~= Config.Target then
                TAC.Flag("Debug Hooks", "Just-In-Time Lines [expected: %i; got: %i]", Config.Target, Initial.Lines - Config.Fill)
                break
            end
        end
    end

    debug.sethook()
end

TAC.DebugHooks.Run()