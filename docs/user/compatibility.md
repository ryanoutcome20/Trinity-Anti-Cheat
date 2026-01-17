# Introduction

Check if your addons are in the list before posting an issue!

Some of these are just **warnings**, they still function if cared for.

- [Aimbot SWEPs](#aimbot-sweps)
- [Darken217's SciFi Weapons](#darken217s-scifi-weapons)
- [Modern Warfare Base & SWEPs](#modern-warfare-base--sweps)
- [TFA AT Rust](#tfa-at-rust)
- [ARC9](#arc9)
- [SwiftAC](#swiftac)
- [Leys Serverside AntiCheat (LSAC)](#leys-serverside-anticheat-lsac)
- [Chronon Anti-Cheat](#chronon-anti-cheat-ai)

This list is subject to change! It is not exhaustive!

## Aimbot SWEPs

[Back](#introduction)

[Link](https://steamcommunity.com/workshop/browse/?appid=4000&searchtext=Aimbot)

- Incompatible with nearly all Aimbot checks serverside and clientside
    - Issue: Its... an aimbot?
    - Fix: Blacklist these SWEPs in the central flag config or don't use them.

## Darken217's SciFi Weapons

[Back](#introduction)

[Link](https://steamcommunity.com/sharedfiles/filedetails/?id=420970650)

- Incompatible with the Angles check serverside
    - Issue: Some weapons in this pack apply linear viewpunch which over extends the games default angle limit in pitch, very rare though.
    - Fix: Either use Accurate Angles, blacklist these SWEPs in the central flag config, use high flag based banning, or raise the pitch (X) angle limit to above 120.

## Modern Warfare Base & SWEPs

[Back](#introduction)

[Link](https://steamcommunity.com/sharedfiles/filedetails/?id=2459720887)
[Collection](https://steamcommunity.com/workshop/filedetails/?id=2526457139)

- Incompatible with the Angles check serverside
    - Issue: Very rarely will exceed the maximum pitch of the view angle check during recoil.
    - Fix: Either use Accurate Angles, blacklist these SWEPs in the central flag config, use high flag based banning, or raise the pitch (X) angle limit to above 120.

- Incompatible with the ESP Breaker clientside
    - Issue: Breaks scopes due to render target collision.
    - Fix: Don't use the ESP Breaker, you can perhaps change the ESP breaker hook and adjust its render order if you feel so inclined.

## TFA AT Rust

[Back](#introduction)

[Link](https://steamcommunity.com/sharedfiles/filedetails/?id=2529785777)
[Collection](https://steamcommunity.com/workshop/filedetails/?id=2950916542)

- Incompatible with the Angles check serverside
    - Issue: Regularly goes above normal angle limits during recoil.
    - Fix: Either use Accurate Angles, blacklist these SWEPs in the central flag config, or raise the pitch (X) angle limit to above 120.

## ARC9

[Back](#introduction)

[Link](https://steamcommunity.com/workshop/filedetails/?id=2910505837)

- Incompatible with the ESP Breaker clientside
    - Issue: Breaks scopes due to render target collision. Also very laggy.
    - Fix: Don't use the ESP Breaker, you can perhaps change the ESP breaker hook and adjust its render order if you feel so inclined.

## SwiftAC

[Back](#introduction)

[Link](https://www.gmodstore.com/market/view/swiftac-clientside-anticheat-against-lua-cheats)
[Archive](https://archive.org/details/anti-cheats.7z)

- Incompatible with the clientside anti-cheat components
    - Issue: SwiftAC will flag Trinity as a cheat and ban you.
    - Fix: Either modify it to whitelist Trinity or don't use it. Its also possible that Trinity would flag SwiftAC but its unlikely (if you find this bug, submit it).

## Leys Serverside AntiCheat (LSAC)

[Back](#introduction)

[Link](https://www.gmodstore.com/market/view/lsac-the-best-serverside-anti-cheat)

- Incompatible with the serverside anti-cheat components
    - Issue: Trinity causes issues with the DRM, performance is also heavily impacted.
    - Fix: Don't use LSAC - its bad and overpriced.

- Incompatible with the clientside anti-cheat components
    - Issue: Menu will be flagged as foreign Lua source because of DRM.
    - Fix: Don't use LSAC - its bad and overpriced.

- Incompatible with PVS
    - Issue: LSAC contains its own PVS module which causes issues with ours.
    - Fix: Turn it off on Trinity; LSAC doesn't fully fix it when you disable it.

## Chronon Anti-Cheat (AI)

[Back](#introduction)

[Link](https://chrononlabs.net/)
[Archive](https://archive.org/details/chronon-anti-cheat)

- Incompatible with the serverside anti-cheat components
    - Issue: Trinity causes issues with the ""AI"" (so does existing, don't blame us for that).
    - Fix: Don't use Chronon - its bad and overpriced.