{
  lib,
  config,
  sec,
  ...
}: let
  cfg = config.mine.user.shell.starship;
in {
  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;
    };
  };
}
