function TAC.Reporter(Stage, Player, OS, Sensitivity, Resolution)
    OS = isstring(OS) and OS or "Windows"
    Sensitivity = isnumber(Sensitivity) and Sensitivity or 3
    Resolution = {
        ScrW = isnumber(Resolution.ScrW) and Resolution.ScrW or 1920,
        ScrH = isnumber(Resolution.ScrH) and Resolution.ScrH or 1080
    }

    if OS == "OSX" then
        Player:Set("OSX", true)
    elseif OS == "Linux" then
        Player:Set("Linux", true)
    else
        Player:Set("Windows", true)
    end

    Player:Set("Sensitivity", Sensitivity)
    Player:Set("Resolution", Resolution)
end

Atlas:Listen("Reporter", "TAC.Reporter", MODE_DONE, TAC.Reporter)