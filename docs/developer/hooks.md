# Introduction

This documentation file is designed to get you up and running with all the major hooks you'll be working with inside of **Trinity Anti-Cheat**.

## Serverside

### StartCommandPlus

`TAC.StartCommandPlus`

`player Player, table cNew, table cOld, userdata CUserCMD`

This is a major serverside hook that provides a CUserCMD context for the current tick and last tick based on saved data. It also automatically verifies that the player is valid, authenticated, not a bot, and other sanity checks.

```lua
hook.Add("TAC.StartCommandPlus", "Example", (Player, cNew, cOld, CUserCMD)
    MsgN(cNew:GetDelta()) -- Current yaw delta
    MsgN(cNew:GetViewAngles() == CUserCMD:GetViewAngles()) -- true
end)
```

### StartCommandBatch

`TAC.StartCommandBatch`

`player Player, table Cache`

This is a minor serverside hook that provides a cache context with 40 captured TAC.StartCommandPlus indexes.

```lua
hook.Add("TAC.StartCommandBatch", "Example", (Player, Cache)
    MsgN(Cache[1].cNew:GetViewAngles()) -- View angles from 40 StartCommand's ago
    PrintTable(Cache) -- A whole lot of data
end)
```

```lua
function TAC.Batch.StartCommandPlus(Player, cNew, cOld)
	local Cache = Player:Grab("Batch Storage", { })
	
	table.insert(Cache, {
		cNew = cNew,
		cOld = cOld
	})
	
	if #Cache >= 40 then
		hook.Run("TAC.StartCommandBatch", Player, Cache)
	
		Cache = { }
	end
		
	Player:Set("Batch Storage", Cache)
end
```

### TransferStopped

`TAC.TransferStopped`

`player Player`

This is a minor serverside hook that is ran when the player finishes collecting all of his file transfers. When this is called the player *should* have ran all registered clientside files.

Note that this isn't called when the player disconects or becomes invalid mid-transfer, only at the end when the next file in the list doesn't exist.

```lua
hook.Add("TAC.TransferStopped", "Example", (Player)
    MsgN(Player:Nick() .. " just finished loading!")
end)
```