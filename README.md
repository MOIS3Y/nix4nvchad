# nix4nvchad

**A seamless way to integrate NvChad, a blazing fast Neovim configuration, into your Nix setup.**

`nix4nvchad` provides a declarative, reproducible way to install and configure [NvChad](https://nvchad.com/) using Nix flakes. It safely manages NvChad's runtime state by automatically provisioning its configuration directory while keeping your system environment clean by injecting LSP servers and tools exclusively into the Neovim wrapper.

<div align="center">

[![Docs](https://img.shields.io/badge/docs-latest-blue?style=for-the-badge&labelColor=101418)](https://nix-community.github.io/nix4nvchad/)
![NixOS](https://img.shields.io/badge/NixOS-5277C3?style=for-the-badge&logo=nixos&logoColor=white&labelColor=101418)
![Neovim](https://img.shields.io/badge/Neovim-57A143?style=for-the-badge&logo=neovim&logoColor=white&labelColor=101418)
![Lua](https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white&labelColor=101418)
[![License](https://img.shields.io/badge/License-GPLv3-blue.svg?style=for-the-badge&labelColor=101418)](./LICENSE)

<br>

<img src="https://nvchad.com/screenshots/onedark.webp" width="80%" alt="NvChad Screenshot">

</div>

## Key Features

- **Home Manager Integration:** Easily configure NvChad using our provided Home Manager module.
- **Standalone Package:** Use it independently of Home Manager by overriding the Nix derivation directly.
- **Isolated Dependencies:** Manage your runtime dependencies (like LSP servers, formatters, and tools) in isolation. They are made available exclusively to NvChad without polluting your global `$PATH`.
- **Custom Starter:** Swap the default starter repository with your own fork to maintain pure, vanilla Lua configuration while leveraging Nix for dependencies.

## Quick Try

Want to see it in action without installing? You can run it directly:

```console
nix run github:nix-community/nix4nvchad
```

> [!NOTE]
> When NvChad needs to initialize `~/.config/nvim`, an existing directory
> is moved to a timestamped backup such as
> `~/.config/nvim_2026_07_27_14_30_00.bak`.

## Intel macOS

Official `x86_64-darwin` support was removed because Nixpkgs unstable no
longer supports Intel macOS. Nixpkgs 26.05 is the last release to support
the platform. The removal landed in an [upstream Nixpkgs commit][upstream]
and was followed by a [nix-community announcement][announcement].

Consequently, `x86_64-darwin` is not included in the officially tested
flake outputs. Commands such as the following are unsupported on Intel
Macs:

```console
nix run github:nix-community/nix4nvchad
```

As a best-effort workaround, the Home Manager module can still be used
with the last Nixpkgs branch that supports Intel macOS:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix4nvchad = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nix4nvchad,
      ...
    }:
    let
      system = "x86_64-darwin";

      pkgs = import nixpkgs {
        inherit system;
      };
    in
    {
      homeConfigurations.example = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          nix4nvchad.homeManagerModules.default

          {
            programs.nvchad.enable = true;
          }
        ];
      };
    };
}
```

This works because the module builds the package with the user's `pkgs`.
It does not add `packages.x86_64-darwin` or `apps.x86_64-darwin` to
nix4nvchad itself. This workaround is best effort and is not tested by
the project's CI.

[upstream]:
  https://github.com/NixOS/nixpkgs/commit/90796a2
[announcement]:
  https://github.com/orgs/nix-community/discussions/2195

## Usage Guide

Comprehensive guides on installation, configuration, and advanced usage are available in the official **[Documentation](https://nix-community.github.io/nix4nvchad/)**.

### Table of Contents
- [Installation](https://nix-community.github.io/nix4nvchad/installation.html)
- [Configuration Options](https://nix-community.github.io/nix4nvchad/configuration.html)
- [Advanced Usage](https://nix-community.github.io/nix4nvchad/advanced_usage.html)

## License

This project is licensed under the **GPL-3.0** License.
