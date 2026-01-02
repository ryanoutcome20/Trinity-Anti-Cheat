/*
    Generates a delta between the current _G table and the new _G table.

    Usage: Run tac_capture, load your script, and then load tac_display.
*/

local Capture;

concommand.Add("tac_capture", function()
    Capture = table.Copy(_G)
end)

concommand.Add("tac_display", function()
    local Visited = {
        [_G] = true,
        [Capture] = true
    }
    
    for k,v in pairs(_G) do 
        if Visited[v] then
            continue
        end
        
        if Capture[k] == nil or Capture[k] ~= v then
            if not istable(v) or not istable(Capture[k]) then
                MsgN(
                    string.format(
                        "%s [c] ~= %s [g] (%s)",
                        tostring(Capture[k]), 
                        tostring(v),
                        tostring(k)
                    )
                )
            end
        end

        Visited[v] = true
    end

    MsgN("\n\n-=-=-=-=-=-\n\n")

    for k,v in pairs(Capture) do 
        if not Visited[v] and not istable(v) then
            MsgN(
                string.format(
                    "%s [lost]",
                    v
                )
            )
        end
    end
end)