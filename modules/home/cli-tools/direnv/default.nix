{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (config.mine) user;
  cfg = config.mine.home-manager.cli-tools.direnv;
  pinnedDirenv = inputs.nixpkgs-direnv-pin.legacyPackages.${pkgs.stdenv.hostPlatform.system}.direnv;
in {
  options.mine.home-manager.cli-tools.direnv = {
    enable = lib.mkEnableOption "direnv configs";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user.username} = {
      home.packages = [pinnedDirenv];

      programs.direnv = {
        enable = true;
        package = pinnedDirenv;
        enableZshIntegration = config.mine.home-manager.system.shell.zsh.enable;
        nix-direnv.enable = true;
      };
    };
  };
}
