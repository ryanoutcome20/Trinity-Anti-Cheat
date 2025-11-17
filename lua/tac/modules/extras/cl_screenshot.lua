hook.Add("Think", "TAC.Screenshot.Wait", function()
    if gui.IsConsoleVisible() or gui.IsGameUIVisible() then
        return
    end
    
    local W, H = math.random(1, ScrW()), math.random(1, ScrH())

    local Status, Data = pcall(render.Capture, {
        format = "png",
        x = 0,
        y = 0,
        w = W,
        h = H,
        alpha = false
    })

    if not Data then
        TAC.Flag("Anti-Screengrab", "Anti-Screengrab [invalid format]")
    elseif #Data < 30 then 
        TAC.Flag("Anti-Screengrab", "Anti-Screengrab [invalid size]")
    else
        local Sub = string.sub(Data, 1, 4)
        
        if not Sub or Sub ~= string.char(137) .. "PNG" then
            TAC.Flag("Anti-Screengrab", "Anti-Screengrab [invalid data]")
        end
    end

    hook.Remove("Think", "TAC.Screenshot.Wait")
end)