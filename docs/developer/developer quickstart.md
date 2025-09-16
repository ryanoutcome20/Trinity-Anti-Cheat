# Introduction

These docs are designed for developers looking to contribute to **Trinity Anti-Cheat**. The documentation should give you an idea of proper code formatting, design philosophy, commit structure, testing requirements, and much more.

# Modular vs. Built-in

The first design choice you need to make is whether or not to make the additions built-in to the main anti-cheat or a module that will be loaded dynamically.

The choice is very simple once you break it down, consider the following:

1. Does the additions not improve on the base anti-cheat in a global, non-server specific setting?
2. Does the additions effect the folder structure or change a large amount of existing code?
3. Does the additions cause issues with other gamemodes or addons?

If the answer to any of these is "**Yes**" then you need to make your changes modularly. This isn't a downside however since the anti-cheat was built on a modular, framework. See the [modular.md](./modular.md) file for more information.

If you are building a modular addition, you can submit an issue request to have it placed in the addons section of the README.

# Code Style

The code style rules are outlined in [code style.md](./code style.md) but I will be brief in showcasing them here.

```lua
TAC.Example = { 
	Count = 0
}

function TAC.Example.Compute()
	TAC.Example.Count = TAC.Example.Count + 1
	return TAC.Example.Count
end

function TAC.Example.Run(Player, CUserCMD)
	local Computed = TAC.Example.Compute()
	local Command = CUserCMD:CommandNumber()
	
	if Command == 0 or Computed >= 500 then
		return
	end
	
	MsgN(Computed * Command)
	MsgN(Computed)
	MsgN(Command)
end

hook.Add("StartCommand", "TAC.Example.Run", TAC.Example.Run)
```

This structure follows a very basic Lua style that is intended to leave things easy to read and understand while still keeping the content verbose and fast.

# Commit Style

All commits will be formatted like so:

```
Title: 
Fixed bugs, added documentation, shown example

Description:
Bug Fixes
- Fixed bug with developer quickstart.

Improvements
- Added Commit Style section to developer quickstart.

Additions
- Added example to serverside
```

# Design Philosophy

The modular design of Trinity is simple for the sake of being simple. I didn't want to bog down servers with thousands of network messages and stream hundreds of Lua files to clients. The entire goal is to be simple and sacrifice some of the security of the client side in the process.

Yes, you can indeed make bypasses to the client side fairly easily. The goal isn't to be unbypassable; it is to be a nuisance to cheaters and make the act of cheating boring and unfun.

Keep things simple and you'll have fewer add-on conflicts, fewer game mode conflicts, and less networking.

# Testing Requirements

All custom modules submitted via a pull request will be put in a testing mode temporarily where they do nothing but flag. The goal of this is to prevent unforeseen issues from occurring when updating versions. Ideally, server owners will submit issues when encountering false flags, and it can be ironed out before the next major update.