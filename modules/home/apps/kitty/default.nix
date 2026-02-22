{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.mine) user;
  cfg = config.mine.home-manager.apps.kitty;

  # Matches stylix kitty color config
  # https://github.com/nix-community/stylix/blob/master/modules/kitty/hm.nix
  mkKittyColors = scheme: ''
    background #${scheme.base00}
    foreground #${scheme.base05}
    selection_background #${scheme.base03}
    selection_foreground #${scheme.base05}

    cursor #${scheme.base05}
    cursor_text_color #${scheme.base00}

    url_color #${scheme.base04}

    active_border_color #${scheme.base03}
    inactive_border_color #${scheme.base01}

    wayland_titlebar_color #${scheme.base00}
    macos_titlebar_color #${scheme.base00}

    active_tab_background #${scheme.base00}
    active_tab_foreground #${scheme.base05}
    inactive_tab_background #${scheme.base01}
    inactive_tab_foreground #${scheme.base04}
    tab_bar_background #${scheme.base01}

    color0 #${scheme.base00}
    color1 #${scheme.base08}
    color2 #${scheme.base0B}
    color3 #${scheme.base0A}
    color4 #${scheme.base0D}
    color5 #${scheme.base0E}
    color6 #${scheme.base0C}
    color7 #${scheme.base05}

    color8 #${scheme.base02}
    color9 #${scheme.base08}
    color10 #${scheme.base0B}
    color11 #${scheme.base0A}
    color12 #${scheme.base0D}
    color13 #${scheme.base0E}
    color14 #${scheme.base0C}
    color15 #${scheme.base07}

    color16 #${scheme.base09}
    color17 #${scheme.base0F}
    color18 #${scheme.base01}
    color19 #${scheme.base02}
    color20 #${scheme.base04}
    color21 #${scheme.base06}
  '';

  darkColors = config.mine.system.stylix.darkBase16Scheme;
  lightColors = config.mine.system.stylix.lightBase16Scheme;
in {
  options.mine.home-manager.apps.kitty = {
    enable = lib.mkEnableOption "Enable kitty terminal emulator";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user.username} = {
      home.packages = with pkgs; [
        kitty
      ];

      stylix.targets.kitty.enable = false;

      programs.kitty = {
        enable = true;
        shellIntegration.enableZshIntegration = config.mine.home-manager.system.shell.zsh.enable;
        font = {
          inherit (config.stylix.fonts.monospace) package name;
          size = config.stylix.fonts.sizes.terminal;
        };
      };

      xdg.configFile."kitty/dark-theme.auto.conf".text = mkKittyColors darkColors;
      xdg.configFile."kitty/light-theme.auto.conf".text = mkKittyColors lightColors;
    };
  };
}
