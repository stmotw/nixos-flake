{
  config,
  lib,
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
      programs.direnv = {
        enable = true;
        enableZshIntegration = config.mine.home-manager.system.shell.zsh.enable;
        nix-direnv.enable = true;
      };
    };
  };
}
