inputs:
{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.programs.newydd;
  pkgs' = inputs.self.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  options = {
    programs.newydd = {
      enable = lib.mkEnableOption "newydd";

      package = lib.mkOption {
        type = lib.types.package;
        inherit (pkgs') default;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
