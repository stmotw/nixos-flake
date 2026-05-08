{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.mine) user;
  cfg = config.mine.home-manager.cli-tools.direnv;
in {
  options.mine.home-manager.cli-tools.direnv = {
    enable = lib.mkEnableOption "direnv configs";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user.username} = {
      home.packages = with pkgs; [
        direnv
      ];

      programs.direnv = {
        enable = true;
        enableZshIntegration = config.mine.home-manager.system.shell.zsh.enable;
        nix-direnv.enable = true;
      };
    };
  };
}
