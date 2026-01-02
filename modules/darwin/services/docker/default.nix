{
  config,
  lib,
  ...
}: let
  cfg = config.mine.services.docker;
in {
  options.mine.services.docker = {
    enable = lib.mkEnableOption "Docker desktop";
  };

  config = lib.mkIf cfg.enable {
    homebrew.casks = ["docker-desktop"];
  };
}
