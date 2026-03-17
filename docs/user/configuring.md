# Introduction

Configuring the serverside & clientside can be a pain depending on how you have set up your other addons, various issues can pop up due to addon selections (see the [known addon incompatibility list](./compatibility.md) file), including false positives, false negatives, and random Lua errors. This guide will hopefully assist you in configuring both the clientside & serverside components.

- [Serverside Guide](#serverside-guide)
    - [Interpolated Strings](#interpolated-strings)
    - [Flags / Punishment Stubs](#flags--punishment-stubs)
    - [Flag / Punishment Stubs Static Variables](#flag--punishment-stubs-static-variables)
- [Clientside Guide](#clientside-guide)
    - [Batches](#batches)

## Serverside Guide

### Interpolated Strings

At the top of the serverside config file you'll notice some "interpolated strings"

```
Default Player Strings:
{Name} - Name
{SteamID64} - SteamID (64)
{SteamID} - SteamID
{IP} - IP
{Ping} - Ping
{Loss} - Packet loss
{Position} - Position (x y z)
{Angle} - Angle (x y r)

Default Token Strings:
{Info} - Punishment reason
{ID} - Punishment ID (PID)

Flags Specific Strings:
{Flags} - Flag total amount

Delayed Punishment Specific Strings:
{Timer} - How long until the delay is over

Default Global Strings:
{Contact} - Contact (Config.Contact)
{Map} - Map
{Gamemode} - Gamemode
```

These strings are format strings used by various systems to allow you to add unique dynamic variables to strings:

```
{Name} [{SteamID64}] was logged for \"{Info}\" ({ID})! P:{Position} A:{Angle}
```

```
nullptr* [76561199623856937] was logged for "Bad Module [exists; name: proxi] [CL]" (Binaries)! P:-1311.389282 -224.098999 114.052940 A:4.784 -153.864 0.000 [dbg]
```

The debug message is applied with TAC.Debug being enabled, see this [GitHub](https://github.com/ryanoutcome20/Trinity-Anti-Cheat-Debug-Stub).

### Flags / Punishment Stubs

Flags are (more than likely) the most common type of configuration object you'll interact with. Flags all derive their default values from the "Fallback" stub.

```
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
})
```

When creating a flag, it will inherit all of those variables into its own table. For example, if you wanted to change just the alerts evaluate type, you'd do:

```
pStub.Register("Example", {
    Alerts = {
        Evaluate = ALERT_EVERYONE
    }
})
```

And it'd apply it to just the evaluate variable within alerts while keeping all of the variables assigned in the fallback table (the example's Name variable would still be "Fallback").

### Flag / Punishment Stubs Static Variables

You'll notice some static variables being assigned to things (ALERT_EVERYONE, ALERT_NONE, PUNISHMENT_LOG, etc.); these are what are called "enums." Enums (or enumerations) are a simple way of assigning a numbered ID to a type without having to remember the number for each of the options (ALERT_EVERYONE is easier to remember than 2).

```
ALERT_NONE - Don't alert anyone
ALERT_STAFF - Alert only staff (see Config.Staff)
ALERT_EVERYONE - Alert everyone
```

```
PUNISHMENT_LOG - Only log to file, database, & alerts
PUNISHMENT_KICK - Kick and log
PUNISHMENT_BAN - Ban and log
```

There are more enums than this, but you won't run into them when dealing with the config.

## Clientside Guide

#### **WARNING**

The clientside configuration is considered a "debug" config, subject to change, and may cause false flags depending on what variables you set. Do not edit the clientside config unless you know for sure what you're doing!

Most of the info you need on what each config section does is in the config file itself; good luck.

### Batches

The clientside uses a "batch" system to transfer its information to the serverside. It does this to avoid the 64 KB size limitation that Source Engine single network channels suffer from. See the warning on [this page](https://wiki.facepunch.com/gmod/net.SendToServer).

Yes, we do use [Atlas](https://github.com/ryanoutcome20/Atlas) and [SFS](https://github.com/Srlion/sfs/tree/master) to prevent size issues as much as possible, but the practical size limitation of transfer is roughly 32 KBs, and we have to transfer loads of function information to the server for security purposes.

"Process Time" is the time between each process of the batches. "Batch" is the total size of a single batch (do not exceed 32 KB; in a sustained constant transfer rate, it'll eventually overload the net channel, and the game engine will time you out).

