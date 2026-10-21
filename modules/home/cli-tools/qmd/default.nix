{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (config.mine) user;
  cfg = config.mine.home-manager.cli-tools.qmd;
in {
  options.mine.home-manager.cli-tools.qmd = {
    enable = lib.mkEnableOption "Enable qmd, local search index over markdown";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user.username} = {
      home.packages = [
        inputs.qmd.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };
  };
}
