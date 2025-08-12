# Introduction

**Trinity Anti-Cheat** offers a modular system for external addons to add their own modules and additions to the anti-cheat.

# Main Modules

Modules are dynamically loaded in from the client side and server side. Modules are stored in `lua/tac/`. In order to use a module, you must first create a folder for your module and then create its `init.lua` file. For example:

In `tac/example/init.lua`

```lua
AddCSLuaFile() -- This file will now be included dynamically by the clientside. Any file added will be included dynamically.

AddCSLuaFile("cl_example.lua") -- This will now be included by the clientside.
include("sv_example.lua") -- This will now be included by the serverside.

MsgN(CLIENT and "CLIENT" or "SERVER")
```

This structure allows you to string together larger modules by including them from the init file. It is recommended to manually include files via the init file on the client side; otherwise, they will load alphabetically.

# Lists

Lists are dynamically loaded from the client side and server side. The realm of the list depends on the prefix. Lists are stored in `lua/lists/` and some realm examples include:

- `lua/lists/cl_example.lua`: This will only be visible to the client realm.
- `lua/lists/sv_example.lua`: This will only be visible to the server realm.
- `lua/lists/sh_example.lua`: This will be visible to both realms.

Lists are dynamically included using the built-in `include` function and must be structured like so:

```lua
return "Example", {
	A = 1,
	B = 2
}
```

You can access your new list by using the utility libraries offered by the server side & client side:

```lua
-- As of 0.1.4 this has yet to be completed
-- TODO! Expected as of 0.1.5+
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