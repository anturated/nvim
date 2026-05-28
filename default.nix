# WHAT IS THIS ABOMINATION
let
  lockfile = builtins.fromJSON (builtins.readFile ./flake.lock);
  node = lockfile.nodes.nixpkgs.locked;
  nixpkgs' = fetchTarball {
    url = "https://github.com/${node.owner}/${node.repo}/archive/${node.rev}.tar.gz";
    sha256 = node.narHash;
  };
in
{
  nixpkgs ? nixpkgs',
  pkgs ? import nixpkgs {
    inherit system;
  },
  lib ? pkgs.lib,
  system ? builtins.currentSystem,

  inputs,
  self ? inputs.self,
  newyddVersion ? self.shortRev or self.dirtyRev or "unknown",
}:

let
  inherit (inputs.gift-wrap.legacyPackages.${pkgs.stdenv.hostPlatform.system}) wrapNeovim;
in
lib.makeScope pkgs.newScope (self: {
  newydd = self.callPackage ./nix/package.nix { inherit newyddVersion wrapNeovim; };
})
