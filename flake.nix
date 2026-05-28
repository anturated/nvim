{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

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

      # do this bs so we have nix run .
      mkPackages =
        default: pkgs:
        let
          generatedPackages = import ./default.nix { inherit pkgs inputs; };
          defaultPackage = lib.optionalAttrs default { default = generatedPackages.newydd; };
        in
        generatedPackages // defaultPackage;
    in
    {
      legacyPackages = forAllSystems (mkPackages true);
      packages = forAllSystems (mkPackages true);

      # homeModules.default = import ./modules/home-manager.nix inputs;

      overlays.default = _: mkPackages false;
    };
}
