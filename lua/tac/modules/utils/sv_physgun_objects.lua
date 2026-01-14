function TAC.PhysgunPickup(Player, Target)
    Player:Set(
        "Physgun Target", 
        Target
    )
end

function TAC.PhysgunDrop(Player)
    Player:Set(
        "Physgun Target", 
        nil
    )
end

hook.Add("PhysgunPickup", "TAC.PhysgunPickup", TAC.PhysgunPickup)
hook.Add("PhysgunDrop", "TAC.PhysgunDrop", TAC.PhysgunDrop)