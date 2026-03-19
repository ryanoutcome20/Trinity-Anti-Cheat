<div align="center">
  <img width="256" height="256" alt="GitHub Icon" src="https://github.com/user-attachments/assets/3a73664a-c4ba-4728-a113-b3d1c1267ce5" />

  Trinity Anti-Cheat
  <hr>
  
  <img alt="GitHub commit activity" src="https://img.shields.io/github/commit-activity/m/ryanoutcome20/Trinity-Anti-Cheat/dev?style=plastic&color=blue&logo=github">
  <a href="https://discord.gg/Brdm4tFG9K"><img alt="Discord" src="https://img.shields.io/discord/1410210633302937622?style=plastic&color=blue&labelColor=grey&label=Discord&logo=discord"></a>
  <img alt="Version 0.3" src="https://img.shields.io/badge/Version-0.3.1-blue?style=plastic&logo=lua">
  
  <hr>
</div>

Trinity Anti-Cheat is a complete anti-cheat solution for Garry's Mod. Its architecture is built with modularity, performance, and security in mind. It also supports installation along side various popular anti-cheats including QAC, MAC (and TTT forks like [Velkon](https://github.com/colemclaren/ttt)), and SimpLAC.

**Notable *unique* features include**:

* [PVS Anti-ESP serverside system](https://www.youtube.com/watch?v=Nwy0jQc8S4Y)
* [Anti-Aimbot interpolated serverside system](https://www.youtube.com/watch?v=xNqrlCG11Ws)
* Anti-ESP clientside system (Anti C++)
* Anti-File Stealer systems
* Anti-Nospread systems

**Table Of Contents**:

1. [Installation](#installation)
2. [Configuration](#configuration)
3. [Help & Issues](#help--issues)
4. [Links](#links)
5. [Credits](#credits)
6. [License](#license)

## Installation

Installation is very simple:

* Download the anti-cheat from the [releases](https://github.com/ryanoutcome20/Trinity-Anti-Cheat/releases) section on GitHub.
* Install the anti-cheat to the directory: `GarrysMod\garrysmod\addons\`.

You should check the [known addon incompatibility list](./docs/user/compatibility.md) before installation!
You should also read the [documentation](./docs) and [wiki](https://github.com/ryanoutcome20/Trinity-Anti-Cheat/wiki) for guidance.

## Configuration

Configuration is also simple but can be challenging depending on how deep you'd like to go:

* Navigate to the directory `Trinity-Anti-Cheat\lua\tac\config\`.
* Choose to either configure the clientside (`clientside.lua`) or serverside (`serverside.lua`).

You should follow the tips inside of the configuration files and consult the extensive [configuration documentation](./docs/user/configuring.md) during configuration.

If there is a specific feature that confuses you, then you should consult the [wiki](https://github.com/ryanoutcome20/Trinity-Anti-Cheat/wiki).

## Help & Issues

If you experience any issues you should consult the [troubleshooting documentation](./docs/user/troubleshooting.md) first before opening an issue on GitHub. Questions **are** welcome on the GitHub issue tracker.

## Links

###### Download
* [Releases](https://github.com/ryanoutcome20/Trinity-Anti-Cheat/releases)
* [Development Branch](https://github.com/ryanoutcome20/Trinity-Anti-Cheat/tree/dev)

###### Support and Documentation
* [Issues/Tickets](https://github.com/ryanoutcome20/Trinity-Anti-Cheat/issues)
* [Wiki](https://github.com/ryanoutcome20/Trinity-Anti-Cheat/wiki)
* [Troubleshooting Guide](./docs/user/troubleshooting.md)
* [Configuring Guide](./docs/user/configuring.md)
* [Addon Compatibility List](./docs/user/compatibility.md)

###### For Developers
* [License (GNU v3.0 w/ “Commons Clause”)](https://github.com/ryanoutcome20/Trinity-Anti-Cheat/blob/main/LICENSE)
* [API](./lua/tac/api.lua)
* [Contribute](./CONTRIBUTING.md)
* [Debug Stubs](https://github.com/ryanoutcome20/Trinity-Anti-Cheat-Debug-Stub)

## Credits

* Srlion - The SFS serialization library.
* Vectivus - The print library.
* Wholecream - Providing some detection ideas.
* Matthew B. (HeX) - Providing the biggest source of motivation to finish this project and awesome detection resources for when I'm out of ideas. 

## License

This project is licensed under the GNU General Public License v3.0 **with a “Commons Clause” License Condition v1.0** - see the [LICENSE](https://github.com/ryanoutcome20/Trinity-Anti-Cheat/blob/main/LICENSE) file for more details. See also the [contributing](./CONTRIBUTING.md) documentation for developer instructions.
