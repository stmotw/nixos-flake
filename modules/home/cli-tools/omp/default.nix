{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (config.mine) user;
  cfg = config.mine.home-manager.cli-tools.omp;
in {
  options.mine.home-manager.cli-tools.omp = {
    enable = lib.mkEnableOption "Enable omp coding agent";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user.username} = {
      home.packages = [
        inputs.omp.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };
  };
}
