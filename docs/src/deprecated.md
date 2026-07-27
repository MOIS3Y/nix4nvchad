# Removed features

This page documents removed features and their available migration paths.

## `homeManagerModule` attribute

The deprecated singular flake output
`inputs.nix4nvchad.homeManagerModule` has been removed. Use
`homeManagerModules.default` instead.

Before:

```nix
{ inputs, ... }: {
  imports = [ inputs.nix4nvchad.homeManagerModule ];

  programs.nvchad.enable = true;
}
```

After:

```nix
{ inputs, ... }: {
  imports = [ inputs.nix4nvchad.homeManagerModules.default ];

  programs.nvchad.enable = true;
}
```

## Intel macOS support

Official `x86_64-darwin` support has been removed from nix4nvchad.
Nixpkgs 26.05 is the last release to support Intel macOS. Nixpkgs
unstable removed the platform after the 26.05 branch was created, so it
can no longer be evaluated by nix4nvchad's unstable Nixpkgs input.

The change is documented in the
[nix-community announcement][announcement] and the corresponding
[upstream Nixpkgs commit][upstream].

The Home Manager module may still work as a best-effort workaround when
the user's configuration supplies `pkgs` from the final supported Nixpkgs
branch. This does not restore `x86_64-darwin` flake outputs and is not
tested by the project's CI.

[announcement]:
  https://github.com/orgs/nix-community/discussions/2195
[upstream]:
  https://github.com/NixOS/nixpkgs/commit/90796a2
