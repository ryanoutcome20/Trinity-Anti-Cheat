function TAC.OnPhysgunPickup(Player, Target)
    Player:Set(
        "Physgun Target", 
        Target
    )
end

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

hook.Add("OnPhysgunPickup", "TAC.OnPhysgunPickup", TAC.OnPhysgunPickup)
hook.Add("PhysgunPickup", "TAC.PhysgunPickup", TAC.PhysgunPickup)
hook.Add("PhysgunDrop", "TAC.PhysgunDrop", TAC.PhysgunDrop)