inputs:
{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.newydd;

  pkgs' = import ../default.nix { inherit pkgs inputs; };
in
{
  options = {
    programs.newydd = {
      enable = lib.mkEnableOption "newydd";

      package = lib.mkPackageOption pkgs' "newydd" { };

      bundleLSPs = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to bundle basic LSPs.";
      };

      packageOverrides = lib.mkOption {
        type = lib.types.lazyAttrsOf lib.types.anything;
        default = { };
        description = "Arguments to add to the package override";
        example = lib.literalExpression ''
          {
            nil = pkgs.nil.override { nix = pkgs.lix; };
          }
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.newydd = {
      package = pkgs'.newydd.override (
        {
          inherit (cfg) bundleLSPs;
        }
        // cfg.packageOverrides
      );
    };

    home.packages = [ cfg.package ];
  };
}
