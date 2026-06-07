{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    gift-wrap = {
      url = "github:tgirlcloud/gift-wrap";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      gift-wrap,
    }:
    let
      inherit (nixpkgs) lib;

      forAllSystems =
        f: lib.genAttrs lib.systems.flakeExposed (system: f (import nixpkgs { inherit system; }));

      versionSuffix = self.shortRev or "unstable";
    in
    {
      packages = forAllSystems (
        pkgs:
        let
          inherit (inputs.gift-wrap.legacyPackages.${pkgs.stdenv.hostPlatform.system}) wrapNeovim;
        in
        {
          default = self.packages.${pkgs.stdenv.hostPlatform.system}.newydd;
          newydd = pkgs.callPackage ./nix/package.nix { inherit wrapNeovim versionSuffix; };
          newyddNoLsp = pkgs.callPackage ./nix/package.nix {
            inherit wrapNeovim versionSuffix;
            bundleLSPs = false;
          };
        }
      );

      homeModules.default = import ./modules/home-manager.nix inputs;

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShellNoCC {
          packages = [
            pkgs.selene
            pkgs.stylua
            pkgs.lua-language-server
          ];
        };
      });
    };
}
