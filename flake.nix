{
  description = ''
    NvChad is Blazing fast Neovim config
    providing solid defaults and a beautiful UI https://nvchad.com/
    This home manager module will add NvChad configuration to your Nix setup
    You can specify in the configuration your own extended configuration
    built on the starter repository
    You can also add runtime dependencies that will be isolated from the main
    system but available to NvChad. This is useful for adding lsp servers.
    If you are using your own Neovim build and not from nixpkgs
    you can also specify your package.
    In addition, you can continue to configure NvChad in the usual way
    manually by disabling the hm-activation option
  '';

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nvchad-starter = {
      url = "github:NvChad/starter/main";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nvchad-starter,
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgsFor = forAllSystems (
        system:
        import nixpkgs {
          inherit system;
        }
      );
    in
    {
      packages = forAllSystems (
        system:
        let
          nvchadPackage = pkgsFor.${system}.callPackage ./nix/nvchad.nix {
            starterRepo = nvchad-starter;
          };
        in
        {
          nvchad = nvchadPackage;
          default = nvchadPackage;
        }
      );

      apps = forAllSystems (
        system:
        let
          package = self.packages.${system}.nvchad;
          nvchadApp = {
            type = "app";
            program = "${package}/bin/nvim";
            meta = package.meta;
          };
        in
        {
          nvchad = nvchadApp;
          default = nvchadApp;
        }
      );

      checks = self.packages;

      devShells = forAllSystems (system: {
        default = pkgsFor.${system}.mkShell {
          buildInputs = [ pkgsFor.${system}.mdbook ];
        };
      });

      homeManagerModules =
        let
          nvchadModule = import ./nix/module.nix {
            starterRepo = nvchad-starter;
          };
        in
        {
          nvchad = nvchadModule;
          default = nvchadModule;
        };

      # DEPRECATED: This attribute will be removed soon.
      # Use homeManagerModules.default instead.
      homeManagerModule = self.homeManagerModules.nvchad;
    };
}
