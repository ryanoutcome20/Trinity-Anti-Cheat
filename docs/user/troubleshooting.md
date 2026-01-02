# Introduction

If you're having issues with **Trinity**, it is likely to be caused by one of the following:

1. [Gamemode Incompatibility](#gamemode-incompatibility)
2. [Addon Incompatibility](#addon-incompatibility)
3. [Game Updates](#game-updates)

This guide will help you in deciding which one of these has occurred and hopefully will give you some insight into how to fix the issues. As always, if you still cannot figure it out on your own, we'd be happy to help if you would submit an issue on [GitHub](https://github.com/ryanoutcome20/Trinity-Anti-Cheat/issues).

## Gamemode Incompatibility

If you can confirm one of the following, it is likely you are dealing with a gamemode incompatibility bug:

- Broken playermodels (specifically [statue/default playermodel](https://steamcommunity.com/sharedfiles/filedetails/?id=2297936227))
- Broken spawn positions
- Engine or gamemode errors on server startup
- Gamemode errors on server startup or player join
- Player crashes (specifically [`gamemode table doesn't exist`](https://www.reddit.com/r/gmod/comments/xrtzq7/gamemode_libary_is_not_a_table_make_sure_addon_is/), [`out of memory`](https://images.steamusercontent.com/ugc/857227537368119246/697388C1D65B5F183E88C14BCE0C4AB814A16FAF/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false), or `registry` crash popups)

Some of these are matching with [addon incompatibility](#addon-incompatibility), it can be hard to tell! You should probably disable suspicious addons or play on sandbox to confirm that it is truly a gamemode bug.

## Addon Incompatibility

If you can confirm one of the following, it is likely you are dealing with an addon incompatibility bug:

- Broken on specific SWEP or when using specific SENT (vehicle, entity, etc)
- Broken on specific action (F4 menu, running command, etc)
- Errors from (or in the stack tree of) an addon

These are not guarantees of addon incompatibility - most of these can be caused by detours or similar strange addon behavior. See the [known addon incompatibility list](./compatibility.md) for known addon bugs (**before you submit a new issue**), submit new ones through an issue on [GitHub](https://github.com/ryanoutcome20/Trinity-Anti-Cheat/issues).

## Game Updates

Ah yes, the bane of any competent developer's existence on this game. Rubat ([the only active Garry's Mod developer](https://facepunch.com/team)) generally has a pretty good grasp on how to break things people enjoy. 

We cannot predict the future, and if you cannot fix a bug on your own by tweaking settings (especially if the game just updated or shadow updated), then submit an issue on [GitHub](https://github.com/ryanoutcome20/Trinity-Anti-Cheat/issues). If the bug is reproducible, expect it to be fixed within hours.