{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    ts-nix-numtide = {
      url = "github:numtide/tree-sitter-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      ts-nix-numtide,
    }:
    let
      inherit (nixpkgs) lib;

      forAllSystems =
        f: lib.genAttrs lib.systems.flakeExposed (system: f (import nixpkgs { inherit system; }));

      versionSuffix = self.shortRev or "unstable";
    in
    {
      packages = forAllSystems (pkgs: {
        default = self.packages.${pkgs.stdenv.hostPlatform.system}.newydd;
        newydd = pkgs.callPackage ./nix/package.nix { inherit versionSuffix ts-nix-numtide; };
        newyddNoLsp = pkgs.callPackage ./nix/package.nix {
          inherit versionSuffix ts-nix-numtide;
          bundleLSPs = false;
        };
      });

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
