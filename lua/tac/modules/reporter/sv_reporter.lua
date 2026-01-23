function TAC.Reporter(Stage, Player, OS, Sensitivity, Resolution)
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