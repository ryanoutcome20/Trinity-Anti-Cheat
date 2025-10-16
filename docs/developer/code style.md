# Introduction

This file should give you the basic coding style rules for **Trinity Anti-Cheat**. It will cover things like if statements, functions, function arguments, variable naming, key-pair tables, and some less common topics for onboarding developers to get used to working on the codebase.

# Variables

Variables are designed to be simple and should follow a simple structure. We use PascalCase for everything. 

Exceptions can be made for very long variables. An example would be the `cNew` and `cOld` used by `StartCommandPlus`. This is used instead of using `CUserCMDNew` and `CUserCMDOld`.

Exceptions can also be made to low-level engine bindings. An example would be `m_flSimulationTime` used by the Simulation Time check. Since this is such a low-level binding and must be grabbed like that anyway, setting the variable to that isn't a big deal.

# If Statements

If statements follow a simple, typical Lua style where there are no parentheses and the statement just contains basic operands. Do not use C-style conditionals (`||`, `&&`, `!=`).

```lua
if Value == Value2 and Value2 == Value3 then
	MsgN("Hello World!")
end

if Value == Value3 and Value2 ~= Value1 or Value1 == Value2 then
	MsgN("Yay!")
end
```

# Functions & Function Arguments

Functions should follow a non-OOP style with very little substance. All arguments should follow variable naming rules. For example:

```lua
TAC.Table = { }

function TAC.Table.Calculate(X, Y) -- No OOP, no self.
	return X + Y -- Simple variable names.
end
```

# Comments

We use basic Lua-style commits. Not C-style commits. For example:

```lua
-- This is a message.

--[[
	Large message!
--]]
```

Always indent and newline multi-line comments. Try to manually word wrap after an arbitrary point in multi-line comments.

# Key Pair Tables

Try to limit your tables to using index-based tables instead of string-key-based tables if you plan to loop through them. This allows you to use an `ipair` loop instead of a `pair` loop, significantly increasing performance.

Do not use numeric loops unless you need special conditions (looping backwards for `table.remove`).

Only use string-key-based tables if you need to index into them or designing it around `pair` loops is much too complex.

```lua
local Names = {
	["Jerry W. Smith"] = {
		Age = 52,
		Height = 5.8
	}
}

function Names.Get(Name)
	return Names[Name]
end

MsgN(Names.Get("Jerry W. Smith").Age)
```

```lua
local Array = {
	1,
	2,
	3,
	4,
	128
}

function Array.Loop()
	for k,v in ipairs(Array) do 
		MsgN(v)
	end
end

Array.Loop()
```

# OOP

**Do not use the code style inside of these examples.**

Why not OOP? Well, we use lots of major structures such as `TAC.Punishments` and `TAC.Networking`; the issue here is that within a table such as `TAC.Networking` you cannot access `TAC.Punishments` with `self`. This issue compounds with larger frameworks and leads to one of two methods of actually getting the data you want:

```lua
TAC.Networking = {
	Punishments = TAC.Punishments
}

function TAC.Networking:Example(Player)
	self.Punishments:Explode(Player)
end
```

or

```lua
TAC.Networking = OOP.Register("Networking")

OOP.Grab("Punishments")

function TAC.Networking:Example(Player)
	self.Punishments:Explode(Player)
end
```

Both of these run into the issue of the fact that OOP is not inherently truly supported in LuaJIT, and you get the issue of table nesting with large projects:

```lua
TAC
	Networking
		Punishments
			Explode
		Example
	Punishments
		Explode
```

It doesn't look terrible, but if you scale this to multiple inherits and hundreds of library functions, you'll run into structure issues very quickly.

The alternative which is much better:

```lua
TAC.Networking = { }

function TAC.Networking.Explode(Player)
    TAC.Networking.Notify(Player, "Boom!")
end

function TAC.Networking.Notify(Player, Message)
    -- Code.
end
```

# Meta Tables

You may use meta tables when interacting with the game's various meta tables. Such as:

```lua
local Player = FindMetaTable("Player")

function Player:Who()
	return self:Name()
end
```

# RunString / Dynamic Execution

Do not use dynamic execution unless it is truly needed for a very specific reason. If possible, use `include`. Instances of dynamic execution being required will vary depending on various factors, so a case-by-case basis will be decided.

An example within the current code base of "truly needed":

```lua
if TAC.Config.FSB.Enabled then
	for k, Indentifier in ipairs(TAC.Config.FSB.Indentifier) do 
		TAC.Config.FSB.Handle(TAC.Config.FSB.Code, Indentifier) -- TAC.Config.FSB.Handle is RunString (or RunStringEx)
	end
end
```

# Player Name

If dealing with a player always use the variable name `Player`. If you cannot use `Player` then use `Target`. If dealing with more than one player then use the variable name specific to that use case. Examples include:

```lua
hook.Add("PlayerDeath", "Example", function(Victim, Inflictor, Attacker)
	-- Code.
	-- Can also use "Player" instead of "Victim"!
end)
```

```lua
hook.Add("PlayerHurt", "Example", function(Player, Target)
	-- Code.
end)
```

```lua
hook.Add("StartCommand", "Example", function(Player, CUserCMD)
	-- Code.
end)
```
