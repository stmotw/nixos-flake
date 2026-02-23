{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mine.system.stylix;

  # Adaptation of VSCode's Default Dark+ theme
  darkScheme = {
    base00 = "1E1E1E"; # Editor background
    base01 = "252526"; # Sidebar, menus, tab bar
    base02 = "3A3D41"; # Selection, line highlighting
    base03 = "6A6A6A"; # Comments, line numbers
    base04 = "858585"; # Dark foreground
    base05 = "D4D4D4"; # Editor foreground
    base06 = "E8E8E8"; # Light foreground
    base07 = "FFFFFF"; # Lightest foreground
    base08 = "D16969"; # Red (regexp)
    base09 = "CE9178"; # Orange (strings)
    base0A = "DCDCAA"; # Yellow (functions)
    base0B = "6A9955"; # Green (comments)
    base0C = "4EC9B0"; # Cyan (types)
    base0D = "569CD6"; # Blue (keywords)
    base0E = "C586C0"; # Purple (control flow)
    base0F = "D7BA7D"; # Brown (escape chars)
  };

  # Adaptation of VSCode's Default Light+ theme
  lightScheme = {
    base00 = "FFFFFF"; # Editor background
    base01 = "F3F3F3"; # Sidebar, widget backgrounds
    base02 = "E0E0E0"; # Selection, borders
    base03 = "A0A0A0"; # Comments, muted foreground
    base04 = "6F6F6F"; # Dark foreground
    base05 = "383838"; # Editor foreground
    base06 = "1A1A1A"; # Darker foreground
    base07 = "000000"; # Darkest foreground
    base08 = "CD3131"; # Red (errors)
    base09 = "A31515"; # Dark red (strings)
    base0A = "795E26"; # Brown (functions)
    base0B = "008000"; # Green (comments)
    base0C = "267F99"; # Teal (types)
    base0D = "0451A5"; # Blue (properties, JSON keys)
    base0E = "AF00DB"; # Purple (keywords)
    base0F = "800000"; # Maroon (HTML tags)
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
    wallpaper = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Wallpaper image (use a dynamic .heic for macOS light/dark switching)";
    };
  };

  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;
      image = lib.mkIf (cfg.wallpaper != null) cfg.wallpaper;
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
