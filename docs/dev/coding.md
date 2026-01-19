# Introduction

This is a guide on some aspects of code used in Trinity Anti-Cheat. This file should be a little more casual and easier to follow for the developer who needs a quick refresher.

**Table Of Contents**:

1. [Linters Warning](#linters-warning)
2. [Directories](#directories)
3. [Proper File Structure](#proper-file-structure)
4. [Module Structure](#module-structure)
5. [Config Interaction](#config-interaction)
    * [Serverside](#serverside-config)
    * [Clientside](#clientside-config)
6. [Function Structure](#function-structure)
7. [Table Structure](#table-structure)
8. [Hooks](#hooks)
	* [Serverside](#serverside-hooks)
	* [Clientside](#clientside-hooks)
9. [Variable Names](#variable-names)

## Linters Warning

Unfortunately, no linters are adequate for the needs of the project. They do exist for Lua; however, they are woefully unprepared for the scope of the project and the nature of the Garry's Mod API.

GLuaFixer (or GLuaLint) is a project that _*could*_ work but has issues, some of which being: 

* Incorrect errors.
* Aggressively normalized control flow.
* Single statement blocks are collapsed.

There really isn't a config option for any of these, and it results in practically unreadable and unusable code. Don't use it.

## Directories

A short summary of the file structure of the anti-cheat.

```
lua/
    autorun/ -- Automatically ran at boot, just bootcode.
    cores/ -- Cores for pLib, contains punishment API calls for various punishment systems.
    external/ -- All the external libraries.
    includes/ -- Internal detours & file overrides, manually added AddCSLuaFile through autorun.
    tac/ - Main TAC.
        config/ - Config files, server and client, client is streamed.
        gamemode/ - Gamemode overrides, best not to touch unless you understand the underlying module.
        honeypots/ - Honeypots, also best not to touch unless you understand the underlying module.
        lists/ - The main static lists for the clientside, use TAC.Lists.Merge clientside to grab them.
        modules/ - The main modules, see Module Structure. 
        stubs/ - Stubs for load order in autorun, useless unless you need to add functions to the config (like pStubs) where you register something complicated without over complicating the top of the config file.
```

## Proper File Structure

General order of operations when dealing with files (especially modules).

1. Assign table.
2. Localized variables.
3. Create functions.
4. Hooks, timers, and other related logic.

In that order.

## Module Structure

A module is a folder created in the `lua/tac/modules/` folder; they are the main driving force behind the checks in Trinity. All modules require an `init.lua` file, which will be run on the server, and all modules share similar capabilities.

When creating an init file, the common practice is to create your table for the modules' subfiles and then include them:

```lua
TAC.Example = { }

include("sv_example.lua")
```

**Clientside Files**:

To create a clientside file that'll be networked dynamically down the client all you have to do is setup a return in this init file. An example would be:

```lua
TAC.Example = { }

include("sv_example.lua")

return {
    "cl_example.lua"
}
```

There is also a second argument to that return, which involves simply adding a `}, true` to the end of your return statement - this enables the explicit directory mode, which will load relative from `lua/` instead of `tac/modules/*/`.

An actual example of this is the gamemode specific detections:

```lua
local File = "tac/gamemode/cl_" .. engine.ActiveGamemode() .. ".lua"

if file.Exists(File, "LUA") then
	return {
		File
	}, true
end
```

## Config Interaction

I highly recommend reading the user's guide for [configuration](../user/configuring.md) and [troubleshooting](../user/troubleshooting.md); they both go over how the configuration works (especially flags), and it can be a useful resource.

### Serverside Config

As for interacting with the config on serverside:

```lua
local Config = TAC.Config[Index]
```

Will fetch you the config value; all keys are stored as written, including flags:

```lua
Config.Punishment = {
	IgnoreStaff = false,

	GlobalFilter = false,
	GlobalFilterCallback = function(Player, Config)
		return false
	end,

	pStub.Register("Fallback", {
		-- General
		Enabled = false,
		Name = "Fallback",
		Description = "",
		Category = "None", 
		
		-- Clientside
		Client = false,
		
		-- Punishment section.
		Backend = "ULX", -- See "cores/" for adding new ones.
		Method = PUNISHMENT_LOG,
		Message = "Unfair Advantage: {Contact}",
		Time = 0,

		-- Flag section.
		Flags = false,
		Maximum = 3,
		Decay = -1,
		
		AlertFlagsMinimum = 0,
		
		-- Delay section.
		Delay = false,
		DelayMinimum = 1,
		DelayMaximum = 10,
		DelaySID = true,
		DelayIgnoreLogOnly = true,
		
		-- Alert section.
		Alerts = {
			Evaluate = ALERT_NONE,
			Flags = ALERT_STAFF,
			Delays = ALERT_STAFF,
			Punishment = ALERT_EVERYONE
		},
		
		-- Formats.
		FormatEvaluate = "{Name} [{SteamID64}] was evaluated for \"{Info}\" ({ID})!",	
		FormatFlags = "{Name} [{SteamID64}] was flagged for \"{Info}\" ({ID})! [{Flags}]",
		FormatPunishment = "{Name} [{SteamID64}] was punished for \"{Info}\" ({ID})!",
		FormatDelayedPunishment = "{Name} [{SteamID64}] is about to be punished for \"{Info}\" ({ID})! [{Timer}s]",
		FormatLog = "{Name} [{SteamID64}] was logged for \"{Info}\" ({ID})!",
		
		-- Avoidance
		Ping = -1,
		Loss = -1,
		Vehicles = false,
		Water = false,
		Noclip = false,
		SWEPs = {
			-- ...
			-- weapon_smg1 = true
		},

		-- Extra
		Verbose = false,
		Callback = function(self) 
			return false
		end
	}),
}
```

```lua
local Config = TAC.Config["Fallback"] -- Could use .Fallback like we do in the actual codebase.

MsgN(Config.Enabled) -- false
```

### Clientside Config

Clientside is very similar to the serverside:

```lua
local Config = TAC.Config[Index]
```

Handled by the logic in the pre-init bootstrap files, do remember this is a **private** table in a custom environment, don't leak it.

## Function Structure

Example function structure:

```lua
local Table = { } -- Always space brackets only IF the table is empty.

function Table.PrintHello(Name, Age, printType) -- We don't use Table: and self defines in Lua. Nor parentheses spaces.
    -- We do not use () nor C style operators like ! or ||.
    if not Name then -- Always new line.
        return
    end

    -- Attempt to format printed data always. We use MsgN instead of print for utility purposes.
    MsgN(string.format(
        "Hello: `%s`", -- We use `` when quoting data in formats.
        Name
    ))

    -- TAC.Print automatically formats things for you with a specific header and all.
    TAC.Print(
		printType, -- This is just an example, this isn't complicated enough to really need a two word argument name.
		"Info",
        "Hello [name: %s; age: %i]", -- Example of the punishment format we use. 
        Name,
        Age
	)
end

Table.PrintHello("Ryan", 18, PRINT_INFO) -- Calls without spaces. No semicolons on newlines either.
```

As you can clearly see we enforce the following:

* Capitalized function names, source table names, and arguments.
* Simple, easy-to-read, usually single-word arguments.
* When doing doubled text arguments, use camelCase (only in very complicated arguments).
* Always formatting data or using a library that does it for you when printing given data.
* Always expanded if statement trees.
* Never use if statement parentheses unless doing mathematical operations.
* No C-style operators, only Lua style.
* Calls are always done without spaces in between parentheses.
* No semicolons on newlines unless empty value; do not handle more than one operation per line.
* When creating a table, always space brackets **if** the table is empty.
* Bring functions into multiline calls as an alternative to word wrapping.

When interacting with metatables you'll always use the prefix `t` with your function, for example:

```lua
local PLAYER = FindMetaTable("Player") -- Always capitalize metatables

function PLAYER:tSayHi() -- Use : in this very specific case.
    TAC.Print(
		PRINT_INFO,
		"Info",
        "Hello: %s!",
        self:Nick()
	)
end
```

We do this to avoid conflict with other addons, for example, `tLog` -> `Log` causes large swaths of compatibility issues.

## Table Structure

Example table structure:

```lua
local Table = {
    Data = { } -- Sub tables also spaced when empty
}

function Table.Example(Name, Age)
    local isAdult; -- Add semicolons in this case when you define a local scope variable but don't assign it.

    if Age > 18 then
        isAdult = true
    end

    table.insert(
        Table.Data
        {
            Name = Name,
            Age = Age,
            isAdult = isAdult
        }
    )
end
```

As you can clearly see we enforce the following:

* Semicolons in the case of empty variables of local scope.
* Preferred use of array-style tables instead of string key-value tables (for optimization reasons).
* Spaced empty table brackets, otherwise newline.

## Hooks

### Serverside Hooks

```TAC.StartCommandPlus```

A hook called for processing CUserCMD inputs. Allows for the use of previous ticks in detections.

```
Player (player) -> Current player this StartCommand is for.
cNew (CUserCMD wrapper object) -> A wrapper object containing various CUserCMD and other related data for this tick.
cOld (CUserCMD wrapper object) -> A wrapper object containing various CUserCMD and other related data for the last tick.
CUserCMD (CUserCMD) -> This ticks the CUserCMD object; prefer to edit the CUserCMD wrapper object than use this. You can also set values in here and actually affect the player, so be careful.
```

```lua
function TAC.Example(Player, cNew, cOld, CUserCMD)
    local Delta = cNew:GetDelta()

    if Delta == angle_zero then
        return
    end
    
    TAC.Print(
		PRINT_INFO,
		"Info",
        "Your last angle delta was: (%s, %s, %s)!",
        Delta.x,
        Delta.y,
        Delta.z
	)
end

hook.Add("TAC.StartCommandPlus", "TAC.Example", TAC.Example)
```

Read the [SCP](scp.md) guide for the various wrappers in cNew and cOld.

```TAC.StartCommandBatch```

A hook called for batch processing CUserCMD inputs.

```
Player (player) -> Current player this StartCommand is for.
Cache (table) -> Contains all the batch data. Maximum and minimum size is forty calls.
    cNew (CUserCMD wrapper object) -> A wrapper object containing various CUserCMD and other related data for this tick index.
    cOld (CUserCMD wrapper object) -> A wrapper object containing various CUserCMD and other related data for the last tick index.
```

```lua
function TAC.Example(Player, Cache)
	for k, Object in ipairs(Cache) do
		local cNew = Object.cNew -- Also has a .cOld.

        local Delta = cNew:GetDelta()

        if Delta == angle_zero then
            continue
        end
        
        TAC.Print(
            PRINT_INFO,
            "Info",
            "Angle Delta #%i: (%s, %s, %s)!",
            k,
            Delta.x,
            Delta.y,
            Delta.z
        )
    end
end

hook.Add("TAC.StartCommandBatch", "TAC.Example", TAC.Example)
```

Read the [SCP](scp.md) guide for the various wrappers in cNew and cOld.

```TAC.TransferStopped```

Called when the files that the client is supposed to run (modules) are finished being sent but haven't loaded yet. See TAC.TransferConfig.

```
Player (player) -> The player we just finished transfering files to.
```

```TAC.TransferConfig```

Called when the config is sent to the client, the client *should* be loaded now.

```
Player (player) -> The player we just finished sending the config to.
```

### Clientside Hooks

```TAC.TransferConfig```

Called just before the client initializes. Will **NEVER** be called in a module since this loads before modules.

```
Config (table) -> The config.
```

```TAC.Initialize```

Called just after the client initializes.

```
Config (table) -> The config.
```

## Variable Names

You'll want to keep variables simple and easy to understand while limiting the size of said variables. Some common variable naming conventions (standards) used in the anti-cheat include:

* `Player` - Refers to any target player or received player, used a lot in hooks, functions, and callbacks.
* `ENT`- Refers to any non-player entity, used a lot in hooks, functions, and callbacks.
* `Target` - Refers to any player when interacting with more than one player object; this is the fallback.
* `CUserCMD` - Refers to a CUserCmd object, used simply because it's what I've always called them.
* `Token` - Refers to a token generated by the tokenized punishments.
* `Cache` - Typically refers to the CUserCMD cache given by TAC.StartCommandBatch.