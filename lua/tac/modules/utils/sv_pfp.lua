function TAC.UpdateProfilePicture(Player)
    Player.Avatar = "https://i.imgur.com/MBRvOU1.png" -- Default "?" steam photo.

    http.Fetch("https://steamcommunity.com/profiles/" .. Player:SteamID64() .. "?xml=1", function(Body)
        if not Body then
            return
        end

        local XML = XMLToTable(Body)

        if not istable(XML) or not istable(XML.profile) or not XML.profile.avatarIcon then
            return
        end

        Player.Avatar = XML.profile.avatarIcon
    end)
end

hook.Add("PlayerInitialSpawn", "TAC.UpdateProfilePicture", TAC.UpdateProfilePicture)