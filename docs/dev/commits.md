# Introduction

This is a simple file outlining the commit etiquette. We follow the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) guidelines. This requirement isn't rigid but can be useful to describe what your commit is doing and is highly recommended.

## Prefix

* `feat:` - A new feature (adds functionality).
* `fix:` - A bug fix that changes behavior to correct something.
* `refactor:` - Code changes that neither fix a bug nor add a feature (internal restructuring).
* `chore:` - Maintenance task that doesn't affect logic (updating the docs tools, etc.)
* `docs:` - Documentation changes. Includes README and associated files.
* `style:` - Code style fixes, whitespace, etc.
* `perf:` - Performance improvements that don't affect logic.
* `revert:` - Undid a previous commit.

## Breaking Changes

These changes are changes that will affect the end user and require a full update in order to function (config changes, module system changes, etc.).

Include the `!` suffix at the end of your prefix (`feat!:`). Include the `BREAKING CHANGE` text in the summary body of the commit.