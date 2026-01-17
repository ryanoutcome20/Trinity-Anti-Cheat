function TAC.ProcessOS(Stage, Player, OS)
    if OS == "OSX" then
        Player:Set("OSX", true)
    elseif OS == "Linux" then
        Player:Set("Linux", true)
    else
        Player:Set("Windows", true)
    end
end

Atlas:Listen("Operating System", "TAC.ProcessOS", MODE_DONE, TAC.ProcessOS)