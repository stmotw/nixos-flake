{
  config,
  lib,
  ...
}: let
  inherit (config.mine) user;
  cfg = config.mine.home-manager.cli-tools.docker;
in {
  options.mine.home-manager.cli-tools.docker = {
    enable = lib.mkEnableOption "docker ZSH completions";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user.username} = {
      programs.zsh.initContent = lib.mkIf config.mine.home-manager.system.shell.zsh.enable ''
        if command -v docker &>/dev/null; then
          eval "$(docker completion zsh)"
        fi
      '';
    };
  };
}
