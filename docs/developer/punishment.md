# Introduction

**Trinity Anti-Cheat** offers a punishment library to assist in the automatic banning of cheaters. This documentation should help you to understand exactly how to use the punishment library.

# Tokens

Tokens are little table objects that contain information about the player, config objects, and other information that will be used later to check if the punishment is valid for that specific player.

Tokens are provided by the following function:

```lua
TAC.Punishment.Evaluate(ID, Player, Info, ...)
```

Which will return one of the following global variables:

```
EVALUATE_FAILED: Failed to evaluate, arguments were nil or invalid. [0]
EVALUATE_FALLBACK: ID provided is non existant. Falling back to default fallback ID. [1]
EVALUATE_SUCCESS: Everything is working, second return value should be your token. [2]
EVALUATE_BYPASSED: With this ID, we shouldn't give a token. The player shouldn't be punished. [3]
```

If you receive the `EVALUATE_SUCCESS` you should have a second return value containing your token:

```lua
local Status, Token = TAC.Punishment.Evaluate("Fallback", Entity(1), "Cheated (%s)", "Format")

if Status == EVALUATE_SUCCESS and Token then
	PrintTable(Token)
else
	MsgN("Failed")
end
```

Note that the `Info` argument will be run through a `string.format` call using the varargs provided.

# Token Validation

Evaluated IDs can return a `EVALUATE_BYPASSED` for a variety of reasons connected to the `TAC.Punishment.Valid` function. It may fail due to rank, ping, loss, etc. All of which are heavily documented in the config files.

# Execution

To execute a punishment on a player, you must pass a token to the function `TAC.Execute`. Below is an example of how that might work:

```lua
local Status, Token = TAC.Punishment.Evaluate("Fallback", Entity(1), "Cheated (%s)", "Format")

if Status == EVALUATE_SUCCESS and Token then
	TAC.Punishment.Execute(Token)
else
	MsgN("Failed")
end
```

This will automatically log the player, check with the flag system, call the backend manager, and handle all of the logic of punishments internally.

# Wrappers

Because this is so verbose for API reasons, I included a simple wrapper function for you to use:

```lua
function TAC.Punishment.Wrapper(ID, Player, Info, ...)
	local Status, Token = TAC.Punishment.Evaluate(ID, Player, Info, ...)
	
	if Status == EVALUATE_SUCCESS and Token then
		return TAC.Execute(Token)
	end
	
	return Status, Token
end
```

Example usage:

```lua
TAC.Punishment.Wrapper("Fallback", Entity(1), "Cheated (%s)", "Format")
```

# Flag System

The flag system generally shouldn't be touched, but it has one important API function for you to use if you need to reset it on a specific player's punishment ID:

```lua
TAC.Punishment.ResetFlags(Player, ID)
```

Example Usage:

```lua
TAC.Punishment.ResetFlags(Entity(1), "Fallback")
```

# Disconnected Players

For disconnected players, we CANNOT verify that the player is actually valid for a punishment since we can't check ranks, ping, loss, or anything like that. Use this function only if you are sure this player deserves to be banned.

```lua
TAC.ExecuteSID(Token)
```