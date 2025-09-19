{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mine.system.fonts;
in {
  options.mine.system.fonts = {
    enable = lib.mkEnableOption "Enable fonts";
  };

  config = lib.mkIf cfg.enable {
    fonts.packages = with pkgs; [
      fira-code
      nerd-fonts.fira-mono
    ];
  };
}
