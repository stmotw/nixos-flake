{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mine.system.stylix;

  # Adaptation of VSCode's Dark Modern theme
  darkScheme = {
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

  lightScheme = {
    base00 = "F8F8F8";
    base01 = "E8E8E8";
    base02 = "D8D8D8";
    base03 = "B8B8B8";
    base04 = "585858";
    base05 = "383838";
    base06 = "282828";
    base07 = "181818";
    base08 = "AB4642";
    base09 = "DC9656";
    base0A = "F7CA88";
    base0B = "A1B56C";
    base0C = "86C1B9";
    base0D = "7CAFC2";
    base0E = "BA8BAF";
    base0F = "A16946";
  };
in {
  options.mine.system.stylix = {
    enable = lib.mkEnableOption "stylix color scheme";
    darkBase16Scheme = lib.mkOption {
      type = lib.types.attrs;
      default = darkScheme;
      description = "Dark base16 color scheme for apps supporting light/dark switching";
    };
    lightBase16Scheme = lib.mkOption {
      type = lib.types.attrs;
      default = lightScheme;
      description = "Light base16 color scheme for apps supporting light/dark switching";
    };
  };

  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;
      base16Scheme = darkScheme;

      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font Mono";
        };
      };
    };
  };
}
