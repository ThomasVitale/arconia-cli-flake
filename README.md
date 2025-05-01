# Arconia CLI - Nix Flake

A [Nix Flake](https://nixos.wiki/wiki/flakes) to install the [Arconia CLI](https://arconia.io/docs/arconia-cli/latest/index.html) in your Nix-based environment.

## How to use it

### Flox

Using [Flox](https://flox.dev), you can install the Arconia CLI in your development environment as follows:

```shell
flox install github:thomasvitale/arconia-cli-flake
```

## How to build it

Using [nix], you can build the flake and generate a lock file. Whenever the flake is updated with a new version of Arconia CLI, this command needs to be run again.

```shell
nix build --extra-experimental-features flakes --extra-experimental-features nix-command
```
