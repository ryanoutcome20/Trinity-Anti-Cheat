# Introduction

**Trinity Anti-Cheat** offers a modular system for external addons to add their own modules and additions to the anti-cheat.

# Main Modules

Modules are dynamically loaded on the serverside from the directory `tac/modules/`. Serverside, they are loaded automatically by calling the `init.lua` file. Below is an example of how to use these `init.lua` files.

```lua
if SERVER then
	-- This includes a serverside file.
	include("sv_serverside.lua")
	
	-- This defines load orders for clientside files.
	-- These are dynamically streamed in order to the clientside.
	return {
		"cl_clientside_one.lua",
		"cl_clientside_two.lua"
	}
end
```

Files that are dynamically streamed are automatically compressed and sent in batches thanks to the Atlas library.

# Lists

Lists are dynamically loaded from the client side and server side. The realm of the list depends on the prefix. Lists are stored in `lua/lists/` and some realm examples include:

- `lua/lists/cl_example.lua`: This will only be visible to the client realm.
- `lua/lists/sv_example.lua`: This will only be visible to the server realm.
- `lua/lists/sh_example.lua`: This will be visible to both realms.

Lists are dynamically included using the built-in `include` function and must be structured like so:

```lua
return {
	A = 1,
	B = 2
}
```

You can access your new list by using the utility libraries offered by the server side & client side:

```lua
-- List names are based on the file names!

local Example = TAC.Lists.Merge("Example", true)

PrintTable(Example) -- tac/lists/sh_example.lua
```

```lua
List name is based on the file name!

TAC.Lists.Merge(Name, Shared) - Merges list automatically, returns the data from the list. Pass true to shared if the file prefix starts with sh_.
TAC.Lists.Grab(Name) - Grabs the list by name from the cache.
```

# Backends

Backends manage the punishment system of the anti-cheat. They will be called if the current punishment token has a punishment ID pointing to that specific backend ID (`Backend`).

Registering a backend requires making a file in the directory: `lua/backends/example.lua`. Usually you want to keep the file name the same as the registered backend ID.

Within the backend file:
```lua
return "Example", {
	Valid = function()
		-- If this fails then the punishment will fallback to
		-- the backend ID: "Default". Default is the same code
		-- as this example (minus comments).
		
		return true
	end,

	Ban = function(Player, Reason, Time)
		-- Player is being banned by punishment system.
		
		Player:Ban(Time, false)
		
		return Player:Kick(Reason)
	end,
	
	BanID = function(SID, Reason, Time)
		-- Player is being banned by punishment system but
		-- they have disconnected.
		
		return RunConsoleCommand("banid", SID, Time, Reason)
	end,
	
	Kick = function(Player, Reason)
		-- Player is being kicked by punishment system.
	
		return Player:Kick(Reason)
	end
}
```