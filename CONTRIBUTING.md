# Introduction

This file gives some instructions and context on contributing to Trinity Anti-Cheat. Our hope is that reading this file will give you the necessary information to be able to contribute and potentially become a longer term contributor.

**Table Of Contents**:

1. [Licenses](#licenses)
2. [Purpose & Scope](#purpose--scope)
3. [Design Principles & Pitfalls](#design-principles--pitfalls)
4. [Contribution Types](#contribution-types)
    * [Features](#features)
    * [Bug Fixes](#bug-fixes)
    * [Performance Improvements](#performance-improvements)
    * [Security Improvements](#security-improvements)
    * [Documentation Improvements](#documentation-improvements)
5. [Development Expectations](#development-expectations)

## Licenses

We (ryanoutcome20 and other approved individuals) are currently licensed under the GNU General Public License v3.0 **with a “Commons Clause” License Condition v1.0** - this ensures not 
only the security of our code but also the insurance that it won't be resold and fabricated by malicious individuals.

You may not edit, adjust, or replace the license and license headers documented throughout the code. If you wish to create a fork of the software you must follow the GNU General Public License v3.0 conditions including, but not limited to:

* You must include the full GPLv3 license text and copyright notices with your distribution.
* You must provide the raw source code of your fork to anyone who receives the binary or obfuscated source code.
* You cannot relicense your fork under a different or more restrictive license.

## Purpose & Scope

Contributions are generally welcome but we have our scope of the project, we are an anti-cheat, nothing more - we are not a screengrab addon nor an anti-alt addon.

An anti-cheat is not the place for experimental features or rewrites, test your features before you make a pull request.

## Design Principles & Pitfalls

There are a couple of design principles that are considered a priority when developing for Trinity, here are a few of the highlights:

* **Simplicity**: Generally you want to keep every single function you write under twenty lines with a maximum of eighty lines for extremely complicated code.
* **Server Authority**: We keep as much as we can on the server as possible - this includes small things like processing data. It allows us to expand the config and prevent bypasses.
* **Backwards Compatibility**: Due to the modular nature of Trinity, you'll need to ensure other custom modules will function correctly ([see the debug module stubs we wrote for this](https://github.com/ryanoutcome20/Trinity-Anti-Cheat-Debug-Stub)).
* **Performance**: We take performance very seriously, do not attempt to push any changes that significantly slow down the server or especially the client.

There are also a couple of pitfalls that a lot of new developers will fall into:

* **External Code**: Rewrite any libraries you plan to use yourself. When we do add external modules, they require a discussion in the [issues tab of GitHub](https://github.com/ryanoutcome20/Trinity-Anti-Cheat/issues) and approval from the developer of that external library.
* **Addon Compatibility**: Consider how this game functions - it runs on addons. You are not allowed to break large swaths of addons for security improvements or detections. If we could do this, it would be great, but that's the trade-off we have with a public anti-cheat.
* **Obfuscation**: Under no circumstance will **ANY** obfuscated clientside or serverside code be approved. No exceptions.

## Contribution Types

### Features

If you'd like to contribute a feature, you must first open an [issue](https://github.com/ryanoutcome20/Trinity-Anti-Cheat/issues) on the GitHub page. If you can program and would like to contribute your feature, then you may also create a [pull request](https://github.com/ryanoutcome20/Trinity-Anti-Cheat/pulls) on the GitHub page.

### Bug Fixes

If you have found a bug then you may create an [issue](https://github.com/ryanoutcome20/Trinity-Anti-Cheat/issues) on the GitHub page. Further debugging may be required but if you've done some yourself, even tiny, you should post it along side your issue.

### Performance Improvements

These are more specific; it is highly recommended to only go for larger changes that will substantially affect the performance of the addon. You can, if you see it fit, create a large batch of performance improvements and send them all in as an [issue](https://github.com/ryanoutcome20/Trinity-Anti-Cheat/issues) and linked [pull request](https://github.com/ryanoutcome20/Trinity-Anti-Cheat/pulls). Please do not submit incorrect performance metrics - we will test them.

### Security Improvements

If you've found a bypass or security issue then you should go through the instructions in the [security policy](./SECURITY.md).

### Documentation Improvements

Simple documentation improvements can be submitted with or without an [issue](https://github.com/ryanoutcome20/Trinity-Anti-Cheat/issues). You may submit a raw [pull request](https://github.com/ryanoutcome20/Trinity-Anti-Cheat/pulls) for these; after being reviewed, your pull request will be merged.

## Development Expectations

There are a few expectations we expect you to follow if you want to contribute:

* Follow the [development coding style guide](./docs/dev/coding_style.md).
* No behavioral changes without documentation updates.
* Ensure client and server logic remain separated (remember, server authority).
* One issue per pull request; several commits may be required, but they should strive to solve one goal.