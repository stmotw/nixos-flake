{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.mine) user;
  cfg = config.mine.home-manager.cli-tools.eza;

  darkColors = config.mine.system.stylix.darkBase16Scheme;
  lightColors = config.mine.system.stylix.lightBase16Scheme;

  # TODO: migrate to stylix when support is ready:
  # https://github.com/nix-community/stylix/issues/545
  mkEzaTheme = scheme: {
    filekinds = {
      normal.foreground = "#${scheme.base07}";
      directory.foreground = "#${scheme.base0D}";
      symlink.foreground = "#${scheme.base05}";
      pipe.foreground = "#${scheme.base06}";
      block_device.foreground = "#${scheme.base0B}";
      char_device.foreground = "#${scheme.base0A}";
      socket.foreground = "#${scheme.base03}";
      special.foreground = "#${scheme.base0E}";
      executable.foreground = "#${scheme.base0B}";
      mount_point.foreground = "#${scheme.base04}";
    };
    perms = {
      user_read.foreground = "#${scheme.base0D}";
      user_write.foreground = "#${scheme.base07}";
      user_execute_file.foreground = "#${scheme.base0B}";
      user_execute_other.foreground = "#${scheme.base0B}";
      group_read.foreground = "#${scheme.base0D}";
      group_write.foreground = "#${scheme.base07}";
      group_execute.foreground = "#${scheme.base0B}";
      other_read.foreground = "#${scheme.base0D}";
      other_write.foreground = "#${scheme.base07}";
      other_execute.foreground = "#${scheme.base0B}";
      special_user_file.foreground = "#${scheme.base0E}";
      special_other.foreground = "#${scheme.base04}";
      attribute.foreground = "#${scheme.base06}";
    };
    size = {
      major.foreground = "#${scheme.base06}";
      minor.foreground = "#${scheme.base0D}";
      number_byte.foreground = "#${scheme.base06}";
      number_kilo.foreground = "#${scheme.base05}";
      number_mega.foreground = "#${scheme.base0C}";
      number_giga.foreground = "#${scheme.base0A}";
      number_huge.foreground = "#${scheme.base08}";
      unit_byte.foreground = "#${scheme.base06}";
      unit_kilo.foreground = "#${scheme.base0C}";
      unit_mega.foreground = "#${scheme.base0A}";
      unit_giga.foreground = "#${scheme.base0A}";
      unit_huge.foreground = "#${scheme.base08}";
    };
    users = {
      user_you.foreground = "#${scheme.base0A}";
      user_root.foreground = "#${scheme.base08}";
      user_other.foreground = "#${scheme.base0E}";
      group_yours.foreground = "#${scheme.base05}";
      group_other.foreground = "#${scheme.base03}";
      group_root.foreground = "#${scheme.base08}";
    };
    links = {
      normal.foreground = "#${scheme.base0D}";
      multi_link_file.foreground = "#${scheme.base0C}";
    };
    git = {
      new.foreground = "#${scheme.base0B}";
      modified.foreground = "#${scheme.base0A}";
      deleted.foreground = "#${scheme.base08}";
      renamed.foreground = "#${scheme.base0C}";
      typechange.foreground = "#${scheme.base0E}";
      ignored.foreground = "#${scheme.base03}";
      conflicted.foreground = "#${scheme.base0B}";
    };
    punctuation.foreground = "#${scheme.base0C}";
  };

  mkEzaConfig = scheme: (pkgs.formats.yaml {}).generate "theme.yml" (mkEzaTheme scheme);
in {
  options.mine.home-manager.cli-tools.eza = {
    enable = lib.mkEnableOption "eza configs";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user.username} = {
      home.packages = with pkgs; [
        eza
      ];

      # https://github.com/eza-community/eza/issues/1224
      # On macOS, eza looks for theme.yml in ~/Library/Application Support/eza by default
      # Set environment variable to use XDG config location
      home.sessionVariables = lib.mkIf pkgs.stdenv.isDarwin {
        EZA_CONFIG_DIR = "\${HOME}/.config/eza";
      };

      programs.eza = {
        enable = true;
        enableZshIntegration = config.mine.home-manager.system.shell.zsh.enable;

        colors = "auto";
      };

      xdg.configFile."eza/theme-dark.yml".source = mkEzaConfig darkColors;
      xdg.configFile."eza/theme-light.yml".source = mkEzaConfig lightColors;

      programs.zsh.initContent = lib.mkIf config.mine.home-manager.system.shell.zsh.enable (
        if pkgs.stdenv.isDarwin
        then ''
          function _eza_theme_precmd() {
            if defaults read -g AppleInterfaceStyle &>/dev/null 2>&1; then
              ln -sf "$HOME/.config/eza/theme-dark.yml" "$HOME/.config/eza/theme.yml"
            else
              ln -sf "$HOME/.config/eza/theme-light.yml" "$HOME/.config/eza/theme.yml"
            fi
          }
          precmd_functions+=(_eza_theme_precmd)
        ''
        else ''
          ln -sf "$HOME/.config/eza/theme-dark.yml" "$HOME/.config/eza/theme.yml"
        ''
      );
    };
  };
}
