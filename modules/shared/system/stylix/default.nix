{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mine.system.stylix;
in {
  options.mine.system.stylix = {
    enable = lib.mkEnableOption "stylix color scheme";
  };

  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;

      # Adaptation of VSCode's Dark Modern theme
      base16Scheme = {
        base00 = "1E1E1E";
        base01 = "181818";
        base02 = "252526";
        base03 = "3A3D41";
        base04 = "6B6B6B";
        base05 = "D4D4D4";
        base06 = "CCCCCC";
        base07 = "FFFFFF";
        base08 = "D16969";
        base09 = "CE9178";
        base0A = "DCDCAA";
        base0B = "608B4E";
        base0C = "4EC9B0";
        base0D = "569CD6";
        base0E = "C586C0";
        base0F = "D7BA7D";
      };

      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font Mono";
        };
      };
    };
  };
}
